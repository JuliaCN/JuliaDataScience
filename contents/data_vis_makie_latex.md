## 使用 LaTeXStrings.jl {#sec:using_latex}

通过调用 `LaTeXStrings.jl`，`Makie.jl` 实现了对 LaTeX 的支持：

```
using LaTeXStrings
```

一个简单的基础用法例子如下所示 (@fig:latex_strings)，其主要包含用于 x-y 标签和图例的 LaTeX 字符串。

```jl
@sc LaTeX_Strings()
```

```jl
s = """
    CairoMakie.activate!() # hide
    with_theme(LaTeX_Strings, publication_theme())
    label = "latex_strings" # hide
    caption = "Plot with LaTeX strings." # hide
    link_attributes = "width=60%" # hide
    Options(current_figure(); filename=label, caption, label, link_attributes) # hide
    """
sco(s)
```

下面是更复杂的例子，图中的`text`是一些等式，并且图例编号随着曲线数增加：

```jl
@sco JDS.multiple_lines()
```

但不太好的是，一些曲线的颜色是重复的。
添加标记和线条类型通常能解决此问题。
所以让我们使用 [`Cycles`](http://makie.juliaplots.org/stable/documentation/theming/index.html#cycles) 来添加标记和线条类型。
设置 `covary=true`，使所有元素一起循环：

```jl
@sco JDS.multiple_scatters_and_lines()
```

一张出版质量的图如上所示。
那我们还能做些什么操作？
答案是还可以为图定义不同的默认颜色或者调色盘。
在下一节，我们将再次了解如何使用 [`Cycles`](http://makie.juliaplots.org/stable/documentation/theming/index.html#cycles) 以及有关它的更多信息，即通过添加额外的关键字参数就可以实现前面的操作。
