#'
#' Weighted post-stratification estimation
#' 
#' @param cov_df A [data.frame()] of stratified coverage survey data to get
#'   overall coverage estimates of. `cov_df` should have a variable named
#'   `cases_in` for number of SAM or MAM cases in the programme found during the
#'   survey, `cases_out` for number SAM or MAM cases not in the programme found
#'   during the survey, and `rec_in` for children recovering from SAM or MAM who
#'   are in the programme found during the survey. A final required variable
#'   should be one that contains identifying geographical information
#'   corresponding to the location from which each row of the survey data was
#'   collected from.
#' @param pop_df A [data.frame()] with at least two variables: `strata` for the
#'   stratification/grouping information that matches the grouping information
#'   in `cov_df` and `pop` for information on population for the given grouping
#'   information.
#' @param strata A character value of the variable name in `cov_df` that
#'   corresponds to the `strata` values to match with values in `pop_df`.
#' @param u5 A numeric value for the proportion of the population that is under
#'   years old.
#' @param p Prevalence of SAM or MAM in the given population.
#' @param cov_type Coverage estimator to report. Either *"cf"* for
#'   *case-finding effectiveness* or *"tc"* for *treatment coverage*.
#'   Default is *"cf"*.
#' @inheritParams squeacr::calculate_tc
#'
#' @returns An overall coverage estimate with 95% confidence interval.
#' 
#' @examples
#' cov_df <- survey_data
#' 
#' pop_df <- pop_data |>
#'   setNames(nm = c("strata", "pop"))
#' 
#' estimate_coverage_overall(
#'   cov_df, pop_df, strata = "district", u5 = 0.17, p = 0.015
#' )
#' 
#' @export
#' @rdname estimate_coverage
#' 

estimate_coverage_overall <- function(cov_df, pop_df, strata, 
                                      u5, p, 
                                      cov_type = c("cf", "treat"), k = 3) {
  ## Check data ----
  check_coverage_data(cov_df)

  if (!any(strata %in% names(cov_df)))
    cli::cli_abort(
      "{.strong {strata}} is not a variable in {.var cov_df}"
    )
  
  cov_type <- match.arg(cov_type)
  
  ## Calculate weights ----
  weights <- calculate_weights(pop_df = pop_df, u5 = u5, p = p)

  cov_pop_df <- merge(
    cov_df[ , c(strata, "cases_in", "cases_out", "rec_in")], pop_df,
    by.x = strata, by.y = "strata", all.x = TRUE
  )

  ## Calculate coverage ----
  cov <- estimate_coverage(
    cov_df = cov_pop_df, cov_type = cov_type, k = k
  )

  ## Weight coverage estimates and sum ----
  cov <- sum(cov * weights)

  ## Return cov ----
  cov
}

#'
#' Calculate post-stratification weights
#' 
#' @keywords internal
#' 

calculate_weights <- function(pop_df, u5, p) {
  check_pop_data(pop_df)

  ## Calculate weights ----
  total_cases <- pop_df$pop * u5 * p
  weights <- total_cases / sum(total_cases) |>
    floor()

  ## Return weights ----
  weights
}


#'
#' @export
#' @rdname estimate_coverage
#' 

estimate_coverage <- function(cov_df, 
                               cov_type = c("cf", "tc"), 
                               k = 3) {
  check_coverage_data(cov_df)

  cov_type <- match.arg(cov_type)

  if (cov_type == "cf") {
    cov <- with(cov_df, squeacr::calculate_cf(cin = cases_in, cout = cases_out))
  } else {
    cov <- with(
      cov_df, 
      squeacr::calculate_tc(
        cin = cases_in, cout = cases_out, rin = rec_in, k = k
      )
    )
  }

  ## Return cov ----
  cov
}
