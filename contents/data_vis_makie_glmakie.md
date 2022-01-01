## GLMakie.jl {#sec:glmakie}

`CairoMakie.jl` 满足了所有关于静态 2D 图的需求。
但除此之外，有时候还需要交互性，特别是在处理 3D 图的时候。
使用 3D 图可视化数据是 **洞察** 数据的常见做法。
这就是 `GLMakie.jl` 的用武之地，它使用 [OpenGL](http://www.opengl.org/) 作为添加交互和响应功能的绘图后端。
与之前一样，一幅简单的图只包括线和点。因此，接下来将从简单图开始。因为已经知道布局如何使用，所以将在例子中应用一些布局。

### 散点图和折线图

散点图有两种绘制选项，第一种是 `scatter(x, y, z)`，另一种是 `meshscatter(x, y, z)`。
若使用第一种，标记则不会沿着坐标轴缩放，但在使用第二种时标记会缩放， 这是因为此时它们是三维空间的几何实体。
例子如下：

```
using GLMakie
GLMakie.activate!()
```

```jl
@sco JDS.scatters_in_3D()
```

另请注意，标记可以是不同的几何实体，比如正方形或矩形。另外，也可以为标记设置 `colormap`。
对于上面位于中间的 3D 图，如果想得到获得完美的球体，那么只需如右侧图那样添加 `aspect = :data` 参数。
绘制 `lines` 或 `scatterlines` 也很简单：

```jl
@sco JDS.lines_in_3D()
```

在 3D 图中绘制 `surface`， `wireframe` 和 `contour` 是一项容易的工作。

### 表面，`wireframe`，`contour`，`contourf` 和 `contour3d`

将使用如下的 `peaks` 函数展示这些例子：

```jl
@sc JDS.peaks()
```

不同绘图函数的输出如下：

```jl
@sco JDS.plot_peaks_function()
```

但是也可以使用 `heatmap(x, y, z)`，`contour(x, y, z)` 或 `contourf(x, y, z)` 绘图：

```jl
@sco JDS.heatmap_contour_and_contourf()
```

另外，只要将`Axis` 更改为 `Axis3`，这些图就会自动位于 x-y 平面：

```jl
@sco JDS.heatmap_contour_and_contourf_in_a_3d_plane()
```

将这些绘图函数混合在一起也是非常简单的，如下所示：

```
using TestImages
```

```jl
@sco JDS.mixing_surface_contour3d_contour_and_contourf()
```

还不错，对吧？从这里也可以看出，任何的 `heatmap`， `contour`，`contourf` 和 `image` 都可以绘制在任何平面上。

### `arrows` 和 `streamplot`

当想要知道给定变量的方向时，`arrows` 和 `streamplot` 会变得非常有用。
参见如下的示例^[此处使用 Julia 标准库中的 `LinearAlgebra`。]：

```
using LinearAlgebra
```

```jl
@sco JDS.arrows_and_streamplot_in_3d()
```

另外一些有趣的例子是 `mesh(obj)`，`volume(x, y, z, vals)` 和 `contour(x, y, z, vals)`。

### `mesh` 和 `volume`

绘制网格在想要画出几何实体时很有用，例如 `Sphere` 或矩形这样的几何实体，即 `FRect3D`。
另一种在 3D 空间中可视化的方法是调用 `volume` 和 `contour` 函数，它们通过实现 [光线追踪](https://en.wikipedia.org/wiki/Ray_tracing_(graphics)) 来模拟各种光学效果。
例子如下：

```
using GeometryBasics
```

```jl
@sco JDS.mesh_volume_contour()
```

注意到透明球和立方体绘制在同一个坐标系中。
截至目前，我们已经包含了 3D 绘图的大多数用例。
另一个例子是 `?linesegments`。

参考之前的例子，可以使用球体和矩形平面创建一些自定义图：

```
using GeometryBasics, Colors
```

首先为球体定义一个矩形网格，而且给每个球定义不同的颜色。
另外，可以将球体和平面混合在一张图里。下面的代码定义了所有必要的数据。

```jl
sc("""
seed!(123)
spheresGrid = [Point3f(i,j,k) for i in 1:2:10 for j in 1:2:10 for k in 1:2:10]
colorSphere = [RGBA(i * 0.1, j * 0.1, k * 0.1, 0.75) for i in 1:2:10 for j in 1:2:10 for k in 1:2:10]
spheresPlane = [Point3f(i,j,k) for i in 1:2.5:20 for j in 1:2.5:10 for k in 1:2.5:4]
cmap = get(colorschemes[:plasma], LinRange(0, 1, 50))
colorsPlane = cmap[rand(1:50,50)]
rectMesh = FRect3D(Vec3f(-1, -1, 2.1), Vec3f(22, 11, 0.5))
recmesh = GeometryBasics.mesh(rectMesh)
colors = [RGBA(rand(4)...) for v in recmesh.position]
""")
```

然后可使用如下方式简单地绘图：

```jl
@sco JDS.grid_spheres_and_rectangle_as_plate()
```

注意，右侧图中的矩形平面是半透明的，这是因为颜色函数 `RGBA()` 中定义了 `alpha` 参数。
矩形函数是通用的，因此很容易用来实现 3D 方块，而它又能用于绘制 3D 直方图。
参见如下的例子，我们将再次使用 `peaks` 函数并增加一些定义：

```jl
sc("""
x, y, z = peaks(; n=15)
δx = (x[2] - x[1]) / 2
δy = (y[2] - y[1]) / 2
cbarPal = :Spectral_11
ztmp = (z .- minimum(z)) ./ (maximum(z .- minimum(z)))
cmap = get(colorschemes[cbarPal], ztmp)
cmap2 = reshape(cmap, size(z))
ztmp2 = abs.(z) ./ maximum(abs.(z)) .+ 0.15
""")
```

其中方块的尺寸由 $\delta x, \delta y$ 指定。 `cmap2` 用于指定每个方块的颜色而 `ztmp2` 用于指定每个方块的透明度。如下图所示。

```jl
@sco JDS.histogram_or_bars_in_3d()
```

应注意到，也可以在 `mesh` 对象上调用  `lines` 或 `wireframe`。

### 填充的线和带

在最终的例子中， 我们将展示如何使用 `band`和一些 `linesegments` 填充 3D 图中的曲线：

```jl
@sco JDS.filled_line_and_linesegments_in_3D()
```

最后，我们的3D绘图之旅到此结束。
你可以将我们这里展示的一切结合起来，去创造令人惊叹的 3D 图！
