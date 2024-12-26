# Tests for utility functions --------------------------------------------------

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
  expect_type(
    get_hypergeom_cumulative(
      k = 5, m = 600, n = 25, N = 10000, tail = "upper"
    ), 
    "double"
  )
  expect_true(
    is.numeric(
      get_hypergeom_cumulative(
        k = 5, m = 600, n = 25, N = 10000, tail = "upper"
      )
    )
  )
})

