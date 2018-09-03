output<-function()
{

  # The following library is mandatory to use the melt(), dcast() functions
  library(reshape2)
  
  ## Initialize some handy variables
  file <- "getdata_dataset.zip"
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  folder_name = "UCI HAR Dataset"

  features_filename = "features.txt"
  features<-paste(folder_name, features_filename, sep = "/")

  activities_filename = "activity_labels.txt"
  activities<-paste(folder_name, activities_filename, sep = "/")## Download the file
  
  
  ## Download the file if needed
  if (!file.exists(file)){
    download.file(fileURL, file, method="curl")
  }  
  
  ## Unzip the file unless it has been done already
  if (!file.exists(folder_name)) { 
    unzip(filename) 
  }
  
  # Load features
  FT_L <- read.table(features)
  FT_L[,2] <- as.character(FT_L[,2])
  
  ## Uses descriptive activity names to name the activities in the data set
  ## Appropriately labels the data set with descriptive variable names.
  
  # Load activity labels
  ACT_L <- read.table(activities)
  ACT_L[,2] <- as.character(ACT_L[,2])

  ## Extracts only the measurements on the mean and standard deviation for each measurement.
  patterns = ".*std.*|.*mean.*"

  NEW_FT <- grep(patterns, FT_L[,2])
  NEW_FT.names <- FT_L[NEW_FT,2]
  
  # Exclude respectively, mean and std
  NEW_FT.names = gsub('-Mean', 'mean', NEW_FT.names)
  NEW_FT.names = gsub('-Std', 'std', NEW_FT.names)
  
  # Clean the names
  NEW_FT.names <- gsub('[-()]', '', NEW_FT.names)

  
  # Read the train datasets
  train_Act <- read.table("UCI HAR Dataset/train/Y_train.txt")
  train_TB <- read.table("UCI HAR Dataset/train/X_train.txt")[NEW_FT]
  train_Sub <- read.table("UCI HAR Dataset/train/subject_train.txt")
  train_TB <- cbind(train_Sub, train_Act, train_TB)
  
  # Read the test datasets
 
  test_Act <- read.table("UCI HAR Dataset/test/Y_test.txt")
  test_TB <- read.table("UCI HAR Dataset/test/X_test.txt")[NEW_FT]
  test_Sub <- read.table("UCI HAR Dataset/test/subject_test.txt")
  test_TB <- cbind(test_Sub, test_Act, test_TB)
  
  # Now perform the merge of the train and test data drames 
  merged <- rbind(train_TB, test_TB)
  
  # add a set of labels to the result
  colnames(merged) <- c("Subject", "Activity", NEW_FT.names)
  
  # convert Activities in factors
  merged$Activity <- factor(merged$Activity, levels = activityLabels[,1], labels = ACT_L[,2])
  merged$Subject <- as.factor(merged$Subject)
  
  merged.melted <- melt(merged, id = c("Subject", "Activity"))
  merged.mean <- dcast(merged.melted, Subject + Activity ~ variable, mean)
  
  ## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  write.table(merged.mean, "tidy_data_set.txt", row.names = FALSE, quote = FALSE)
  
  # Some output for the user
  
  print("The file tidy.txt has been generated!")
  merged
  # Print the labels related to the activity
  print(ACT_L[,2])
  
}