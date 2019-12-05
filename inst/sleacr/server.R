################################################################################
#
# Server function
#
################################################################################
##
function(input, output, session) {
  #
  ##############################################################################
  ## INPUTS
  ##############################################################################
  ## Input for dUpper
  output$dUpper <- renderUI({
    req(input$dLower)
    #dUpperDefault <- input$dLower + 30
    sliderInput(inputId = "dUpper",
                label = "Upper triage threshold",
                value = input$dLower + 30,
                min = input$dLower + 30,
                max = 95)
  })
  ##
  ##############################################################################
  ## Simulation
  ##############################################################################
  ## Simulate
  x <- eventReactive(input$runTest, {
    ## Perform simulation
    test_lqas_classifier(pop = input$populationSize,
                         n = input$sampleSize,
                         d.lower = input$dLower,
                         d.upper = input$dUpper)
  })
  ## Calculate probabilities
  y <- reactive({
    req(x())
    get_class_prob(x = x())
  })
  ##
  ##############################################################################
  ## Output
  ##############################################################################
  ## Table
  output$probClassTable <- renderTable({
    df <- data.frame(c("Low", "Moderate", "High", "Overall", "Gross misclassification"),
                     c(round(y()$probs, 4)))
    names(df) <- c("Classification", "Probability")
  })
  ## Plot
  output$probClassPlot <- renderPlot({
    req(x())
    plot(x = x())
  })
}
