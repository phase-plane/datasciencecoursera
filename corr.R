corr <- function(directory, threshold = 0){
  DataFrameOfCases <- complete(directory)
  cases <- as.character(DataFrameOfCases[,2])
  casesAsInt <- as.integer(cases)
  idx <- which(casesAsInt > threshold)
  
  # set full directory name
  directory <- paste(getwd(),"/", directory,"/", sep = "")
  
  # process files
  files <- list.files(directory) # produces character vector
  
  # initialise
  correlations <- numeric()
    
  for (i in idx){
    # read file
    fileToRead <- paste(directory, files[i], sep = "")
    fileData <- read.csv(fileToRead)
    # compute correlation
    sulphate <- as.numeric(fileData[,2])
    nitrate <- as.numeric(fileData[,3])
    corToAppend <- cor(sulphate, nitrate, use = "complete.obs")
      
    # append
    correlations <- c(correlations, corToAppend)
  }
  correlations
}