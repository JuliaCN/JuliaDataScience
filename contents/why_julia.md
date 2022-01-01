# 为什么选择 Julia ? {#sec:why_julia}

数据科学领域中充满了各种各样的开源编程语言。

工业界大多使用 Python，而学术界偏爱 R。
**那为什么要学习另外一种语言呢?**
我们分别从两种常见背景来回答此问题：

1. **从未编过程** -- 请查阅 @sec:non-programmers。

2. **以前编过程** -- 请查阅 @sec:programmers。

## 从未编过程 {#sec:non-programmers}

对于第一种背景的读者，我们期望都有着如下的基本故事。

数据科学肯定已经吸引到了你，使你有兴趣去了解它到底是什么，以及如何利用它构建你在学术界或工业界的职业生涯。
然后，在尝试寻找资源学习这门新学科时，你会闯进一个充满缩写词的世界：
`pandas`、`dplyr`、`data.table`、`numpy`、`matplotlib`、`ggplot2`、`bokeh`，以及更多数不胜数的例子。

然后会突然听到一个名字：“Julia”。
它究竟是什么样的呢？
它与其他别人告诉你的数据科学工具有什么不同？

为什么你应该投入珍贵的时间去学习这门新语言呢？它几乎从来不会在任何工作要求，实验室职位，博士后职位，或学术职位描述中提到。
答案是，Julia 是用于编程和数据科学的 **全新方法**。
在 Python 或 R 所实现的一切，都可以使用 Julia 实现，并且代码还具有可读性好[^readable]、速度快、功能强大等优点。
因此，Julia 语言越来越受欢迎，而且具有很充分的理由。

所以，**如果你没有任何编程背景知识，我们强烈鼓励你学习 Julia**，让它成为你的第一门编程语言和数据科学框架。

## 有编程经验 {#sec:programmers}

对了有编程经验的读者，背景故事发生了些变化。
你也许知道如何编程，并且可能以此为生。
你熟悉多种编程语言，并且可以在它们之间来回切换。
你已经听说了一种叫做“数据科学”的新奇事物，并且想要跟随这一潮流。
你开始学习如何使用 `numpy`，如何在 `pandas` 中操作 `DataFrames` ，以及如何使用 `matplotlib` 绘图。
又或者，你可能已经通过 tidyverse 学习了所有的操作，包括 `tibbles`、`data.frames`、`%>%` （管道运算符）和 `geom_*` 等等 ……

然后通过某些人或某些地方，你关注到一门名为 “Julia” 的新语言。
何必呢？
你已经精通了 Python 或 R ，并且掌握了你所需要的一切。
好吧，让我们设想一些场景。

**假设你正在使用 Python 或 R：**

1. 编写的代码未能达到需要的性能?
实际上， **若使用 Julia， Python 或 R 的分钟级运行时间可能会缩短为秒级**^[有时是毫秒级。]。
我们将在 @sec:julia_wild 展示 Julia 在学术界和工业界的成功应用案例。

2. 尝试做些不符合 `numpy`/`dplyr` 惯例的操作，但发现代码很慢，然后不得不学习黑魔法^[`numba`、甚至 `Rcpp` 或 `cython`？] 来加速代码？
**在 Julia 中，你可以自定义各种各样的代码，而且不会有任何性能损失**。

3. 不得不调试代码以及有时需要阅读 Fortran 或 C/C++ 源码，但却又不明白实现的原理？
**在 Julia 中，你仅需要阅读 Julia 代码，并且不需要学习其他语言来加速原来的代码**。
这就是 “两语言问题” (请查阅 @sec:two_language)。
这还能对应此种情况： “你想把一个有趣的想法贡献给开源项目。但是不得不放弃，因为所有库的编程语言既不是 Python，也不是 R，而是C/C++ 或 Fortran”^[浏览一些 GitHub 中的深度学习库，你会惊讶地发现 Python 只占代码库的25%-33%。]。

4. 并不能直接使用其他包中的数据结构，而是需要构建一组接口^[这通常是 Python 生态系统的问题，虽然 R 并没有受到严重的影响，但也并不乐观。]。
**而 Julia 用户能够轻松地共享和重用来自不同包的代码。**
大多数 Julia 用户定义的类型和函数都是开箱即用的^[或者需要做出极少的努力。]，一些用户甚至会惊讶地发现其他库可能以无法想象的方式使用他们的包。
我们会在 @sec:multiple_dispatch 介绍一些例子。

