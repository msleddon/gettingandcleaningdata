## run_analysis.R
## reads and merges Human Activity Recognition datasets to produce mean average results by subject and activity

library(plyr)

## read the training data, activity labels and subjects into data frames
trainData <- read.table("train/X_train.txt")
trainLabels <- read.table("train/y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")

## read the test data, activity labels and subjects into data frames
testData <- read.table("test/X_test.txt")
testLabels <- read.table("test/y_test.txt")
testSubjects <- read.table("test/subject_test.txt")

## join the train and test data sets
combinedData <- rbind(trainData, testData)
combinedLabels <- rbind(trainLabels, testLabels)
combinedSubjects <- rbind(trainSubjects, testSubjects)

## read the features into a data frame and create a subset of the required features
allFeatures <- read.table("features.txt") ## load 561 features labels 
reqdFeatures <- grep("-mean\\(\\)|-std\\(\\)",allFeatures[,2])

## read the activity label names into a data frame and replace the combined data IDs with the label names
activityNames <- read.table("activity_labels.txt") ## load 6 activity_labels
combinedLabels[,1] <- activityNames[combinedLabels[,1],2]

## correct the column names for the activities and subjects
names(combinedLabels) <- "activity"
names(combinedSubjects) <- "subject"

## subset the combined data for only the required features
reqdData <- combinedData[, reqdFeatures]

## make the column names more readable
names(reqdData) <- allFeatures[reqdFeatures,2]
names(reqdData) <- gsub("-mean\\(\\)"," Mean",names(reqdData))
names(reqdData) <- gsub("-std\\(\\)"," StdDev",names(reqdData))

## append the reqdData to the Subjects and Activities
reqdData <- cbind(combinedSubjects, combinedLabels, reqdData)

## create a second data set with averages by subject and activity
avgData <- aggregate( . ~ subject:activity, reqdData, mean)

## write the data to file
write.table(avgData, "averages_data.txt", row.name=FALSE)

