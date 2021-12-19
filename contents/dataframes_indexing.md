## Index 和 Summarize {#sec:index_summarize}

回顾之前定义的 `grades_2020()` 数据集：

```jl
sco("grades_2020()"; process=without_caption_label)
```

可以通过 `.` 语法提取 `DataFrame` 中的 `name` 列向量，正如之前 @sec:julia_basics 中 `struct` 的操作那般：

```jl
@sco JDS.names_grades1()
```

或者，可以像 `Array` 那样通过 `Symbol` 或特殊字符索引 `DataFrame` 。
**第二个索引是列索引**：

```jl
@sco JDS.names_grades2()
```

注意， `df.name` 与 `df[!, :name]` 完全相同， 这可以自行验证：

```
julia> df = DataFrame(id=[1]);

julia> @edit df.name
```

这两个例子都会得到 `:name`。
同样，也存在 `df[:, :name]` 这样的语法，不过它复制了 `:name` 列。
大多数情况下， `df[!, :name]` 是最佳的做法，因为它更通用，而且没有内存拷贝，对其的所有操作都是 in-place 的。


对于任意 **行**, 例如第二行， 可以使用 **第一个索引作为行索引**：

```jl
s = """
    df = grades_2020()
    df[2, :]
    df = DataFrame(df[2, :]) # hide
    """
sco(s; process=without_caption_label)
```

或者创建函数来获取某一行 `i`：

```jl
@sco process=without_caption_label JDS.grade_2020(2)
```

还可以使用 **切片** （与 `Array` 类似）来仅获取 `names` 列的前两行：

```jl
@sco JDS.grades_indexing(grades_2020())
```

如果假设表中的每个名字是唯一的，那么可以编写一个函数来通过 `name` 获取每个人的成绩。
要实现此操作，需将上表转换为一种 Julia 基本数据结构，即可以实现映射的 `Dict`：

```jl
@sco post=output_block grade_2020("Bob")
```

这是可行的，因为 `zip` 会同时遍历 `df.name` 和 `df.grade_2020`，就像 “拉链” 那样：

```jl
sco("""
df = grades_2020()
collect(zip(df.name, df.grade_2020))
""")
```

然而， `DataFrame` 转 `Dict` 操作仅在元素唯一的情况下可行。
一般情况下，上述条件并不成立，所以需要学习如何对 `DataFrame` 进行 `filter` 操作。

## Filter 和 Subset {#sec:filter_subset}

有两种方式可以选取 `DataFrame` 中的某些行， 一种是 `filter` (@sec:filter) 而另一种是 `subset` (@sec:subset)。

`DataFrames.jl` 较早地添加了 `filter` 函数, 它更强大且与 Julia `Base` 库的语法保持一致，因此我们先讨论 `filter`。
`subset` 是较新的函数，但它通常更简便。

### Filter {#sec:filter}

由此开始，接下来将讨论 `DataFrames.jl` 中非常强大的特性。
在讨论伊始，首先学习一些函数，例如 `select` 和 `filter`。
但请不要担心！
可以先松一口气，因为 **`DataFrames.jl` 的总体设计目标就是让用户需学习的函数保持在最低限度[^verbs]**。

