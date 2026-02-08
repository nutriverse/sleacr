# Population data of districts of Sierra Leone based on 2015 census

Population data of districts of Sierra Leone based on 2015 census

## Usage

``` r
pop_data
```

## Format

A tibble with 14 rows and 2 columns

|              |                 |
|--------------|-----------------|
| **Variable** | **Description** |
| *district*   | District name   |
| *pop*        | Population      |

## Source

https://sierraleone.unfpa.org/sites/default/files/pub-pdf/Population%20structure%20Report_1.pdf

## Examples

``` r
pop_data
#> # A tibble: 14 × 2
#>    district               pop
#>    <chr>                <dbl>
#>  1 Kailahun            526379
#>  2 Kenema              609891
#>  3 Kono                506100
#>  4 Bombali             606544
#>  5 Kambia              345474
#>  6 Koinadugu           409372
#>  7 Port Loko           615376
#>  8 Tonkolili           531435
#>  9 Bo                  575478
#> 10 Bonthe              200781
#> 11 Moyamba             318588
#> 12 Pujehun             346461
#> 13 Western Area Rural  444270
#> 14 Western Area Urban 1055964
```
