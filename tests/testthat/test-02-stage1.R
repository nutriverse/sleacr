library(tibble)

## Test that output is numeric

test_that("output is numeric or integer", {
  ## Sampling intervals
  expect_type(
    get_sampling_interval(N_clusters = 211, n_clusters = 35), "double"
  )
  expect_true(
    is.numeric(get_sampling_interval(N_clusters = 211, n_clusters = 35))
  )

  ## Random start
  expect_type(select_random_start(6), "integer")

  ## Sampling sequence
  expect_type(
    select_sampling_clusters(N_clusters = 211, n_clusters = 35), "double"
  )
})

## Test that output is data.frame

test_that("output is tibble or data.frame", {
  expect_type(
    create_sampling_list(cluster_list = village_list, n_clusters = 70),
    "list"
  )

  expect_true(
    is_tibble(
      create_sampling_list(cluster_list = village_list, n_clusters = 70)
    )
  )

  expect_true(
    is.data.frame(
      create_sampling_list(cluster_list = village_list, n_clusters = 70)
    )
  )
})
