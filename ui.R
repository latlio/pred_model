################################################################################
# UI of the Shiny app
#
# Author: Lathan Liou
# Created: Wed Aug  5 15:35:47 2020 ------------------------------
################################################################################

library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Demo Predictor")

convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle'] = "tab"
  mi$children[[1]]$attribs['data-value'] = "tabName"
  mi
}

sidebar <- dashboardSidebar(
  sidebarMenu(
    convertMenuItem(menuItem("Predict!", tabName = "model", icon = icon("bar-chart-o"),
             sliderInput("prs",
                         "Standardized PRS", 
                         value = 0,
                         min = -4,
                         max = 4),
             selectInput("hormone",
                         "Received hormone therapy?",
                         c("No", "Yes")),
             textInput("bmi",
                       "BMI"),
             selectInput("smoking",
                         "Smoking status",
                         c("Never", "Past", "Current")),
             selectInput("alc",
                         "Currently drinking",
                         c("No", "Yes")),
             textInput("age",
                       "Age at diagnosis"),
             sliderInput("imd",
                         "IMD Score",
                         value = 1,
                         min = 1,
                         max = 15)
             )),
    menuItem("Source Code", icon = icon("file-code-o"),
             href = "https://github.com/latlio/pred_model")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "model",
            h2("Your predicted risk is: "),
            box(verbatimTextOutput("pred"))
    )
  )
)

ui <- dashboardPage(header, sidebar, body)
