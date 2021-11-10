## 索引和汇总 {#sec:index and summarize}

让我们回到之前定义过的例子grades_2020()：

```jl
sco("grades_2020()"; process=without_caption_label)
```

我们可以使用（操作符）“.”访问DataFrame，获取由（表中）名字组成的向量，如同我们此前在@sec:julia_basics使用结构体一样：

```jl
@sco JDS.names_grades1()
```

或者，我们可以更像使用数组一样，用符号标识（Symbols）或特殊字符对DataFrame进行索引。
**第二个索引是列索引：**

```jl
@sco JDS.names_grades2()
```

“df.name”与“df[!, :name]”完全相同，你可以像下面这样操作来自行验证：

```
julia> df = DataFrame(id=[1]);

julia> @edit df.name
```

两个例子中，都给出了“名字”列。
还有df[:, :name]，它拷贝了“名字”列。
大多情况下，使用df[!, :name]是最好的选择，因为它更加通用而且采用“就地修改”的方式。

对任意某行，比如第二行，我们可以使用**第一个索引作为行索引**：

```jl
s = """
    df = grades_2020()
    df[2, :]
    df = DataFrame(df[2, :]) # hide
    """
sco(s; process=without_caption_label)
```

或者生成一个函数，来提供给我们任何想要的行“i”：

```jl
@sco process=without_caption_label JDS.grade_2020(2)
```

我们还可以通过使用切片，只获取前两行的名字（这又与数组类似）：

```jl
@sco JDS.grades_indexing(grades_2020())
```

如果我们假定表中的名字都是独一无二的，我们可以写出一个函数，通过每个人的名字来获取此人的等级。
为了这样做，我们将表转换回到Julia的能够生成映射的基本数据结构之一———字典：

```jl
@sco post=output_block grade_2020("Bob")
```

字典如同zipper的zip循环一样，可以同时遍历df.name和df.grade_2020：

```jl
sco("""
df = grades_2020()
collect(zip(df.name, df.grade_2020))
""")
```

但是，仅当表中的各元素是独一无二时，将DataFrame转换为字典才有用。
通常情况，表中的元素并非独一无二，这也是为什么我们需要学习如何对DataFrame进行筛选的原因。

## 筛选和子集 {#sec:filter_subset}

有两种方式可以将行从DataFrame中移除。一种方式是“筛选”，而另一种是使用“子集”。
“筛选”早期就已加入进DataFrames.jl，功能更强，与Julia Base的语法也更一致，因此我们首先讨论“筛选”。“子集”比较新，而且通常更方便易用。

### 筛选 {#sec:filter}

从现在起，我们开始深入到DataFrames.jl更强大的特性中了。
为此，我们需要学习一些函数，比如“选取”和“筛选”。
但无需过虑。
要知道，DataFrames.jl的设计目标，就是将使用者需要学习的函数数量保持在一个最低限度。了解了这点，是不是会让你放轻松些？

