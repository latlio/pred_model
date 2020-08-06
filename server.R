################################################################################
# Server logic of the Shiny app
#
# Author: Lathan Liou
# Created: Wed Aug 5 15:14:42 2020 ------------------------------
################################################################################

library(shiny)
library(shinydashboard)
source("ui.R")
source("src/fit_model.R")

server <- function(input, output) {
  
  output$pred <- renderPrint({
    req(input$bmi,
        input$age,
        cancelOutput = T)
    newdata <- tibble(prs_z = input$prs,
                      HormoneTherapy = input$hormone,
                      BMI = input$bmi,
                      smokingEver = input$smoking,
                      AlcNow = input$alc,
                      DiagnosisAge = input$age,
                      IMD = input$imd) %>%
      mutate(HormoneTherapy = case_when(
        HormoneTherapy == "No" ~ 0,
        HormoneTherapy == "Yes" ~ 1
      ),
      smokingEver = case_when(
        smokingEver == "Never" ~ 0,
        smokingEver == "Past" ~ 1,
        smokingEver == "Current" ~ 2
      ),
      AlcNow = case_when(
        AlcNow == "No" ~ 0,
        AlcNow == "Yes" ~ 1
      )) %>%
      mutate_all(as.numeric)
    pred <- predict(fit, newdata = newdata, type = "risk")
    pred[[1]]
  })
  
}

shinyApp(ui, server)
