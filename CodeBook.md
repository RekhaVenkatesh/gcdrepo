---
title: "CodeBook"
author: "RekhaVenkatesh"
date: "January 20, 2016"
output: html_document
---

This codebook was generated as part of Getting and Cleaning Data Course Project. 
Goal of the project was to prepare a tidy dataset that could be used for analysis. The source of the raw, messy, data files was: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A folder "data" was created in the current directory and the downloded zip file was extracted to this folder. Reuired library "dplyr" was loaded:
```{r}
  library(dplyr)
```

Original data set was broken down into two sets: test and train. The subjects participating in the trail were also split into either train or test candidates. So, the first task was to merge these two datasets into one comprehensive set.This task required that we combine data spread in three files: subject_test.txt, y_test.txt, and X_test.txt in that order. The same process was repeated for train. Then both the datasets were merged to form the main data set. 

```{r}
  dfMain <- rbind(train, test) ##[10299,563]
```

The original dataset also split the labels for each of the 561 features captured in a file called features.txt. The columns names were captured and applied to the dfMain dataset. Simialrly the labels for the actviity were in a file called activity_labels.txt. They were captured and all the "activity" column was updated to now show the labels.

```{r}
 colnames(dfMain) <- c("subject", "activity", cNames) ##562 columns
 dfMain <- dfMain %>% mutate(activity = lookup[activity])
```

It was also found that the column names were repeated. Duplicate column names had to be removed.

```{r}
   dfMain <- dfMain[, !duplicated(colnames(dfMain))] ##this has dimesions of 10299, 479
```

Another requirement of the project was to extract only the mean and standard deviation measurement. To capture only these features, program uses the grep function that reduced the number of columns to 81:

```{r}
    dfMain <- dfMain[, grep("subject|activity|std()|mean()", colnames(dfMain))] ##[10299, 81]
```
Now that we had cleaned up the data, as per the requirement program sets to building a tidy data set. The requirement was to capture average of each varibale for each activity and each subject. This was done by using the aggregate function. First the data was grouped by subject, then by activity, and then mean of each column was found.

```{r}
  tidyDs <- dfMain %>% 
            aggregate(list(Subject = dfMain$subject, Activity = dfMain$activity), 
                      FUN=mean) %>%
            select(-c(subject, activity)) ##remove duplicate columns
```

The resulting tidy data set was written to a CSV file called tidy_data.csv.

```{r}
  write.csv(tidyDs, file="tidy_data.csv", row.names = FALSE)
```

The section below will list the variable in this dataset.This data has 81 column names. The columns are:

1. Subject                        : int  
2. Activity                       : Factor w/ 6 levels WALKING,         WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

All the columns below are of type: num
__Note: The data present in the dataset is average of each activity and each subject. __

3. tBodyAcc-mean()-X                 
4. tBodyAcc-mean()-Y               
5. tBodyAcc-mean()-Z                 
6. tBodyAcc-std()-X                
7. tBodyAcc-std()-Y                  
8. tBodyAcc-std()-Z                
9.   tGravityAcc-mean()-X             
10. tGravityAcc-mean()-Y            
11.   tGravityAcc-mean()-Z              
12.  tGravityAcc-std()-X             
13.   tGravityAcc-std()-Y               
14.  tGravityAcc-std()-Z             
15.   tBodyAccJerk-mean()-X             
16.  tBodyAccJerk-mean()-Y           
17.   tBodyAccJerk-mean()-Z             
18.  tBodyAccJerk-std()-X            
19.   tBodyAccJerk-std()-Y              
20.  tBodyAccJerk-std()-Z            
21.   tBodyGyro-mean()-X                
22.  tBodyGyro-mean()-Y              
23.   tBodyGyro-mean()-Z                
24.  tBodyGyro-std()-X               
25.   tBodyGyro-std()-Y                 
26.  tBodyGyro-std()-Z               
27.   tBodyGyroJerk-mean()-X            
28.  tBodyGyroJerk-mean()-Y          
29.   tBodyGyroJerk-mean()-Z            
30.  tBodyGyroJerk-std()-X           
31.   tBodyGyroJerk-std()-Y             
32.  tBodyGyroJerk-std()-Z           
33.   tBodyAccMag-mean()                
34.  tBodyAccMag-std()               
35.   tGravityAccMag-mean()             
36.  tGravityAccMag-std()            
37.   tBodyAccJerkMag-mean()            
38.  tBodyAccJerkMag-std()           
39.   tBodyGyroMag-mean()               
40.  tBodyGyroMag-std()              
41.   tBodyGyroJerkMag-mean()           
42.  tBodyGyroJerkMag-std()          
43.   fBodyAcc-mean()-X                 
44.  fBodyAcc-mean()-Y               
45.   fBodyAcc-mean()-Z                 
46.  fBodyAcc-std()-X                
47.   fBodyAcc-std()-Y                  
48.  fBodyAcc-std()-Z                
49.   fBodyAcc-meanFreq()-X             
50.  fBodyAcc-meanFreq()-Y           
51.   fBodyAcc-meanFreq()-Z             
52.  fBodyAccJerk-mean()-X           
53.   fBodyAccJerk-mean()-Y             
54.  fBodyAccJerk-mean()-Z           
55.   fBodyAccJerk-std()-X              
56.  fBodyAccJerk-std()-Y            
57.   fBodyAccJerk-std()-Z              
58.  fBodyAccJerk-meanFreq()-X       
59.   fBodyAccJerk-meanFreq()-Y         
60. fBodyAccJerk-meanFreq()-Z       
61.   fBodyGyro-mean()-X                
62.  fBodyGyro-mean()-Y              
63.   fBodyGyro-mean()-Z                
64.  fBodyGyro-std()-X               
65.   fBodyGyro-std()-Y                 
66.  fBodyGyro-std()-Z               
67.   fBodyGyro-meanFreq()-X            
68.  fBodyGyro-meanFreq()-Y          
69.   fBodyGyro-meanFreq()-Z            
70.  fBodyAccMag-mean()              
71.   fBodyAccMag-std()                 
72.  fBodyAccMag-meanFreq()          
73.   fBodyBodyAccJerkMag-mean()        
74.  fBodyBodyAccJerkMag-std()       
75.   fBodyBodyAccJerkMag-meanFreq()    
76.  fBodyBodyGyroMag-mean()         
77.   fBodyBodyGyroMag-std()            
78.  fBodyBodyGyroMag-meanFreq()     
79.   fBodyBodyGyroJerkMag-mean()       
80.  fBodyBodyGyroJerkMag-std()      
81.   fBodyBodyGyroJerkMag-meanFreq() 



