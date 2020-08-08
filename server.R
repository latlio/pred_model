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
fit <- readRDS("model.RDS")

server <- function(input, output, session) {
  
  text_to_display <- reactiveVal("Complete all fields!")
  
  observeEvent(input$reset, {
    updateSliderInput(session, 'prs', value = 0)
    updateSelectInput(session, 'hormone')
    updateTextInput(session, 'bmi', value = "")
    updateSelectInput(session, 'smoking')
    updateSelectInput(session, 'alc')
    updateTextInput(session, 'age', value = "")
    updateSliderInput(session, 'imd', value = 1)
  })
               
  pred <- eventReactive(input$go, {
    # req(input$bmi,
    #     input$age,
    #     cancelOutput = T)
    validate(
      need(input$bmi, "Input a BMI!"),
      need(input$age, "Input an age!"),
      need(str_detect(input$bmi, "[a-zA-Z]*"), "Input a number for BMI!"),
      need(str_detect(input$age, "[a-zA-Z]*"), "Input a number for age!")
    )
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
  })
  output$pred <- renderText(ifelse(is.na(pred()), 
                                   print("Make sure age and BMI are numbers."), 
                                   pred()))
}

enableBookmarking("url")
shinyApp(ui, server)
