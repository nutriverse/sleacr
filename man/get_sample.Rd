% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01-sample_size.R
\name{get_sample_n}
\alias{get_sample_n}
\alias{get_sample_d}
\title{Calculate sample size and decision rule for a specified LQAS sampling plan}
\usage{
get_sample_n(N, dLower, dUpper, alpha = 0.1, beta = 0.1)

get_sample_d(N, n, dLower, dUpper, alpha = 0.1, beta = 0.1)
}
\arguments{
\item{N}{Total population size of cases in the specified survey area}

\item{dLower}{Lower triage threshold. Values from 0 to 1.}

\item{dUpper}{Upper triage threshold. Values from 0 to 1.}

\item{alpha}{Maximum tolerable alpha error. Values from 0 to 1.
Default is 0.1}

\item{beta}{Maximum tolerable beta error. Values from 0 to 1. Default is 0.1}

\item{n}{Sample size}
}
\value{
A list of values providing the LQAS sampling plan for the specified
parameters. The list includes sample size, decision rule, alpha error and
beta error for the specified classification scheme
}
\description{
Calculate sample size and decision rule for a specified LQAS sampling plan
}
\examples{
get_sample_n(N = 600, dLower = 0.7, dUpper = 0.9)
get_sample_d(N = 600, n = 40, dLower = 0.7, dUpper = 0.9)

}
