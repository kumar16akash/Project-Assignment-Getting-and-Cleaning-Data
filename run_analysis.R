# Files have been already downloaded and all the scripts and files are in a particular folder.
# Inside which there are two folders named as "train" & "test"

# Getting all the datasets

library(reshape2)

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

## Assigning Column names to variables in test & training dataset

colnames(y_test) <- "activity_code"
colnames(y_train) <- "activity_code"
colnames(x_test) <- features[,2]
colnames(x_train) <- features[,2]
colnames(subject_test) <- "subject_code"
colnames(subject_train) <- "subject_code"
colnames(activity_labels) <- c("activity_code","activity_type")

#Merging both the train & test dataset to one.

merged_test <- cbind(subject_test,y_test,x_test)
merged_train <- cbind(subject_train,y_train,x_train)
merged_all <- rbind(merged_train,merged_test)

#Extracting the mean and standard deviation values

col_Names <- colnames(merged_all)
logical_Mean_StdDevn <- (grepl("subject_code",col_Names) | grepl("activity_code",col_Names) | grepl("mean",col_Names) | grepl("mean",col_Names) )

Mean_StanDevn <- merged_all[,logical_Mean_StdDevn==TRUE]

#Replacing the values of activity_code(1-6) & subject_code)(1-30) to the corresponding characters 

Mean_StanDevn$activity_code <- factor(Mean_StanDevn$activity_code,levels=activity_labels[,1],labels=activity_labels[,2])
Mean_StanDevn$subject_code<- as.factor(Mean_StanDevn$subject_code)

#For a specific activity of a particular subject, mean has been taken for all the values corresponding to that 

melted_mean <- melt(Mean_StanDevn,id=c("subject_code","activity_code"))
melted_mean <- dcast(melted_mean, subject_code + activity_code ~ variable,mean)

#Final Tidy dataset exported as "Tidy_mean.txt"

write.table(melted_mean, file = "Tidy_mean.txt",row.names = FALSE, quote = FALSE)


