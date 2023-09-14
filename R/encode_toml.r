#' Encode R object to TOML
#'
#' `encode_toml()` is an S3 method that encodes R object to TOML
#'
#' @param x R object to encode
#' @param ... Currently ignored
#' @return A character vector
#' @export
encode_toml <- function(x, ...) {
    UseMethod("encode_toml")
}

#' @param prefix Prefix for keys.
#'               If `NULL` and `isFALSE(inline)` assume this is the top-level aka root table.
#' @param inline Encode as a TOML "inline" table.
#' @rdname encode_toml
#' @export
encode_toml.list <- function(x, ..., prefix = NULL, inline = FALSE) {
    if (is.list(x) && !is.null(names(x))) { # Encode named list as a TOML table
        if (length(x) == 0L) {
            if (is.null(prefix) && !inline) {
                return("")
            } else {
                return("{}")
            }
        }
        nms <- names(x)
        stopifnot(!any(duplicated(nms)))
        s <- character()
        for (i in seq_along(x)) {
            nm <- nms[i]
            v <- x[[i]]
            if (!grepl("^[A-Za-z0-9_-]*$", nm) || nchar(nm) == 0L) {
                nm <- encode_toml.character(nm)
            }
            if (!is.null(prefix))
                nm <- paste0(prefix, ".", nm)
            if (is.list(v) && !is.null(names(v)) && length(v)) {
                s <- append(s, encode_toml(v, prefix = nm))
            } else {
                s <- append(s, paste(nm, "=", encode_toml(v, prefix = nm)))
            }
        }
        if (inline) {
            paste0("{", paste(s, collapse = ", "), "}")
        } else {
            s
        }
    } else { # Encode an unnamed list as a TOML array
        if (length(x)) {
            s <- unlist(lapply(x, encode_toml, character(1), inline = TRUE))
            stopifnot("TOML doesn't support missing data" = !any(is.na(s)))
            paste0("[", paste(s, collapse = ", "), "]")
        } else {
            "[]"
        }
    }
}

maybe_as_array <- function(s) {
    stopifnot("TOML doesn't support missing data" = !any(is.na(s)))
    if (length(s) != 1L) {
        paste0("[", paste(s, collapse = ", "), "]")
    } else {
        s
    }
}

named_list <- function(...) {
    l <- list(...)
    if (is.null(names(l)))
        names(l) <- character(length(l))
    l
}

#' @rdname encode_toml
#' @export
encode_toml.default <- function(x, ...) {
    stop(paste("Can't encode class", sQuote(class(x)), "yet"))
}

#' @rdname encode_toml
#' @export
encode_toml.character <- function(x, ...) {
    # Currently no multi-line string support
    # If single-line literal strings work (no `'` or `\n`) will use those
    # else single-line basic string (which escapes special characters)
    s <- ifelse(grepl("'|[[:cntrl:]]", x),
                paste0('"', escape_basic_string(x), '"'),
                paste0("'", x, "'"))
    maybe_as_array(s)
}

escape_basic_string <- function(x) {
    if (grepl("'", x)) {
        x <- stringi::stri_escape_unicode(x)
        # TOML doesn't allow  `\a`, `\v`, or `\'`...
        x <- stringi::stri_replace_all_fixed(x, "\\'", "'")
        x <- stringi::stri_replace_all_fixed(x, "\\a", "\\u0007") # alert
        x <- stringi::stri_replace_all_fixed(x, "\\v", "\\u000b") # vertical tab
        x
    } else {
        stringi::stri_escape_unicode(x)
    }
}

#' @rdname encode_toml
#' @param big.mark,big.interval `big.mark` is used as a mark between every `big.interval` decimals
#'                 (before the decimal point).
#'                 TOML allows this to be either `"_"` or `""`.
#' @export
encode_toml.integer <- function(x, ..., big.mark = "_", big.interval = 3L) {
    stopifnot(big.mark %in% c("", "_"))
    s <- formatC(x, format = "d", big.mark = big.mark, big.interval = big.interval)
    maybe_as_array(s)
}

encode_toml.integer64 <- function(x, ..., big.mark = "_", big.interval = 3L) {
    stopifnot("TOML doesn't support missing data" = !any(is.na(x)))
    stopifnot(big.mark %in% c("", "_"))
    if (big.mark == "") {
        as.character(x)
    } else {
        signs <- sign(x)
        numbers <- vapply(as.character(abs(x)), encode_int_string_helper, character(1),
                          big.interval = big.interval, USE.NAMES = FALSE)
        ifelse(signs < 0,
               paste0("-", numbers),
               numbers)
    }
}

encode_int_string_helper <- function(x, big.interval = 3L) {
    to <- rev(seq(from = nchar(x), to = 1L, by = -big.interval))
    from <- pmax(1L, to - big.interval + 1L)
    stringi::stri_paste(stringi::stri_sub(x, from, to), collapse = "_")
}

#' @rdname encode_toml
#' @export
encode_toml.logical <- function(x, ...) {
    s <- ifelse(x, "true", "false")
    maybe_as_array(s)
}

#' @rdname encode_toml
#' @param small.mark,small.interval `small.mark` is used as a mark between every `small.interval` decimals
#'                 after the decimal point.
#'                 TOML allows this to be either `"_"` or `""`.
#' @export
encode_toml.numeric <- function(x, ...,
                                big.mark = "_", big.interval = 3L,
                                small.mark = big.mark, small.interval = big.interval) {
    # infinity, # not a number
    stopifnot(big.mark %in% c("", "_"), small.mark %in% c("", "_"))
    s <- format(x, nsmall = 1L, digits = 22, scientific = FALSE,
                big.mark = "_", big.interval = big.interval,
                small.mark = "_", small.interval = small.interval)
    s <- ifelse(is.nan(x), "nan", s)
    s <- ifelse(is.infinite(x) & x > 0, "inf", s) #### +inf instead?
    s <- ifelse(is.infinite(x) & x < 0, "-inf", s)
    maybe_as_array(s)
}

#' @rdname encode_toml
#' @export
encode_toml.Date <- function(x, ...) {
    s <- format(x)
    maybe_as_array(s)
}

encode_toml_datetime <- function(x, ...) {
    x <- datetimeoffset::as_datetimeoffset(x)
    s <- datetimeoffset::format_iso8601(x, mode = "toml")
    maybe_as_array(s)
}

#' @rdname encode_toml
#' @export
encode_toml.POSIXt <- encode_toml_datetime

#' @rdname encode_toml
#' @export
encode_toml.datetimeoffset <- function(x, ...) {
    s <- datetimeoffset::format_iso8601(x, mode = "toml")
    maybe_as_array(s)
}
