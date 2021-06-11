
#### Read data  ####

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","features"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("classLabels", "activity"))
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$features)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$features)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "classLabels")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "classLabels")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")


#### Merge sets ####
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
data <- cbind(subject, x, y)

#### Extract only the measurements which contain mean or standard deviation information ####

data <- data %>% select(subject, classLabels, contains("mean"), contains("std"))

#### Replace classLabels by activity names ####

data$classLabels <- activities[data$classLabels, 2]

#### Fourth step ####

names(data)[2] = "Activity"
names(data)<-gsub("subject", "Subject", names(data))
names(data)<-gsub("angle", "Angle", names(data))
names(data)<-gsub("gravity", "Gravity", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("tBody", "TimeBody", names(data))
names(data)<-gsub("(-)?mean()", "Mean", names(data), ignore.case = TRUE)
names(data)<-gsub("(-)?std", "Std", names(data), ignore.case = TRUE)
names(data)<-gsub("(-)?freq()", "Frequency", names(data), ignore.case = TRUE)
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub('\\.', "", names(data))

#### Fifth step  ####

tidyData <- data %>%
  group_by(Subject, Activity) %>%
  summarise_all(list(mean = mean))

#### Write output file  ####
write.table(tidyData, file = "tidyData.txt", row.names = FALSE)

