# Weighted post-stratification estimation of coverage over several service delivery units

Weighted post-stratification estimation of coverage over several service
delivery units

## Usage

``` r
estimate_coverage_overall(cov_df, pop_df, strata, u5, p, k = 3)

estimate_coverage(cov_df, cov_type = c("cf", "tc"), k = 3)
```

## Arguments

- cov_df:

  A [`data.frame()`](https://rdrr.io/r/base/data.frame.html) of
  stratified coverage survey data to get overall coverage estimates of.
  `cov_df` should have a variable named `cases_in` for number of SAM or
  MAM cases in the programme found during the survey, `cases_out` for
  number SAM or MAM cases not in the programme found during the survey,
  and `rec_in` for children recovering from SAM or MAM who are in the
  programme found during the survey. A final required variable should be
  one that contains identifying geographical information corresponding
  to the location from which each row of the survey data was collected
  from.

- pop_df:

  A [`data.frame()`](https://rdrr.io/r/base/data.frame.html) with at
  least two variables: `strata` for the stratification/grouping
  information that matches the grouping information in `cov_df` and
  `pop` for information on population for the given grouping
  information.

- strata:

  A character value of the variable name in `cov_df` that corresponds to
  the `strata` values to match with values in `pop_df`.

- u5:

  A numeric value for the proportion of the population that is under
  years old.

- p:

  Prevalence of SAM or MAM in the given population.

- k:

  Correction factor. Ratio of the mean length of an untreated episode to
  the mean length of a CMAM treatment episode

- cov_type:

  Coverage estimator to report. Either *"cf"* for *case-finding
  effectiveness* or *"tc"* for *treatment coverage*. Default is *"cf"*.

## Value

A list of overall coverage estimates with corresponding 95% confidence
intervals for case-finding effectiveness and treatment coverage.

## Examples

``` r
cov_df <- survey_data

pop_df <- pop_data |>
  setNames(nm = c("strata", "pop"))

estimate_coverage_overall(
  cov_df, pop_df, strata = "district", u5 = 0.177, p = 0.01
)
#> $cf
#> $cf$estimate
#> [1] 0.1257481
#> 
#> $cf$ci
#> [1] 0.09247579 0.15902045
#> 
#> 
#> $tc
#> $tc$estimate
#> [1] 0.1706466
#> 
#> $tc$ci
#> [1] 0.1371647 0.2041284
#> 
#> 
```
