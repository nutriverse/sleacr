################################################################################
#
#' Calculate sample size of number of cases to be found to assess coverage
#'
#' @param c Total population size of cases in the specified survey area
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
#' get_n(c = 600, dLower = 0.7, dUpper = 0.9)
#'
#' @export
#'
#
################################################################################

get_n <- function(c, dLower, dUpper, alpha = 0.1, beta = 0.1) {

  low <- ceiling(dLower  * c)
  high <- ceiling(dUpper * c)

  d <- 0
  k <- d + 1

  observedAlpha <- 1
  observedBeta <- 1

  while(observedAlpha > alpha & k < c) {

    while(observedBeta <= beta & k < c) {
      k <- k + 1

      observedAlpha <- min(phyper(q = 0:(k + 1), m = high, n = c - high, k = k, lower.tail = TRUE))
      observedBeta <- 1 - min(phyper(q = 0:(k + 1), m = low, n = c - low, k = k, lower.tail = TRUE))

      if(observedAlpha <= alpha) break
    }

    if(observedAlpha <= alpha & observedBeta <= beta) break

    d = d + 1

    observedAlpha <- min(phyper(q = 0:(k + 1), m = high, n = c - high, k = k, lower.tail = TRUE))
    observedBeta <- 1 - min(phyper(q = 0:(k + 1), m = low, n = c - low, k = k, lower.tail = TRUE))
  }
  ## Concatenate results into a list
  results <- list(n = k, d = d + 1, alpha = observedAlpha, beta = observedBeta)
  ## Return results
  return(results)
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
#' ## Calculate number of SAM cases in a population of 100000 persons of all ages
#' ## with an under-5 population of 17% and a prevalence of 2%
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
#' @param N Population for all ages in the specified survey area
#' @param u5 Proportion (value from 0 to 1) of population that are aged 6-59
#'   months
#' @param p Prevalence of condition that is to be assessed
#'
#' @return Numeric value of the estimated number of clusters to sample to reach
#'   target sample size
#'
#' @examples
#' ## Calculate number of villages to sample given a population of 100000
#' ## persons of all ages with an under-5 population of 17% and a prevalence
#' ## of SAM of 2% if the target sample size is 40
#' get_n_clusters(n = 40, N = 100000, u5 = 0.17, p = 0.02)
#'
#' @export
#'
#
################################################################################

get_n_clusters <- function(n, N, u5, p) {
  ceiling(n / floor(N * u5 * p))
}

