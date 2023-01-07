library(readxl)

village_list <- readxl::read_xls("data-raw/bo_village.xls", sheet = 1)
names(village_list) <- c("id", "chiefdom", "section", "village")

usethis::use_data(village_list, overwrite = TRUE, compress = "xz")





