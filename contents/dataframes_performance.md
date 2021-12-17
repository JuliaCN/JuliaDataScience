## 性能 {#sec:df_performance}

截至目前，我们还没有尝试让 `DataFrames.jl` 代码变得 **快些**。
就像 Julia 中的一切， `DataFrames.jl` 实际上也可以变得非常快。
本节将给出一些性能建议和技巧。

### In-place 的操作 {#sec:df_performance_inplace}

如在 @sec:function_bang 讨论的那样，如果函数结尾带有叹号 `!`，那么这表明该函数会更改传入的参数。
在 Julia 高性能代码的语境中，这**表明** 带有 `!`的函数将会原地（in-place）修改我们传入的参数对象。

几乎所有的 `DataFrames.jl` 函数都有一个带 `!` 的版本。
例如， `filter` 有 _in-place_ 的 `filter!`， `select` 有 `select!`， `subset` 有 `subset!` 等等。
注意，这些函数都 **没有** 返回新的 `DataFrame`，而是直接 **更新** 传入的 `DataFrame` 。
另外， `DataFrames.jl` (从版本 1.3 开始)支持 in-place 的 `leftjoin` ，即 `leftjoin!` 函数。
该函数会使用右侧 `DataFrame` 的数据列更新左侧 `DataFrame` 。
需要注意的是，左表的每一行 **最多** 只能匹配右表中的一行。

如果想在代码中获得最高的速度和性能，你绝对应该使用带 `!` 的函数，而不是常规的 `DataFrames.jl` 函数。

让我们回到在 @sec:select 开始部分提到的关于 `select` 函数的例子。
如下是 `responses` 的 `DataFrame`：

```jl
sco("responses()"; process=without_caption_label)
```

现在使用 `select` 函数来进行选择，就像之前所做的那样：

```jl
s = """
    # allocating function # hide
    select(responses(), :id, :q1)
    """
sco(s, process=without_caption_label)
```

而 _in-place_ 函数如下：

```jl
s = """
    # non allocarting function # hide
    select!(responses(), :id, :q1)
    """
sco(s; process=without_caption_label)
```

`@allocated` 宏会告诉我们运行过程中分配的内存大小。
换句话说，**计算机在运行代码时需要在内存中存储多少新信息**。
让我们看看运行结果：

```jl
s = """
    # allocation # hide
    df = responses()
    @allocated select(df, :id, :q1)
    """
sco(s; process=string, post=plainblock)
```

```jl
s = """
    # non allocation # hide
    df = responses()
    @allocated select!(df, :id, :q1)
    """
sco(s; process=string, post=plainblock)
```

如我们所看到的那样， `select!` 分配的内存小于 `select` 的。
所以，由于消耗更少的内存，它应该更快。

### 复制或者不复制列 {#sec:df_performance_df_copy}

有两种 **访问 DataFrame 列**的方式。
它们的不同之处在于：一种方式是创建列的 “view”，并且没有拷贝；而另一种方式是从原始列复制出一个全新的列。

第一种方式通常使用点运算符 `.` + 列名的语法，即 `df.col`。
这种方式 **不拷贝** 列 `col`。
实际上，`df.col` 创建了链接到原始列的 "view" ，且没有分配任何内存。
另外，`df.col` 语法等价于带有 `i` 的列选择器 `df[!, :col]` 。

第二种访问 `DataFrame` 列的方式是 `df[:, :col]`，即使用 `:` 作为列选择器。
这种方式 **会拷贝** 列 `col`， 所以请注意这将产生非预期的内存分配。

与之前一样， 让我们尝试这两种方法来访问 `DataFrame` `responses` 中的列：

```jl
s = """
    # allocation # hide
    df = responses()
    @allocated col = df[:, :id]
    """
sco(s; process=string, post=plainblock)
```


```jl
s = """
    # non allocation # hide
    df = responses()
    @allocated col = df[!, :id]
    """
sco(s; process=string, post=plainblock)
```

当访问某列而不复制它时，不会进行任何内存分配，代码应该更快。
所以，如果不需要复制，通常请使用 `df.col` 或 `df[!, :col]` 访问 `DataFrame` 的列， 而不是 `df[:, :col]`。

### CSV.read 和 CSV.File {#sec:df_performance_csv_read_file}

如果查看过 `CSV.read` 的帮助输出， 你将会发现一个与该函数功能等价的便利函数 `CSV.File`，它们拥有相同的关键字参数。
 `CSV.read` 和 `CSV.File` 都可以用来读取 CSV 文件的内容，但它们的默认行为不同。
**在默认情况下，`CSV.read` 不会复制** 输入数据。
取而代之的是，`CSV.read` 会把所有数据传入第二个参数（称为“槽”）。

因此如下所示：

```julia
df = CSV.read("file.csv", DataFrame)
```

这将会把 `file.csv` 中的数据传入 `DataFrame` 槽， 然后把 `DataFrame` 类型返回给 `df` 变量。

