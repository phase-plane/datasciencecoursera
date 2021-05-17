# 1. Basics

# R uses 'one-based indexing' like Matlab

# assign variable 
y <- 9

# built-in help
?c

# create vector
z <- c(1.1, 9, 3)

# operations applied element-wise
z * 2 + 100

# concatenate strings 
paste()

# "recycled" smaller vector
c(1,2,3,4) + c(0,10)

# time-saving:
# ^ arrow
# type first two letter then tab

# 2. Workspace and file system

# commands to make files OS independent

getwd()

# List all the objects in your local workspace
ls()

# List all the files in your working directory 
list.files() 
# or 
dir()

# Using the args() function on a function name to list arguments
args()

# Use dir.create() to create a director
dir.create("testdir")

# Create a file in your working directory
file.create("mytest.R")

# check if file exists in current working directory
file.exists("mytest.R")

# Access information about the file "mytest.R"
file.info("mytest.R")

# Rename file
file.rename("mytest.R", "mytest2.R")

# Make a copy of "mytest2.R" called "mytest3.R" using file.copy()
file.copy("mytest2.R", "mytest3.R")

# Provide the relative path to the file "mytest3.R" by using file.path()
file.path("mytest3.R")

# Pass 'folder1' and 'folder2' as arguments to file.path to make a
# platform-independent pathname
file.path("folder1", "folder2")

# Create a directory in the current working directory called "testdir2"
# and a subdirectory for it called "testdir3"
dir.create(file.path("testdir2", "testdir3"), recursive = TRUE)

# 4.  Vectors (numeric or otherwise)

# logical operators 
# A | B or 
# A & B and
# !A negation

# Character vectors

# double quotations 

# join strings contained in vector 
paste()

# Note: the numeric vector gets 'coerced' into a character
# vector by the paste() function

# 5. Missing Values 
# randomly combine vectors
sample()

# locate NAs 
is.na()

# lesson: be cautious when
# using logical expressions anytime NAs might creep in.
# R creates vectors of NA

# sum() works on TRUE (1), FALSE (0) values 

# another type of missing value - NaN

# Inf stands for infinity

# 6. Subsetting Vectors

# index using square brackets 

# Index vectors come in four different flavors 
# logical vectors, vectors of positive integers,
# vectors of negative integers, and vectors of character strings

# logical indexing: not necessarily returning index values but extracting 
# values given conditions

# N.B. note: R doesn't prevent us from asking for invalid index values!

# exclude certain elements
x[-c(2, 10)] 

# commands for name vectors 
identical(x,y)

# 7. Matrices and Data Frames 

# matrices contain single class of data
# data frames can consist of multiple classes

# commands 
dim()
length()
attributes()
class()
matrix(data = , nrow =, ncol = )
identical()

# no need for c() when using : to generate vector

# combine columns 
cbind()

# to avoid implicit coercion > data frames 
data.frame()

# insert column names
# create cnames string vector
colnames(my_data) <- cnames

# 8. Logic
# equality == 
# inequality !=
# negation !

# && only evaluates the first element of a vector
# || OR - same 

# Note: All AND operators are evaluated before OR operators.

# commands
isTRUE()
identical()

# xor(TRUE, TRUE) evaluates to FALSE
xor() 

# functions that take logical vectors as inputs
which() # return index values
any()
all()

# 9. Functions 

# function_name <- function(arg1, arg2){
#	# Manipulate arguments in some way
#	# Return a value
# }

# default arguments
# increment <- function(number, by = 1)

# Note: When you explicitly designate argument values by name,
# the ordering of the arguments becomes unimportant

# R can also partially match arguments, but proceed with caution 

# commands 
# type function name, no parentheses
args()

# Yes it's true: you can pass functions as arguments

# You may be surprised to learn that you can pass a function as an argument
# without first defining the passed function. Functions that are not named are
# appropriately known as anonymous functions

# Ellipse example

# paste (..., sep = " ", collapse = NULL)

# The ellipses can be used to pass on arguments to other functions that are
# used within the function you're writing. Usually a function that has the
# ellipses as an argument has the ellipses as the last argument.

# Notice that the ellipses is the first argument, and all other arguments after
# the ellipses have default values. This is a strict rule in R programming: all
# arguments after an ellipses must have default values. 

# Often need to "unpack" arguments from an ellipses
# example 

# add_alpha_and_beta <- function(...){
#   # First we must capture the ellipsis inside of a list
#   # and then assign the list to a variable. Let's name this
#   # variable `args`.
#
#   args <- list(...)
#
#   # We're now going to assume that there are two named arguments within args
#   # with the names `alpha` and `beta.` We can extract named arguments from
#   # the args list by using the name of the argument and double brackets. The
#   # `args` variable is just a regular list after all!
#   
#   alpha <- args[["alpha"]]
#   beta  <- args[["beta"]]
#
#   # Then we return the sum of alpha and beta.
#
#   alpha + beta 
# }
#
# Note: you can create binary operations in R

# The syntax for creating new binary operators in R is unlike anything else in
# R, but it allows you to define a new syntax for your function. I would only
# recommend making your own binary operator if you plan on using it often!

# User-defined binary operators have the following syntax:
#      %[whatever]% 
# where [whatever] represents any valid variable name.

