toml 0.1.0 (development)
========================

* `encode_toml()` is an S3 generic that encodes R objects as TOML.
  Provides methods for the following R classes:

  + `"character"`
  + `"Date"`
  + `"clock_calendar"`, `"clock_sys_time"`, and `"clock_zoned_time"` from `{clock}`
  + `"datetimeoffset"` from `{datetimeoffset}`
  + `"integer"`
  + `"integer64"` from `{bit64}`
  + `"list"` (both named and unnamed)
  + `"logical"`
  + `"nanotime"` from `{nanotime}`
  + `"numeric"`
  + `"partial_time"` from `{parttime}`
  + `"POSIXct"` and `"POSIXlt"`

* `write_toml()` encodes an R object to TOML and writes it to a connection.