在 `CSV.File` 的例子中，**情况相反：默认情况下，它将会复制 CSV 文件中的每一列**。
另外，语法上也稍有不同。
我们需要将 `CSV.File` 返回的所有数据包含在 `DataFrame` 构造器函数：

```julia
df = DataFrame(CSV.File("file.csv"))
```

或者，也可以使用 `|>` 管道运算符：

```julia
df = CSV.File("file.csv") |> DataFrame
```

如之前所说， `CSV.File` 将会复制 CSV 文件中的每一列。
因此，如果想要最佳性能，那么肯定应该使用 `CSV.read` 而不是 `CSV.File`。
这就是为什么 在 @sec:csv 中只讨论 `CSV.read`。

### CSV.jl 与多文件 {#sec:df_performance_csv_multiple}

现在让我们关注 `CSV.jl`。
特别要关注将多个 CSV 文件读取到一个 `DataFrame` 的例子。
从 `CSV.jl` 的 0.9 版本开始， 我们可以提供文件名字符串的向量。
在此之前，用户需要按顺序读取多个文件，并将它们垂直连接到单个 `DataFrame` 中。
举个例子，下面的代码将读取多个 CSV 文件，并使用 `vcat` 和 `reduce` 函数将它们垂直连接到单个 `DataFrame` 中：

```julia
files = filter(endswith(".csv"), readdir())
df = reduce(vcat, CSV.read(file, DataFrame) for file in files)
```

一个附加的特点是，`reduce` 不能并行化，因为它必须遵循与 `files`向量相同的顺序。

若在 `CSV.jl` 使用该功能，则可以简单地向 `CSV.read` 函数传入 `files` 向量：

```julia
files = filter(endswith(".csv"), readdir())
df = CSV.read(files, DataFrame)
```

`CSV.jl` 将会为每个文件单独指定一个计算机中可用的线程，然后将每个线程的的输出延迟连接到 `DataFrame` 中。
因此，在不使用 `reduce` 函数时，我们获得了 **额外的多线程优点**。

### CategoricalArrays.jl 压缩 {#sec:df_performance_categorical_compression}

如果需要处理大量的分类值，例如许多代表不同定性数据的文本数据列，那么可能需要使用 `CategoricalArrays.jl` 压缩来处理此类情况。

默认情况下， **`CategoricalArrays.jl` 将会使用 32 位 无符号整数 `UInt32` 来表示基础的类别**：

```jl
s = """
    typeof(categorical(["A", "B", "C"]))
    """
sco(s; process=string, post=plainblock)
```

这意味着，`CategoricalArrays.jl` 将最多可以在一列中表示 $2^{32}$ 中不同的类别，这是一个非常大的数字 (接近 43亿)。
在处理常规数据时，可能永远都不需要如此级别的容量[^bigdata]。
这就是为什么 `categorical` 有一个 `compress` 参数， 它可以通过接收 `true` 或 `false` 来决定是否压缩基本分类数据。
如果传入了 **`compress=true`, `CategoricalArrays.jl` 将会尝试把基本分类数据压缩到最小的 `UInt` 表示**。
例如，之前的 `categorical` 向量可以表示为 8 位无符号整数 `UInt8` (通常这样做，因为这是 Julia 中最小的无符号整型)：

[^bigdata]: 同时注意到常规数据 （最多 10 000 行）不算大数据（超过 100 000 行）。因此，若是主要处理大数据，请你谨慎设定分类值。

```jl
s = """
    typeof(categorical(["A", "B", "C"]; compress=true))
    """
sco(s; process=string, post=plainblock)
```

这些都意味着什么呢？
假设你有一个超级大的向量。
例如，1 百万元素的向量，但仅有四种基本类型：A，B，C，或 D。
如果不想压缩生成的分类向量，那么你将会存储 1 百万 `UInt32` 类型的元素。
另一方面，如果压缩它，那么将会存储 1 百万 `UInt8` 类型的元素。
可以使用 `Base.summarysize` 函数获得给定对象的基本大小（以字节为单位）。
因此，让我们量化一下，在不压缩一百万分类向量时，将需要多少更多的内存：

```julia
using Random
```

```jl
s = """
    one_mi_vec = rand(["A", "B", "C", "D"], 1_000_000)
    Base.summarysize(categorical(one_mi_vec))
    """
sco(s; process=string, post=plainblock)
```

4 百万字节，大概是 3.8 MB。
不要觉得我们错了，这是对原始字符串向量的很大改进：

```jl
s = """
    Base.summarysize(one_mi_vec)
    """
sco(s; process=string, post=plainblock)
```

通过使用 `CategoricalArrays.jl` 将数据表示为 `UInt32` ，我们节省了 50% 的原始数据大小。

现在与压缩选项进行对比：

```jl
s = """
    Base.summarysize(categorical(one_mi_vec; compress=true))
    """
sco(s; process=string, post=plainblock)
```

在不丢失信息的情况下，我们将大小减少到原始未压缩向量大小的25% （四分之一）。
我们的压缩分类向量现在有100万字节，大约是1.0 MB。

因此，只要有提高性能的可能，请考虑在分类数据中使用 `compress=true`。
