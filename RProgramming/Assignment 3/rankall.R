rankall <- function(outcome, num = "best"){
  
  # read outcome data relevant to request
  alloutcomes <- c("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23)
  colindex <- alloutcomes[outcome]
  
  if (is.na(colindex) == TRUE) {
    stop("invalid outcome")
  }
  else {
    stateData <- hospitalData[,c(2,7,colindex)]
    stateData <- na.omit(stateData)
    stateData <- stateData[order(stateData$State, stateData[outcome],
                                     stateData$Hospital.Name),]
    stateList <- split(stateData, stateData$State)
    fetchindex <- function(x){
      # validate num
      if (identical(x, "best") == TRUE){
        idx <- 1
      }
      else if (identical(x, "worst") == TRUE){
        idx <- nrow(elem)
      }
      else {
        idx <- as.integer(x)
      }
      as.integer(idx)
    }
    finalProduct <- lapply(stateList, function(elem) elem[fetchindex(num), 1])
    unlistedValues <- unlist(finalProduct)
    listNames <- names(finalProduct)
    data.frame(hospital = unlistedValues, state = listNames, row.names = listNames)
  }
}