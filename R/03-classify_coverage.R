#'
#' Classify coverage results
#'
#' @param n_in Number (integer) of cases found in the programme
#' @param n_total Number (integer) of children under 5 years sampled
#' @param standard  Decision rule standard/s. Should be between 0 and 1. At
#'   least one standard should be provided for a two-tier coverage classifier.
#'   Two standards should be provided for a three-tier coverage classifier.
#'   Default is a three-tier classifier with rule set at 0.2 and 0.5.
#'
#' @return A character value or vector indicating coverage classification. If
#'   `standard` is a single value, returns **"Satisfactory"** if coverage is
#'   above `standard` and **"Not satisfactory"** if coverage is below or
#'   equal to `standard`. If `standard` is two values, returns **"Low"** if
#'   coverage is below or equal to lower standard, **"High"** if coverage is
#'   above the higher standard, and **"Moderate"** for all other coverage
#'   values.
#'
#' @author Ernest Guevarra
#'
#' @examples
#' classify_coverage(n_in = 6, n_total = 40)
#' with(survey_data,
#'   classify_coverage(n_in = in_cases, n_total = n)
#' )
#'
#' @export
#'

classify_coverage <- function(n_in, n_total, standard = c(0.2, 0.5)) {
  coverage_class <- Map(
    f = classify_coverage_,
    n_in = as.list(n_in),
    n_total = as.list(n_total),
    standard = rep(list(standard), length(n_in))
  )

  unlist(coverage_class)
}

#'
#' @noRd
#'

classify_coverage_ <- function(n_in, n_total, standard = c(0.2, 0.5)) {
  ## Check that standard/s is/are numeric
  if (!all(is.numeric(standard))) {
    stop(
      "Standard/s should be numeric. Check your values.", call. = TRUE
    )
  }

  ## Sort rule to ensure that first value is the smaller value
  standard <- sort(standard)

  ## Check that standard is between 0 and 1
  if (any(standard < 0 | standard > 1)) {
    stop(
      "Standard/s should be between 0 and 1. Check your values.", call. = TRUE
    )
  }

  ## Check that difference between standards is at least 0.3
  if (length(standard) == 2) {
    if ((standard[2] - standard[1]) < 0.3) {
      warning(
        "Difference between lower and upper standards is less than 0.3. ",
        "This may cause gross mis-classification.", 
        call. = TRUE
      )
    }
  }

  ## Get d
  d <- n_total * standard

  ## Two-tier classification
  if (length(d) == 1) {
    coverage_class <- ifelse(n_in > d, "Satisfactory", "Not satisfactory")
  }

  ## Three-tier classification
  if (length(d) == 2) {
    coverage_class <- ifelse(
      n_in > d[2], "High",
      ifelse(
        n_in <= d[1], "Low", "Moderate"
      )
    )
  }

  coverage_class
}



