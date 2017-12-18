# MBDO2-2
# R Group Assignment
# ===================================================

# Building regression models on data subsets

# ===================================================

#Loading libraries
source("lib_loading.R")

# ===================================================

# All models are for NO2
# ===================================================
# First run a regression model with all variables
# ===================================================
rmodel <- lm(NO2~., data=daily_data_pp)
summary(rmodel)
confint(rmodel,parm = 'temp_avg', level = 0.95)
confint(rmodel,parm = 'temp_max', level = 0.95)
confint(rmodel,parm = 'temp_min', level = 0.95)
confint(rmodel,parm = 'precipitation', level = 0.95)
confint(rmodel,parm = 'humidity', level = 0.95)
confint(rmodel,parm = 'wind_avg_speed', level = 0.95)
confint(rmodel,parm = 'week_dayMonday', level = 0.95)
confint(rmodel,parm = 'week_daySaturday', level = 0.95)
confint(rmodel,parm = 'restdayTRUE', level = 0.95)
confint(rmodel,parm = 'CO', level = 0.95)
confint(rmodel,parm = 'NO', level = 0.95)
confint(rmodel,parm = 'O3', level = 0.95)
confint(rmodel,parm = 'PM2.5', level = 0.95)
confint(rmodel,parm = 'SO2', level = 0.95)
confint(rmodel,parm = 'TCH', level = 0.95)
confint(rmodel,parm = 'TOL', level = 0.95)
corrplot( cor(daily_data_pp[,c('temp_avg', 'temp_max',
                               'precipitation', 'humidity', 'wind_avg_speed',
                               # 'week_day', 'week_day', 'restday',
                               'CO', 'NO', 'O3', 'PM2.5', 'SO2', 'TCH', 'TOL')]),
          method = 'number', tl.col = 'black', type = 'lower',
          number.cex = 0.5, order='hclust')

summary(rmodel$residuals)
plot(rmodel$residuals)
hist(rmodel$residuals)
qqnorm(rmodel$residuals); grid()
boxplot(rmodel$residuals,main='boxplot'); grid()

# ===================================================
# Build regression model on weather parameters.
# ===================================================

# Try not to pass a list of more than 4 data tables to this function.
#   Reason : It plots 4 graphs for each data table. The plot space will be too cluttered to read.
check_weather_model <- function(data_table_list) {
  par(mfrow=c(length(data_table_list),4))
  lapply(data_table_list, function(x) {
    linear_model <- lm(NO2~temp_avg + wind_avg_speed + precipitation, data = x)
    print(summary(linear_model))
    print(confint(linear_model, 'temp_avg', level = 0.95))
    print(confint(linear_model, 'wind_avg_speed', level = 0.95))
    print(confint(linear_model, 'precipitation', level = 0.95))
    
    print(paste('MAD = ', mean(abs(linear_model$residuals)), sep = ''))
    print('Residuals summary')
    print(summary(linear_model$residuals))
    
    plot(linear_model$residuals)
    hist(linear_model$residuals)
    qqnorm(linear_model$residuals); grid()
    boxplot(linear_model$residuals,main='boxplot'); grid()
  })
}
dev.off()

summer_months <- c(4:9)
summer_workdays <- daily_data_pp[(month(ob_date) %in% summer_months) & (workday == T) & !is.na(NO2)]
summer_restdays <- daily_data_pp[(month(ob_date) %in% summer_months) & (workday == F) & !is.na(NO2)]
winter_workdays <- daily_data_pp[!(month(ob_date) %in% summer_months) & (workday == T) & !is.na(NO2)]
winter_restdays <- daily_data_pp[!(month(ob_date) %in% summer_months) & (workday == F) & !is.na(NO2)]


list_of_data_tables <- list(summer_workdays, summer_restdays, winter_workdays, winter_restdays)
length(list_of_data_tables)
check_weather_model(list_of_data_tables)
