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


