## Load libraries --------------------------------------------------------------
library(readxl)

## Read and process village_list data ------------------------------------------

village_list <- readxl::read_xls("data-raw/bo_village.xls", sheet = 1)
names(village_list) <- c("id", "chiefdom", "section", "village")

usethis::use_data(village_list, overwrite = TRUE, compress = "xz")

## Read and process SLEAC survey data ------------------------------------------

survey_data <- read.csv("data-raw/sleacSL.csv")

survey_data <- subset(survey_data, select = c(-vita, -worm))

names(survey_data) <- c("country", "province", "district", "in_cases", "out_cases", "n")

survey_data <- tibble::tibble(survey_data)

usethis::use_data(survey_data, overwrite = TRUE, compress = "xz")



