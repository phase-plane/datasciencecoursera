best <- function(state, outcome){
  # read outcome data relevant to request
  alloutcomes <- c("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23)
  colindex <- alloutcomes[outcome]
  if (is.na(colindex) == TRUE) {
    stop("invalid outcome")
  } else if (state %in% hospitalData[,7] != TRUE){
    stop("invalid state")
  } 
  else {
  relevantColumns <- hospitalData[,c(2,7,colindex)]
  stateData <- relevantColumns[grep(state, relevantColumns$State),]
  stateData <- stateData[order(stateData$Hospital.Name),]
  idx <- which.min(stateData[,3])
  # return hospital name[,2] in state with lowest 30 day death rate
  as.character(stateData$Hospital.Name[idx])
  }
}
