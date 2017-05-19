#set the file path and reads the Features txt file
filePath <- file.path("C:/Users/Phil/Documents/Data_Science/Getting_And_Cleaning_Data/Final_Project/getdata%2Fprojectfiles%2FUCI HAR Dataset", "UCI HAR Dataset")
files <- list.files(filePath, recursive = TRUE)

Features <- read.csv("C:/Users/Phil/Documents/Data_Science/Getting_And_Cleaning_Data/Final_Project/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/features.txt", header = FALSE, sep = ' ' )
Features <- as.character(Features[,2])

#Read Y Data
Data_Y_Test <- read.table(file.path(filePath, "test", "y_test.txt"), header = FALSE)
Data_Y_Train <- read.table(file.path(filePath, "train", "y_train.txt"), header = FALSE)

#Read X Data
Data_X_Test <- read.table(file.path(filePath, "test", "X_test.txt"), header = FALSE)
Data_X_Train <- read.table(file.path(filePath, "train", "X_train.txt"), header = FALSE)

#Read subject test data
Data_ST_Test <- read.table(file.path(filePath, "test", "subject_test.txt"), header = FALSE)
Data_ST_Train <- read.table(file.path(filePath, "train", "subject_train.txt"), header = FALSE)

#Merge the training the test datasets
Data_Train <-  data.frame(Data_ST_Train, Data_X_Train, Data_Y_Train)
names(Data_Train) <- c(c('subject', 'activity'), Features)

Data_Test <-  data.frame(Data_ST_Test, Data_X_Test, Data_Y_Test)
names(Data_Test) <- c(c('subject', 'activity'), Features)

Data_All <- rbind(Data_Train, Data_Test)

#Extracts the measurement of the mean and standard deviation
Selection <- grep('mean|std', Features)
Subdata <- Data_All[,c(1,2,Selection + 2)]

#Provides descriptive activity names to name the activity dataset
Activity_Labels <- read.table("C:/Users/Phil/Documents/Data_Science/Getting_And_Cleaning_Data/Final_Project/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", header = FALSE)
Activity_Labels_V2 <- as.character(Activity_Labels[,2])
Subdata$subject <- Activity_Labels_V2[Subdata$subject]

#renames and appropriately lables the data set with descriptive variable names
names(Subdata)<-gsub("^t", "Time ", names(Subdata))
names(Subdata)<-gsub("^f", "Frequency ", names(Subdata))
names(Subdata)<-gsub("Acc", " Accelerometer", names(Subdata))
names(Subdata)<-gsub("Gyro", " Gyroscope", names(Subdata))
names(Subdata)<-gsub("Mag", " Magnitude", names(Subdata))
names(Subdata)<-gsub("BodyBody", " Body", names(Subdata))
names(Subdata)<-gsub("std", " -Standard Deviation", names(Subdata))
names(Subdata)<-gsub("-mean", " -Mean", names(Subdata))

#Tidy output setup, ordering, and output
Tidy_Output <- aggregate(. ~subject + activity, Subdata, mean)
Tidy_Output <- Tidy_Output[order(Tidy_Output$subject, Tidy_Output$activity),]
write.table(Tidy_Output, file = "tidy_data.txt", row.name=FALSE)

