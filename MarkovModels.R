# Demonstration of Markov models and popbio library
# 13 April 2017
# ELK

install.packages("popbio")
library(popbio)
stages <- c("Disturbed", "Grassland", "Forest")
A <- matrix(c(0.3, 0.4, 0.3,
              0.0, 0.1, 0.2,
              0.7, 0.5, 0.1),
            nrow=3,
            byrow=TRUE, dimnames=list(stages,stages)) # row, column
n <- c(100,0,0) # initial vector aka sites in each type
timesteps=10
print(A)

MarkovOut <- pop.projection(A=A,n=n,iterations=timesteps) # pop.projection needs A matrix, initial state, and how many time steps aka iterations
stage.vector.plot(MarkovOut$stage.vectors,col=2:4) # plotting function. Takes stage vectors and plot them

print(MarkovOut)


##################################################
# function: plotCounts
# plot raw counts of states at each time step
# input: matrix (rows=stages, cols=times)
# output: plot
#------------------------------------------------- 
plotCounts <- function(m=matrix) {
  par(mfrow=c(1,2))
  
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
          type="o",
          col=i+1,
          lty=i,
          lwd=2)
  }
  stage.vector.plot(MarkovOut$stage.vectors,col=2:(nrow(m)+1))
  par(mfrow=c(1,1))
}
plotCounts(MarkovOut$stage.vectors)

# hypothesis: proportions in patches are constant regardless of starting point
# hypothesis: constant numbers only result when column sums are all 1.0

# data from Gotelli N.J. and A.M. Ellison. 2002. Nitrogen deposition and extinction risk in the northern pitcher plant, Sarracenia purpurea. Ecology 83: 2758-2765.

# Sarracenia purpurea = long lived bog plants with 4 different stages
stages <- c("Recruit","Juvenile","NFAdult","FAdult")
timesteps=100
n=c(50,50,50,50)
A <- matrix(c(0,0,0,4,
              0.1, 0.854, 0.177, 0,
              0, 0.131, 0.708, 0.660,
              0,0,0.1,0.307),nrow=4,byrow=TRUE,dimnames=list(stages,stages)
# First column: what happens to the recruit (probability of transitioning into the different stages
# Second column: " " but with Juvenile
# thesse will not add up to 1 because of the mortality 
MarkovOut <- pop.projection(A=A,n=n,iterations=timesteps)
plotCounts(MarkovOut$stage.vectors)

# NETWORK DIAGRAM
# nodes = stages
# edges = arrows, i.e. transition to different stage (non-zero element, no arrow = 0)
# new network analysis tools can be applied to these

print(MarkovOut$lambda)  # 1.005225 is the percent increase/year
print(MarkovOut$stable.stage) # stable stage distribution 
print(head(MarkovOut$pop.sizes)) # record of population sizes
print(tail(MarkovOut$pop.sizes)) # end population sizes
eigen.analysis(A) # sensitivities - which stage change accounts for the most of population changes this 
# elasticity analysis - scales to relative changes in values


### AGE BASE MODELS


# data simplified from Slade N.A. and D.F. Balph. 1974. Population ecology of Uinta ground squirrels. Ecology 55: 989-1003

# in this model, stages are actually the ages of individuals 
# first row is the fedundity of females at each different age
# diagonal values is the probability of making it to the next year (i.e. survivorship)
stages <- as.character(0:8)
timesteps=150
n= rep(20,9)
A <- matrix(c(0,0,0.646,3,2.17,0,1.054,0,2.214,
              0.662,0,0,0,0,0,0,0,0,
              0,0.501,0,0,0,0,0,0,0,
              0,0,0.756,0,0,0,0,0,0,
              0,0,0,0.142,0,0,0,0,0,
              0,0,0,0,0.566,0,0,0,0,
              0,0,0,0,0,0.026,0,0,0,
              0,0,0,0,0,0,0.103,0,0,
              0,0,0,0,0,0,0,0,0.000),nrow=9,byrow=TRUE,dimnames=list(stages,stages))
print(A)
MarkovOut <- pop.projection(A=A,n=n,iterations=timesteps)
plotCounts(MarkovOut$stage.vectors)
print(MarkovOut$lambda) # pop growth rate = 1.011263
print(MarkovOut$stable.stage) # declines from newborns to the upper age classes because probability of survivorship decreases
print(head(MarkovOut$pop.sizes))
print(tail(MarkovOut$pop.sizes))
eigen.analysis(A)
# damping ratio is the measure of its mathematical stability - how stable is this growth curve/trajectory? 

# Data from Diamond, S. E., L. M. Nichols, S. L. Pelini, C. A. Penick, G. W. Barber, S. H. Cahan, R. R. Dunn, A. M. Ellison, N. J. Sanders, and N. J. Gotelli. 2016. Climatic warming destabilizes forest ant communities. Science Advances 2.

# transition matrix from control 5C heated chamber
stages <- c("Empty",paste("Species",LETTERS[1:3]))
timesteps=70
n= rep(20,4)
A <- matrix(c(245,14,8,0,
              18,17,0,2,
              8,1,0,5,
              1,0,0,1) ,nrow=length(stages),byrow=TRUE,dimnames=list(stages,stages)) 
print(A)

A <- apply(A,2, function(x) x/sum(x)) # convert raw counts to column proportions # function(x) = anonymous function, one shot thing for a one-time function, x/sum(x) means take the x vector and divide it by the total to make proprtions
print(A)

MarkovOut <- pop.projection(A=A,n=n,iterations=timesteps)
plotCounts(MarkovOut$stage.vectors)
print(MarkovOut$stable.stage)    
eigen.analysis(A)

# transition matrix from control (=unheated) chamber
stages <- c("Empty",paste("Species",LETTERS[1:3]))
timesteps=70
n= rep(20,4)
A <- matrix(c(202,14,13,0,
              18,9,2,0,
              13,1,35,1,
              1,0,0,11) ,nrow=length(stages),byrow=TRUE,dimnames=list(stages,stages)) 
print(A)
A <- apply(A,2, function(x) x/sum(x)) # convert raw counts to column proportions
print(A)
MarkovOut <- pop.projection(A=A,n=n,iterations=timesteps)
plotCounts(MarkovOut$stage.vectors)
print(MarkovOut$stable.stage) 
eigen.analysis(A)

install.packages("gtools")
