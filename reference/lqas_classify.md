# LQAS classifier

LQAS classifier

## Usage

``` r
lqas_classify_(
  cases_in,
  cases_out,
  rec_in = NULL,
  k = 3,
  threshold = c(0.2, 0.5),
  label = FALSE
)

lqas_classify(
  cases_in,
  cases_out,
  rec_in = NULL,
  k = 3,
  threshold = c(0.2, 0.5),
  label = FALSE
)

lqas_classify_cf(cases_in, cases_out, threshold = c(0.2, 0.5), label = FALSE)

lqas_classify_tc(
  cases_in,
  cases_out,
  rec_in,
  k,
  threshold = c(0.2, 0.5),
  label = FALSE
)
```

## Arguments

- cases_in:

  Number of SAM and/or MAM cases found during the survey who are in the
  CMAM programme.

- cases_out:

  Number of SAM and/or MAM cases found during the survey who are in the
  CMAM programme.

- rec_in:

  Number of children recovering from SAM or MAM found during the survey
  who are in the programme.

- k:

  Correction factor. Ratio of the mean length of an untreated episode to
  the mean length of a CMAM treatment episode

- threshold:

  Decision rule threshold/s. Should be between 0 and 1. At least one
  threshold should be provided for a two-tier classifier. Two thresholds
  should be provided for a three-tier classifier. Default is a
  three-tier classifier with rule set at 0.2 and 0.5.

- label:

  Logical. Should the output results be classification labels? If TRUE,
  output classification are character labels else they are integer
  values. Default is FALSE.

## Value

A [`data.frame()`](https://rdrr.io/r/base/data.frame.html) of coverage
classifications for case-finding effectiveness and for treatment
coverage.

## Author

Ernest Guevarra

## Examples

``` r
lqas_classify(cases_in = 6, cases_out = 34, rec_in = 6)
#>   cf tc
#> 1  0  1

with(
  survey_data,
  lqas_classify(
    cases_in = cases_in, cases_out = cases_out, rec_in = rec_in
  )
)
#>    cf tc
#> 1   0  1
#> 2   0  0
#> 3   0  0
#> 4   0  0
#> 5   0  0
#> 6   0  1
#> 7   0  0
#> 8   1  1
#> 9   1  1
#> 10  1  1
#> 11  0  0
#> 12  0  0
#> 13  0  0
#> 14  0  0
```
