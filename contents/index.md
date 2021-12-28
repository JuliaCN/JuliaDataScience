# Welcome {-}

```{=comment}
This file is only included on the website.
```

Welcome! 这是一本关于 **[Julia](https://julialang.org) 数据科学** 的开放获取书籍，同时源代码开源。
我们的目标读者是来自应用科学各个领域的研究人员。
当然，我们也希望能对工业界有用。
你可以使用键盘上的箭头键（左/右）浏览电子书。

> 此译本将在未来发布 **PDF** 版本。

此译本的源码公开在 [GitHub](https://github.com/JuliaCN/JuliaDataScience){target="_blank"}。

本书的英文版同时发布在 [Amazon.com](https://www.amazon.com/dp/B09KMRKQ96/)。

如果你想得到有关英文版的更新通知，请考虑**注册更新**：

```{=html}
<form style="margin: 0 auto;" action="https://api.staticforms.xyz/submit" method="post">
    <input type="hidden" name="accessKey" value="2b78f325-fb4e-44e1-ad2f-4dc714ac402f">
    <input type="email" name="email">
    <input type="hidden" name="redirectTo" value="https://juliadatascience.io/thanks">
    <input type="submit" value="Submit" />
</form>
```

### 引用信息 {-}

可使用如下条目引用本书的内容：

```plaintext
Storopoli, Huijzer and Alonso (2021). Julia Data Science. https://juliadatascience.io. ISBN: 9798489859165.
```

或以 BibTeX 格式：

```plaintext
@book{storopolihuijzeralonso2021juliadatascience,
  title = {Julia Data Science},
  author = {Jose Storopoli and Rik Huijzer and Lazaro Alonso},
  url = {https://juliadatascience.io},
  year = {2021},
  isbn = {9798489859165}
}
```

### 封面 {-}

```jl
let
    fig = front_cover()
    # Use lazy loading to keep homepage speed high.
    link_attributes = """loading="lazy" width=80%"""
    # When changing this name, also change the link in README.md.
    # This doesn't work for some reason; I need to fix it.
    filename = "frontcover"
    Options(fig; filename, label=filename)
end
```

