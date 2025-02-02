# Retrieve chi-square statistic table ------------------------------------------

session <- rvest::session(
  "https://people.richland.edu/james/lecture/m170/tbl-chi.html"
)

chi_square_table <- rvest::html_table(session) |>
  (\(x) x[[1]])()

usethis::use_data(
  chi_square_table, internal = TRUE, overwrite = TRUE, compress = "xz"
)
