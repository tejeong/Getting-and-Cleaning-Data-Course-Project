## Create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

library("data.table")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[, 2]
features <- read.table("./UCI HAR Dataset/features.txt")[, 2]
extract_features <- grepl("mean|std", features)

## train data

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

# Appropriately labels the data set with descriptive variable names.
names(X_train) <- features

# Extracts only the measurements on the mean and standard deviation for each measurement.
X_train <- X_train[, extract_features]

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_train[, 2] <- activity_labels[y_train[, 1]]
# Uses descriptive activity names to name the activities in the data set
names(y_train) <- c("Activity_ID", "Activity_Label")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(subject_train) <- "subject"

train_data <- cbind(subject_train, y_train, X_train)

## test data

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

# Appropriately labels the data set with descriptive variable names.
names(X_test) <- features

# Extracts only the measurements on the mean and standard deviation for each measurement.
X_test <- X_test[, extract_features]

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_test[, 2] <- activity_labels[y_test[, 1]]

# Uses descriptive activity names to name the activities in the data set
names(y_test) <- c("Activity_ID", "Activity_Label")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(subject_test) <- "subject"

test_data <- cbind(subject_test, y_test, X_test)

## Merges the training and the test sets to create one data set.
data <- rbind(train_data, test_data)

id_labels = c("subject", "Activity_ID", "Activity_Label")
variable_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id.vars = id_labels, measure.vars = variable_labels)

## Creates a second, independent tidy data set with the average of each variable 
## for each activity and each subject.
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)
