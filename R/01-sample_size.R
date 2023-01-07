################################################################################
#
#' Calculate the binomial coefficient "n-choose-k"
#'
#' @param n Total population
#' @param k Number of sample drawn from total population
#'
#' @return A numeric vector of binomial probability
#'
#' @examples
#' get_binom_hypergeom(n = 600, k = 40)
#'
#' @export
#'
#'
#
################################################################################

get_binom_hypergeom <- function(n, k) {
  x <- 1

  for(i in seq_len(k)) {
    x <- x * (n - i + 1) / i
  }

  x
}


################################################################################
#
#' Calculate hypergeometric probability
#'
#' @param k Number of cases in the sample
#' @param m Number of cases in the population
#' @param n Sample size
#' @param N Population size
#'
#' @return A numeric value of hypergeometric probability given specified
#'   parameters
#'
#' @examples
#' get_hypergeom(k = 5, m = 600, n = 25, N = 10000)
#'
#' @export
#'
#
################################################################################

get_hypergeom <- function(k, m, n, N) {
  p_cases <- get_binom_hypergeom(n = m, k = k)
  p_non_cases <- get_binom_hypergeom(n = N - m, k = n - k)
  total_population <- get_binom_hypergeom(n = N, k = n)

  (p_cases * p_non_cases) / total_population
}


################################################################################
#
#' Calculate cumulative hypergeometric probabilities
#'
#' @param k Number of cases in the sample
#' @param m Number of cases in the population
#' @param n Sample size
#' @param N Population size
#' @param tail A character vector indicating "lower" (default) or "upper" tail
#'
#' @examples
#' get_hypergeom_cumulative(k = 5, m = 600, n = 25, N = 10000)
#'
#' @export
#'
#
################################################################################

get_hypergeom_cumulative <- function(k, m, n, N, tail = "lower") {
  x <- 0

  for(i in 0:k) {
    x <- x + get_hypergeom(k = k, m = n, n = n, N = N)
  }
  if(tail == "upper") x <- 1 - x

  x
}

################################################################################
#
#' Calculate sample size of number of cases to be found to assess coverage
#'
#' @param N Total population size of cases in the specified survey area
#' @param dLower Lower triage threshold. Values from 0 to 1.
#' @param dUpper Upper triage threshold. Values from 0 to 1.
#' @param alpha Maximum tolerable alpha error. Values from 0 to 1.
#'   Default is 0.1
#' @param beta Maximum tolerable beta error. Values from 0 to 1. Default is 0.1
#'
#' @return A list of values providing the LQAS sampling plan for the specified
#'   parameters. The list includes sample size, decision rule, alpha error and
#'   beta error for the specified classification scheme
#'
#' @examples
#' get_n(N = 600, dLower = 0.7, dUpper = 0.9)
#'
#' @export
#'
#
################################################################################

get_n <- function(N, dLower, dUpper, alpha = 0.1, beta = 0.1) {
  low <- ceiling(dLower  * N)
  high <- ceiling(dUpper * N)

  d <- 0
  n <- d + 1

  observedAlpha <- 1
  observedBeta <- 1

  while (observedAlpha > alpha & n < N) {
    while (observedBeta <= beta & n < N) {
      n <- n + 1

      observedAlpha <- get_hypergeom_cumulative(
        k = d, m = high, n = n, N = N, tail = "lower"
      )

      observedBeta <- get_hypergeom_cumulative(
        k = d, m = low, n = n, N = N, tail = "upper"
      )
      if (observedAlpha <= alpha) break
    }

    if (observedAlpha <= alpha & observedBeta <= beta) break

    d = d + 1

    observedAlpha <- get_hypergeom_cumulative(
      k = d, m = high, n = n, N = N, tail = "lower"
    )

    observedBeta <- get_hypergeom_cumulative(
      k = d, m = low, n = n, N = N, tail = "upper"
    )
  }

  ## Concatenate results into a list
  results <- list(n = n, d = d + 1, alpha = observedAlpha, beta = observedBeta)

  ## Return results
  results
}


