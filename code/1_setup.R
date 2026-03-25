# ------------------------------------------------------------------------------
#
# R script prepares for analysis
#      Loads necessary pacakges
#      Loads and cleans data necessary for analysis
#
# Sara Kim
# March 24, 2026
# 
# ------------------------------------------------------------------------------

# -- Establish working directory
here::i_am("code/1_setup.R")

# -- Load packages
pacman::p_load(dplyr, tidyr, lubridate, ggplot2, zoo, gt)



# -- Load data
data <- read.csv(here::here("data/noro_for_data550.csv")) %>%
  select(-X)

# -- Light data cleaning
data2 <- data %>%
  mutate(ave_cases = round(rollmean(marketscan_cases, k = 7, fill = NA, align = "right"), 0),
         noro_wastewater_scaled = Noro_G2_norm_PMMoV_trimmed5 * 200, 
         month = month(date),
         season = if_else(month %in% c(10, 11, 12, 1, 2, 3, 4),
                          "In Season (Oct–Apr)",
                          "Out of Season (May–Sep)"),
         date = as.Date(date),
         doy = yday(date),
         sin_doy = sin(2 * pi * doy / 365),
         cos_doy = cos(2 * pi * doy / 365)) %>%
  filter(!is.na(ave_cases))

# -- Create 14 day lags 
T_lag <- 14
data3 <- data2

# get case lags
for (i in 1:T_lag) {
  data3[, paste0("cases_lagged_", i)] <- lag(data3$ave_cases, i)
}

# get wastewater lags
for (i in 1:T_lag) {
  data3[, paste0("wwscan_lagged_", i)] <- lag(data3$noro_wastewater_scaled, i)
}


# filter out days without complete case counts after lag
data4 <- data3 %>%
  filter(!is.na(cases_lagged_14))

# -- Save data 
saveRDS(data4, file = here::here("data/noro_for_data550_clean.rds"))
