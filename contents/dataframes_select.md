## Select {#sec:select}

上节讨论了 **按行选取的 `filter`**, 而本节将讨论 **按列选取的 `select`**。
然而， `select` 不止能用于按列选取，本节还会讨论更加广泛的用法。
首先，创建具有多列的数据集：

```jl
@sco responses()
```

上述数据表示某问卷中五个问题的（`q1`，`q2`，...，`q5`）的答案。
首先，选取数据集中的一些列。
照例使用 `Symbol` 指定列：

```jl
s = "select(responses(), :id, :q1)"
sco(s, process=without_caption_label)
```

也可以使用字符串：

```jl
s = """select(responses(), "id", "q1", "q2")"""
sco(s, process=without_caption_label)
```

如果要选取**除了** 某些列外的所有列，请使用 `Not`：

```jl
s = """select(responses(), Not(:q5))"""
sco(s, process=without_caption_label)
```

`Not` 也适用于多列：

```jl
s = """select(responses(), Not([:q4, :q5]))"""
sco(s, process=without_caption_label)
```

当然也可以将要保留的列参数和 **不** 保留的列参数组合起来：

```jl
s = """select(responses(), :q5, Not(:id))"""
sco(s, process=without_caption_label)
```

注意，`q5` 是 `select` 返回的 `DataFrame` 的第一列。
要实现如上的操作，更聪明的做法是使用 `:`。
冒号 `:` 可以认为是 **前述条件尚未包含的所有列**。
例如：

```jl
s = """select(responses(), :q5, :)"""
sco(s, process=without_caption_label)
```

或者，把 `q5` 放在第二个位置[^sudete]：

[^sudete]: 感谢 Sudete 在 Discourse 论坛 (<https://discourse.julialang.org/t/pull-dataframes-columns-to-the-front/60327/4>) 上给予的建议。

```jl
s = "select(responses(), 1, :q5, :)"
sco(s, process=without_caption_label)
```

> **_NOTE:_**
> 正如你所看到的那样，有多种列选择方法。
> 它们都被称为 [**列选择器**](https://bkamins.github.io/julialang/2021/02/06/colsel.html)。
>
> 可以使用：
>
> * `Symbol`: `select(df, :col)`
>
> * `String`: `select(df, "col")`
>
> * `Integer`: `select(df, 1)`

甚至可以使用 `select` 重命名列，语法是 `source => target`：

```jl
s = """select(responses(), 1 => "participant", :q1 => "age", :q2 => "nationality")"""
sco(s, process=without_caption_label)
```

另外，还可以使用 "splat" 算符 `...` (请查阅 @sec:splat) 写作如下形式：

```jl
s = """
    renames = (1 => "participant", :q1 => "age", :q2 => "nationality")
    select(responses(), renames...)
    """
sco(s, process=without_caption_label)
```

## 类型和缺失值 {#sec:missing_data}

```{=comment}
Try to combine with transformations

categorical
allowmissing
disallowmissing
```

正如在 @sec:load_save 讨论的那样， `CSV.jl` 会尽可能推断每列数据应该使用的类型。
然而，这并不总是能完美实现。
本节将说明为什么合适的类型是重要的，以及如何修复错误数据类型。
为了更清晰地展示类型，接下来将给出 `DataFrame` 的文本输出，而不是格式化打印的表。
本节将使用如下的数据集：

```jl
@sco process=string post=output_block wrong_types()
```

因为日期列的类型并不正确，所以 `sort` 并不能正常工作：

```{=comment}
Whoa! You haven't introduced the reader to sorting with `sort` yet.
```

```jl
s = "sort(wrong_types(), :date)"
scsob(s)
```

为了修复此问题，可以使用在  @sec:dates 中提到的 Julia 标准库 `Date` 模块：

```jl
@sco process=string post=output_block fix_date_column(wrong_types())
```

现在，排序的结果与预期相符：

```jl
s = """
    df = fix_date_column(wrong_types())
    sort(df, :date)
    """
scsob(s)
```

年龄列存在相似的问题：

```jl
s = "sort(wrong_types(), :age)"
scsob(s)
```

这显然不正确，因为婴儿比成年人和青少年更年轻。
对于此问题和其他分类数据的解决方案是 `CategoricalArrays.jl`：

```
using CategoricalArrays
```

可以使用 `CategoricalArrays.jl` 包为分类变量数据添加层级顺序：

```jl
@sco process=string post=output_block fix_age_column(wrong_types())
```

> **_NOTE:_**
> 此处注意参数 `ordered=true` 将告诉 `CategoricalArrays.jl` 的 `categorical` 函数，分类数据是排好序的。
> 如果没有此参数，任何的大小比较都不能实现。

现在可以正确地按年龄排序：

```jl
s = """
    df = fix_age_column(wrong_types())
    sort(df, :age)
    """
scsob(s)
```

因为已经定义了一组函数，因此可以通过调用函数来定义修正后的数据：
```jl
@sco process=string post=output_block correct_types()
```

数据中的年龄是有序的 (`ordered=true`)，因此可以正确比较年龄类别：

```jl
s = """
    df = correct_types()
    a = df[1, :age]
    b = df[2, :age]
    a < b
    """
scob(s)
```

如果元素类型为字符串，这将产生错误的比较：

```jl
s = "\"infant\" < \"adult\""
scob(s)
```
