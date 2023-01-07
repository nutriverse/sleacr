

test_that("output is character", {
  expect_type(classify_coverage(n_in = 6, n_total = 40), "character")
  expect_type(
    classify_coverage(
      n_in = survey_data$in_cases, n_total = survey_data$n
    ), "character"
  )
})


test_that("errors and warnings show correctly", {
  expect_warning(
    classify_coverage(n_in = 6, n_total = 40, standard = c(0.4, 0.5))
  )
  expect_error(
    classify_coverage(n_in = 6, n_total = 40, standard = c("0.4", "0.5"))
  )
  expect_error(
    classify_coverage(n_in = 6, n_total = 40, standard = c(0.4, 1.2))
  )
})
