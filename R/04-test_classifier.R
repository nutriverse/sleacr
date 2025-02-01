#' 
#' Simulate survey data of covered/cases and non-covered/non-cases given 
#' a coverage/prevalence proportion
#'
#' @param proportion A numeric value of a coverage/prevalence proportion to 
#'   simulate on. Values should be between 0 and 1.
#' @param pop Population size from which simulated coverage survey data is to
#'   be taken from
#'
#' @returns A data.frame with 2 variables: `id` for unique identifier and `case`
#'   for numeric vector of cases and non-cases (1s and 0s)
#'
#' @examples
#' lqas_simulate_population(proportion = 0.3, pop = 10000)
#'
#' @export
#' @rdname lqas_simulate
#'

lqas_simulate_population <- function(proportion, pop) {
  ## Check that proportion is within appropriate range ----
  if (proportion < 0 | proportion > 1) {
    stop(
      "Values for `proportion` should be between 0 and 1. Try again.",
      call. = TRUE
    )
  }

  ## Calculate number of covered/cases from population ---
  d <- round(pop * proportion)
  
  ## Create a vector of cases/covered and non-cases/non-covered ----
  case <- c(rep(1, d), rep(0, pop - d))

  ## Add unique identifier ----
  id <- seq_len(length(case))

  ## Concatenate results into a data.frame ----
  result <- data.frame(id, case)

  ## Return result ----
  result
}


#' 
#' Perform LQAS on simulated data based on specified decision rules
#'
#' @param proportion A numeric value of a coverage/prevalence proportion to 
#'   simulate on. Values should be between 0 and 1.
#' @param pop Population size from which simulated coverage survey data is to
#'   be taken from.
#' @param n Sample size of actual or test coverage data.
#' @param dLower A numeric value for the lower classification threshold
#'   proportion. Value should be between 0 and 1.
#' @param dUpper A numeric value for the upper classification threshold
#'   proportion. Value should be between 0 and 1.
#' @param pLower Starting proportion for simulations. Default is 0.
#' @param pUpper Ending proportion for simulations. Default is 1.
#' @param fine Granularity of simulated proportions. Default is 0.01.
#' @param runs Number of simulation runs to perform per coverage proportion.
#'   Default is 50 runs.
#' @param replicates Number of replicate LQAS simulations to perform.
#'   Default is set to 20 replicates.
#' @param cores The number of computer cores to use/number of child processes
#'   will be run simultaneously.
#'
#' @returns A data.frame with variable `cases` for total number of 
#'   covered/cases, `outcome` for LQAS outcome, and `proportion` for the
#'   coverage/prevalence proportion being simulated on. For 
#'   `[lqas_simulate_test()]`, a `sleac`` class object.
#'
#' @examples
#' lqas_simulate_run(
#'   proportion = 0.3, pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9
#' )
#' 
#' lqas_simulate_runs(
#'   pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, runs = 10
#' )
#' 
#' lqas_simulate_test(
#'   pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, runs = 5, replicates = 5
#' )
#'
#' @export
#' @rdname lqas_simulate
#'

