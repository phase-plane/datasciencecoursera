setwd(paste(getwd(),"GetCleanData", sep="/"))

# Week 1: Getting and Cleaning Data (Overview)
# Data collection - Raw files (.csv, .xlsx), Databases (MySQL), APIs
# formats - JSON, XML, flat files (.csv, .txt)
# Making data tidy
# distributing data
# Scripting for cleaning data

# This course: Phase 1 of pipeline
# (i) raw data -> processing script -> tidy data -> ...
# (ii) data analysis -> data communication

# always record processing steps

# components of tidy data

# 4 things you should have:

# 1. the raw data
# 2. a tidy data set
# 3. code book describing each variable and its values in the 
#    tidy data set (metadata)
# 4. an explicit and exact method of how you went from 1 -> 2,3

# (I) DOWNLOADING FILES IN R
# n.b. commands
getwd()
setwd()

# relative vs absolute paths (differs in slightly (\\) in Windows)
setwd("../") 
setwd("/Users/alexanderjohannes.../")

files.exists("directoryName")
dir.create("directoryName")

# (i) FROM INTERNET

download.file()

# > str(download.file)
# function (url, destfile, method, quiet = FALSE, mode = "w", cacheOK = TRUE, 
#          extra = getOption("download.file.extra"), headers = NULL, ...)

# url, destfile, method most n.b.
# not working for this e.g.
# https on mac -> method = "curl"
fileUrl <- paste("https://data.baltimorecity.gov/datasets/baltimore::",
            "fixed-speed-cameras/about#:~:text=Download-,available,-file", sep="")
download.file(fileUrl, destfile = "./cameras.csv", method = "curl")
# be mindful of cwd for destfile
list.files() # <=> dir()

# Quiz Q1
install.packages("curl")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./IdahoHousing2006.csv", method = "libcurl")
housingData <- read.csv("IdahoHousing2006.csv", colClasses = "character",
                         na.strings = "", stringsAsFactors = FALSE)
housingPrices <- as.numeric(housingData$VAL)
missingVals <- is.na(housingPrices)
prices <- housingPrices[!missingVals]
ans <- prices[prices >= 24] # 53

# always record
dateDownloaded <- date()

# (ii) LOCAL FLAT FILES

read.table()
# looks for 'tab' seperated files (.tab/.txt) -> need extra commands
# function (file, header = FALSE, sep = "",..., row.names, nrows,..., quote,..)
# quote = "" can be helpful
# so for csv, could use sep = ","
# else (for standard csvs)
read.csv()
read.csv2()

# (iii) EXCEL FILES

# install.packages("xlsx")
# install.packages("rJava")
# XLConnect is also a good package
library(xlsx)
# .xlsx extension, method = "curl"

colIndex <- 2:3
rowIndex <- 1:4
read.xlsx("./GetCleanData/cameras.xlsx", sheetIndex = 1, colIndex = colIndex, 
          rowIndex = rowIndex)
write.xlsx()
# if you really want xlsx file
# rather export as .csv/.txt though

# Quiz Q3
fileUrl <- paste("https://d396qusza40orc.cloudfront.net/getdata",
                 "%2Fdata%2FDATA.gov_NGAP.xlsx", sep = "")
download.file(fileUrl, destfile = "./NGA.xlsx", method = "libcurl")
rowIndex <- 18:23
colIndex <- 7:15
dat <- read.xlsx("./NGA.xlsx", sheetIndex = 1, colIndex = colIndex,
                 rowIndex = rowIndex)
ans <- sum(dat$Zip*dat$Ext,na.rm=T) # [1] 36534720

# (iv) XML FILES
# Extensible Markup Language
# used with XPath
# comes up in web-scraping
# components: 
#   markup - labels that give the text structure
#   content - the actual text in the document

# tags - general labels
# e.g. start tag <section>
#      end tag </section>

# elements - specific examples of tags
# e.g. <Greeting> Hello, world </Greeting>

# attributes - components of the label
library(XML)
fileUrl <- "https://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl, useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

# subsetting
rootNode[[1]]
rootNode[[1]][[1]]

# programatically extract
xmlSApply(rootNode, xmlValue)

xpathSApply(rootNode,"//name", xmlValue)
xpathSApply(rootNode,"//price", xmlValue)

# Quiz Q4
install.packages("RCurl")
library(RCurl)

fileUrl <- paste("https://d396qusza40orc.cloudfront.net/",
                 "getdata%2Fdata%2Frestaurants.xml", sep = "")
download.file(fileUrl, destfile = "./baltimoreRestaurants.xml",
              method = "libcurl")

doc <- xmlTreeParse("baltimoreRestaurants.xml", useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
codes <- xpathSApply(doc, "//zipcode", xmlValue)
length(which(codes == "21231"))


# html
doc <- htmlTreeParse(fileUrl, useInternalNodes = TRUE)

# extract list item s.t. class = 'score'
scores <- xpathSApply(doc, "//li[@class='score']", xmlValue)

# (v) JSON FILES
# Javascript Object Notation
# common format from APIs
# structure similar to XML
install.packages("jsonlite")
library(jsonlite)

jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")

# can drill down at multiple levels
names(jsonData)

names(jsonData$owner)

jsonData$owner$login

# write data frames to JSON (good for exporting data)
myjson <- toJSON(iris, pretty = TRUE)
cat(myjson)

# back again
iris2 <- fromJSON(myjson)
head(iris2)

# (vi) DATA.TABLE PACKAGE

# OpenMP support not detected
library(data.table)

# inherits from data.frame 
# written in C
# see all tables in memory 
tables()

# subsetting different 

# args after [,..] comma are 'expressions' {}
# last pass a list of functions to be applied

# good at adding new colums 
DT[,w:=z^2]

# multiple operations
DT[,m:={tmp <- (x+z); log2(temp+5)}]
# returns evaluation of last statement

# create logical variables
DT[, a:=x>0]
# then 
DT[,b:=mean(x+w), by=a]

# special variable
.N
set.seed(123)
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
DT[, .N, by=x]
# count grouped by x variable

# keys (for fast sorting and subsetting)
DT <- data.table(x=rep(c("a", "b", "c"), each=100), y=rnorm(300))
setkey(DT,x)
DT['a']

# Quiz Q5
DT <- fread(file = "IdahoHousing2006.csv")
system.time()