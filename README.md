
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sleacr: Simplified Lot Quality Assurance Sampling Evaluation of Access and Coverage (SLEAC) Tools <img src="man/figures/logo.png" width="200px" align="right" />

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/nutriverse/sleacr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nutriverse/sleacr/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/nutriverse/sleacr/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/nutriverse/sleacr/actions/workflows/test-coverage.yaml)
[![Codecov test
coverage](https://codecov.io/gh/nutriverse/sleacr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/nutriverse/sleacr?branch=main)
[![CodeFactor](https://www.codefactor.io/repository/github/nutriverse/sleacr/badge)](https://www.codefactor.io/repository/github/nutriverse/sleacr)
[![DOI](https://zenodo.org/badge/186984529.svg)](https://zenodo.org/badge/latestdoi/186984529)
<!-- badges: end -->

In the recent past, measurement of coverage has been mainly through
two-stage cluster sampled surveys either as part of a nutrition
assessment or through a specific coverage survey known as Centric
Systematic Area Sampling (CSAS). However, such methods are resource
intensive and often only used for final programme evaluation meaning
results arrive too late for programme adaptation. SLEAC, which stands
for Simplified Lot Quality Assurance Sampling Evaluation of Access and
Coverage, is a low resource method designed specifically to address this
limitation and is used regularly for monitoring, planning and
importantly, timely improvement to programme quality, both for agency
and Ministry of Health (MoH) led programmes. This package provides
functions for use in conducting a SLEAC assessment.

## What does the package do?

The `{sleacr}` package provides functions that facilitate the design,
sampling, data collection, and data analysis of a SLEAC survey. The
current version of the `{sleacr}` package currently provides the
following:

  - Functions to calculate the sample size needed for a SLEAC survey;

  - Functions to draw a stage 1 sample for a SLEAC survey;

  - Functions to classify coverage; and,

  - Functions to determine the performance of chosen classifier cut-offs
    for analysis of SLEAC survey data.

## Installation

The `{sleacr}` package is not yet available on
[CRAN](https://cran.r-project.org) but can be installed from the
[nutriverse R Universe](https://nutriverse.r-universe.dev) as follows:

``` r
install.packages(
  "sleacr",
  repos = c('https://nutriverse.r-universe.dev', 'https://cloud.r-project.org')
)
```

## Usage

### Lot quality assurance sampling frame

To setup an LQAS sampling frame, a target sample size is first
estimated. For example, if the survey area has an estimated population
of about 600 severe acute malnourished (SAM) children and you want to
assess whether coverage is reaching at least 50%, the sample size can be
calculated as follows:

``` r
get_sample_n(N = 600, dLower = 0.5, dUpper = 0.8)
```

which gives an LQAS sampling plan list with values for the target
minimum sample size (`n`), the decision rule (`d`), the observed alpha
error (`alpha`), and the observed beta error (`beta`).

    #> $n
    #> [1] 19
    #> 
    #> $d
    #> [1] 12
    #> 
    #> $alpha
    #> [1] 0.06446194
    #> 
    #> $beta
    #> [1] 0.08014249

In this sampling plan, a target minimum sample size of 19 SAM cases
should be aimed for with a decision rule of more than 12 SAM cases
covered to determine whether programme coverage is at least 50% with
alpha and beta errors no more than 10%. The alpha and beta errors
requirement is set at no more than 10% by default. This can be made more
precise by setting alpha and beta errors less than 10%.

There are contexts where survey data has already been collected and the
sample is less than what was aimed for based on the original sampling
frame. The `get_sample_d()` function is used to determine the error
levels of the achieved sample size. For example, if the survey described
above only achieved a sample size of 16, the `get_sample_d()` function
can be used as follows:

``` r
get_sample_d(N = 600, n = 16, dLower = 0.5, dUpper = 0.8)
```

which gives an alternative LQAS sampling plan based on the achieved
sample size.

    #> $n
    #> [1] 16
    #> 
    #> $d
    #> [1] 10
    #> 
    #> $alpha
    #> [1] 0.07890285
    #> 
    #> $beta
    #> [1] 0.1019738

In this updated sampling plan, the decision rule is now more than 10 SAM
cases but with higher alpha and beta errors. Note that the beta error is
now slightly higher than 10%.

### Stage 1 sample

The first stage sample of a SLEAC survey is a systematic spatial sample.
Two methods can be used and both methods take the sample from all parts
of the survey area: the *list-based* method and the *map-based* method.
The `{sleacr}` package currently supports the implementation of the
*list-based* method.

In the list-based method, communities to be sampled are selected
systematically from a complete list of communities in the survey area.
This list of communities should sorted by one or more non-overlapping
spatial factors such as district and subdistricts within districts. The
`village_list` dataset is an example of such a list.

``` r
village_list
#> # A tibble: 1,001 × 4
#>       id chiefdom section village  
#>    <dbl> <chr>    <chr>   <chr>    
#>  1     1 Badjia   Damia   Ngelehun 
#>  2     2 Badjia   Damia   Gondama  
#>  3     3 Badjia   Damia   Penjama  
#>  4     4 Badjia   Damia   Jawe     
#>  5     5 Badjia   Damia   Dambala  
#>  6     6 Badjia   Fallay  Bumpewo  
#>  7     7 Badjia   Fallay  Pelewahun
#>  8     8 Badjia   Fallay  Pendembu 
#>  9     9 Badjia   Kpallay Jokibu   
#> 10    10 Badjia   Kpallay Kpaku    
#> # ℹ 991 more rows
```

The `get_sampling_list()` function implements the list-based sampling
method. For example, if 40 clusters/villages are needed to be sampled to
find the 19 SAM cases calculated earlier, a sampling list can be created
as follows:

``` r
get_sampling_list(village_list, 40)
```

which provides the following sampling list:

|  id | chiefdom      | section        | village     |
| --: | :------------ | :------------- | :---------- |
|  13 | Badjia        | Kpallay        | Kugbahun    |
|  38 | Bagbe         | Jongo          | Bandajuma   |
|  63 | Bagbe         | Nyallay        | Fuinda      |
|  88 | Bagbo         | Gorapon        | Kassay      |
| 113 | Bagbo         | Kpangbalia     | Kpangbalia  |
| 138 | Bagbo         | Tissawa        | Monjemei    |
| 163 | Baoma         | Bambawo        | Feiba       |
| 188 | Baoma         | Mawojeh        | Masao       |
| 213 | Baoma         | Upper Pataloo  | Komende     |
| 238 | Bumpe Ngao    | Bumpe          | Nguabu      |
| 263 | Bumpe Ngao    | Bumpe          | Sembehun    |
| 288 | Bumpe Ngao    | Sewama         | Juhun       |
| 313 | Bumpe Ngao    | Sahn           | Sembehun    |
| 338 | Bumpe Ngao    | Taninahun      | Nyandehun   |
| 363 | Bumpe Ngao    | Taninahun      | Waterloo    |
| 388 | Bumpe Ngao    | Taninahun      | Kangama     |
| 413 | Bumpe Ngao    | Yengema        | Yengema     |
| 438 | Gbo           | Maryu          | Kama        |
| 463 | Jaiama Bongor | Lower Kama     | Bangema     |
| 488 | Jaiama Bongor | Tongowa        | Lalewahun   |
| 513 | Jaiama Bongor | Upper Kama     | Bowohun     |
| 538 | Kakua         | Kpandobu       | Manguama    |
| 563 | Kakua         | Nguabu         | Gandorhun   |
| 588 | Kakua         | Samamie        | Gbanja Town |
| 613 | Komboya       | Kemoh          | Manyama     |
| 638 | Komboya       | Mangaru        | Kpamajama   |
| 663 | Lugbu         | Yalenga        | Kpetema     |
| 688 | Niawa Lenga   | Kaduawo        | Huawuma     |
| 713 | Niawa Lenga   | Yalenga        | Kpah        |
| 738 | Selenga       | Mambawa        | Gbangaima   |
| 763 | Selenga       | Old Town       | Korwama     |
| 788 | Tikonko       | Seiwa          | Kapima      |
| 813 | Tikonko       | Njagbla II     | Failor      |
| 838 | Tikonko       | Seiwa          | Gbanahun    |
| 863 | Valunia       | Deilenga       | Konima      |
| 888 | Valunia       | Kendebu        | Kpetema     |
| 913 | Valunia       | Lunia          | Levuma      |
| 938 | Valunia       | Lunia          | Njala       |
| 963 | Valunia       | Seilenga       | Foya        |
| 988 | Wonde         | Central Kargoi | YawaJu      |

### Classifying coverage

With data collected from a SLEAC survey, the `lqas_classify_coverage()`
function is used to classify coverage. For example, using the
`survey_data` dataset, per district coverage classification can be
calculated as follows:

``` r
with(survey_data, lqas_classify_coverage(n = in_cases, n_total = n))
```

which outputs the following results:

    #>  [1] "Low"      "Low"      "Low"      "Low"      "Low"     
    #>  [6] "Low"      "Low"      "Moderate" "Moderate" "Moderate"
    #> [11] "Low"      "Low"      "Low"      "Low"

### Assessing classifier performance

It is useful to be able to assess the performance of the classifier
chosen for a SLEAC survey. For example, in the context presented above
of an area with a population of 600, a sample size of 40 and a 60% and
90% threshold classifier, the performance of this classifier can be
assessed by first simulating a population and then determining the
classification probabilities of the chosen classifier on this
population.

``` r
lqas_simulate_test(pop = 600, n = 40, dLower = 0.6, dUpper = 0.9) |>
  lqas_get_class_prob()
#>                     Low : 0.9562
#>                Moderate : 0.8288
#>                    High : 0.8393
#>                 Overall : 0.9063
#> Gross misclassification : 0
```

## Citation

If you use `{sleacr}` in your work, please cite using the suggested
citation provided by a call to the `citation` function as follows:

``` r
citation("sleacr")
#> To cite sleacr in publications use:
#> 
#>   Mark Myatt, Ernest Guevarra, Lionella Fieschi, Allison
#>   Norris, Saul Guerrero, Lilly Schofield, Daniel Jones,
#>   Ephrem Emru, Kate Sadler (2012). _Semi-Quantitative
#>   Evaluation of Access and Coverage (SQUEAC)/Simplified Lot
#>   Quality Assurance Sampling Evaluation of Access and
#>   Coverage (SLEAC) Technical Reference_. FHI 360/FANTA,
#>   Washington, DC.
#>   <https://www.fantaproject.org/sites/default/files/resources/SQUEAC-SLEAC-Technical-Reference-Oct2012_0.pdf>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Book{,
#>     title = {Semi-Quantitative Evaluation of Access and Coverage ({SQUEAC})/Simplified Lot Quality Assurance Sampling Evaluation of Access and Coverage ({SLEAC}) Technical Reference},
#>     author = {{Mark Myatt} and {Ernest Guevarra} and {Lionella Fieschi} and {Allison Norris} and {Saul Guerrero} and {Lilly Schofield} and {Daniel Jones} and {Ephrem Emru} and {Kate Sadler}},
#>     year = {2012},
#>     publisher = {FHI 360/FANTA},
#>     address = {Washington, DC},
#>     url = {https://www.fantaproject.org/sites/default/files/resources/SQUEAC-SLEAC-Technical-Reference-Oct2012_0.pdf},
#>   }
```

## Community guidelines

Feedback, bug reports, and feature requests are welcome; file issues or
seek support [here](https://github.com/nutriverse/sleacr/issues). If you
would like to contribute to the package, please see our [contributing
guidelines](https://nutriverse.io/sleacr/CONTRIBUTING.html).

This project is released with a [Contributor Code of
Conduct](https://nutriverse.io/sleacr/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
