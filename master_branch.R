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

# Reading every piece of raw data and creating the whole initial raw_data set.


# Read all files into one data table. The verbose way.
#years <- c(11:12)
#months <- c(1:12)
#hours <- c(1:24)
#data <- data.table(year=integer(), month=integer(), day=integer(), hour=integer(), station=integer(), parameter=integer(), value=numeric())
#data <- data.frame(day=integer(), hour=integer(), station=integer(), parameter=integer(), value=numeric())
#for(i in years) {
#  for(j in months) {
#    df <- read.csv(paste(paste("hourly_data", as.character(i), as.character(j), sep='_'), ".csv", sep=''))
#    yr <- rep(i + 2000, nrow(df))
#    mnth <- rep(j, nrow(df))
#    dftemp <- data.frame(year=yr, month=mnth)
#    df <- cbind(dftemp, df)
#    data <- rbind(data, df)
#  }
#}
# Apparantly there are 6,471,098 rows and 5 columns

# Read all files into one data table. Using sapply.
data <- data.table(year=integer(), month=integer(), day=integer(), hour=integer(), station=integer(), parameter=integer(), value=numeric())
years <- c(11:12)
months <- c(1:12)
filenameprefix <- "hourly_data"

sapply(years, function(x) {
  sapply(months, function(y) {
    filename <- paste(paste(filenameprefix, as.character(x), as.character(y), sep="_"), '.csv', sep='')
    df <- read.csv(filename)
    yr <- rep(x+2000, nrow(df))
    mnth <- rep(y, nrow(df))
    dftemp <- data.frame(year=yr, month=mnth)
    df <- cbind(dftemp, df)
    data <<- rbind(data, df)
  })
})
head(data)
tail(data)
data[is.na(value), 'value'] <- 0

# List of unique stations
stationlist <- unique(data$station)
# List of unique parameters
paramlist <- unique(data$parameter)
# Print unique parameter recorded per station
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
