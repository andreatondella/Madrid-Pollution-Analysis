# MBDO2-2
# R Group Assignment
# GitHub Master Branch
# ----------------------------
  
# LIBRARIES -> space where to call new libraries
library(data.table)
  
# Reading every piece of raw data and creating the whole initial raw_data set.
  

#Just some trials
df1 <- read.csv('./dataset/data/hourly_data_11_1.csv')
df2 <- read.csv('./dataset/data/hourly_data_11_2.csv')
df3 <- read.csv('./dataset/data/hourly_data_11_3.csv')

str(df1)
str(df2)
str(df3)

df12 <- rbind(df1, df2, df3)

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


  