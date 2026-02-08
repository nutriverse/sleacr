# Check coverage distribution

Check coverage distribution

## Usage

``` r
check_coverage_homogeneity(cov_df, k = 3, p = 0.05)
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

- k:

  Correction factor. Ratio of the mean length of an untreated episode to
  the mean length of a CMAM treatment episode

- p:

  Minimum p-value to test statistic. Default is 0.05.

## Value

A named list of 2 lists: one for case-finding effectiveness (*cf*) and
the second for treatment coverage (*tc*). For each list, the following
values are provided:

- **statistic** - calculated chi-square statistic

- **df** - degrees of freedom

- **p** - p-value of chi-square statistic

## Examples

``` r
check_coverage_homogeneity(survey_data)
#> ℹ Case-finding effectiveness across 14 surveys is not patchy.
#> ! Treatment coverage across 14 surveys is patchy.
#> $cf
#> $cf$statistic
#> [1] 20.1292
#> 
#> $cf$df
#> [1] 13
#> 
#> $cf$p
#> [1] 0.09203514
#> 
#> 
#> $tc
#> $tc$statistic
#> [1] 33.10622
#> 
#> $tc$df
#> [1] 13
#> 
#> $tc$p
#> [1] 0.001642536
#> 
#> 
```
