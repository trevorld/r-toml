# nocov start
.onLoad <- function(libname, pkgname) {
    s3_register("toml::encode_toml", "integer64", encode_toml.integer64)

    # Datetimes with `as_datetimeoffset()` method
    # {clock}
    s3_register("toml::encode_toml", "clock_calendar", encode_toml_datetime)
    s3_register("toml::encode_toml", "clock_sys_time", encode_toml_datetime)
    s3_register("toml::encode_toml", "clock_zoned_time", encode_toml_datetime)
    # {nanotime}
    s3_register("toml::encode_toml", "nanotime", encode_toml_datetime)
    # {parttime}
    s3_register("toml::encode_toml", "partial_time", encode_toml_datetime)
}
# nocov end
