# Calculate estimated number of cases for a condition affecting children under 5 years old in a specified survey area

Calculate estimated number of cases for a condition affecting children
under 5 years old in a specified survey area

## Usage

``` r
get_n_cases(N, u5, p)
```

## Arguments

- N:

  Population for all ages in the specified survey area.

- u5:

  Proportion (value from 0 to 1) of population that are aged 6-59
  months.

- p:

  Prevalence (value from 0 to 1) of condition that is to be assessed.

## Value

A numeric value of the estimated number of cases in the specified survey
area

## Examples

``` r
## Calculate number of SAM cases in a population of 100000 persons of all
## ages with an under-5 population of 17% and a prevalence of 2%
get_n_cases(N = 100000, u5 = 0.17, p = 0.02)
#> [1] 340
```
