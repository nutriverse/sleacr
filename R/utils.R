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