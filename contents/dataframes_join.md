## Join {#sec:join}

本章主要展示和讨论关于多张表的操作。
目前为止，我们仅探讨了单张表的操作，接下来将探讨如何合并多张表。
`DataFrames.jl` 通过 `join` 函数合并多张表。
`join` 函数非常强大，但可能需要花些时间才能理解。
然而，你不需要记住下面所有的 `join` 函数，因为 [`DataFrames.jl` 文档](https://DataFrames.juliadata.org/stable/man/joins/) 和本书将会列出它们。
但是，必须要知道存在 `join` 操作。
如果要在某张 `DataFrame` 中遍历所有行并与其他数据行比较，那么可能需要如下这些 `join` 函数。

@sec:dataframes 给出了 2020 年的成绩 `grades_2020`：

```jl
s = "grades_2020()"
sco(s; process=without_caption_label)
```

现在需要将 `grades_2020` 与 2021 年的成绩合并：

```jl
s = "grades_2021()"
sco(s; process=without_caption_label)
```

此功能的实现就需要用到 `join`。
`DataFrames.jl` 列出了不少于七种的 `join` 函数，
这看起来令人生畏，但请坚持，因为它们都很有用，后面将会逐个讨论所有函数。

### innerjoin {#sec:innerjoin}

首先讨论的是 **`innerjoin`**。
假设存在两个数据集 `A` 和 `B`， 分别具有列 `A_1, A_2, ..., A_n` 和 `B_1, B_2, ..., B_m` ，**并且** 其中的一列具有相同的名字：`A_1` 和 `B_1` 都是 `:id`。
然后对 `:id` 使用 `innerjoin`，则将遍历 `A_1` 中的所有元素并且与 `B_1` 中的元素进行比较。
如果元素 **是相同的**，然后将会把 `A_2, ..., A_n` 和 `B_2, ..., B_m` 的相应信息添加到 `:id` 列后。

好吧，如果你没有明白上面的描述，请不要担心。
请查看如下所示的成绩数据集合并结果：

```jl
s = "innerjoin(grades_2020(), grades_2021(); on=:name)"
sco(s; process=without_caption_label)
```

注意只有 "Sally" 和 "Hank" 同时存在于两个数据集中。
`innerjoin` 的名字对应了数学中的 **交集**， 即“存在于 $A$ 的元素，也存在于 $B$，或者说存在于 $B$ 的元素，也存在于 $A$”。

### outerjoin {#sec:outerjoin}

也许你在想， “aha，如果我们有`inner`，那我们可能也会有 `outer`”。
是的，你猜对了！

**`outerjoin`** 没有 `innerjoin` 那么严格，只要在 **至少一个数据集中**发现包含的 `name`，就会将相应的列合并到结果中：

```jl
s = "outerjoin(grades_2020(), grades_2021(); on=:name)"
sco(s; process=without_caption_label)
```

因此，当其中一个原始数据集不存在对应的值时，该方法会创建 `missing` 值。

### crossjoin {#sec:crossjoin}

如果使用 **`crossjoin`** 将会出现更多的 `missing` 值。
该方法会给出 **行的笛卡尔积**，也就是行的乘法，即对于每一行创建一个与另一张表中所有行的组合：

```jl
s = "crossjoin(grades_2020(), grades_2021(); on=:id)"
sce(s; post=trim_last_n_lines(2))
```

呃，出错了。
因为 `crossjoin` 并不按行考虑元素，所以不需要将 `on` 参数指定为想要合并的列：

```jl
s = "crossjoin(grades_2020(), grades_2021())"
sce(s; post=trim_last_n_lines(6))
```

呃，又出错了。
这是一个 `DataFrame` 和 `join` 中很常见的错误。
2020 和 2021 年成绩表有一个重复的列名，即 `:name`。
与之前一样，`DataFrames.jl` 的报错输出给出了一个可能修复此错误的简单建议。
尝试仅传递 `makeunique=true` 解决此问题：

```jl
s = "crossjoin(grades_2020(), grades_2021(); makeunique=true)"
sco(s; process=without_caption_label)
```

所以现在，对于 2020 和 2021 年成绩表中的每个人，新表都存在表示其成绩的一行。
对于直接的查询，例如“谁的成绩最高？”，笛卡尔积的结果通常不太可行，但对于“统计学” 查询来说具有一定意义。

### leftjoin 和 rightjoin {#sec:leftjoin_rightjoin}

**对数据科学项目更有用的是 `leftjoin` 和 `rightjoin`**。
`leftjoin` 将考虑合并时左侧 `DataFrame` 中的所有元素：

```jl
s = "leftjoin(grades_2020(), grades_2021(); on=:name)"
sco(s; process=without_caption_label)
```

此处注意，“Bob” 和 “Alice” 的成绩在 2021 成绩表格中是 **缺失** 的，这就是为什么对应的位置是 `missing` 值。
`rightjoin` 实现了相反的操作：

```jl
s = "rightjoin(grades_2020(), grades_2021(); on=:name)"
sco(s; process=without_caption_label)
```

而现在 2020 中的部分成绩是缺失的。

注意到， **`leftjoin(A, B) != rightjoin(B, A)`**，因为它们的列顺序不同。
例如，将下面的输出与之前的输出进行比较：

```jl
s = "leftjoin(grades_2021(), grades_2020(); on=:name)"
sco(s; process=without_caption_label)
```

### semijoin 和 antijoin {#sec:semijoin_antijoin}

最后讨论 **`semijoin`** 和 **`antijoin`**。

`semijoin` 比 `innerjoin` 更具有限制性。
它仅返回 **存在于左侧 `DataFrame` 并同时存在于两张 `DataFrame` 的元素**。
这看起来像是 `innerjoin` 和 `leftjoin` 的组合。

```jl
s = "semijoin(grades_2020(), grades_2021(); on=:name)"
sco(s; process=without_caption_label)
```

与 `semijoin` 相对的是 `antijoin`。
它仅返回 **存在于左侧 `DataFrame` 但不存在于右侧 `DataFrame` 的元素**。

```jl
s = "antijoin(grades_2020(), grades_2021(); on=:name)"
sco(s; process=without_caption_label)
```
