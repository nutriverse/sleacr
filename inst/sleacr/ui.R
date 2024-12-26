################################################################################
#
# UI
#
################################################################################
## Load dependencies
if(!require(shiny)) install.packages("shiny")
if(!require(shinythemes)) install.packages("shinythemes")
if(!require(remotes)) install.packages("remotes")
if(!require(sleacr)) remotes::install_github("nutriverse/sleacr")
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
          label = "Lower triage threshold (%)",
          value = 20,
          min = 5,
          max = 65,
          step = 5),
        ## upper threshold
        uiOutput(outputId = "dUpper"),
        ## Sample size
        sliderInput(inputId = "sampleSize",
          label = "Survey sample size",
          value = 40,
          min = 15,
          max = 100,
          step = 1),
        sliderInput(inputId = "populationSize",
          label = "Population size",
          value = 192,
          min = 50,
          max = 1000,
          step = 1),
        #sliderInput(inputId = "runs",
        #  label = "Simulation runs at each proportion",
        #  value = 50,
        #  min = 50,
        #  max = 100),
        #sliderInput(inputId = "fine",
        #  label = "Granularity of simulated proportions (%)",
        #  value = 1,
        #  min = 0.1,
        #  max = 1),
        #sliderInput(inputId = "span",
        #  label = "Span for LOWESS smoother for probability plots",
        #  value = 0.02,
        #  min = 0.02,
        #  max = 1),
        #sliderInput(inputId = "pLower",
        #  label = "Starting proportion for simulation (%)",
        #  value = 0,
        #  min = 0,
        #  max = 0),
        #sliderInput(inputId = "pUpper",
        #  label = "Ending proportion for simulation (%)",
        #  value = 100,
        #  min = 100,
        #  max = 100),
        actionButton(inputId = "runTest",
          label = "Run",
          class = "btn-primary",
          icon = icon(name = "chart-line", class = "fa-lg"),
          width = "100%")
      ),
      ## Main panel
      mainPanel(width = 9,
        tabsetPanel(id = "outputType", selected = 1,
          tabPanel(title = "Table", value = 1,
            tableOutput(outputId = "probClassTable")
          ),
          tabPanel(title = "Plot", value = 2,
            plotOutput(outputId = "probClassPlot", height = "600px")
          )
        )
      )
    )
  )
)
