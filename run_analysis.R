
#downloading the data set and unzipping the file
fileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <-"courseraweek4.zip"
if(!file.exists(filename))
    download.file(fileUrl,filename,method='curl')
if (!file.exists('UCI HAR Dataset')) 
    unzip(filename)

# Reading the data and assigning correct column names

feature <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = feature$functions)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = feature$functions)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merging the train and test data to create one dataset
x <- rbind(xtrain, xtest)
y <- rbind(ytrain, ytest)
subject <- rbind(subjecttrain, subjecttest)
mergeddata <- cbind(subject, y, x)

#extracting colums that contain mean and standard deviation definition 
tidy <- mergeddata %>% select(subject, code, contains("mean"), contains("std"))

#Give descriptive name to each activity
names(tidy)[2] = "activity"
names(tidy)<-gsub("Acc", "accelerometer", names(tidy))
names(tidy)<-gsub("Gyro", "gyroscope", names(tidy))
names(tidy)<-gsub("BodyBody", "body", names(tidy))
names(tidy)<-gsub("Mag", "magnitude", names(tidy))
names(tidy)<-gsub("^t", "time", names(tidy))
names(tidy)<-gsub("^f", "frequency", names(tidy))
names(tidy)<-gsub("tBody", "timebody", names(tidy))
names(tidy)<-gsub("-mean()", "mean", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-std()", "std dev", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-freq()", "frequency", names(tidy), ignore.case = TRUE)

#summarizing and grouping the data
finaldata <- tidy %>% 
    group_by(subject,activity) %>% 
    summarise_all(funs(mean))
write.table(finaldata,"finaldata.txt",row.name=FALSE)