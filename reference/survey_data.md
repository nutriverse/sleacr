# SLEAC survey data from Sierra Leone

SLEAC survey data from Sierra Leone

## Usage

``` r
survey_data
```

## Format

A tibble with 14 rows and 6 columns

|               |                                              |
|---------------|----------------------------------------------|
| **Variable**  | **Description**                              |
| *country*     | Country                                      |
| *province*    | Province                                     |
| *district*    | District                                     |
| *cases_in*    | SAM cases found who are in the programme     |
| *cases_out*   | SAM cases found who are not in the programme |
| *rec_in*      | Recovering SAM cases in the programme        |
| *cases_total* | Total number SAM cases found                 |

## Source

Ministry of Health, Sierra Leone

## Examples

``` r
survey_data
#> # A tibble: 14 × 7
#>    country      province     district      cases_in cases_out rec_in cases_total
#>    <chr>        <chr>        <chr>            <int>     <int>  <int>       <int>
#>  1 Sierra Leone Northern     Bombali              4        26      6          30
#>  2 Sierra Leone Northern     Koinadugu            0        32      6          32
#>  3 Sierra Leone Northern     Kambia               0        28      0          28
#>  4 Sierra Leone Northern     Port Loko            2        28      0          30
#>  5 Sierra Leone Northern     Tonkolili            1        27      5          28
#>  6 Sierra Leone Eastern      Kono                 2        14      3          16
#>  7 Sierra Leone Eastern      Kailahun             4        30      3          34
#>  8 Sierra Leone Eastern      Kenema               8        26      4          34
#>  9 Sierra Leone Southern     Pujehun              6        21      1          27
#> 10 Sierra Leone Southern     Bo                   6        16      8          22
#> 11 Sierra Leone Southern     Bonthe               7        34      2          41
#> 12 Sierra Leone Southern     Moyamba              6        34      0          40
#> 13 Sierra Leone Western Area Western Area…        6        40      5          46
#> 14 Sierra Leone Western Area Western Area…        2        18      0          20
```
