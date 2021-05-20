# Control structures, Functions, Scoping Rules
# Summary Notes (Full Notes in course textbook: R Programming)

# A few e.g.s to get used to the syntax

# Generate a uniform random number
x <- runif(1, 0, 10)
if (x > 3) {
  y <- 10 
} else {
    y <- 0 
}

# for loop 
for (i in 1:10) {
  print(i)
}

# Generate a sequence based on length of 'x' 
seq_along(x)

# 'repeat' - infinite loop > must call 'break' along with it

# 'next' skips certain iterations of a loop

# Functions
# a) can be passed as arguments to other functions. 
# This is very handy for the various apply functions, like lapply() and sapply()

# b) can be nested, so that you can define a function inside of another function

# assignment with default value
f <- function(num = 1){
  num + 1 # return value (return() seldom used)
}

# Note: R functions arguments can be matched positionally or by name

# lecture example 

columnmean<- function(y, removeNA = TRUE){
  nc <- ncol(y)
  means <- numeric(nc)
  for (i in 1:nc){
    means[i] <- mean(y[,i], na.rm = removeNA)
  }
  means
}

# lm() fits linear model
args(lm)

function (formula, data, subset, weights, na.action, method = "qr", 
          model = TRUE, x = FALSE, y = FALSE, qr = TRUE, singular.ok = TRUE, 
          contrasts = NULL, offset, ...) 
NULL

# Note: watch out for lazy evaluation
# i.e writing a function that doesn’t use an argument and not notice
# it simply because R never throws an error.

# special argument: the (...) argument can be used to process a variable 
# number of inputs

# Scoping Rules

# lexical scoping (like python)