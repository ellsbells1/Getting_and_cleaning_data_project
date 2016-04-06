## You should create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## download data set into R
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "/Users/eleanordurant/downloads/getting-and-cleaning-data.zip", method = "curl")

##unzip the file
unzip(zipfile="./downloads/getting-and-cleaning-data.zip",exdir="./data")


## view unzipped files
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

## Read in the data
ATest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ATrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
STrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
STest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
Test  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
Train <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

## 1. Merges the training and the test sets to create one data set.
dataS <-rbind(STrain, STest)
dataA <- rbind(ATrain, ATest)
testtrain <-rbind(Train, Test)

dataCombined <-cbind(dataS, dataA)
Wholedata <- cbind(testtrain, dataCombined)

## view merged dataset
View(Wholedata)

##getting names for vairables
names(dataS)<-c("subject")
names(dataA)<- c("activity")
testtrainnames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(testtrain)<- testtrainnames$V2

##remerging
dataCombined <-cbind(dataS, dataA)
Wholedata <- cbind(testtrain, dataCombined)

##check dataset
View(Wholedata)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
meanorstd <-testtrainnames$V2[grep("mean\\(\\)|std\\(\\)", testtrainnames$V2)]

## label subset
selectedNames<-c(as.character(meanorstd), "subject", "activity" )
> MeanorStdData<-subset(Wholedata,select=selectedNames)
> View(MeanorStdData)


## 3. Uses descriptive activity names to name the activities in the data set 

## read in labels from activity_labels text file
activity_labels <- read.table(file.path(path_rf, "activity_labels.txt"), header=FALSE)

##look at dataset variables
View(activity_labels)
View(MeanorStdData)

## substituting numbers for activity names
MeanorStdData$activity <-as.character(MeanorStdData$activity)
MeanorStdData$activity[MeanorStdData$activity ==1] <- "Walking"
MeanorStdData$activity[MeanorStdData$activity ==2] <- "Walking Upstairs"
MeanorStdData$activity[MeanorStdData$activity ==3] <- "Walking Downstairs"
MeanorStdData$activity[MeanorStdData$activity ==4] <- "Sitting"
MeanorStdData$activity[MeanorStdData$activity ==5] <- "Standing"
MeanorStdData$activity[MeanorStdData$activity ==6] <- "Laying"


##check activity names in dataset
View(MeanorStdData)
names(MeanorStdData)

## 4. Appropriately label the data set with descriptive variable names.

##label dataset 

##assess the variables names
names(MeanorStdData)

## change variable names to more descriptive names
names(MeanorStdData)<- gsub("^f", "frequency", names (MeanorStdData))
names(MeanorStdData)<- gsub("^t", "time", names (MeanorStdData))
names(MeanorStdData)<- gsub("Gyro", "Gyroscope", names (MeanorStdData))
names(MeanorStdData)<- gsub("BodyBody", "Body", names (MeanorStdData))
names(MeanorStdData)<- gsub("Acc", "Accelerometer", names (MeanorStdData))
names(MeanorStdData)<- gsub("Mag", "Magnitude", names (MeanorStdData))


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## dataset from step 4 = MeanorStdData
## create a second independent dataset
Tidy <- data.table(MeanorStdData)

##calculate the average (mean) for each variable for each activity and each subject (person)
TidyAvg <- Tidy [,lapply(.SD, mean), by 'participants', 'activity']
