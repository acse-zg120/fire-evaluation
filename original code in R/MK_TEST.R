library("trend")
library(data.table)
library(dplyr)
library(Kendall)
library(zoo)

# Set work directory
setwd("/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT")  
path_fire = '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/Fires in Pantanal.csv'
path_prec = '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/prec_1.csv'

# Define study years
years <- list('2000','2001','2002','2003','2004','2005','2006','2007',
              '2008','2009','2010','2011','2012','2013','2014','2015',
              '2016','2017','2018')
years <- as.numeric(as.character(unlist(years)))

# Read fire data
data_fire = read.csv(path_fire,nrow=19, header = TRUE)

# Read precipitation data
data_prec <- read.csv(path_prec, header = TRUE)
prec_list <- data_prec$Average_Prec[1:19]

# Read fire information for a particular year 
read_year <- function(start_date, end_date){
  df = read.csv(path_fire)
  year <- subset(df, ACQ_DATE>= start_date & ACQ_DATE <= end_date & FRP)
  sapply(year, class)
  return(year)
}

fire_list <- list()

# Loop over data from 2000-2018
for (i in 1:19){
  start_date <- c("2000-01-01","2001-01-01","2002-01-01","2003-01-01","2004-01-01","2005-01-01","2006-01-01",
                  "2007-01-01","2008-01-01","2009-01-01","2010-01-01","2011-01-01","2012-01-01","2013-01-01",
                  "2014-01-01","2015-01-01","2016-01-01","2017-01-01","2018-01-01")
  end_date <- c( "2000-12-31","2001-12-31","2002-12-31","2003-12-31","2004-12-31","2005-12-31","2006-12-31",
                "2007-12-31","2008-12-31","2009-12-31","2010-12-31","2011-12-31","2012-12-31","2013-12-31",
                "2014-12-31","2015-12-31","2016-12-31","2017-12-31","2018-12-31")

  data<- read_year(start_date[i], end_date[i])
  data <- as.data.frame(data)
  
  # Count fire foci in each year
  fire_list[i] <- count(data)/6
}

# Ensure fire and prec lists are ready to plot graphs
fire_list <- as.numeric(as.character(unlist(fire_list)))
prec_list <- as.numeric(as.character(unlist(prec_list)))

# Apply MK Tests
mk.test(fire_list, continuity = TRUE)
mk.test(prec_list, continuity = TRUE)

# Calculate local regression
par(mfrow=c(2,2))
loessMod1 <- loess(prec_list~years)
# smooth output
pr.loess <- predict(loessMod1) # Predict Loess
# Plot
plot(years, prec_list, "l", las=3, cex.lab=1.3, cex.sub=1.4,
     sub="(a) Local Regression of Precipitation", 
     xlab="Year", ylab="Precipitation (mm)")
lines(pr.loess~years, col="red", lwd=1)

# Generate second order linear model
lin.mod2 <- lm(prec_list~I(years^2)+years)
# smooth output
pr.lm2 <- predict(lin.mod2) # Predict Loess
# Plot
plot(years, prec_list, "l", las=3, cex.lab=1.3, cex.sub=1.4,
     sub="(b) 2nd Linear Regression of Precipitation", 
     xlab="Time", ylab="Precipitation (mm)")
lines(pr.lm2~years, col="blue", lwd=1)

# Calculate local regression
loessMod1 <- loess(fire_list~years)
# smooth output
pr.loess <- predict(loessMod1) # Predict Loess
# Plot
plot(years, fire_list, "l", las=3, cex.lab=1.3, cex.sub=1.4, 
     sub="(c) Local Regression of Fire", 
     xlab="Year", ylab="Fire Foci")
lines(pr.loess~years, col="orange", lwd=1)

# Generate second order linear model
lin.mod2 <- lm(fire_list~I(years^2)+years)
# smooth output
pr.lm2 <- predict(lin.mod2) # Predict Loess
# Plot
plot(years, fire_list, "l", las=3, cex.lab=1.3, cex.sub=1.4,
     sub="(d) 2nd Linear Regression of Fire", 
     xlab="Time", ylab="Fire Foci")
lines(pr.lm2~years, col="green", lwd=1)

#### First order linear regression ####
par(mfrow= c(1,1))
lin.mod <- lm(fire_list~prec_list)
pr.lm <- predict(lin.mod)
plot(prec_list, fire_list, las=3, cex.lab=1.3, cex.sub=1.4,
     main="PREC VS FIRE FOCI",
     xlab="Precipitation (mm)", ylab="Fire Foci")
lines(pr.lm~prec_list, col="blue", lwd=1)

