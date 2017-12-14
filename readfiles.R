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

raw_data$year <- as.character(raw_data$year); raw_data$month <- as.character(raw_data$month); raw_data$day <- as.character(raw_data$day)
date_column <- data.frame(ob_date = as.Date(paste(raw_data$year, raw_data$month, raw_data$day, sep='-')))
h_data <- data.table(cbind(date_column, raw_data))
date_column <- NULL
head(h_data)
h_data$year <- NULL
h_data$month <- NULL
h_data$day <- NULL

# ===================================================

# Subsetting raw_data to create a daily dataset and merge it with weather info and parameter name
daily_data <- h_data[,.(daily_avg=mean(value)), by=.(ob_date,station,parameter)]

daily_data_merged <- merge(daily_data, weather, by.x="ob_date", by.y="date", all=FALSE)



# ===================================================

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