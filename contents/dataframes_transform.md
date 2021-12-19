## 变量变换 {#sec:df_transform}

```{=comment}
We need to cover `ifelse` and `case_when`
```

在 @sec:filter 中，我们使用 `filter` 函数筛选一列或多列数据。
回忆一下， `filter` 函数使用 `source => f::Function` 这样的语法：`filter(:name => name -> name == "Alice", df)`。

在 @sec:select 中， 我们使用 `select` 函数选择一列或多列源数据， 并传入一个或多个目标列 `source => target`。
同样也有例子帮助回忆： `select(df, :name => :people_names)`。

本节将讨论如何 **变换** 变量，即如何 **更改数据**。
 `DataFrames.jl` 中对应的语法是 `source => transformation => target`。

与之前一样，使用 `grades_2020` 数据集：

```jl
@sco process=without_caption_label grades_2020()
```

假设想要 `grades_2020` 中的所有成绩加 1。
首先，需要定义一个接收向量数据并使所有元素加 1 的函数。
然后使用 `DataFrames.jl` 中的 `transform` 函数。与其他原生 `DataFrames.jl` 函数一样，按照其语法，它接收 `DataFrame` 作为第一个参数：

```jl
s = """
    plus_one(grades) = grades .+ 1
    transform(grades_2020(), :grade_2020 => plus_one)
    """
sco(s; process=without_caption_label)
```

如上， `plus_one` 函数接收了 `:grade_2020` 整列。
这就是为什么要在加 `+` 运算符前添加 `.` 广播运算符。
可以查阅 @sec:broadcasting 回顾有关广播的操作。

如之前所说， `DataFrames.jl` 总是支持 `source => transformation => target` 这样的短语法。
所以，如果想在输出中保留 `target` 列的命名，操作如下：

```jl
s = """
    transform(grades_2020(), :grade_2020 => plus_one => :grade_2020)
    """
sco(s; process=without_caption_label)
```

也可以使用关键字参数 `renamecols=false`：

```jl
s = """
    transform(grades_2020(), :grade_2020 => plus_one; renamecols=false)
    """
sco(s; process=without_caption_label)
```

还可以使用 `select` 实现相同的转换，具体如下：

```jl
s = """
    select(grades_2020(), :, :grade_2020 => plus_one => :grade_2020)
    """
sco(s; process=without_caption_label)
```

其中 `:` 表明 "选择所有列" ，正如在 @sec:select 讨论的那样。
另外，还可以使用 Julia 广播更改 `grade_2020` 列，即直接访问 `df.grade_2020`：

```jl
s = """
    df = grades_2020()
    df.grade_2020 = plus_one.(df.grade_2020)
    df
    """
sco(s; process=without_caption_label)
```

但是，尽管很容易使用 Julia 原生操作构建最后的例子，**我们仍然强烈建议使用在大多数例子中提到的 `DataFrames.jl` 函数，因为它们更加强大并且更容易与其他代码组织**。

### 多条件变换 {#sec:multiple_transform}

为了展示如何同时更改两列， 我们使用 @sec:join 中的左合并数据：

```jl
s = """
    leftjoined = leftjoin(grades_2020(), grades_2021(); on=:name)
    """
sco(s; process=without_caption_label)
```

结合此数据集，我们增加一列来判断每位同学是否都有一门课的成绩大于 5.5：

```jl
s = """
    pass(A, B) = [5.5 < a || 5.5 < b for (a, b) in zip(A, B)]
    transform(leftjoined, [:grade_2020, :grade_2021] => pass; renamecols=false)
    """
sco(s; process=without_caption_label)
```

```{=comment}
I don't think you have covered vector of symbols as col selector...
You might have to do this in the `dataframes_select.md`
```

可以清理下结果，并将上述逻辑整合到一个函数中，然后最终得到符合标准学生的名单：

```jl
@sco only_pass()
```
