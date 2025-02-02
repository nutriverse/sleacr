# Tests for check_coverage_homogeneity ----------------------------------------

samp_size <- c(38, 32, 43, 35, 42, 37, 39, 42)
in_cases <- c(29, 18, 36, 15, 14, 10, 5, 23)
rec_in <- c(2, 10, 1, 10, 12, 11, 20, 10)
out_cases <- samp_size - in_cases

cov_data <- data.frame(
  cases_in = in_cases, cases_out = out_cases, rec_in = rec_in
)

cov_df <- survey_data
cov_df$rec_in <- 1

test_that("check_coverage_homogeneity works as expected", {
  expect_type(check_coverage_homogeneity(survey_data), "list")
  expect_type(check_coverage_homogeneity(cov_data), "list")
  expect_type(check_coverage_homogeneity(cov_df), "list")

  expect_error(check_coverage_homogeneity(survey_data, p = 1.2))

  expect_error(check_coverage_homogeneity(survey_data, p = "0.5"))
})
