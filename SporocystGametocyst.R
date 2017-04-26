### Nested ANOVA
### Sporocyst Count
### Erin L. Keller

data <- read.table("SporCount.csv", header=TRUE,sep=",")
head(data)

str(data)

fit = aov(SporCount ~ Site + Error(ID), data=data)
summary(fit)

fit = aov(SporCount ~ Site, data=data)
summary(fit)

fit = aov(SporCount ~ ID, data=data)
summary(fit)

fit = aov(SporCount ~ Site + ID, data=data)
summary(fit)

Spor <- data[,2]
IDs <- data[,3]
SporID <- cbind("IDs","Spor")
SporID
aov(SporID)
GraphAnova(dat)
