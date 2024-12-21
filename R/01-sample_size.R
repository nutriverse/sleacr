#' 
#' Calculate sample size and decision rule for a specified LQAS sampling plan
#'
#' @param N Total population size of cases in the specified survey area
#' @param n Sample size
#' @param dLower Lower triage threshold. Values from 0 to 1.
#' @param dUpper Upper triage threshold. Values from 0 to 1.
#' @param alpha Maximum tolerable alpha error. Values from 0 to 1.
#'   Default is 0.1
#' @param beta Maximum tolerable beta error. Values from 0 to 1. Default is 0.1
#'
#' @returns A list of values providing the LQAS sampling plan for the specified
#'   parameters. The list includes sample size, decision rule, alpha error and
#'   beta error for the specified classification scheme
#'
#' @examples
#' get_sample_n(N = 600, dLower = 0.7, dUpper = 0.9)
#' get_sample_d(N = 600, n = 40, dLower = 0.7, dUpper = 0.9)
#'
#' @export
#' @rdname get_sample
#'

get_sample_n <- function(N, dLower, dUpper, alpha = 0.1, beta = 0.1) {
  low <- ceiling(dLower  * N)
  high <- ceiling(dUpper * N)

  d <- 0
  n <- d + 1

  observedAlpha <- 1
  observedBeta <- 1

  while (observedAlpha > alpha && n < N) {
    while (observedBeta <= beta && n < N) {
      n <- n + 1
  
      observedAlpha <- phyper(
        q = d, m = high, n = N - high, k = n, lower.tail = TRUE
      )
    
      observedBeta <- phyper(
        q = d, m = low, n = N - low, k = n, lower.tail = FALSE
      )
      
      if (observedAlpha <= alpha) break
    }
  
    if (observedAlpha <= alpha && observedBeta <= beta) break
  
    d <- d + 1
  
    observedAlpha <- phyper(
      q = d, m = high, n = N - high, k = n, lower.tail = TRUE
    )
  
    observedBeta <- phyper(
      q = d, m = low, n = N - low, k = n, lower.tail = FALSE
    )
  }

  ## Concatenate results into a list
  results <- list(n = n, d = d, alpha = observedAlpha, beta = observedBeta)

  ## Return results
  results
}


#'
#' @export
#' @rdname get_sample
#'

get_sample_d <- function(N, n, dLower, dUpper, alpha = 0.1, beta = 0.1) {
  low <- ceiling(dLower  * N)
  high <- ceiling(dUpper * N)

  observedAlpha <- 1
  observedBeta <- 1

  overallError <- 0
  bestError <- 1
  bestRule <- 0
  startRule <- dLower * n

  for (d in startRule:n) {
    observedAlpha <- phyper(
      q = d, m = high, n = N - high, k = n, lower.tail = TRUE
    )

    observedBeta <- phyper(
      q = d, m = low, n = N - low, k = n, lower.tail = FALSE
    )
      
    overallError <- observedAlpha + observedBeta

    if (overallError < bestError) {
      bestError <- overallError
      bestRule <- d
    }
  }

  d <- bestRule

  observedAlpha <- abs(
    phyper(q = d, m = high, n = N - high, k = n, lower.tail = TRUE)
  )

  observedBeta <- abs(
    phyper(q = d, m = low, n = N - low, k = n, lower.tail = FALSE)
  )

  ## Concatenate results into a list
  results <- list(n = n, d = d, alpha = observedAlpha, beta = observedBeta)

  ## Return results
  results
}


#' 
#' Calculate estimated number of cases for a condition affecting children under
#' 5 years old in a specified survey area
#'
#' @param N Population for all ages in the specified survey area
#' @param u5 Proportion (value from 0 to 1) of population that are aged 6-59
#'   months
#' @param p Prevalence of condition that is to be assessed
#'
#' @returns A numeric value of the estimated number of cases in the specified
#'   survey area
#'
#' @examples
#' ## Calculate number of SAM cases in a population of 100000 persons of all
#' ## ages with an under-5 population of 17% and a prevalence of 2%
#' get_n_cases(N = 100000, u5 = 0.17, p = 0.02)
#'
#' @export
#'

get_n_cases <- function(N, u5, p) {
  floor(N * u5 * p)
}


#' 
#' Calculate number of clusters to sample to reach target sample size
#'
#' @param n Target sample size of cases for the coverage survey
#' @param N Average cluster population for all ages in the specified survey area
#' @param u5 Proportion (value from 0 to 1) of population that are aged 6-59
#'   months
#' @param p Prevalence of condition that is to be assessed
#'
#' @returns A numeric value of the estimated number of clusters to sample to 
#'   reach target sample size
#'
#' @examples
#' ## Calculate number of villages to sample given an average village population
#' ## of 600 persons of all ages with an under-5 population of 17% and a
#' ## prevalence of SAM of 2% if the target sample size is 40
#' get_n_clusters(n = 40, N = 600, u5 = 0.17, p = 0.02)
#'
#' @export
#'

get_n_clusters <- function(n, N, u5, p) {
  ceiling(n / floor(N * u5 * p))
}

