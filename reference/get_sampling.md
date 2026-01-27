# Select sampling clusters using systematic sampling

Select sampling clusters using systematic sampling

## Usage

``` r
get_sampling_clusters(N_clusters, n_clusters)

get_sampling_list(cluster_list, n_clusters)
```

## Arguments

- N_clusters:

  Total number of clusters in survey area.

- n_clusters:

  Number of sampling clusters to be selected.

- cluster_list:

  A data.frame containing at least the name or any other identifier for
  the entire set of clusters to sample from.

## Value

An integer vector for `get_sampling_clusters()` giving the row index for
selected clusters. A data.frame for `[get_sampling_list()]` which is a
subset of `cluster_list`.

## Examples

``` r
get_sampling_clusters(N_clusters = 211, n_clusters = 35)
#>  [1]   5  11  17  23  29  35  41  47  53  59  65  71  77  83  89  95 101 107 113
#> [20] 119 125 131 137 143 149 155 161 167 173 179 185 191 197 203 209
get_sampling_list(cluster_list = village_list, n_clusters = 70)
#> # A tibble: 72 × 4
#>       id chiefdom section    village  
#>    <dbl> <chr>    <chr>      <chr>    
#>  1     5 Badjia   Damia      Dambala  
#>  2    19 Badjia   Njargbahun Jagban   
#>  3    33 Badjia   Sei        Sembehun 
#>  4    47 Bagbe    Kemoh      Yangabu  
#>  5    61 Bagbe    Nyallay    Kpatou   
#>  6    75 Bagbo    Bum        Gballeh  
#>  7    89 Bagbo    Gorapon    Yeinsa   
#>  8   103 Bagbo    Jimmi      Damballa 
#>  9   117 Bagbo    Kpangbalia Gibina   
#> 10   131 Bagbo    Tissawa    Mondamble
#> # ℹ 62 more rows
```
