#'
#' LQAS classifier
#'
#' @param n Number of cases found.
#' @param n_total Number sampled.
#' @param threshold  Decision rule threshold/s. Should be between 0 and 1. At
#'   least one threshold should be provided for a two-tier classifier. Two 
#'   thresholds should be provided for a three-tier classifier. Default is a 
#'   three-tier classifier with rule set at 0.2 and 0.5.
#'
#' @returns A character value or vector indicating classification. If
#'   `threshold` is a single value, the generic function returns *1* if `n` is
#'   greater than the threshold else *0*. The coverage classifier
#'   function returns **"Satisfactory"** if `n` is greater than the threshold
#'   else **"Not satisfactory"**. If `threshold` is two values, the generic
#'   function returns *1* if `n` is greater than the first threshold and *2* if
#'   `n` is greater than the second threshold else *0*. The CMAM coverage
#'   classifier returns **"Low"** if `n` is below or equal to lower threshold, 
#'   **"High"** if `n` is above the higher threshold, and **"Moderate"** for 
#'   all other values of `n`.
#'
#' @author Ernest Guevarra
#'
#' @examples
#' lqas_classify_coverage(n = 6, n_total = 40)
#' with(
#'   survey_data,
#'   lqas_classify_coverage(n = cases_in, n_total = cases_total)
#' )
#'
#' @export
#' @rdname lqas_classify
#'

lqas_classify_ <- function(n, n_total, threshold = c(0.2, 0.5)) {
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
  
  ## Get d
  d <- n_total * threshold
  
  ## Two-tier classification
  if (length(d) == 1) {
    coverage_class <- ifelse(n > d, 1, 0)
  }
  
  ## Three-tier classification
  if (length(d) == 2) {
    coverage_class <- ifelse(
      n > d[2], 2,
      ifelse(
        n <= d[1], 0, 1
      )
    )
  }
  
  coverage_class
}

#'
#' @export
#' @rdname lqas_classify
#' 

lqas_classify <- function(n, n_total, threshold = c(0.2, 0.5)) {
  Map(
    f = lqas_classify_,
    n = as.list(n),
    n_total = as.list(n_total),
    threshold = rep(list(threshold), length(n))
  ) |>
    unlist()  
}

#'
#' @export
#' @rdname lqas_classify
#' 

lqas_classify_coverage <- function(n, n_total, threshold = c(0.2, 0.5)) {
  coverage_class <- lqas_classify(
    n = n, n_total = n_total, threshold = threshold
  )

  if (length(threshold) == 1) {
    coverage_label <- ifelse(
      coverage_class == 1, "Satisfactory", "Not satisfactory"
    )
  } else {
    coverage_label <- ifelse(
      coverage_class == 0, "Low",
      ifelse(
        coverage_class == 1, "Moderate", "High"
      )
    )
  }

  ## Return coverage_label ----
  coverage_label
}
