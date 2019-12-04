################################################################################
#
#' Function to simulate survey data of covered/cases and non-covered/non-cases
#' given specified parameters
#'
#' @param proportion A numeric value of a coverage proportion to simulate on
#' @param pop Population size from which simulated coverage survey data is to
#'   be taken from
#'
#' @return A numeric vector of cases and non-cases (1s and 0s)
#'
#' @examples
#' make_data(proportion = 0.3, pop = 10000)
#'
#' @export
#'
#
################################################################################

make_data <- function(proportion, pop) {
  d <- round(pop * (proportion / 100))
  case <- c(rep(1, d), rep(0, pop - d))
  id <- 1:length(case)
  result <- data.frame(cbind(id, case))
  return(result)
}

################################################################################
#
#' Function to perform LQAS based on data based on specified decision rules
#'
#' @param data A vector of simulated data produced by \code{make_data}
#' @param n Sample size of actual or test coverage data
#' @param d.lower A numeric value for the lower classification threshold
#' @param d.upper A numeric value for the upper classification threshold
#'
#' @return A list of coverage proportions and LQAS outcomes
#'
#' @examples
#' lqas_run(data = make_data(proportion = 0.3, pop = 10000),
#'          n = 40, d.lower = 60, d.upper = 90)
#'
#' @export
#'
#
################################################################################

lqas_run <- function(data, n, d.lower, d.upper) {
  ##
  d <- c(floor(n * (d.lower / 100)), floor(n * (d.upper / 100)))
  ##
  survey.data <- data.frame(data[sample(x = 1:nrow(data),
                                        size = n,
                                        replace = FALSE), ])
  d.run <- sum(survey.data$case)
  result <- list(d = d.run, outcome = 1)
  if (d.run > d[1])
  {
    result <- list(d = d.run, outcome = 2)
  }
  if (d.run > d[2])
  {
    result <- list(d = d.run, outcome = 3)
  }
  return(result)
}


################################################################################
#
#' Function to perform a series of LQAS analysis on simulated coverage survey
#' data
#'
#' @param runs Number of simulation runs to perform per coverage proportion.
#'   Default is 50 runs
#' @param pop Population size from which simulated coverage survey data is to
#'   be taken from
#' @param n Sample size of actual or test coverage data
#' @param d.lower A numeric value for the lower classification threshold
#' @param d.upper A numeric value for the upper classification threshold
#' @param p.lower Starting proportion for simulations. Default is 0
#' @param p.upper Ending proportion for simulations. Default is 100
#' @param fine Granularity of simulated proportiongs; Defaul to 1
#' @param progress Logical. Should simulation progress be shown?
#'   Default is TRUE
#'
#' @return A data.frame of coverage proportions and LQAS outcomes
#'
#' @examples
#' lqas_simul(runs = 10, pop = 10000, n = 40, d.lower = 60, d.upper = 90)
#'
#' @export
#'
#
################################################################################

lqas_simul <- function(runs = 50,
                       pop = NULL,
                       n,
                       d.lower,
                       d.upper,
                       p.lower = 0,
                       p.upper = 100,
                       fine = 1,
                       progress = TRUE) {
  ##
  result <- data.frame()
  ##
  for(proportion in seq(from = p.lower, to = p.upper, by = fine)) {
    if(progress) {
      cat("Running simulations for proportion := ", proportion, "%\n", sep = "")
    }
    ##
    test.data <- make_data(proportion, pop = pop)
    ##
    for(i in 1:runs) {
      test.run <- cbind(data.frame(lqas_run(data = test.data,
                                            n = n,
                                            d.lower = d.lower,
                                            d.upper = d.upper)), proportion)
      result <- rbind(result, test.run)
    }
  }
  return(result)
}


################################################################################
#
#' Function to test performance of LQAS classifier
#'
#' @param replicates Number of replicate LQAS simulations to perform.
#'   Default is set to 20 replicates
#' @param runs Number of simulation runs to perform per coverage proportion.
#'   Default is 50 runs
#' @param pop Population size from which simulated coverage survey data is to
#'   be taken from
#' @param n Sample size of actual or test coverage data
#' @param d.lower A numeric value for the lower classification threshold
#' @param d.upper A numeric value for the upper classification threshold
#' @param p.lower Starting proportion for simulations. Default is 0
#' @param p.upper Ending proportion for simulations. Default is 100
#' @param fine Granularity of simulated proportiongs; Defaul to 1
#' @param progress Logical. Should simulation progress be shown? Default is TRUE
#'
#' @return A sleac object
#'
#' @examples
#'
#' test_lqas_classifier(replicates = 5, runs = 5,
#'                      pop = 10000, n = 40, d.lower = 60, d.upper = 90)
#'
#' @export
#'
#
################################################################################

test_lqas_classifier <- function(replicates = 20,
                                 runs = 50,
                                 pop = NULL,
                                 n = NULL,
                                 d.lower = NULL,
                                 d.upper = NULL,
                                 p.lower = 0,
                                 p.upper = 100,
                                 fine = 1,
                                 progress = TRUE) {
  ## Create concatenating object for replicate simulations
  x <- NULL
  ## Cycle through number of replicate simulations
  for(i in 1:replicates) {
    x <- rbind(x, lqas_simul(runs = runs,
                             pop = pop,
                             n = n,
                             d.lower = d.lower,
                             d.upper = d.upper,
                             p.lower = p.lower,
                             p.upper = p.upper,
                             fine = 1,
                             progress = progress))
  }
  ##
  return(x)
}
