#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

library(wellber)
library(gridExtra)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$wellPlot <- renderPlot({

    # Generate subset of dataset based on widget inputs from ui.R
    dat <- load.wellber()
    subset <- selector(dat, input$ctry, input$indic, input$subj, input$size)

    if (input$hl_category) {
      # Plot the indictaed and group indicated dataset side-by-side
      grid.arrange(plot(subset,1), plot(subset,2), ncol = 2)
    }
    else {
      # Plot the indictaed dataset
      plot(subset,1)
    }
  })
})
