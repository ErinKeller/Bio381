# Random subsetting and probability distributions 
# 23 February 2017
# ELK

# grab the ant data
data <- read.table(file="antcountydata.csv",header=TRUE,sep=",",stringsAsFactors=FALSE)

littleData<-data[1:8,3:6]

# running sample with an integer
sample(10)

# applied to a vector, it randomizes the order of the elements
print(littleData$n.species)
sample(littleData$n.species)

sample(x=littleData$n.species,size=3)


# sample with replacement for bootstrapping
sample(x=littleData$n.species,size=20,replace=TRUE)

# sample sizes must match - you will get an error message because you are pulling out more observations than there are

sample(x=littleData$n.species,size=20,replace=FALSE)

# suppose elements are not sample equiprobably
# community assembly and null models (Simberloff)
mainlandSpecies <- paste("Species",1:10,sep="")
popSizes <- c(1000,500,100,20,10,5,5,5,1,1)

# equiprobable colonization
islandA <- sample(x=mainlandSpecies, size=5)
print(islandA)


# assume colonization potential is proportional to population size 
# must be same length, can't be negative 
# prob function will select species based on relative frequency of each
islandB <- sample(x=mainlandSpecies, size=5,prob=popSizes)
print(islandB)

# but islands aren't colonized by species, they are colonized by individuals
# colonization now of individuals, not species
islandC <- sample(x=mainlandSpecies, size=100,prob=popSizes,replace=TRUE)
head(islandC)
table(islandC) # the table function will give you the counts for each species sampled
unique(islandC)
length(unique(islandC)) # gives you the numbers of species present

# colonization of equiprobable individuals
# prob=NULL is the default, it does not take into consideration population sizes so all species are equally likely
islandD <- sample(x=mainlandSpecies, size=100,prob=NULL,replace=TRUE)
head(islandD)
table(islandD)
unique(islandD)
length(unique(islandD))
length(table(islandD)[table(islandD)>9]) # this will tell you how many species that  have more than 9 individuals colonizing


# --------------------------------
# Poisson distribution
# "d" function gives the probability density
# lambda is the rate of process parameter 
# poisson distributions are good for rare events
MyVec <- dpois(x=seq(0,10),lambda=1)
names(MyVec) <- seq(0,10)
barplot(height=MyVec)

# again with a different lambda
MyVec <- dpois(x=seq(0,10),lambda=2)
names(MyVec) <- seq(0,10)
barplot(height=MyVec)
print(MyVec)
sum(MyVec) # the area under the curve/bar is set to 1

# even higher lambda
# you need to make the seqeunce longer to get the right tail
# increasing lambda makes the distribution more and more like a normal distribution
MyVec <- dpois(x=seq(0,10),lambda=5)
names(MyVec) <- seq(0,10)
barplot(height=MyVec)

# and here is a VERY LOW vvalue for lamda
MyVec <- dpois(x=seq(0,10),lambda=0.1)
names(MyVec) <- seq(0,10)
barplot(height=MyVec)

# p poisson now
MyVec <- ppois(q=seq(0,10),lambda=2)
names(MyVec) <- seq(0,10)
barplot(height=MyVec) # probability of getting that value or smaller

# q function
MyVec <- ppois(q=seq(0,10),lambda=2)
names(MyVec) <- seq(0,10)
barplot(height=MyVec)

# the range is the upper and lower bound of a 95% confidence interval
# the output is: 95% values of the poisson distribution will be between 37 and 64

qpois(p=c(0.025,0.975),lambda=50)

x <- rpois(n=1000,lambda=1.1)
hist(x)

# -------------------------------------------------------------
# Binomial distributions
# p= probability of dichotomous outcome
# size = number of trials
# x = possible outcomes (usually can set x = size)

MyVec <- dbinom(x=seq(0,10),size=10,p=0.75)
names(MyVec) <- seq(0,10)
barplot(height=MyVec)

qbinom(p=c(0.025,0.975),size=100,prob=0.75)


# Negative binomial: the number of failures (values of MyVec) in a series of Bernouli (coin toss) trials with probability of success p, before we reach a target number of successes 
# more hetergenous ("overdispersed") than a Poisson

MyVec <- dnbinom(x=seq(0,40),size=5,prob=0.5) # size = 5 means we want five successes 
names(MyVec) <- seq(0.40)
barplot(height=MyVec)

MyVec <- dnbinom(x=seq(0,40),size=1,prob=0.1)  
names(MyVec) <- seq(0.40)
barplot(height=MyVec)

# alternatively specify mean = mu
# size is a dispersion parameter 
# small values of size give overdispersion

MyVec <- dnbinom(x=seq(0,40),size=10,mu=5) # when we specify it this way we want to use the probability that gives us an average of 5 
names(MyVec) <- seq(0.40)
barplot(height=MyVec)

# success v. failure is one way to think about it, but we really care about is that the histogram is well described by the model. They are not mechanistic models but can match the data pretty well

