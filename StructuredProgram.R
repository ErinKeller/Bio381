# Illustration of structured pragramming
# 09 March 2017
# Erin L. Keller

########################################################################
# FUNCTION: GetData
# read in a .csv file
# Inputs: .csv file
# Outputs: data frame
#-----------------------------------------------------------------------
GetData <- function(fileName=NULL) {
  if(is.null(fileName)) {
    dataFrame <- data.frame(ID=1:10,
                            varA <- runif(10),
                            varB <- runif(10))
  } else {
    dataFrame <- read.table(file=fileName,
                            header=TRUE,
                            sep=",",
                            stringsAsFactors=FALSE)
  }
  
  return(dataFrame)
}
GetData()
########################################################################
# FUNCTION: FitRegressionModel
# Fits an ordinary least squares regression
# Inputs: x and y numeric vectors or same length
# Outputs: entire model summary from lm
#-----------------------------------------------------------------------
FitRegressionModel <- function(xVar=runif(10),
                               yVar=runif(10)) {
  dataFrame <- data.frame(xVar,yVar)
  regModel <- lm(yVar~xVar,data=dataFrame)
  
  return(summary(regModel))
}
########################################################################
# FUNCTION: SummarizeOutput
# pull elements from lm model summary list
# Inputs: list fromt model summary call of lm
# Outputs: vector of regression residuals
#-----------------------------------------------------------------------
SummarizeOutput <- function(z=NULL) {
  if(is.null(z)) {
    z <- summary(lm(runif(10)~runif(10)))
  }
  
  return(z$residuals)
}
# will give you an error message because there are no column or row names but the function will work and return the correct output
########################################################################
# FUNCTION: GraphResults
# graph data and fitted OLS line
# Inputs: x and y vectors of numeric, same length
# Outputs: creates graph
#-----------------------------------------------------------------------
graphResults <- function(xVar=runif(10),
                         yVar=runif(10)) {
  dataFrame <- data.frame(xVar,yVar)
  plot(y=dataFrame$yVar,
       x=dataFrame$xVar,
       pch=21,
       bg="lightblue",
       cex=2)
  
  regModel <- lm(yVar~xVar,data=dataFrame)
  abline(regModel)
  
  message("Message: Regression graph created") # message will write something to the screan in pink lettering stating that we have created a graph
}
#-----------------------------------------------------------
# Global variables
antFile <- "antcountydata.csv" # New England ant data
xCol <- 7 # 7 refers to particular column in the data ; column 7 = latitude centroid of county
yCol <- 5 # column 5 = number of ant species
#-------------------------------------------------------------------------

# Program Body
temp1 <- GetData(fileName=antFile)
x <- temp1[,xCol]
y <- temp1[,yCol]
temp2 <- FitRegressionModel(xVar=x,yVar=y)
temp3 <- SummarizeOutput()
GraphResults()

print(temp3)
