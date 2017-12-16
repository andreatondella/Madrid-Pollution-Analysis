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

# ===================================================

corrplot(cor(daily_data_pp[complete.cases(daily_data_pp), c("BEN","CO","EBE","NMHC","NO","NO2","O3","PM10","PM2.5","SO2","TCH","TOL")]), method = 'number', tl.col = 'black')

# ===================================================

# Let's look at O3 values to search for an explanation for the negative correlation
O3 <- daily_data_pp$O3[!is.na(daily_data_pp$O3)]
quantile(O3, seq(0,1,0.1))

p0_O3<-qplot(x=1:length(O3),y=O3, geom='point')
p1_O3<-qplot(O3, geom='histogram')
p2_O3<-qplot(O3, geom='density')
p3_O3<-qplot(O3, x= 1, geom = "boxplot")
p_O3<-list(p0_O3,p1_O3, p2_O3, p3_O3)
marrangeGrob(p_O3, nrow=2, ncol=2)

O3_mean <- mean(O3)
O3_sd <- sd(O3)

# 50, 100 and 150 are reccomended threshold values for NO2
# https://www3.epa.gov/airnow/no2.pdf
plot(O3, pch=19, xlab=''); grid()
abline(50,0,col="chartreuse4")  
abline(100,0,col="gold") 
abline(150,0,col="darkorange2")
points(rep(0,length(O3)),col='white')

# ===================================================

# Let's analyse NO2 and O3 together

NO2_O3<-daily_data_pp[ ,.(x=NO2, y=O3)]
NO2_O3 <- NO2_O3[complete.cases(NO2_O3), ]
head(NO2_O3)

NO2_O3_p1<-qplot(NO2_O3$x,geom='density')
NO2_O3_p2<-qplot(NO2_O3$y,geom='density')
NO2_O3_p4<-ggplot(NO2_O3,aes(x=x,y=y))+geom_point()
NO2_O3_p<-list(NO2_O3_p1,NO2_O3_p2)
marrangeGrob(NO2_O3_p, nrow=2, ncol=1)

print(NO2_O3_p4+ggtitle('NO2 vs O3'))
# ===================================================
