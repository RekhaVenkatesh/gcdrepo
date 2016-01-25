##Getting and Cleaning Data Course Project

  ##Required library to load
  library(dplyr)

#1.Merges two dataset training and test sets to create one data set
  
  message("#1.Merges two dataset training and test sets to create one data set")
  
  #Two data files are in the folder ./data/test/X_test.txt and 
  #.data/train/X_train.txt. We will load those datasets and merge them
  message("\tBuilding test data set...")
  testX <- read.table("./data/test/X_test.txt") ##2947,561
  testLabel <- read.table("./data/test/y_test.txt")#2947,1
  testSub <- read.table("./data/test/subject_test.txt")#2947,1
  #combine label and data
  test <- cbind(testSub, testLabel,testX)
  
  message("\tBuilding train data set...")
  trainX <- read.table("./data/train/X_train.txt") ##7352,561
  trainLabel <- read.table("./data/train/y_train.txt")#7352,1
  trainSub <- read.table("./data/train/subject_train.txt")#7352,1
  train <- cbind(trainSub, trainLabel, trainX)
  
  message("\tCombine training and test dataset...")
  #Combine training and test dataset
  dfMain <- rbind(train, test) ##[10299,563]

#4. Appropriately labels the data sets with descriptive variable names
  message("#4. Appropriately labels the data sets with descriptive variable names")
  
  #Tidy the main data by giving column names from features table 
  ##Lets load the feature labels from features.txt. 
  #these will form the column labels for our dfMain dataset
  features <- read.table("./data/features.txt") ##[561,2]
  cNames <- as.character(features$V2) ##as character array
  ##first column is subject, second is activity, then comes features labels
  colnames(dfMain) <- c("subject", "activity", cNames) ##562 columns
  
  message("\tThere are duplicated column names. We are going to tidy it")
  ##There are duplicated column names. We are going to tidy it
  dfMain <- dfMain[, !duplicated(colnames(dfMain))]
  ##this has dimesions of 10299, 479

#3. Uses Descriptive activity names to name activities in the data set
  message("#3. Uses Descriptive activity names to name activities in the data set")
  
  ##Now the values for "activity" columns are numbers, lets convert them into
  ##labels. Read the labels off "activity_labels.txt" in data directory
  lbls <- read.table("./data/activity_labels.txt")
  ##write a function that returns the label for given index
  lookup <- lbls[,2] ##create a lookup index
  ##Replace the values in activity column with the labels
  dfMain <- dfMain %>% mutate(activity = lookup[activity])
  message("\tReplaced activity with labels")
  
#2. Extracts only the measurements on the mean and standard deviation for each measurement
  message("#2.Extracts only the measurements on the mean and standard deviation for each measurement")
  
  ##Select only those columns that measure mean and satndard deviation
  ##we will select only thos columns that contain word "mean" and "std()" in them
  dfMain <- dfMain[, grep("subject|activity|std()|mean()", colnames(dfMain))]
  ##dimension are 10299, 81

#5. From the data set in step 4 creates a second independent tidy data set with the 
#   average of each variable for each activity and each subject.
  message("#5.Creates a second independent tidy data set with the average of each variable for each activity and each subject.")
  tidyDs <- dfMain %>% 
            aggregate(list(Subject = dfMain$subject, Activity = dfMain$activity), 
                      FUN=mean) %>%
            select(-c(subject, activity)) ##remove duplicate columns

  #Should be sorted by subject, by activity, with mean values for each measure
  tidyDs <- tidyDs[order(tidyDs$Subject),] 

  message("\tDump the tidy dataset to a CSV file called tidy_data.csv")
  #Dump this dataset to a file and call it tidy_data.csv
  write.csv(tidyDs, file="tidy_data.csv", row.names = FALSE)
  
  message("Check the current folder for a file called tidy_data.csv")
  

