# Accelerometer Data from Samsung S2

  #read in all applicable tables - features will be column headings, activity labels will be associated to activity code,
  #subjects for test/train, results for test/train

headernames <- read.table("features.txt", col.names = c("EntryNo", "Description"))
  #to clean up the variable names
    headernames$Description <- gsub("\\()", "", headernames$Description)
    headernames$Description <- gsub("\\-", "", headernames$Description)
actnames <- read.table("activity_labels.txt", col.names = c("ActivityID", "ActivityName"))
testusers <- read.table("test/subject_test.txt", col.names = "UserID")
trainusers <- read.table("train/subject_train.txt", col.names = "UserID")
testact <- read.table("test/y_test.txt", col.names = "ActivityID")
  #associate the activity name with its number and then combine the user ids with the activity per observation     
    testact["ActivityName"] <- actnames$ActivityName[match(testact$ActivityID, actnames$ActivityID)]
    testact <- cbind(testusers, testact) 
trainactivity <- read.table("train/y_train.txt", col.names = "ActivityID")
    trainactivity["ActivityName"] <- actnames$ActivityName[match(trainactivity$ActivityID, actnames$ActivityID)]
    trainactivity <- cbind(trainusers, trainactivity)
testresults <- read.table("test/x_test.txt", col.names = t(headernames$Description))
  #combine the activities, users with the results per observation    
    testresults <- cbind(testact, testresults) 
trainresults <- read.table("train/x_train.txt", col.names = t(headernames$Description))
    trainresults <- cbind(trainactivity, trainresults)
  #merge the two datasets together
altogether <- rbind(testresults, trainresults)
  #Select only the mean and the std deviation columns (using dplyr package)
library(dplyr)
library(reshape2)
library(data.table)
meanstd <- select(altogether, 1, 3, contains("mean"), contains("std"))
  #create a new dataset showing the average of each variable for each activity & subject
  #melt the table first and then apply dcast to group by activity and subject and apply the mean function
moltentable <- melt(meanstd, id = c("UserID", "ActivityName"), measure.vars = 3:86)
avetable <- dcast(moltentable, UserID + ActivityName ~ variable, mean)
#head(avetable) for testing purposes only
#head(meanstd) 