5. 想要更好的项目管理工具，其需包含精确的、可管理的、可复制的依赖和版本控制？
**而 Julia 有着令人惊叹的项目管理方案和绝佳的包管理器**。
与安装和管理单个全局软件集的传统包管理器不同，Julia 的包管理器围绕“环境”设计：
这些独立的软件集既可局部生效于单个项目，也能在不同的项目间共享。
每个项目独立维护自己的软件版本集。

如果这些熟悉或看似合理的情景吸引到了你的兴趣，那么你可能会想了解更多关于新 Julia 语言的内容。

让我们继续吧！

## Julia 想实现什么? {#sec:julia_accomplish}

> **_NOTE:_**
> 本节将详细解释是什么使 Julia 成为一门出色的编程语言。
> 如果这对你来说太过技术性，你可以跳过这节并前往 @sec:dataframes 学习如何使用 `DataFrames.jl` 处理表格数据。

Julia 编程语言 [@bezanson2017julia] 是一门较新的语言，第一版发布于 2012 年，其目标是 **简单且快速**。
即，“ 运行起来像C^[有时甚至快于C。]， 但阅读起来像 Python”[@perkelJuliaComeSyntax2019]。
它是为科学计算设计的，能够处理 **大规模的数据与计算** 。但仍可以相当 **容易地创建和操作原型代码**。

