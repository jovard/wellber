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
      grid.arrange(plot(subset,ind_class=0), plot(subset,ind_class=1), ncol = 2)
    }
    else {
      # Plot the indictaed dataset
      plot(subset,ind_class=0)
    }
  })
})
