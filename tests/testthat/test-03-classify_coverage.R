# Tests for lqas_classify functions --------------------------------------------

test_that("output is character", {
  expect_type(lqas_classify_coverage(n = 6, n_total = 40), "character")
  
  expect_type(
    lqas_classify_coverage(
      n = survey_data$in_cases, n_total = survey_data$n
    ), "character"
  )

  expect_type(
    lqas_classify_coverage(n = 6, n_total = 40, threshold = 0.5), 
    "character"
  )
  
  expect_type(
    lqas_classify_coverage(
      n = survey_data$in_cases, n_total = survey_data$n, threshold = 0.5
    ), 
    "character"
  )
})


test_that("errors and warnings show correctly", {
  expect_warning(
    lqas_classify_coverage(n = 6, n_total = 40, threshold = c(0.4, 0.5))
  )

  expect_error(
    lqas_classify_coverage(n = 6, n_total = 40, threshold = c("0.4", "0.5"))
  )

  expect_error(
    lqas_classify_coverage(n = 6, n_total = 40, threshold = c(0.4, 1.2))
  )
})