# pbninom for tail distribution
pnbinom(q=3,size=1,mu=5)

# qnorm for actual value for a p
qnbinom(p=0.05,size=10,mu=5) # answer: 1 so 95% of observations has a lower bound at 1

# confidence interval
qnbinom(p=c(0.025,0.975),prob=0.5,size=10) # 3 is the lower bound and 20 is the upper bound of the 95% confidence interval; in terms of this mode, it means that typically it takes between 3 and 20 flips to get 10 heads with a probability of getting heads to be 0.5

# random sample from negative binomial
MyVec <- rnbinom(n=100,size=1,mu=20)
quantile(MyVec,prob=c(0.025,0.975)) # output will be the upper and lower bounds of the 95% CI
qnbinom(p=c(0.025,0.975),size=1,mu=20) # this is the theoretical 95% CI

# uniform
# parameters for minimum and maximum

limits <- seq(0,10,by=0.01)
z <- dunif(x=limits,min=0,max=5)
names(z) <- limits
plot(x=limits,y=z,type="l",xlim=c(0,10))

# punif for tail probabilities

limits <- seq(0.10,by=0.1)
z <- punif(q=limits,min=0,max=5)
names(z) <- limits
plot(x=limits,y=z,type="l",xlim=c(0,10))

# qunif for quantiles
qunif(p=c(0.025,0.975),min=0,max=5)

# runif to generate data
hist(runif(n=1000,min=0,max=5))


# --------------------------------------

# normal distribution 

hist(rnorm(n=100,mean=100,sd=2))
hist(rnorm(n=100,mean=2,sd=2)) # this will likely give us negative observations but we rarely see ngeative values in ecological studies
MyVec <- rnorm(n=100,mean=2,sd=2)
summary(MyVec)

TossZeroes <- MyVec[MyVec>0] # this is a fast and easy way to eliminate all negative values that you don't want
summary(TossZeroes)
hist(TossZeroes) # this doesn't appear normal because we tossed a lot of the data (lower tail)

#-----------------------------------------
# gamma distribution ** this is often the most appropriate distribution for ecological studies
# 2 parameters shape1, shape2
# continuous, positive values

hist(rgamma(n=100,shape=1,scale=10))

# gamma with shape = 1 gives an exponential with scale = mean

hist(rgamma(n=100,shape=0.1,scale=10))


# large shape parameter look like normal distribution
hist(rgamma(n=100,shape=20,scale=1))


# mean = shape*scale
# variance = shape*scale^2

# -------------------------------------------
# Beta distribution
# continuous BUT bounded between 0 and 1 (works well for probability of event, distribution of organisms along gradient
# parameter shape1 = number of successes + 1
# parameter shape2 = number of failures + 1

# shape1 = 1 and shape2 = 1 "no data"
hist(rbeta(n=1000,shape1=1,shape2=1),breaks=seq(0,1,length=100)) # no pattern because no data!

# shape1 = 2 shape 2 = 1 "1 head"
hist(rbeta(n=1000,shape1=2,shape2=1),breaks=seq(0,1,length=100)) # p value is all the way to the right because there are so few (n=1) data!

# two tosses, 1 head, 1 tail -> shape 1 = 2, shape 2 = 2
hist(rbeta(n=1000,shape1=2,shape2=2),breaks=seq(0,1,length=100)) # now we start seeing a pvalue for the coin ~0.5

# two tosses, both heads
hist(rbeta(n=1000,shape1=3,shape2=1),breaks=seq(0,1,length=100)) # we see pvalue again ro the right (1) which makes sense because we got 2 heads.... sharper incline of pvalue because we have more data

# more data equal counts
hist(rbeta(n=1000,shape1=20,shape2=20),breaks=seq(0,1,length=100)) # now we see a sharp incline to the the pvalue which is at 0.5 which is expected as we had the same number of heads as tails

# more data unequal counts
hist(rbeta(n=1000,shape1=20,shape2=10),breaks=seq(0,1,length=100))

# shape parameters less than 1?
hist(rbeta(n=1000,shape1=0.2,shape2=0.4),breaks=seq(0,1,length=100)) # we start generating U shape distributions with two probability massese at 0 and 1... height of these will be asymmetric because we had different values for the shapes. If we make the shapes equal, then the height at 0 and 1 will be the same

# estimating parameters from data
# maximum likelihood estimation
# maximize the p(data|parameters)

library(MASS) 
x<-rnorm(1000,mean=92.5,sd=2.5)
hist(x)
fitdistr(x,"normal") # this will tell you what the mean and sd of your data is given a specific distribution of interest
mean(x)
sd(x)

# but what should we fit to?
# gamma distribution
z <-fitdistr(x,"gamma")
str(z) # this tells us that we have two parameters: shape and rate
# rate = 1/scale
# so here is the estimate of the mean
z$estimate[1]/z$estimate[2]


# estimate of variance
z$estimate[1]/z$estimate[2]^2
