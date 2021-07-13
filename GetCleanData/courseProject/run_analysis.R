# run_analysis

# setting up environment
setwd(paste(getwd(),"courseProject", sep="/"))
library(dplyr)
library(curl)
path <- getwd()

# for a longer description of the objective of each step, see CodeBook.md

# 0. download the data

# link to data 
fileUrl <- paste0("https://d396qusza40orc.cloudfront.net/getdata", 
                  "%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")

filename <- "ProjectData.zip"

# check if file already exists
if (!file.exists(filename)){
  download.file(fileUrl, destfile = "./ProjectData.zip", method = "libcurl")
}

# check if folder has been unzipped
if (!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

# check contents
list.files("UCI HAR Dataset")

# assign file contents to objects in R
features <- read.table("UCI HAR Dataset/features.txt",
                       col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", 
                         col.names = c("code", "activity"))

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", 
                     col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",
                     col.names = "code")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                            col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", 
                      col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                      col.names = "code")

# 1. merge the training and the test sets 
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
mergedData <- cbind(subject, Y, X)

# 2. extracts mean and standard deviation for each measurement
tidyData <- mergedData %>% 
  select(subject, code, contains("mean"), contains("std"))

# 3. name the activities in the data set
tidyData$code <- activities[tidyData$code, 2]

# 4.  label the data set
names(tidyData)[2] = "activity"
names(tidyData)<-gsub("Acc", "accelerometer", names(tidyData))
names(tidyData)<-gsub("Gyro", "gyroscope", names(tidyData))
names(tidyData)<-gsub("BodyBody", "body", names(tidyData))
names(tidyData)<-gsub("Mag", "magnitude", names(tidyData))
names(tidyData)<-gsub("^t", "time", names(tidyData))
names(tidyData)<-gsub("^f", "frequency", names(tidyData))
names(tidyData)<-gsub("tBody", "timebody", names(tidyData))
names(tidyData)<-gsub("-mean()", "mean", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-std()", "std", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-freq()", "frequency", names(tidyData), ignore.case = TRUE)

# 5.  create tidy data set with 
#     the average of each variable for each activity and each subject
cleanedData <- tidyData %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean = mean))

write.table(cleanedData, "cleanedData.txt", row.name=FALSE)