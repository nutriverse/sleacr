#'
#' List of villages in Bo District, Sierra Leone
#'
#' @format A tibble with 1001 rows and 4 columns
#' 
#' **Variable** | **Description**
#' :--- | :---
#' *id* | Unique identifier
#' *chiefdom* | Chiefdom
#' *section* | Section
#' *village* | Village
#' 
#' @source Ministry of Health, Sierra Leone
#'
#' @examples
#' village_list
#' 

"village_list"


#'
#' SLEAC survey data from Sierra Leone
#'
#' @format A tibble with 14 rows and 6 columns
#' 
#' **Variable** | **Description**
#' :--- | :---
#' *country* | Country
#' *province* | Province
#' *district* | District
#' *cases_in* | SAM cases found who are in the programme
#' *cases_out* | SAM cases found who are not in the programme
#' *rec_in* | Recovering SAM cases in the programme
#' *cases_total* | Total number SAM cases found
#'
#' @source Ministry of Health, Sierra Leone
#'
#' @examples
#' survey_data
#'

"survey_data"


#'
#' Population data of districts of Sierra Leone based on 2015 census
#' 
#' @format A tibble with 14 rows and 2 columns
#' 
#' **Variable** | **Description**
#' :--- | :---
#' *district* | District name
#' *pop* | Population
#' 
#' @source https://sierraleone.unfpa.org/sites/default/files/pub-pdf/Population%20structure%20Report_1.pdf
#' 
#' @examples
#' pop_data
#' 

"pop_data"
