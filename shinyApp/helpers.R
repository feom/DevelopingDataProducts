# Load the required R packages.
library(e1071)
library(quantmod)
library(caret)
library(randomForest)
set.seed(32343)

# Load time series data for the given symbol using quantmod.
getSymbolTimeSeries <- function(symbol, fromDate, toDate) {
  getSymbols(symbol, src = "yahoo", from = fromDate, to = toDate, auto.assign = FALSE)
}

# Calcluate the required feature indicators and put them into a data frame.
# Pre-process by removing NA columns.
createFeatureData <- function(symbol, fromDate, toDate) {
  symbolDF <- getSymbolTimeSeries(symbol, fromDate, toDate)
  
  #Calculate the relative strength index (RSI) for a 5 day period from the open price 
  rsiInd <- RSI(Op(symbolDF), n = 5)
  
  #Calculate the 5 day exp. moving average for the open price
  emaInd <- EMA(Op(symbolDF),n = 5)
  
  
  smaInd <- SMA(Op(symbolDF), n = 5)
  
  #Calculate the MACD indicator using the std. (popular) configuration
  MACD<-MACD(Op(symbolDF),fast = 12, slow = 26, signal = 9)
  #The signal line is used as classification feature 
  MACDsignalLine <-MACD[,2]
  
  #Price direction up/down as binary classification variable calculated from the closing and opening price
  priceDelta <- Cl(symbolDF) - Op(symbolDF)
  direction <- ifelse(priceDelta > 0,"up", "down")
  
  indexCol <- index(symbolDF)
  featureData <- data.frame(indexCol, rsiInd, MACDsignalLine, smaInd, direction)
  colnames(featureData) <- c("Date", "RSI", "MACD", "SMA", "Direction")
  
  #Omit the na columns with undefined indicator values
  featureData <- na.omit(featureData)
  featureData
}

# Train the model using random forests.
trainModel <- function(trainingDataPartition) {
  fitControl <- trainControl(method = "cv", number = 3, verboseIter = FALSE)
  rfFit <- train(Direction ~ ., method = "rf", data = trainingDataPartition, trControl = fitControl)
  rfFit
}

# Predict using the given rf fit model on the given input target data.
predictModel <- function(fitModel, targetData) {
  rfPred <- predict(fitModel, newdata = targetData)
  rfPred
}

# Train and predict the given feature data using the partition training (75%) and testing data set (25%).
trainAndPredict <- function(featureData) {
  partTrain <- createDataPartition(y = featureData$Direction, p=0.75, list = FALSE)
  trainingDataPartition <- featureData[partTrain, ] 
  testingDataPartition <- featureData[-partTrain, ] 
  
  rfFit <<- trainModel(trainingDataPartition)
  rfPred <- predictModel(rfFit, testingDataPartition)
  
  predResults <- cbind(testingDataPartition, rfPred)
  colnames(predResults)[5] <- "Given Direction"
  colnames(predResults)[6] <- "Predicted Direction"
  predResults
}

#featureData <- createFeatureData("AAPL", "2010-01-01", "2013-01-01")
#out <- partitionData(tdOut)
#trainModel(td)
#preds <- trainAndPredict(featureData)









