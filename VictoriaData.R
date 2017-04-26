# Helping Victoria
# 2 April 2017
# ELK


# Variables 10 vs 7
data <- read.table("Victoria.csv",header=TRUE,sep=",") # this reads your data into R
head(data) # taking a look at the top 5 or 10 rows
Var10 <- data[,10] # assigning a column of data to a variable
str(Var10) # checking to make sure the structure is okay, should equal the number of observations you have
Var7 <- data[,7] # assigning a column of data to a variable
str(Var7) # checking structure
Model710 <- cbind(Var7,Var10) # making a smaller data set containing only variables of interest; you don't have to do this
dataMatrix710 <-  matrix(Var10,Var7) # making a data matrix needed to do a contingency table/Chi Square Test  
head(dataMatrix710) # looking at first 10 rows or so of the data matrix to make sure it looks right
print(chisq.test(dataMatrix710)) # Chi Square Test on these variables. P value is printed out.

boxplot(Var10~Var7,data=dataMatrix710, main="Alcohol Consumption", 
        xlab="Study Motivation", ylab="Alchol Effect") # Making a box and whisker plot with your data. Check to see if I have my axes labels right

##############################################
# Variables 4 vs. 9

Var4 <- data[,4]
Var9 <- data[,9]
dataMatrix49 <-  matrix(Var4,Var9)
print(chisq.test(dataMatrix49))

print(chisq.test(dataMatrix49))
pvalue <-c("P-value=", format(chisq.test(dataMatrix49)$p.value, nsmall=3,digits=3))


boxplot(Var4~Var9,data=dataMatrix49, main="Alcohol Consumption", 
        xlab="Alcohol Per Month", ylab="Study Level")

#############################################
        