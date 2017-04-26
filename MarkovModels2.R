# Unertainty and stochastic environments in matrix models
# April 18 2017
# ELK

library("gtools")
library(popbio)
stages <- c("Empty",paste("Species",LETTERS[1:3]))
timesteps=70
n= rep(20,4)
A <- matrix(c(245,14,8,0,
              18,17,0,2,
              8,1,0,5,
              1,0,0,1) ,nrow=length(stages),byrow=TRUE,dimnames=list(stages,stages)) 
print(A)
A <- apply(A,2, function(x) x/sum(x)) # convert raw counts to column proportions
print(A)
damping.ratio(A)
####################################################
# use beta distribution to sample probabilities, given number of successes/failures
# shape1 = number of successes + 1
# shape2 = number of failures + 1

##################################################
# function: betaSampler
# generate a transition matrix from samples of raw counts
# input: matrix of raw transition counts
# output: matrix of transition probabilities sampled from beta
#------------------------------------------------- 
betaSampler <- function(m=matrix(rpois(n=16,lambda=5),nrow=4)) {
  print(m)
  z <-m
  z[] <- 0
  for (i in 1:nrow(m)){
    for (j in 1:nrow(m)){
      z[i,j] <- rbeta(1,shape1=z[i,j] + 1,
                      shape2= sum(z[,j]) - z[i,j] + 1)
    }
  }
  print(z) 
  z <- apply(z,2, function(x) x/sum(x))
  return(z)
  
}
betaSampler(A) # values look very biased! why? serial application of beta! 

# rbinom(prob of success, prob of failure (add up to 1)) -> counts of number of success and number of failures
# rbeta to get from counts to probs
# rbeta (number success, number failures) --> probability of success/failure
# multinomial function
# rmultinom(prob1, prob2, prob3, prob4) --> n1, n2,n3, n4
# dirichlet model allows you to go to probabiliities of multinomial data
# dirichlet(n1,n2,n3,n4) --> p1, p2, p3, p4

library(gtools) 
x <- rdirichlet(5, c(245,18,8,1))# two elements: 1, ?, 2 raw counts
print(x)


##################################################
# function: dirichletSampler
# Creates transition matrix with sampling uncertainty
# input: matrix of raw transition counts
# output: matrix of transition probabilities sampled from a Dirichlet for each column
#------------------------------------------------- 
dirichletSampler <- function(m=matrix(rpois(n=16,lambda=5),nrow=4)) {
  z <- apply(m+1,2,rdirichlet,n=1)
  
  return(z)
}

dirichletSampler(A) # run on original matrix; what is wrong? add one to all params (m+1) and this will make the results more appropriate 

temp <- replicate(10,dirichletSampler(A)) # create a little data set of 10
print(temp) # looks like an array!
str(temp)
temp2 <- apply(temp,3,damping.ratio) # use apply over the third dimension to extract the damping ratio  for each matrix --> vector of damping ratios
print(temp2)
str(temp2)

hist (replicate(1000,damping.ratio(dirichletSampler(A))),breaks=25)
A <- matrix(c(245,14,8,0,
              18,17,0,2,
              8,1,0,5,
              1,0,0,1) ,nrow=length(stages),byrow=TRUE,dimnames=list(stages,stages)) 

damping.ratio(A) # why off? need to rescale

scaledA <- apply(A,2, function(x) x/sum(x)) # original matrix has to be scaled!
damping.ratio(scaledA)
simDat <- replicate(1000,damping.ratio(dirichletSampler(A)))
hist (simDat,
      breaks=25,
      col="goldenrod")
abline(v=damping.ratio(scaledA),col="red") # shows uncertainty and potential bias
z <- quantile(simDat,probs=c(0.025,0.975))
abline(v=z,lty="dashed")
print(z) # z = quantiles, uncertainty based on number of observations



# Transition matrices in varying environments

mGood <- matrix(c(0.2,0.1,0.1,
                  0.8,0.5,0.1,
                  0.0,0.4,0.8),
                nrow=3,
                byrow=TRUE)
patchTypes=c("Empty","Grassland","Forest")
dimnames(mGood) <- list(patchTypes,patchTypes)
 print(mGood)

mBad <- mGood
mBad[1,] <- c(0.8,0.5,0.1)
mBad[2,] <- c(0.2,0.5,0.8)
mBad[3,] <- c(0.0,0.0,0.1)
print(mBad)

