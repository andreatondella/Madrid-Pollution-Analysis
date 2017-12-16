# MBDO2-2
# R Group Assignment
# ===================================================

# Exploring the datasets

# ===================================================

#Loading libraries
source("lib_loading.R")

# ===================================================

# Some scientific facts about our parameters:

# There are three tipe of sources for our pollutants:
#   
# CARS: BEN, CO, EBE, NMHC, NO, NO2, PM10, PM2.5
# 
# INDUSTRIES: SO2, TOL, NMHC
# 
# CHEMICAL REACTIONS: (NOx + NMHC + all other aromatic compounds) + SUNLIGHT -> GROUND OZONE (O3)
# 
# TCH = total hydrocarbons = NMHC + CH4 + BEN + EBE + ...

# ===================================================

# Daily_data_pp summary
str(daily_data_pp)

# ===================================================

# NO2 analysis
NO2 <- daily_data_pp$NO2[!is.na(daily_data_pp$NO2)]
quantile(NO2, seq(0,1,0.1))

p0_NO2<-qplot(x=1:length(NO2),y=NO2, geom='point')
p1_NO2<-qplot(NO2, geom='histogram')
p2_NO2<-qplot(NO2, geom='density')
p3_NO2<-qplot(NO2, x= 1, geom = "boxplot")
p_NO2<-list(p0_NO2,p1_NO2, p2_NO2, p3_NO2)
marrangeGrob(p_NO2, nrow=2, ncol=2)

NO2_mean <- mean(NO2)
NO2_sd <- sd(NO2)

NO2_thres <- c(50,100,150,200)

plot(NO2, pch=19, xlab=''); grid()
points(NO2 <= NO2_thres[1],col)
points(rep(0,length(NO2)),col='white')
