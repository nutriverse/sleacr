# Tests for sample size functions ----------------------------------------------

test_that("get_sample_n works as expected", {
  samp_plan <- get_sample_n(N = 600, dLower = 0.7, dUpper = 0.9)

  expect_type(samp_plan, "list")
  expect_named(samp_plan, expected = c("n", "d", "alpha", "beta"))
  
  expect_error(get_sample_n(N = 600, dLower = -0.7, dUpper = 0.9))
  expect_error(get_sample_n(N = 600, dLower = 0.7, dUpper = -0.9))
  expect_error(get_sample_n(N = 600, dLower = 7, dUpper = 0.9))
  expect_error(get_sample_n(N = 600, dLower = 0.7, dUpper = 9))
  expect_error(get_sample_n(N = 600, dLower = 0.9, dUpper = 0.7))

  expect_error(
    get_sample_n(N = 600, dLower = 0.7, dUpper = 0.9, alpha = -0.1, beta = 0.1)
  )
  expect_error(
    get_sample_n(N = 600, dLower = 0.7, dUpper = 0.9, alpha = 0.1, beta = -0.1)
  )
  expect_error(
    get_sample_n(N = 600, dLower = 0.7, dUpper = 0.9, alpha = 1.1, beta = 0.1)
  )
  expect_error(
    get_sample_n(N = 600, dLower = 0.7, dUpper = 0.9, alpha = 0.1, beta = 1.1)
  )
})


test_that("get_sample_d works as expected", {
  samp_plan <- get_sample_d(N = 600, n = 19, dLower = 0.7, dUpper = 0.9)

  expect_type(samp_plan, "list")
  expect_named(samp_plan, expected = c("n", "d", "alpha", "beta"))
  
  expect_error(get_sample_d(N = 600, n = 19, dLower = -0.7, dUpper = 0.9))
  expect_error(get_sample_d(N = 600, n = 19, dLower = 0.7, dUpper = -0.9))
  expect_error(get_sample_d(N = 600, n = 19, dLower = 7, dUpper = 0.9))
  expect_error(get_sample_d(N = 600, n = 19, dLower = 0.7, dUpper = 9))
  expect_error(get_sample_d(N = 600, n = 19, dLower = 0.9, dUpper = 0.7))

  expect_error(
    get_sample_d(
      N = 600, n = 19, dLower = 0.7, dUpper = 0.9, alpha = -0.1, beta = 0.1
    )
  )
  expect_error(
    get_sample_d(
      N = 600, n = 19, dLower = 0.7, dUpper = 0.9, alpha = 0.1, beta = -0.1
    )
  )
  expect_error(
    get_sample_d(
      N = 600, n = 19, dLower = 0.7, dUpper = 0.9, alpha = 1.1, beta = 0.1
    )
  )
  expect_error(
    get_sample_d(
      N = 600, n = 19, dLower = 0.7, dUpper = 0.9, alpha = 0.1, beta = 1.1
    )
  )
})


test_that("get_n_cases works as expected", {
  n_cases <- get_n_cases(N = 10000, u5 = 0.17, p = 0.02)

  expect_type(n_cases, "double")
  expect_true(is.numeric(n_cases))

  expect_error(get_n_cases(N = 10000, u5 = -0.17, p = 0.02))
  expect_error(get_n_cases(N = 10000, u5 = 17, p = 0.02))
  expect_error(get_n_cases(N = 10000, u5 = 0.17, p = -0.02))
  expect_error(get_n_cases(N = 10000, u5 = 0.17, p = 2))
})


test_that("get_n_clusters works as expected", {
  n_clusters <- get_n_clusters(n = 40, n_cluster = 600, u5 = 0.17, p = 0.02)

  expect_type(n_clusters, "double")
  expect_true(is.numeric(n_clusters))

  expect_error(get_n_clusters(n = 40, n_cluster = 600, u5 = -0.17, p = 0.02))
  expect_error(get_n_clusters(n = 40, n_cluster = 600, u5 = 17, p = 0.02))
  expect_error(get_n_clusters(n = 40, n_cluster = 600, u5 = 0.17, p = -0.02))
  expect_error(get_n_clusters(n = 40, n_cluster = 600, u5 = 0.17, p = 2))
})