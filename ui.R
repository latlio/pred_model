################################################################################
# UI of the Shiny app
#
# Author: Lathan Liou
# Created: Wed Aug  5 15:35:47 2020 ------------------------------
################################################################################

makereactivetrigger <- function() {
  #programmed action button 
  rv <- reactiveValues(a = 0)
  list(
    depend = function() {
      rv$a
      invisible()
    },
    trigger = function() {
      rv$a <- isolate(rv$a + 1)
    }
  )
}
dbtrigger <- makereactivetrigger()

con <- dbConnect(RSQLite::SQLite(), ":memory:")
dbExecute(con, 'CREATE TABLE mytable (prs int,
          horm varchar(10), 
          bmi int, 
          smoking varchar(10), 
          drinking varchar(10), 
          age int, 
          imd int);')

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
hoverIcon <- function(title) {
  quo(
  tags$style(
    class = "fa fa-info-circle", 
    `data-toggle` = "tooltip",
    `data-placement` = "right",
    `title` = title
  )
  )
}

sidebar <- dashboardSidebar(
  sidebarMenu(
    convertMenuItem(menuItem("Predict!", tabName = "model", icon = icon("bar-chart-o"),
                             sliderInput("prs",
                                        list(icon = rlang::eval_tidy(
                                          hoverIcon("Standardized coronary artery disease polygenic risk score.")
                                        ),
                                        "Standardized PRS"),
                                         value = 0,
                                         min = -4,
                                         max = 4
                                         ),
                             selectInput("hormone",
                                         list(icon = rlang::eval_tidy(
                                           hoverIcon("Have you received tamoxifen in the past?")
                                         ),
                                         "Received anti-hormone therapy?"),
                                         c("No", "Yes")),
                             textInput("bmi",
                                       "BMI"),
                             selectInput("smoking",
                                         "Smoking status",
                                         c("Never", "Past", "Current")),
                             selectInput("alc",
                                         "Currently drinking?",
                                         c("No", "Yes")),
                             textInput("age",
                                       list(icon = rlang::eval_tidy(
                                         hoverIcon("The age when you received your first breast cancer diagnosis.")
                                       ),
                                       "Age at diagnosis")),
                             sliderInput("imd",
                                         list(icon = rlang::eval_tidy(
                                           hoverIcon("What is your zipcode?")
                                         ),
                                         "IMD Score"),
                                         value = 1,
                                         min = 1,
                                         max = 15),
                             div(style="display: inline-block;vertical-align:top; width: 100px;",
                                 actionButton("go", "Predict!")),
                             div(style="display: inline-block;vertical-align:top; width: 100px;",
                                 actionButton("reset", "Clear", style='padding:6px;width:80px'))
    )),
    menuItem("Source Code", icon = icon("file-code-o"),
             href = "https://github.com/latlio/pred_model")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "model",
            h2("Your predicted risk is: "),
            h3(verbatimTextOutput("pred", placeholder = T) %>% 
                 shinycssloaders::withSpinner()),
            tags$head(tags$style("#pred{color: black;
                                 font-size: 20px;
                                 font-family: Source Sans Pro
                                 }"
            )
            ),
            flexdashboard::gaugeOutput("gauge"))),
    box(title = "Input History",
        width = 12,
        column(
          tableOutput('dbtable'), align = "center", width = 12)
      ),
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

ui <- dashboardPage(header, 
                    sidebar, 
                    body, 
                    useShinyjs()
                    )



