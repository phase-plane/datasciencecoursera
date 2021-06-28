# setup
setwd("/Users/alexanderjohannes/Desktop/2021/Code/datasciencecoursera/Assignment 3")
hospitalData <- read.csv("outcome-of-care-measures.csv", colClasses = "character",
                    na.strings = "Not Available", stringsAsFactors = FALSE)
hospitalData <- read.csv("outcome-of-care-measures.csv", 
                         na.strings = "Not Available", stringsAsFactors = FALSE)
# getting a feel
head(hospitalData)
ncol(hospitalData)
nrow(hospitalData)

# 30-day death rates from
# heart attack[,11] 
hospitalData[,11] <- as.numeric(hospitalData[,11])
names(hospitalData)[11] <- "heart attack"

# heart failure[,17]
hospitalData[,17] <- as.numeric(hospitalData[,17])
names(hospitalData)[17] <- "heart failure"

# pneumonia[,23]
hospitalData[,23] <- as.numeric(hospitalData[,23])
names(hospitalData)[23] <- "pneumonia"

# character vectors
# hospital name[,2] Hospital.Name
# state[,7] State

testData <- data.frame(a = c(7, NA,10,6,NA,11),
                       b = c("y", "f", "a", "z","k","b"),
                       c = c("JHB", "JHB", "JHB", "CPT", "CPT", "CPT"))
names(testData) <- c("Rate", "Name", "State")
testData[,1] <- as.numeric(testData[,1])
TeststateData <- testData[grep("CPT", testData$State),]
TeststateData <- TeststateData[order(TeststateData$Name),]
idx <- which.min(TeststateData$Rate)
as.character(TeststateData$Name[idx])
"JHB" %in% testData[,3]

for(state in uniqueStates){
  print(state)
}

for (i in 1:5){
  if (i==3) next
  cat(i)
}