# r-toml

[![CRAN Status Badge](https://www.r-pkg.org/badges/version/toml)](https://cran.r-project.org/package=toml)
[![R-CMD-check](https://github.com/trevorld/r-toml/workflows/R-CMD-check/badge.svg)](https://github.com/trevorld/r-toml/actions)
[![codecov](https://codecov.io/github/trevorld/r-toml/branch/main/graph/badge.svg)](https://app.codecov.io/github/trevorld/r-toml)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

### Table of Contents

* [Overview](#overview)
* [Installation](#installation)
* [Examples](#examples)
* [Comparison with {RccpTOML}](#rccptoml)
* [Comparison with {blogdown}](#blogdown)
* [Related software](#links)

## <a name="overview">Overview</a>

Currently this package only **encodes** R objects to [TOML](https://toml.io/) v1.0.  

Depending on your TOML needs you may consider instead [{RccpTOML}](https://github.com/eddelbuettel/rcpptoml) or [{blogdown}](https://pkgs.rstudio.com/blogdown/reference/read_toml.html).

`{toml}` provides the following functions to support encoding R objects to [TOML](https://toml.io/).

* `encode_toml()` is an S3 generic that encodes R objects as TOML.  Feel free to write a TOML encoder for any object you like---this package provides encoders for following:
  
  + named and unnamed lists
  + character, integer, logical, numeric (double) vectors 
  + the 64-bit integer vectors from `{bit64}`
  + dates, datetimes, and times from `{base}`, `{clock}`, `{datetimeoffset}`, `{nanotime}`, and `{parttime}`

* `write_toml()` encodes an R object to TOML and then writes it to a connection.

## <a name="installation">Installation</a>


```r
remotes::install_github("trevorld/r-toml")
```

## <a name="examples">Examples</a>


```r
library("toml")
l <- list(title = "TOML Example",
          owner = list(name = "Tom Preston-Werner",
                       dob = as.POSIXct("1979-05-27 07:32:00",
                                        tz = "America/Los_Angeles")),
          database = list(server = "192.168.1.1",
                          ports = c(8001L, 8001L, 8002L),
                          connection_max = 5000L,
                          enabled = TRUE),
          servers = list(alpha = list(ip = "10.0.0.1", dc = "eqdc10"),
                         beta = list(ip = "10.0.0.2", dc = "eqdc10")),
          clients = list(data = list(c("gamma", "delta"), c(1L, 2L)),
                         hosts = c("alpha", "omega"))
          )
cat(encode_toml(l), sep = "\n")
```

```
## title = 'TOML Example'
## owner.name = 'Tom Preston-Werner'
## owner.dob = 1979-05-27T07:32:00.000000-07:00
## database.server = '192.168.1.1'
## database.ports = [8_001, 8_001, 8_002]
## database.connection_max = 5_000
## database.enabled = true
## servers.alpha.ip = '10.0.0.1'
## servers.alpha.dc = 'eqdc10'
## servers.beta.ip = '10.0.0.2'
## servers.beta.dc = 'eqdc10'
## clients.data = [['gamma', 'delta'], [1, 2]]
## clients.hosts = ['alpha', 'omega']
```

```r
if (requireNamespace("bit64", quietly = TRUE)) {
  library("datetimeoffset")
  l <- list(int_64bit = bit64::as.integer64("9223372036854775807"),
            offset_datetime = as_datetimeoffset("2023-04-05T01:02:03-07:00"),
            local_datetime = as_datetimeoffset("2023-04-05T01:02:03"),
            local_date = as.Date("2023-04-05"),
            local_time = as_datetimeoffset("T01:02:03"))
  cat(encode_toml(l), sep = "\n")
}
```

```
## int_64bit = 9_223_372_036_854_775_807
## offset_datetime = 2023-04-05T01:02:03-07:00
## local_datetime = 2023-04-05T01:02:03
## local_date = 2023-04-05
## local_time = 01:02:03
```


## <a name="rccptoml">Comparison with {RccpTOML}</a>

**Note**: Please feel free to [open a pull request to fix any {RccpTOML} mis-understandings or statements that are now out-of-date](https://github.com/trevorld/r-toml/edit/main/README.Rmd).

* Currently [{RccpTOML}](https://github.com/eddelbuettel/rcpptoml) only **decodes** TOML files while this package only **encodes** TOML files.

## <a name="blogdown">Comparison with {blogdown}</a>

**Note**: Please feel free to [open a pull request to fix any {blogdown} mis-understandings or statements that are now out-of-date](https://github.com/trevorld/r-toml/edit/main/README.Rmd).

* The `read_toml()` / `write_toml()` functions in [{blogdown}](https://pkgs.rstudio.com/blogdown/reference/read_toml.html) can **read**/**write** TOML documents either by using `{RccpTOML}` or alternatively by converting from/to [YAML](https://yaml.org/) using [{yaml}](https://cran.r-project.org/web/packages/yaml/index.html) and then using [Hugo](https://gohugo.io/) to convert from/to TOML whereas this package **writes** TOML documents directly in R.
* TOML generated from by `{blogdown}` may be formatted more nicely than TOML generated from this package.
* This package (as of `{blogdown}` v1.18) seems to do a better job of encoding to TOML `{bit64}`'s "integer64" class as well as several datetime classes from `{base}`, `{clock}`, `{datetimeoffset}`, `{nanotime}`, and `{parttime}`.
* This package lets you write your own `encode_toml()` methods to support encoding additional R objects that `{blogdown}` may not support.

## <a name="links">Related software</a>

* [TOML](https://toml.io/)
* [toml-test](https://github.com/toml-lang/toml-test)
* [{RccpTOML}](https://github.com/eddelbuettel/rcpptoml) can **read** TOML documents using [toml++](https://github.com/marzer/tomlplusplus)
* [{blogdown}](https://pkgs.rstudio.com/blogdown/reference/read_toml.html) can **read**/**write** TOML documents either by using `{RccpTOML}` or alternatively by converting from/to [YAML](https://yaml.org/) using [{yaml}](https://cran.r-project.org/web/packages/yaml/index.html) and then using [Hugo](https://gohugo.io/) to convert from/to TOML.
