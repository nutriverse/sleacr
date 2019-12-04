################################################################################
#
# UI
#
################################################################################
## Load dependencies
if(!require(shiny)) install.packages("shiny")
if(!require(shinythemes)) install.packages("shinythemes")
if(!require(remotes)) install.packages("remotes")
if(!require(sleacr)) remotes::install_github("rapidsurveys/sleacr")
##
navbarPage(title = "sleacr", id = "chosenTab", theme = shinytheme("sandstone"),
  tabPanel(title = "", value = 1, icon = icon(name = "home", class = "fa-lg"),
    div(class = "outer",
        tags$head(includeCSS("styles.css"))
    ),
    sidebarLayout(
      sidebarPanel(width = 3,
        h5("Enter LQAS survey parameters"),
        ## lower threshold
        sliderInput(inputId = "dLower",
          label = "Lower triage threshold",
          value = 20,
          min = 10,
          max = 90,
          step = 5),
        ## upper threshold
        sliderInput(inputId = "dUpper",
          label = "Upper triage treshold",
          value = 50,
          min = 50,
          max = 90
        )
      ),
      ## Main panel
      mainPanel(width = 9,
      )
    )
  )
)
