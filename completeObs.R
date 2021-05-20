completeObs <- function(directory, idx = 1:332){
  # creates data frame of:
    # column 1 - file names 
    # column 2 - no. of complete observations
  
  # initialise empty data frame 
  df <- data.frame()

  # set full directory name
  directory <- paste(getwd(),"/", directory,"/", sep = "")
  
  # process files
  files <- list.files(directory) # produces character vector
  
  # read specified files and calculate complete cases
  for (i in idx) {
    fileToRead <- paste(directory, files[i], sep = "")
    fileData <- read.csv(fileToRead)
    rowToAppend <- cbind(files[i], sum(complete.cases(fileData)))
    df <- rbind(df,rowToAppend)
  }
  # return
  names(df) <- c("File", "Complete Cases")
  df
}