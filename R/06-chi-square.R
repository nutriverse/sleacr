#'
#' Check coverage distribution
#' 
#' @inheritParams estimate_coverage_overall
#' @param p Minimum p-value to test statistic. Default is 0.05.
#' 
#' @returns A named list of 2 lists: one for case-finding effectiveness (*cf*)
#'   and the second for treatment coverage (*tc*). For each list, the following
#'   values are provided:
#'   * **statistic** - calculated chi-square statistic
#'   * **df** - degrees of freedom
#'   * **p** - p-value of chi-square statistic
#' 
#' @examples
#' check_coverage_homogeneity(survey_data)
#' 
#' @export
#' 

check_coverage_homogeneity <- function(cov_df, k = 3, p = 0.05) {
  ## Check coverage data ----
  check_coverage_data(cov_df)

  ## Check p ----
  check_p(p)

  ## Calculate chi-square statistic ----
  x2 <- calculate_x2_stat(
    cases_in = cov_df$cases_in, cases_out = cov_df$cases_out, 
    rec_in = cov_df$rec_in, k = k
  )

  ## Sum of chi-square statistics ----
  x2_cf <- sum(x2[[1]])
  x2_tc <- sum(x2[[2]])

  deg_free <- nrow(cov_df) - 1

  ## Get critical value ----
  #crit_value <- get_critical_value(df = deg_free, p = as.character(p))

  p_cf <- stats::pchisq(x2_cf, df = deg_free, lower.tail = FALSE)
  p_tc <- stats::pchisq(x2_tc, df = deg_free, lower.tail = FALSE)

  ## Concatenate results ----
  x2_results <- list(
    cf = list(
      statistic = x2_cf,
      df = deg_free,
      p = p_cf
    ),
    tc = list(
      statistic = x2_tc,
      df = deg_free,
      p = p_tc
    )
  )

  ## Create messages ----
  if (p_cf < p) {
    cli::cli_alert_warning(
      "{.strong Case-finding effectiveness} across {nrow(cov_df)} surveys is {.strong patchy}."
    )
  } else {
    cli::cli_alert_info(
      "{.strong Case-finding effectiveness} across {nrow(cov_df)} surveys is {.strong not patchy}."
    )
  }

  if (p_tc < p) {
    cli::cli_alert_warning(
      "{.strong Treatment coverage} across {nrow(cov_df)} surveys is {.strong patchy}."
    )
  } else {
    cli::cli_alert_info(
      "{.strong Treatment coverage} across {nrow(cov_df)} surveys is {.strong not patchy}."
    )
  }

  ## Return x2_results ----
  x2_results
}


#'
#' @keywords internal
#' 

calculate_x2_stat <- function(cases_in, cases_out, rec_in, k = 3) {
  ## Get observed ----
  observed_cf <- cases_in
  observed_tc <- cases_in + rec_in

  ## Calculate rec_out ----
  rec_out <- squeacr::calculate_rout(
    cin = cases_in, cout = cases_out, rin = rec_in, k = k
  )

  ## Calculate variables needed ----
  cases_cf <- cases_in + cases_out
  cases_tc <- cases_in + cases_out + rec_in + rec_out

  total_cases_cf <- sum(cases_cf)
  total_cases_tc <- sum(cases_tc)

  total_cases_in_cf <- sum(cases_in)
  total_cases_in_tc <- sum(cases_in + rec_in)

  ## Calculate expected ----
  expected_cf <- cases_cf * (total_cases_in_cf / total_cases_cf)
  expected_tc <- cases_tc * (total_cases_in_tc / total_cases_tc) 

  ## Calculate chi-square ----
  x2_cf <- ((observed_cf - expected_cf) ^ 2) / expected_cf
  x2_tc <- ((observed_tc - expected_tc) ^ 2) / expected_tc

  ## Concatenate ----
  x2 <- list(cf = x2_cf, tc = x2_tc)

  ## Return chi-square ----
  x2
}

