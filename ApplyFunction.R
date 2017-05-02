### Apply Function
### 20 April 2017
### ELK


# The apply function
# apply(x, margin, function,....)
# x is a vector, matrix or an array
#marin 1 rows, 2 columns, (3...) c(1,2)
m <- matrix(1:12,3,4,byrow=TRUE)
print(m)

myCV <- function(x=runif(5)) {
  x <- sd(x)/mean(x)
  return(x)
}

# get cvs of rows with a for loop
myOut <- vector(mode="numeric",length=nrow(m))

for (i in 1:nrow(m)) {
  myOut[i] <- myCV(m[i,])
}
print(myOut)

# solve with apply function

m0 <- apply(m,1,myCV) # apply takes myCV function and use it on m
print(m0)

# solve for columns
m0 <- apply(m,2,myCV)
print(m0)

# apply across both indices simultaneously
m0 <- apply(m,c(1,2),myCV) # matrix full of NA because we are calling both 1 and 2 and can't get an sd on a single number
print(m0)

# use myCV for entire matrix
m0 <- myCV(m)
print(m0)

# use anonymous function
m0 <- apply(m,1,function(x) sd(x)/mean(x)) # usually when we use an anonymous function we just use "X" i.e. function(x) then add the function directly afterwards
# this allows you to NOT write out a separate function but code it all in a single step
print(m0)


# problems with matrix dimensions
# a simple rescaling of column totals
m0 <- apply(m,2,function(x) x/sum(x)) # x is a vector (column) so by dividing x by sum of x = vectorize operation and it is going to take each value of x and divide it by the sum of x
print(m0)

# now try over rows
m0 <- t(apply(m,1,function(x) x/sum(x))) # wrap it with the t function = transpose rows and columns # only need to do this if you are operating on the rows and not the columns
print(m0)

# rescale over entire matrix
m0 <- t(apply(m,c(1,2),function(x) x/sum(x))) # this will fill the matrix up with a value of 1 because weare giving the function a value of x and dividing it over the sum of the vector - only x in the vector, so dividing by itself
print(m0)

# vectorize this operation
m0 <- m/sum(m)
print(m0) # add all elements --> equals 1

# reshuffle matrix rows as in EcoSimR sim2
m0 <- t(apply(m,1,function(x) sample(x)))
print(m0)

# reshuffle columns
m0 <- apply(m,2,function(x) sample(x))
print(m0)

# shuffle all elements
m0 <- sample(m)
print(m0)

m0 <- matrix(sample(m),3,4,byrow=TRUE)
print(m0)

m0 <- m
print(m0)
m0[,] <- sample(m)

# what if the output differs in length each time
print(m)
m0 <- apply(m,c(1,2),function(x) runif(x)) # first element --> function --> random uniform number --> next element passed through function etc --> 2 random numbers..... --> 3 random numbers, etc. 
print(m0)
str(m0)
print(m0[1,2])
print(m0[[2]])

# replicate function
# replcate(n, expression, simplify)
# n = # replicates
# expression = R expression
# simplify TRUE --> vector, matrix
# simplify FALSE --> list

myOut <- matrix(data=0,3,5)

# fill with a double for loop
for (i in 1:nrow(myOut)) {
  for (j in 1:ncol(myOut)) {
    myOut[i,j] <- runif(1)
  }
}
print(myOut)

myOut <- matrix(data=runif(15),3,5)
print(myOut)

# with replicate
m0 <- replicate(5, 100 + runif(3),simplify=FALSE) # with false = list
print(myOut)

# create different structure
m0 <- replicate(5, 100 + runif(sample.int(10, 1)),simplify=TRUE) # sample.int(range of numbers (1-10), how many times you want to sample from that list of numbers (1)
print(m0)


# the lapply function 
# lapply(x, function, [optional argumennts...])
# x = vector or a list
# this will take the vector/list and apply the function to each of the elements it has in it


# use with operations on the columns of a data frame
d <- read.table(file="antcountydata.csv",
                header=TRUE,
                sep=",",
                stringsAsFactors=FALSE)
str(d)

# with a for loop, get mea of vars 5 and 6
myMeans <- vector(mode="numeric",length=2)

z<- 0 # have to create counter variable, uggh!

for (i in 5:6){
  z <- z + 1 
  myMeans[z] <- mean(d[[i]])
}
print(myMeans)

# do this much easier with lapply
myMeans <- lapply(d[c(5,6)],mean)
print(myMeans)
unlist(myMeans)

# sapply is the same but gives output as vectors
myMeans <- sapply(d[c(5,6)],mean)
print(myMeans)
unlist(myMeans)

# aggregate(x, by, function)
# by must be in the form of a list!!!!!
# aggregate function to split a list into group and apply the function to each group

myMeans <- aggregate(d[c(5,6)],by=list(d$ecoregion),mean)
print(myMeans)

# set up parameter sweep for species-area model
# first illustrate with for loop

# global variables
c <- c(0.1, 0.2, 0.5)
z <- c(0.16, 0.26)
A <- c(1,10,100,1000)
noise <- c(0,0.01,0.1)
nrep <- 100 # must be of length 1 to use the Map function

# set up parameter/output grid
modelSum <- expand.grid(nrep=nrep,c=c,z=z,A=A,noise=noise) #expand.grid sets up long table with all of the possible combination of the different parameters. Gives data frame
modelSum$meanS <- NA # add two more columns to modelSum data frame
modelSum$sdS <- NA # see above
print(modelSum)
# create simple Species Area calculator function
SAcalc <- function(c=0.1,z=0.16,A=100,noise=0.1) {
  S <- c*(A)^z + rnorm(n=1,mean=0,sd=noise)
  return(S)
}
SAcalc()
# cycle through parameters with a for loop
for (i in 1:nrow(modelSum)) {
  pars <- list(modelSum[i,2],
               modelSum[i,3],
               modelSum[i,4],
               modelSum[i,5])
  temp <-replicate(n=modelSum[i,1],do.call(SAcalc,pars)) # can call list of parameters with do.call, temp is a vector of each replicate
  modelSum$meanS[i] <- mean(temp)
  modelSum$sdS[i]<- sd(temp)
}  
print(modelSum) 

# illustrate the basic map function which allows you to call a function with multiple sets of paramters
Map(SAcalc,modelSum$c,modelSum$z,modelSum$A,modelSum$noise) # first function you want to work on, then a list of vectors corresponding to a particular value that is in there and each column has the 72 values. All vectors must be the same length. Output - list of 72 elements created by sweeping through the corresponding set of paramters are running at those parameters 

# now repeat model calculations using only map, no for loops
temp <- replicate(nrep,unlist(Map(SAcalc,modelSum$c,modelSum$z,modelSum$A,modelSum$noise))) #unlist takes results from a list and instead put it into a vector (temp)
modelSum$meanS[i] <- mean(temp)
modelSum$sdS[i]<- sd(temp)
print(modelSum) 
# map function eliminates need for for loop