#!/usr/bin/Rscript --vanilla
# `toml-test` decoder: https://github.com/toml-lang/toml-test
# library("toml")
source("R/encode_toml.r")
json_data <- readLines(file("stdin"))
if (requireNamespace("jsonlite", quietly = TRUE)) {
    jl <- jsonlite::fromJSON(json_data, simplifyVector = FALSE)
} else {
    cat("No json decoders found", sep="\n")
    quit("no", status = 1)
}

# Decode `toml-test` list (after decoded from JSON)
decode_tt_list <- function(jl) {
    if (is.list(jl) &&
        !is.null(names(jl)) &&
        length(jl) == 2 &&
        all(names(jl) == c("type", "value"))) {
        switch(jl$type,
               string = jl$value,
               integer = bit64::as.integer64(jl$value),
               float = as.double(jl$value),
               bool = as.logical(jl$value),
               datetime = datetimeoffset::as_datetimeoffset(jl$value),
               `datetime-local` = datetimeoffset::as_datetimeoffset(jl$value),
               `date-local` = datetimeoffset::as_datetimeoffset(jl$value),
               `time-local` = datetimeoffset::as_datetimeoffset(jl$value),
               stop(paste("Don't recognize toml-test type", jl$type)))
    } else if (is.list(jl)) {
        lapply(jl, decode_tt_list)
    } else {
        jl
    }
}

l <- lapply(jl, decode_tt_list)
tml <- encode_toml(l)
cat(tml, sep = "\n")
quit("no", status = 0)
