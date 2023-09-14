test_that("Strings work", {
    expect_equal(encode_toml(list(a = "boo")),
                 "a = 'boo'")
    expect_equal(encode_toml("a'b"), "\"a'b\"")
    expect_equal(encode_toml("'a'"), "\"'a'\"")
})

test_that("Integers work", {
    expect_equal(encode_toml(list(a = 1L)),
                 "a = 1")
    expect_equal(encode_toml(list(a = 123456L)),
                 "a = 123_456")

    skip_if_not_installed("bit64")
    expect_equal(encode_toml(bit64::as.integer64("23")), "23")
    expect_equal(encode_toml(bit64::as.integer64("1023")), "1_023")
    expect_equal(encode_toml(bit64::as.integer64("-1023")), "-1_023")
    expect_equal(encode_toml(bit64::as.integer64("-123")), "-123")
    expect_equal(encode_toml(bit64::as.integer64("1023"), big.mark = ""), "1023")
    max_integer64 <- "9223372036854775807"
    expect_equal(encode_toml(bit64::as.integer64(max_integer64)),
                             "9_223_372_036_854_775_807")
    expect_error(encode_toml(bit64::NA_integer64_))
    skip("{bit64} treats -9223372036854775808 as an NA value")
    min_integer64 <- "-9223372036854775808"
    expect_equal(encode_toml(bit64::as.integer64(min_integer64)),
                             "-9_223_372_036_854_775_808")
})

test_that("Arrays work", {
    expect_equal(encode_toml(list(a = 1:4)),
                 "a = [1, 2, 3, 4]")
    expect_equal(encode_toml(list(a = list(1, "a", TRUE))),
                 "a = [1.0, 'a', true]")
    expect_equal(encode_toml(list(a = integer(0))),
                 "a = []")
    expect_equal(encode_toml(list(a = list(1L))),
                 "a = [1]")
})

test_that("Datetimes work", {
    expect_equal(encode_toml(list(a = as.Date("2020-04-04"))),
                 "a = 2020-04-04")
    expect_equal(encode_toml(list(a = as.Date("2020-04-04"))),
                 "a = 2020-04-04")

    dob <- as.POSIXct("1979-05-27 07:32:00", tz = "America/Los_Angeles")
    expect_equal(encode_toml(dob),
                 "1979-05-27T07:32:00.000000-07:00")

    skip_on_cran()
    dob <- datetimeoffset::as_datetimeoffset(dob)

    skip_if_not_installed("clock")
    expect_equal(encode_toml(clock::as_sys_time(dob)),
                 "1979-05-27T14:32:00.000000Z")
    expect_equal(encode_toml(clock::as_zoned_time(dob)),
                 "1979-05-27T07:32:00.000000-07:00")
    expect_equal(encode_toml(clock::as_year_month_day(dob)),
                 "1979-05-27T07:32:00.000000")

    skip_if_not_installed("nanotime")
    expect_equal(encode_toml(nanotime::as.nanotime(dob)),
                 "1979-05-27T14:32:00.000000000Z")

    skip_if_not_installed("parttime")
    expect_equal(encode_toml(parttime::as.parttime(dob)),
                 "1979-05-27T07:32:00.000000000-07:00")
})

test_that("Floats work", {
    expect_equal(encode_toml(list(a = c(NaN, Inf, -Inf))),
                 "a = [nan, inf, -inf]")
    expect_equal(encode_toml(list(a = 1)),
                 "a = 1.0")
    expect_equal(encode_toml(123456789), "123_456_789.0")
    expect_equal(encode_toml(0.00390625), "0.003_906_25")
})

test_that("Booleans work", {
    expect_equal(encode_toml(list(a = TRUE, b = FALSE)),
                 c("a = true", "b = false"))
})

test_that("Hash tables work", {
    expect_equal(encode_toml(list(a = named_list(), b = list())),
                c("a = {}", "b = []"))

    expect_equal(encode_toml(named_list()), "")

    l <- list()
    l[[""]] <- "empty quoted key"
    expect_equal(encode_toml(l), "'' = 'empty quoted key'")

    expect_equal(encode_toml(list(list(a = 1, b = 2))),
                 "[{a = 1.0, b = 2.0}]")

    expect_equal(encode_toml(list(a = list(b = list(list(c = "d"))))),
                 "a.b = [{c = 'd'}]")
})
