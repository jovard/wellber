library(shiny)

# Create lists to use for input drop-down menus
ctry_list <- c("Australia","Austria","Belgium","Brazil","Canada","Chile","Czech Republic",
               "Denmark","Estonia","Finland","France","Germany","Greece","Hungary",
               "Iceland","Ireland","Israel","Italy","Japan","Korea","Latvia","Luxembourg",
               "Mexico","Netherlands","New Zealand","Norway","Poland","Portugal","Russia",
               "Slovak Republic","Slovenia","South Africa","Spain","Sweden","Switzerland",
               "Turkey","United Kingdom","United States")

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

# Define UI for wellber app
shinyUI(fluidPage(

  # Application title
  titlePanel("Well-Being Comparison Tool"),

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
                   c("Small" = "Small",
                     "Medium" = "Medium",
                     "Large" = "Large")),

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
