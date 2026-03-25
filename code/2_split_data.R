# ------------------------------------------------------------------------------
#
# This R script splits data into training and test datasets
#
# Sara Kim
# March 24, 2026
# 
# ------------------------------------------------------------------------------

# -- Establish working directory
here::i_am("code/2_split_data.R")

# -- Load packages
pacman::p_load(dplyr, tidyr, lubridate, ggplot2, zoo, gt)

# -- Load cleaned data
data_full <- readRDS(here::here("data/noro_for_data550_clean.rds"))

# -- Define a split time 
split_date <- as.Date("2024-03-01") 

# -- Define training dataset 
train_data <- data_full %>%
  filter(date <= split_date)

saveRDS(train_data, file = here::here("data/train_data.rds"))

# -- Define test dataset
test_data <- data_full %>%
  filter(date > split_date)

saveRDS(test_data, file = here::here("data/test_data.rds"))



