### Randomization Tests
### 11 April 2017
### ELK

# Randomization tests - 
# 1. define univariate metric x (single number that characterizes a pattern we are interested in)
# 2. calculate x for observed data xobs (is this number unusually large or small?)
# 3. randomize data subject to some costraints (some features of the data will be preserved so that the test is realistic)
# 4. calculate x for randomized data xsim
# 5. repeat step 4 many times (n=1000) - generates a disibution of xsim that we can visualize ass a histogram --> H0 (null hypothesis)
# 6. compare Xobs to Xsim - probality of Xobs given H0, estimate tail probability which is the probability that, by chance, you observe a value somewhere in the tail
# 7. draw biological inference from this

# Compare ant species richness among different New Egland ecotypes (major habitat types deliminated on a map)
data <- read.table(file="antcountydata.csv",header=TRUE,sep=",", stringsAsFactors = FALSE)
data$ecoregion <- as.factor(data$ecoregion) # this will reclassify the variable ecoregion to a factor
boxplot(data$n.species~data$ecoregion, col="indianred")
myModel <- aov(data$n.species~data$ecoregion,data=data)
summary(myModel) 

# define response metric
# use variance among treatment means as X

########################################################################
# FUNCTION: VarMeans
# calculates variance among a group of treatment means 
# Inputs: Vector of groups, vector of group means
# Outputs: among group variance of means
#-----------------------------------------------------------------------
VarMeans <- function(fac=NULL,res=runif(25)) {
  if(is.null(fac)){
    fac <- as.factor(rep(LETTERS[1:5],each=5))
  }
  temp <- aggregate(x=res,by=list(fac),FUN=mean) # this is a functional function because one of its inputs is itself a function
  
    return(var(temp$x)) # comes back in the form of a list/data frame
  # return(var(temp[,2])) this is another way to run it.
}
VarMeans()

# specify treatment randomization

########################################################################
# FUNCTION: TreatRan
# randomize treatment (factor) labels
# Inputs: vector of observed treatment labels
# Outputs: Vector of randomized treatment labels
#-----------------------------------------------------------------------
TreatRan <- function(fac=NULL) {
  if(is.null(fac)){
    fac <- as.factor(rep(LETTERS[1:5],each=5))
  }
  fac <- sample(fac,replace=FALSE) # replace=FALSE is the default parameter, but this is to remind us that we are just shuffling the order and not changing any values
  
  
  return(fac)
}
TreatRan()

# Now write function for summary and plots
########################################################################
# FUNCTION: randomizeSummary
# give summary statistics, boxplots, and histogram plot
# Inputs: vector of simulated values, observed value for the actual data
# Outputs: list of null model statistics, graphs
#-----------------------------------------------------------------------
randomizeSummary <- function(obsX=runif(1),
                             simX=runif(1000),
                             fac=NULL,
                             res=runif(25)){
  if(is.null(fac)){
    fac <- as.factor(rep(LETTERS[1:5],each=5))
  }
  
  pLow <- mean(simX <= obsX) # this is going to give a boolean vector of Trues and Falses. Taking the mean is going to coerce T and F into 0s and 1s so we end up with a proportion 
  pHigh <-  mean(simX >= obsX) # by setting both to be equal to we account for exact ties
  meanSimX <- var(simX)
  varSimX <- var(simX)
  SES <- (obsX-mean(simX))/sd(simX)# SES = standarized effect size; if the observed metric is larger than the simulated --> positive, less than --> negative, at 50% probability --> 0. Roughly is equivalent to standard deviations
  
  outList <- list(stats=list(obsX=obsX,
                             meanSimX=meanSimX,
                             varSimX=varSimX,
                             pLow=pLow,
                             pHigh=pHigh,
                             SES=SES,
                             reps=length(simX)),
                             raw=simX)
  
  par(mfrow=c(1,3))
  
  # Show boxplot of real data
  boxplot(res~fac,col="indianred")
  mtext("Observed Data",side=3,font=2,cex=0.75) # Text is written in one of the four margins (=side) of the current figure region or one of the outer margins of the device region.
  
  # show boxplot of simulated data
  boxplot(res~sample(fac),col="goldenrod")
  mtext("Simulated Data",side=3,font=2,cex=0.75)
  
  # show histogram of simulated and observed values
  hist(simX,breaks=25,
       col="goldenrod",
       main="Null Distriution",
       xlab="Simulated Response",
       xlim=c(0,max(c(simX,obsX)))) # 25 bins is coded by breaks=25
  Interval95 <- quantile(x=simX,probs=c(0.05,0.95))
  Interval975 <- quantile(x=simX,probs=c(0.025,0.975))
  abline(v=obsX,col="indianred",lwd=2)
  abline(v=Interval95,col="black",lwd=2,lty="dotted")
  abline(v=Interval975,col="black",lwd=2,lty="dashed")
  par(mfrow=c(1,1))
  return(outList)
}
z <- randomizeSummary()
#----------------------------------------------------
# global variables
filename <- "antcountydata.csv"
data <- read.table(file=filename,
                   header=TRUE,
                   sep=",",
                   stringsAsFactors=FALSE)
data$ecoregion <- as.factor(data$ecoregion)
grps <- data$ecoregion
richness <- data$n.species
nreps <- 1000
outVec <- vector(mode="numeric",length=nreps)

obsX <- VarMeans(fac=grps,res=richness)

# for (i in 1:nreps) {
#  outVec[i] <- VarMeans(fac=TreatRan(grps), res = richness)
#}

# New function!

# runif(1)
# runif(5)
# replicate(5, runif(1)) 
# replicate(5, runif(3)) # will make a 3x5 matrixm with each column be a repicate run

outVec <- replicate(nreps, VarMeans(fac=TreatRan(grps),
                                    res=richness))
head(outVec) # length = length nreps = 1000 # contained in outVec = variance for each simulated run

z <- randomizeSummary(obsX=obsX,simX=outVec,fac=grps,res=richness)


