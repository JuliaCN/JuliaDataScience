# 附录 {#sec:appendix}

## 库的版本 {#sec:appendix_pkg}

本书由 Julia `jl string(VERSION)` 及以下库构建：

```jl
JDS.pkg_deps()
```

```jl
let
    date = today()
    hour = Dates.hour(now())
    min = Dates.minute(now())

    "Build: $date $hour:$min UTC"
end
```
