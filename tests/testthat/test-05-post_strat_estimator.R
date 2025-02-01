# Tests for post-stratification weighted estimation ----------------------------

test_that("overall estimation works as expected", {
  pop_df <- pop_data |>
    setNames(nm = c("strata", "pop"))

  expect_type(
    estimate_coverage_overall(
      cov_df = survey_data, pop_df = pop_df, strata = "district", 
      u5 = 0.177, p = 0.01, k = 3
    ),
    "list"
  )

  expect_error(
    estimate_coverage_overall(
      cov_df = survey_data, pop_df = pop_df, strata = "state", 
      u5 = 0.177, p = 0.01, k = 3
    )
  )

  expect_error(
    estimate_coverage_overall(
      cov_df = survey_data$cases_in, pop_df = pop_df, strata = "district", 
      u5 = 0.177, p = 0.01, k = 3
    )
  )

  expect_error(
    estimate_coverage_overall(
      cov_df = survey_data |> 
        setNames(
          c("country", "province", "district", "in", "out", "rin", "total")
        ), 
      pop_df = pop_df, strata = "district", 
      u5 = 0.177, p = 0.01, k = 3
    )
  )

  expect_error(
    estimate_coverage_overall(
      cov_df = survey_data, pop_df = pop_df$strata, strata = "district", 
      u5 = 0.177, p = 0.01, k = 3
    )
  )

  expect_error(
    estimate_coverage_overall(
      cov_df = survey_data, 
      pop_df = pop_df |>
        setNames(c("state", "population")), 
      strata = "district", 
      u5 = 0.177, p = 0.01, k = 3
    )
  )
})

