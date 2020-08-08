################################################################################
# UI of the Shiny app
#
# Author: Lathan Liou
# Created: Wed Aug  5 15:35:47 2020 ------------------------------
################################################################################

library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Demo Predictor",
                          tags$li(a(href = 'https://www.phpc.cam.ac.uk/ceu/',
                                    img(src = 'www/cambridge-logo.png',
                                        height = "10px"),
                                    style = "padding-top:10px; padding-bottom:10px;"),
                                  class = "dropdown"))

#HTML styling
convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle'] = "tab"
  mi$children[[1]]$attribs['data-value'] = "tabName"
  mi
}
buttonInputRow <- function (inputId, label) 
{
  div(style="display:inline-block",
      tags$label(label, `for` = inputId), 
      tags$input(id = inputId, type = "button",
                 class = "btn btn-default action-button"))
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
                                         max = 15),
                             actionButton("go", "Predict!"),
                             actionButton("reset", "Clear")
    )),
    menuItem("Source Code", icon = icon("file-code-o"),
             href = "https://github.com/latlio/pred_model")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "model",
            h2("Your predicted risk is: "),
            box(verbatimTextOutput("pred", placeholder = T)),
            br(),
            br(),
            br(),
            br(),
            br(),
            br(),
            br(),
            br(),
            br(),
            br(),
            fluidRow(infoBox(
              "What", "is this model for?", icon = icon("line-chart"),
              width = 4
            ),
            infoBox(
              "Who", "is this model for?", icon = icon("user-friends"),
              width = 4
            ),
            infoBox(
              "Where", "can I find out more?", icon = icon("book-open"),
              width = 4
            )),
            fluidRow(
              column(align = "center",
                     "This model asks for some details from the patient. It then uses data about the survival of similar women in the past to show the risk of coronary artery disease.",
                     width = 4
              ),
              column(
                align = "center",
                "This model is for clinicians, patients, and their families.",
                width = 4
              ),
              column(
                align = "center",
                "To read more visit:",
                width = 4
              ))
    )
  )
)
ui <- dashboardPage(header, sidebar, body)
