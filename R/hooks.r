# nocov start
.onLoad <- function(libname, pkgname) {
    s3_register("toml::encode_toml", "integer64", encode_toml.integer64)
}
# nocov end
