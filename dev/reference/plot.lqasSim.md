# `plot` helper function for [`lqas_simulate_test()`](https://nutriverse.io/sleacr/dev/reference/lqas_simulate.md) function

`plot` helper function for
[`lqas_simulate_test()`](https://nutriverse.io/sleacr/dev/reference/lqas_simulate.md)
function

## Usage

``` r
# S3 method for class 'lqasSim'
plot(x, ...)
```

## Arguments

- x:

  An object of class `lqasSim` produced by
  [`lqas_simulate_test()`](https://nutriverse.io/sleacr/dev/reference/lqas_simulate.md)
  function

- ...:

  Additional `plot` parameters

## Value

An LQAS probability of classification plot

## Examples

``` r
x <- lqas_simulate_test(
  pop = 10000, n = 40, dLower = 0.6, dUpper = 0.9, replicates = 5, runs = 5
)
plot(x)

```
