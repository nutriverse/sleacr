#'
#' LQAS classifier
#'
#' @param cases_in Number of SAM and/or MAM cases found during the survey who
#'   are in the CMAM programme.
#' @param cases_out Number of SAM and/or MAM cases found during the survey who
#'   are in the CMAM programme.
#' @param rec_in Number of children recovering from SAM or MAM found during the
#'   survey who are in the programme.
#' @param k Correction factor. Ratio of the mean length of an untreated episode
#'   to the mean length of a CMAM treatment episode
#' @param threshold  Decision rule threshold/s. Should be between 0 and 1. At
#'   least one threshold should be provided for a two-tier classifier. Two 
#'   thresholds should be provided for a three-tier classifier. Default is a 
#'   three-tier classifier with rule set at 0.2 and 0.5.
#' @param label Logical. Should the output results be classification labels?
#'   If TRUE, output classification are character labels else they are integer
#'   values. Default is FALSE.
#'
#' @returns A [data.frame()] of coverage classifications for case-finding
#'   effectiveness and for treatment coverage.
#'
#' @author Ernest Guevarra
#'
#' @examples
#' lqas_classify(cases_in = 6, cases_out = 34, rec_in = 6)
#' 
#' with(
#'   survey_data,
#'   lqas_classify(
#'     cases_in = cases_in, cases_out = cases_out, rec_in = rec_in
#'   )
#' )
#'
#' @export
#' @rdname lqas_classify
#'

lqas_classify_ <- function(cases_in, 
                           cases_out,
                           rec_in = NULL,
                           k = 3,
                           threshold = c(0.2, 0.5),
                           label = FALSE) {  
  ## Check that threshold/s is/are numeric
  if (!all(is.numeric(threshold))) {
    stop(
      "Threshold/s should be numeric. Check your values.", call. = TRUE
    )
  }
  
  ## Sort rule to ensure that first value is the smaller value
  threshold <- sort(threshold)
  
  ## Check that threshold is between 0 and 1
  if (any(threshold < 0 | threshold > 1)) {
    stop(
      "Threshold/s should be between 0 and 1. Check your values.", 
      call. = TRUE
    )
  }
  
  ## Check that difference between thresholds is at least 0.3
  if (length(threshold) == 2) {
    if ((threshold[2] - threshold[1]) < 0.3) {
      warning(
        "Difference between lower and upper thresholds is less than 0.3. ",
        "This may cause gross mis-classification.", 
        call. = TRUE
      )
    }
  }

  ## Classify case-finding effectiveness ----
  cf <- lqas_classify_cf(
    cases_in = cases_in, cases_out = cases_out, 
    threshold = threshold, label = label
  )

  ## Classify treatment coverage ----
  tc <- lqas_classify_tc(
    cases_in = cases_in, cases_out = cases_out, rec_in = rec_in, k = k,
    threshold = threshold, label = label
  )
  
  ## Concatenate cf and tc ----
  coverage_class <- list(cf = cf, tc = tc)

  ## Return coverage class ----
  coverage_class
}

#'
#' @export
#' @rdname lqas_classify
#' 

lqas_classify <- function(cases_in, 
                          cases_out, 
                          rec_in = NULL, 
                          k = 3, 
                          threshold = c(0.2, 0.5),
                          label = FALSE) {
  Map(
    f = lqas_classify_,
    cases_in = as.list(cases_in),
    cases_out = as.list(cases_out),
    rec_in = as.list(rec_in),
    k = as.list(k),
    threshold = rep(list(threshold), length(cases_in)),
    label = label
  ) |>
    do.call(rbind, args = _) |>
    data.frame()
}

#'
#' @export
#' @rdname lqas_classify
#'

lqas_classify_cf <- function(cases_in, cases_out, 
                             threshold = c(0.2, 0.5), label = FALSE) {
  d <- (cases_in + cases_out) * threshold

  if (length(threshold) == 1) {
    cf <- ifelse(cases_in > d, 1L, 0L)

    if (label) cf <- ifelse(cf == 0L, "Not satisfactory", "Satisfactory")
  } else {
    cf <- ifelse(
      cases_in > d[2], 2L,
      ifelse(
        cases_in <= d[1], 0L, 1L
      )
    )

    if (label)
      cf <- ifelse(cf == 0L, "Low", ifelse(cf == 1L, "Moderate", "High"))
  }

  ## Return cf ----
  cf
}


#'
#' @export
#' @rdname lqas_classify
#' 

lqas_classify_tc <- function(cases_in, cases_out, rec_in, k,
                             threshold = c(0.2, 0.5), label = FALSE) {
  rec_out <- calculate_rout(cases_in, cases_out, rec_in, k = k)
  
  d <- (cases_in + cases_out + rec_in + rec_out) * threshold

  if (length(threshold) == 1) {
    tc <- ifelse((cases_in + rec_in) > d, 1L, 0L)

    if (label) tc <- ifelse(tc == 0L, "Not satisfactory", "Satisfactory")
  } else {
    tc <- ifelse(
      (cases_in + rec_in) > d[2], 2L,
      ifelse(
        (cases_in + rec_in) <= d[1], 0L, 1L
      )
    )

    if (label)
      tc <- ifelse(tc == 0L, "Low", ifelse(tc == 1L, "Moderate", "High"))
  }

  ## Return tc ----
  tc
}
