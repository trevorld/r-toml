# r-toml

[![CRAN Status Badge](https://www.r-pkg.org/badges/version/toml)](https://cran.r-project.org/package=toml)
[![R-CMD-check](https://github.com/trevorld/r-toml/workflows/R-CMD-check/badge.svg)](https://github.com/trevorld/r-toml/actions)
[![codecov](https://codecov.io/github/trevorld/r-toml/branch/main/graph/badge.svg)](https://app.codecov.io/github/trevorld/r-toml)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

### Table of Contents

* [Overview](#overview)
* [Installation](#installation)
* [Examples](#examples)
* [Related software](#links)

## <a name="overview">Overview</a>

**Warning:** this package is a work-in-progress.  
Currently it only **encodes** [TOML](https://toml.io/) files and only passes 86/99 of the tests in the [toml-test](https://github.com/toml-lang/toml-test) test suite.  Depending on your TOML needs you may consider instead [{RccpTOML}](https://github.com/eddelbuettel/rcpptoml) or [{blogdown}](https://pkgs.rstudio.com/blogdown/reference/read_toml.html).

`{toml}` provides the following functions to support encoding R objects to [TOML](https://toml.io/).

* `encode_toml()` is an S3 generic that encodes R objects as TOML.
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


## <a name="links">Related software</a>

* [TOML](https://toml.io/)
* [toml-test](https://github.com/toml-lang/toml-test)
* [{RccpTOML}](https://github.com/eddelbuettel/rcpptoml) can **read** TOML documents using [toml++](https://github.com/marzer/tomlplusplus)
* [{blogdown}](https://pkgs.rstudio.com/blogdown/reference/read_toml.html) can **read**/**write** TOML documents either by using `{RccpTOML}` or alternatively by converting from/to [YAML](https://yaml.org/) using [{yaml}](https://cran.r-project.org/web/packages/yaml/index.html) and then using [Hugo](https://gohugo.io/) to convert from/to TOML.
