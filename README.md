
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sleacr: Simplified Lot Quality Assurance Sampling Evaluation of Access and Coverage (SLEAC) Tools in R

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/nutriverse/sleacr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nutriverse/sleacr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/nutriverse/sleacr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/nutriverse/sleacr?branch=main)
[![CodeFactor](https://www.codefactor.io/repository/github/nutriverse/sleacr/badge)](https://www.codefactor.io/repository/github/nutriverse/sleacr)
<!-- badges: end -->

In the recent past, measurement of coverage has been mainly through
two-stage cluster sampled surveys either as part of a nutrition
assessment or through a specific coverage survey known as Centric
Systematic Area Sampling (CSAS). However, such methods are resource
intensive and often only used for final programme evaluation meaning
results arrive too late for programme adaptation. SLEAC, which stands
for Simplified Lot Quality Assurance Sampling Evaluation of Access and
Coverage, is a low resource method designed specifically to address this
limitation and is used regularly for monitoring, planning and
importantly, timely improvement to programme quality, both for agency
and Ministry of Health (MoH) led programmes. This package provides
functions for use in conducting a SLEAC assessment.

## Installation

The `sleacr` package is not yet available on
[CRAN](https://cran.r-project.org). You can install the development
version of `sleacr` from [GitHub](https://github.com/nutriverse/sleacr)
with:

``` r
if (!require(remotes)) install.packages("remotes")
remotes::install_github("nutriverse/sleacr")
```

## What does `sleacr` do?

The `sleacr` package provides functions that facilitate the design,
sampling, data collection, and data analysis of a SLEAC survey. The
current version of the `sleacr` package currently provides the
following:

- Functions to calculate the sample size needed for a SLEAC survey;

- Functions to draw a stage 1 sample for a SLEAC survey;

- Functions to determine the performance of chosen classifier cut-offs
  for analysis of SLEAC survey data.

## Citation

If you find the `sleacr` package useful, please cite using the suggested
citation provided by a call to the `citation` function as follows:

``` r
citation("sleacr")
#> 
#> To cite sleacr in publications use:
#> 
#>   Ernest Guevarra (2023). sleacr: Simplified Lot Quality Assurance
#>   Sampling Evaluation of Access and Coverage (SLEAC) Tools in R R
#>   package version 0.0.0.9000 URL https://nutriverse.io/sleacr/
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {sleacr: Simplified Lot Quality Assurance Sampling Evaluation of Access and Coverage (SLEAC) Tools in R},
#>     author = {{Ernest Guevarra}},
#>     year = {2023},
#>     note = {R package version 0.0.0.9000},
#>     url = {https://nutriverse.io/sleacr/},
#>   }
```

## Community guidelines

Feedback, bug reports, and feature requests are welcome; file issues or
seek support [here](https://github.com/nutriverse/sleacr/issues). If you
would like to contribute to the package, please see our [contributing
guidelines](https://nutriverse.io/sleacr/CONTRIBUTING.html).

This project is released with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
