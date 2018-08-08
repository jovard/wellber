#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(repmis)

source_data("https://github.com/jovard/project_data/blob/master/sysdata.rda?raw=True",
            cache = FALSE)

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Country Well-Being Comparison"),

  # Sidebar with drop-downs and radio buttons for selection
  sidebarLayout(
    sidebarPanel(
      selectInput("ctry", "OECD Country:",
                  choices=levels(raw_data$Country)),

      selectInput("indic", "Well-Being Indicator:",
                  choices=levels(raw_data$Indicator)),

      radioButtons("subj", "Subject Type:",
                   c("Male & Female" = "Total",
                     "Male" = "Men",
                     "Female" = "Women")),

      radioButtons("size", "Window Size:",
                   c("Small" = "small",
                     "Medium" = "medium",
                     "Large" = "large")),

      checkboxInput(inputId = "hl_category",
                    label = strong("Display High-Level Indicator"),
                    value = FALSE),

      helpText("Data is taken from the OECD's 2017 Well-Being data.")
    ),

    # Show a plot of the generated bar chart
    mainPanel(
       plotOutput("wellPlot")
    )
  )
))
