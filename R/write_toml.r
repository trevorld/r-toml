#' Write TOML config files
#'
#' `write_toml()` encodes R objects into TOML
#' and then writes them to a connection.
#'
#' @param x An R object with an [encode_toml()] method.
#' @param con A connection object or a character string.
#'            Passed to [base::writeLines()].
#' @param ... Passed to [encode_toml()].
#' @export
write_toml <- function(x, con = stdout(), ...) {
    if (!is_named_list(x))
        stop("`x` must be a named list")
    s <- encode_toml(x, ...)
    writeLines(s, con = con)
}

is_named_list <- function(x) {
    is.list(x) && !is.null(names(x))
}
