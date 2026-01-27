# Calculate sample size and decision rule for a specified LQAS sampling plan

Calculate sample size and decision rule for a specified LQAS sampling
plan

## Usage

``` r
get_sample_n(N, dLower, dUpper, alpha = 0.1, beta = 0.1)

get_sample_d(N, n, dLower, dUpper, alpha = 0.1, beta = 0.1)
```

## Arguments

- N:

  Total population size of cases in the specified survey area

- dLower:

  Lower triage threshold. Values from 0 to 1.

- dUpper:

  Upper triage threshold. Values from 0 to 1.

- alpha:

  Maximum tolerable alpha error. Values from 0 to 1. Default is 0.1

- beta:

  Maximum tolerable beta error. Values from 0 to 1. Default is 0.1

- n:

  Sample size

## Value

A list of values providing the LQAS sampling plan for the specified
parameters. The list includes sample size, decision rule, alpha error
and beta error for the specified classification scheme

## Examples

``` r
get_sample_n(N = 600, dLower = 0.7, dUpper = 0.9)
#> $n
#> [1] 25
#> 
#> $d
#> [1] 20
#> 
#> $alpha
#> [1] 0.09357163
#> 
#> $beta
#> [1] 0.08585219
#> 
get_sample_d(N = 600, n = 40, dLower = 0.7, dUpper = 0.9)
#> $n
#> [1] 40
#> 
#> $d
#> [1] 32
#> 
#> $alpha
#> [1] 0.03637535
#> 
#> $beta
#> [1] 0.04944484
#> 
```
