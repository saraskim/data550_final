# ------------------------------------------------------------------------------
#
# This R script:
#.    Defines three models
#     Trains data on them
#     Predicts norovirus cases on test dataset
#
# Sara Kim
# March 24, 2026
# 
# ------------------------------------------------------------------------------

# -- Establish working directory
here::i_am("code/3_analysis.R")

# -- Load packages
pacman::p_load(dplyr, tidyr, lubridate, ggplot2, zoo, gt)

# -- Load train dataset
train_data <- readRDS(here::here("data/train_data.rds"))

# -- Load test datasets
test_data <- readRDS(here::here("data/test_data.rds"))

# -- Define variables
cases_lag_vars <- paste0("cases_lagged_", 7:13)
wwscan_lag_vars <- paste0("wwscan_lagged_", 7:13)




# -- Model 1 - uses only case data

# Define model and train on train_data
formula1 <- as.formula(paste("ave_cases ~", paste(c(cases_lag_vars, "sin_doy", "cos_doy"), collapse = " + "))) 
model1 <- glm(formula1,
              data = train_data,
              family = poisson)

# Predict on test_data
test_data$model1_prediction <- predict(model1, newdata = test_data, type="response")



# -- Model 2 - uses only case data

# Define model and train on train_data
formula2 <- as.formula(paste("ave_cases ~", paste(c(wwscan_lag_vars, "sin_doy", "cos_doy"), collapse = " + "))) 
model2 <- glm(formula2,
              data = train_data,
              family = poisson)

# Predict on test_data
test_data$model2_prediction <- predict(model2, newdata = test_data, type="response")



# -- Model 3 - uses only case data

# Define model and train on train_data
formula3 <- as.formula(paste("ave_cases ~", paste(c(cases_lag_vars, wwscan_lag_vars, "sin_doy", "cos_doy"), collapse = " + "))) 
model3 <- glm(formula3,
              data = train_data,
              family = poisson)

# Predict on test_data
test_data$model3_prediction <- predict(model3, newdata = test_data, type="response")



# save dataset
saveRDS(test_data, file = here::here("data/test_data_with_predictions.rds"))
