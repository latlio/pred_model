################################################################################
# Server logic of the Shiny app
#
# Author: Lathan Liou
# Created: Wed Aug 5 15:14:42 2020 ------------------------------
################################################################################

library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output) { }

shinyApp(ui, server)
