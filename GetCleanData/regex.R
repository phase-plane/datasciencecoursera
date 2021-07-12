setwd(paste(getwd(),"GetCleanData", sep="/"))

# Week 4: text variables & regular expressions

# (i) TEXT VARIABLES

# variable names should be all lowercase when possible
# no underscores, dots, white space

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- paste("https://data.baltimorecity.gov/api/",
                 "views/dz54-2aru/rows.csv?accessType=DOWNLOAD", sep = "")
download.file(fileUrl,destfile="./data/cameras.csv", method="libcurl")
cameraData <- read.csv("./data/cameras.csv")
names(cameraData)

# editing variable names
tolower(names(cameraData))
toupper(names(cameraData))

# str split
splitNames = strsplit(names(cameraData),"\\.")
splitNames[[5]]

splitNames[[6]] # [1] "Location" "1"

# recall from lists
mylist <- list(letters = c("A", "b", "c"), 
               numbers = 1:3, matrix(1:25, ncol = 5))
head(mylist)

mylist[1]
mylist$letters
mylist[[1]]

# fixing character vectors with sapply()
splitNames[[6]][1] # [1] "Location"
firstElement <- function(x){x[1]}
sapply(splitNames,firstElement)

sub() # fix character vectors
names(reviews)
# [1] "id"  "solution_id" "reviewer_id" "start" "stop" "time_left"  
# [7] "accept"
sub("_","",names(reviews),)
# [1] "id" "solutionid" "reviewerid" "start" "stop" "timeleft"  "accept"

gsub()
testName <- "this_is_a_test"
sub("_","",testName)
# [1] "thisis_a_test"
gsub("_","",testName)
# [1] "thisisatest"

# finding values
grep("Alameda",cameraData$intersection) # [1]  4  5  36

table(grepl("Alameda",cameraData$intersection))
# FALSE  TRUE 
# 77     3
cameraData2 <- cameraData[!grepl("Alameda",cameraData$intersection),]

# more grep (return the values)
grep("Alameda",cameraData$intersection,value=TRUE)
# [1] "The Alameda  & 33rd St"   "E 33rd  & The Alameda" 
# "Harford \n & The Alameda"

grep("JeffStreet",cameraData$intersection)
# integer(0)

length(grep("JeffStreet",cameraData$intersection))
# [1] 0

# useful functions
install.packages("stringr")
library(stringr)
nchar("Jeffrey Leek")
substr("Jeffrey Leek",1,7)
paste("Jeffrey","Leek")
paste0("Jeffrey","Leek")
str_trim("Jeff      ")

# quiz q1:
acs <- read.csv("IdahoHousing2006.csv")
names(acs)
splitNames <- strsplit(names(acs), "wgtp")
splitNames[[123]]

# q2.
gdp <- read.csv("gdp.csv")
names(gdp); head(gdp)
gdp[,5] <- gsub(",","", gdp[,5])
gdpvalue <- as.integer(gdp[,5])
ans = mean(gdpvalue, na.rm = TRUE)

# q3. 
grep("^United",gdp[,4])

# q4.
eduDT <- data.table::fread(paste0("http://d396qusza40orc.cloudfront.net/",
                           "getdata%2Fdata%2FEDSTATS_Country.csv"))

mergedDT <- merge(GDPrank, eduDT, by = 'CountryCode')

mergedDT[grepl(pattern = "Fiscal year end: June 30;",
               mergedDT[, `Special Notes`]), .N]

# q5.
# install.packages("quantmod")
# library("quantmod")
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes <- index(amzn) 
timeDT <- data.table::data.table(timeCol = sampleTimes)

# How many values were collected in 2012? 
timeDT[(timeCol >= "2012-01-01") & (timeCol) < "2013-01-01", .N]
# Answer: 
# 250

# How many values were collected on Mondays in 2012?
timeDT[((timeCol >= "2012-01-01") & (timeCol < "2013-01-01")) & 
         (weekdays(timeCol) == "Monday"), .N]
# Answer:
# 47

# (ii) REGULAR EXPRESSIONS

# for literals 
grep() # etc.

# for metacharacters

# ^ beginning of line
# ^i think 

# $ end of line
# morning$

# character classes with []
# [Bb][Uu][Ss][Hh] # any variation of lower and upper "Bush"

# ^[Ii] am
# ^[0-9][a-zA-Z]

# ^ for negation
# [^?.]$

# "." 'any character'
# 9.11, '9 followed by any character, then 11'

# 'alternatives' / "or"

# flood|earthquake|hurricane|fire
# ^[Gg]ood|[Bb]ad
# ^([Gg]ood|[Bb]ad)

# ? metacharacter
# [Gg]eorge( [Ww]\.)? [Bb]ush

# \ to 'escape' interpretation as metacharacter
# [Gg]eorge( [Ww]\.)? [Bb]ush

# * - any number
# + - at least one of the item
# [0-9]+ (.*)[0-9]+

# {} - interval quantifiers
# [Bb]ush( +[^ ]+ +){1,5} debate

# * is 'greedy', matches longest possible expression
# ^s(.*)s

# greediness turned of with '?'
# ^s(.*?)s$

# repetitions with \1, \2, etc.

# (iii) DATES

d1 <- date()
class(d1)

d2 <- Sys.Date()
class(d2)

# formatting dates
format(d2,"%a %b %d")

# creating dates
x = c("1jan1960", "2jan1960", "31mar1960", "30jul1960")
z = as.Date(x, "%d%b%Y")

# operations
z[1] - z[2]
as.numeric(z[1]-z[2])

# converting to Julian dates
weekdays(d2)
months(d2)
julian(d2)

?Sys.timezone

# (iv) LUBRIDATE PACKAGE
install.packages("lubridate")
library(lubridate)
help(package = lubridate)

this_day <- today()
day(this_day)
wday(this_day) # 1 = Sunday, ...
wday(this_day, label = TRUE)

this_moment <- now()
minute(this_moment)

# parsing messy date-times representation
# form of
ymd(); dmy(); hms(); ymd_hms()

my_date <- ymd("1989-05-17")
class(my_date) # now of class POSIXct

ymd("1989 May 17")
mdy("March 12, 1975")
dmy(25081985) # nice! 

# but watch out
ymd("192012") # [1] NA

# more explicit
ymd("1920/1/2") # or 
ymd("1920-1-2")

# > dt1
# [1] "2014-08-23 17:23:02"
ymd_hms(dt1)

hms("03:22:14")

# vectors of dates (e.g. parse a column of data)
# > dt2
# [1] "2014-05-14" "2014-09-22" "2014-07-11"
ymd(dt2)

# update times
update(this_moment, hours = 8, minutes = 34, seconds = 55)
this_moment <- update(this_moment, 
                      hours = 12, minutes = 54, seconds = 01)

# worked e.g.
nyc <- now(tzone = "America/New_York")
depart <- nyc + days(2)
depart <- update(depart, hours = 17, minutes = 34)
arrive <- depart + hours(15) + minutes(50)
arrive <- with_tz(arrive, "Asia/Hong_Kong")

last_time <- mdy("June 17, 2008", tz = "Singapore")
how_long <- interval(last_time, arrive)
as.period(how_long)

# This is where things get a little tricky. Because of things like leap years,
# leap seconds, and daylight savings time, the length of any given minute,
# day, month, week, or year is relative to when it occurs. In contrast, the
# length of a second is always the same, regardless of when it occurs.