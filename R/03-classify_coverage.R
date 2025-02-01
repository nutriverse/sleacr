#'
#' LQAS classifier
#'
#' @param cases_in Number of SAM and/or MAM cases found during the survey who
#'   are in the CMAM programme.
#' @param cases_out Number of SAM and/or MAM cases found during the survey who
#'   are in the CMAM programme.
#' @param rec_in Number of children recovering from SAM or MAM found during the
#'   survey who are in the programme.
#' @inheritParams squeacr::calculate_tc
#' @param threshold  Decision rule threshold/s. Should be between 0 and 1. At
#'   least one threshold should be provided for a two-tier classifier. Two 
#'   thresholds should be provided for a three-tier classifier. Default is a 
#'   three-tier classifier with rule set at 0.2 and 0.5.
#'
#' @returns A [data.frame()] of coverage classifications for case-finding
#'   effectiveness and for treatment coverage.
#'
#' @author Ernest Guevarra
#'
#' @examples
#' lqas_classify_coverage(cases_in = 6, cases_out = 34, rec_in = 6)
#' 
#' with(
#'   survey_data,
#'   lqas_classify_coverage(
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
                           threshold = c(0.2, 0.5)) {  
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

  ## Calculate rec_out ----
  rec_out <- squeacr::calculate_rout(
    cin = cases_in, cout = cases_out, rin = rec_in, k = k
  )
  
  ## Determine decision rules ----
  d <- list(
    cf = (cases_in * cases_out) * threshold,
    tc = (cases_in + cases_out + rec_in + rec_out) * threshold
  )

  ## Two-tier classification ----
  if (length(threshold) == 1) {
    cf <- ifelse(cases_in > d$cf, 1, 0)
    tc <- ifelse(
      (cases_in + rec_in) > d$tc, 1, 0
    )
  }
  
  ## Three-tier classification ----
  if (length(threshold) == 2) {
    cf <- ifelse(
      cases_in > d$cf[2], 2,
      ifelse(
        cases_in <= d$cf[1], 0, 1
      )
    )

    tc <- ifelse(
      (cases_in + rec_in) > d$tc[2], 2,
      ifelse(
        (cases_in + rec_in) <= d$tc[1], 0, 1
      )
    )
  }
  
  ## Concatenate cf and tec ----
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
                          threshold = c(0.2, 0.5)) {
  Map(
    f = lqas_classify_,
    cases_in = as.list(cases_in),
    cases_out = as.list(cases_out),
    rec_in = as.list(rec_in),
    k = as.list(k),
    threshold = rep(list(threshold), length(cases_in))
  ) |>
    do.call(rbind, args = _) |>
    data.frame()
}

#'
#' @export
#' @rdname lqas_classify
#' 

lqas_classify_coverage <- function(cases_in, 
                                   cases_out, 
                                   rec_in = NULL, 
                                   k = 3, 
                                   threshold = c(0.2, 0.5)) {
  coverage_class <- lqas_classify(
    cases_in = cases_in, cases_out = cases_out,
    rec_in = rec_in, k = k, threshold = threshold
  )

  if (length(threshold) == 1) {
    coverage_label <- data.frame(
      cf = ifelse(coverage_class$cf == 1, "Satisfactory", "Not satisfactory"),
      tc = ifelse(coverage_class$tc == 1, "Satisfactory", "Not satisfactory")
    )
  }
  
  if (length(threshold) == 2) {
    coverage_label <- data.frame(
      cf = ifelse(coverage_class$cf == 0, "Low",
        ifelse(
          coverage_class$cf == 1, "Moderate", "High"
        )
      ),
      tc = ifelse(coverage_class$tc == 0, "Low",
        ifelse(
          coverage_class$tc == 1, "Moderate", "High"
        )
      )
    )
  }
  
  ## Remove row names ----
  row.names(coverage_label) <- NULL

  ## Return coverage_label ----
  coverage_label
}
