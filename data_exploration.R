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

# 50, 100 and 150 are reccomended threshold values for NO2
# https://www3.epa.gov/airnow/no2.pdf
plot(NO2, pch=19, xlab=''); grid()
abline(50,0,col="chartreuse4")  
abline(100,0,col="gold") 
abline(150,0,col="darkorange2")
points(rep(0,length(NO2)),col='white')

#Trying a logarithmic transformation, cannot achieve a normal distribution
# ln_NO2<-log(NO2)

# p0_ln<-qplot(x=1:length(NO2),y=ln_NO2, geom='point')
# p1_ln<-qplot(ln_NO2, geom='histogram')
# p2_ln<-qplot(ln_NO2, geom='density')
# p3_ln<-qplot(ln_NO2, x= 1, geom = "boxplot")
# p_ln<-list(p0_ln,p1_ln,p2_ln,p3_ln)
# marrangeGrob(p_ln, nrow=2, ncol=2)

corrplot(cor(daily_data_pp[complete.cases(daily_data_pp), c("BEN","CO","EBE","NMHC","NO","NO2","O3","PM10","PM2.5","SO2","TCH","TOL")]), method = 'circle', tl.col = 'black')

p<-GGally::ggpairs(daily_data_pp[complete.cases(daily_data_pp), c("BEN","CO","EBE","NMHC","NO","NO2","O3","PM10","PM2.5","SO2","TCH","TOL")],axisLabels = 'none',size=1,lwd=0.5,alpha=.5)

ggplotly(p, width = 800, height = 500)