################################################################################
#
#' Calculate decision rule for a specified sample size and lower and upper
#' triage thresholds
#'
#' @param N Total population size of cases in the specified survey area
#' @param n Sample size
#' @param dLower Lower triage threshold. Values from 0 to 1.
#' @param dUpper Upper triage threshold. Values from 0 to 1.
#' @param alpha Maximum tolerable alpha error. Values from 0 to 1.
#'   Default is 0.1
#' @param beta Maximum tolerable beta error. Values from 0 to 1. Default is 0.1
#'
#' @return A list of values providing the LQAS sampling plan for the specified
#'   parameters. The list includes sample size, decision rule, alpha error and
#'   beta error for the specified classification scheme
#'
#' @examples
#' get_d(N = 600, n = 40, dLower = 0.7, dUpper = 0.9)
#'
#' @export
#'
#
################################################################################

get_d <- function(N, n, dLower, dUpper, alpha = 0.1, beta = 0.1) {
  low <- ceiling(dLower  * N)
  high <- ceiling(dUpper * N)

  d <- 0
  n <- d + 1

  observedAlpha <- 1
  observedBeta <- 1

  overallError <- 0
  bestError <- 1
  bestRule <- 0
  startRule <- dLower * n

  for (i in startRule:n) {
    observedAlpha <- get_hypergeom_cumulative(
      k = i, m = high, n = n, N = N, tail = "lower"
    )

    observedBeta <- get_hypergeom_cumulative(
      k = i, m = low, n = n, N = N, tail = "upper"
    )

    overallError <- observedAlpha + observedBeta

    if (overallError < bestError) {
      bestError <- overallError
      bestRule <- i
    }
  }

  d <- bestRule

  observedAlpha <- abs(
    get_hypergeom_cumulative(
      k = d, m = high, n = n, N = N, tail = "lower"
    )
  )

  observedBeta <- abs(
    get_hypergeom_cumulative(
      k = d, m = low, n = n, N = N, tail = "upper"
    )
  )

  ## Concatenate results into a list
  results <- list(n = n, d = d + 1, alpha = observedAlpha, beta = observedBeta)

  ## Return results
  results
}


################################################################################
#
#' Calculate estimated number of cases for a condition affecting children under
#' 5 years old in a specified survey area
#'
#' @param N Population for all ages in the specified survey area
#' @param u5 Proportion (value from 0 to 1) of population that are aged 6-59
#'   months
#' @param p Prevalence of condition that is to be assessed
#'
#' @return Numeric value of the estimated number of cases in the specified
#'   survey area
#'
#' @examples
#' ## Calculate number of SAM cases in a population of 100000 persons of all
#' ## ages with an under-5 population of 17% and a prevalence of 2%
#' get_n_cases(N = 100000, u5 = 0.17, p = 0.02)
#'
#' @export
#'
#
################################################################################

get_n_cases <- function(N, u5, p) {
  floor(N * u5 * p)
}


################################################################################
#
#' Calculate number of clusters to sample to reach target sample size
#'
#' @param n Target sample size of cases for the coverage survey
#' @param N Average cluster population for all ages in the specified survey area
#' @param u5 Proportion (value from 0 to 1) of population that are aged 6-59
#'   months
#' @param p Prevalence of condition that is to be assessed
#'
#' @return Numeric value of the estimated number of clusters to sample to reach
#'   target sample size
#'
#' @examples
#' ## Calculate number of villages to sample given an average village population
#' ## of 600 persons of all ages with an under-5 population of 17% and a
#' ## prevalence of SAM of 2% if the target sample size is 40
#' get_n_clusters(n = 40, N = 600, u5 = 0.17, p = 0.02)
#'
#' @export
#'
#
################################################################################

get_n_clusters <- function(n, N, u5, p) {
  ceiling(n / floor(N * u5 * p))
}

