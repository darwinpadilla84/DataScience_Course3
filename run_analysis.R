#install.packages("data.table");install.packages("reshape2")
library(data.table);library(reshape2);library(dplyr)
#You should create one R script called run_analysis.R that does the following.

#1.Merges the training and the test sets to create one data set.
rm(list = ls()) #Borrar los archivos existentes en memoria
#setwd("E:\\DataScience") #Direccionar el trabajo a una carpeta específica
if(!file.exists("./data")){dir.create("./data")} #Crear una carpeta que contengan los datos
fileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" #Dirección para extraer la data
download.file(fileUrl,destfile = "./data/data.zip") #Descargar la data en la carpeta creada en el paso anterior
unzip(zipfile = "./data/data.zip") #Descomprimir la data
getwd()

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
names(activity_labels)[c(1,2)] <- c("Labels","ActivityN")

features <- read.table("./UCI HAR Dataset/features.txt", quote="\"", comment.char="")
names(features)[c(1,2)] <- c("Labels","FeatureNames")

#2.Extracts only the measurements on the mean and standard deviation for each measurement.
featuresWhich <- grep("(mean|std)\\(\\)", features[,2])
measurements <- features[featuresWhich, 2]
measurements <- gsub('[()]', '', measurements)
path <- getwd()

#3.Uses descriptive activity names to name the activities in the data set
# Load train datasets
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWhich, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)

# Load test datasets
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWhich, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivities, test)

# merge datasets
combined <- rbind(train, test)

#4. Appropriately labels the data set with descriptive variable names.
combined[["Activity"]] <- factor(combined[, Activity]
                                 , levels = activity_labels[["Labels"]]
                                 , labels = activity_labels[["ActivityN"]])

combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each
#variable for each activity and each subject.
combined2 <- combined %>%group_by(Activity,SubjectNum)%>%
    mutate(mean_c=mean(combined[,3:68]))%>%
    arrange(mean_c,Activity,SubjectNum)
