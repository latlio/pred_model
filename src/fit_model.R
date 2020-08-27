################################################################################
# Create data model for the Shiny app to consume. 
#
# The model weights are for the following covariates
# 
# - prs_z <integer>             -> standardized PRS  
# - DiagnosisAge <integer>      -> age at diagnosis
# - HormoneTherapy <integer>    -> binary for received/not received anti-hormone therapy
# - log(BMI) <integer>          -> 
# - smokingEver <factor>        -> never/past/current smoker
# - AlcNow <integer>            -> binary for past/current drinker
# - log(IMD) <integer>          -> index of multiple deprivation
# 
# Note: for future development, ideally user would enter zipcode, and zipcode would
# be matched to IMD

# Author: Lathan Liou
# Created: Wed Aug  5 15:41:52 2020 ------------------------------
################################################################################

library(tidyverse)
library(survival)
library(logging)

#path to data
SEARCH_PATH <- "src/final_thesis_data.csv"
loginfo("Loading data from '%s'", SEARCH_PATH)

data <- read_csv(SEARCH_PATH)

fit <- coxph(Surv(YearsToEntry,
                  YearsToI2125,
                  completeI2125) ~ prs_z + HormoneTherapy +
               log(BMI) + as.factor(smokingEver) + AlcNow + DiagnosisAge + log(IMD),
             data)

saveRDS(fit, "model.RDS")

coefs <- fit %>%
  broom::tidy() %>%
  select(term, estimate)



