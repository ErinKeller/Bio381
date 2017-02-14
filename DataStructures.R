# Basic data structures in R
# 14 February 2017
# ELK

# Use the assingmnet operator to assign variable
x <- 5 # preferred way to assign variables 
y = 4 # legal way to assign variables but confusing
y = y + 1.1 # algebraically this doesn't make sense but it will work (sum would be 5.1)
y <- y + 1.1 # this is a better way (y = 6.2)
# Use print() to print the value or result
print(y)

# Variable names

z <- 3 # begin lower case
plant_height <-3.3 # cannot have space in variable name. Underlines work but looks "gangly"
plant.height <- 4 # periods are sometimes used in functions, though, so also not great
plantHeight <- 3 # camelCaseFormatting. Each time you need a new word you start the word with a capital letter

# the combine function
z <- c(3.2, 5, 5, 6) # z is now a vector
print(z)

# typeof() function will tell you what kind of variable it is
typeof(z) 

# to ask what the status of the variable is we can use the is. function... will give you True or False
is.numeric(z)

z <- c(c(3,4),c(5,6)) # this compound  combined function will flatten things out to a simple atomic vector
print(z)

# character strings surrounded by single or double quotes
z <-c("perch","bass",'trout')
print(z)
z <- c("This is only 'one' character string","this is a second") # you can put interior quotes without making a different string
print(z)

typeof(z) # again, to get the status of a variable
is.numeric(z) # should be false

# building logicals variables 
# no quotes, all caps
z <- c(TRUE, TRUE, FALSE)


### Three properties of vectors
# type
is.logical(z)
typeof(z)
str(z) # tells you what type of data it is, followed by a short look into the string of values

# Length 
length(z)

# Names
z <- runif(5) # runif(#) is a random uniform number generator
print(z)

# names are optional
names(z) # gives you NULL until you assign name
names(z) <- c("chow","pug","beagle","greyhound","akita") # this is the function you use to assign names
print(z)

# add names with variable creation (with or without quotes)

z2 <- c(gold=3.3, silver=10, lead=2) # name of atomic vector comes first followed by value
print(z2)

# reset names
names(z2) <- NULL
print(z2)


### Three features of atomic variables
## Coercion 
z <- c(3,"eggs")
typeof(z) # gives you "character"
print(z) # print is read as characters "3" "eggs" 

# hierarchy of coercion

# logical -> integer -> double -> character

# Comparison operators yield a logic variable

a <-runif(10)
a > 0.5 # is a greater than 0=.5? In this case, it will generate 10 logical elements (falses and trues) corresponding to each element in a
print(a)

# how many elements are greater than 05?
sum(a > 0.5) # will coerce logicals to turn into integer, 0 = False, 1 = True

# what proportion of the elements are greater than 0.5?
mean(a > 0.5) # again this will give you an integer value, the average = proportion

# Qualifying exam question: approximately what proportion of observations drawn from a normal distribution with mean 0, variance 1, are larger than 2.0
mean(rnorm(1000) > 2) #rnorm function will give you 1000 random variables drawm from a normal distribution with a mean of 0 and a variance of 1 # the mean will give you the proportion of values > 2

## Vectorization 
z <- c(10,20,30)
z + 1 # 1 will be added to each element within the vector
y <- c(1,2,3)
z + y # vectorization will add element by element so only 3 outputs (10+1, 20+2, 30+3)

z^2 + z # this will take each element in the z variable and square it followed by adding 10, 20, and 30, respectively

## Recycling 
y <- c(1,2)
z <- c(10,20,30)
y + z # this will fill up as much as it can and then go back to the beginning (in this case, 1 then 2 then 1 ... will be added to z) 
z <- c(10,20,30,40)
y + z # because these vectors are the same length it will add z to y respectively

# creating vectors
z <- vector(mode="numeric",length=0) # mode refers to type of data
print(z) # at this point -> numeric(0)
# add element to z
z <- c(z,5) # this will string what is in z right now with the element 5
print(z) # will build variable to 5 ## NEVER DO THIS!

# create vector of predetermined length
z <- rep(0,100) # will repeat the number 0 100x
str(z)

z <- rep(NA,100) # 100 NA values # this data type is logical
str(z)

z[1] <- "Washington" # this replaces the first value in the string of z
typeof(z) # this gives us a character variable because of coercion
