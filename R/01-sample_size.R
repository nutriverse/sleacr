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
  ## Check that dLower and dUpper are within 0 to 1 ----
  if (dLower < 0 | dLower > 1) {
    stop(
      "The value for `dLower` should be from 0 and 1. ",
      "Check value and try again.",
      call. = TRUE
    )
  }

  if (dUpper < 0 | dUpper > 1) {
    stop(
      "The value for `dUpper` should be from 0 and 1. ",
      "Check value and try again.",
      call. = TRUE
    )
  }

  ## Check that dLower is less than dUpper ----
  if (dLower > dUpper) {
    stop(
      "Value for `dLower` should be less than `dUpper`. Check values ",
      "and try again.",
      call. = TRUE
    )
  }

  ## Check that alpha and beta error values are within 0 and 1 ----
  if (alpha < 0 | alpha > 1) {
    stop(
      "The value for `alpha` should be from 0 and 1. ",
      "Check value and try again.",
      call. = TRUE
    )
  }

  if (beta < 0 | beta > 1) {
    stop(
      "The value for `beta` should be from 0 and 1. ",
      "Check value and try again.",
      call. = TRUE
    )
  }  

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
  ## Check that dLower and dUpper are within 0 to 1 ----
  if (dLower < 0 | dLower > 1) {
    stop(
      "The value for `dLower` should be from 0 and 1. ",
      "Check value and try again.",
      call. = TRUE
    )
  }

  if (dUpper < 0 | dUpper > 1) {
    stop(
      "The value for `dUpper` should be from 0 and 1. ",
      "Check value and try again.",
      call. = TRUE
    )
  }

  ## Check that dLower is less than dUpper ----
  if (dLower > dUpper) {
    stop(
      "Value for `dLower` should be less than `dUpper`. Check values ",
      "and try again.",
      call. = TRUE
    )
  }

  ## Check that alpha and beta error values are within 0 and 1 ----
  if (alpha < 0 | alpha > 1) {
    stop(
      "The value for `alpha` should be from 0 and 1. ",
      "Check value and try again.",
      call. = TRUE
    )
  }

  if (beta < 0 | beta > 1) {
    stop(
      "The value for `beta` should be from 0 and 1. ",
      "Check value and try again.",
      call. = TRUE
    )
  }

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
#' @param N Population for all ages in the specified survey area.
#' @param u5 Proportion (value from 0 to 1) of population that are aged 6-59
#'   months.
#' @param p Prevalence (value from 0 to 1) of condition that is to be assessed.
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
  if (u5 < 0 | u5 > 1) {
    stop(
      "The value for `u5` should be from 0 to 1. Check value and try again.",
      call. = TRUE
    )
  }

  if (p < 0 | p > 1) {
    stop(
      "The value for `p` should be from 0 to 1. Check value and try again.",
      call. = TRUE
    )
  }

  floor(N * u5 * p)
}


#' 
#' Calculate number of clusters to sample to reach target sample size
#'
#' @param n Target sample size of cases for the coverage survey.
#' @param n_cluster Average cluster population for all ages in the specified
#'   survey area.
#' @param u5 Proportion (value from 0 to 1) of population that are aged 6-59
#'   months.
#' @param p Prevalence (value from 0 to 1) of condition that is to be assessed.
#'
#' @returns A numeric value of the estimated number of clusters to sample to 
#'   reach target sample size.
#'
#' @examples
#' ## Calculate number of villages to sample given an average village population
#' ## of 600 persons of all ages with an under-5 population of 17% and a
#' ## prevalence of SAM of 2% if the target sample size is 40
#' get_n_clusters(n = 40, n_cluster = 600, u5 = 0.17, p = 0.02)
#'
#' @export
#'

get_n_clusters <- function(n, n_cluster, u5, p) {
  ceiling(n / get_n_cases(N = n_cluster, u5 = u5, p = p))
}

