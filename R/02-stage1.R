#'
#' Select sampling clusters using systematic sampling
#'
#' @param N_clusters Total number of clusters in survey area.
#' @param n_clusters Number of sampling clusters to be selected.
#' @param cluster_list A data.frame containing at least the name or any other
#'   identifier for the entire set of clusters to sample from.
#'
#' @return An integer vector for [get_sampling_clusters()] giving the row 
#'   index for selected clusters. A data.frame for `[get_sampling_list()]` which 
#'   is a subset of `cluster_list`.
#'
#' @examples
#' get_sampling_clusters(N_clusters = 211, n_clusters = 35)
#' get_sampling_list(cluster_list = village_list, n_clusters = 70)
#'
#' @export
#' @rdname get_sampling
#'

get_sampling_clusters <- function(N_clusters, n_clusters) {
  interval <- get_sampling_interval(
    N_clusters = N_clusters, n_clusters = n_clusters
  )

  random_start <- select_random_start(interval = interval)

  sample_sequence <- seq(from = random_start, to = N_clusters, by = interval)

  sample_sequence
}

#'
#' @export
#' @rdname get_sampling
#'

get_sampling_list <- function(cluster_list, n_clusters) {
  sample_sequence <- get_sampling_clusters(
    N_clusters = nrow(cluster_list), n_clusters = n_clusters
  )

  cluster_list[sample_sequence, ]
}

#'
#' @keywords internal
#'

select_random_start <- function(interval) {
  sample(x = seq_len(interval), size = 1)
}

#'
#' @keywords internal
#'

get_sampling_interval <- function(N_clusters, n_clusters) {
  floor(N_clusters / n_clusters)
}