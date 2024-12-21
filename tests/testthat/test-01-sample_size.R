## Test that outputs are numeric

test_that("output is numeric", {
  expect_type(get_binom_hypergeom(n = 600, k = 40), "double")
  expect_true(is.numeric(get_binom_hypergeom(n = 600, k = 40)))
})

test_that("output is numeric", {
  expect_type(get_hypergeom(k = 5, m = 600, n = 25, N = 10000), "double")
  expect_true(is.numeric(get_hypergeom(k = 5, m = 600, n = 25, N = 10000)))
})

test_that("output is numeric", {
  expect_type(
    get_hypergeom_cumulative(k = 5, m = 600, n = 25, N = 10000), "double"
  )
  expect_true(
    is.numeric(get_hypergeom_cumulative(k = 5, m = 600, n = 25, N = 10000))
  )
})

## Test that output is a list

test_that("output is list", {
  expect_type(get_sample_n(N = 600, dLower = 0.7, dUpper = 0.9), "list")
})

test_that("output is list", {
  expect_type(get_sample_d(N = 600, n = 40, dLower = 0.7, dUpper = 0.9), "list")
})

## Test that output is an numeric

test_that("output is numeric", {
  expect_type(get_n_cases(N = 100000, u5 = 0.17, p = 0.02), "double")
  expect_true(is.numeric(get_n_cases(N = 100000, u5 = 0.17, p = 0.02)))
})

test_that("output is numeric", {
  expect_type(
    get_n_clusters(n = 40, N = 100000, u5 = 0.17, p = 0.02), "double"
  )
  expect_true(
    is.numeric(get_n_clusters(n = 40, N = 100000, u5 = 0.17, p = 0.02))
  )
})

