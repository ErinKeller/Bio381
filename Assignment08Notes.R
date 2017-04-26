# Assignment 08 NOTES
# 8 March 2017
# Erin L. Keller

##################### Linear Regression  ###################
## Continuous - continuous
# data
xVar <- 1:10 # x vriable is 1-10
yVar <- runif(10) # y variable is 10 random numbers from a uniform distribution
dataFrame <- data.frame(xVar,yVar) # making a data frame from our values

# model
regModel <- lm(yVar~xVar,data=dataFrame) # Assigning a variable to the linear regression of our variables

# model output
print(regModel) # this prints the intercept and the slope of the regression
print(summary(regModel)) # this prints the results of the linear regression including the R^2 value, p-value

# plot
plot(y=dataFrame$yVar,x=dataFrame$xVar,pch=21,bg="lightblue",cex=2,main="Linear Regression",xlab="Number of Cats",ylab="Probability of being crazy") # plotting the linear regression, cex = the data points are 2x larger than default. ylab changes Y axis label main = adds a title
abline(regModel) # this adds the line of best fit

############################### ANOVA #######################################
# Dependent - continuous; Independent - discrete
# data
xVar <- as.factor(rep(c("Control","Heated","Cooled"),each=5)) # rep function repeats "Control" "heated" etc. 5 times # this is the X variable = discrete
yVar <- c(rgamma(10,shape=5,scale=5),rgamma(5,shape=5,scale=10)) # Y variable data = continuous
dataFrame <- data.frame(xVar,yVar) # putting data into a data frame

# model
anovaModel <- aov(yVar~xVar,data=dataFrame) # ANOVA model

# model output
print(anovaModel) # this prints the sum of squares and degrees of freedom
summary(anovaModel) # this gices p-values

# plot
boxplot(yVar~xVar,data=dataFrame,col=c("grey","thistle","orchid")) # This makes a barplot # words in quotations indicate color of box plot

#################################### Contingency Table ###################################
# Discrete - discrete
# data
vec1 <- c(50,66,22) # discrete variable
vec2 <- c(120,22,30) # discrete variable
dataMatrix <- rbind(vec1,vec2)
rownames(dataMatrix) <- c("Cold","Warm") # giving row and column names
colnames(dataMatrix) <-c("Aphaenogaster",
                         "Camponotus",
                         "Crematogaster")



# model + model output
print(chisq.test(dataMatrix)) # this does a Chi Square analysis and prints back X^2 value, d.f., and p-values

# plotting the data matrix
mosaicplot(x=dataMatrix,
           col=c("goldenrod","grey","black"),
           shade=FALSE)
# plotting a barplot
barplot(height=dataMatrix,
        beside=TRUE,
        col=c("cornflowerblue","tomato"))
# to get expected data points
chisq.test(dataMatrix)$expected # print back expected value 
## Verify that these are the expected counts
(sum(dataMatrix[,1])*sum(dataMatrix[1,]))/sum(dataMatrix) # this is equivalent to: sum of: Row totals * column totals all divided by total obserations

# Now we can compare the expected vs. observed visually
par(mfrow=c(2,1)) # plots 2 graphs one on top of another
expected <- as.matrix(chisq.test(dataMatrix)$expected)

barplot(height=expected,
        beside=TRUE,
        col=c("cornflowerblue","tomato"))
barplot(height=dataMatrix,
        beside=TRUE,
        col=c("cornflowerblue","tomato"))

########################### Logistic Regression #########################################
# Dependent variable - discrete Independent variable - continuous
# data
xVar <- rgamma(n=20,shape=5,scale=5)
yVar <- rbinom(n=20,size=1,p=0.5)
dataFrame <- data.frame(xVar,yVar)

# model
# glm function performs regression
logRegMod <- glm(yVar ~ xVar,
                 data=dataFrame,
                 family=binomial(link="logit")) # we can specify it is binomial because we used a binomial distribution to create y values
# model output
print(logRegMod) # prints d.f., residual, intercepts, slope
summary(logRegMod) # prints p-value

par(mfrow=c(1,1)) # making it so the figures won't stack
# plot
plot(x=dataFrame$xVar, y=dataFrame$yVar,pch=21,bg="tan",cex=2.5)
curve(predict(logRegMod,data.frame(xVar=x),type="response"),add=TRUE,lwd=2) # this line is a predicter based on the logical regression we've done #add=TRUE means we are adding the line to the plot we just made 
