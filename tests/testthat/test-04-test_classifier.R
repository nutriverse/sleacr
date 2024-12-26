# Tests for test classifier functions ------------------------------------------

test_that("outcome is data.frame", {
  expect_s3_class(
    lqas_simulate_population(proportion = 0.3, pop = 10000), "data.frame"
  )
})

test_that("outcome has correct number of rows", {
  expect_equal(
    nrow(lqas_simulate_population(proportion = 0.3, pop = 10000)), 10000
  )
})

test_that("warnings and errors come up as expected", {
  expect_error(lqas_simulate_population(proportion = -0.1, pop = 10000))
  expect_error(lqas_simulate_population(proportion = 1.1, pop = 10000))
})

test_that("outcome is a list", {
  expect_s3_class(
    lqas_simulate_run(
      proportion = 0.3, pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9
    ), 
    "data.frame"
  )
})

test_that("warnings and errors come up as expected", {
  expect_error(
    lqas_simulate_run(
      proportion = 0.3, pop = 10000, n = 40, dLower = "0.6", dUpper = 0.9
    )
  )

  expect_error(
    lqas_simulate_run(
      proportion = 0.3, pop = 10000, n = 40, dLower = 0.6, dUpper = "0.9"
    )
  )

  expect_error(
    lqas_simulate_run(
      proportion = 0.3, pop = 10000, n = 40, dLower = 0, dUpper = 0.9
    )
  )

  expect_error(
    lqas_simulate_run(
      proportion = 0.3, pop = 10000, n = 40, dLower = 0.6, dUpper = 1
    )
  )

  expect_error(
    lqas_simulate_run(
      proportion = 0.3, pop = 10000, n = 40, dLower = 0.9, dUpper = 0.6
    )
  )
})

test_that("outcome is a data.frame", {
  expect_s3_class(
    lqas_simulate_runs(
      pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, runs = 5
    ), 
    "data.frame"
  )
})

test_that("outcome is lqasSim", {
  expect_s3_class(
    lqas_simulate_test(
      pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, runs = 5, replicates = 5
    ),
    "lqasSim"
  )
})


test_that("outcome is a list", {
  expect_type(
    lqas_get_class_prob(
      lqas_simulate_test(
        pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, 
        runs = 5, replicates = 5
      )
    ),
    "list"
  )
})


test_that("outcome is lqasClass", {
  expect_s3_class(
    lqas_get_class_prob(
      lqas_simulate_test(
        pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, 
        runs = 5, replicates = 5
      )
    ),
    "lqasClass"
  )
})


test_that("outcome is as expected", {
  expect_snapshot_output(
    print(
      lqas_get_class_prob(
        lqas_simulate_test(
          pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, 
          runs = 5, replicates = 5
        )
      )
    )
  )

  expect_snapshot_output(
    plot(
      lqas_simulate_test(
        pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, 
        runs = 5, replicates = 5
      )
    )
  )
})