Julia 的创始人在一篇[2012 年的博客](https://julialang.org/blog/2012/02/why-we-created-julia/) 中解释了为什么要创造 Julia。
他们说：

> 我们很贪婪：我们想要更多。
> 我们想要一门采用自由许可证的开源语言。
> 我们想要 C 的性能和 Ruby 的动态特性。
> 我们想要一门同调的语言，它既拥有 Lisp 那样真正的宏， 但又具有 Matlab 那样明显又熟悉的数学运算符。
> 我们希望这门语言可以像 Python 一样用于常规编程，像 R 一样容易地用于统计领域，像 Perl 一样自然地处理字符串，像 Matlab 一样拥有强大的线性代数系统，像 Shell 一样能够擅长组合程序。
> 这门语言要简单易学，但又能打动最认真的极客。
> 我们希望它可交互，同时希望它是编译的。

大多数用户都被 Julia 的 **优越速度** 所吸引。
毕竟，Julia 可是著名独家俱乐部 petaflop 的成员。
[**petaflop 俱乐部**](https://www.hpcwire.com/off-the-wire/julia-joins-petaflop-club/) 的组成成员都是一些峰值运算速度超过 **千万亿次每秒** 的编程语言。
现在只有 C，C++，Fortran，和 Julia 属于 [petaflop 俱乐部](https://www.nextplatform.com/2017/11/28/julia-language-delivers-petascale-hpc-performance/)。

但是，速度不是 Julia 的全部。
Julia 的一些特性还包括**易用性**、 **Unicode 支持** 和 **代码共享的便捷性**。
本节将讨论这些所有的特性，不过目前先来关注 Julia 的代码共享特性。

Julia 软件包的生态非常独特。
它不仅允许共享代码，也允许共享用户自定义的类型。
例如，Python 的 `pandas` 使用自带的 `Datetime` 类型来处理日期。
同时， R tidyverse 的 `lubridate` 包也使用自定义的 `datetime` 类型来处理日期。
Julia 不需要上述任何一种类型, 因为其标准库已准备好了所有的日期工具。
这意味其他包不需要担心日期处理。
其他包仅需要为 Julia `DateTime` 类型扩展新功能，即定义新函数但不需要定义新类型。
Julia `Dates` 模块可以实现许多令人惊叹的功能，但目前讨论它有些超前。
于是让我们来讨论一些 Julia 的其他特性。

### Julia VS 其他编程语言

[@fig:language_comparison] 给出了非常个性化的分类，它将主流的开源科学计算编程语言分在一张 2x2 图中， 该图具有两个轴：
**Slow-Fast（慢-快）** 和 **Easy-Hard（简单-困难）**。
我们省略了闭源语言，因为允许其他人运行你的代码以及检查源代码中的问题会具有许多好处。

我们把 C++ 和 FORTRAN 放在 困难-快 象限。
作为需要编译、类型检查和其他专业管理的静态语言，它们真的很难学习，原型代码也编写很缓慢。
好处是它们都是 **非常快的** 语言。

R 和 Python 放在 简单-慢 象限。
它们是不需要编译的动态语言，在运行时执行。
因此，它们很容易学习，能够快速创建原型代码。
当然，这会导致共同的缺点：
它们都是 **非常慢的** 语言。

Julia 是唯一一门在 简单-快 象限的语言。
我们知道任何其他严格的语言都不会想变得困难且缓慢，所以此象限为空。

![科学计算编程语言比较：FORTRAN、C++、Python、R 和 Julia。](images/language_comparisons.png){#fig:language_comparison}

**Julia 很快! 特别快!**
它起初就为速度而设计。
而这通过多重派发实现。
基本上，这个想法能够生成非常高效的 LLVM[^LLVM] 代码。
LLVM 代码，也称为 LLVM 指令，它非常靠近底层，即非常接近计算机执行的实际操作。
所以，本质上， Julia 会将你可读性好的手写代码转换为 LLVM 机器码。虽然 LLVM 机器码对于人类来说很难阅读，但对于计算机来说很容易。
例如，如果你定义了一个接收单个参数的函数并向该函数传递整数，然后 Julia 会创建一个 **专门的** `MethodInstance`。
下次你再向该函数传递整数时，Julia 将会查找之前创建的 `MethodInstance`，并引用其执行操作。
一个**很棒的** 技巧是，可以在调用函数的嵌套函数中使用它。
例如，如果向函数 `f` 传递了某些数据类型，而 `f` 又调用了函数 `g`，同时传递给 `g` 的数据类型都是相同且已知的，那么生成函数 `g` 就会硬编码到 `f` 中！
这意味着 Julia 不再需要查找 `MethodInstances`，此时代码就会运行地非常快。
此处需要权衡的是，在某些情况下，早期关于硬编码 `MethodInstances` 的假设可能是无效的。
然后需要重新创建硬编码的 `MethodInstances`。
因此，权衡也需包括花时间推断哪些能够硬编码，而哪些不能。
这也解释了为什么 Julia 代码在第一次执行前通常要花费较长的时间：
Julia 在背后优化代码。

编译器接着做它最擅长的事情：优化机器码^[如果你想了解更多关于 Julia 如何设计的内容，你绝对需要看 @bezanson2017julia 。]。
你可以在 Julia 网站上找到 Julia 和其他语言的 [benchmarks](https://julialang.org/benchmarks/) 。
@fig:benchmarks 取自于 [Julia 网站的 benchmarks 节^[请注意上述的 Julia 结果不包含编译时间。]](https://julialang.org/benchmarks/)。
如你所见， Julia 是**相当** 快的。

![Julia VS 其他编程语言。](images/benchmarks.png){#fig:benchmarks}

我们非常信任 Julia。
否则，我们不会写这本书。
我们认为， Julia 是 **科学计算和科学数据分析的未来**。
它使得用户可以通过简单的语法开发快速且强大的代码。
研究人员通常使用一种简单但缓慢的语言开发原型代码。
一旦确定代码正常运行且实现其目标，然后就会开始将当前的代码转换为一门快速但困难的编程语言。
这就是“两语言问题”，接下来将讨论它。

### 两语言问题 {#sec:two_language}

“两语言问题” 是科学计算中的典型问题。通常研究人员想要设计一种算法或方案来解决手头的问题或分析。
一般地，解决方案的原型代码都采用容易编程的语言（像 Python 或 R）。
如果原型能够正常工作，那么研究人员就会使用不易编写原型但快速的语言（C++ 或 FORTRAN）重新实现。
因此，开发解决方案的过程涉及了两种语言。
一种语言易于编写原型代码并不适合方案实现 (通常由于缓慢的速度)。
而另一种语言并不易于编写原型代码，但由于非常快，所以适合方案实现。
Julia 能够避免此类情形，因为 **开发原型（易编程）和方案实现（速度快）将采用相同的语言**。

另外， Julia 允许使用 **Unicode 字符作为变量或参数**。
这意味着不再使用 `sigma` 或 `sigma_i`，而是像数学记号那样使用 $σ$ 或 $σᵢ$ 。
当查看算法代码或数学方程时，你会看到几乎相同的符号和术语。
我们将这种强大的特性称为 **“代码和数学关系的一对一”**。

我们认为，Alan Edelman，Julia 创始人之一，在一次[TEDx Talk](https://youtu.be/qGW0GT1rCvs) [@tedxtalksProgrammingLanguageHeal2020] 中对 “两语言问题” 和 “代码和数学关系的一对一” 作出了最好的描述。

<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='https://www.youtube.com/embed/qGW0GT1rCvs' frameborder='0' allowfullscreen></iframe></div>

### 多重派发 {#sec:multiple_dispatch}

多重派发（multiple dispatch）是一种强大的特性，它使得能够扩展现有的函数或为新类型自定义复杂行为。
假设想要定义两种 `struct` 来表示不同的动物：

```jl
s = """
    abstract type Animal end
    struct Fox <: Animal
        weight::Float64
    end
    struct Chicken <: Animal
        weight::Float64
    end
    """
sc(s)
```

这表明此处定义了动物类型 `Fox` 和 `Chicken`。
然后生成名为 Fiona 的 `Fox` 和名为 Big Bird 的 `Chicken`。

```jl
s = """
    fiona = Fox(4.2)
    big_bird = Chicken(2.9)
    """
sc(s)
```

为了知道他们的重量之和，编写如下的函数：

```jl
sco("combined_weight(A1::Animal, A2::Animal) = A1.weight + A2.weight")
```

然后还想知道它们能否相处得好。
采用条件语句实现：

```jl
s = """
    function naive_trouble(A::Animal, B::Animal)
        if A isa Fox && B isa Chicken
            return true
        elseif A isa Chicken && B isa Fox
            return true
        elseif A isa Chicken && B isa Chicken
            return false
        end
    end
    """
sco(s)
```

现在，看看 Fiona 和 Big Bird 待在一起是否会产生麻烦：

```jl
scob("naive_trouble(fiona, big_bird)")
```

好的，看起来不错。
编写 `naive_trouble` 函数已经足够简单了。然而，使用多重派发编写 `trouble` 函数还可以带来新的优势。按照如下方式创建函数：

```jl
s = """
    trouble(F::Fox, C::Chicken) = true
    trouble(C::Chicken, F::Fox) = true
    trouble(C1::Chicken, C2::Chicken) = false
    """
sco(s)
```

定义这些方法后，`trouble` 会得到与 `naive_trouble` 相同的结果。
例如：

```jl
scob("trouble(fiona, big_bird)")
```

把 Big Bird 和另外一只小鸡 Dora 放在一起也是可以的。

```jl
s = """
    dora = Chicken(2.2)
    trouble(dora, big_bird)
    """
scob(s)
```

所以在本例中，多重派发的优势就是可以仅声明类型，然后由 Julia 去为类型找到正确的函数方法。
若是在嵌套函数中使用多重派发则更是如此，Julia 编译器实际上会自动优化函数调用。
例如，函数如下：


```jl
function trouble(A::Fox, B::Chicken, C::Chicken)
    return trouble(A, B) || trouble(B, C) || trouble(C, A)
end
```

根据上下文，Julia 会将其优化为：

```jl
function trouble(A::Fox, B::Chicken, C::Chicken)
    return true || false || true
end
```

因为编译器 **知道** `A` 是 `Fox`, `B` 是 `Chicken` ，所以方法替换为 `trouble(F::Fox, C::Chicken)`。
 `trouble(C1::Chicken, C2::Chicken)` 同理。
然后，编译器进一步优化：

```jl
function trouble(A::Fox, B::Chicken, C::Chicken)
    return true
end
```

此外，多重派发还使比较已存在的动物和新的动物 Zebra 成为可能。
可以在其他包中定义 Zebra ：

```jl
s = """
    struct Zebra <: Animal
        weight::Float64
    end
    """
sc(s)
```

然后定义与现有动物的交互：

```jl
s = """
    trouble(F::Fox, Z::Zebra) = false
    trouble(Z::Zebra, F::Fox) = false
    trouble(C::Chicken, Z::Zebra) = false
    trouble(Z::Zebra, F::Fox) = false
    """
sco(s)
```

现在可查看 Marty（Zebra 动物）是否能与 Big Bird 和谐相处：

```jl
s = """
    marty = Zebra(412)
    trouble(big_bird, marty)
    """
scob(s)
```

更好的是，**不需额外定义任何函数即可计算 Zebra 和其他动物的重量之和**：

```jl
scob("combined_weight(big_bird, marty)")
```

因此，总而言之，即使在编写代码时只考虑了 `Fox` 和 `Chicken`，但它也能用于 **从未见过的** 类型！
在实践中，这意味着重用其他 Julia 项目的代码会非常容易。

如果你和我们一样对多重派发感到兴奋，那么可以了解下面这些深入的例子。
第一个例子是，@storopoli2021bayesianjulia 关于 [ one-hot 向量的快速而优雅的实现](https://storopoli.io/Bayesian-Julia/pages/1_why_Julia/#example_one-hot_vector) 。
第二个例子是，[Tanmay Bakshi YouTube 频道](https://youtu.be/moyPIhvw4Nk?t=2107) 对 [Christopher Rackauckas](https://www.chrisrackauckas.com/) 的采访 （查看时间 35:07 ） [@tanmaybakshiBakingKnowledgeMachine2021]。
Chris 提到， 在他开发和维护 [`DifferentialEquations.jl`](https://diffeq.sciml.ai/dev/) 包时，一名用户报告问题说：他基于 GPU 构造的 ODE 求解器并不能正常工作。
Chris 对这个请求感到非常惊讶，因为他从来没有期望能够将 GPU 计算与求解 ODE 结合起来。
他甚至更惊讶地发现，用户犯了一个小错误，但一切正常。
这些大多数优点都来自于多重派发和高可用的代码 / 类型共享。

总的来说，我们认为多重派发的最好解释来自于 Julia 创始人
[Stefan Karpinski 在 JuliaCon 2019 的演讲](https://youtu.be/kc9HwsxE1OY)。

<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='https://www.youtube.com/embed/kc9HwsxE1OY' frameborder='0' allowfullscreen></iframe></div>


## Julia 应用案例 {#sec:julia_wild}

@sec:julia_accomplish 解释了为什么我们认为 Julia 是门如此独一无二的编程语言。
我们在上节展示了一些 Julia 特性的简单例子。
如果想要深入了解 Julia 的使用， 下面介绍一些 **有趣的案例**：

1. NASA 使用 Julia 在超级计算机上分析了 ["迄今为止发现的最大一批地球尺寸的行星"](https://exoplanets.nasa.gov/news/1669/seven-rocky-trappist-1-planets-may-be-made-of-similar-stuff/) ，并且实现了惊人的 **1,000 倍加速**，在 15 分钟内分类了1.88 亿个天体。
2. [气候建模联盟(Climate Modeling Alliance，CliMa)](https://clima.caltech.edu/)  **在 GPU 和 CPU 上模拟天气**。
该项目启动于 2018 年，与加州理工大学、 NASA 喷气推进实验室以及海军研究生院的研究人员合作，CliMa 项目组采用最近的计算科学进展来开发一个地球系统模型，该模型能够以前所未有的精度和速度预测干旱、热浪和降雨。
3. [美国联邦航空管理局 (FAA) 正在使用 Julia 开发一种 **空中防碰撞系统 (ACAS-X)** ](https://youtu.be/19zm1Fn0S9M)。
这也是一个“两语言问题” 的好例子（查看 @sec:julia_accomplish）。
之前的方案是使用 Matlab 开发算法 并使用 C++ 编写高性能实现。
现在，FAA 使用 Julia 语言完成所有的事。
4. [使用 Julia 在 GPU 上 **175 倍加速** 辉瑞的药理学模型](https://juliacomputing.com/case-studies/pfizer/)。
这是一份第11届美国定量药理学会议的[海报](https://chrisrackauckas.com/assets/Posters/ACoP11_Poster_Abstracts_2020.pdf)，它还获得了 [ quality award](https://web.archive.org/web/20210121164011/https://www.go-acop.org/abstract-awards)。
5. [巴西卫星亚马逊 1 号的姿态和轨道控制子系统 (AOCS) **100% 使用 Julia 编写**](https://discourse.julialang.org/t/julia-and-the-satellite-amazonia-1/57541) ，它的作者是 Ronan Arraes Jardim Chagas (<https://ronanarraes.com/>)。
6. [巴西国家发展银行 (BNDES) 放弃了付费解决方案，转而选择开源 Julia 模型并获得 **10 倍加速**。](https://youtu.be/NY0HcGqHj3g)

如果觉得这些仍不够，[Julia 计算网站](https://juliacomputing.com/case-studies/) 上还有更多的例子。

[^readable]: 没有调用 C++ 或 FORTRAN API。
[^LLVM]: LLVM 是 **L**ow **L**evel **V**irtual **M**chine 的缩写，你可以在LLVM 网站(<http://llvm.org>)找到更多信息。

