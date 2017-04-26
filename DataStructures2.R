# Matrices, lists, data frames
# 16 February 2017
# ELK


# Matrices
a <- 1:12 # sequences function 
print(a)

# creating a matrix from an atomic vector

m <- matrix(data=1:12,nrow=4,ncol=3) # only need rows or columns and R will know how to make it
print(m)

m <- matrix(data=1:12,nrow=4,byrow=TRUE) #byrow=TRUE means that sequential items will go across rows
print(m)

# Use dim() which will give you #rows and #columns
dim(m)

# We can also use dim() to change matrix format: (product of rows and coluns ust equal the number of items)

dim(m) <- c(6,2)
print(m)
dim(m) <-c(4,3)
print(m)

# Basic dimesions of the matrix
# ncol and nrow will alos give you # of rows and columns
nrow(m)
ncol(m)
length(m) # this will give you length of vector
print(m)

# adding names to rows and columns
names(m)

# add names with an assignment
rownames(m) <-c("a","b","c","d")
print(m)
colnames(m) <- LETTERS[1:ncol(m)] # you can call another function so you don't have to worry about the actual number of columns
print(m)
rownames(m) <- LETTERS[rep(1,4)] # this is a way you could feasibly name all columns or rows the same name
print(m)
rownames(m) <- LETTERS[1:4]
print(m)
rownames(m) <- letters[nrow(m):1] # this will make the first label a d and go down
print(m)

# simple subsetting
# print a single element
print(m[2,3]) # this will give you an element in the position you specify
print(m["c","C"]) # same as above but you put in the name of the rows and columns

# print an entire row or column with empty subscript

# print row 3
print(m[3,])

# print first column
print(m[,1])

# all of the following will print the matrix (we only will use the first for obvious reasons
print(m)
print(m[,])
print(m[])

# using paste function for automating names
rownames(m) <- paste("Site",1:nrow(m),sep="")
colnames(m) <- paste("Species",LETTERS[1:ncol(m)],sep="")
print(m)

# transpose matrix very easily with t
m2 <- t(m)
print(m2)

# add a row to m with rbind()
m2 <- rbind(m2,c(10,20,30,40)) # this will not add a new row name!
print(m2)
rownames(m2)
rownames(m2)[4] <- "myFix"
print(m2)

# add a column with cbind()
m2 <- cbind(c(0.2,0.4,0.6,0.8),m2) # order of elements is important!
print(m2)

# access individual or compound elements
m2["SpeciesA","Site2"] # equals m2[1,3]
m2[c("SpeciesB","SpeciesC"),c("Site1","Site4")]

# transform matrix back to vector 
myVec <- as.vector(m)
print(myVec)

# lists are atomic vectors but each element can be any type we want and can hold other structures including other lists

myList <- list(1:10,matrix(1:8,nrow=4,byrow=TRUE),letters[1:3],pi)

# including other lists
print(myList)
str(myList)
myList[4]
myList[4] - 3 # you will get an error because it will just tell you what item it is rather than pulling the item
myList[[4]] - 3# the oduble bracket allows you to grab item in a list (it won't keep it as a list item)

# ruppose a list with 10 elements in it
# [[5]] equals contents of car #5
# [c(4,5,60] equals a little train of cars 4,5, and 60

myList[[2]]
myList[[2]][3,2]

# pulling out results from stats in R with a list
varY <- runif(10)
varX <- runif(10)
myModel <- lm(varY~varX) # lm = linear model, response variable is a function of a predictable variable
print(myModel)
summary(myModel) # summary actually gives more data
plot(x=varX,y=varY)
plot(myModel)

# figure out structure of myModel
str(summary(myModel))
names(summary(myModel))
summary(myModel)$coefficients
print(summary(myModel)$coefficients[2,4])
