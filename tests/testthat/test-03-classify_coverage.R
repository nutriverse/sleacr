# Tests for lqas_classify functions --------------------------------------------

test_that("output is character", {
  expect_s3_class(
    lqas_classify(cases_in = 6, cases_out = 34, rec_in = 6), 
    "data.frame"
  )
  
  expect_s3_class(
    lqas_classify(cases_in = 6, cases_out = 34, rec_in = 6, label = TRUE), 
    "data.frame"
  )

  expect_s3_class(
    lqas_classify(
      cases_in = survey_data$cases_in, 
      cases_out = survey_data$cases_out,
      rec_in = survey_data$rec_in
    ), "data.frame"
  )

  expect_s3_class(
    lqas_classify(
      cases_in = survey_data$cases_in, 
      cases_out = survey_data$cases_out,
      rec_in = survey_data$rec_in,
      label = TRUE
    ), "data.frame"
  )

  expect_s3_class(
    lqas_classify(
      cases_in = 6, cases_out = 34, rec_in = 6, threshold = 0.5
    ), 
    "data.frame"
  )
  
  expect_s3_class(
    lqas_classify(
      cases_in = 6, cases_out = 34, rec_in = 6, threshold = 0.5, label = TRUE
    ), 
    "data.frame"
  )

  expect_s3_class(
    lqas_classify(
      cases_in = survey_data$cases_in, 
      cases_out = survey_data$cases_out,
      rec_in = survey_data$rec_in, 
      threshold = 0.5
    ), 
    "data.frame"
  )

  expect_s3_class(
    lqas_classify(
      cases_in = survey_data$cases_in, 
      cases_out = survey_data$cases_out,
      rec_in = survey_data$rec_in, 
      threshold = 0.5, label = TRUE
    ), 
    "data.frame"
  )
})


test_that("errors and warnings show correctly", {
  expect_warning(
    lqas_classify(
      cases_in = 6, cases_out = 34, rec_in = 6, threshold = c(0.4, 0.5)
    )
  )

  expect_error(
    lqas_classify(
      cases_in = 6, cases_out = 34, rec_in = 6, threshold = c("0.4", "0.5")
    )
  )

  expect_error(
    lqas_classify(
      cases_in = 6, cases_out = 34, rec_in = 6, threshold = c(0.4, 1.2)
    )
  )
})
