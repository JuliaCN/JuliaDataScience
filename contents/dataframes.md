# DataFrames.jl {#sec:dataframes}

数据通常以表格格式存储。
在表格格式中，数据由包含行和列的表组成。
每列通常具有相同的数据类型，而每行数据类型不同。
实际上，行表示观测量，而列表示变量。
例如，我们有一个电视节目表，其中包含每个节目的制作国家和大众个人评分，如 @tbl:TV_shows 所示。

```{=comment}
Using a different example from the rest in the chapter to make the text a bit more interesting.
We could even ask the reader to answer the queries described below as exercises.
```

```jl
tv_shows = DataFrame(
        name=["Game of Thrones", "The Crown", "Friends", "..."],
        country=["United States", "England", "United States", "..."],
        rating=[8.2, 7.3, 7.8, "..."]
    )
Options(tv_shows; label="TV_shows")
```

此处的省略号表示这是一张非常长的表，但只显示了少数行。
在分析数据时，我们经常会提出一些关于数据的有趣问题，这也称为 **数据查询**。
对于大型表格，计算机能够比手工查询更快地回答此类问题。
一些 **数据查询** 问题的例子如下：

- 哪个电视节目评分最高？
- 哪些电视节目由美国制作？
- 哪些电视节目由相同的国家制作?

但是，作为研究人员，实际的科学往往从多张表格或多个数据源开始。
例如，如果我们也有其他人的电视节目评分数据 (@tbl:ratings)：

```jl
ratings = DataFrame(
    name=["Game of Thrones", "Friends", "..."],
    rating=[7, 6.4, "..."])
Options(ratings; label="ratings")
```

现在则能够提出以下问题：

- 节目 Game of Thrones 的平均评分是多少？
- 谁对 Friends 给出了最高的评分？
- 哪些节目你评分了，但其他人没有？

在本章的其余部分中，我们将展示如何借助 Julia 来轻松地回答这些问题。
因此此，首先说明为什么需要 Julia 包 `DataFrames.jl`。
下节将展示如何使用此包，最后将展示如何编写快速数据变换的代码 (@sec:df_performance)。

```{=comment}
TODO: Add a comparison with Excel to see where Julia is better.
In summary, because it is much easier to structure and reproduce the logic.
(Jose approves)
```

首先查看如下的成绩表 @tbl:grades_for_2020 ：

```jl
JDS.grades_for_2020()
```

其中 name 列的类型为 `string`, age 列的类型为 `integer`，而 grade 列的类型为 `float`。

截至目前，本书只介绍了 Julia 的基础知识。
这些基础能够处理很多东西，但不能处理表。
因此，为了说明我们需要更多类型，让我们尝试将表格数据存储在数组中：

```jl
@sc JDS.grades_array()
```

现在，数据以列优先形式存储，当想从行获取数据时，这种形式很麻烦：

```jl
@sco JDS.second_row()
```

或者，如果想获得 Alice 的成绩，首先需要弄清楚 Alice 所在的行：

```jl
scob("""
function row_alice()
    names = grades_array().name
    i = findfirst(names .== "Alice")
end
row_alice()
""")
```

然后才能得到成绩：

```jl
scob("""
function value_alice()
    grades = grades_array().grade_2020
    i = row_alice()
    grades[i]
end
value_alice()
""")
```

`DataFrames.jl` 可以很容易地处理此类问题。
首先使用 `using` 加载 `DataFrames.jl` ：

```
using DataFrames
```

通过 `DataFrames.jl`，我们可以定义 `DataFrame` 来存储表格数据：

```jl
sco("""
names = ["Sally", "Bob", "Alice", "Hank"]
grades = [1, 5, 8.5, 4]
df = DataFrame(; name=names, grade_2020=grades)
without_caption_label(df) # hide
""")
```

即此处返回的变量 `df` 以表格格式存储数据。

```{=comment}
Although this section is a duplicate of earlier chapters, I do think it might be a good idea to keep the duplicate.
According to MIT instructor Patrick Winston (https://youtu.be/Unzc731iCUY), convincing someone of something means repeating it a few times.
With this section, people who already understand it, understand it a bit better and people who didn't understand it yet might understand it here.
```

> **_NOTE:_**
> 这是可行的，但我们需要立即改变一件事。
> 在本例中，我们在全局作用域定义了变量 `name`、 `grade_2020` 和 `df`。
> 这意味着可以从任何位置访问和修改这些变量。
> 如果我们继续像这样写这本书，那么我们会在书结尾时拥有上百个变量，即使变量 `name` 中的数据本应只能通过 `DataFrame` 访问！
> 变量 `name` 和 `grade_2020` 不应该持久地保存！
> 现在，想象一下，我们将会在本书中多次修改 `grade_2020`。
> 如果本书只有 PDF 格式， 那么几乎不可能在最后指出变量的内容。
>
> 可以使用函数轻松地解决此类问题。

让我们使用函数完成同样的操作：

```jl
@sco grades_2020()
```

注意， `name` 和 `grade_2020` 会在函数返回后销毁，即它们仅在函数中可用。
这样做还有两个好处。
首先，读者可以清晰地看到 `name` 和 `grade_2020` 由谁所有：它们属于 2020 成绩表。
其次，很容易在书中的任何地方确定 `grades_2020()` 的输出。
例如，可以将数据赋给变量 `df`：

```jl
sco("""
df = grades_2020()
"""; process=without_caption_label)
```

改变 `df` 的内容：

```jl
sco("""
df = DataFrame(name = ["Malice"], grade_2020 = ["10"])
"""; process=without_caption_label)
```

而且仍然能够无损恢复数据：

```jl
sco("""
df = grades_2020()
"""; process=without_caption_label)
```

当然，此处假设没有重新定义函数。
我们在本书中保证不会这样做，因为这是非常糟糕的做法。
我们不会 “改变” 函数，而是创建一个具有明确名称的新函数。

因此，回到 `DataFrames`构造器。
如你所见，创建方法是将向量作为参数传递给 `DataFrame` 构造器。
你可以给定任何合法的 Julia 向量，并且 **只要向量长度相同**，就能成功构造 `DataFrame`。
重复的向量、Unicode 符号和任何类型的数字都可以：

```jl
sco("""
DataFrame(σ = ["a", "a", "a"], δ = [π, π/2, π/3])
"""; process=without_caption_label)
```

通常，您在代码中会创建函数来包装一个或多个作用于 `DataFrame` 的函数。
例如，可以创建函数来获取一个或多个 `names` 的成绩：

```jl
@sco process=without_caption_label JDS.grades_2020([3, 4])
```

使用函数来包装基本功能的这种方式，在编程语言和包中非常常见。
基本上，你可以把 Julia 和 `DataFrames.jl` 看作基本模块的提供者。
它们提供了相当 **通用的** 模块，从而你可以在此基础之上实现一些 **特例** ，比如这个成绩例子。
借助这些基本模块，你可以编写数据分析脚本，控制机器人或任何你想要构造的东西。

截至目前，由于必须使用索引，这些例子都非常麻烦。
下节将介绍如何在 `DataFrames.jl` 中加载和保存数据，以及其它一些强大的基本模块。
