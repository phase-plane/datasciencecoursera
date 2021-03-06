## Week 4
## Simulation & Profiling

# 1. str function 
# compactly display internal structure
# useful for nested lists; and
# a quick look at data
# similar to summary()

# 2. Simulation 
# rnorm() -  # generate rnv
# dnorm() - # evaluate (random) density
# pnorm() - # evaluate cumulative density
# rpois(100,4) - # generate random poisson

# pdfs have four functions associated with them, prefixed by
# d - density
# r - randomly generate
# p - cumulative distribution
# q - quantile function

# e.g. Generating random numbers

# N.B. need to use set.seed
# > str(set.seed)
# function (seed, kind = NULL, normal.kind = NULL, sample.kind = NULL) 

# seed - any integer
# idea: you can generate the same random numbers (for reproducibility)

# Random sampling
set.seed(1)
sample(1:10, 4)
sample(1:10, 4)
sample(letters, 5)
sample(1:10) # permutation of elements
sample(1:10, replace = TRUE) # with replacement

# 3. Profiling + tools
# why take so long
# where (in the programme) is the time being spent 
# premature optimisation BAD
system.time() # assumes you know where the problems are 
# user time (CPU)
# elapsed time (you)

# elapsed > user => e.g. reading webpages (waiting for network)
# elapsed < user => svd (linear algebra / splitting across cpus)
# Now
Rprof()
summaryRprof()
# not to be used in conjunction with system.time
# two methods for normalising data 
by.total
by.self # most revealing

# Swirl exercises Week 4
# 12. Looking at Data
dim(plants) # works on data frame
nrow(plants)
# memory
object.size(plants)
names(plants)
tail(plants,15)

# 13. Simulation
flips <- sample(c(0,1), 100, replace = TRUE, prob = c(0.3, 0.7))
rbinom(1, size = 100, prob = 0.7) # 1 observation of 100 flips
flips2 <- rbinom(100, size = 1, prob = 0.7) # 100 observations of 1 flip
replicate(100, rpois(5, 10)) # 100 groups of 5 obs.

# 15. Base Graphics
# advanced graphics: lattice, ggplot2, ggvis
# plot <=> scatterplot
plot(x = cars$speed, y = cars$dist)
plot(x = cars$speed, y = cars$dist, xlab = "Speed", ylab = "Stopping Distance")
# OR using formula interface
plot(dist ~ speed, cars)

# box plots
boxplot(formula = mpg ~ cyl, data = mtcars)