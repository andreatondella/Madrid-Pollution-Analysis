## MBDO2-2
# R Group Assignment
# ===================================================

# Reading the files and creating the initial datasets

# ===================================================

#Loading libraries
source("lib_loading.R")

# ===================================================

# Creating date column

raw_data$year <- as.character(raw_data$year); raw_data$month <- as.character(raw_data$month); raw_data$day <- as.character(raw_data$day)
date_column <- data.frame(ob_date = as.Date(paste(raw_data$year, raw_data$month, raw_data$day, sep='-')))
h_data <- data.table(cbind(date_column, raw_data))
date_column <- NULL
head(h_data)
# h_data$year <- NULL
# h_data$month <- NULL
# h_data$day <- NULL

# ===================================================

# Subsetting raw_data to create a daily dataset and merge it with weather info and parameter name
daily_data <- h_data[,.(daily_avg=mean(value)), by=.(ob_date,station,parameter)]
daily_data <- merge(daily_data, weather, by.x="ob_date", by.y="date", all=FALSE)
daily_data <- merge(daily_data, parameters, by.x="parameter", by.y="param_ID", all = FALSE)

# ===================================================

# Adding some info about day of the week and holidays

daily_data[,week_day:=weekdays(ob_date)]

# Creating dummy variables for workdays, restdays & holidays
daily_data[ ,workday := daily_data$week_day %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday") ]
daily_data[ ,restday := daily_data$week_day %in% c("Saturday", "Sunday") ]
daily_data[ ,holiday := daily_data$ob_date %in% holidays$holiday]

head(daily_data)

# ===================================================
# List of unique stations/parameters
stationlist <- unique(h_data$station)
paramlist <- unique(h_data$parameter)

# Create list of data tables per station
perstationdata <- list()
length(stationlist)
for(x in stationlist) {
  perstationdata[[length(perstationdata) + 1]]  <- h_data[station == x,]
}
daily_data[, holiday :=  daily_data$ob_date %in% holidays$holiday]
daily_data$ob_date %in% holidays$holiday
# Create list of data tables per parameter
perparameterdata <- list()
length(perparameterdata)
for(x in paramlist) {
  perparameterdata[[length(perparameterdata) + 1]] <- h_data[parameter == x]
}

