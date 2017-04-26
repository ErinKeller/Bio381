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
