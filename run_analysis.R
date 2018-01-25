library(reshape2)
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

colnames(y_test) <- "activity_code"
colnames(y_train) <- "activity_code"
colnames(x_test) <- features[,2]
colnames(x_train) <- features[,2]
colnames(subject_test) <- "subject_code"
colnames(subject_train) <- "subject_code"
colnames(activity_labels) <- c("activity_code","activity_type")

#Merge--------------------------------------

merged_test <- cbind(subject_test,y_test,x_test)
merged_train <- cbind(subject_train,y_train,x_train)
merged_all <- rbind(merged_train,merged_test)

#Extraction------
col_Names <- colnames(merged_all)
logical_Mean_StdDevn <- (grepl("subject_code",col_Names) | grepl("activity_code",col_Names) | grepl("mean",col_Names) | grepl("mean",col_Names) )

Mean_StanDevn <- merged_all[,logical_Mean_StdDevn==TRUE]

#Naming------------------

Mean_StanDevn$activity_code <- factor(Mean_StanDevn$activity_code,levels=activity_labels[,1],labels=activity_labels[,2])
Mean_StanDevn$subject_code<- as.factor(Mean_StanDevn$subject_code)

#labeling-----------
melted_mean <- melt(Mean_StanDevn,id=c("subject_code","activity_code"))
melted_mean <- dcast(melted_mean, subject_code + activity_code ~ variable,mean)

#Final Tidy dataset

write.table(melted_mean, file = "Tidy_mean.txt",row.names = FALSE, quote = FALSE)


