## MBDO2-2
# R Group Assignment
# ===================================================

# Transforming the datasets

# ===================================================

#Loading libraries
source("lib_loading.R")
start <- Sys.time()
# ===================================================


# raw_data$year <- as.character(raw_data$year); raw_data$month <- as.character(raw_data$month); raw_data$day <- as.character(raw_data$day)
# date_column <- data.frame(ob_date = as.Date(paste(raw_data$year, raw_data$month, raw_data$day, sep='-')))
# h_data <- data.table(cbind(date_column, raw_data))
# date_column <- NULL
# head(h_data)

h_data <- raw_data[ ,ob_date := as.Date(paste0(year,"-",month,"-",day))]
h_data <- merge(h_data, parameters, by.x="parameter", by.y="param_ID", all = FALSE)
h_data <- merge(h_data, stations, by.x="station", by.y="station_ID", all=FALSE)
head(h_data)

# h_data$year <- NULL
# h_data$month <- NULL
# h_data$day <- NULL

# ===================================================

# Subsetting raw_data to create a daily dataset and merge it with weather, parameters & station info
daily_data <- h_data[,.(daily_avg=mean(value)), by=.(ob_date,station,parameter)]
daily_data <- merge(daily_data, weather, by.x="ob_date", by.y="date", all=FALSE)
daily_data <- merge(daily_data, parameters, by.x="parameter", by.y="param_ID", all = FALSE)
daily_data <- merge(daily_data, stations, by.x="station", by.y="station_ID", all=FALSE)
head(daily_data)
# ===================================================

# Adding some info about day of the week and holidays
daily_data[,week_day:=weekdays(ob_date)]

# Creating dummy variables for workdays, restdays & holidays
# daily_data[ ,workday := daily_data$week_day %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")]
daily_data[ ,restday := ((daily_data$week_day %in% c("Saturday", "Sunday")) | (daily_data$ob_date %in% holidays$holiday)) ]
daily_data[ ,workday := !(daily_data$restday)]
head(daily_data)

# ===================================================

# Expand the parameter column in many columns one for each parameter
daily_data_pp <- daily_data
daily_data_pp <- daily_data_pp[ ,c("param_Name", "param_unit", "parameter") := NULL]
daily_data_pp <- data.table(tidyr::spread(daily_data_pp, param_Form, daily_avg))
str(daily_data_pp)

# Expand the stations column in many columns one for each station
# daily_data_ps <- daily_data
# daily_data_ps <- daily_data_ps[ ,c("station", "station_loc", "Lat", "Lng") := NULL]
# daily_data_ps <- data.table(tidyr::spread(daily_data_ps, station_Name, daily_avg))
# str(daily_data_pp)
# # ===================================================

# Subsetting daily_data_pp keeping only rows without NAs
daily_data_pp_cc <- daily_data_pp[complete.cases(daily_data_pp), ]

# # List of unique stations/parameters
# 
# stationlist <- unique(h_data$station)
# paramlist <- unique(h_data$parameter)
# 
# # Create list of data tables per station
# perstationdata <- list()
# length(stationlist)
# for(x in stationlist) {
#   perstationdata[[length(perstationdata) + 1]]  <- h_data[station == x,]
# }
# daily_data[, holiday :=  daily_data$ob_date %in% holidays$holiday]
# daily_data$ob_date %in% holidays$holiday
# # Create list of data tables per parameter
# perparameterdata <- list()
# length(perparameterdata)
# for(x in paramlist) {
#   perparameterdata[[length(perparameterdata) + 1]] <- h_data[parameter == x]
# }

stop <- Sys.time()
print(stop-start)

