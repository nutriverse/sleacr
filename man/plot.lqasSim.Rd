% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/04-test_classifier.R
\name{plot.lqasSim}
\alias{plot.lqasSim}
\title{\code{plot} helper function for \code{\link[=lqas_simulate_test]{lqas_simulate_test()}} function}
\usage{
\method{plot}{lqasSim}(x, ...)
}
\arguments{
\item{x}{An object of class \code{lqasSim} produced by
\code{\link[=lqas_simulate_test]{lqas_simulate_test()}} function}

\item{...}{Additional \code{plot} parameters}
}
\value{
An LQAS probability of classification plot
}
\description{
\code{plot} helper function for \code{\link[=lqas_simulate_test]{lqas_simulate_test()}} function
}
\examples{
x <- lqas_simulate_test(
  pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, replicates = 5, runs = 5
)
plot(x)

}
