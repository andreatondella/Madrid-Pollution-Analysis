# MBDO2-2
# R Group Assignment
# ===================================================

# Building regression models on data subsets

# ===================================================

#Loading libraries
source("lib_loading.R")

# ===================================================

# Subset for NO2 temp_avg above 10 degree C
daily_data_no2_10c <- daily_data_pp[temp_avg > 9 & !is.na(daily_data_pp$NO2),]
# Subset for NO2 temp_avg below 9 degree C
daily_data_no2_10c <- daily_data_pp[temp_avg < 10 & !is.na(daily_data_pp$NO2),]
no2_month_temp <- lm()

