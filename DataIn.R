# Bringing data into R
# 2 February 2017
# Erin L. Keller

# Import county ant datz 
# header=TRUE tells R that you have column names
z <- read.table("antcountydata.csv", header=TRUE, row.names=1, sep=",", stringsAsFactors=FALSE)

str(z)
 # use str to see data types and size of data in frame

# use summary to summarize numeric variables it will even give you mean min and max!
summary(z)

# use table to check character strings use $ to denote which variable to call
table(z$state)
table(z$ecoregion)

table(z$state,z$ecoregion)
