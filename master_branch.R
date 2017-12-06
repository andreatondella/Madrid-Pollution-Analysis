# MBDO2-2
# R Group Assignment
# GitHub Master Branch
# ----------------------------
#whats up
# Deo: Whatsup?

# LIBRARIES -> space where to call new libraries
library(data.table)

# Read all files into one data table. The verbose way.
years <- c(11:12)
months <- c(1:12)
hours <- c(1:24)
data <- data.table(year=integer(), month=integer(), day=integer(), hour=integer(), station=integer(), parameter=integer(), value=numeric())
#data <- data.frame(day=integer(), hour=integer(), station=integer(), parameter=integer(), value=numeric())
for(i in years) {
  for(j in months) {
    df <- read.csv(paste(paste("hourly_data", as.character(i), as.character(j), sep='_'), ".csv", sep=''))
    yr <- rep(i + 2000, nrow(df))
    mnth <- rep(j, nrow(df))
    dftemp <- data.frame(year=yr, month=mnth)
    df <- cbind(dftemp, df)
    data <- rbind(data, df)
  }
}
# Apparantly there are 6,471,098 rows and 5 columns


filenames <- sapply(c(11:16), function(x) { paste(paste("hourly_data", as.character(x), as.character(1:12), sep="_"), '.csv', sep='')})
# 2011 => filenames[,1]
# 2016 => filenames[,6]
dflist <- list()
dflist <- sapply(c(1:6), function(x) {
  dfilist <- list()
  for(i in 1:12) {
    df <- read.csv(filenames[i, x])
    dflist <- c(dflist, df)
  }
  return(dflist)
  #dflist <- c(dflist, dfilist)
  })

head(dflist)

filenames[1,2]
head(df)
for(i in 1:6) {
  #print(filenames[i])
  df <- read.csv(filenames[i])
  dflist <- c(dflist, df)
}


# Reading every piece of raw data and creating the whole initial raw_data set.
#paste(as.character(c(11:16)), as.character(1:12), sep="_")


#Just some trials
df1 <- read.csv('./dataset/data/hourly_data_11_1.csv')
df2 <- read.csv('./dataset/data/hourly_data_11_2.csv')
df3 <- read.csv('./dataset/data/hourly_data_11_3.csv')

str(df1)
str(df2)
str(df3)

df12 <- rbind(df1, df2, df3)

<<<<<<< HEAD
#Yet another upload trial

=======
  >>>>>>> d6fff266c8adc5cf0d153f0bd4661f90f27270ce
#for (i in (11:16)) {
# j=1
#for (j in 1:12) {
#    anno.list <- list(read.csv(paste("./dataset/data/hourly_data_11_", j, ".csv", sep = "")))

#print(j)
#print(paste(".dataset/data/hourly_data_11_", j, ".csv", sep = ""))
#  }

#}





# Processing raw_data to create a daily dataset, by averaging each hourly measure, 
# and containing also the weather variables and the names for each pollutant parameter.



# Generating a descriptive analysis with correlation matrices,
# scatterplots, time series charts …



# Creating a linear regression model that explains NO2.