# MBDO2-2
# R Group Assignment
# ===================================================

# Reading the files and creating the initial datasets

# ===================================================

#Loading libraries
source("lib_loading.R")

# ===================================================

#Reading weather data and converting date column to date format
weather <- data.table(read_excel("weather.xlsx"))
weather$date <- as.Date(weather$date)

# ===================================================

#Reading pollution data and creating the hourly dataset
years <- c(11:12); months <- c(1:12)
filenameprefix <- "hourly_data"
raw_data <- data.table(year=integer(), month=integer(), day=character(), hour=integer(),station=integer(), parameter=integer(), value=numeric())

sapply(years, function(x) { sapply(months, function(y) {
  filename <- paste(paste(filenameprefix, as.character(x), as.character(y), sep="_"), '.csv', sep='')
  df <- read.csv(filename)
  yr <- rep(x+2000, nrow(df)); mnth <- rep(y, nrow(df)); dftemp <- data.frame(year=yr, month=mnth)
  df <- cbind(dftemp, df); raw_data <<- rbind(raw_data, df)
}) })

raw_data[is.na(value), 'value'] <- 0

head(raw_data)
tail(raw_data)

# ===================================================

# Creating date column

# The data table way
# Still needs some improvements
intermediate <<- raw_data[,date:=paste0(year,"-",month,"-",day)]

h_data <<- intermediate[,c("year","month","day"):=NULL]

head(h_data)
tail(h_data)

#ALTERNATIVE WAY:
# h_data$year <- as.character(h_data$year); h_data$month <- as.character(h_data$month); h_data$day <- as.character(h_data$day)
# dateddf <- h_data.frame(dated = as.Date(paste(h_data$year, h_data$month, h_data$day, sep='-')))
# h_data <- cbind(dateddf, h_data)
# dateddf <- NULL
# head(h_data)
# h_data$year <- NULL
# h_data$month <- NULL
# h_data$day <- NULL

# ===================================================

# Subsetting raw_data to create a daily dataset and merge it with weather info and parameter name
<<<<<<< HEAD

daily_data <- h_data[,.(daily_avg=mean(value)), by=.(ob_date,station,parameter)]

daily_data <- merge(daily_data, weather, by.x="ob_date", by.y="date", all=FALSE)
=======
daily_data <- h_data[,.(daily_avg=mean(value)), by=.(date,station,parameter)]

daily_data <- merge(daily_data, weather, by.daily_data=)
>>>>>>> e06459b79e902af0ed4625e66d765a809bed73f4

daily_data <- merge(daily_data, parameters, by.x="parameter", by.y="param_ID", all = FALSE)


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

# Create list of data tables per parameter
perparameterdata <- list()
length(perparameterdata)
for(x in paramlist) {
  perparameterdata[[length(perparameterdata) + 1]] <- h_data[parameter == x]
}




<<<<<<< HEAD
# # >>======================================>>
# # This code merges weather info with main data. Takes too long. Better avoided.
# mergeddata <- data.table(dated=as.character(),
#                          year=integer(), month=integer(), day=character(),
#                          hour=integer(), station=integer(), parameter=integer(), value=numeric(),
#                          temp_avg=numeric(), temp_max=numeric(), temp_min=numeric(),
#                          precipitation=numeric(), humidity=numeric(), wind_avg_speed=numeric())
# mergeddata$dated <- as.Date(mergeddata$dated)
# sapply(1:nrow(h_data), function(x) {
#   weatherrow <- weather[weather$date == h_data[x, 'dated'], -c('date')]
#   dft <- cbind(h_data[x,], weatherrow)
#   mergeddata <<- rbind(mergeddata, dft)
# })
# head(mergeddata)
# tail(mergeddata)
# # <<======================================<<
=======
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
sapply(1:nrow(h_data), function(x) {
  weatherrow <- weather[weather$date == h_data[x, 'dated'], -c('date')]
  dft <- cbind(h_data[x,], weatherrow)
  mergeddata <<- rbind(mergeddata, dft)
})
head(mergeddata)
tail(mergeddata)
# <<======================================<<
>>>>>>> e06459b79e902af0ed4625e66d765a809bed73f4
