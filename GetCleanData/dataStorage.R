setwd(paste(getwd(),"GetCleanData", sep="/"))

# Week 2: Getting Data from common data storage systems

# (i) MySQL

# data structured in:
# (a) databases
# (b) tables within databases
# (c) fields within tables
# each row is called a 'record'
install.packages("RMySQL")
library(RMySQL)

# connect (using MySQL commands)
ucscDb <- dbConnect(MySQL(),user="genome", 
                    host="genome-euro-mysql.soe.ucsc.edu")
result <- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb);

# access specific database
hg19 <- dbConnect(MySQL(),user="genome", db="hg19",
                  host="genome-euro-mysql.soe.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

# get dimensions of specific table / column names
dbListFields(hg19,"affyU133Plus2")

# how many rows
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

# read the actual data from the table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

# select specific subset
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where
                     misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)

# check the data
affyMisSmall <- fetch(query,n=10); dbClearResult(query);
dim(affyMisSmall)
dbDisconnect(hg19)

# Quiz Q2 & 3
install.packages("curl")
install.packages("sqldf")
library(curl)
library(sqldf)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./acs.csv", method = "libcurl")
acs <- data.table::data.table(read.csv("acs.csv"))

detach("package:RMySQL", unload=TRUE)
query1 <- sqldf("select pwgtp1 from acs where AGEP < 50")
query2 <- sqldf("select distinct AGEP from acs")

# (ii) HDF5

install.packages("BiocManager")
BiocManager::install(c("rhdf5"))
library(rhdf5)

# create our own file
created = h5createFile("example.h5")

# create groups within file
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
created = h5createGroup("example.h5","foo/foobaa")

# similar to ls() i.e. list command
h5ls("example.h5")

# write to groups
A = matrix(1:10,nr=5,nc=2)
h5write(A, "example.h5","foo/A")

B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B, "scale") <- "litre"
h5write(B, "example.h5","foo/foobaa/B")

# print
h5ls("example.h5")

# write a data set (to top level group)
df = data.frame(1L:5L,seq(0,1,length.out=5),
                c("ab","cde","fghi","a","s"), stringsAsFactors=FALSE)
h5write(df, "example.h5","df")
h5ls("example.h5")

# reading data
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf= h5read("example.h5","df")
readA

# read and write 'chunks'
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
h5read("example.h5","foo/A")

# could pass index=list(1:3,1) to h5read() as well

# (iii) The WEB / web scraping (see rbloggers)

# webpages
# con -> connection
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

# parsing with XML
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=TRUE)

xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)

# HTML
html2 <- GET(url)
content2 <- content(html2,as="text")
parsedHtml <- htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)

# Quiz Q4
con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)

nchar(htmlCode[10])

# (iv) APIs
# using httr
# access twitter API
myapp = oauth_app("twitter",
                  key="yourConsumerKeyHere",secret="yourConsumerSecretHere")
sig = sign_oauth1.0(myapp,
                    token = "yourTokenHere",
                    token_secret = "yourTokenSecretHere")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
# how to find the URL -> documentation of twitter API

# convert the json object
json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]

# GET from httr package
install.packages("httr")
library(httr)

# Quiz Q1 
# creating an OAuth App on github
install.packages("httpuv")
library(httpuv)
library(jsonlite)

oauth_endpoints("github")
myapp <- oauth_app("github",
                   key = "b0acad002b1fd56ecb43",
                   secret = "6d6bae4ecf7972cbe3ca5b38cb9a6aa4310576a9",
                   redirect_uri = "http://localhost:1410")

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)
# convert to data frame
json1 = content(req)
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))
# extract info
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"]

# websites with passwords
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
pg2
names(pg2)

# using handles
google = handle("http://google.com")
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")

# (v) other Sources

# interact directly with files
file() # open a connection to a text file
url() # open a connection to a URL
gzfile()  # open a connection to a .gz file (zipped)
bzfile() # open a connection to a .bz2 file
?connections # for more information
# remember to close connections

# foreign package
# loads data from Minitab, S, SAS, SPSS, Stata, Systat
# e.g. 
read.xport # (SAS)

# other data base packages
RPostresSQL()
RODBC()
RMongo()

# Quiz Q5 fixed width file
library(curl)
download.file(fileUrl, destfile = "./noaa.for", method = "libcurl")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
lines <- readLines(fileUrl, n = 10)
NOAA <- read.fwf(fileUrl, skip=4, widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4))
sum(NOAA[,4])