# using for loops to sweep model parameters
# 6 April 2017
# ELK
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

cPars <- c(100,150,175)
zPars <- c(0.10,0.16,0.26,0.30)
expand.grid(cPars,zPars) # takes any vectors, even character strings, and creates a data frame that  has those two vectors as columns

########################################################################
# FUNCTION: myExpandGrid
# home grown expand grid function for 2 variables
# Inputs: 2 vectors (any type)
# Outputs: data frame with parameters swept
#-----------------------------------------------------------------------
myExpandGrid <- function(a=1:4,b=c(300,400,500)) {
  Factor1 <- rep(a,times=length(b))
  Factor2 <- rep(b, each=length(a))
  return(list(varA=Factor1,varB=Factor2))
}
myExpandGrid()

########################################################################
# FUNCTION: SA_Output
# grab results from species vector
# Inputs: vector of species richness from SA function
# Outputs: list of max-min (biggest difference), and coefficient of variation 
#-----------------------------------------------------------------------
SA_Output <- function(S=1:10) {
  
  sumStats <- list(SDelta <- max(S) - min(S), 
                   SCV=sd(S)/mean(S))
  return(sumStats)
}


# Build program body with a single loop through the parameters in modelFrame


Area <- 1:5000
cPars <- c(100,150,175)
zPars <- c(0.10,0.16,0.26,0.30)

# set up model frame
modelFrame <- expand.grid(c=cPars,z=zPars)
modelFrame$SDelta <- NA
modelFrame$SCV <- NA
print(modelFrame)


# cycle through model calculations

for (i in 1:nrow(modelFrame)) {
  # generate S vector
  temp1 <- SpeciesAreaCurve(A=Area, c=modelFrame[i,1],z=modelFrame[i,2])
  
  # calculate output stats
  temp2 <- SA_Output(temp1)
  
  # pass results fback to modelFrame
  modelFrame[i,c(3,4)] <- temp2
  
} # close loop

print(modelFrame)

# Sweeping parameters for a stochastic model


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
                    noiseSD=10) {
  n <- rep(NA,times)
n[1] <- n1 
noise <- rnorm(n=times,mean=0,sd=noiseSD)

for (i in 1:(times-1)) {
  n[i+1] <- lambda*n[i] + noise[i]
  if(n[i+1] <= 0) {
    n[i+1] <- NA
#    cat("Population extinction at time",
        i-1,"\n")
#    tkbell()
    break } # end of conditional statements
} # end of for loop
return(n)
} # end of function

########################################################################
# FUNCTION: rWalkOutput
# summarizes univariate metric to describe population trajectory
# Inputs: vector of population sizes
# Outputs: length of positive elements in vector
#-----------------------------------------------------------------------
rWalkOutput <- function(v=c(1:10,c(NA,NA))) {
  lenPop <- length(v[is.na(v)==FALSE]) # take vector v and subset only the elements that do not have an NA 
  
  return(lenPop)
}


# global variables
SerLen <- 500 # length of each population run
lambda <- c(0.95,0.99,1.00,1.01,1.05)
noiseSD <- c(0,5,10,20)
n1 <- 50 # initial population size
reps <- 20 # number of replications for each parameter combination 

# create output structure 

ranOut <- expand.grid(n1=n1,
                      reps=reps,
                      SerLen = SerLen,
                      lambda=lambda,
                      noiseSD=noiseSD)
# add summary response variables
ranOut$meanLen <- NA
ranOut$sdLen <- NA

SurvTime <- rep(NA,reps) # vector to hold survival times


# begin program body
for (i in 1:nrow(ranOut)) { # start of parameter loop
  for (j in 1:reps) { # start of replicate loop
    temp <- RanWalk(times=ranOut$SerLen[i],
                    n1=ranOut$n1[i],
                    lambda=ranOut$lambda[i],
                    noiseSD=ranOut$noiseSD[i])
    SurvTime[j] <- rWalkOutput(temp)
  } # end of replicate loop
  
  ranOut$meanLen[i] <- mean(SurvTime)
  ranOut$sdsLen[i] <- sd(SurvTime)
} # end of paramter loop

print(ranOut)
                      