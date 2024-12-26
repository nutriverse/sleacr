#'
#' Select sampling clusters using systematic sampling
#'
#' @param N_clusters Total number of clusters in survey area
#' @param n_clusters Number of sampling clusters to be selected
#' @param interval Sampling interval usually calculated using
#'   `[get_sampling_interval()]`
#' @param cluster_list A data.frame containing at least the name or any other
#'   identifier for the entire set of clusters to sample from.
#'
#' @return A numeric value for `[get_sampling_interval()]` and
#'   `[select_random_start()]`. An integer vector for 
#'   `[select_sampling_clusters()]` giving the row index for selected clusters. 
#'   A data.frame for `[create_sampling_list()]` which is a subset of 
#'   `cluster_list`
#'
#' @examples
#' get_sampling_interval(N_clusters = 211, n_clusters = 35)
#' interval <- get_sampling_interval(N_clusters = 211, n_clusters = 35)
#' select_random_start(interval)
#' select_sampling_clusters(N_clusters = 211, n_clusters = 35)
#' create_sampling_list(cluster_list = village_list, n_clusters = 70)
#'
#' @export
#' @rdname sampling
#'

get_sampling_interval <- function(N_clusters, n_clusters) {
  floor(N_clusters / n_clusters)
}

#'
#' @export
#' @rdname sampling
#'

select_random_start <- function(interval) {
  sample(x = seq_len(interval), size = 1)
}

#'
#' @export
#' @rdname sampling
#'

select_sampling_clusters <- function(N_clusters, n_clusters) {
  interval <- get_sampling_interval(
    N_clusters = N_clusters, n_clusters = n_clusters
  )

  random_start <- select_random_start(interval = interval)

  sample_sequence <- seq.int(
    from = random_start, to = N_clusters, by = interval
  )

  sample_sequence
}

#'
#' @export
#' @rdname sampling
#'

create_sampling_list <- function(cluster_list, n_clusters) {
  sample_sequence <- select_sampling_clusters(
    N_clusters = nrow(cluster_list), n_clusters = n_clusters
  )

  cluster_list[sample_sequence, ]
}
