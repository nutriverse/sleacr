#' 
#' Calculate the binomial coefficient *n-choose-k*
#'
#' @param n Total population
#' @param k Number of sample drawn from total population
#'
#' @returns A numeric value of binomial probability
#'
#' @keywords internal
#' 

get_binom_hypergeom <- function(n, k) {
  x <- 1

  for (i in seq_len(k)) {
    x <- x * (n - i + 1) / i
  }

  x
}


#' 
#' Calculate hypergeometric probability
#'
#' @param k Number of cases in the sample
#' @param m Number of cases in the population
#' @param n Sample size
#' @param N Population size
#'
#' @returns A numeric value of hypergeometric probability given specified
#'   parameters
#'
#' @keywords internal
#' 

get_hypergeom <- function(k, m, n, N) {
  p_cases <- get_binom_hypergeom(n = m, k = k)
  p_non_cases <- get_binom_hypergeom(n = N - m, k = n - k)
  total_population <- get_binom_hypergeom(n = N, k = n)

  (p_cases * p_non_cases) / total_population
}


#' 
#' Calculate cumulative hypergeometric probabilities
#'
#' @param k Number of cases in the sample
#' @param m Number of cases in the population
#' @param n Sample size
#' @param N Population size
#' @param tail A character vector indicating "lower" (default) or "upper" tail
#'
#' @returns A numeric value of cumulative hypergeometric probability given
#'   specified parameters 
#'
#' @keywords internal
#'

get_hypergeom_cumulative <- function(k, m, n, N, tail = "lower") {
  x <- 0

  for (i in 0:k) {
    x <- x + get_hypergeom(k = k, m = n, n = n, N = N)
  }

  if (tail == "upper") x <- 1 - x

  x
}

#'
#' Get low, moderate, and high probabilities per proportion
#' 
#' @param x A vector of low, moderate, and high classification labelled as
#'   1, 2, and 3 respectively.
#' 
#' @returns A table object of low, moderate, and high classification 
#'   probabilities
#' 
#' @keywords internal
#' 

get_classification_probabilities <- function(x) {
  factor(x, levels = c(1, 2, 3)) |>
    table() |>
    prop.table() |>
    (\(x) x * 100)()
}


#'
#' Check coverage data for post-stratification weighted estimation
#' 
#' @param cov_df A [data.frame()] of stratified coverage survey data.
#' 
#' @returns A message or an error on whether `cov_df` is structured
#'   appropriately for post-stratification weighted estimation.
#' 
#' @keywords internal
#' 

check_coverage_data <- function(cov_df) {
  ## Get cov_df name ----
  df_name <- deparse(substitute(cov_df))

  ## Check that cov_df is a data.frame ----
  if (!is.data.frame(cov_df))
    cli::cli_abort(
      "{.strong {df_name}} is not a {.var data.frame}"
    )
  
  ## Check that cov_df has the required variables ----
  df_names_check <- c("cases_in", "cases_out", "rec_in") %in% names(cov_df)
  df_names_missing <- names(cov_df)[!df_names_check]

  if (!all(df_names_check))
    cli::cli_abort(
      "Variable {.strong {df_names_missing}} not found or has different name."
    )
}


#'
#' Check population data for post-stratification weighted estimation
#' 
#' @param pop_df A [data.frame()] of population data.
#' 
#' @returns A message or an error on whether `pop_df` is structured
#'   appropriately for post-stratification weighted estimation.
#' 
#' @keywords internal
#' 

check_pop_data <- function(pop_df) {
  ## Get pop_df name ----
  df_name <- deparse(substitute(pop_df))

  ## Check that pop_df is a data.frame ----
  if (!is.data.frame(pop_df))
    cli::cli_abort(
      "{.strong {df_name}} is not a {.var data.frame}"
    )
  
  ## Check that pop_df has the required variables ----
  df_names_check <- c("strata", "pop") %in% names(pop_df)
  df_names_missing <- names(pop_df)[!df_names_check]

  if (!all(df_names_check))
    cli::cli_abort(
      "Variable {.strong {df_names_missing}} not found or has different name."
    )
}




