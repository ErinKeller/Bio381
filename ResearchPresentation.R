# Research Project Analysis
# 30 April 2017
# Erin L. Keller

library(dplyr)

opar <- par(no.readonly=TRUE)

# Read in Sporocyst/Gametocyst data

data <- read.table("SporCount.csv", header=TRUE,sep=",")

head(data)

str(data)

# Use Shapiro-Wilk Normality Test to determine is the distribution of sporocysts per gametocyst for both AU and HF follow a normal distribution

shapiro.test(data[,2])
# W = 0.99618, p-value = 0.157
hist(data[,2])

# Use Shapiro-Wilk Normality Test to determine if the distribution of sporocysts per gametocysts are normally distributed at AU and HF separately.

AUSpor <- data[1:300,]
print(AUSpor)

HFSpor <- data[301:600,]
print(HFSpor)

shapiro.test(AUSpor[,2])
# W = 0.98394, p-value = 0.00194
hist(AUSpor[,2], breaks=10)

shapiro.test(HFSpor[,2])
# W = 0.99056, p-value = 0.05046
hist(HFSpor[,2], breaks=20)

HFHist <- HFSpor[,2]
AUHist <- AUSpor[,2]

# Making overlaid histogram of sporocysts/gametocyst at both sites

par(mfrow=c(1,1))

my.blue <- adjustcolor("blue",alpha.f=0.6)

hist(AUHist, col="red",breaks=seq(70,230,by=10),xlim=c(70,230),xlab="Sporocysts/Gametocyst",main="Sporocysts/Gametocyst at HF and AU",ylim=c(0,60))


par(new="TRUE")

hist(HFHist, axes=FALSE,ann=FALSE,col=my.blue,breaks=seq(70,230,by=10)) 

par(new="TRUE")
abline(v=mean(HFHist), col="blue", lwd=2)
par(new="TRUE")
abline(v=mean(AUHist), col="red", lwd=2)
legend("topright",title="Site",
       c("Hort Farm","Audubon"),
       pch=15,col=c(my.blue,"red"))


sd(HFHist)
# Not sure if I like the overlay, so making histograms by site
# HF
par(opar)
hHF<-hist(HFHist, col=my.blue,ylim=c(0,80),main="Sporocysts/Gametocyst at HF",xlab="Sporocysts/Gametocyst", breaks=20)
xfit <- seq(min(HFHist),max(HFHist),length=40)
yfit <- dnorm(xfit,mean=mean(HFHist), sd=sd(HFHist))
yfit2 <- yfit*diff(hHF$mids[1:2])*length(HFHist)
lines(xfit,yfit2,col="black",lwd=2)

# AU
par(opar)
hAU <- hist(AUHist,col="red", xlab= "Sporocysts/Gametocyst",main="Sporocysts/Gametocyst at AU",ylim=c(0,80))
xfit2 <- seq(min(AUHist),max(AUHist),length=40)
yfit3 <- dnorm(xfit2,mean=mean(AUHist), sd=sd(AUHist))
yfit4 <- yfit3*diff(hAU$mids[1:2])*length(AUHist)
lines(xfit2,yfit4,col="black",lwd=2)


# Conduct a nested ANOVA on the sporocysts/gametocyst for both sites, where site is the group and individual is the subgroup

fit = aov(SporCount ~ ID, data=data)
summary(fit)
# Df Sum Sq Mean Sq F value Pr(>F)    
# ID           19 157617    8296   21.65 <2e-16 ***
#   Residuals   580 222282     383   

fit = aov(SporCount ~ Site + ID, data=data)
summary(fit)

# Df Sum Sq Mean Sq F value Pr(>F)    
# Site          1   3480    3480    9.08 0.0027 ** 
#   ID           18 154137    8563   22.34 <2e-16 ***
#   Residuals   580 222282     383  

# Box and Whisker Plot of Sporocysts/Gametocyst
par(cex.lab=1.5)

par(cex.axis=1.5)
boxplot(SporCount~Site,data=data, main="Sporocysts Per Gametocyst", 
        xlab="Site", ylab="Sporocysts/Gametocyst",col=c("red",my.blue),breaks=10)

# Reading in AU Parasite Phenology data
ParPhen <- read.table("ParasitePhenology.csv", header=TRUE,sep=",")
ParPhen1 <- as.data.frame(ParPhen,header=TRUE)
head(ParPhen1)
# Calculating average parasitemia by week and site
avgTotal <- group_by(ParPhen, SITE, DATE) %>%
  summarise(N = n(), avgTotal = mean(TOTAL))

print(avgTotal)
# Making data frames for the average parasitemia for each site
avgTotalAU <- avgTotal[1:17,]
print(avgTotalAU)



avgTotalCW <- avgTotal[18:34,]
print(avgTotalCW)

avgTotalHF <- avgTotal[35:50,]
print(avgTotalHF)

group_by(ParPhen, SITE) %>%
  summarise(N_dates = n_distinct(DATE))
avgTotal


# Plot average parasitemia by site each week
# Starting by adding AU data
par(opar)

plot(x=avgTotalAU$DATE, y=avgTotalAU$avgTotal,xlab="Week",ylab="Mean Parasitemia",main="Mean Parasitemia by Week",xlim=c(16,32), lab=c(12,4,0),col="red",pch=16, type="l")

par(new="TRUE")

# Adding HF data
plot(x=avgTotalHF$DATE, y=avgTotalHF$avgTotal,axes=FALSE,ann=FALSE,col="blue",pch=16,type="l")

par(new="TRUE")
# Adding CW data
plot(x=avgTotalCW$DATE, y=avgTotalCW$avgTotal,axes=FALSE,ann=FALSE,col="green",pch=16,type="l")

# adding legend
par(new="TRUE")
legend("topright", c("AU", "HF", "CW"), pch=16, col=c("red","blue","green"))

# Making box and whisker plot
boxplot(avgTotal~SITE,data=avgTotal, main="Parasitemia by Week", 
        xlab="Week", ylab="Parasitemia",col=c("red","green",my.blue),breaks=10)
