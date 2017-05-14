library(plyr)

#Download and unzip data
if(!file.exists("./data")){dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Read data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

labels <- read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Merge all rows
x_total <- rbind(x_test, x_train)
y_total <- rbind(y_test, y_train)
subject_total <- rbind(subject_test, subject_train)

y_total_labels <- join(y_total, labels)
activity <- data.frame(y_total_labels$V2)

#Name all columns
colnames(x_total) <- features$V2
colnames(activity) <- "activity"
colnames(subject_total) <- "subject"

#Select all colums with mean or std
x_subset <- x_total[grep("mean\\(\\)|std\\(\\)", names(x_total), value = TRUE)]

#Merge all columns
set_total <- cbind(subject_total, activity, x_subset)

#Label the dataset with descriptive variable names
names(set_total) <- gsub("^t", "time", names(set_total))
names(set_total) <- gsub("^f", "frequency", names(set_total))
names(set_total) <- gsub("Acc", "Accelerometer", names(set_total))
names(set_total) <- gsub("Gyro", "Gyroscope", names(set_total))
names(set_total) <- gsub("Mag", "Magnitude", names(set_total))
names(set_total) <- gsub("BodyBody", "Body", names(set_total))
names(set_total) <- tolower(names(set_total))

View(set_total)

#Create a second, independent tidy data set with the average of each variable for each activity and each subject
set_total2 <- aggregate(. ~subject + activity, set_total, mean)

#Export the set
write.table(set_total2, "tidyset.txt", row.names = FALSE, quote = FALSE)