[^verbs]: According to Bogumił Kamiński (lead developer and maintainer of `DataFrames.jl`) on Discourse (<https://discourse.julialang.org/t/pull-dataframes-columns-to-the-front/60327/5>).

如前，我们仍然从grades_2020开始：

```jl
sco("grades_2020()"; process=without_caption_label)
```

我们可以使用filter(source => f::Function, df)来对行进行筛选。
该函数与Julia Base模块中的filter(f::Function, V::Vector)非常相似。
这是因为DataFrames.jl使用多重分派来定义筛选的一个新方法，这个方法可以接受DataFrame作为一个参数。


乍一看，在实践中定义及使用一个筛选函数有些难。
但不要放弃，这个付出会得到很好的回报，因为它是筛选数据非常有力的方法。
简单举例，我们可以生成一个函数equals_alice，来检查是否输入为"Alice"：

```jl
@sco post=output_block JDS.equals_alice("Bob")
```

```jl
sco("equals_alice(\"Alice\")"; post=output_block)
```

“装备”了这样一个函数，我们可以使用它来筛选出所有名字为“Alice”的行：

```jl
s = "filter(:name => equals_alice, grades_2020())"
sco(s; process=without_caption_label)
```

这个筛选函数不仅仅可以用于DataFrames，也可以用于向量：

```jl
s = """filter(equals_alice, ["Alice", "Bob", "Dave"])"""
sco(s)
```

通过使用匿名函数，我们可以使筛选函数更简洁一些：

```jl
s = """filter(n -> n == "Alice", ["Alice", "Bob", "Dave"])"""
sco(s)
```

同样可以将其用于grades_2020：

```jl
s = """filter(:name => n -> n == "Alice", grades_2020())"""
sco(s; process=without_caption_label)
```

简要概括，该函数调用，可以看作“对名字列中的每个元素——让我们称其为元素n——检查n是否为Alice”。
对有些人来说，这仍然过于冗长。
幸运的是，Julia为“==”增加了一个偏函数（partial function）。
具体细节不很重要——只要知道你可以像使用其它函数一样使用它就可以了：

```jl
sco("""
s = "This is here to workaround a bug in books" # hide
filter(:name => ==("Alice"), grades_2020())
"""; process=without_caption_label)
```

如要获取所有不等于Alice的行，在此前的所有例子中，可以将== (等于)替换为!= (不等于)：

```jl
s = """filter(:name => !=("Alice"), grades_2020())"""
sco(s; process=without_caption_label)
```

现在来演示为何匿名函数如此强大，我们可以使用一个略微复杂的筛选。
在这个筛选中，我们希望得到名字以A或B起始，且等级在6以上的人名清单：

```jl
s = """
    function complex_filter(name, grade)::Bool
        interesting_name = startswith(name, 'A') || startswith(name, 'B')
        interesting_grade = 6 < grade
        interesting_name && interesting_grade
    end
    """
sc(s)
```

```jl
s = "filter([:name, :grade_2020] => complex_filter, grades_2020())"
sco(s; process=without_caption_label)
```

### 子集 {#sec:subset}

子集函数是为了更容易地处理缺失值而添加的。
与筛选不同，子集处理整列，而不是行或单个值。
如果我们想使用之前定义的函数，需要将函数打包在ByRow内：

```jl
s = "subset(grades_2020(), :name => ByRow(equals_alice))"
sco(s; process=without_caption_label)
```

还需注意，对于函数subset(df, args...)，DataFrame是它的第一个参数，而在筛选中，DataFrame是函数filter(f, df)的第二个参数。
此中原因是Julia将筛选定义为filter(f, V::Vector)，而DataFrames.jl选择与现有Julia函数保持一致，这些Julia函数可通过多重分派，扩展至DataFrames类型。

> **_注意：_**
> 大多DataFrames.jl原生函数，包括“子集”，总是一致地将DataFrame作为第一个参数。

如同“筛选”，我们可以在“子集”中使用匿名函数

```jl
s = "subset(grades_2020(), :name => ByRow(name -> name == \"Alice\"))"
sco(s; process=without_caption_label)
```

或者是对于“==”的偏函数：

```jl
s = "subset(grades_2020(), :name => ByRow(==(\"Alice\")))"
sco(s; process=without_caption_label)
```

最终，让我们来展示“子集”的真正威力。
首先，我们创建一个含有缺失值的数据集。

```jl
@sco salaries()
```

这数据有关一种似是而非的情形：你想算出你所有同事的薪资，却没有算其中某人的薪资。
尽管我们不想鼓励这种情况实际发生，但我们可以设想这是一个有趣的例子。
假设我们想知道谁的薪水超过2000。
如果我们使用“筛选”而没有考虑到缺失值，筛选将无法成功进行。

```jl
s = "filter(:salary => >(2_000), salaries())"
sce(s, post=trim_last_n_lines(25))
```

“子集”也会失败，但幸运的是，子集会指引我们通往解决方案的途径：

```jl
s = "subset(salaries(), :salary => ByRow(>(2_000)))"
sce(s, post=trim_last_n_lines(25))
```

我们只需传递关键字参数skipmissing=true即可：

```jl
s = "subset(salaries(), :salary => ByRow(>(2_000)); skipmissing=true)"
sco(s; process=without_caption_label)
```

```{=comment}
我们需要一个既有筛选又有子集的，复合情况的例子，如下：

`filter(row -> row.col1 >= something1 && row.col2 <= something2, df)`

and:

`subset(df, :col1 => ByRow(>=(something1)), :col2 => ByRow(<=(something2)>))
```
