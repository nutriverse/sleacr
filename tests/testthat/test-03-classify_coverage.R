

test_that("output is character", {
  expect_type(classify_coverage(n_in = 6, n_total = 40), "character")
  expect_type(
    classify_coverage(
      n_in = survey_data$in_cases, n_total = survey_data$n
    ), "character"
  )
})
