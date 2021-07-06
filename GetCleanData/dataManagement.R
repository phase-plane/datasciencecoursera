# Week 3
# organize, merge, manage data

# (i) SUBSETTING & SORTING
# review
set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X <- X[sample(1:5),]; X$var2[c(1,3)] = NA
X[,1]
X[,"var1"]
X[1:2,"var2"]

# logical and/or
X[(X$var1 <= 3 & X$var3 > 11),]
X[(X$var1 <= 3 | X$var3 > 15),]

# missing values 
X[which(X$var2 > 8),]

# sorting
sort(X$var1)
sort(X$var1,decreasing=TRUE)
sort(X$var2,na.last=TRUE)

# ordering
X[order(X$var1),]
X[order(X$var1,X$var3),]

# ordering with plyr
library(plyr)

# arrange
arrange(X,var1)
arrange(X,desc(var1))

# adding rows and columns
X$var4 <- rnorm(5)
Y <- cbind(X,rnorm(5))

# (ii) QUICK SUMMARY 
restData <- read.csv("baltimoreRestaurants.csv")

# initial feel
head(restData,3)
tail(restData$name,3)

# summary
summary(restData)
str(restData)

# quantiles
# no longer works (with new .csv)
quantile(restData$councilDistrict,na.rm=TRUE)
quantile(restData$councilDistrict,probs=c(0.5,0.75,0.9))

# make table
table(restData$zipcode,useNA="ifany")
table(restData$councilDistrict,restData$zipCode)

# missing values 
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode > 0)
 
# sums
colSums(is.na(restData))
all(colSums(is.na(restData))==0)

# checking for specific characteristics
table(restData$zipCode %in% c("21212")) # or ==
table(restData$zipCode %in% c("21212","21213"))

# subsetting using logical
restData[restData$zipCode %in% c("21212","21213"),]

# cross tabs
data(UCBAdmissions)
DF = as.data.frame(UCBAdmissions)
summary(DF)

xt <- xtabs(Freq ~ Gender + Admit,data=DF)
xt
#         Admit
# Gender   Admitted Rejected
# Male       1198     1493
# Female      557     1278

# flat tables
warpbreaks$replicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~.,data=warpbreaks) # breaks by all other variables
xt
ftable(xt)

# size of data sets
fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units="Mb")

# (iii) CREATING NEW VARIABLES
# creating sequences
s1 <- seq(1,10,by=2) ; s1
s2 <- seq(1,10,length=3); s2
x <- c(1,3,8,25,100); seq(along = x)
# [1] 1 2 3 4 5
# create vector of same length as object to be sequenced along

# subsetting variables
restData$nearMe = restData$nghbrhd %in% c("Roland Park", "Homeland")
table(restData$nearMe)
# FALSE  TRUE 
# 1314    13

# binary variables
restData$zipWrong = ifelse(restData$zipcode < 0, TRUE, FALSE)
table(restData$zipWrong,restData$zipcode < 0)

# categorical variables
restData$zipGroups = cut(restData$zipcode,breaks=quantile(restData$zipcode))
table(restData$zipGroups)
table(restData$zipGroups,restData$zipCode)
# easier cutting 
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4)
table(restData$zipGroups)

# creating factor variables
restData$zcf <- factor(restData$zipcode)
restData$zcf[1:10]
class(restData$zcf)

# levels of factor variable
yesno <- sample(c("yes","no"),size=10,replace=TRUE)
yesnofac = factor(yesno,levels=c("yes","no"))
relevel(yesnofac,ref="no")
as.numeric(yesnofac)

# cutting produces factor variables
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4)
table(restData$zipGroups)

# using the mutate function
library(Hmisc); library(plyr)
restData2 = mutate(restData,zipGroups=cut2(zipCode,g=4))
table(restData2$zipGroups)

# (iv) RESHAPING DATA
install.packages("reshape2")
library(reshape2)

head(mtcars)

# melting data frames
mtcars$carname <- rownames(mtcars)
# melt -> id, measurement variables
carMelt <- melt(mtcars,id=c("carname","gear","cyl"), measure.vars=c("mpg","hp"))
head(carMelt,3)
tail(carMelt,n=3)

# (re)casting data frames
# cyl in rows, variable in column
cylData <- dcast(carMelt, cyl ~ variable)
cylData <- dcast(carMelt, cyl ~ variable, mean)

# averaging values
head(InsectSprays)
tapply(InsectSprays$count,InsectSprays$spray,sum)
# or
spIns =  split(InsectSprays$count,InsectSprays$spray)
# or
sprCount = lapply(spIns,sum)
# then de-list (create vector)
unlist(sprCount)
# or
sapply(spIns,sum)
# or
ddply(InsectSprays,.(spray),summarize,sum=sum(count))

# creating a new variable
spraySums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum))
dim(spraySums)
head(spraySums)

# (v) MERGING DATA
install.packages("curl")
library(curl)
# urls no longer active
fileUrl1 <- "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 <- "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1, destfile = "./reviews.csv", method = "libcurl")
download.file(fileUrl2, destfile = "./solutions.csv", method = "libcurl")
reviews <- read.csv("reviews.csv")
solutions <- read.csv("solutions.csv")

# merge()
names(reviews)
# [1] "id"          "solution_id" "reviewer_id" "start"  
# "stop"        "time_left"  
# [7] "accept"
names(solutions)
# [1] "id"         "problem_id" "subject_id" "start"      "stop"       "time_left" 
# "answer"    
mergedData = merge(reviews,solutions,by.x="solution_id",by.y="id",all=TRUE)

# default - merge all common column names
intersect(names(solutions),names(reviews))
# [1] "id"        "start"     "stop"      "time_left"
mergedData2 = merge(reviews,solutions,all=TRUE)

# or use JOIN in plyr package
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id)

# for multiple data frames
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
df3 = data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3)
join_all(dfList)