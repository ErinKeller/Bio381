# Care and feeing of for loops
# 20 March 2017
# ELK

# Some R programmers say we should never use for loops in R because they can be slow and unneccessary.

# Apply functions will do many of the things for loops can

################################ General Structure for for loops##################
# for(var in seq(can be 1:10 for example)) { <- this is the start of the loop # var is a counter variable; will increment by 1. Var = i,j, or k
# body of loop
# } <- this is the end of loop
###############################################################################
# example when x = 1:1000
# for(i in seq_along(x)) # this is the fastest way to set it up {
# function body
# }
###############################################################################

# Simple example


myDat <- round(runif(10),digits=2)
for (i in seq_along(myDat)) {
 cat("loop number = ",i, 
     "vector element = ",myDat[i],"\n")
}


# don't put unneccessary things in loops; it will slow the program down!!!
myDat <- vector(mode="numeric",length=10)
for (i in seq_along(myDat)) {
 myDat[i] <- round(runif(1),digits=2) 
 cat("loop number = ",i, 
     "vector element = ",myDat[i],"\n")
}

# do not change object dimensions in a loop
# (c, rbind, cbind, list) <- just set the vector to the longest it could possibly be outside a loop

myDat <- runif(1)
for (i in 2:10) {
  temp <- round(runif(1),digits=2)
  myDat <- c(myDat,temp)
  cat("loop number = ",i, 
      "vector element = ",myDat[i],"\n")
}

# do not use a loop if you don't need to
 myDat <- 1:10
 for (i in seq_along(myDat)) {
   myDat[i] <- myDat[i] + myDat[i]^2
   cat("loop number = ",i, 
       "vector element = ",myDat[i],"\n")
 }
 z <- 1:10
 z <- z + z^2
 z
 # above will generate the same answers as the for loop without using a for loop!
 
 # be aware of i versus z[i]
 
 z <- c(10,2,4)
 
 for (i in seq_along(z)) {
   cat("i = ",i, "z[i] = ",z[i],"\n")
 }
 
 # use next in the loop to skip certain elements
 z <- 1:20
 
 # can we coperate on the odd-number elements?
 # %% special R function that modulus or remainder function from a division operation
 
 for (i in seq_along(z)) {
   if (i %% 2 == 0) next 
   print(i)
 }
 
 # a faster better way to do this
 z <- 1:20
 zsub <- z[z %% 2!=0]
 z %% 2!=0 
 zsub <- z[z %% 2!=0]
 zsub
 
 for (i in seq_along(zsub)) {
   cat("i = ",i, "zsub[i] = ",zsub[i],"\n")
 }
   
 
 
 # use break to conditionally get out of a loop
 
 ########################################################################
 # FUNCTION: RanWalk
 # stochastic random walk (for of an exponential growth model depending on what terms we put in
 # Inputs: 
 #      n1 = initial population size, 
 #      lambda = finite rate of increase, 
 #      times = number of time steps
 #      noiseSD = sd of normal distribution with mean = 0
 # Outputs: vector n with population sizes > 0 
 #          until extinction NA
 #-----------------------------------------------------------------------
library(tcltk)
RanWalk <- function(times=100,
                    n1=50,
                    lambda=1.001,
                    noiseSD=10)
n <- rep(NA,times)
n[1] <- n1 
noise <- rnorm(n=times,mean=0,sd=noiseSD)

for (i in 1:(times-1)) {
  n[i+1] <- lambda*n[i] + noise[i]
  if(n[i+1] <= 0){
    n[i+1] <- NA
    cat("Population extinction at time",
        i-1,"\n")
        tkbell()
        break } # end of conditional statements
} # end of for loop
return(n)
} # end of function
head(RanWalk())
plot(RanWalk(lambda=1,noiseSD=5),type="o")

# Using double for loops
# loops over rows
m <- matrix(round(runif(20),digits=3),nrow=5)

for (i in 1:nrow(m)) {
  m[i,] <- m[i,] + i
}

print(m)


# loop over columns
m <- matrix(round(runif(20),digits=3),nrow=5)
for (j in 1:ncol(m)) {
  m[,j] <- m[,j] + j
}
print(m)

# double loop over rows and columns
m <- matrix(round(runif(20),digits=3),nrow=5)
for (i in 1:nrow(m)) {
  for (j in 1:ncol(m)) {
    m[i,j] <- m[i,j] + i + j
  } # end of column loop j
} # end of row loop i
print(m)

# write functions to sweep over model parameters

########################################################################
# FUNCTION: SpeciesAreaCurve
# power function for S and A
# Inputs: A is a vector of island areas, C is a intercept constant, Z is the slope constant
# Outputs: S is a vector of predicted species richness
#-----------------------------------------------------------------------
SpeciesAreaCurve <- function(A=1:5000,
                             c=0.5,
                             z=0.26) {
  S <- c*(A^z)
  
  
  
  return(S)
}

head(SpeciesAreaCurve())


########################################################################
# FUNCTION: SpeciesAreaPlot
# plot the species area curve
# Inputs: A = vector of island areas,
#         C = single parameter for constant
#         Z = single parameter for slope
# Outputs: smoothed graph with parameters shown
#-----------------------------------------------------------------------
SpeciesAreaPlot <- function(A=1:5000,
                         c=0.5,
                         z=0.26) {
  
plot(x=A,y=SpeciesAreaCurve(A,c,z),
     type="l",xlab="Island Area",ylab="S",ylim=c(0,1000))
  
  mtext(paste("c = ",c,"z = ",z), cex=0.7)
  
  return()
}

SpeciesAreaPlot()

# Now sweep and build a grid of plots!

# global variales
cPars <- c(100,150,175)
zPars <- c(0.10,0.16,0.26,0.3)
par(mfrow=c(3,4))

for (i in seq_along(cPars)) {
  for (j in seq_along(zPars)) {
    SpeciesAreaPlot(c=cPars[i],z=zPars[j])
  }
}

# looping with for
cutPoint <- 0.0001 
z <- NA
ranData <- runif(100)
for ( i in seq_along(ranData)){
  z <- ranData[i]
  if (z < cutPoint) break
}
print(z) # this will just print the last z value because it is unlikely that any of out 100 randomly generated number is less than 0.0001 so it never broke away from the loop


# looping with while

z <- NA
cycleNumber <- 0
while (is.na(z) | z >= cutPoint) {
  z <- runif(1)
  cycleNumber <- cycleNumber + 1
}
print(z)
print(cycleNumber)


# looping with repeat # Nick's preferred way
z <- NA
cycleNumber <- 0
repeat {
  z <- runif(1)
  cycleNumber <- cycleNumber + 1
  if  (z <= cutPoint) break
}
print(z)
print(cycleNumber)

