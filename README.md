
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
#>        id      chiefdom        section            village
#> 1       1        Badjia          Damia           Ngelehun
#> 2       2        Badjia          Damia            Gondama
#> 3       3        Badjia          Damia            Penjama
#> 4       4        Badjia          Damia               Jawe
#> 5       5        Badjia          Damia            Dambala
#> 6       6        Badjia         Fallay            Bumpewo
#> 7       7        Badjia         Fallay          Pelewahun
#> 8       8        Badjia         Fallay           Pendembu
#> 9       9        Badjia        Kpallay             Jokibu
#> 10     10        Badjia        Kpallay              Kpaku
#> 11     11        Badjia        Kpallay            Giewoma
#> 12     12        Badjia        Kpallay               Fala
#> 13     13        Badjia        Kpallay           Kugbahun
#> 14     14        Badjia        Kpallay          Jahandama
#> 15     15        Badjia        Kpallay            Gumahun
#> 16     16        Badjia     Njargbahun           Kebawana
#> 17     17        Badjia     Njargbahun               Jelu
#> 18     18        Badjia     Njargbahun            Kpowabu
#> 19     19        Badjia     Njargbahun             Jagban
#> 20     20        Badjia     Njargbahun            Kpetema
#> 21     21        Badjia     Njargbahun           Yorvuhun
#> 22     22        Badjia     Njargbahun            Ndaambu
#> 23     23        Badjia     Njargbahun             Solima
#> 24     24        Badjia     Njargbahun           Ngalahun
#> 25     25        Badjia     Njargbahun           Bangiema
#> 26     26        Badjia            Sei            Nomiama
#> 27     27        Badjia            Sei           Jaluahun
#> 28     28        Badjia            Sei             Palima
#> 29     29        Badjia            Sei           Korjehun
#> 30     30        Badjia            Sei               Guma
#> 31     31        Badjia            Sei             Giehun
#> 32     32        Badjia            Sei              Sarso
#> 33     33        Badjia            Sei           Sembehun
#> 34     34        Badjia            Sei            Mbokeni
#> 35     35         Bagbe          Jongo          Mokpendeh
#> 36     36         Bagbe          Jongo             Gbarma
#> 37     37         Bagbe          Jongo             Venima
#> 38     38         Bagbe          Jongo          Bandajuma
#> 39     39         Bagbe          Jongo              Faabu
#> 40     40         Bagbe          Jongo               Sami
#> 41     41         Bagbe          Jongo               Buma
#> 42     42         Bagbe          Jongo             Kpaula
#> 43     43         Bagbe          Jongo           Kondiama
#> 44     44         Bagbe          Jongo              Bioja
#> 45     45         Bagbe          Jongo            Yengema
#> 46     46         Bagbe          Kemoh          Langukama
#> 47     47         Bagbe          Kemoh            Yangabu
#> 48     48         Bagbe          Kemoh            Benduma
#> 49     49         Bagbe          Kemoh             Niahun
#> 50     50         Bagbe          Kemoh             Lowoma
#> 51     51         Bagbe          Kemoh            Kpetema
#> 52     52         Bagbe          Kemoh          Pelewahun
#> 53     53         Bagbe          Niawa              Kandu
#> 54     54         Bagbe          Niawa           Kpuawala
#> 55     55         Bagbe          Niawa      Njala Kendima
#> 56     56         Bagbe          Niawa              Balie
#> 57     57         Bagbe          Niawa            Bonkema
#> 58     58         Bagbe          Niawa            Bangabu
#> 59     59         Bagbe        Nyallay              Blama
#> 60     60         Bagbe        Nyallay          Kpetewoma
#> 61     61         Bagbe        Nyallay             Kpatou
#> 62     62         Bagbe        Nyallay              Yawei
#> 63     63         Bagbe        Nyallay             Fuinda
#> 64     64         Bagbe        Nyallay               Galu
#> 65     65         Bagbe        Nyallay        Man-Pendobu
#> 66     66         Bagbe        Nyallay           Kerawana
#> 67     67         Bagbe        Nyallay             Kowama
#> 68     68         Bagbe        Nyallay            Walihun
#> 69     69         Bagbe        Nyallay    Gbarma - Tabema
#> 70     70         Bagbe         Samawa             Baiama
#> 71     71         Bagbe         Samawa             Palima
#> 72     72         Bagbe         Samawa        Kunjogiehun
#> 73     73         Bagbe         Samawa         Kunjondoma
#> 74     74         Bagbe         Samawa            Kpetema
#> 75     75         Bagbo            Bum            Gballeh
#> 76     76         Bagbo            Bum             Kenema
#> 77     77         Bagbo            Bum           Tokpombu
#> 78     78         Bagbo            Bum           Bum-Kaku
#> 79     79         Bagbo            Bum           Gbatorma
#> 80     80         Bagbo            Bum             Balleh
#> 81     81         Bagbo        Gorapon       Gbenya (Old)
#> 82     82         Bagbo        Gorapon            Panguma
#> 83     83         Bagbo        Gorapon            Largowo
#> 84     84         Bagbo        Gorapon               Dema
#> 85     85         Bagbo        Gorapon           Mohapewa
#> 86     86         Bagbo        Gorapon             Mogbon
#> 87     87         Bagbo        Gorapon             Mokoba
#> 88     88         Bagbo        Gorapon             Kassay
#> 89     89         Bagbo        Gorapon             Yeinsa
#> 90     90         Bagbo          Jimmi             Levuma
#> 91     91         Bagbo          Jimmi            Garinga
#> 92     92         Bagbo          Jimmi              Mandu
#> 93     93         Bagbo          Jimmi              Limba
#> 94     94         Bagbo          Jimmi             Kakama
#> 95     95         Bagbo          Jimmi            Kpawama
#> 96     96         Bagbo          Jimmi          Mopandima
#> 97     97         Bagbo          Jimmi             Gordie
#> 98     98         Bagbo          Jimmi             Waiima
#> 99     99         Bagbo          Jimmi          Bandajuma
#> 100   100         Bagbo          Jimmi            Manjama
#> 101   101         Bagbo          Jimmi           Bandoima
#> 102   102         Bagbo          Jimmi            Yeinken
#> 103   103         Bagbo          Jimmi           Damballa
#> 104   104         Bagbo          Jimmi             Mattru
#> 105   105         Bagbo          Jimmi               Jimm
#> 106   106         Bagbo          Jimmi             Gordie
#> 107   107         Bagbo          Jimmi             Waiima
#> 108   108         Bagbo          Jimmi    Senehun - Ngola
#> 109   109         Bagbo     Kpangbalia          Nyandehun
#> 110   110         Bagbo     Kpangbalia            Mogbain
#> 111   111         Bagbo     Kpangbalia     Farbaina (Old)
#> 112   112         Bagbo     Kpangbalia              Baoma
#> 113   113         Bagbo     Kpangbalia         Kpangbalia
#> 114   114         Bagbo     Kpangbalia    Senehun - Somba
#> 115   115         Bagbo     Kpangbalia             Mbonda
#> 116   116         Bagbo     Kpangbalia          Kpetewoma
#> 117   117         Bagbo     Kpangbalia             Gibina
#> 118   118         Bagbo           Mano          Mondorkor
#> 119   119         Bagbo           Mano           Tokpombu
#> 120   120         Bagbo           Mano            Dandabu
#> 121   121         Bagbo           Mano             Semabu
#> 122   122         Bagbo           Mano       Mano-Yorgbor
#> 123   123         Bagbo     Niagorehun           Mandehun
#> 124   124         Bagbo     Niagorehun             Salema
#> 125   125         Bagbo     Niagorehun            Mosakpa
#> 126   126         Bagbo     Niagorehun         Niagorehun
#> 127   127         Bagbo        Tissawa           Sembehun
#> 128   128         Bagbo        Tissawa            Ngiehun
#> 129   129         Bagbo        Tissawa             Temuma
#> 130   130         Bagbo        Tissawa              Moway
#> 131   131         Bagbo        Tissawa          Mondamble
#> 132   132         Bagbo        Tissawa       Kortulablama
#> 133   133         Bagbo        Tissawa          Ngolawoma
#> 134   134         Bagbo        Tissawa       Mossa Gbahun
#> 135   135         Bagbo        Tissawa             Manibo
#> 136   136         Bagbo        Tissawa               Mani
#> 137   137         Bagbo        Tissawa             Yegele
#> 138   138         Bagbo        Tissawa           Monjemei
#> 139   139         Bagbo        Tissawa            Mbelebu
#> 140   140         Bagbo        Tissawa             Tolobu
#> 141   141         Bagbo        Tissawa            Gonoama
#> 142   142         Bagbo        Tissawa              Folla
#> 143   143         Baoma         Njeima            Gbuyama
#> 144   144         Baoma        Bambawo             Vaahun
#> 145   145         Baoma        Bambawo           Kenemawo
#> 146   146         Baoma        Bambawo              Falla
#> 147   147         Baoma        Bambawo          Kpefewoma
#> 148   148         Baoma        Bambawo          Morgbuama
#> 149   149         Baoma        Bambawo            Kanjalu
#> 150   150         Baoma        Bambawo             Kwellu
#> 151   151         Baoma        Bambawo            Pujehun
#> 152   152         Baoma        Bambawo             Geihun
#> 153   153         Baoma        Bambawo            Gbaiima
#> 154   154         Baoma        Bambawo             Potoru
#> 155   155         Baoma        Bambawo          Ngeyawami
#> 156   156         Baoma        Bambawo             Palima
#> 157   157         Baoma        Bambawo              Konia
#> 158   158         Baoma        Bambawo              Lungi
#> 159   159         Baoma        Bambawo              Gollu
#> 160   160         Baoma        Bambawo            Nogorba
#> 161   161         Baoma        Bambawo            Gondama
#> 162   162         Baoma        Bambawo             Matama
#> 163   163         Baoma        Bambawo              Feiba
#> 164   164         Baoma        Bambawo            Tobanda
#> 165   165         Baoma        Bambawo            Ngually
#> 166   166         Baoma        Bambawo            Fagorya
#> 167   167         Baoma        Bambawo              Njama
#> 168   168         Baoma        Bambawo               Mana
#> 169   169         Baoma        Bambawo              Jormu
#> 170   170         Baoma         Fallay             Gbandi
#> 171   171         Baoma         Fallay          Njaluahun
#> 172   172         Baoma         Fallay         Niagorehun
#> 173   173         Baoma         Fallay              Waima
#> 174   174         Baoma         Kimaya          Kotumahun
#> 175   175         Baoma         Kimaya          Njaluahun
#> 176   176         Baoma         Kimaya             Kpumbu
#> 177   177         Baoma         Kimaya             Manowa
#> 178   178         Baoma  Lower Pataloo            Kpawuma
#> 179   179         Baoma  Lower Pataloo          Taninahun
#> 180   180         Baoma  Lower Pataloo            Kwalema
#> 181   181         Baoma  Lower Pataloo        Ndogborgoma
#> 182   182         Baoma  Lower Pataloo            Yamandu
#> 183   183         Baoma  Lower Pataloo          Mbundorbu
#> 184   184         Baoma  Lower Pataloo             Kpakru
#> 185   185         Baoma  Lower Pataloo      Buma - Sewama
#> 186   186         Baoma  Lower Pataloo   Komende - Sewama
#> 187   187         Baoma        Mawojeh          Taninahun
#> 188   188         Baoma        Mawojeh              Masao
#> 189   189         Baoma        Mawojeh            Gbinima
#> 190   190         Baoma        Mawojeh             Kigbai
#> 191   191         Baoma        Mawojeh             Sawula
#> 192   192         Baoma        Mawojeh             Foindu
#> 193   193         Baoma        Mawojeh              Ndema
#> 194   194         Baoma        Mawojeh              Miama
#> 195   195         Baoma        Mawojeh           Ngelahun
#> 196   196         Baoma        Mawojeh            Gendema
#> 197   197         Baoma        Mawojeh             Komolu
#> 198   198         Baoma        Mawojeh            Kenyema
#> 199   199         Baoma        Mawojeh              Jembe
#> 200   200         Baoma         Sannah             Semibu
#> 201   201         Baoma         Sannah            Kpatobu
#> 202   202         Baoma         Sannah           Gboyeiya
#> 203   203         Baoma         Sannah            Tugbebu
#> 204   204         Baoma         Sannah          Faikundor
#> 205   205         Baoma         Sannah              Kanga
#> 206   206         Baoma         Sannah             Sandia
#> 207   207         Baoma         Sannah          Kotumahun
#> 208   208         Baoma         Sannah            Gangama
#> 209   209         Baoma         Sannah            Ngually
#> 210   210         Baoma         Sannah              Farbu
#> 211   211         Baoma         Sannah             Fayama
#> 212   212         Baoma  Upper Pataloo            Kpatema
#> 213   213         Baoma  Upper Pataloo            Komende
#> 214   214         Baoma  Upper Pataloo           Hagbahun
#> 215   215         Baoma  Upper Pataloo             Gbahun
#> 216   216         Baoma  Upper Pataloo            Kponima
#> 217   217         Baoma  Upper Pataloo           Jombohun
#> 218   218         Baoma  Upper Pataloo             Matema
#> 219   219         Baoma  Upper Pataloo            Gbangba
#> 220   220         Baoma  Upper Pataloo             Yakaji
#> 221   221         Baoma  Upper Pataloo              Juhun
#> 222   222         Baoma  Upper Pataloo          Pelewahun
#> 223   223    Bumpe Ngao          Bongo              Bongo
#> 224   224    Bumpe Ngao          Bumpe             Kowama
#> 225   225    Bumpe Ngao          Bumpe          Fulawahun
#> 226   226    Bumpe Ngao          Bumpe            Bonjema
#> 227   227    Bumpe Ngao          Bumpe               Koni
#> 228   228    Bumpe Ngao          Bumpe            Naiahun
#> 229   229    Bumpe Ngao          Bumpe          Nyandehun
#> 230   230    Bumpe Ngao          Bumpe             Fongia
#> 231   231    Bumpe Ngao          Bumpe           Sembehun
#> 232   232    Bumpe Ngao          Bumpe              Baoma
#> 233   233    Bumpe Ngao          Bumpe             Kowama
#> 234   234    Bumpe Ngao          Bumpe             Mongla
#> 235   235    Bumpe Ngao          Bumpe            Mamboma
#> 236   236    Bumpe Ngao          Bumpe           Mortoima
#> 237   237    Bumpe Ngao          Bumpe         Simbekihun
#> 238   238    Bumpe Ngao          Bumpe             Nguabu
#> 239   239    Bumpe Ngao          Bumpe      Kenema/Salina
#> 240   240    Bumpe Ngao          Bumpe            Badjawo
#> 241   241    Bumpe Ngao          Bumpe           Kundorma
#> 242   242    Bumpe Ngao          Bumpe    Baoma-Morgongoi
#> 243   243    Bumpe Ngao          Bumpe           Gbenenga
#> 244   244    Bumpe Ngao          Bumpe         Ngeagboiya
#> 245   245    Bumpe Ngao          Bumpe             Waiima
#> 246   246    Bumpe Ngao          Bumpe             Semabu
#> 247   247    Bumpe Ngao          Bumpe             Levuma
#> 248   248    Bumpe Ngao          Bumpe            Morwoso
#> 249   249    Bumpe Ngao          Bumpe             Kawaya
#> 250   250    Bumpe Ngao          Bumpe           Ngiegebu
#> 251   251    Bumpe Ngao          Bumpe           Morgenda
#> 252   252    Bumpe Ngao          Bumpe       Dar-es-salam
#> 253   253    Bumpe Ngao          Bumpe    Semabu - Folobu
#> 254   254    Bumpe Ngao          Bumpe Pujehun Kotugbiama
#> 255   255    Bumpe Ngao          Bumpe            Selehun
#> 256   256    Bumpe Ngao          Bumpe          Kotumahun
#> 257   257    Bumpe Ngao          Bumpe          Njaluahun
#> 258   258    Bumpe Ngao          Bumpe   Valahun-Kosawama
#> 259   259    Bumpe Ngao          Bumpe             Fanima
#> 260   260    Bumpe Ngao          Bumpe             Mokolu
#> 261   261    Bumpe Ngao          Bumpe            Ngualla
#> 262   262    Bumpe Ngao          Bumpe              Vaima
#> 263   263    Bumpe Ngao          Bumpe           Sembehun
#> 264   264    Bumpe Ngao          Bumpe     Ngiehun-Songay
#> 265   265    Bumpe Ngao          Bumpe           Mongerie
#> 266   266    Bumpe Ngao           Foya            Benduma
#> 267   267    Bumpe Ngao           Foya             Levuma
#> 268   268    Bumpe Ngao           Foya             Golala
#> 269   269    Bumpe Ngao           Foya              Banda
#> 270   270    Bumpe Ngao           Foya             Bobobu
#> 271   271    Bumpe Ngao           Foya            Kpetema
#> 272   272    Bumpe Ngao           Foya          Niagoihun
#> 273   273    Bumpe Ngao           Foya             Gambia
#> 274   274    Bumpe Ngao           Foya             Ngieya
#> 275   275    Bumpe Ngao           Foya             Ndambu
#> 276   276    Bumpe Ngao           Foya               Foya
#> 277   277    Bumpe Ngao        Kpetema         Hotawuloma
#> 278   278    Bumpe Ngao        Kpetema            Kpejebu
#> 279   279    Bumpe Ngao        Kpetema            Kpetema
#> 280   280    Bumpe Ngao        Kpetema               Yoni
#> 281   281    Bumpe Ngao         Sewama             Mokoba
#> 282   282    Bumpe Ngao         Sewama             Mokoba
#> 283   283    Bumpe Ngao         Sewama           Mokpende
#> 284   284    Bumpe Ngao         Sewama            Walihun
#> 285   285    Bumpe Ngao         Sewama               Buma
#> 286   286    Bumpe Ngao         Sewama              Guabu
#> 287   287    Bumpe Ngao         Sewama          Yengemawo
#> 288   288    Bumpe Ngao         Sewama              Juhun
#> 289   289    Bumpe Ngao         Sewama             Kamasu
#> 290   290    Bumpe Ngao         Sewama          Nyandehun
#> 291   291    Bumpe Ngao         Sewama       Kaniya Kpeje
#> 292   292    Bumpe Ngao         Sewama             Mofuwe
#> 293   293    Bumpe Ngao         Sewama             Tisana
#> 294   294    Bumpe Ngao         Sewama           Madinawo
#> 295   295    Bumpe Ngao          Bongo             Belebu
#> 296   296    Bumpe Ngao          Bongo            Moryoru
#> 297   297    Bumpe Ngao          Bongo            Mangema
#> 298   298    Bumpe Ngao          Bongo           Tokpombu
#> 299   299    Bumpe Ngao          Bumpe           Gbeworba
#> 300   300    Bumpe Ngao          Bumpe             Bellor
#> 301   301    Bumpe Ngao          Bumpe             Hangha
#> 302   302    Bumpe Ngao           Foya            Moawoma
#> 303   303    Bumpe Ngao        Kpetema             Mojiba
#> 304   304    Bumpe Ngao        Kpetema           Gbagbabu
#> 305   305    Bumpe Ngao        Kpetema            Jewenga
#> 306   306    Bumpe Ngao        Kpetema           Sembehun
#> 307   307    Bumpe Ngao        Kpetema           Kpandemi
#> 308   308    Bumpe Ngao           Sahn             Mowoto
#> 309   309    Bumpe Ngao           Sahn              Wunde
#> 310   310    Bumpe Ngao           Sahn        Nghanyawama
#> 311   311    Bumpe Ngao           Sahn               Sahn
#> 312   312    Bumpe Ngao           Sahn           Jombohun
#> 313   313    Bumpe Ngao           Sahn           Sembehun
#> 314   314    Bumpe Ngao           Sahn             Manoma
#> 315   315    Bumpe Ngao           Sahn            Kapuima
#> 316   316    Bumpe Ngao           Sahn            Bandasa
#> 317   317    Bumpe Ngao           Sahn           Teblahun
#> 318   318    Bumpe Ngao           Sahn            Gendema
#> 319   319    Bumpe Ngao         Serabu             Mokibi
#> 320   320    Bumpe Ngao         Serabu        Nyahagoihun
#> 321   321    Bumpe Ngao         Serabu             Nitiwo
#> 322   322    Bumpe Ngao         Serabu           Nyorlema
#> 323   323    Bumpe Ngao         Serabu            Motimor
#> 324   324    Bumpe Ngao         Serabu           Jombohun
#> 325   325    Bumpe Ngao         Serabu              Faama
#> 326   326    Bumpe Ngao         Serabu             Serabu
#> 327   327    Bumpe Ngao         Serabu           Dukpuibu
#> 328   328    Bumpe Ngao         Serabu           Kpanguma
#> 329   329    Bumpe Ngao         Serabu             Janema
#> 330   330    Bumpe Ngao         Sewama             Mowoto
#> 331   331    Bumpe Ngao         Sewama            Mogbevo
#> 332   332    Bumpe Ngao         Sewama              Baaka
#> 333   333    Bumpe Ngao         Sewama           Gbalahun
#> 334   334    Bumpe Ngao      Taninahun           Njagbema
#> 335   335    Bumpe Ngao      Taninahun            Golahun
#> 336   336    Bumpe Ngao      Taninahun           Kagbiama
#> 337   337    Bumpe Ngao      Taninahun            Bambaya
#> 338   338    Bumpe Ngao      Taninahun          Nyandehun
#> 339   339    Bumpe Ngao      Taninahun          Gandorhun
#> 340   340    Bumpe Ngao      Taninahun            Bumpewo
#> 341   341    Bumpe Ngao      Taninahun            Mokemoh
#> 342   342    Bumpe Ngao      Taninahun              Bauya
#> 343   343    Bumpe Ngao      Taninahun              Kanga
#> 344   344    Bumpe Ngao      Taninahun         Momokanneh
#> 345   345    Bumpe Ngao      Taninahun          Kpetewoma
#> 346   346    Bumpe Ngao      Taninahun             Mokolo
#> 347   347    Bumpe Ngao      Taninahun            Teminde
#> 348   348    Bumpe Ngao      Taninahun           Sembehun
#> 349   349    Bumpe Ngao      Taninahun             Manowo
#> 350   350    Bumpe Ngao      Taninahun          Pelewahun
#> 351   351    Bumpe Ngao      Taninahun         Tokpogorma
#> 352   352    Bumpe Ngao      Taninahun            Mofindo
#> 353   353    Bumpe Ngao      Taninahun             Moyoli
#> 354   354    Bumpe Ngao      Taninahun           Tokpombu
#> 355   355    Bumpe Ngao      Taninahun            Gondama
#> 356   356    Bumpe Ngao      Taninahun            Bongalu
#> 357   357    Bumpe Ngao      Taninahun            Gelehun
#> 358   358    Bumpe Ngao      Taninahun            Gendema
#> 359   359    Bumpe Ngao      Taninahun             Tolobu
#> 360   360    Bumpe Ngao      Taninahun               Dodo
#> 361   361    Bumpe Ngao      Taninahun           Kpanguma
#> 362   362    Bumpe Ngao      Taninahun        Mongegbindi
#> 363   363    Bumpe Ngao      Taninahun           Waterloo
#> 364   364    Bumpe Ngao      Taninahun        Balavulahun
#> 365   365    Bumpe Ngao      Taninahun             Golala
#> 366   366    Bumpe Ngao      Taninahun               Jene
#> 367   367    Bumpe Ngao      Taninahun             Motoko
#> 368   368    Bumpe Ngao      Taninahun            Nagbena
#> 369   369    Bumpe Ngao      Taninahun        Fulaninahun
#> 370   370    Bumpe Ngao      Taninahun             Mokebi
#> 371   371    Bumpe Ngao      Taninahun              Baoma
#> 372   372    Bumpe Ngao      Taninahun           Mogbonda
#> 373   373    Bumpe Ngao      Taninahun            Bandaya
#> 374   374    Bumpe Ngao      Taninahun          Taninahun
#> 375   375    Bumpe Ngao      Taninahun            Molunya
#> 376   376    Bumpe Ngao      Taninahun             Gambia
#> 377   377    Bumpe Ngao      Taninahun            Mongere
#> 378   378    Bumpe Ngao      Taninahun          Kpetewoma
#> 379   379    Bumpe Ngao      Taninahun            Gendema
#> 380   380    Bumpe Ngao      Taninahun           Mongabay
#> 381   381    Bumpe Ngao      Taninahun          Mokpenden
#> 382   382    Bumpe Ngao      Taninahun           Gbangema
#> 383   383    Bumpe Ngao      Taninahun           Makayoni
#> 384   384    Bumpe Ngao      Taninahun            Mojihun
#> 385   385    Bumpe Ngao      Taninahun             Gordiu
#> 386   386    Bumpe Ngao      Taninahun              Macca
#> 387   387    Bumpe Ngao      Taninahun           Mongagba
#> 388   388    Bumpe Ngao      Taninahun            Kangama
#> 389   389    Bumpe Ngao      Taninahun             Hangha
#> 390   390    Bumpe Ngao      Taninahun          Molcombie
#> 391   391    Bumpe Ngao      Taninahun         Hotawuloma
#> 392   392    Bumpe Ngao      Taninahun          Pelewahun
#> 393   393    Bumpe Ngao      Taninahun           Massahun
#> 394   394    Bumpe Ngao      Taninahun              Blama
#> 395   395    Bumpe Ngao      Taninahun         Ngiegboiya
#> 396   396    Bumpe Ngao      Taninahun             Semabu
#> 397   397    Bumpe Ngao      Taninahun            Kpatema
#> 398   398    Bumpe Ngao         Wlihun              Tongi
#> 399   399    Bumpe Ngao         Wlihun            Jiminga
#> 400   400    Bumpe Ngao         Wlihun            Manjama
#> 401   401    Bumpe Ngao         Wlihun              Lungi
#> 402   402    Bumpe Ngao         Wlihun          Pelewahun
#> 403   403    Bumpe Ngao         Wlihun              Gbado
#> 404   404    Bumpe Ngao         Wlihun          Kpetewoma
#> 405   405    Bumpe Ngao         Wlihun            Walihun
#> 406   406    Bumpe Ngao         Wlihun            Sengema
#> 407   407    Bumpe Ngao         Wlihun              Masao
#> 408   408    Bumpe Ngao        Yengema             Madina
#> 409   409    Bumpe Ngao        Yengema            Komendi
#> 410   410    Bumpe Ngao        Yengema              Kanga
#> 411   411    Bumpe Ngao        Yengema             Kowama
#> 412   412    Bumpe Ngao        Yengema             Giehun
#> 413   413    Bumpe Ngao        Yengema            Yengema
#> 414   414           Gbo            Gbo              Hiima
#> 415   415           Gbo            Gbo             Bisibu
#> 416   416           Gbo            Gbo             Baiima
#> 417   417           Gbo            Gbo               Kosa
#> 418   418           Gbo            Gbo            Benduma
#> 419   419           Gbo            Gbo           Massahun
#> 420   420           Gbo            Gbo     Kotumahun Mavi
#> 421   421           Gbo            Gbo            Majihun
#> 422   422           Gbo            Gbo            Senehun
#> 423   423           Gbo            Gbo           Gbeworbu
#> 424   424           Gbo            Gbo            Borbobu
#> 425   425           Gbo            Gbo          Gbangbama
#> 426   426           Gbo            Gbo            Nagbena
#> 427   427           Gbo            Gbo          Ngoyiahun
#> 428   428           Gbo            Gbo            Balehun
#> 429   429           Gbo            Gbo            Bongeya
#> 430   430           Gbo          Maryu         Mogibissie
#> 431   431           Gbo          Maryu               Dodo
#> 432   432           Gbo          Maryu            Batiema
#> 433   433           Gbo          Maryu            Motimor
#> 434   434           Gbo          Maryu          Njabormie
#> 435   435           Gbo          Maryu            Manjama
#> 436   436           Gbo          Maryu           Badjiawo
#> 437   437           Gbo          Maryu             Yakaji
#> 438   438           Gbo          Maryu               Kama
#> 439   439           Gbo          Maryu           Sembehun
#> 440   440           Gbo          Nyawa            Gangama
#> 441   441           Gbo          Nyawa             Gbandi
#> 442   442           Gbo          Nyawa               Buma
#> 443   443           Gbo          Nyawa            Molambi
#> 444   444           Gbo          Nyawa              Dambu
#> 445   445           Gbo          Nyawa               Foya
#> 446   446           Gbo          Nyawa             Largbo
#> 447   447           Gbo          Nyawa          Pelewahun
#> 448   448           Gbo          Nyawa              Barlu
#> 449   449           Gbo          Nyawa            Pujehun
#> 450   450           Gbo          Nyawa  Kotumahun Karanka
#> 451   451 Jaiama Bongor     Lower Kama              Lungi
#> 452   452 Jaiama Bongor        Tongowa           Njekohun
#> 453   453 Jaiama Bongor        Tongowa             Teibor
#> 454   454 Jaiama Bongor        Tongowa              Bauya
#> 455   455 Jaiama Bongor        Tongowa             Lowoma
#> 456   456 Jaiama Bongor        Tongowa            Kenyema
#> 457   457 Jaiama Bongor        Tongowa               Mano
#> 458   458 Jaiama Bongor   Lower Baimba        Mano Bongor
#> 459   459 Jaiama Bongor   Lower Baimba             Godiam
#> 460   460 Jaiama Bongor   Lower Baimba              Bendu
#> 461   461 Jaiama Bongor   Lower Baimba             Kangor
#> 462   462 Jaiama Bongor   Lower Baimba               Buma
#> 463   463 Jaiama Bongor     Lower Kama            Bangema
#> 464   464 Jaiama Bongor     Lower Kama            Kpetema
#> 465   465 Jaiama Bongor     Lower Kama           Jombohun
#> 466   466 Jaiama Bongor     Lower Kama          Koribondo
#> 467   467 Jaiama Bongor    Lower Niawa        Mano Jaiama
#> 468   468 Jaiama Bongor    Lower Niawa               Folu
#> 469   469 Jaiama Bongor    Lower Niawa         Nengbeyama
#> 470   470 Jaiama Bongor    Lower Niawa             Baraka
#> 471   471 Jaiama Bongor    Lower Niawa             Meyama
#> 472   472 Jaiama Bongor    Lower Niawa     Kponima Jaiama
#> 473   473 Jaiama Bongor    Lower Niawa             Sogoma
#> 474   474 Jaiama Bongor    Lower Niawa           Kpulemei
#> 475   475 Jaiama Bongor    Lower Niawa              Blama
#> 476   476 Jaiama Bongor    Lower Niawa               Lago
#> 477   477 Jaiama Bongor    Lower Niawa       Kpetegonumei
#> 478   478 Jaiama Bongor    Lower Niawa              Njala
#> 479   479 Jaiama Bongor    Lower Niawa             Foyama
#> 480   480 Jaiama Bongor    Lower Niawa              Vaama
#> 481   481 Jaiama Bongor    Lower Niawa          Nyandehun
#> 482   482 Jaiama Bongor       Nekpondo            Komemei
#> 483   483 Jaiama Bongor       Nekpondo             Madina
#> 484   484 Jaiama Bongor       Nekpondo              Laoma
#> 485   485 Jaiama Bongor       Nekpondo            Gogbebu
#> 486   486 Jaiama Bongor       Nekpondo            Yabaima
#> 487   487 Jaiama Bongor        Tongowa            Hegbema
#> 488   488 Jaiama Bongor        Tongowa          Lalewahun
#> 489   489 Jaiama Bongor        Tongowa              Yeima
#> 490   490 Jaiama Bongor        Tongowa               Foya
#> 491   491 Jaiama Bongor        Tongowa              Bahun
#> 492   492 Jaiama Bongor        Tongowa            Nagbena
#> 493   493 Jaiama Bongor        Tongowa              Baoma
#> 494   494 Jaiama Bongor        Tongowa            Gangama
#> 495   495 Jaiama Bongor        Tongowa              Talia
#> 496   496 Jaiama Bongor        Tongowa            Mamboma
#> 497   497 Jaiama Bongor        Tongowa            Kponima
#> 498   498 Jaiama Bongor   Upper Baimba               Telu
#> 499   499 Jaiama Bongor   Upper Baimba           Baomahun
#> 500   500 Jaiama Bongor   Upper Baimba            Gangama
#> 501   501 Jaiama Bongor   Upper Baimba          Kpewoyama
#> 502   502 Jaiama Bongor   Upper Baimba        Bumuvulahun
#> 503   503 Jaiama Bongor   Upper Baimba              Faama
#> 504   504 Jaiama Bongor   Upper Baimba            Sulehun
#> 505   505 Jaiama Bongor   Upper Baimba            Gangama
#> 506   506 Jaiama Bongor   Upper Baimba          Kpewoyama
#> 507   507 Jaiama Bongor   Upper Baimba        Bumuvulahun
#> 508   508 Jaiama Bongor   Upper Baimba              Faama
#> 509   509 Jaiama Bongor   Upper Baimba            Sulehun
#> 510   510 Jaiama Bongor     Upper Kama       Mende Kelema
#> 511   511 Jaiama Bongor     Upper Kama              Dombu
#> 512   512 Jaiama Bongor     Upper Kama               Godi
#> 513   513 Jaiama Bongor     Upper Kama            Bowohun
#> 514   514 Jaiama Bongor     Upper Kama           Mangoebu
#> 515   515 Jaiama Bongor     Upper Kama            Walihun
#> 516   516 Jaiama Bongor    Upper Niawa             Koyama
#> 517   517 Jaiama Bongor    Upper Niawa          Periwahun
#> 518   518 Jaiama Bongor    Upper Niawa             Niahun
#> 519   519 Jaiama Bongor    Upper Niawa               Sami
#> 520   520 Jaiama Bongor    Upper Niawa            Nyeyama
#> 521   521 Jaiama Bongor    Upper Niawa              Juhun
#> 522   522 Jaiama Bongor    Upper Niawa           Manowolo
#> 523   523 Jaiama Bongor    Upper Niawa            Gelehun
#> 524   524 Jaiama Bongor    Upper Niawa              Gombu
#> 525   525 Jaiama Bongor    Upper Niawa            Yendema
#> 526   526 Jaiama Bongor    Upper Niawa             Baiima
#> 527   527 Jaiama Bongor    Upper Niawa             Kaimbe
#> 528   528 Jaiama Bongor    Upper Niawa             Yengen
#> 529   529         Kakua        Nyallay            Bevehun
#> 530   530         Kakua        Nyallay            Kpetema
#> 531   531         Kakua        Nyallay          Nyandehun
#> 532   532         Kakua         Korjeh               Kpan
#> 533   533         Kakua         Korjeh          Njaluahun
#> 534   534         Kakua         Korjeh              Kalia
#> 535   535         Kakua         Korjeh              Fallu
#> 536   536         Kakua       Kpandobu            Kenjema
#> 537   537         Kakua       Kpandobu            Vengema
#> 538   538         Kakua       Kpandobu           Manguama
#> 539   539         Kakua       Kpandobu            Mokasie
#> 540   540         Kakua       Kpandobu            Kpatema
#> 541   541         Kakua       Kpandobu             Jibima
#> 542   542         Kakua       Kpandobu           Nyamaina
#> 543   543         Kakua       Kpandobu            Magbema
#> 544   544         Kakua       Kpandobu              Falla
#> 545   545         Kakua       Kpandobu            Fabaina
#> 546   546         Kakua       Kpandobu          Ngeigboya
#> 547   547         Kakua       Kpandobu           Batiyema
#> 548   548         Kakua         Nguabu            Korwama
#> 549   549         Kakua         Nguabu            Sumbuya
#> 550   550         Kakua         Nguabu              Largo
#> 551   551         Kakua         Nguabu        Ngangorehun
#> 552   552         Kakua         Nguabu          Nyandehun
#> 553   553         Kakua         Nguabu          Torkpombu
#> 554   554         Kakua         Nguabu            Balehun
#> 555   555         Kakua         Nguabu             Mbaoma
#> 556   556         Kakua         Nguabu        Kumbablahun
#> 557   557         Kakua         Nguabu            Kpetema
#> 558   558         Kakua         Nguabu              Vaama
#> 559   559         Kakua         Nguabu              Gbina
#> 560   560         Kakua         Nguabu            Walihun
#> 561   561         Kakua         Nguabu              Banda
#> 562   562         Kakua         Nguabu           Gbanahun
#> 563   563         Kakua         Nguabu          Gandorhun
#> 564   564         Kakua         Nguabu             Levuma
#> 565   565         Kakua         Nguabu           Sembehun
#> 566   566         Kakua         Nguabu             Mbaoma
#> 567   567         Kakua         Nguabu           Nduvuibu
#> 568   568         Kakua        Nyallay          Bandajuma
#> 569   569         Kakua        Nyallay     Mbaoma-Lungibu
#> 570   570         Kakua        Nyallay            Jandama
#> 571   571         Kakua          Nyawa           Jagbwema
#> 572   572         Kakua          Nyawa             Kigbai
#> 573   573         Kakua          Nyawa            Gbumbeh
#> 574   574         Kakua          Nyawa            Bangoma
#> 575   575         Kakua          Nyawa           Fengehun
#> 576   576         Kakua          Nyawa          Sarguehun
#> 577   577         Kakua        Samamie          Gbongboma
#> 578   578         Kakua        Samamie           Massahun
#> 579   579         Kakua        Samamie           Kpanguma
#> 580   580         Kakua        Samamie            Boborbu
#> 581   581         Kakua        Samamie            Simbeck
#> 582   582         Kakua        Samamie            Manjama
#> 583   583         Kakua        Samamie             Bayama
#> 584   584         Kakua        Samamie        Fanima-Foya
#> 585   585         Kakua        Samamie            Komende
#> 586   586         Kakua        Samamie            Manihun
#> 587   587         Kakua        Samamie            Mbelima
#> 588   588         Kakua        Samamie        Gbanja Town
#> 589   589         Kakua        Samamie         Old Falaba
#> 590   590         Kakua           Sewa           Mafindor
#> 591   591         Kakua           Sewa            Gondama
#> 592   592         Kakua           Sewa           Kpakorya
#> 593   593         Kakua           Sewa            Gangama
#> 594   594         Kakua           Sewa      Ngamjagorehun
#> 595   595         Kakua           Sewa         Kenedeyama
#> 596   596         Kakua           Sewa            Misilah
#> 597   597         Kakua           Sewa            Dandabu
#> 598   598         Kakua           Sewa           Maminhun
#> 599   599         Kakua           Sewa            Kpawula
#> 600   600         Kakua           Sewa             Konima
#> 601   601         Kakua           Sewa             Tobola
#> 602   602         Kakua           Sewa           Samabobu
#> 603   603         Kakua           Sewa              Balie
#> 604   604         Kakua           Sewa             Tongie
#> 605   605         Kakua         Sindeh            Ngiehun
#> 606   606         Kakua         Sindeh            Bambara
#> 607   607         Kakua         Sindeh             Poluma
#> 608   608         Kakua         Sindeh             Koyama
#> 609   609         Kakua         Sindeh             Wojema
#> 610   610         Kakua         Sindeh          Torkpombu
#> 611   611       Komboya          Kemoh         Banyamahun
#> 612   612       Komboya          Kemoh             Poyama
#> 613   613       Komboya          Kemoh            Manyama
#> 614   614       Komboya          Kemoh           Korkorti
#> 615   615       Komboya          Kemoh               Foya
#> 616   616       Komboya          Kemoh             Semabu
#> 617   617       Komboya          Kemoh        Naiagolehun
#> 618   618       Komboya          Kemoh            Gbanama
#> 619   619       Komboya          Kemoh          Kobondala
#> 620   620       Komboya          Kemoh            Gumahun
#> 621   621       Komboya          Kesua            Kundoma
#> 622   622       Komboya          Kesua             Njawoh
#> 623   623       Komboya          Kesua             Gbaama
#> 624   624       Komboya          Kesua           Yendehun
#> 625   625       Komboya          Kesua            Gbewobu
#> 626   626       Komboya          Kesua            Komboya
#> 627   627       Komboya          Kesua            Kenjama
#> 628   628       Komboya          Kesua           Bendellu
#> 629   629       Komboya          Kesua          Fulawahun
#> 630   630       Komboya          Kesua            Giewabu
#> 631   631       Komboya          Kesua              Bendu
#> 632   632       Komboya        Mangaru               Duya
#> 633   633       Komboya        Mangaru            Logbana
#> 634   634       Komboya        Mangaru            Maajebu
#> 635   635       Komboya        Mangaru             Ketuma
#> 636   636       Komboya        Mangaru             Foindu
#> 637   637       Komboya        Mangaru             Gulubu
#> 638   638       Komboya        Mangaru          Kpamajama
#> 639   639       Komboya        Mangaru            Nongoba
#> 640   640       Komboya        Mangaru            Sungaru
#> 641   641       Komboya        Mangaru          Bandajuma
#> 642   642       Komboya        Mangaru          Bawomahun
#> 643   643       Komboya        Mangaru            Yengema
#> 644   644       Komboya        Mangaru            Kpawuma
#> 645   645       Komboya        Mangaru          Sengbehun
#> 646   646       Komboya            Gao              Vahun
#> 647   647       Komboya            Sei          Pelewahun
#> 648   648       Komboya            Sei              Njala
#> 649   649       Komboya            Sei            Gbitima
#> 650   650       Komboya            Sei              Talia
#> 651   651         Lugbu         Baimba           Kortuhun
#> 652   652         Lugbu         Baimba            Benduma
#> 653   653         Lugbu         Baimba            Mamboma
#> 654   654         Lugbu         Baimba          Kpamgbama
#> 655   655         Lugbu         Baimba              Korbu
#> 656   656         Lugbu         Baimba            Jagbewa
#> 657   657         Lugbu         Baimba             Konima
#> 658   658         Lugbu         Baimba               Yalu
#> 659   659         Lugbu         Baimba          Torkpombu
#> 660   660         Lugbu         Baimba           Pendembu
#> 661   661         Lugbu        Yalenga             Semabu
#> 662   662         Lugbu        Yalenga            Hendobu
#> 663   663         Lugbu        Yalenga            Kpetema
#> 664   664         Lugbu         Baimba              Kandu
#> 665   665         Lugbu         Baimba               Jumu
#> 666   666         Lugbu          Kamba              Belpi
#> 667   667         Lugbu          Kamba             Mokema
#> 668   668         Lugbu          Kamba           Nyalahun
#> 669   669         Lugbu       Kargbevu         Lower Sama
#> 670   670         Lugbu       Kargbevu            Momandu
#> 671   671         Lugbu          Kemoh           Momeinde
#> 672   672         Lugbu          Kemoh             Kpumbu
#> 673   673         Lugbu          Kemoh            Benduma
#> 674   674         Lugbu          Kemoh              Guabu
#> 675   675         Lugbu         Magbao           Gbanahun
#> 676   676         Lugbu         Magbao               Hima
#> 677   677         Lugbu         Magbao            Masahun
#> 678   678         Lugbu         Magbao           Loposema
#> 679   679         Lugbu          Yorma   Ngieya - Gbondaa
#> 680   680         Lugbu          Yorma           Teindema
#> 681   681         Lugbu          Yorma           Kporwubu
#> 682   682   Niawa Lenga        Kaduawo           Segbeima
#> 683   683   Niawa Lenga        Kaduawo              Baoma
#> 684   684   Niawa Lenga        Kaduawo            Gbangba
#> 685   685   Niawa Lenga        Kaduawo           Sembehun
#> 686   686   Niawa Lenga        Kaduawo             Kaniya
#> 687   687   Niawa Lenga        Kaduawo            Bongeya
#> 688   688   Niawa Lenga        Kaduawo            Huawuma
#> 689   689   Niawa Lenga    Lower Niawa            Korihun
#> 690   690   Niawa Lenga    Lower Niawa             Giehun
#> 691   691   Niawa Lenga    Lower Niawa              Blama
#> 692   692   Niawa Lenga    Lower Niawa            Tondeya
#> 693   693   Niawa Lenga    Lower Niawa           Nengbema
#> 694   694   Niawa Lenga    Lower Niawa         Nyandeyama
#> 695   695   Niawa Lenga    Lower Niawa              Luawa
#> 696   696   Niawa Lenga    Lower Niawa            Mbelebu
#> 697   697   Niawa Lenga    Lower Niawa           Guandoma
#> 698   698   Niawa Lenga      Mokpendeh           Njayeima
#> 699   699   Niawa Lenga      Mokpendeh           Gbeyahun
#> 700   700   Niawa Lenga      Mokpendeh            Kpetema
#> 701   701   Niawa Lenga      Mokpendeh             Kenema
#> 702   702   Niawa Lenga      Mokpendeh               Jolu
#> 703   703   Niawa Lenga      Mokpendeh            Gbumbeh
#> 704   704   Niawa Lenga      Mokpendeh             Tabema
#> 705   705   Niawa Lenga      Mokpendeh           Tokpombu
#> 706   706   Niawa Lenga    Upper Niawa              Bendu
#> 707   707   Niawa Lenga    Upper Niawa              Saama
#> 708   708   Niawa Lenga    Upper Niawa               Kowa
#> 709   709   Niawa Lenga    Upper Niawa            Gogbebu
#> 710   710   Niawa Lenga    Upper Niawa              Meima
#> 711   711   Niawa Lenga    Upper Niawa             Konima
#> 712   712   Niawa Lenga        Yalenga         Kongobahun
#> 713   713   Niawa Lenga        Yalenga               Kpah
#> 714   714   Niawa Lenga        Yalenga              Sorma
#> 715   715   Niawa Lenga        Yalenga             Njagor
#> 716   716   Niawa Lenga        Yalenga            Tambalu
#> 717   717   Niawa Lenga        Yalenga             Sahn A
#> 718   718   Niawa Lenga        Yalenga             Jaiama
#> 719   719   Niawa Lenga        Yalenga          Torkpombu
#> 720   720   Niawa Lenga        Yalenga            Dandabu
#> 721   721       Selenga       Old Town          Gbangeima
#> 722   722       Selenga       Old Town              Grima
#> 723   723       Selenga       Old Town              Salon
#> 724   724       Selenga       Old Town            Nigeria
#> 725   725       Selenga       Old Town           Mogbondo
#> 726   726       Selenga       Old Town             Kasema
#> 727   727       Selenga       Bainyawa          Jagbewema
#> 728   728       Selenga       Bainyawa          Tikonkowo
#> 729   729       Selenga        Kaduawo           Segbeima
#> 730   730       Selenga        Kaduawo              Baoma
#> 731   731       Selenga        Kaduawo            Gbangba
#> 732   732       Selenga        Kaduawo             Kaniya
#> 733   733       Selenga        Kaduawo            bongeya
#> 734   734       Selenga        Kaduawo            Huawuma
#> 735   735       Selenga        Mambawa          Wotebehun
#> 736   736       Selenga        Mambawa            Kassama
#> 737   737       Selenga        Mambawa              Njala
#> 738   738       Selenga        Mambawa          Gbangaima
#> 739   739       Selenga        Mambawa            Nigeria
#> 740   740       Selenga        Mambawa            Yenkisa
#> 741   741       Selenga      Mokpendeh           Njayeima
#> 742   742       Selenga      Mokpendeh           Gbeyahun
#> 743   743       Selenga      Mokpendeh            Kpetema
#> 744   744       Selenga      Mokpendeh             Kenema
#> 745   745       Selenga      Mokpendeh               Jolu
#> 746   746       Selenga      Mokpendeh            Gbumbeh
#> 747   747       Selenga      Mokpendeh             Tabema
#> 748   748       Selenga      Mokpendeh           Tokpombu
#> 749   749       Selenga       Old Town          Gbangeima
#> 750   750       Selenga       Old Town              Grima
#> 751   751       Selenga       Old Town              Salon
#> 752   752       Selenga       Old Town           Mogbondo
#> 753   753       Selenga       Old Town             Kasema
#> 754   754       Selenga       Old Town           Damballa
#> 755   755       Selenga       Old Town           Sembehun
#> 756   756       Selenga       Old Town          Njaluahun
#> 757   757       Selenga       Old Town           Mobondey
#> 758   758       Selenga       Old Town           Mamboima
#> 759   759       Selenga       Old Town            Korwama
#> 760   760       Selenga       Old Town         N'Yandehun
#> 761   761       Selenga       Old Town          Njaluahun
#> 762   762       Selenga       Old Town           Mamboima
#> 763   763       Selenga       Old Town            Korwama
#> 764   764       Selenga       Old Town          Nyandehun
#> 765   765       Tikonko     Ngolamajie          Tokopombu
#> 766   766       Tikonko     Ngolamajie       Ngalivulahun
#> 767   767       Tikonko     Ngolamajie            Dandabu
#> 768   768       Tikonko     Ngolamajie            Ngombeh
#> 769   769       Tikonko     Ngolamajie         Kalogeyabu
#> 770   770       Tikonko     Ngolamajie   Baoma (Geyewoma)
#> 771   771       Tikonko     Ngolamajie          Kondiyama
#> 772   772       Tikonko     Ngolamajie            Kpoyama
#> 773   773       Tikonko     Ngolamajie           Njagbina
#> 774   774       Tikonko     Ngolamajie            Kpawama
#> 775   775       Tikonko     Ngolamajie           Mamboima
#> 776   776       Tikonko     Ngolamajie            Natihun
#> 777   777       Tikonko     Ngolamajie             Tolobu
#> 778   778       Tikonko     Ngolamajie             Sulima
#> 779   779       Tikonko     Ngolamajie            Bandawa
#> 780   780       Tikonko     Ngolamajie          Gandorhun
#> 781   781       Tikonko     Ngolamajie              Kanga
#> 782   782       Tikonko     Ngolamajie           Morkasie
#> 783   783       Tikonko     Ngolamajie             Gbanga
#> 784   784       Tikonko     Ngolamajie            Negbema
#> 785   785       Tikonko     Ngolamajie            Njagbla
#> 786   786       Tikonko     Ngolamajie             Mattru
#> 787   787       Tikonko          Seiwa               Dodo
#> 788   788       Tikonko          Seiwa             Kapima
#> 789   789       Tikonko          Seiwa            Tikonko
#> 790   790       Tikonko          Seiwa            kpakuma
#> 791   791       Tikonko          Seiwa           Wubangay
#> 792   792       Tikonko          Seiwa           Gbalehun
#> 793   793       Tikonko          Seiwa          Pelewahun
#> 794   794       Tikonko          Seiwa           Magbwema
#> 795   795       Tikonko          Seiwa            Gendema
#> 796   796       Tikonko          Seiwa         Sami- Tabe
#> 797   797       Tikonko          Seiwa             Foindu
#> 798   798       Tikonko          Seiwa          Faikundor
#> 799   799       Tikonko          Morku            Sengema
#> 800   800       Tikonko          Morku           Sembehun
#> 801   801       Tikonko          Morku              Baoma
#> 802   802       Tikonko          Morku            Bevehun
#> 803   803       Tikonko          Morku              Adala
#> 804   804       Tikonko          Morku        Manobebeteh
#> 805   805       Tikonko      Njagbla I            Mokumba
#> 806   806       Tikonko      Njagbla I          Taninahun
#> 807   807       Tikonko      Njagbla I            Golahun
#> 808   808       Tikonko     Njagbla II            Magbema
#> 809   809       Tikonko     Njagbla II          Gandorhun
#> 810   810       Tikonko     Njagbla II               Lorh
#> 811   811       Tikonko     Njagbla II          Taninahun
#> 812   812       Tikonko     Njagbla II            Majihun
#> 813   813       Tikonko     Njagbla II             Failor
#> 814   814       Tikonko     Njagbla II             Mokema
#> 815   815       Tikonko          Seiwa             Kenema
#> 816   816       Tikonko          Seiwa              Daaru
#> 817   817       Tikonko          Seiwa          Tanganema
#> 818   818       Tikonko          Seiwa             Govama
#> 819   819       Tikonko          Seiwa       Logorvulahun
#> 820   820       Tikonko          Seiwa             Towama
#> 821   821       Tikonko          Seiwa           Jombohun
#> 822   822       Tikonko          Seiwa            Mosakpa
#> 823   823       Tikonko          Seiwa            Mendewa
#> 824   824       Tikonko          Seiwa            Njewoma
#> 825   825       Tikonko          Seiwa         Kaindeyela
#> 826   826       Tikonko          Seiwa               Sami
#> 827   827       Tikonko          Seiwa            Benduma
#> 828   828       Tikonko          Seiwa           Bangeima
#> 829   829       Tikonko          Seiwa            Gelehun
#> 830   830       Tikonko          Seiwa           Nyanyama
#> 831   831       Tikonko          Seiwa            Lembema
#> 832   832       Tikonko          Seiwa            Ngiehun
#> 833   833       Tikonko          Seiwa              Dambu
#> 834   834       Tikonko          Seiwa            Potehun
#> 835   835       Tikonko          Seiwa            Yoviama
#> 836   836       Tikonko          Seiwa             Ballie
#> 837   837       Tikonko          Seiwa          Kpetewoma
#> 838   838       Tikonko          Seiwa           Gbanahun
#> 839   839       Tikonko          Seiwa            Magibeh
#> 840   840       Tikonko          Seiwa            Ngebina
#> 841   841       Tikonko          Seiwa          Bawomahun
#> 842   842       Tikonko          Seiwa          Surgbehun
#> 843   843       Tikonko          Seiwa          Fulawahun
#> 844   844       Tikonko          Seiwa           Tokpombu
#> 845   845       Tikonko          Seiwa        Kpawugbahun
#> 846   846       Tikonko          Seiwa             Golala
#> 847   847       Tikonko          Seiwa       Nyayagolehun
#> 848   848       Tikonko          Seiwa            Kpetema
#> 849   849       Tikonko          Seiwa             Kigbai
#> 850   850       Tikonko          Seiwa              Borbu
#> 851   851       Tikonko          Seiwa              Njala
#> 852   852       Tikonko         Sendeh            Maboima
#> 853   853       Tikonko         Sendeh       New Sembehun
#> 854   854       Tikonko         Sendeh               Tuba
#> 855   855       Tikonko         Sendeh         Nyandeyama
#> 856   856       Valunia       Deilenga            Pujehun
#> 857   857       Valunia       Deilenga           Baomahun
#> 858   858       Valunia       Deilenga            Jabwama
#> 859   859       Valunia       Deilenga           Moyorgbo
#> 860   860       Valunia       Deilenga            Lablama
#> 861   861       Valunia       Deilenga        Mendekelema
#> 862   862       Valunia       Deilenga             Kowama
#> 863   863       Valunia       Deilenga             Konima
#> 864   864       Valunia       Deilenga         Ngewojahun
#> 865   865       Valunia       Deilenga            Kongopa
#> 866   866       Valunia       Deilenga          Nyandehun
#> 867   867       Valunia       Deilenga            Bohehun
#> 868   868       Valunia       Deilenga            Simbeck
#> 869   869       Valunia       Deilenga             Bumpeh
#> 870   870       Valunia       Deilenga         Hendogboma
#> 871   871       Valunia       Deilenga            Kpateya
#> 872   872       Valunia       Deilenga            Belihun
#> 873   873       Valunia       Deilenga             Semabu
#> 874   874       Valunia       Deilenga              Jallo
#> 875   875       Valunia       Deilenga          Taninahun
#> 876   876       Valunia       Deilenga            Sengima
#> 877   877       Valunia       Deilenga            Kpewama
#> 878   878       Valunia       Deilenga             Palima
#> 879   879       Valunia       Deilenga             Njabla
#> 880   880       Valunia       Deilenga            Kanjalo
#> 881   881       Valunia        Kendebu           Massahun
#> 882   882       Valunia        Kendebu             Nyahun
#> 883   883       Valunia        Kendebu              Lagor
#> 884   884       Valunia        Kendebu           Njalahun
#> 885   885       Valunia        Kendebu           Yendehun
#> 886   886       Valunia        Kendebu           Manjendu
#> 887   887       Valunia        Kendebu              Claya
#> 888   888       Valunia        Kendebu            Kpetema
#> 889   889       Valunia        Kendebu             Cosima
#> 890   890       Valunia        Kendebu            Sengema
#> 891   891       Valunia   Lower Kargoi              Gaura
#> 892   892       Valunia   Lower Kargoi            Yanihun
#> 893   893       Valunia   Lower Kargoi            Kpeyama
#> 894   894       Valunia   Lower Kargoi           Bathurst
#> 895   895       Valunia   Lower Kargoi              Gombu
#> 896   896       Valunia   Lower Kargoi        Naiagolehun
#> 897   897       Valunia   Lower Kargoi              Njala
#> 898   898       Valunia          Lunia              Ngalu
#> 899   899       Valunia          Lunia             Kamaru
#> 900   900       Valunia          Lunia            Kponibu
#> 901   901       Valunia          Lunia             Kavoma
#> 902   902       Valunia          Lunia            Jojohun
#> 903   903       Valunia          Lunia            Kpasama
#> 904   904       Valunia          Lunia            Nwogema
#> 905   905       Valunia          Lunia       Konima - New
#> 906   906       Valunia          Lunia            Tongoma
#> 907   907       Valunia          Lunia             Barrie
#> 908   908       Valunia          Lunia               Daru
#> 909   909       Valunia          Lunia             Yawema
#> 910   910       Valunia          Lunia             Bekeya
#> 911   911       Valunia          Lunia              Yuabu
#> 912   912       Valunia          Lunia           Masumana
#> 913   913       Valunia          Lunia             Levuma
#> 914   914       Valunia          Lunia           Kpakimbu
#> 915   915       Valunia          Lunia             Madina
#> 916   916       Valunia          Lunia           Nyaiahun
#> 917   917       Valunia          Lunia            Banjema
#> 918   918       Valunia          Lunia              Baoma
#> 919   919       Valunia          Lunia             Lomabu
#> 920   920       Valunia          Lunia            Kpetema
#> 921   921       Valunia          Lunia             Gowala
#> 922   922       Valunia          Lunia             Nayema
#> 923   923       Valunia          Lunia          Bandujuma
#> 924   924       Valunia          Lunia           Jonjahun
#> 925   925       Valunia          Lunia              Wunde
#> 926   926       Valunia          Lunia             Konima
#> 927   927       Valunia          Lunia            Mongeri
#> 928   928       Valunia          Lunia              Konta
#> 929   929       Valunia          Lunia           Njalehun
#> 930   930       Valunia          Lunia         Jopolwahun
#> 931   931       Valunia          Lunia            Gelehun
#> 932   932       Valunia          Lunia           Waterloo
#> 933   933       Valunia          Lunia            Gumahun
#> 934   934       Valunia          Lunia          Nyandehun
#> 935   935       Valunia          Lunia           Manjehun
#> 936   936       Valunia          Lunia             Hewebu
#> 937   937       Valunia          Lunia          Pelewahun
#> 938   938       Valunia          Lunia              Njala
#> 939   939       Valunia          Lunia         Njopowahun
#> 940   940       Valunia          Lunia           Clifonia
#> 941   941       Valunia          Lunia         Nyandeyama
#> 942   942       Valunia          Lunia               Gima
#> 943   943       Valunia         Manyeh           Gbojeima
#> 944   944       Valunia         Manyeh           Layiahun
#> 945   945       Valunia         Manyeh             Malema
#> 946   946       Valunia          Ngovo              Njala
#> 947   947       Valunia          Ngovo             Kpoebu
#> 948   948       Valunia          Ngovo             Bogema
#> 949   949       Valunia          Ngovo             Ngorbu
#> 950   950       Valunia          Ngovo            Balehun
#> 951   951       Valunia       Seilenga               Juma
#> 952   952       Valunia       Seilenga           Tokpombu
#> 953   953       Valunia       Seilenga            Benduma
#> 954   954       Valunia       Seilenga           Gbassama
#> 955   955       Valunia       Seilenga              Farma
#> 956   956       Valunia       Seilenga            Tongoba
#> 957   957       Valunia       Seilenga             Peyela
#> 958   958       Valunia       Seilenga Njalihun -Junction
#> 959   959       Valunia       Seilenga           Moselleh
#> 960   960       Valunia       Seilenga              Giema
#> 961   961       Valunia       Seilenga            Naiahun
#> 962   962       Valunia       Seilenga            Kpakibu
#> 963   963       Valunia       Seilenga               Foya
#> 964   964       Valunia        Vanjelu          Kpetewama
#> 965   965       Valunia        Vanjelu              Mandu
#> 966   966       Valunia        Vanjelu             Madina
#> 967   967       Valunia        Vanjelu            Yambama
#> 968   968       Valunia        Vanjelu             Kundom
#> 969   969       Valunia       Yarlenga            Jagbema
#> 970   970       Valunia       Yarlenga            Dassamu
#> 971   971       Valunia       Yarlenga             Giehun
#> 972   972       Valunia       Yarlenga             Mogbwe
#> 973   973       Valunia       Yarlenga          Dambalawa
#> 974   974       Valunia       Yarlenga            Pembema
#> 975   975       Valunia       Yarlenga               Selu
#> 976   976       Valunia       Yarlenga            Gorahun
#> 977   977       Valunia       Yarlenga          kotumahun
#> 978   978       Valunia       Yarlenga              Farma
#> 979   979       Valunia       Yarlenga            Magbema
#> 980   980       Valunia       Yarlenga             Naiama
#> 981   981       Valunia       Yarlenga            Kpetema
#> 982   982       Valunia       Yarlenga      Kenema Blango
#> 983   983       Valunia       Yarlenga             Njallo
#> 984   984       Valunia       Yarlenga            Yabaima
#> 985   985         Wonde Central Kargoi              Wonde
#> 986   986         Wonde Central Kargoi           Kpuawala
#> 987   987         Wonde Central Kargoi            Mendama
#> 988   988         Wonde Central Kargoi             YawaJu
#> 989   989         Wonde         Manyeh              Konia
#> 990   990         Wonde         Manyeh             Fanima
#> 991   991         Wonde         Manyeh             Tolobu
#> 992   992         Wonde         Manyeh             Fayama
#> 993   993         Wonde         Manyeh          Pelewahun
#> 994   994         Wonde         Manyeh            Gendema
#> 995   995         Wonde         Manyeh            Kigbema
#> 996   996         Wonde   Upper Kargoi              Njala
#> 997   997         Wonde   Upper Kargoi                Dia
#> 998   998         Wonde   Upper Kargoi            Gboyama
#> 999   999         Wonde   Upper Kargoi            Yengema
#> 1000 1000         Wonde   Upper Kargoi             Boamai
#> 1001 1001         Wonde   Upper Kargoi        Njagbakahun
```

The `get_sampling_list()` function implements the list-based sampling
method. For example, if 40 clusters/villages are needed to be sampled to
find the 19 SAM cases calculated earlier, a sampling list can be created
as follows:

``` r
get_sampling_list(village_list, 40)
```

which provides the following sampling list:

|     |  id | chiefdom      | section       | village      |
| :-- | --: | :------------ | :------------ | :----------- |
| 9   |   9 | Badjia        | Kpallay       | Jokibu       |
| 34  |  34 | Badjia        | Sei           | Mbokeni      |
| 59  |  59 | Bagbe         | Nyallay       | Blama        |
| 84  |  84 | Bagbo         | Gorapon       | Dema         |
| 109 | 109 | Bagbo         | Kpangbalia    | Nyandehun    |
| 134 | 134 | Bagbo         | Tissawa       | Mossa Gbahun |
| 159 | 159 | Baoma         | Bambawo       | Gollu        |
| 184 | 184 | Baoma         | Lower Pataloo | Kpakru       |
| 209 | 209 | Baoma         | Sannah        | Ngually      |
| 234 | 234 | Bumpe Ngao    | Bumpe         | Mongla       |
| 259 | 259 | Bumpe Ngao    | Bumpe         | Fanima       |
| 284 | 284 | Bumpe Ngao    | Sewama        | Walihun      |
| 309 | 309 | Bumpe Ngao    | Sahn          | Wunde        |
| 334 | 334 | Bumpe Ngao    | Taninahun     | Njagbema     |
| 359 | 359 | Bumpe Ngao    | Taninahun     | Tolobu       |
| 384 | 384 | Bumpe Ngao    | Taninahun     | Mojihun      |
| 409 | 409 | Bumpe Ngao    | Yengema       | Komendi      |
| 434 | 434 | Gbo           | Maryu         | Njabormie    |
| 459 | 459 | Jaiama Bongor | Lower Baimba  | Godiam       |
| 484 | 484 | Jaiama Bongor | Nekpondo      | Laoma        |
| 509 | 509 | Jaiama Bongor | Upper Baimba  | Sulehun      |
| 534 | 534 | Kakua         | Korjeh        | Kalia        |
| 559 | 559 | Kakua         | Nguabu        | Gbina        |
| 584 | 584 | Kakua         | Samamie       | Fanima-Foya  |
| 609 | 609 | Kakua         | Sindeh        | Wojema       |
| 634 | 634 | Komboya       | Mangaru       | Maajebu      |
| 659 | 659 | Lugbu         | Baimba        | Torkpombu    |
| 684 | 684 | Niawa Lenga   | Kaduawo       | Gbangba      |
| 709 | 709 | Niawa Lenga   | Upper Niawa   | Gogbebu      |
| 734 | 734 | Selenga       | Kaduawo       | Huawuma      |
| 759 | 759 | Selenga       | Old Town      | Korwama      |
| 784 | 784 | Tikonko       | Ngolamajie    | Negbema      |
| 809 | 809 | Tikonko       | Njagbla II    | Gandorhun    |
| 834 | 834 | Tikonko       | Seiwa         | Potehun      |
| 859 | 859 | Valunia       | Deilenga      | Moyorgbo     |
| 884 | 884 | Valunia       | Kendebu       | Njalahun     |
| 909 | 909 | Valunia       | Lunia         | Yawema       |
| 934 | 934 | Valunia       | Lunia         | Nyandehun    |
| 959 | 959 | Valunia       | Seilenga      | Moselleh     |
| 984 | 984 | Valunia       | Yarlenga      | Yabaima      |

### Classifying coverage

With data collected from a SLEAC survey, the `lqas_classify_coverage()`
function is used to classify coverage. For example, using the
`survey_data` dataset, per district coverage classification can be
calculated as follows:

``` r
with(survey_data, lqas_classify_coverage(n = in_cases, n_total = n))
```

which outputs the following results:

    #>  [1] "Low"      "Low"      "Low"      "Low"      "Low"      "Low"     
    #>  [7] "Low"      "Moderate" "Moderate" "Moderate" "Low"      "Low"     
    #> [13] "Low"      "Low"

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
#>                     Low : 0.9552
#>                Moderate : 0.8319
#>                    High : 0.8354
#>                 Overall : 0.9062
#> Gross misclassification : 0
```

## Citation

If you use `{sleacr}` in your work, please cite using the suggested
citation provided by a call to the `citation` function as follows:

``` r
citation("sleacr")
#> To cite sleacr in publications use:
#> 
#>   Mark Myatt, Ernest Guevarra, Lionella Fieschi, Allison Norris, Saul
#>   Guerrero, Lilly Schofield, Daniel Jones, Ephrem Emru, Kate Sadler
#>   (2012). _Semi-Quantitative Evaluation of Access and Coverage
#>   (SQUEAC)/Simplified Lot Quality Assurance Sampling Evaluation of
#>   Access and Coverage (SLEAC) Technical Reference_. FHI 360/FANTA,
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
