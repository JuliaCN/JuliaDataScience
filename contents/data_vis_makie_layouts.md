## 布局 {#sec:makie_layouts}

一个完整的 **画布/布局** 是由 `Figure` 定义的，创建后将在其中填充各种内容。
下面将以一个包含 `Axis`，`Legend` 和 `Colorbar` 的简单例子开始。
在这项任务中， 就像 `Array`/`Matrix` 那样，可以使用 `rows` 和 `columns` 索引 `Figure`。
`Axis` 位于 **第 1 行，第 1 列**， 即为 `fig[1, 1]`。 `Colorbar` 位于 **第 1 行，第 2 列**， 即为 `fig[1, 2]`。
另外， `Legend` 位于 **第 2 行** 和 **第 1 - 2 列**， 即为 `fig[2, 1:2]`。

```jl
@sco JDS.first_layout()
```

这看起来已经不错了，但能变得更好。可以使用以下关键字和方法来解决图的间距问题：

- `figure_padding=(left, right, bottom, top)`
- `padding=(left, right, bottom, top)`

改变 `Legend` 或 `Colorbar` 实际大小的方法为：

> - `tellheight=true` or `false`
> - `tellwidth=true` or `false`
>
> **将这些设置为 `true` 后则需考虑 `Legend` 或 `Colorbar` 的实际大小（高或宽）。**
> 然后这些内容将会相应地调整大小。

可以使用以下方法指定行和列的间距：

> - `colgap!(fig.layout, col, separation)`
> - `rowgap!(fig.layout, row, separation)`
>
> **列间距** （`colgap!`），如果给定了 `col`，那么间距将只应用在指定的列。
> **行间距** （`rowgap!`），如果给定了 `row`，那么间距将只应用在指定的行。

接下来将学习如何将内容放进 **突出部分（protrusion）**，即为 **标题 `x` 和 `y`，或 `ticks` 以及 `label`** 保留的空间。
实现方法是将位置索引改为 `fig[i, j, protrusion]`， 其中 _`protrusion`_ 可以是 `Left()`， `Right()`，`Bottom()` 和 `Top()`，或者是四个角 `TopLeft()`， `TopRight()`， `BottomRight()`，`BottomLeft()`。
这些选项将在如下的例子中使用：

```jl
@sco JDS.first_layout_fixed()
```

这里在 `TopLeft()`添加标签  `(a)` 可能是不必要的， 因为标签仅在有两个以上的图时有意义。
在接下来的例子中，我们将继续使用之前的工具和一些新工具，并创建一个更丰富、更复杂的图。

可以使用以下函数隐藏图的装饰部分和轴线：

> - `hidedecorations!(ax; kwargs...)`
> - `hidexdecorations!(ax; kwargs...)`
> - `hideydecorations!(ax; kwargs...)`
> - `hidespines!(ax; kwargs...)`

应记住总是可以调用 `help` 查看能够传递的参数，例如：

```jl
s = """
    help(hidespines!)
    """
sco(s)
```

另外，对于 `hidedecorations!` 有：

```jl
s = """
    help(hidedecorations!)
    """
sco(s)
```

对于 **不想隐藏的** 元素，仅需要将它们的值设置为 `false`，即 `hideydecorations!(ax; ticks=false, grid=false)`。


同步 `Axis` 的方式如下：

> - `linkaxes!`， `linkyaxes!` 和 `linkxaxes!`
>
> 这在需要共享轴时会变得很有用。
> 另一种获得共享轴的方法是设置 `limits!`。

使用以下方式可一次性设定`limits`，当然也能单独为每个方向的轴单独设定：

> - `limits!(ax; l, r, b, t)`，其中 `l` 为左侧, `r` 右侧，`b` 底部， 和 `t` 顶部。
>
> 还能使用 `ylims!(low, high)` 或 `xlims!(low, high)`，甚至可以通过 `ylims!(low=0)` 或 `xlims!(high=1)` 只设定一边。

