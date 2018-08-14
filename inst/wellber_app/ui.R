#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#library(repmis)
#source_data("https://github.com/jovard/project_data/blob/master/sysdata.rda?raw=True",
#            cache = FALSE)

library(shiny)

ctry_list <- c("Australia","Austria","Belgium","Canada","Czech Republic",
               "Denmark","Finland","France","Germany","Greece","Hungary",
               "Iceland","Ireland","Italy","Japan","Korea","Luxembourg",
               "Mexico","Netherlands","New Zealand","Norway","Poland",
               "Portugal","Slovak Republic","Spain","Sweden","Switzerland",
               "Turkey","United Kingdom","United States","Brazil","Chile",
               "Estonia","Israel","Latvia","Russia","Slovenia","South Africa")

indic_list <- c("Air pollution","Dwellings without basic facilities",
                "Educational attainment","Employees working very long hours",
                "Employment rate","Feeling safe walking alone at night",
                "Homicide rate","Household net adjusted disposable income",
                "Household net financial wealth","Housing expenditure",
                "Labour market insecurity","Life expectancy","Life satisfaction",
                "Long-term unemployment rate","Personal earnings",
                "Quality of support network","Rooms per person",
                "Self-reported health",
                "Stakeholder engagement for developing regulations","Student skills",
                "Time devoted to leisure and personal care","Voter turnout",
                "Water quality","Years in education")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Country Well-Being Comparison"),

  # Sidebar with drop-downs and radio buttons for selection
  sidebarLayout(
    sidebarPanel(
      selectInput("ctry", "OECD Country:",
                  choices=ctry_list),

      selectInput("indic", "Well-Being Indicator:",
                  choices=indic_list),

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
