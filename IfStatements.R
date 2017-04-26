# Control structures for R programming
# Logical Operators
5 < 3
5 > 3
5 >= 3
5 <= 3
5 == 5 # This is a Boulean symbol, this will ask whether these values are equal rather than the single = sign which assigns values
5 != 3 # != means not equal to 

# Compound & for AND
5 > 3 & 1!=2 # will get a single TRUE value because both parts must be true

# use | for OR
1==2 | 1!=2 # TRUE if either are satisfied

# logicals work with vectors
1:5 >  # we will get out 5 T or F because each element in the vector will get evaluated
  
a <- 1:10
b <- 10:1

a > 4 & b > 4

# use "long form" of & (&&) and | (||)to find the first comparison that can be evaluated as a true false, and just use that.
a > 4 && b > 4 # single logical because it stops after the first comparison
a > 4 || b > 4

# can use isTRUE to test whether any statement is a vector of length 1 that has a value of TRUE

z <- 0
isTRUE(z) # False because 0 indicates FALSE and 1 indicates TRUE when coerced into a logical
z <- 1
isTRUE(z)

# xor for exclusive or testing of vectors (requires only one of the two statements be true, not both of them)
a <- c(0,0,1)
b <- c(0,1,1)
a | b # FALSE TRUE TRUE; first two elements = 0,0 =FALSE FALSE, second element 0,1 = TRUE False, third element = 1,1 (true true)
xor(a,b) # FALSE TRUE FALSE

# Set Operations
# boolean algebra on sets of atomic vectors
# (logical, numeric, character strings)

a <- 1:7
b <- 5:10

# union for all elements
union(a,b) # prints only unique elements, duplicates will be dropped

# intersect to get common elements
intersect(a,b) # prints diplicate elements only

# set diff to get distinct elements
setdiff(a,b) # for which the first set differs from the second set (elements in set a that are not found in set b)
setdiff(b,a) # elements in set b that are not found in set a

# set equal to check for identical elements
setequal(a,b) # overal inequality to determinne if a and b are the same --> FALSE

# more generally to compare two objects
z <- matrix(1:12,nrow=4,byrow=TRUE)
print(z)
z1 <- matrix(1:12,nrow=4,byrow=FALSE)
print(z1)
z==z1 # will print out a matrix with TRUES and FALSES 
identical(z,z1) # identical will ask whether the matrices are identical --> FALSE right now
z1 <- z
identical(z,z1) # now TRUE because we made the matrices the same

# useful for if statements is %in% or is.element
d <- 12
d %in% union(a,b) # is d in the union of a and b --> FALSE
is.element(d,union(a,b)) # equivalent to above

# if statements----------------------------------------------------------

# if (condition) expression (parthentheses are mandatory)

# else passes on to the next expression if satisfied

# if (condition) expression1 else expression2

# if (condition) expression1 else
# if (condition) expression2 else 
# expression 3

z <- signif(runif(1),digits=2) # signif takes a value and only retains the number of digits specifed
print(z)
z > 0.5
if(z > 0.5) cat(z, "is a bigger than average number","\n") # if your z value is less than 0.5 you will get nothing right now

if(z > 0.8) cat(z, "is a large number","\n") else 
  if(z<0.2) cat(z,"is a small number","\n") else
  {
    cat(z,"is an ordinary-sized number","\n")
    cat("z^2=",z^2,"\n")
  }

# avoid multiple true false vectors for ifs

z <- 1:10

# this won't do anything
if(z > 7) print(z) # you will get an error message and it says that only the first element will be used

if(z<7) print(z) # will get whole vector because you are asking if z < 7 (z is 1) so it will just print out the entire vector

# use subsetting here
print(z[z<7]) # this will print out all z values less than 7

# ifelse function
# ifelse(test,yes,no)
# test is an object that can be coerced to yes,no
# yes returns values for true elements of test
# no returns values for false elements of test


# insect in which each female lays, on average, 10.2 eggs (draw from a Poisson!)
# But, 35% of females are parasitized and sterile = MIXTURE DISTRIBUTION
tester <- runif(1000)
eggs <- ifelse(tester>0.35,rpois(n=1000,lambda=10.2),0)
               
head(eggs)

hist(eggs)
