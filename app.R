################################################################################
# Running app
#
# Author: Lathan Liou
# Created: # Tue Aug 11 15:26:37 2020 ------------------------------
################################################################################

library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinyjs)
library(flexdashboard)
library(rsconnect)
library(RSQLite)
library(DBI)
source("ui.R")
source("server.R")
source("src/fit_model.R")
fit <- readRDS("model.RDS")

enableBookmarking("url")
shinyApp(ui, server)
