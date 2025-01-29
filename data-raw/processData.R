# Process external datasets ----------------------------------------------------

## Load libraries ----

library(readxl)

## Read and process village_list data ----

village_list <- readxl::read_xls("data-raw/bo_village.xls", sheet = 1)
names(village_list) <- c("id", "chiefdom", "section", "village")

usethis::use_data(village_list, overwrite = TRUE, compress = "xz")

## Read and process SLEAC survey data ----

survey_data <- read.csv("data-raw/sleacSL.csv")

survey_data <- subset(survey_data, select = c(-vita, -worm))

names(survey_data) <- c("country", "province", "district", "cases_in", "rec_in", "cases_total")

survey_data <- within(survey_data, {
  cases_out <- cases_total - cases_in
}) |>
  (\(x) x[ , c("country", "province", "district", "cases_in", "cases_out", "rec_in", "cases_total")])()

survey_data <- tibble::as_tibble(survey_data)
usethis::use_data(survey_data, overwrite = TRUE, compress = "xz")


## Create Sierra Leone district population data ----

pop_data <- tibble::tibble(
  district = c(
    "Kailahun", "Kenema", "Kono", "Bombali", "Kambia", "Koinadugu",
    "Port Loko", "Tonkolili", "Bo", "Bonthe", "Moyamba", "Pujehun",
    "Western Area Rural", "Western Area Urban"
  ),
  pop = c(
    526379, 609891, 506100, 606544, 345474, 409372, 615376, 531435, 575478,
    200781, 318588, 346461, 444270, 1055964
  )
)

pop_data <- tibble::as_tibble(pop_data)
usethis::use_data(pop_data, overwrite = TRUE, compress = "xz")

