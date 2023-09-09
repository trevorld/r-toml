toml 0.1.0 (development)
========================

* `encode_toml()` is an S3 generic that encodes R objects as TOML.
  Provides methods for the following R classes:

  + `"character"`
  + `"Date"`
  + `"datetimeoffset"` (`{datetimeoffset}`)
  + `"integer"`
  + `"integer64"` (`{bit64}`)
  + `"list"` (both named and unnamed)
  + `"logical"`
  + `"numeric"`
  + `"POSIXct"` and `"POSIXlt"`

* `write_toml()` encodes an R object to TOML and writes it to a connection.
