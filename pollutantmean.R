pollutantmean <- function(directory, pollutant, idx = 1:332, removeNA = TRUE){
  
  # set full directory name
  directory <- paste(getwd(),"/", directory,"/", sep = "")
  
  # process files
  files <- list.files(directory)
  
  datfram <- data.frame()
  
  # read specified files and append 
  for (i in idx) {
    fileToRead <- paste(directory, files[i], sep = "")
    fileData <- read.csv(fileToRead)
    datfram <- rbind(datfram,fileData)
  }
  
  # calculate mean
  
  mean(datfram[[pollutant]], na.rm = removeNA)
}