# Week 3
# 1. lapply & sapply (Loop functions)
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
# lapply(unique_vals, function(elem) elem[2])

# 2. vapply & tapply

# when not working interactively at the prompt e.g. writing a function
# can make errors based on what the output is assumed to be 
# to be more careful > vapply()
# i.e. whereas sapply() tries to 'guess' the correct format of the result, vapply()
# allows you to specify it explicitly.
# sapply but allows you to check output 

# > vapply(flags,unique,numeric(1)) 
# I expect a numeric vector of length 1
# if this is not the case > error message returned

# tapply 'apply a function over a ragged array'

# commands
# > table(flags$landmass)

# apply the mean function to the 'animate' variable separately for each of the six
# landmass groups, thus giving us the proportion of flags containing an animate
# image WITHIN each landmass group
# > tapply(flags$animate,flags$landmass,mean)

# we can look at a summary of population values (in round millions)
# for countries with and without the color red on their flag with
# > tapply(flags$population,flags$red,summary)