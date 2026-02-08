# Package index

## LQAS sampling frame

- [`get_sample_n()`](https://nutriverse.io/sleacr/dev/reference/get_sample.md)
  [`get_sample_d()`](https://nutriverse.io/sleacr/dev/reference/get_sample.md)
  : Calculate sample size and decision rule for a specified LQAS
  sampling plan
- [`get_n_cases()`](https://nutriverse.io/sleacr/dev/reference/get_n_cases.md)
  : Calculate estimated number of cases for a condition affecting
  children under 5 years old in a specified survey area
- [`get_n_clusters()`](https://nutriverse.io/sleacr/dev/reference/get_n_clusters.md)
  : Calculate number of clusters to sample to reach target sample size

## Stage 1 sampling

- [`get_sampling_clusters()`](https://nutriverse.io/sleacr/dev/reference/get_sampling.md)
  [`get_sampling_list()`](https://nutriverse.io/sleacr/dev/reference/get_sampling.md)
  : Select sampling clusters using systematic sampling

## Coverage classifier

- [`lqas_classify_()`](https://nutriverse.io/sleacr/dev/reference/lqas_classify.md)
  [`lqas_classify()`](https://nutriverse.io/sleacr/dev/reference/lqas_classify.md)
  [`lqas_classify_cf()`](https://nutriverse.io/sleacr/dev/reference/lqas_classify.md)
  [`lqas_classify_tc()`](https://nutriverse.io/sleacr/dev/reference/lqas_classify.md)
  : LQAS classifier

## Tests for SLEAC classifier performance

- [`lqas_simulate_population()`](https://nutriverse.io/sleacr/dev/reference/lqas_simulate.md)
  [`lqas_simulate_run()`](https://nutriverse.io/sleacr/dev/reference/lqas_simulate.md)
  [`lqas_simulate_runs()`](https://nutriverse.io/sleacr/dev/reference/lqas_simulate.md)
  [`lqas_simulate_test()`](https://nutriverse.io/sleacr/dev/reference/lqas_simulate.md)
  : Simulate survey data of covered/cases and non-covered/non-cases
  given a coverage/prevalence proportion

- [`lqas_get_class_prob()`](https://nutriverse.io/sleacr/dev/reference/lqas_get_class_prob.md)
  : Produce misclassification probabilities

- [`print(`*`<lqasClass>`*`)`](https://nutriverse.io/sleacr/dev/reference/print.lqasClass.md)
  :

  `print` helper function for
  [`lqas_get_class_prob()`](https://nutriverse.io/sleacr/dev/reference/lqas_get_class_prob.md)
  function

- [`plot(`*`<lqasSim>`*`)`](https://nutriverse.io/sleacr/dev/reference/plot.lqasSim.md)
  :

  `plot` helper function for
  [`lqas_simulate_test()`](https://nutriverse.io/sleacr/dev/reference/lqas_simulate.md)
  function

## Post-stratification weighted estimator

- [`estimate_coverage_overall()`](https://nutriverse.io/sleacr/dev/reference/estimate_coverage.md)
  [`estimate_coverage()`](https://nutriverse.io/sleacr/dev/reference/estimate_coverage.md)
  : Weighted post-stratification estimation of coverage over several
  service delivery units

## Test for coverage homogeneity

- [`check_coverage_homogeneity()`](https://nutriverse.io/sleacr/dev/reference/check_coverage_homogeneity.md)
  : Check coverage distribution

## Datasets

- [`village_list`](https://nutriverse.io/sleacr/dev/reference/village_list.md)
  : List of villages in Bo District, Sierra Leone
- [`survey_data`](https://nutriverse.io/sleacr/dev/reference/survey_data.md)
  : SLEAC survey data from Sierra Leone
- [`pop_data`](https://nutriverse.io/sleacr/dev/reference/pop_data.md) :
  Population data of districts of Sierra Leone based on 2015 census
