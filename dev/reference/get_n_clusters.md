# Calculate number of clusters to sample to reach target sample size

Calculate number of clusters to sample to reach target sample size

## Usage

``` r
get_n_clusters(n, n_cluster, u5, p)
```

## Arguments

- n:

  Target sample size of cases for the coverage survey.

- n_cluster:

  Average cluster population for all ages in the specified survey area.

- u5:

  Proportion (value from 0 to 1) of population that are aged 6-59
  months.

- p:

  Prevalence (value from 0 to 1) of condition that is to be assessed.

## Value

A numeric value of the estimated number of clusters to sample to reach
target sample size.

## Examples

``` r
## Calculate number of villages to sample given an average village population
## of 600 persons of all ages with an under-5 population of 17% and a
## prevalence of SAM of 2% if the target sample size is 40
get_n_clusters(n = 40, n_cluster = 600, u5 = 0.17, p = 0.02)
#> [1] 20
```
