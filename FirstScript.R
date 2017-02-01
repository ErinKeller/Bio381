#` "Special" roxygen comment that will render as markdown
# Demo of R scripts
# 26 January 2017
# Erin L. Keller

# New plot to show up in viewer
# Code will only run when you hit Ctrl+Entr

plot(runif(10))

# Show some data in the console

z <- rnorm(n=3, mean=10, sd=2)

# rnorm gives you a random normal numbers, nnumber of outputs equals n
# numerical output shows in console

print(z)

# Cmd + Shift + Enter runs all lines of code

# In the console, onup arrows lets you browse through different lines to grab a previously use line of code. 

# Clicking the notebook icon above allows you to put it into different formats including all code, notes, and outputs

# Ctrl + L cleans out console

# "purl" puts all script into one chunk. To do this, go into the Console and write: purl(".Rmd name") and open.