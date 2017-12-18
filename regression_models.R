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
# Regression model with all variables
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
summer_months <- c(4:9)
summer_workdays <- daily_data_pp[(month(ob_date) %in% summer_months) & (workday == T) & !is.na(NO2)]
summer_restdays <- daily_data_pp[(month(ob_date) %in% summer_months) & (workday == F) & !is.na(NO2)]
winter_workdays <- daily_data_pp[!(month(ob_date) %in% summer_months) & (workday == T) & !is.na(NO2)]
winter_restdays <- daily_data_pp[!(month(ob_date) %in% summer_months) & (workday == F) & !is.na(NO2)]

model_summer_workdays <- lm(NO2~temp_avg + wind_avg_speed + precipitation, data = summer_workdays)
model_summer_restdays <- lm(NO2~temp_avg + wind_avg_speed + precipitation, data = summer_restdays)
model_winter_workdays <- lm(NO2~temp_avg + wind_avg_speed + precipitation, data = winter_workdays)
model_winter_restdays <- lm(NO2~temp_avg + wind_avg_speed + precipitation, data = winter_restdays)

summary(model_summer_workdays)
summary(model_summer_restdays)
summary(model_winter_workdays)
summary(model_winter_restdays)

# ===================================================
# First model. Filter data by average temperatures
#   above & below 10 degree C
# ===================================================
daily_data_no2_above10 <- daily_data_pp[temp_avg >= 10 & !is.na(daily_data_pp$NO2),]
daily_data_no2_below10 <- daily_data_pp[temp_avg < 10 & !is.na(daily_data_pp$NO2),]

no2_wind_temp_above10 <- lm(NO2~temp_avg+wind_avg_speed, data=daily_data_no2_above10)
no2_wind_temp_below10 <- lm(NO2~temp_avg+wind_avg_speed, data=daily_data_no2_below10)

summary(no2_wind_temp_above10)
# Multiple R-squared:  0.2004,	Adjusted R-squared:  0.2003
confint(no2_wind_temp_above10,parm = 'temp_avg', level = 0.95)
# temp_avg -0.412738 -0.3591649
confint(no2_wind_temp_above10,parm = 'wind_avg_speed', level = 0.95)
# wind_avg_speed -1.677816 -1.607999
mean(abs(no2_wind_temp_above10$residuals))
# 12.44691
summary(no2_wind_temp_above10$residuals)
plot(no2_wind_temp_above10$residuals)
hist(no2_wind_temp_above10$residuals)
qqnorm(no2_wind_temp_above10$residuals); grid()
boxplot(no2_wind_temp_above10$residuals,main='boxplot'); grid()

summary(no2_wind_temp_below10)
# Multiple R-squared:  0.4173,	Adjusted R-squared:  0.4173
confint(no2_wind_temp_below10,parm = 'temp_avg', level = 0.95)
# temp_avg -2.080286 -1.846379
confint(no2_wind_temp_below10,parm = 'wind_avg_speed', level = 0.95)
# wind_avg_speed -2.078921 -1.994215
mean(abs(no2_wind_temp_below10$residuals))
# 13.67155
plot(no2_wind_temp_below10$residuals)
hist(no2_wind_temp_below10$residuals)
qqnorm(no2_wind_temp_below10$residuals); grid()
boxplot(no2_wind_temp_below10$residuals,main='boxplot'); grid()

# ===================================================
# Second model. Filter data by workday true/false
#   above & below 10 degree C
# ===================================================
daily_data_no2_workday <- daily_data_pp[workday == T & !is.na(daily_data_pp$NO2),]
daily_data_no2_no_workday <- daily_data_pp[workday == F & !is.na(daily_data_pp$NO2),]

no2_wind_temp_workday <- lm(NO2~temp_avg+wind_avg_speed, data=daily_data_no2_workday)
no2_wind_temp_no_workday <- lm(NO2~temp_avg+wind_avg_speed, data=daily_data_no2_no_workday)

summary(no2_wind_temp_workday)
# Multiple R-squared:  0.3624,	Adjusted R-squared:  0.3624
confint(no2_wind_temp_workday,parm = 'temp_avg', level = 0.95)
# temp_avg -0.8223797 -0.7805817
confint(no2_wind_temp_workday,parm = 'wind_avg_speed', level = 0.95)
# wind_avg_speed -2.005352 -1.940932
mean(abs(no2_wind_temp_workday$residuals))
# 13.00107
summary(no2_wind_temp_workday$residuals)
plot(no2_wind_temp_workday$residuals)
hist(no2_wind_temp_workday$residuals)
qqnorm(no2_wind_temp_workday$residuals); grid()
boxplot(no2_wind_temp_workday$residuals,main='boxplot'); grid()

summary(no2_wind_temp_no_workday)
# Multiple R-squared:  0.3817,	Adjusted R-squared:  0.3816
confint(no2_wind_temp_no_workday,parm = 'temp_avg', level = 0.95)
# temp_avg -0.8175451 -0.7624115
confint(no2_wind_temp_no_workday,parm = 'wind_avg_speed', level = 0.95)
# wind_avg_speed -1.806638 -1.724246
mean(abs(no2_wind_temp_no_workday$residuals))
# 11.24153
summary(no2_wind_temp_no_workday$residuals)
plot(no2_wind_temp_no_workday$residuals)
hist(no2_wind_temp_no_workday$residuals)
qqnorm(no2_wind_temp_no_workday$residuals); grid()
boxplot(no2_wind_temp_no_workday$residuals,main='boxplot'); grid()
