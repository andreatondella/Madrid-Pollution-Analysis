# MBDO2-2
# R Group Assignment
# GitHub Master Branch
# ----------------------------
#Check dygraphs

# LIBRARIES -> space where to call new libraries

# Reading every piece of raw data and creating the whole initial raw_data set.
library(data.table)
library(openair)
library(readxl)

# ===================================================
weather <- data.table(read_excel("weather.xlsx"))
weather$date <- as.Date(weather$date)
# ===================================================
years <- c(11:12); months <- c(1:12)
filenameprefix <- "hourly_data"
data <- data.table(year=integer(), month=integer(), day=character(), hour=integer(),
                   station=integer(), parameter=integer(), value=numeric())

sapply(years, function(x) { sapply(months, function(y) {
  filename <- paste(paste(filenameprefix, as.character(x), as.character(y), sep="_"), '.csv', sep='')
  df <- read.csv(filename)
  yr <- rep(x+2000, nrow(df)); mnth <- rep(y, nrow(df)); dftemp <- data.frame(year=yr, month=mnth)
  df <- cbind(dftemp, df); data <<- rbind(data, df)
}) })
data[is.na(value), 'value'] <- 0
# ===================================================
data$year <- as.character(data$year); data$month <- as.character(data$month); data$day <- as.character(data$day)
dateddf <- data.frame(dated = as.Date(paste(data$year, data$month, data$day, sep='-')))
data <- cbind(dateddf, data)
dateddf <- NULL
head(data)
data$year <- NULL
data$month <- NULL
data$day <- NULL
# ===================================================
# List of unique stations/parameters
stationlist <- unique(data$station)
paramlist <- unique(data$parameter)
# ===================================================
# Parameter per station
for(x in stationlist) {
  print(x)
  print(data[station == x, unique(parameter)])
}

# Create list of data tables per station
perstationdata <- list()
length(stationlist)
for(x in stationlist) {
  perstationdata[[length(perstationdata) + 1]]  <- data[station == x,]
}

# Create list of data tables per parameter
perparameterdata <- list()
length(perparameterdata)
for(x in paramlist) {
  perparameterdata[[length(perparameterdata) + 1]] <- data[parameter == x]
}



# TODO: Processing raw_data to create a daily dataset, by averaging each hourly measure, 
# and containing also the weather variables and the names for each pollutant parameter.

# Reading weather data
weather <- data.table(read_excel("weather.xlsx"))

# Subsetting raw_data to create a daily dataset
daily_data <- data[,.(daily_avg=mean(value)), by=.(year,month,day,station,parameter)]

# Create a column with format yyyy-mm-aa for daily_data

# TODO: Generating a descriptive analysis with correlation matrices,
# scatterplots, time series charts …

# Read csv with long/lat info on station
stations <- read.csv("stations.csv")

# Read csv with parameters info
parameters <- read.csv("parameters.csv")

# TODO: Creating a linear regression model that explains NO2.










# >>======================================>>
# This code merges weather info with main data. Takes too long. Better avoided.
mergeddata <- data.table(dated=as.character(),
                         year=integer(), month=integer(), day=character(),
                         hour=integer(), station=integer(), parameter=integer(), value=numeric(),
                         temp_avg=numeric(), temp_max=numeric(), temp_min=numeric(),
                         precipitation=numeric(), humidity=numeric(), wind_avg_speed=numeric())
mergeddata$dated <- as.Date(mergeddata$dated)
sapply(1:nrow(data), function(x) {
  weatherrow <- weather[weather$date == data[x, 'dated'], -c('date')]
  dft <- cbind(data[x,], weatherrow)
  mergeddata <<- rbind(mergeddata, dft)
})
head(mergeddata)
tail(mergeddata)
# <<======================================<<