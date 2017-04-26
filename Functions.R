# Working with functions
# 2 March 2017
# ELK

# everything in R is a function
sum(3,2) # "prefix" function
3 + 2 # "operator" is a function
`+`(3,2) # "infix" function
y <- 3
`<-` (yy,3) # infix
print(yy)

# to see the contents of a function, print it
print(read.table) # this will show you how much R code goes into a single function
sum(3,2)
print(sum) # some of R's functions are coded in C++ and are called "primitive" functions that run faster because they are coded with C++
sum() # when we call functions without any input, there is always a built-in default (for this example, the fault will spit out 0)


###########################################################################
# FUNCTION: HardyWeinberg
# Input: p, an allelic frequency (0,1)
# Output: p and three genotype frequencies AA, AB, BB
# -------------------------------------------------------------------------
HardyWeinberg <- function(p=runif(1)){
  q <- 1 - p
  fAA <- p^2
  fAB <- 2*p*q
  fBB <- q^2
  
  vecOut <- signif(c(p=p,AA=fAA,AB=fAB,BB=fBB),digits=3)
  return(vecOut)
} 
############################################################################
HardyWeinberg() # this will run the function with the default values, output is below
#     p     AA     AB     BB 
# 0.8850 0.7830 0.2040 0.0132 
# when testing a function, run it once from the script then use the up arrow and enter to run the function a bunch of times with new data sets (due to the runif function we used)
pp <- 0.7
HardyWeinberg(p=pp) # good to show what parameter each value is associated with
HardyWeinberg(1.2)

# Use multiple return() statements to generate different outcomes
###########################################################################
# FUNCTION: HardyWeinberg2
# Input: p, an allelic frequency (0,1)
# Output: p and three genotype frequencies AA, AB, BB
# -------------------------------------------------------------------------
HardyWeinberg2 <- function(p=runif(1)){
  if(p > 1.0 | p < 0.0) { # in a "if" commmant, | indicates "or", the return must be surrounded by {} this will not work when dealing with an error.... we want the program to stop entirely
    return("Function failure: p must be >= 0 and <=1") 
  }
  q <- 1 - p
  fAA <- p^2
  fAB <- 2*p*q
  fBB <- q^2
  
  vecOut <- signif(c(p=p,AA=fAA,AB=fAB,BB=fBB),digits=3)
  return(vecOut)
} 
############################################################################
HardyWeinberg2()
HardyWeinberg2(0.5)
pp <- 1.2
HardyWeinberg2(pp)
z <- HardyWeinberg2(1.2) # this runs when it shouldn't! What is in z right now is a character string with one element... this will become an error later

###########################################################################
# FUNCTION: HardyWeinberg3
# Input: p, an allelic frequency (0,1)
# Output: p and three genotype frequencies AA, AB, BB
# -------------------------------------------------------------------------
HardyWeinberg3 <- function(p=runif(1)){
  if(p > 1.0 | p < 0.0) { 
    stop("Function failure: p must be >= 0 and <=1") # the stop funciton is distinct from the return function and it will not let the function run
  }
  q <- 1 - p
  fAA <- p^2
  fAB <- 2*p*q
  fBB <- q^2
  
  vecOut <- signif(c(p=p,AA=fAA,AB=fAB,BB=fBB),digits=3)
  return(vecOut)
} 
############################################################################
HardyWeinberg3(pp) # now we get an error message: Error in HardyWeinberg3(pp) : Function failure: p must be >= 0 and <=1 # it comes out in pink which means that there has been a coding error and the program will not run. Stop function works for true error trapping

# Scoping in functions
# global variables: not in functions, visible to all parts of code, decalared in main body
# local variables: only live inside the function that has made them, only visible within the function, created in function or passed through as parameter... so we could use the same variable names that are in functions 

myFunc <- function(a=3,b=4){
  z <- a + b
  return(z)
}
myFunc() # output = 7
print(b) # we can't print a local variable and we get the following error message: Error in print(b) : object 'b' not found

myFuncBad <- function(a=3) {
  z <- a + b
  return(z)
}
myFuncBad() # you will get an error message if you run this because you have not defined a needed parameter (b) in either a global or local environment: Error in myFuncBad() : object 'b' not found
b <- 10
myFuncBad() # now the function runs because we have defined b in the global environment. The function will preferentially use locally defined variables and then search globally. It is not good practice to have global variables being used as parameters, we want to stay local as much as possible

myFuncOK <- function(a=3) {
  bb <- 100
  z <- a + bb
  return(z)
}
myFuncOK() # now it will run because it is calling local variables rather than global variables

# Simple linear regression function

############################################################################
# FUNCTION: fitLinear
# Description: fits a simple OLS regression
# Inputs: numeric vector of predictor (z) and response (y)
# Outputs: slope and p-value
#---------------------------------------------------------------------------

fitLinear <- function(x=runif(10),y=runif(10)) {
  myMod <- lm(y~x)
  myOut <- c(slope=summary(myMod)$coefficients[2,1],pValue=summary(myMod)$coefficients[2,4])
  plot(x=x,y=y)
  return(myOut)
}
############################################################################
fitLinear # using defaults this is an example of the output:     
# slope    pValue 
# 0.1916850 0.5399949 

############################################################################
# FUNCTION: fitLinear2
# Description: fits a simple OLS regression
# Inputs: numeric vector of predictor (z) and response (y)
# Outputs: slope and p-value
#---------------------------------------------------------------------------

fitLinear2 <- function(x=NULL,y=NULL) {
  if(is.null(x) & is.null(y)) {
    x <- runif(20)
    y <- 0.5 + 2*x +rnorm(n=20,mean=0,sd=0.2)
  } # this will only occur if we run the defaults only and this code will generat a linear relationship between x and y with additional noise (rnorm part)
  
  myMod <- lm(y~x)
  myOut <- c(slope=summary(myMod)$coefficients[2,1],pValue=summary(myMod)$coefficients[2,4])
  plot(x=x,y=y)
  return(myOut)
}
#############################################################################
fitLinear2()

# Passing a parameter list with do.call
z <- c(runif(99),NA) # creating a data string with the last element being NA
mean(z) # get NA as a result because the function doesn't know what to do with NA in the data so we can:
mean(x=z,na.rm=TRUE) # no we will get the correct mean 
mean(x=z,na.rm=TRUE,trim=0.05) # trim will throw out the upper and lower 5% of the data (outliers)
parList <- list(x=z,na.rm=T,trim=0.05) # we can create a list of parameters and call them with do.call when we want a function to use those parameters
do.call(mean,parList) # and this returns the correct value with the parameters
