## Getting and Cleaning Data Assignment

filename <- "UCI_HAR_Dataset.zip"

# Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file (fileURL, filename)
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Read activity labels and features files
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# Get means and standard deviations 
meansd <- grep(".*mean.*|.*std.*", features[,2])
meansd_features <- features[meansd,2]
meansd_features = gsub('-mean', 'Mean', meansd_features)
meansd_features = gsub('-std', 'Std', meansd_features)
meansd_features <- gsub('[-()]', '', meansd_features)

# Load the train and test datasets individually and combine them to make larger datasets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")[meansd]
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train, y_train, x_train)

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")[meansd]
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, y_test, x_test)

# Merge datasets and label them
MergeData <- rbind(train, test)
colnames(MergeData) <- c("subject", "activity", meansd_features)
MergeData$activity <- factor(MergeData$activity, levels = activity_labels[,1], labels = activity_labels[,2])

library(reshape2)
melted_MergeData <- melt(MergeData, id = c("subject", "activity"))
mean_MergeData <- dcast(melted_MergeData, subject + activity ~ variable, mean)

# Make a new tidy dataset with the merged dataset
write.table(mean_MergeData, "tidy.txt", row.names = FALSE, quote = FALSE)