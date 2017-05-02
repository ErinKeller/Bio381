install.packages("lubridate")
library("lubridate")
library("ggplot2")
library("dplyr")

AUTemp <- read.csv("AUTemp.csv",header=TRUE, stringsAsFactors=FALSE)
head(AUTemp)
class(AUTemp$date) # character

# convert column to date class
AUTemp$date <- as.Date(AUTemp$date, format= "%m/%d/%Y")

# view R class of data
class(AUTemp$date)

AU1<- AUTemp[AUTemp$date >= "2015-01-01" & AUTemp$date <= "2015-12-31",]


par(opar)
plot(x=AU1$date, y=AU1$Temperature,
      main="Daily Soil Temperatures", cex=0.5, pch=21,lab=c(20,4,0), xlab = "Month", ylab="Soil Temperature")
abline(h=5,col="red", lwd=2)
# trying ggplot2 version
ggplot(data=AUTemp, 
       aes(AUTemp$date, AUTemp$Temperature), 
       scale_x_date(labels=date_format("%m-%Y"),
                    breaks= "1 month"))

AUTemp$date<-as.POSIXct(AUTemp$date,
                                    format = "%m-%d-%Y",
                                    tz = "America/New_York")
AUTemp$month <- month(AUTemp$date)

# Create a group_by object using the year column 
AUTempMonth <- group_by(AUTemp, # data_frame object
                          month) # column name to group by

head(AUTempMonth)

# Summarize data by month
summarize(AUTempMonth,
          mean(Temperature))   # calculate the meansoil temperature for every month
sum(AUTemp$Temperature > 5)

