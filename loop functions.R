# Week 3 - Loop Functions & Debugging

# Loop Functions 
# 1. lapply & sapply
# Split-Apply-Combine

# e.g. what is the class of each column the flags dataframe

# lapply - list/df an input > returns list; then
# (as each element is of length one) 
# > list unnecessary
#  therefore us as.character() > character vector

# e.g.
# cls_list <- lapply(flags,class)
# > class(cls_list)
# [1] "list"
# > as.character(cls_list)

# > cls_vect <- sapply(flags,class)
# > class(cls_vect)
# [1] "character"

# sapply attempts to do this entire process for you

# nice command
# sum(flags$orange)
# lapply(flags_colors, sum)
# lapply (object, command)

# callings (anonymous) functions as arguments (when no built-in function suitable)
# return second item from each element of the unique_vals list
lapply(unique_vals, function(elem) elem[2])

# lecture video e.g.s

x <- list(a = 1:5, b = rnorm(10))
lapply(x, mean)

x <- 1:4
lapply(x, runif)
# specify additional arguments for runif
lapply(x, runif, min = 0, max = 10)

x <- list(a = matrix(1:4, 2, 2), b = matrix(1:6, 3, 2))
# anonymous function to extract first column of matrix
lapply(x, function(elem) elem[,1])

# 2. apply() 
# apply a function (often anonymous) over the margains of an array
# often used to apply function to rows/columns of a matrix
# not necessarily faster than a loop but written in one line

# > str(apply)
# function (X, MARGIN, FUN, ...) 
# X - array
# MARGIN - integer vector indicating which margains(dimension) should be retained

x <- matrix(rnorm(200), 20, 10) # 20 x 10

z <- apply(x, 2, mean) # column mean (10 x 1)

y <- apply(x, 1, sum) # row sum (20 x 1)

# but rather use 
colMeans(x)
rowSums(x)
# much faster 

# e.g. of additional (...) arguments for quantile function
# calculate row quantiles
apply(x, 1, quantile, probs = c(0.25, 0.75))

# 3. mapply - multivariate lapply
# > str(mapply)
# function (FUN, ..., MoreArgs = NULL, SIMPLIFY = TRUE, USE.NAMES = TRUE) 
# from single list argument to multiple list arguments
# e.g. 

noise <- function(n, mean, sd){
  rnorm(n, mean, sd)
}

# want to pass vectors as arguments > currently not possible
# use 
mapply(noise, 1:5, 1:5, 2)

# instead of
list(noise(1,1,2), noise(2,2,2), noise(3,3,2), 
     noise(4,4,2), noise(5,5,2))

# 4. vapply & tapply

# when not working interactively at the prompt e.g. writing a function
# can make errors based on what the output is assumed to be 
# to be more careful > vapply()
# i.e. whereas sapply() tries to 'guess' the correct format of the result, 
# vapply() allows you to specify it explicitly.
# sapply but allows you to check output 

# > vapply(flags,unique,numeric(1)) 
# I expect a numeric vector of length 1
# if this is not the case > error message returned

# tapply 'apply a function over a ragged array' i.e. a subset of vectors
# > str(tapply)
# function (X, INDEX, FUN = NULL, ..., default = NA, simplify = TRUE)
# the idea:
# X - numeric vector 
# INDEX - vector of same length which identifies which group each element
# of the numeric vector is in

# commands
# > table(flags$landmass)

# apply the mean function to the 'animate' variable separately for each of the 
# six landmass groups, thus giving us the proportion of flags containing 
# an animate image WITHIN each landmass group
# > tapply(flags$animate,flags$landmass, mean)

# we can look at a summary of population values (in round millions)
# for countries with and without the color red on their flag with
# > tapply(flags$population,flags$red,summary)

# 5. split() - useful in conjuction with lapply
# takes vector or other object (list/df) and splits it into groups determined by 
# factor / factor list
# like tapply but without specifying the function
# > str(split)
# function (x, f, drop = FALSE, ...)
# f - is a factor or list of factors (or coerced to one)
# 'levels' <=> 'groups'

x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3,10)
split(x,f) # (always) outputs list, with 3 groupings / parts for this e.g.

# could then use lapply or sapply on that list
lapply(split(x,f), mean)
# $`1`
# [1] -0.1544324

# $`2`
# [1] 0.3669658

# $`3`
# [1] 0.9702248

# e.g. splitting a dataframe
# calculate the mean of ozone, solar radiation and wind
# within each month

s <- split(airquality, airquality$Month)
lapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")], na.rm = TRUE))
# last two are matrices

# Splitting on more than one level
x <- rnorm(10)
# > x
# [1] -0.39380385  0.77302291 -1.05334177  1.02568534 -1.11676808 -0.06804529
# [7]  0.67926658 -0.86506574 -0.98783536 -0.76468252

f1 <- gl(2,5)
# > f1
# [1] 1 1 1 1 1 2 2 2 2 2
# Levels: 1 2

f2 <- gl(5,2)
# [1] 1 1 2 2 3 3 4 4 5 5
# Levels: 1 2 3 4 5

interaction(f1,f2)
# [1] 1.1 1.1 1.2 1.2 1.3 2.3 2.4 2.4 2.5 2.5
# 10 Levels: 1.1 2.1 1.2 2.2 1.3 2.3 1.4 2.4 1.5 2.5

split(x, list(f1,f2), drop = TRUE)
# get rid of empty levels