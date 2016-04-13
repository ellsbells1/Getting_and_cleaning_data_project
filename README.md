# Getting_and_cleaning_data_project

You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

##Aim overview

The aim of this project is to show how data can be collected and cleaned reulting in a tidy dataset that is ready for use in further analysis. 

In order to do this, the original data file needed modification before tit can be processed. This can be seen in the run_analysis.R file in this repo. 



## Assignment summary:

You should create one R script called run_analysis.R that does the following:
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Additional info 

### Process description 
 (for the full script, please see run_analysis.R)

Firstly, the data needs to be downloaded,this is done with the following script which takes the URL and then downloads the data associated with that URL. Curl was added as I was downloading onto a Mac.

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "PATHWAY", method = "curl")

Next, the file needs to be unzipped to expose the files within, this iwas done with the following script which states where to unzip from:
unzip(zipfile="PATHWAY",exdir="./data")


Once unipped, I wanted to view the files, so did so ith this:
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)


Next I wanted to read in the data, from each of the files that were enclosed within the original file "getting-and-cleaning-data.zip:

ATest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ATrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
STrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
STest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
Test  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
Train <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

The first thing that was asked was for the test and training datasets were merged into one data det, to do this i used the rbind command. 

dataCombined <-cbind(dataS, dataA)
Wholedata <- cbind(testtrain, dataCombined)
View(Wholedata)

Viewing it at this point showed that the vairables names had now been picked up so i went back and added the varible names and the remerged resulting in one dataset complete with variable names

names(dataS)<-c("subject")
names(dataA)<- c("activity")
testtrainnames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(testtrain)<- testtrainnames$V2
dataCombined <-cbind(dataS, dataA)
Wholedata <- cbind(testtrain, dataCombined)
View(Wholedata)

The measurements of the mean and standard deviation (sd) were wanted to those needed to be extracted from the dataet I'd just made, grep was used to locate the specified variables and create a subset where only they would show, then the subset needed labeling with appropriate vairable names.


The activity names were included in a txt file from the original download, these needed to be added to the datatset and substiture the numbers that were there representing them, firsly the labels needed to be read in from the txt file

activity_labels <- read.table(file.path(path_rf, "activity_labels.txt"), header=FALSE)


This shows how I substituted the numbers for the activity labels and viewing afterwards to make sure it looked correct:
MeanorStdData$activity <-as.character(MeanorStdData$activity)
MeanorStdData$activity[MeanorStdData$activity ==1] <- "Walking"
MeanorStdData$activity[MeanorStdData$activity ==2] <- "Walking Upstairs"
MeanorStdData$activity[MeanorStdData$activity ==3] <- "Walking Downstairs"
MeanorStdData$activity[MeanorStdData$activity ==4] <- "Sitting"
MeanorStdData$activity[MeanorStdData$activity ==5] <- "Standing"
MeanorStdData$activity[MeanorStdData$activity ==6] <- "Laying"

View(MeanorStdData)
names(MeanorStdData)

Again, substituting the appreviated names from the original data for meaningful variable names was needed.Gsub was used to do this:
f for frequency
t for time
Gyro for Gyroscope
BodyBody for Body
Acc for Accelerometer
Mag for Magnitute


A new tidy data table was needed which included the means for each subject and each activity (this was created at the pervious step), using the write.table() command this was done and the new file was added to the specified path location.
