# Produce misclassification probabilities

Produce misclassification probabilities

## Usage

``` r
lqas_get_class_prob(x)
```

## Arguments

- x:

  Simulated results data produced by
  [`lqas_simulate_test()`](https://nutriverse.io/sleacr/reference/lqas_simulate.md)

## Value

A list object of class `lqasClass` for LQAS misclassification
probabilities results

## Examples

``` r
sim <- lqas_simulate_test(
  pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, replicates = 5, runs = 5
)

lqas_get_class_prob(x = sim)
#>                     Low : 0.9513
#>                Moderate : 0.8387
#>                    High : 0.832
#>                 Overall : 0.9056
#> Gross misclassification : 0
#> 
```
