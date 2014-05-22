# Getting and Cleaning Data Project
#
# Original Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Original Data Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#

#installing packages
install.package <- "reshape2"
library(reshape2)


#setting directories
if(!file.exists("assignment")){dir.create("assignment")}
list.files()
setwd("C:\\Users\\Propietario\\Documents\\Coursera\\Getting and Cleaning Data\\assignment")
if(!file.exists("data")){dir.create("data")}
list.files()
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./data/Dataset.zip")) {download.file(fileURL,destfile="./data/Dataset.zip")}

if (!file.exists("UCI HAR DATASET")) {
  unzip("Dataset.zip", overwrite = TRUE)
}
list.files("./UCI HAR Dataset")
list.files("./UCI HAR Dataset/test")
list.files("./UCI HAR Dataset/train")



#getting meta_data
activity_lbl <- read.table("./UCI HAR Dataset/activity_labels.txt", sep = "" , header=FALSE )
dim(activity_lbl)
activity_lbl
colnames(activity_lbl) <- c("label", "activity")
activity_lbl

#renaming the variables names
features <- read.table("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
dim(features)
features2 <- features[,2]
features3 <- gsub(pattern="\\(",replacement="",features2)
features_lbl <- gsub(pattern="\\)",replacement="",features3)



#getting and reshaping the train data
train_data <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep = "" , stringsAsFactors=FALSE, header=FALSE )
sub_train <- read.csv("./UCI HAR Dataset/train/Subject_train.txt", sep = "" , stringsAsFactors=FALSE, header=FALSE )
train_dataLbl <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep = "" , stringsAsFactors=FALSE, header=FALSE )
dim(train_data)
dim(sub_train)
dim(train_dataLbl)
unique(sub_train)
unique(train_dataLbl)
colnames(train_dataLbl) <- c("label")
colnames(sub_train) <- c("subject")
colnames(train_data) <- features_lbl
train_dataset <- cbind(train_dataLbl,sub_train,train_data)

#getting and reshaping the test data
test_data <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep = "" , stringsAsFactors=FALSE, header=FALSE )
sub_test <- read.csv("./UCI HAR Dataset/test/Subject_test.txt", sep = "" , stringsAsFactors=FALSE, header=FALSE )
test_dataLbl <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep = "" , stringsAsFactors=FALSE, header=FALSE )
dim(test_data)
dim(test_dataLbl)
dim(sub_test)
unique(test_dataLbl)
unique(sub_test)

colnames(test_dataLbl) <- c("label")
colnames(sub_test) <- c("subject")
colnames(test_data) <- features_lbl

test_dataset<- cbind(test_dataLbl,sub_test,test_data)



#merging both datasets

all_data <- rbind(train_dataset,test_dataset)
all_data[1:2,1:5]


#naming the labels

all_data_lbld <- merge(activity_lbl,all_data)
all_data_lbld[1:2,1:5]

#obtaining the first dataset

tidy_data_1 <- subset(all_data_lbld, select = grepl("mean|std", features_lbl))

dim(tidy_data_1)

write.table(tidy_data_1, file = "tidy_data_1.txt", sep = "\t", row.names = FALSE)


#obtaining the second tidy dataset
melted_data<-melt(tidy_data_1,id=c("activity","subject"))

tidy_data_2 <- dcast(melted_data, activity + subject ~ variable, mean) 

dim(tidy_data_2)

write.table(tidy_data_2, file = "tidy_data_2.txt", sep = "\t", row.names = FALSE)

#cleaning useless data
rm('train_dataset','test_dataset','train_data','test_data','all_data')