例子如下：

```jl
@sco JDS.complex_layout_double_axis()
```

如上所示， `Colorbar` 的方向已经变为水平且它的标签也处在其下方。
这是因为设定了 `vertical=false` 和 `flipaxis=false`。
另外，也可以将更多的 `Axis` 添加到 `fig` 里，甚至可以是 `Colorbar` 和 `Legend`，然后再构建布局。

另一种常见布局是热力图组成的正方网格：

```jl
@sco JDS.squares_layout()
```

上图中每一个标签都位于 **突出部分** 并且每一个 `Axis` 都有 `AspectData()` 率属性。
图中 `Colorbar` 位于第三列，并从第一行跨到第二行。

下例将使用称为 `Mixed()` 的**对齐模式**，这在处理 `Axis` 间的大量空白区域时很有用，而这些空白区域通常是由长标签导致的。
另外，本例还需要使用 Julia 标准库中的 `Dates` 。

```
using Dates
```

```jl
@sco JDS.mixed_mode_layout()
```

如上，参数 `alignmode=Mixed(bottom=0)` 将边界框移动到底部，使其与左侧面板保持对齐。

从上图也可以看到 `colsize!` 和 `rowsize!` 如何作用于不同的行和列。
可以向函数传递一个数字而不是 `Auto()`，但那会固定所有的设置。
另外， 在定义 `Axis` 时也可以设定 `height` 或 `width`，例如 `Axis(fig, heigth=50)` 将会固定轴的高度。

### 嵌套 `Axis` (_subplots_)

精准定义一组 `Axis` (_subplots_) 也是可行的， 可以使用一组 `Axis` 构造具有多行多列的图。
例如，下面展示了一组较复杂的 `Axis`：

```jl
@sc nested_sub_plot!(fig)
```

当通过多次调用它来构建更复杂的图时，可以得到：

```jl
@sco JDS.main_figure()
```

注意，这里可以调用不同的子图函数。
另外，每一个 `Axis` 都是 `Figure` 的独立部分。
因此，当在进行 `rowgap!`或者 `colsize!` 这样的操作时，你需要考虑是对每一个子图单独作用还是对所有的图一起作用。

对于组合的 `Axis` (_subplots_) 可以使用 `GridLayout()`， 它能用来构造更复杂的 `Figure`。

### 嵌套网格布局

可以使用 `GridLayout()` 组合子图，这种方法能够更自由地构建更复杂的图。
这里再次使用之前的 `nested_sub_plot!`，它定义了三组子图和一个普通的 `Axis`：

```jl
@sco JDS.nested_Grid_Layouts()
```

现在，对每一组使用 `rowgap!` 或 `colsize!` 将是可行的，并且 `rowsize!, colsize!` 也能够应用于 `GridLayout()`。

### 插图

目前，绘制 `inset` 是一项棘手的工作。
本节展示两种在初始时通过定义辅助函数实现绘制插图的方法。
第一种是定义 `BBox`，它存在于整个 `Figure` 空间：

```jl
@sc add_box_inset(fig)
```

然后可以按照如下方式轻松地绘制插图：

```jl
@sco JDS.figure_box_inset()
```

其中 `Box` 的尺寸受到 `Figure`中 `resolution` 参数的约束。
注意，也可以在 `Axis` 外绘制插图。
另一种绘制插图的方法是，在位置`fig[i, j]`处定义一个新的 `Axis`，并且指定 `width`， `height`， `halign` 和 `valign`。
如下面的函数例子所示：

```jl
@sc add_axis_inset()
```

在下面的例子中，如果总图的大小发生变化，那么将重新缩放灰色背景的 `Axis`。
同时 **插图** 要受到 `Axis` 位置的约束。

```jl
@sco JDS.figure_axis_inset()
```

以上包含了 Makie 中布局选项的大多数常见用例。
现在，让我们接下来使用 `GLMakie.jl` 绘制一些漂亮的3D示例图。
