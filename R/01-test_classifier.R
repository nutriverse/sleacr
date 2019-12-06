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
#' run_lqas(data = make_data(proportion = 0.3, pop = 10000),
#'          n = 40, d.lower = 60, d.upper = 90)
#'
#' @export
#'
#
################################################################################

run_lqas <- function(data, n, d.lower, d.upper) {
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
#' simul_lqas(runs = 10, pop = 10000, n = 40, d.lower = 60, d.upper = 90)
#'
#' @export
#'
#
################################################################################

simul_lqas <- function(runs = 50,
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
      test.run <- cbind(data.frame(run_lqas(data = test.data,
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
    x <- rbind(x, simul_lqas(runs = runs,
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
  x <- list(x, d.lower, d.upper, p.lower, p.upper)
  names(x) <- c("x", "d.lower", "d.upper", "p.lower", "p.upper")
  ##
  class(x) <- "lqasSim"
  ##
  return(x)
}


################################################################################
#
#' Function to produce misclassification probabilities
#'
#' @param x Simulated results data produced by \code{test_lqas_classifier}
#'
#' @return A list of LQAS misclassification probabilities results
#'
#' @examples
#' sim <- test_lqas_classifier(replicates = 5, runs = 5,
#'                             pop = 10000, n = 40,
#'                             d.lower = 60, d.upper = 90)
#' get_class_prob(x = sim)
#'
#' @export
#'
#
################################################################################

get_class_prob <- function(x) {
  ## Create confusion matrix
  x[[1]]$true <- cut(x[[1]]$p, breaks = c(0, x$d.lower, x$d.upper, 100), labels = c(1, 2, 3))
  cm <- table(x[[1]]$true, x[[1]]$outcome)
  ## Calculate summary probability results
  correct <- diag(cm)
  denominators <- apply(cm, 1, sum)
  correct.proportion.by.group <- correct / denominators
  names(correct.proportion.by.group) <- c("Low", "Medium", "High")
  correct.proportion.overall <- sum(correct) / sum(denominators)
  gross.misclass <- (cm[1, 3] + cm[3, 1]) / sum(denominators)
  ## Organise probability results
  pLow <- correct.proportion.by.group["Low"]
  pModerate <- correct.proportion.by.group["Medium"]
  pHigh <- correct.proportion.by.group["High"]
  pOverall <- correct.proportion.overall
  pGross <- gross.misclass
  ##
  probs <- c(pLow, pModerate, pHigh, pOverall, pGross)
  names(probs) <- c("Low", "Medium", "High", "Overall", "Gross Missclassification")
  ## Concatenate outputs into a list
  results <- list(cm = cm, correct = correct,
                  denominators = denominators, probs = probs)
  ##
  class(results) <- "lqasClass"
  ##
  return(results)
}


################################################################################
#
#' \code{print} helper function for \code{get_class_prob} function
#'
#' @param x An object resulting from applying the \code{get_class_prob()}
#'   function.
#' @param ... Additional \code{print()} parameters
#'
#' @return Printed output of \code{get_class_prob()} function
#'
#' @examples
#' sim <- test_lqas_classifier(replicates = 5, runs = 5,
#'                             pop = 10000, n = 40,
#'                             d.lower = 60, d.upper = 90)
#' x <- get_class_prob(x = sim)
#' print(x)
#'
#' @export
#'
#
################################################################################

print.lqasClass <- function(x, ...) {
  cat("                    Low : ", round(x$probs[1], 4), "\n",
      "               Moderate : ", round(x$probs[2], 4), "\n",
      "                   High : ", round(x$probs[3], 4), "\n",
      "                Overall : ", round(x$probs[4], 4), "\n",
      "Gross misclassification : ", round(x$probs[5], 4), "\n\n", sep = "")
}


################################################################################
#
#' \code{plot} helper function for \code{test_lqas_classifier} function
#'
#' @param x An object of class \code{lqasSim} produced by
#'   \code{test_lqas_classifier} function
#' @param ... Additional \code{plot()} parameters
#'
#' @return An LQAS probability of classification plot
#'
#' @examples
#' x <- test_lqas_classifier(replicates = 5, runs = 5,
#'                           pop = 10000, n = 40, d.lower = 60, d.upper = 90)
#' plot(x)
#'
#' @export
#'
#
################################################################################

plot.lqasSim <- function(x, ...) {
  ## Probability of classification plot
  p <- vector(mode = "numeric", length = 0)
  p.low <- vector(mode = "numeric", length = 0)
  p.moderate <- vector(mode = "numeric", length = 0)
  p.high <- vector(mode = "numeric", length = 0)
  for (i in unique(x[[1]]$proportion)) {
    y <- subset(x[[1]], x[[1]]$proportion == i)
    n <- nrow(y)
    n.low <- length(y$outcome[y$outcome == 1])
    n.moderate <- length(y$outcome[y$outcome == 2])
    n.high <- length(y$outcome[y$outcome == 3])
    p <- c(p, i)
    p.low <- c(p.low, n.low / n)
    p.moderate <- c(p.moderate, n.moderate / n)
    p.high <- c(p.high, n.high / n)
  }
  #quartz(height = 6.5, width = 6.5, pointsize = 10)
  plot(c(x$d.lower, x$d.upper),
       c(0, 1),
       pch = "",
       xlab = "Indicator Proportion (%)",
       ylab = "Probability of Classification",
       frame.plot = FALSE,
       xlim = c(x$p.lower, x$p.upper),
       ylim = c(0, 1))
  points(p, p.low, pch = 6, cex= 0.5, col = "gray")
  points(p, p.moderate, pch = 5, cex= 0.5, col = "gray")
  points(p, p.high, pch = 2, cex= 0.5, col = "gray")
  lines(lowess(p, p.low, f = 0.02), col = "red", lwd = 2)
  lines(lowess(p, p.moderate, f = 0.02), col = "orange", lwd = 2)
  lines(lowess(p, p.high, f = 0.02), col = "green", lwd = 2)
  abline(v = x$d.lower, lty = 3); abline(v = x$d.upper, lty = 3)
  legend(x = "bottomright",
         legend = c("Low", "Moderate", "High"),
         cex = 0.8,
         lty = c(1, 1, 1),
         lwd = c(2, 2, 2),
         col = c("red", "orange", "green"),
         bg = "white",
         xjust = 1,
         yjust = 0,
         bty = "n")
}