[^verbs]: 这来自于 Bogumił Kamiński （`DataFrames.jl` 的首席开发者和维护者） 在 Discourse (<https://discourse.julialang.org/t/pull-dataframes-columns-to-the-front/60327/5>) 论坛上的发言。

与之前一样，从 `grades_2020` 开始：

```jl
sco("grades_2020()"; process=without_caption_label)
```

可以使用 `filter(source => f::Function, df)` 筛选行。
注意，这个函数与 Julia `Base` 模块中的 `filter(f::Function, V::Vector)` 函数非常相似。
这是因为 `DataFrames.jl` 使用**多重派发** (see @sec:multiple_dispatch) 扩展`filter`，以使其能够接收`DataFrame` 作为参数。

从第一印象来看，实际中定义和使用函数 `f` 可能有些困难。
但请坚持学习，我们的努力会有超高的回报，因为 **这是非常强大的数据筛选方法**。
如下是一个简单的例子， 创建函数 `equals_alice` 来检查输入是否等于 "Alice"：

```jl
@sco post=output_block JDS.equals_alice("Bob")
```

```jl
sco("equals_alice(\"Alice\")"; post=output_block)
```

结合该函数， 可以使用 `f` 筛选出所有 `name` 等于 "Alice" 的行：

```jl
s = "filter(:name => equals_alice, grades_2020())"
sco(s; process=without_caption_label)
```

注意这不仅适用于 `DataFrame`，也适用于向量：

```jl
s = """filter(equals_alice, ["Alice", "Bob", "Dave"])"""
sco(s)
```

还可以使用 **匿名函数** 缩短代码长度 (请查阅 @sec:function_anonymous)：

```jl
s = """filter(n -> n == "Alice", ["Alice", "Bob", "Dave"])"""
sco(s)
```

它也可用于 `grades_2020`:

```jl
s = """filter(:name => n -> n == "Alice", grades_2020())"""
sco(s; process=without_caption_label)
```

简单来说，上述函数可以理解为 “遍历 `:name` 列的所有元素，对每一个元素 `n`，检查 `n` 是否等于 Alice”。
可能对于某些人来说，这样的代码些许冗长。
幸运的是，Julia 已经扩展了 `==` 的**偏函数应用（partial function application）** （译注：指定部分参数的函数）。
其中的细节不重要 -- 只需知道能像其他函数一样使用 `==`：

```jl
sco("""
s = "This is here to workaround a bug in books" # hide
filter(:name => ==("Alice"), grades_2020())
"""; process=without_caption_label)
```

### Subset {#sec:subset}

`subset` 函数的加入使得处理 `missing` 值 (@sec:missing_data) 更加容易。
与 `filter` 相反， `subset` 对整列进行操作，而不是整行或者单个值。
如果想使用之前的函数，可以将其包装在 `ByRow` 里：

```jl
s = "subset(grades_2020(), :name => ByRow(equals_alice))"
sco(s; process=without_caption_label)
```

另请注意， `DataFrame` 是 `subset(df, args...)` 的第一个参数，而而对于 `filter` 来说是第二个参数，即 `filter(f, df)`。
这是因为， Julia 定义 `filter` 的方式为 `filter(f, V::Vector)`，而 `DataFrames.jl` 在使用多重派发将其扩展到 `DataFrame` 类型时，选择与现有函数形式保持一致。

> **_NOTE:_**
> `subset` 所属的大多数原生 `DataFrames.jl` 函数都保持着一致的函数签名，即 **将 `DataFrame` 作为第一个参数**。

与 `filter` 一样，可以在 `subset` 中使用匿名函数：

```jl
s = "subset(grades_2020(), :name => ByRow(name -> name == \"Alice\"))"
sco(s; process=without_caption_label)
```

或者使用 `==` 的偏函数应用：

```jl
s = "subset(grades_2020(), :name => ByRow(==(\"Alice\")))"
sco(s; process=without_caption_label)
```

最后展示 `subset` 的真正用处。
首先，创建一个含有 `missing` 值的数据集：

```jl
@sco salaries()
```

这是一种合理的情况：你想算出同事们的工资，但还没算 Zed 的。
尽管我们不鼓励这么做，但这是一个有趣的例子。
假设我们想知道谁的工资超过了 2000。
如果使用 `filter`, 但未考虑 `missing`值，则会失败：

```jl
s = "filter(:salary => >(2_000), salaries())"
sce(s, post=trim_last_n_lines(25))
```

`subset` 同样会失败，但幸运的是，报错指出一则简单的解决方案：

```jl
s = "subset(salaries(), :salary => ByRow(>(2_000)))"
sce(s, post=trim_last_n_lines(25))
```

所以仅需要传递关键字参数 `skipmissing=true`：

```jl
s = "subset(salaries(), :salary => ByRow(>(2_000)); skipmissing=true)"
sco(s; process=without_caption_label)
```

```{=comment}
Rik, we need a example of both filter and subset with multiple conditions, as in:

`filter(row -> row.col1 >= something1 && row.col2 <= something2, df)`

and:

`subset(df, :col1 => ByRow(>=(something1)), :col2 => ByRow(<=(something2)>))
```
