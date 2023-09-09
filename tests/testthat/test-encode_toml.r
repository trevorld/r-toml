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

    expect_equal(encode_toml(list(list(a = 1, b = 2))),
                 "[{a = 1.0, b = 2.0}]")

    expect_equal(encode_toml(list(a = list(b = list(list(c = "d"))))),
                 "a.b = [{c = 'd'}]")
})