patch0 <- c(10,50,40) # patch0 = initial conditions

##################################################
# function: matStep
# multiplies a matrix transition for a single time step, calculates a transition for a single step
# input: transition matrix and patch vector(t)
# output: patch vector (t + 1)
#------------------------------------------------- 
matStep <- function(m=NULL,p=NULL) {
  if(is.null(m)){
    m <- matrix(runif(9),nrow=3)
    p <- c(40,30,30)
  }
  m <- apply(m,2,function(x) x/sum(x)) # make sure transition matrix columns are scaled
  mn <- m%*%p # R's function for a matrix multiplication
  return(mn)
}
matStep()

##################################################
# function: matFill
# multiplies a series of matrices by an initial patch vector to create a set of patches that change
# through time
# input: array of patch transition matrices, one for each time step, initial patch vector
# output: matrix of patch transitions, starting from intial vector

# A matrix (varies at each time step) * by n at time t --> n at time t+1
#------------------------------------------------- 
matFill <- function (am=NULL, p=NULL) {
  if(is.null(am)){
    am <- array(runif(90),dim=c(3,3,10)) # array(number of obs, dimensions of structure. total of dimensions (3*3*10) must equal the number of observations
    p <- c(40,30,30)
  }
  am <- apply(am,c(2,3),function(x) x/sum(x)) # make sure transition matrix columns are scaled, applying to both the 2nd and 3rd dimensions to rescale to columns of the matrices
  ap <- matrix(0,nrow=length(p),ncol=dim(am)[3]) # needs to be equal to patch vector
  ap[,1] <- p
  
  for (i in 2:dim(am)[3]) {
    ap[,i] <- matStep(m=am[,,i],p=ap[,i-1]) # to pull out matrix at time i
  }
  return(ap) 
}
matFill()


##################################################
# function: matSeq
# takes 2 input matrices and establishes order of good and bad year matrices
# input: good transition matrix, bad transition matrix, length of series, p(bad year)
# output: array of t consecutive n x n transition matrices
#------------------------------------------------- 
matSeq <- function (mG=NULL, mB=NULL,Times=NULL,pBad=NULL) {
  if(is.null(mG)){
    mG <- matrix(runif(9),nrow=3)
    mB <- matrix(runif(9),nrow=3)
    Times <- 10
    pBad <- 0.5
  }
  mG <- apply(mG,2,function(x) x/sum(x)) # make sure transition matrix columns are scaled
  mB <- apply(mB,2,function(x) x/sum(x)) # make sure transition matrix columns are scaled
  mSer <- array(0,dim=c(nrow(mG),ncol(mG),Times)) # array filled with 0s 
  x <- runif(Times) # random uniforms for choosing matrices
  ################################################
  # alternate code for creating a correlated random walk of good and bad years!  
   x2 <- runif(Times) - 0.5 # a series of random numbers ~ half positive, half negative
   x[1] <- 0
   for (i in 2:Times) {
     x[i] <- x[i-1] + x2[i] # start at 0, walk randomly up or down in each step
   }
   pBad <- 0 # call the "negatives" bad years
  mSer[,,x>pBad] <- mG
  mSer[,,x<=pBad] <- mB
  return(mSer)
}
##################################################
# function: plotCounts2
# plot raw counts of states at each time step
# input: matrix (rows = stages, columns = times)
# output: plot
#------------------------------------------------- 
plotCounts2 <- function(m=matrix(runif(30),nrow=3,ncol=10)) {
  
  plot(x=1:ncol(m),
       y=m[1,],
       type="o",
       ylab="Frequency",
       xlab="Time",
       ylim=c(0,max(m)),
       col="red",
       lwd=2)
  for (i in 2:nrow(m)){
    lines(x=1:ncol(m),
          y=m[i,],
          type="l",
          col=i+1,
          lty=i,
          lwd=2)
  }
}
# body of the program
mt <- matSeq(mG=mGood,mB=mBad,Times=100,pBad=0.1) # set up the matrices in each time
SimResult <- matFill(am=mt,p=patch0) # take down mt array and patch0, output in SimResult matrix, rows = patch types, columns = time steps
plotCounts2(SimResult)
# change times and frequency of bad years for fun
