

test_that("outcome is data.frame", {
  expect_true(
    is.data.frame(make_data(proportion = 0.3, pop = 10000))
  )
})

test_that("outcome has correct number of rows", {
  expect_equal(nrow(make_data(proportion = 0.3, pop = 10000)), 10000)
})

test_that("outcome is a list", {
  expect_type(
    run_lqas(data = make_data(proportion = 0.3, pop = 10000),
             n = 40, d.lower = 60, d.upper = 90),
    "list"
  )
})

test_that("outcome is a data.frame", {
  expect_true(
    is.data.frame(
      simulate_lqas(runs = 10, pop = 10000, n = 40, d.lower = 60, d.upper = 90)
    )
  )
})

test_that("outcome is lqasSim", {
  expect_s3_class(
    test_lqas_classifier(
      replicates = 5, runs = 5,
      pop = 10000, n = 40, d.lower = 60, d.upper = 90
    ),
    "lqasSim"
  )
})


test_that("outcome is a list", {
  expect_type(
    get_class_prob(
      test_lqas_classifier(
        replicates = 5, runs = 5, pop = 10000, n = 40,
        d.lower = 60, d.upper = 90
      )
    ),
    "list"
  )
})


test_that("outcome is lqasClass", {
  expect_s3_class(
    get_class_prob(
      test_lqas_classifier(
        replicates = 5, runs = 5, pop = 10000, n = 40,
        d.lower = 60, d.upper = 90
      )
    ),
    "lqasClass"
  )
})


test_that("outcome is as expected", {
  expect_snapshot_output(
    print(
      get_class_prob(
        test_lqas_classifier(
          replicates = 5, runs = 5, pop = 10000, n = 40,
          d.lower = 60, d.upper = 90
        )
      )
    )
  )

  expect_snapshot_output(
    plot(
      test_lqas_classifier(
        replicates = 5, runs = 5, pop = 10000, n = 40,
        d.lower = 60, d.upper = 90
      )
    )
  )
})