lqas_simulate_run <- function(proportion, pop, n, dLower, dUpper) {
  ## Check that dLower and dUpper are numeric ----
  if (!is.numeric(dLower)) {
    stop(
      "Value for `dLower` must be numeric. Check value and try again.",
      call. = TRUE
    )
  }

  if (!is.numeric(dUpper)) {
    stop(
      "Value for `dUpper` must be numeric. Check value and try again.",
      call. = TRUE
    )
  }

  ## Check that dLower and dUpper are between 0 and 1 ----
  if (dLower <= 0 | dLower >= 1) {
    stop(
      "Value for `dLower` must be between 0 and 1. Check value and try again.",
      call. = TRUE
    )
  }

  if (dUpper <= 0 | dUpper >= 1) {
    stop(
      "Value for `dUpper` must be between 0 and 1. Check value and try again.",
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

  ## Simulate survey data based on proportion and population ----
  df <- lqas_simulate_population(proportion = proportion, pop = pop)

  ## Calculate decision thresholds ----
  d <- c(floor(n * dLower), floor(n * dUpper))

  ## Draw survey data ----
  survey_data <- df[sample(x = seq_len(nrow(df)), size = n, replace = FALSE), ]

  ## Count number of cases found in survey ----
  total_cases <- sum(survey_data$case)

  ## Determine LQAS classification based on number of covered/cases found ----
  result <- data.frame(cases = total_cases, outcome = 1)

  if (total_cases > d[1]) result <- data.frame(cases = total_cases, outcome = 2)
  if (total_cases > d[2]) result <- data.frame(cases = total_cases, outcome = 3)

  ## Add proportion ----
  result$proportion <- proportion

  ## Return result ----
  result
}

 
#'
#' @export
#' @rdname lqas_simulate
#'

lqas_simulate_runs <- function(pop,
                               n,
                               dLower,
                               dUpper,
                               pLower = 0,
                               pUpper = 1,
                               fine = 0.01,
                               runs = 50,
                               cores = parallelly::availableCores(omit = 1)) {
  proportion <- rep.int(
    seq(from = pLower, to = pUpper, by = fine), times = runs
  ) |>
    sort()
  
  result <- parallel::mclapply(
    X = proportion,
    FUN = lqas_simulate_run,
    pop = pop,
    n = n,
    dLower = dLower,
    dUpper = dUpper,
    mc.cores = cores
  ) |>
    do.call(rbind, args = _)

  ## Return result ----
  result
}


#'
#' @export
#' @rdname lqas_simulate
#' 

lqas_simulate_test <- function(pop,
                               n,
                               dLower,
                               dUpper,
                               pLower = 0,
                               pUpper = 1,
                               fine = 0.01,
                               runs = 50,
                               replicates = 20,
                               cores = parallelly::availableCores(omit = 1)) {
  proportion <- rep.int(
    seq(from = pLower, to = pUpper, by = fine), times = runs
  ) |>
    sort() |>
    rep(times = replicates)

  x <- parallel::mclapply(
    X = proportion,
    FUN = lqas_simulate_run,
    pop = pop,
    n = n,
    dLower = dLower,
    dUpper = dUpper,
    mc.cores = cores
  ) |>
    do.call(rbind, args = _)

  ## concatenate parameters and results
  x <- list(x, dLower, dUpper, pLower = pLower, pUpper = pUpper)

  names(x) <- c("x", "dLower", "dUpper", "pLower", "pUpper")

  ## Define class of results
  class(x) <- "lqasSim"

  ## Return x
  x
}


#' 
#' Produce misclassification probabilities
#'
#' @param x Simulated results data produced by [lqas_simulate_test()]
#'
#' @returns A list object of class `lqasClass` for LQAS misclassification 
#'   probabilities results
#'
#' @examples
#' sim <- lqas_simulate_test(
#'   pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, replicates = 5, runs = 5
#' )
#' 
#' lqas_get_class_prob(x = sim)
#'
#' @export
#'

lqas_get_class_prob <- function(x) {
  ## Create confusion matrix ----
  x[[1]]$true <- cut(
    x[[1]]$proportion * 100,
    breaks = c(0, x$dLower * 100, x$dUpper * 100, 100),
    labels = c(1, 2, 3)
  )

  cm <- table(x[[1]]$true, x[[1]]$outcome)

  ## Calculate summary probability results ----
  correct <- diag(cm)
  denominators <- apply(cm, 1, sum)
  correct_proportion_by_group <- correct / denominators
  names(correct_proportion_by_group) <- c("Low", "Medium", "High")
  correct_proportion_overall <- sum(correct) / sum(denominators)
  gross_misclass <- (cm[1, 3] + cm[3, 1]) / sum(denominators)

  ## Organise probability results ----
  pLow      <- correct_proportion_by_group["Low"]
  pModerate <- correct_proportion_by_group["Medium"]
  pHigh     <- correct_proportion_by_group["High"]
  pOverall  <- correct_proportion_overall
  pGross    <- gross_misclass

  ## Concatenate probabilities ----
  probs <- c(pLow, pModerate, pHigh, pOverall, pGross)
  names(probs) <- c(
    "Low", "Medium", "High", "Overall", "Gross Misclassification"
  )

  ## Concatenate outputs into a list ----
  results <- list(
    cm = cm, 
    correct = correct,
    denominators = denominators, 
    probs = probs
  )

  ## Set lqasClass ----
  class(results) <- "lqasClass"

  ## Return result ----
  results
}


#' 
#' `print` helper function for [lqas_get_class_prob()] function
#'
#' @param x An object resulting from applying the [lqas_get_class_prob()]
#'   function.
#' @param ... Additional `print` parameters
#'
#' @return Printed output of [lqas_get_class_prob()] function
#'
#' @examples
#' sim <- lqas_simulate_test(
#'   pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, replicates = 5, runs = 5
#' )
#' 
#' x <- lqas_get_class_prob(x = sim)
#' print(x)
#'
#' @export
#'

print.lqasClass <- function(x, ...) {
  cat("                    Low : ", round(x$probs[1], 4), "\n",
      "               Moderate : ", round(x$probs[2], 4), "\n",
      "                   High : ", round(x$probs[3], 4), "\n",
      "                Overall : ", round(x$probs[4], 4), "\n",
      "Gross misclassification : ", round(x$probs[5], 4), "\n\n", sep = "")
}


#' 
#' `plot` helper function for [lqas_simulate_test()] function
#'
#' @param x An object of class `lqasSim` produced by
#'   [lqas_simulate_test()] function
#' @param ... Additional `plot` parameters
#'
#' @return An LQAS probability of classification plot
#'
#' @examples
#' x <- lqas_simulate_test(
#'   pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, replicates = 5, runs = 5
#' )
#' plot(x)
#'
#' @export
#'

plot.lqasSim <- function(x, ...) {
  ## Group outcomes by proportion ----
  y <- split(x[[1]]$outcome, x[[1]]$proportion)

  ## Get low, moderate, and high proportions ----
  z <- lapply(X = y, FUN = get_classification_probabilities) |>
    (\(x) do.call(rbind, x))()

  p <- as.numeric(names(y)) * 100

  ## Probability of classification plot

  plot(
    x = c(x$dLower, x$dUpper),
    y = c(0, 100),
    pch = "",
    xlab = "Indicator Proportion (%)",
    ylab = "Probability of Classification",
    frame.plot = FALSE,
    xlim = c(x$pLower * 100, x$pUpper * 100),
    ylim = c(0, 100)
  )

  points(p, z[ , 1], pch = 6, cex= 0.5, col = "gray")
  points(p, z[ , 2], pch = 5, cex= 0.5, col = "gray")
  points(p, z[ , 3], pch = 2, cex= 0.5, col = "gray")
  
  lines(lowess(p, z[ , 1], f = 0.02), col = "red", lwd = 2)
  lines(lowess(p, z[ , 2], f = 0.02), col = "orange", lwd = 2)
  lines(lowess(p, z[ , 3], f = 0.02), col = "green", lwd = 2)
  
  abline(v = x$dLower * 100, lty = 3)
  abline(v = x$dUpper * 100, lty = 3)
  
  legend(
    x = "bottomright",
    legend = c("Low", "Moderate", "High"),
    cex = 0.8,
    lty = c(1, 1, 1),
    lwd = c(2, 2, 2),
    col = c("red", "orange", "green"),
    bg = "white",
    xjust = 1,
    yjust = 0,
    bty = "n"
  )
}
