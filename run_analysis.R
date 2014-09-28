##  Set the workplace into the UCI data set folder
setwd("~/R/Working Directory/UCI HAR Dataset/")

##  Read the training-related dataset 
trainSubject <- read.delim("train/subject_train.txt", header = F, sep = "")
trainActivity <- read.delim("train/y_train.txt", header = F, sep = "")
trainData <- read.delim("train/X_train.txt", header = F, sep = "")

##  Combine the training-related dataset
training <- cbind(trainSubject, trainActivity, trainData)


##  Read the testing-related dataset 
testSubject <- read.delim("test/subject_test.txt", header = F, sep = "")
testActivity <- read.delim("test/y_test.txt", header = F, sep = "")
testData <- read.delim("test/X_test.txt", header = F, sep = "")

##  Combine the testing-related dataset 
testing <- cbind(testSubject, testActivity, testData)

##  Combine the training and testing dataset
allData <- rbind(training, testing)

##  Read the features and attach it to the allData as column names
feature <- read.delim("features.txt", header = F, sep = "")
header <- c("Subject", "Activity", as.vector(feature$V2))
names(allData) <- header

##  Only show the columns about mean and standard deviation
indicesHeader <- grep("*mean*|*std*", header, ignore.case = T)
tailoredData <- allData[, c(1, 2, indicesHeader)]

##  replace the activity values from numbers to descriptive text
activityLabel <- read.delim("activity_labels.txt", header = F, sep = "")
mergedData <- merge(tailoredData, activityLabel, by.x = "Activity", by.y = "V1")

##  clean up the merged data by exluding duplicates column and re-order the columns
mergedData[, 1] <- mergedData[, 89]
mergedData <- mergedData[, c(2, 1, 3:88)]

##  change the column names to more standard and readable names
names(mergedData) <- gsub("mean", "Mean", names(mergedData))
names(mergedData) <- gsub("std", "Std", names(mergedData))
names(mergedData) <- gsub("\\(\\)|\\)", "", names(mergedData))
names(mergedData) <- gsub("-|,|\\(", "_", names(mergedData))

##  produce a tidy dataset that only shows the average of other column values grouping by subject and activity
tidy <- aggregate(mergedData, by = list(Subject = mergedData$Subject, Activity = mergedData$Activity), mean)
tidy <- tidy[, -(3:4)]

##  export the tidy dataset to a tab delimited text file
write.table(tidy, "tidy.txt", sep = "\t")
