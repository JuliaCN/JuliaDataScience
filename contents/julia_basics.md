# Julia 基础 {#sec:julia_basics}

> **_NOTE:_**
> 本章介绍 Julia 编程语言的基础。
> 请注意，使用 Julia 语言作为数据分析和数据可视化工具不是 **严格必须** 的。
> 了解 Julia 的基础知识可以让你更加 **有效** 且 **高效** 地使用 Julia 。
> 但是，如果希望直接开始，可以跳转到 @sec:dataframes ，学习使用 `DataFrames.jl` 操作表格数据。

本章是对 Julia 语言的简要概述。
如果您已经熟悉其他编程语言，我们强烈建议您阅读 Julia 文档 (<https://docs.julialang.org/>)。
 Julia 文档是深入理解 Julia 的绝佳资源。
它包含了所有的基础和特殊案例，但在你并不熟悉软件文档时会变得很复杂。

接下来将介绍 Julia 的基本知识。
想象一下，若把Julia 比作一辆功能丰富的奇特汽车，比如一辆全新的特斯拉，那么本章只会向您介绍如何“驾驶汽车、停车和在道路上导航”。
若你想知道“方向盘和仪表盘上的所有按钮的作用”，那本章不是您要找的资源。

## 开发环境 {#sec:ide}

在深入研究语法前，我们需要了解如何运行代码。
详细介绍各种运行方案超出本书讨论的范围。因此，本节只对每种方案作简要介绍。

最简单的方案是使用 Julia REPL。
这指的是启动 Julia 可执行文件 (`julia` or `julia.exe`) 并且在其中运行代码。
例如，启动 REPL 并执行一些代码：

```julia
julia> x = 2
2

julia> x + 1
3
```

代码都运行正常，但是如果我们想保存编写的代码，该怎么办？
我们可以通过编写 “.jl” 文件来保存代码，例如 “script.jl” ，并将它加载到 Julia 中。
“script.jl” 包含:

```
x = 3
y = 4
```

将它加载到 Julia:

```julia
julia> include("script.jl")

julia> y
4
```

现在的问题是，如何使 Julia 在每次执行代码前重新读取我们的脚本。
[Revise.jl](https://github.com/timholy/Revise.jl) 实现了这一功能。
因为 Julia 中的编译时间通常很长，所以 `Revise.jl` 是 Julia 开发的必备工具。
有关更多信息，请阅读 `Revise.jl` 文档或者在 Google 上搜索具体的问题。

我们还发现 `Revise.jl` 和 REPL 需要一些手动操作，但文档并没有将这些操作写清楚。
幸运的是，还有 [Pluto.jl](https://github.com/fonsp/Pluto.jl)。
`Pluto.jl` 能够自动管理依赖， 运行代码， 和 **交互式** 地更改代码。
对于刚接触编程的人来说， `Pluto.jl` 是最简单的入门方案。
此软件包的主要缺点是不够适合大型项目。

一些其他选项是使用安装了多种 Julia 插件 的 Visual Studio Code 或定制你自己的 IDE。
如果你 **不知道** 什么是 IDE，但又想管理大型项目，请选择 Visual Studio Code 。
如果你 **知道** 什么是 IDE，那你可以使用 Vim 或者Emacs 结合 REPL 来构建自己的 IDE。

综上所述：

- 最简单的入门方案 -> `Pluto.jl`
- 大型项目 -> Visual Studio Code
- 高级用户 -> Vim, Emacs and the REPL

## 语法 {#sec:syntax}

Julia 是一种即时编译的**动态类型语言**。
这意味着不像 C++ 或 FORTRAN 那样，需要在运行之前编译程序。
相反，Julia 会读取你的代码，并在运行前编译部分程序。
同时，你不需要为每一处代码显式地指定类型，Julia会在运行时推断类型。

Julia 与其他动态语言（如 R 和 Python）之间的主要区别如下。
首先，Julia **允许用户进行类型声明** 。你应该在 **为什么选择 Julia?** (@sec:why_julia): 一节已经见过类型声明，就是一些跟在变量后的双冒号 `::` 。
但是，如果你不想指定变量或函数的类型，Julia 将会很乐意推断（猜测）它们。

其次，Julia 允许用户通过多重派发定义不同参数类型组合的函数行为。
本书将会在 @sec:julia_accomplish 讨论多重派发。
定义不同函数行为的方法是使用相同的函数名称定义新的函数，但将这些函数用于不同的参数类型。

### 变量 {#sec:variable}

变量是在计算机中以特定名称存储的值，以便后面读取或更改此值。
Julia 有很多数据类型，但在数据科学中主要使用:

* 整数： `Int64`
* 实数： `Float64`
* 布尔型： `Bool`
* 字符串： `String`

整数和实数默认使用 64 位存储，这就是为什么它们的类型名称带有“64”后缀。
如果需要更高或更低的精度，Julia 还有 `Int8` 类型和 `Int128` 类型，其中 `Int8` 类型用于低精度，`Int128` 类型用于高精度。
多数情况下，用户不需要关心精度问题，使用默认值即可。

创建新变量的方法是在左侧写变量名并在右侧写其值，并在中间插入`=` 赋值运算符。
例如：

```jl
s = """
    name = "Julia"
    age = 9
    """
scob(s)
```

请注意，最后一行代码 (`age`) 的值已打印到控制台。
上面的代码定义了两个变量 `name` 和 `age`。
将变量名称输入可重新得到变量的值：

```jl
scob("name")
```

如果要为现有变量定义新值，可以重复赋值中的步骤。
请注意，Julia 现在将使用新值覆盖旧值。
假设 Julia 已经过了生日，现在是 10 岁：

```jl
scob("age = 10")
```

我们可以对 `name` 进行同样的操作。假设 Julia 因为惊人的速度获得了一些头衔。那么，我们可以更改 `name` 的值：

```jl
s = """
    name = "Julia Rapidus"
    """
scob(s)
```


也可以对变量进行乘除法等运算。
将 `age` 乘以 12，可以得到 Julia 以月为单位的年龄：

```jl
s = "12 * age"
scob(s)
```

使用 `typeof` 函数可以查看变量的类型：

```jl
sco("typeof(age)")
```

接下来的问题是：“我还能对整数做什么？”
Julia 中 有一个非常好用的函数 `methodswith` ，它可以为输出所有可用于指定类型的函数。
此处限制代码只显示前五行：

```jl
s = """
    first(methodswith(Int64), 5)
    """
sco(s; process=catch_show)
```

### 用户定义类型 {#sec:struct}

不凭借任何依赖关系或层次结构来组织多个变量是不现实的。
在 Julia 中，我们可以使用 `struct`（也称为复合类型）来定义结构化数据。
在每个 `struct` 中都可以定义一组字段。
它们不同于 Julia 语言内核中已经默认定义的原始类型（例如 `Integer` 和 `Float`）。
由于大多数 `struct` 都是用户定义的，因此它们也被称为用户定义类型。

例如，创建 `struct` 表示用于科学计算的开源编程语言。
在 `struct` 中定义一组相应类型的字段：

```jl
s = """
    struct Language
        name::String
        title::String
        year_of_birth::Int64
        fast::Bool
    end
    """
sco(s; post=x -> "")
```

可以通过将 `struct` 作为参数传递给 `fieldnames`检查字段名称列表：

```jl
sco("fieldnames(Language)")
```

要使用 `struct`，必须创建单个实例（或“对象”），每个`struct`实例的字段值都是特定的。
如下所示，创建两个实例 Julia 和 Python：

```jl
s = """
    julia = Language("Julia", "Rapidus", 2012, true)
    python = Language("Python", "Letargicus", 1991, false)
    """
sco(s)
```

`struct` 实例的值在构造后无法修改。
如果需要，可以创建 `mutable struct`。
但请注意，可变对象一般来说更慢且更容易出现错误。
因此，尽可能确保所有类型都是 **不可变的**。
接下来创建一个 `mutable struct`：

```jl
s = """
    mutable struct MutableLanguage
        name::String
        title::String
        year_of_birth::Int64
        fast::Bool
    end

    julia_mutable = MutableLanguage("Julia", "Rapidus", 2012, true)
    """
sco(s)
```

假设想要改变 `julia_mutable` 的标题。
因为 `julia_mutable` 是 `mutable struct` 的实例，所以该操作可行：

```jl
s = """
    julia_mutable.title = "Python Obliteratus"

    julia_mutable
    """
sco(s)
```

### 布尔运算和数值比较

上节讨论了类型，本节讨论布尔运算和数值比较。

Julia 中有三种布尔运算符：

* `!` &nbsp;： **NOT**
* `&&`： **AND**
* `||`： **OR**

一些例子如下：

```jl
scob("!true")
```

```jl
scob("(false && true) || (!false)")
```

```jl
scob("(6 isa Int64) && (6 isa Real)")
```

关于数值比较，Julia有三种主要的比较类型：

1. **相等**：两者的关系为 **相等** 或 **不等**
    * == "相等"
    * != 或 ≠ "不等"
1. **小于**: 两者的关系为 **小于** 或 **小于等于**
    * <  "小于"
    * <= 或 ≤ "小于等于"
1. **大于**: 两者的关系为 **大于** 或 **大于等于**
    * \> "大于"
    * \>= 或 ≥ "大于等于"

下面是一些例子：

```jl
scob("1 == 1")
```

```jl
scob("1 >= 10")
```

甚至可以比较不同类型：

```jl
scob("1 == 1.0")
```

还可以将布尔运算与数值比较：

```jl
scob("(1 != 10) || (3.14 <= 2.71)")
```

### 函数 {#sec:function}

上节学习了如何定义变量和自定义类型 `struct`，本节讨论 **函数**。
在 Julia 里，函数是 **一组参数值到一个或多个返回值的映射**。
基础语法如下所示：

```julia
function function_name(arg1, arg2)
    result = stuff with the arg1 and arg2
    return result
end
```

函数声明以关键字 `function` 开始，后接函数名称。
然后在 `()` 里定义参数， 这些参数由 `,` 分隔。
接着在函数体内部定义我们希望 Julia 对传入参数执行的操作。
函数里定义的所有变量都会在函数返回后删除。这很不错，因为有点像自动垃圾回收。
在函数体内的所有操作完成后，Julia 使用 `return` 关键字返回最终结果。
最后，Julia 以 `end` 关键字结束函数定义。

还有一种紧凑的 **赋值形式**：

```julia
f_name(arg1, arg2) = stuff with the arg1 and arg2
```

这种形式更加紧凑，但 **等效于** 前面的同名函数。
根据经验，当代码符合一行最多只有92字符时，紧凑形式更加合适。
否则，只需使用带 `function` 关键字的较长形式。
接下来深入讨论一些例子。

#### 创建函数 {#sec:function_example}

下面是一个将传入数字相加的函数：

```jl
s = """
    function add_numbers(x, y)
        return x + y
    end
    """
sco(s)
```

接下来调用 `add_numbers` 函数：

```jl
scob("add_numbers(17, 29)")
```

它也适用于浮点数：

```jl
scob("add_numbers(3.14, 2.72)")
```

另外，还可以通过制定类型声明来创建自定义函数行为。
假设创建一个 `round_number` 函数， 它在传入参数类型是 `Float64` 或 `Int64` 时进行不同的操作：

```jl
s = """
    function round_number(x::Float64)
        return round(x)
    end

    function round_number(x::Int64)
        return x
    end
    """
sco(s)
```

可以看到，它是具有多种方法的函数：

```jl
sco("methods(round_number)")
```

但问题是：如果想对 32 位浮点数 `Float32` 或者 8 位整数 `Int8` 作四舍五入，该怎么办？

如果想定义关于所有浮点数和整数类型的函数，那么需要使用 **abstract type** 作为函数签名， 例如 `AbstractFloat` 或 `Integer`：

```jl
s = """
    function round_number(x::AbstractFloat)
        return round(x)
    end
    """
sco(s)
```

现在该函数适用于任何的浮点数类型：

```jl
s = """
    x_32 = Float32(1.1)
    round_number(x_32)
    """
sco(s; process=(x -> sprint(show, x)), post=output_block)
```

> **_NOTE:_**
> 可以使用 `supertypes` 和 `subtypes` 函数查看类型间的关系。

接下来回到之前定义的 `Language` `struct`。
这就是一个多重派发的例子。
下面将扩展 `Base.show` 函数，该函数打印实例的类型和 `struct` 的内容。

默认情况下， `struct` 有基本的输出样式，正如在 `python` 例子中看到的那样。
可以为 `Language` 类型定义新的 `Base.show` 方法， 以便为编程语言实例提供更漂亮的输出。
该方法将更清晰地打印编程语言的姓名，称号和年龄。
函数 `Base.show` 接收两个参数，第一个是 `IO` 类型的 `io` ，另一个是 `Language` 类型的 `l`：

```jl
s = """
    Base.show(io::IO, l::Language) = print(
        io, l.name, ", ",
        2021 - l.year_of_birth, " years old, ",
        "has the following titles: ", l.title
    )
    """
sco(s; post=x -> "")
```

现在查看 `python` 如何输出：

```jl
sco("python")
```

#### 多返回值 {#sec:function_multiple}

一个函数可以返回两个以上的值。
下面看一个新函数 `add_multiply`：

```jl
s = """
    function add_multiply(x, y)
        addition = x + y
        multiplication = x * y
        return addition, multiplication
    end
    """
sco(s)
```

再接收返回值时，有两种写法：

1. 与返回值的形式类似，依次为每个返回值定义一个变量，在本例中则需要两个变量：

   ```jl
   s = """
       return_1, return_2 = add_multiply(1, 2)
       return_2
       """
   scob(s)
   ```

2. 也可以定义一个变量来接受所有的返回值，然后通过  `first` 或 `last` 访问每个返回值：

   ```jl
   s = """
       all_returns = add_multiply(1, 2)
       last(all_returns)
       """
   scob(s)
   ```

#### 关键字参数 {#sec:function_keyword_arguments}

某些函数可以接受关键字参数而不是位置参数。
这些参数与常规参数类似，只是定义在常规函数参数之后且使用分号 `;` 分隔。
例如，定义 `logarithm` 函数，该函数默认使用基 $e$ (2.718281828459045)作为关键字参数。
注意，此处使用抽象类型 `Real`，以便于覆盖从 `Integer` 和 `AbstractFloat` 派生的所有类型，这两种类型本身也都是 `Real` 的子类型：

```jl
scob("AbstractFloat <: Real && Integer <: Real")
```

```jl
s = """
    function logarithm(x::Real; base::Real=2.7182818284590)
        return log(base, x)
    end
    """
sco(s)
```

当未指定 `base` 参数时函数正常运行，这是因为函数声明中提供了 **默认参数** ：

```jl
scob("logarithm(10)")
```

同时也可以指定与默认值不同的 `base` 值：

```jl
s = """
    logarithm(10; base=2)
    """
scob(s)
```

#### 匿名函数 {#sec:function_anonymous}

很多情况下，我们不关心函数名称，只想快速创建函数。
因此我们需要 **匿名函数** 。
Julia 数据科学工作流中经常会用到它。
例如，在使用 `DataFrames.jl` (@sec:dataframes) 或 `Makie.jl` (@sec:DataVisualizationMakie) 时，时常需要一个临时函数来筛选数据或者格式化图标签。
这就是使用匿名函数的时机。
当我们不想创建函数时它特别有用，因为一个简单的 in-place 语句就够用了。

它的语法特别简单，
只需使用 `->` 。
`->` 的左侧定义参数名称。
 `->` 的右侧定义了想对左侧参数进行的操作。
考虑这样一个例子，
假设想通过指数函数来抵消对数运算：

```jl
scob("map(x -> 2.7182818284590^x, logarithm(2))")
```

这里使用 `map` 函数方便地将匿名函数（第一个参数）映射到了 `logarithm(2)` （第二个参数）。
因此，我们得到了相同的数字，因为指数运算和对数运算是互逆的（在选择相同的基 -- 2.7182818284590 时）。

### 条件表达式 If-Elseif-Else {#sec:conditionals}

在大多数语言中，用户可以控制程序的执行流。
我们可依据情况使计算机做这一件或另外一件事。
Julia 使用 `if`，`elseif` 和 `else` 关键字进行流程控制。
它们也被称为条件语句。

`if` 关键字执行一个表达式，,然后根据表达式的结果为 `true` 还是 `false` 执行相应分支的代码。
在复杂的控制流中，可以使用 `elseif` 组合多个 `if` 条件。
最后，如果 `if` 或 `elseif` 分支的语句都被执行为 `true`，那么我们可以定义另外的分支。
这就是 `else` 关键字的作用。
与之前见到的关键字运算符一样，我们必须告诉 Julia 条件语句以 `end` 关键字结束。

下面是一个包含所有 `if`-`elseif`-`else` 关键字的例子：

```jl
s = """
    a = 1
    b = 2

    if a < b
        "a is less than b"
    elseif a > b
        "a is greater than b"
    else
        "a is equal to b"
    end
    """
scob(s)
```

我们甚至可将其包装成函数 `compare`:

```jl
s = """
    function compare(a, b)
        if a < b
            "a is less than b"
        elseif a > b
            "a is greater than b"
        else
            "a is equal to b"
        end
    end

    compare(3.14, 3.14)
    """
sco(s)
```


### For 循环 {#sec:for}

Julia 中的经典 for 循环遵循与条件语句类似的语法。
它以 `for` 关键字开始。
然后，向 Julia 指定一组要 “循环” 的语句。
另外，与其他一样，它也以 `end` 关键字结束。

比如使用如下的 for 循环使 Julia 打印 1-10 的数字：
```jl
s = """
    for i in 1:10
        println(i)
    end
    """
sco(s; post=x -> "")
```

### while 循环 {#sec:while}

while 循环是前面的条件语句和 for 循环的结合体。
在 while 循环中，当条件为 `true` 时将一直执行循环体。
语法与之前的语句相同。
以 `while` 开始，紧跟计算结果为 `true` 或 `false` 的条件表达式。
它仍以 `end` 关键字结束。

例子如下：

```jl
s = """
    n = 0

    while n < 3
        global n += 1
    end

    n
    """
scob(s)
```

可以看到，我们不得不使用 `global` 关键字。
这是因为，
在条件语句中，循环和函数内定义的变量仅存在于其内部。
这就是变量的 **作用域** 。
我们需要通过 `global` 关键字告诉 Julia `while` 循环中的 `n` 是全局作用域中的 `n`。
最后，循环体使用的 `+=` 运算符是 `n = n + 1` 的缩写。

## 原生数据结构 {#sec:data_structures}

Julia 有多种原生数据结构。
它们都是某种结构化数据形式的抽象。
本书将讨论最常用的数据结构。
它们都能够保存同类型或异构的数据。
因为它们都是集合， 所以都能通过 `for` 循环进行 **遍历** 。
接下来的讨论包括 `String`， `Tuple`， `NamedTuple`， `UnitRange`， `Arrays`， `Pair`， `Dict`, `Symbol`。

当在 Julia 中偶然发现某种数据结构时，可以使用 `methodswith` 函数查看能接收该数据结构作为参数的方法。
Julia 中方法和函数的区别如下。
如前面讨论的那样，每一个函数对应多种方法。
因此值得将 `methodswith` 函数收藏到你的技巧包里。
例如，让我们看看当对 `String` 应用该函数时会发生什么：

```jl
s = "first(methodswith(String), 5)"
sco(s; process=catch_show)
```

### 对运算符和函数进行广播 {#sec:broadcasting}

在深入研究数据结构前，我们需要先讨论广播（也被称为 **向量化**）和 `.` 点运算符。

可以使用点运算符广播像 `*` （乘）或 `+`（加）这样的数学运算。
例如，添加广播只需将 `+` 改为 `.+`：

```jl
sco(
"""
[1, 2, 3] .+ 1
"""
)
```

函数也能通过这种操作实现广播。
（技术上讲，数学运算或中缀运算符也是函数，但这不重要。）
还记得 `logarithm` 函数吗？

```jl
sco("logarithm.([1, 2, 3])")
```

### 带感叹号 `!` 的函数 {#sec:function_bang}

当函数改变了一个或多个它们的参数时， 按照 Julia 惯例，应该在函数名后追加 `!` 。
这个惯例警告用户该函数 **并不单纯**，它具有 **副作用**。
当想要更新大型数据结构或变量容器时，具有 **副作用** 的 Julia 函数非常有用，因为它不存在创建新实例的所有开销。

例如，可以定义一个函数，它将向量 `V` 的每个元素加1：

```jl
s = """
    function add_one!(V)
        for i in 1:length(V)
            V[i] += 1
        end
        return nothing
    end
    """
sc(s)
```

```jl
s = """
    my_data = [1, 2, 3]

    add_one!(my_data)

    my_data
    """
sco(s)
```

### 字符串 {#sec:string}

Julia 中使用双引号分隔符表示 **字符串** :

```jl
s = """
    typeof("This is a string")
    """
sco(s)
```

也可以定义一个多行字符串：

```jl
s = """
    text = "
    This is a big multiline string.
    As you can see.
    It is still a String to Julia.
    "
    """
sco(s; post=output_block)
```

但使用三引号通常更清晰：

```jl
sco("""
s = \"\"\"
    This is a big multiline string with a nested "quotation".
    As you can see.
    It is still a String to Julia.
    \"\"\"
"""; post=output_block)
```

当使用三引号时，Julia 会忽略开头的缩进和换行。
这提升了代码可读性，因为你需要缩进代码，但这些空格不能截断字符串。

#### 字符串连接 {#sec:string_concatenation}

一个常见的字符串操作就是 **字符串连接**。
假设你想通过连接两个或多个字符串来创建一个新的字符串。
这在 Julia 中可以通过 `*` 运算符或 `join` 函数实现。
这个符号看起来是一个令人费解的选择，事实上也确实费解。
现在，许多 Julia 基础库都在使用该符号，因此它也被保留在 Julia 语言中。
如果你感兴趣，可以阅读 2015 年 GitHub 上关于它的讨论：
<https://github.com/JuliaLang/julia/issues/11030>.

```jl
s = """
    hello = "Hello"
    goodbye = "Goodbye"

    hello * goodbye
    """
scob(s)
```

如上所示，代码将会自动忽略 `hello` 和 `goodbye` 之间的空格。
可以使用 `*` 连接额外的字符串 `" "`以添加空格，但当连接两个以上字符串时会变得很笨重。
此时就是 `join` 的用武之地。
仅仅需要将 `[]` 中的字符串和分隔符作为参数传递：

```jl
scob("""join([hello, goodbye], " ")""")
```

#### 字符串插值 {#sec:string_interpolation}

连接字符串可能会变得很复杂。
我们也可以使用 **字符串插值** 更直观地实现某些功能。
它看来就是：使用美元符号 `$` 在字符串中插入你想包含的内容。
以下是之前的例子，改为使用字符串插值:

```jl
s = """
    "\$hello \$goodbye"
    """
scob(s)
```

甚至也支持在函数中进行字符串插值。
回到 @sec:conditionals 中的 `test` 函数，并用插值重新实现：

```jl
s = """
    function test_interpolated(a, b)
        if a < b
            "\$a is less than \$b"
        elseif a > b
            "\$a is greater than \$b"
        else
            "\$a is equal to \$b"
        end
    end

    test_interpolated(3.14, 3.14)
    """
scob(s)
```

#### 字符串处理 {#sec:string_manipulations}

Julia 中有多个函数处理字符串。
接下来将讨论那些最常用的函数。
另外注意，这些函数大多数都支持 [正则表达式 (RegEx)](https://docs.julialang.org/en/v1/manual/strings/#Regular-Expressions) 作为参数。
本书不包含 RegEx，但可以自主学习，尤其是如果你的大多数工作都需要处理文本数据。

首先，定义一个供后续使用的字符串：

```jl
s = """
    julia_string = "Julia is an amazing open source programming language"
    """
scob(s)
```


1. `contains`， `startswith` 和 `endswith`： 条件函数 （返回 `true` 或 `false`） 如果第二个参数是：
    * 第一个参数的 **子串**

       ```jl
       scob("""contains(julia_string, "Julia")""")
       ```

    * 第一个参数的 **前缀**

       ```jl
       scob("""startswith(julia_string, "Julia")""")
       ```

    * 第一个参数的 **后缀**

       ```jl
       scob("""endswith(julia_string, "Julia")""")
       ```

2. `lowercase`， `uppercase`， `titlecase` 和 `lowercasefirst`：

     ```jl
     scob("lowercase(julia_string)")
     ```

     ```jl
     scob("uppercase(julia_string)")
     ```

     ```jl
     scob("titlecase(julia_string)")
     ```

     ```jl
     scob("lowercasefirst(julia_string)")
     ```

3. `replace`：介绍一种称为 `Pair` 的新语法：

     ```jl
     scob("""replace(julia_string, "amazing" => "awesome")""")
     ```

4. `split`：使用分隔符分隔字符串：

     ```jl
     sco("""split(julia_string, " ")""")
     ```

#### 字符串转换 {#sec:string_conversions}

我们经常需要在 Julia 中 **转换** 类型。
可以使用 `string` 函数将数字转为字符串：

```jl
s = """
    my_number = 123
    typeof(string(my_number))
    """
sco(s)
```

有时需要逆向操作：将字符串转为数字。
Julia 中有个方便的函数 `parse`。

```jl
sco("""typeof(parse(Int64, "123"))""")
```

时常希望能够安全地进行这些转换。
此时就需要介绍 `tryparse` 函数。
它具有与 `parse` 相同的功能，但只会返回请求类型的值或者`nothing`。
当我们想要避免错误时 `tryparse` 会变得很有用。
当然，你需要之后手动处理这些 `nothing` 值。

```jl
sco("""tryparse(Int64, "A very non-numeric string")""")
```

### 元组（Tuple） {#sec:tuple}

Julia 中有一类名为 **元组** 的**特殊**数据类型。
它们经常用在函数中，而函数又是 Julia 的重要组成部分，因此每一个 Julia 用户都应该了解元组的基础。

元组是**包含多种不同类型的固定长度容器**.
同时元组是 **不可变对象**，这意味着实例化后不能更改。
创建元组的方法是：使用 `()` 作为开头和结尾，并使用 `,` 作为值间的分隔符：

```jl
sco("""my_tuple = (1, 3.14, "Julia")""")
```

这里创建了包含三个值的元组。
每一个值都是不同的类型。
可以使用索引访问每一个元素。
如下所示：

```jl
scob("my_tuple[2]")
```

也可以使用 `for` 关键字遍历元组。
还将函数作用于元组。
但 **永远不能改变元组的每一个值** ， 因为它们是 **不可变的**。

还记得 @sec:function_multiple 中返回多个值的函数吗？
查看 `add_multiply` 函数返回值的类型：

```jl
s = """
    return_multiple = add_multiply(1, 2)
    typeof(return_multiple)
    """
sco(s)
```

这是因为 `return a, b` 与 `return (a, b)` 等价：

```jl
sco("1, 2")
```

现在就可以发现它们之间的联系了。

关于元组还有一种用法。
**当想给匿名函数传递多个变量时，猜猜你需要用什么？ 当然还是元组！**

```jl
scob("map((x, y) -> x^y, 2, 3)")
```

或两个以上参数：

```jl
scob("map((x, y, z) -> x^y + z, 2, 3, 1)")
```

### 命名元组 {#sec:namedtuple}

有时需要给元组中的值命名。
这就是需要用 **命名元组 (named tuple)** 的地方。
它的功能基本与元组一致：
它是 **不可变的**，并且能够接收 **任意类型的值**。

命名元组的构造与元组的构造稍有不同。
你已经熟悉使用括号 `()` 和逗号 `,` 分隔符。
但现在你需要 **给值命名**：

```jl
sco("""my_namedtuple = (i=1, f=3.14, s="Julia")""")
```

可以向元组那样通过索引访问命名元组的元素。另外，还可以使用 `.` **结合名称访问**。

```jl
scob("my_namedtuple.s")
```

为了完成命名元组的讨论，下面介绍一种 Julia 代码中常见的 **快捷** 语法。
Julia 用户通常使用括号 `()` 和逗号 `,` 创建命名元组，但并没有命名值。
为了给值命名，**在命名元组的构造开始时，首先在值之前添加 `;`**。
当组成命名元组的值已经在变量中定义，或者你想避免过长的行时，这一语法非常有用：

```jl
s = """
    i = 1
    f = 3.14
    s = "Julia"

    my_quick_namedtuple = (; i, f, s)
    """
sco(s)
```

### Ranges {#sec:ranges}

Julia 中的 **range** 表示一段开始和结束边界之间的序列。
语法是 `start:stop`：

```jl
sco("1:10")
```

如下所示， range 实例的类型是 `UnitRange{T}` ，其中 `T` 是 `UnitRange` 中元素的类型：

```jl
sco("typeof(1:10)")
```

如果收集所有值将得到：

```jl
sco("[x for x in 1:10]")
```

也可以构造其它类型的 range：

```jl
sco("typeof(1.0:10.0)")
```

有时希望改变序列默认的步长。
这可以通过在 range 语法中添加步长实现，即 `start:step:stop`。
例如，假设想要得到从 0 到 1，步长为 0.2 的  `Float64` range ：

```jl
sco("0.0:0.2:1.0")
```

如果要将 range “实例化” 到集合中， 可以使用函数 `collect`：

```jl
sco("collect(1:10)")
```

这将得到一个边界范围内的指定类型数组。
既然提到数组，那接下来就讨论它。

### 数组 {#sec:array}

在最基本的形式中， **数组**能够包含多种对象。
例如，一维数组可以包含多个数。

```jl
sco("myarray = [1, 2, 3]")
```

大多数情况下，**由于性能原因需要构造单一类型的数组**，但请注意它们也可以包含不同类型的对象：

```jl
sco("myarray = [\"text\", 1, :symbol]"; process=output_block)
```

数组是数据科学家的生计之道，因为它们是大多数 **数据操作** 和 **数据可视化** 工作流的基础。

因此，**数组是非常重要的数据结构**。

#### 数组类型 {#sec:array_types}

首先以 **数组类型** 开始。
这里有很多中类型，但本节主要关注数据科学中两种最常用的类型：

* `Vector{T}`: **一维** 数组。 `Array{T, 1}` 的别名。
* `Matrix{T}`: **二维** 数组。 `Array{T, 2}` 的别名。

注意这里的 `T` 是数组元素的类型。
例如， `Vector{Int64}` 表示所有元素的类型都是 `Int64` 的 `Vector`。另外 `Matrix{AbstractFloat}` 表示一个`Matrix`，其中所有元素的类型都是 `AbstractFloat` 的子类型。

大多数情况下，特别是在处理表格数据时，我们使用的是一维或二维数组。
它们都是 Julia 中的 `Array` 类型。
但是，可以使用简洁清晰的语法操作 `Vector` 和 `Matrix`。

#### 数组构造 {#sec:array_construction}

如何 **构造** 数组呢？
本届的开始，我们使用低级的方式构造数组。
在某些情况下，编写高性能代码就需要这样的做法。
然而，在大多数情况下，这不是必需的。同时可以安全地使用更简便的方法创建数组。
本节稍后讨论这些更简便的方法。

用于 Julia 数组的低级构造器是 **默认构造器**。
它接手元素类型作为 `{}` 括号内的类型参数，并将元素类型传递到构造器里，构造器后跟需要的维度。
通常使用未定义元素初始化向量和矩阵，即将 `undef` 参数作为传递到构造器里的类型。
如下构造一个含 10 个 `undef` `Float64`元素的向量：

```jl
s = """
    my_vector = Vector{Float64}(undef, 10)
    """
sco(s)
```

矩阵的构造方式是，向构造器传递两个维度参数：一个用于 **行** ，另一个用于 **列**。
例如，具有 10 行 2列 `undef` 元素的矩阵以如下方式实例化：

```jl
s = """
    my_matrix = Matrix{Float64}(undef, 10, 2)
    """
sco(s)
```

对于构造最常见元素类型的数组，Julia 中有一些**语法别名** ：

* `zeros` 将所有元素初始化为 0。
  注意默认类型为 `Float64`，如果需要可以更改类型：

     ```jl
     s = """
         my_vector_zeros = zeros(10)
         """
     sco(s)
     ```

     ```jl
     s = """
         my_matrix_zeros = zeros(Int64, 10, 2)
         """
     sco(s)
     ```

* `ones` 将所有元素初始化为 1。

     ```jl
     s = """
         my_vector_ones = ones(Int64, 10)
         """
     sco(s)
     ```

     ```jl
     s = """
         my_matrix_ones = ones(10, 2)
         """
     sco(s)
     ```

对于其他的元素，可以先创建全为 `undef` 元素的数组，然后使用 `fill!` 函数将想要的元素填充到数组的每一个元素上。
下面是一个关于 `3.14`（$\pi$） 的例子：

```jl
s = """
    my_matrix_π = Matrix{Float64}(undef, 2, 2)
    fill!(my_matrix_π, 3.14)
    """
sco(s)
```

也可以使用 **数组字面量** 创建数组：
例如，这是 2x2 的整数数组：

```jl
s = """
    [[1 2]
     [3 4]]
    """
sco(s)
```

数组字面量能在 `[]` 括号前接收指定的类型。
所以，如果想得到与之前相同的数组，但类型应是浮点数，那么应按如下定义：

```jl
s = """
    Float64[[1 2]
            [3 4]]
    """
sco(s)
```

这也能够用于向量：

```jl
s = """
    Bool[0, 1, 0, 1]
    """
sco(s)
```

甚至可以使用数组构造器 **组合和匹配** 数组字面量：

```jl
s = """
    [ones(Int, 2, 2) zeros(Int, 2, 2)]
    """
sco(s)
```

```jl
s = """
    [zeros(Int, 2, 2)
     ones(Int, 2, 2)]
    """
sco(s)
```


```jl
s = """
    [ones(Int, 2, 2) [1; 2]
     [3 4]            5]
    """
sco(s)
```

另一种创建数组的强大方法是 **数组推断**（**array comprehension**）。
这种创建数组的方式在大多数情况下更好：因为它能够避免循环，索引以及其他容易出错的操作。
你可以在 `[]` 括号内编写要执行的语句。
例如，你想创建一个包含 1 到 10 的平方的向量：

```jl
s = """
    [x^2 for x in 1:10]
    """
sco(s)
```

它也支持多个输入：

```jl
s = """
    [x*y for x in 1:10 for y in 1:2]
    """
sco(s)
```

另外还能使用条件语句：

```jl
s = """
    [x^2 for x in 1:10 if isodd(x)]
    """
sco(s)
```

结合数组字面量，你还可以在 `[]` 括号前指定需要的类型：

```jl
s = """
    Float64[x^2 for x in 1:10 if isodd(x)]
    """
sco(s)
```

最后，还可以使用 **串联函数** 创建数组。
串联是计算机编程中的标准术语，意为 “连接在一起”。
例如， 将字符串 `"aa"` 和 `"bb"` 串联并得到 `"aabb"`：

```jl
s = """
    "aa" * "bb"
    """
sco(s)
```

因此，也可以通过串联数组来创建数组：

* `cat`：沿着指定的 `dims` 串联输入的数组

     ```jl
     sco("cat(ones(2), zeros(2), dims=1)")
     ```

     ```jl
     sco("cat(ones(2), zeros(2), dims=2)")
     ```

* `vcat`: 垂直串联， `cat(...; dims=1)` 的缩写

     ```jl
     sco("vcat(ones(2), zeros(2))")
     ```

* `hcat`: 水平串联， `cat(...; dims=2)` 的缩写

     ```jl
     sco("hcat(ones(2), zeros(2))")
     ```

#### 数组检测 {#sec:array_inspection}

当拥有一些数组时，下一步应是对它们进行 **检测** 。
Julia 中提供了许多方便的函数，这使得用户能够检测任何数组。

知道数组中的 **元素类型** 是非常有用的。
这会用到 `eltype` 函数：

```jl
sco("eltype(my_matrix_π)")
```

了解到类型后，可能还会对 **数组的维度** 感兴趣。
Julia 中有多个用于检测数组维度的函数：

* `length`: 元素的总数

     ```jl
     scob("length(my_matrix_π)")
     ```

* `ndims`: 维度的个数

     ```jl
     scob("ndims(my_matrix_π)")
     ```

* `size`: 此例有一些复杂。
    默认情况下将返回包含所有数组维度的元组。

     ```jl
     sco("size(my_matrix_π)")
     ```

    你可以在`size`的第二个参数指定想要的维度。
    如下，第二个轴为列：

     ```jl
     scob("size(my_matrix_π, 2)")
     ```

#### 数组索引和切片 {#sec:array_indexing}

有时希望仅仅检测数组的一部分。
这就需要 **索引** 和 **切片**。
如果想要考察向量的某一部分，或者矩阵的某一行或某一列，那么你可能需要 **索引数组**。

首先创建一个向量和矩阵作为示例：

```jl
s = """
    my_example_vector = [1, 2, 3, 4, 5]

    my_example_matrix = [[1 2 3]
                         [4 5 6]
                         [7 8 9]]
    """
sc(s)
```

首先考虑向量。
假设要访问向量的第二个元素。
你只需要在 `[]` 括号内添加对应**索引**：

```jl
scob("my_example_vector[2]")
```

关于矩阵的语法也是如此。
但因为矩阵是二维数组，需要 **同时** 指定行和列。
接下来检索位于第二行（第一维）、第一列（第二维）的元素：

```jl
scob("my_example_matrix[2, 1]")
```

Julia 也为数组的 **第一个** 和 **最后一个** 元素定义了特殊的关键字： `begin` 和 `end`。
例如，可以如下方式检索向量的倒数第二个元素：

```jl
scob("my_example_vector[end-1]")
```

这也适用于矩阵。
可以如下方式检索位于最后一行、第二列的元素。

```jl
scob("my_example_matrix[end, begin+1]")
```

通常我们不仅对单个数组元素感兴趣，还想获得 **数组的子集**。
这可以通过数组 **切片** 实现。
它使用与索引相同的语法，但需要添加冒号 `:` 来表示数组切片的边界。
例如，假设想要获得向量的第二个到第四个元素：

```jl
sco("my_example_vector[2:4]")
```

可以对矩阵作同样的事。
特别地，对于矩阵，仅使用冒号 `:` 就可以获得指定维度的所有元素。
例如，想要获得第二行的所有元素。

```jl
sco("my_example_matrix[2, :]")
```

上面这段代码可被解释为 “获取第二行的所有列”。

矩阵同样支持 `begin` 和 `end`：

```jl
sco("my_example_matrix[begin+1:end, end]")
```

#### 数组操作 {#sec:array_manipulation}

我们有多种 **操作** 数组的方式。
第一种操作数组的方式是 **数组的单个元素**。
只需索引数组的单个元素，则使用等号 `=` 赋值：

```jl
s = """
    my_example_matrix[2, 2] = 42
    my_example_matrix
    """
sco(s)
```

另外，也可以操作**数组的子集**。
在此例中，对数组进行切片并使用 `=` 赋值：
```jl
s = """
    my_example_matrix[3, :] = [17, 16, 15]
    my_example_matrix
    """
sco(s)
```

注意，此处使用向量赋值，这是因为数组切片的类型就是 `Vector`：

```jl
s = """
    typeof(my_example_matrix[3, :])
    """
sco(s)
```

第二种操作数组的方式是 **改变形状**。
假设你有 6 个元素的向量，但想将其变成 3x2 的矩阵。
这可以通过 `reshape` 实现，具体操作是将数组传递给第一个参数，并将维度构成的元组传递给第二个参数。

```jl
s = """
    six_vector = [1, 2, 3, 4, 5, 6]
    three_two_matrix = reshape(six_vector, (3, 2))
    three_two_matrix
    """
sco(s)
```

通过指定只有 1 维的维度元组，你可以将其变回向量：

```jl
sco("reshape(three_two_matrix, (6, ))")
```

第三种操作数组的方式是 **按元素应用函数**。
这会用到点运算符 `.`，其也被称为 **广播**。

```jl
sco("logarithm.(my_example_matrix)")
```

Julia中的点运算符非常通用。
可以使用它广播中缀运算符：

```jl
sco("my_example_matrix .+ 100")
```

另一种在向量中广播函数的方法是使用 `map`：

```jl
sco("map(logarithm, my_example_matrix)")
```

对于匿名函数， `map` 通常可读性更好。
例如，

```jl
sco("map(x -> 3x, my_example_matrix)")
```

上面的例子看起来相当清晰。
不过，如下的广播代码也能实现相同功能：

```jl
sco("(x -> 3x).(my_example_matrix)")
```

其次，`map` 也适用于数组切片：

```jl
sco("map(x -> x + 100, my_example_matrix[:, 3])")
```

最后，在某些情况下，特别是处理表格数据时，我们想要 **沿着特定的数组维度应用函数**。
这可以通过 `mapslices` 函数实现。
与 `map` 类似，第一个元素是函数而第二个元素是数组。
唯一的变化是，需要传入 `dims` 参数指定操作数组元素的维度。

例如，将 `sum` 函数传给 `mapslices`，维度参数分别指定为行（`dims=1`）和列（`dims=2`）：

```jl
sco(
"""
# rows
mapslices(sum, my_example_matrix; dims=1)
"""
)
```

```jl
sco(
"""
# columns
mapslices(sum, my_example_matrix; dims=2)
"""
)
```

#### 数组迭代 {#sec:array_iteration}

常见的操作是 **使用 `for` 循环迭代数组**。
**应用于数组的 `for` 循环会逐个返回元素**。

最简单的例子是迭代向量。

```jl
sco(
"""
simple_vector = [1, 2, 3]

empty_vector = Int64[]

for i in simple_vector
    push!(empty_vector, i + 1)
end

empty_vector
"""
)
```

有时，你不想要迭代数组的每个元素，而是迭代每个数组索引。
**可以使用 `eachindex` 函数结合 `for` 循环来迭代每个数组索引**。

然后，此处也展示一个向量的例子：

```jl
sco(
"""
forty_twos = [42, 42, 42]

empty_vector = Int64[]

for i in eachindex(forty_twos)
    push!(empty_vector, i)
end

empty_vector
"""
)
```

在上例中，`eachindex(forty_twos)` 函数返回的是 `forty_twos`的索引，即 `[1, 2, 3]`。

类似地，也可以迭代矩阵。
标准 `for` 循环的迭代顺序是先列后行。
它首先遍历第 1 列的所有元素，从第一行和最后一行，然后对第2列进行同样的遍历，直到循环完所有列。

对于熟悉其他编程语言的用户：
与大多数科学计算编程语言一样，Julia 是“列优先存储”。
列优先存储意味着每一列的元素在内存中的存储位置是相邻的[^pointers]。
这也意味着，沿列遍历会比沿行遍历更快。

[^pointers]: 或者说，指向每一列元素的内存地址指针相邻存储。

所以，查看如下的例子：

```jl
sc(
"""
column_major = [[1 3]
                [2 4]]

row_major = [[1 2]
             [3 4]]
"""
)
```

如果遍历的是以列优先方式存储的向量，那么结果将是有序的：

```jl
sco(
"""
indexes = Int64[]

for i in column_major
    push!(indexes, i)
end

indexes
"""
)
```

然而，如果遍历的是以其他方式存储的向量，那么结果将不是有序的：

```jl
sco(
"""
indexes = Int64[]

for i in row_major
    push!(indexes, i)
end

indexes
"""
)
```

通常更好的做法是，在进行这些循环时使用特定的函数：

* `eachcol`: 先沿着列方向迭代

     ```jl
     sco("first(eachcol(column_major))")
     ```

* `eachrow`: 先沿着行方向迭代

     ```jl
     sco("first(eachrow(column_major))")
     ```

### Pair {#sec:pair}

与有关数组的超长章节相比，关于 Pair 的章节将是简短的。
**`Pair` 是一种包含两个对象的数据结构** （一般属于彼此）。
在 Julia 中，可以使用如下的语法构造 `Pair`：

```jl
sco("""my_pair = "Julia" => 42""")
```

这两个元素分别存储在字段 `first` 和 `second`。

```jl
scob("my_pair.first")
```

```jl
scob("my_pair.second")
```

但，在大多数情况下，使用 `first` 和 `last` 更简单[^easier]：

```jl
scob("first(my_pair)")
```

```jl
scob("last(my_pair)")
```

[^easier]: 更简单的原因是 `first` 和 `last` 也适用于其他集合，所以需要记住的就更少。

`Pair` 广泛应用于数组操作和数据可视化。本书的 `DataFrames.jl` (@sec:dataframes) 和 `Makie.jl` (@sec:DataVisualizationMakie) 章节将会在主要程序函数中用到由各种对象构成的 `Pair`。
例如，在 `DataFrames.jl` 这一章，可以看到 `:a => :b` 的用途是将 `:a` 重命名为 `:b`。

### 字典 {#sec:dict}

如何你理解什么是 `Pair`， 那么理解 `Dict` 也不会成为问题。
实际上，**`Dict`是从键 (key) 到值 (values) 的映射**。
映射的意思是说，如果你向 `Dict` 提供一些键，然后 `Dict` 能够告诉你哪些值属于这些键。
`key` 和 `value` 可以是任何类型，但 `key` 通常是字符串。

Julia 中有两种构造 `Dict` 的方法。
第一种是向 `Dict` 构造器传递由 `(key, value)` 元组构成的向量：

```jl
sco(
"""
# tuples # hide
name2number_map = Dict([("one", 1), ("two", 2)])
"""
)
```

还有一种可读性更高的写法，其基于上节中提到的 `Pair` 类型。
即也可以向 `Dict` 构造器传递多组 `key => value` 这样的 `Pair`：

```jl
sco(
"""
# pairs # hide
name2number_map = Dict("one" => 1, "two" => 2)
"""
)
```

使用相应的 `key` 作为索引即可检索到 `Dict` 的 `value`：

```jl
scob("""name2number_map["one"]""")
```

如果要增加新的条目，可使用所需的 `key` 作为 `Dict` 的索引，并使用赋值运算符为其赋值 `value` ：

```jl
scob(
"""
name2number_map["three"] = 3
"""
)
```

可以使用 `keys` 和 `in` 检查一个 `Dict` 是否有特定的 `key`：

```jl
scob("\"two\" in keys(name2number_map)")
```

可以使用 `delete!` 函数删除 `key`：

```jl
sco(
"""
delete!(name2number_map, "three")
"""
)
```

或者，可以使用 `pop!` 函数在返回值时删除键:

```jl
scob("""popped_value = pop!(name2number_map, "two")""")
```

现在， `name2number_map` 仅有一个 `key`：

```jl
sco("name2number_map")
```

`DataFrames.jl` (@sec:dataframes) 中的数据操作和 `Makie.jl` (@sec:DataVisualizationMakie) 中的数据可视化也用到了很多 `Dict`。
因此，了解它们的基本功能十分重要。

另外还有一种非常有用的 `Dict` 构造方法。
假设有两个向量，然后想用它们要构造一个 `Dict`，即其中一个作为 `key`，另一个作为 `value`。
那么可以使用 `zip` 函数将两个对象 “粘合” 起来（就像拉链那样）：

```jl
sco(
"""
A = ["one", "two", "three"]
B = [1, 2, 3]

name2number_map = Dict(zip(A, B))
"""
)
```

例如，获得数字 3 的方式为：

```jl
scob("""name2number_map["three"]""")
```

### Symbol {#sec:symbol}

`Symbol` 实际上 **并不是** 一种数据结构。
它是一种类型，并且其行为类似于字符串。
与引号包围文本的字符串不同，`Symbol` 以冒号 (:) 开始并且可以包含下划线：

```jl
sco("sym = :some_text")
```

可以轻松地将 `Symbol` 转换为字符串，反之亦然：

```jl
scob("s = string(sym)")
```

```jl
sco("sym = Symbol(s)")
```

使用 `Symbol` 的好处是会少键入一个字符，即 `:some_text` 相对于 `"some text"` 。
`DataFrames.jl` (@sec:dataframes) 中的数据操作和 `Makie.jl` (@sec:DataVisualizationMakie) 中的数据可视化将会多次用到 `Symbol`。

### Splat 运算符 {#sec:splat}

Julia 中有一种 `splatting` 运算符 `...`，它被用于在函数调用时转换 **参数序列**。
在 **数据操作** 和 **数据可视化** 章节中，我们偶尔会在调用某些函数时使用 `splatting` 。

结合例子学习 `splatting`是最直观的方法。
如下的 `add_elements` 函数将传入的三个参数相加：

```jl
sco("add_elements(a, b, c) = a + b + c")
```

现在，假设有一个三个元素构成的集合。
一种普通的方法是，将集合的三个元素逐个传递为函数参数，如下所示：

```jl
scob("""
my_collection = [1, 2, 3]

add_elements(my_collection[1], my_collection[2], my_collection[3])
""")
```

接下来使用展开运算符 `...`，它将接收一个集合（通常是数组，向量，元组，或 `range`）并将其转化为参数序列：

```jl
scob("add_elements(my_collection...)")
```

集合后的 `...` 用于将集合转化为参数序列。
对于上述例子，两种传入参数的方式等价：

```jl
scob("""
add_elements(my_collection...) == add_elements(my_collection[1], my_collection[2], my_collection[3])
""")
```

任何时候，若 Julia 在函数调用中发现了展开运算符，那么它会将运算符前的集合转化为一组逗号分隔的参数序列。

这也适用于 range 类型：

```jl
scob("add_elements(1:3...)")
```

## 文件系统 {#sec:filesystem}

在数据科学中，大多数项目都是协作完成的。
开发者会共享代码，数据，表格，图像等等。
这一切的背后都是 **操作系统 (OS) 和文件系统**。
在完美的世界中，当运行在 **不同** 的操作系统时，相同的程序会给出 **相同** 的输出。
不幸的是，世界并不总是如此。
一个常见的差异是不同系统的用户目录，对于 Windows 是 `C:\Users\john\`，而对于 Linux 是  `/home/john`。
这就是为什么讨论 **文件系统最佳实践** 很重要。

Julia 中内置了 **处理不同操作系统差异** 的功能。
这一部分位于 Julia 核心库 `Base` 的 [`Filesystem`](https://docs.julialang.org/en/v1/base/file/) 模块。

每当需要处理 CSV，Excel 文件或其他 Julia 脚本时，请确保代码能够运行 **在不同操作系统的文件系统** 上。
这可以通过 `joinpath`， `@__FILE__` 和 `pkgdir` 函数轻松实现。

当在包中开发代码时，可以使用 `pkgdir` 获取包的根目录。
例如，对于用来生成本书的 Julia Data Science (JDS) 包：

```jl
root = pkgdir(JDS)
```

如上所示，用来生成本书的代码运行在 Linux 电脑上。
在使用脚本时，可以使用如下方式获得脚本文件的路径：

```julia
root = dirname(@__FILE__)
```

这两条命令的优点是它们与启动 Julia 的方式无关。
换句话说，无论以 `julia scripts/script.jl` 还是 `julia script.jl` 方式启动程序，两种方式每次返回的路径都是相同的。

接下来建立从 `root` 到脚本文件的相对路径。
因为不同的操作系统采用不同的方式组织子文件夹的相对路径（一些采用斜杠 `/`，而另一些使用反斜杠 `\`），所以不能简单地通过字符串连接组合 `root` 路径与文件的相对路径。
因此需要使用 `joinpath` 函数，它将根据特定的文件系统实现，采用相应的方式连接不同的相对路径和文件名。

假设项目目录中存在一个名为 `my_script.jl` 的脚本。
`my_script.jl` 文件路径的健壮实现如下所示：

```jl
scob("""joinpath(root, "my_script.jl")""")
```

`joinpath` 也能处理 **子目录**。
接下来考虑一种普遍的情形，项目目录中有一个名为 `data/` 的子文件夹。
此文件夹中有一个名为 `my_data.csv` 的 CSV 文件。
同样地，此 `my_script.jl` 文件路径的健壮实现如下所示：

```jl
scob("""joinpath(root, "data", "my_data.csv")""")
```

这是一个好习惯，因为它能为你或后来者避免问题。

## Julia 标准库 {#sec:standardlibrary}

Julia 拥有 **丰富的标准库**，每个 Julia 发行版都可以使用这些库。
与截至目前提到的一切相反，例如类型，数据结构和文件系统；在使用特定的模块或函数前， **需要将标准库模块导入到环境中**。


这可以通过 `using` 或 `import`实现。
本书将使用 `using` 导入代码：

```julia
using ModuleName
```

在执行上述操作后，就可以使用 `ModuleName` 中所有的函数和类型。

### 日期 {#sec:dates}

了解如何处理日期和时间戳在数据科学中很重要。
正如在 **为什么选择 Julia?** (@sec:why_julia) 节讨论的那样，Python 中的 `pandas` 使用它自己的 `datetime` 类型处理日期。
R 语言中 TidyVerse 的 `lubridate` 包中也是如此，它也定义了自己的 `datetime` 类型来处理日期。
在 Julia 软件包中，不需要编写自己的日期逻辑，因为 Julia 标准库中有一个名为 `Dates` 的日期处理模块。

首先加载 `Dates` 模块到工作空间中：

```julia
using Dates
```

#### `Date` and `DateTime` Types {#sec:dates_types}

`Dates` 标准库模块有 **两种处理日期的类型**:

1. `Date`: 表示以天为单位的时间和
2. `DateTime`: 表示以毫秒为单位的时间。

构造 `Date` 和 `DateTime` 的方法是，向默认构造器传递表示年，月，日，小时等等的整数：

```jl
sco(
"""
Date(1987) # year
"""
)
```

```jl
sco(
"""
Date(1987, 9) # year, month
"""
)
```

```jl
sco(
"""
Date(1987, 9, 13) # year, month, day
"""
)
```

```jl
sco(
"""
DateTime(1987, 9, 13, 21) # year, month, day, hour
"""
)
```

```jl
sco(
"""
DateTime(1987, 9, 13, 21, 21) # year, month, day, hour, minute
"""
)
```

好奇的人会发现，1987 年 9 月 13 日 21 点 21 分正是第一作者 Jose 的官方出生时间。

也可以向默认构造器传递 `Period` 类型。
对于计算机来说，**`Period` 类型是时间的等价表示**。
Julia 的 `Dates` 具有如下的 `Period` 抽象类型：

```jl
sco("subtypes(Period)")
```

它被划分为如下的具体类型，并且它们的用法都是不言自明的：

```jl
sco("subtypes(DatePeriod)")
```

```jl
sco("subtypes(TimePeriod)")
```

因此，也能以如下方式构造 Jose 的官方出生时间：

```jl
sco("DateTime(Year(1987), Month(9), Day(13), Hour(21), Minute(21))")
```

#### 序列化 Dates {#sec:dates_parsing}

多数情况下，我们不会从零开始构造 `Date` 或 `DateTime` 示例。
实际上更可能是 **将字符串序列化为 `Date` 或 `DateTime` 类型**。

 `Date` 和 `DateTime` 构造器可以接收一个数字字符串和格式字符串。
例如，表示 1987 年 9 月 13 日的字符串 `"19870913"` 可被序列化为：

```jl
sco("""Date("19870913", "yyyymmdd")""")
```

注意第二个参数是日期格式的字符串表示。
前四位表示年 `y`，后接着的两位表示月 `m`， 而最后两位数字表示日 `d`.

这也适用于 `DateTime` 的时间戳：

```jl
sco("""DateTime("1987-09-13T21:21:00", "yyyy-mm-ddTHH:MM:SS")""")
```

可以在 [Julia `Dates`' documentation](https://docs.julialang.org/en/v1/stdlib/Dates/#Dates.DateFormat) 了解到更多的日期格式。
不同担心需要时常浏览文档，我们在处理日期和时间戳时也是这样。

根据 [Julia `Dates`' documentation](https://docs.julialang.org/en/v1/stdlib/Dates/#Constructors)，当只需调用几次时，使用 `Date(date_string, format_string)` 方法也是可以的。
然而，如果需要处理大量相同格式的日期字符串，那么更高效的方法是先创建 `DateFormat` 类型，然后传递该类型而不是原始的格式字符串。
然后，先前的例子改为：

```jl
s = """
    format = DateFormat("yyyymmdd")
    Date("19870913", format)
    """
sco(s)
```

或者，在不损失性能的情况下，使用字符串字面量前缀 `dateformat"..."`：

```jl
sco("""Date("19870913", dateformat"yyyymmdd")""")
```

#### 提取日期信息 {#sec:dates_information}

很容易 **从 `Date` 和 `DateTime` 对象中提取想要的信息**。
首先，创建一个具体日期的实例：
```jl
sco("""my_birthday = Date("1987-09-13")""")
```

然后可以从 `my_birthday` 中提取任何想要的信息：

```jl
scob("year(my_birthday)")
```

```jl
scob("month(my_birthday)")
```

```jl
scob("day(my_birthday)")
```

Julia 的 `Dates` 模块也提供了 **返回值元组的复合函数**：

```jl
sco("yearmonth(my_birthday)")
```

```jl
sco("monthday(my_birthday)")
```

```jl
sco("yearmonthday(my_birthday)")
```

也能了解该日期是一周的第几天和其他方便的应用：

```jl
scob("dayofweek(my_birthday)")
```

```jl
scob("dayname(my_birthday)")
```

```jl
scob("dayofweekofmonth(my_birthday)")
```

是的，Jose 出生在 9 月的第 2 个星期日。

> **_NOTE:_**
> 如下是一个从 `Dates` 实例中提取工作日的便捷提示。
> 对 `dayofweek(your_date) <= 5` 使用 `filter`。
> 也可以使用 [`BusinessDays.jl`](https://github.com/JuliaFinance/BusinessDays.jl) 包进行工作日相关的操作。

#### 日期操作 {#sec:dates_operations}

可以对 `Dates` 实例进行多种 **操作** 。
例如，可以对一个 `Date` 或 `DateTime` 实例增加天数。
请注意，Julia 的 `Dates` 将自动地对闰年以及 30 天或 31 天的月份执行必要的调整(这称为 **日历** 算术)。

```jl
sco("my_birthday + Day(90)")
```

我们想加多少天就加多少天：

```jl
sco("my_birthday + Day(90) + Month(2) + Year(1)")
```

可能你想知道：“还能用 `Dates` 做些什么？还有哪些可用的方法？”，则可以使用 `methodswith` 检索这些方法。
这里只展示前 20 条结果：

```jl
s = "first(methodswith(Date), 20)"
sco(s; process=catch_show)
```

由上可知，也能使用加 `+` 和减 `-` 运算符。
让我们看看 Jose 的年龄， 以天为单位：

```jl
sco("today() - my_birthday")
```

`Date` 类型的 **默认持续时间** 是 `Day` 实例。
而对于 `DateTime` 类型，默认持续时间是 `Millisecond` 实例。

```jl
sco("DateTime(today()) - DateTime(my_birthday)")
```

#### 日期区间 {#sec:dates_intervals}

关于 `Dates` 模块的一个好处是，可以轻松地构造 **日期和时间区间**。
Julia 足够聪明，因此不用去定义在 @sec:ranges 中讨论的整个区间类型和操作。
它只需将为 `range` 定义的函数和操作扩展到 `Date` 类型。
这就是在 **为什么选择 Julia?** (@sec:why_julia) 中讨论过的多重派发。

例如，假设想要创建一个 `Day` 区间。
这可以轻松地通过冒号 `:` 运算符实现：

```jl
sco("""Date("2021-01-01"):Day(1):Date("2021-01-07")""")
```

使用 `Day(1)` 作为间隔没有什么特别的， 可以使用 **任意的 `Period` 类型** 作为间隔。
比如，使用 3 天作为间隔：

```jl
sco("""Date("2021-01-01"):Day(3):Date("2021-01-07")""")
```

又或者是月份：

```jl
sco("""Date("2021-01-01"):Month(1):Date("2021-03-01")""")
```

注意， **这个区间的类型是内含 `Date` 和具体 `Period` 类型的`StepRange`**，其中 `Period` 用于作为间隔：

```jl
s = """
    date_interval = Date("2021-01-01"):Month(1):Date("2021-03-01")
    typeof(date_interval)
    """
sco(s)
```

可以使用 `collect` 函数将它转换为 **向量** ：

```jl
sco("collected_date_interval = collect(date_interval)")
```

并具有全部的**可用数组功能**，例如索引：

```jl
sco("collected_date_interval[end]")
```

也可以在 `Date` 向量中实现 **日期操作的广播** ：

```jl
sco("collected_date_interval .+ Day(10)")
```

同理，这些例子也适用于 `DateTime` 类型。

### 随机数 {#sec:random}

`Random` 模块是另一重要的 Julia 标准库模块。
这个模块的用途是 **生成随机数**。
`Random` 是功能丰富的库，如果感兴趣，可以阅读查看 [Julia's `Random` documentation](https://docs.julialang.org/en/v1/stdlib/Random/) 了解更多信息。
接下来 **只** 讨论三个函数： `rand`， `randn` 和 `seed!`。

在开始前，首先导入 `Random` 模块。
先精确地导入想使用的方法：

```julia
using Random: seed!
```

主要有 **两个生成随机数的函数**：

* `rand`: 在某种数据结构或类型的 **元素** 中做随机抽样。
* `randn`: 在**标准正态分布**（平均值 0 和标准差 1）中做随机抽样。

#### `rand` {#sec:random_rand}

默认情况下，可以不带参数地调用 `rand` ，那么它就会返回一个位于区间 $[0, 1)$ 的 `Float64` 随机数，该区间表示随机数的范围是 0 （包含）到 1 （排除）之间：

```jl
scob("rand()")
```

可以使用多种方式更新 `rand` 的参数。
假设，想要获得多个随机数：

```jl
sco("rand(3)")
```

或者，想在不同的区间抽样：

```jl
scob("rand(1.0:10.0)")
```

也可以给区间指定步长，甚至可以在不同的类型间抽样。
这里使用不带点 `.` 的数字，所以 Julia 会将它们解释为 `Int64` 而不是  `Float64`：

```jl
scob("rand(2:2:20)")
```

还可以组合和匹配参数：

```jl
sco("rand(2:2:20, 3)")
```

它还支持元素集构成的元组：

```jl
scob("""rand((42, "Julia", 3.14))""")
```

也支持数组：

```jl
scob("rand([1, 2, 3])")
```

还可以是 `Dict`：

```jl
sco("rand(Dict(:one => 1, :two => 2))")
```

最后要讨论的 `rand` 参数选项是，使用数字元组指定随机数的维度。
如果执行此操作，那么返回类型将会变为数组。
例如，如下是由 1.0-3.0 间的 `Float64` 随机数构成的 2x2 矩阵：

```jl
sco("rand(1.0:3.0, (2, 2))")
```

#### `randn` {#sec:random_randn}

`randn` 遵循与 `rand` 相同的生成原理，但现在它只返回从 **标准正态分布** 中生成的随机数。
标准正态分布是平均值为 0 和标准差为 1 的正态分布。
其默认类型为 `Float64`，并且只接受 `AbstractFloat` 或 `Complex` 的子类型：

```jl
scob("randn()")
```

可以仅指定大小：

```jl
sco("randn((2, 2))")
```

#### `seed!` {#sec:random_seed}

在 `Random` 概述的结尾部分， 我们接下来讨论 **重现性**。
我们经常需要让某些事能够 **可复现**。
这意味着，随机数生成器要每次 **生成相同的随机数序列**。
这可以通过 `seed!` 函数实现：

```jl
s = """
    # comment to distinguish this block from the next # hide
    seed!(123)
    rand(3)
    """
sco(s)
```

```jl
s = """
    seed!(123)
    rand(3)
    """
sco(s)
```

在一些例子中，在脚本开头调用 `seed!` 是不够好的。
为了避免 `rand` 或 `randn` 依赖全局变量，那么可以转而定义一个 `seed!` 的实例，然后将它传递给 `rand` 或 `randn` 的第一个参数。

```jl
sco("my_seed = seed!(123)")
```


```jl
# some comment to distinguish this block from the next # hide
sco("rand(my_seed, 3)")
```

```jl
sco("randn(my_seed, 3)")
```

> **_NOTE:_**
> 请注意，对于不同的版本，这些数字可能会有所不同。
> 若要在不同的版本获得稳定的随机数流，请使用 `StableRNGs.jl` 库。

### Downloads {#sec:downloads}

最后一个要讨论的 Julia 标准库是 **`Downloads` 模块**。
这部分相当简短，因为只关注单个函数 `download`。

假设想要 **从互联网上下载文件到本地**。
这可以用通过 `download` 函数实现。
最简单情况下，仅仅需要一个参数，那就是文件的 url。
还可以指定第二个参数作为下载文件的输出路径 (不要忘记文件系统的最佳实践!)。
如果不指定第二个参数，默认情况下，Julia 将使用 `tempfile` 函数创建一个临时文件。

首先导入 `Downloads` 模块：

```julia
using Downloads
```

例如，下载 [`JuliaDataScience` GitHub 仓库](https://github.com/JuliaDataScience/JuliaDataScience) 的 `Project.toml` 文件。
注意，`Downloads` 模块并没有导出 `download` 函数，因此需要使用语法 `Module.function` 。
默认情况下， 它返回一个包含下载文件本地路径的字符串：

```jl
s = """
    url = "https://raw.githubusercontent.com/JuliaDataScience/JuliaDataScience/main/Project.toml"

    my_file = Downloads.download(url) # tempfile() being created
    """
scob(s)
```

可以使用 `readlines` 查看下载文件的前四行：

```jl
s = """
    readlines(my_file)[1:4]
    """
sco(s; process=catch_show)
```

> **_NOTE:_**
> 对于更复杂的 HTTP 交互过程，例如与 web API 交互，请使用 [`HTTP.jl`](https://github.com/JuliaWeb/HTTP.jl) 包。
