# `print` helper function for [`lqas_get_class_prob()`](https://nutriverse.io/sleacr/reference/lqas_get_class_prob.md) function

`print` helper function for
[`lqas_get_class_prob()`](https://nutriverse.io/sleacr/reference/lqas_get_class_prob.md)
function

## Usage

``` r
# S3 method for class 'lqasClass'
print(x, ...)
```

## Arguments

- x:

  An object resulting from applying the
  [`lqas_get_class_prob()`](https://nutriverse.io/sleacr/reference/lqas_get_class_prob.md)
  function.

- ...:

  Additional `print` parameters

## Value

Printed output of
[`lqas_get_class_prob()`](https://nutriverse.io/sleacr/reference/lqas_get_class_prob.md)
function

## Examples

``` r
sim <- lqas_simulate_test(
  pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, replicates = 5, runs = 5
)

x <- lqas_get_class_prob(x = sim)
print(x)
#>                     Low : 0.9607
#>                Moderate : 0.82
#>                    High : 0.844
#>                 Overall : 0.9068
#> Gross misclassification : 0
#> 
```
