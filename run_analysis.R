# Here are the data for the project:
#         
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.
# Good luck!

###TRAINING
getwd()
path1<-"C:/COURSERA/Getting and Cleaning Data/Project/UCI HAR Dataset/train/X_train.txt"
path2<-"C:/COURSERA/Getting and Cleaning Data/Project/UCI HAR Dataset/train/Y_train.txt"
path3<-"C:/COURSERA/Getting and Cleaning Data/Project/UCI HAR Dataset/train/subject_train.txt"
xtrain<-read.table(path1, stringsAsFactors = F) 
ytrain<-read.table(path2, stringsAsFactors = F)  # acctivities
names(ytrain)<-"activities"
# Features
features<-read.table("C:/COURSERA/Getting and Cleaning Data/Project/UCI HAR Dataset/features.txt", stringsAsFactors = F)
names(xtrain)<-features$V2

subj_train<-read.table(path3, stringsAsFactors = F)  # subjects
names(subj_train)<-"subject"
act_labels<-read.table("C:/COURSERA/Getting and Cleaning Data/Project/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)
names(act_labels)<-c("class_label", "activity_name")
activ_train<-merge(ytrain, act_labels, by.x="activities", by.y="class_label")

#TRAINING dataset
comb_train<-cbind(subj_train,xtrain, activ_train)
comb_train$training_test<-"training"


## TEST
path1<-"C:/COURSERA/Getting and Cleaning Data/Project/UCI HAR Dataset/test/X_test.txt"
path2<-"C:/COURSERA/Getting and Cleaning Data/Project/UCI HAR Dataset/test/Y_test.txt"
path3<-"C:/COURSERA/Getting and Cleaning Data/Project/UCI HAR Dataset/test/subject_test.txt"
xtest<-read.table(path1, stringsAsFactors = F) 
ytest<-read.table(path2, stringsAsFactors = F)  # acctivities
names(ytest)<-"activities"
names(xtest)<-features$V2
subj_test<-read.table(path3, stringsAsFactors = F)  # subjects
names(subj_test)<-"subject"
activ_test<-merge(ytest, act_labels, by.x="activities", by.y="class_label")
#TEST dataset
comb_test<-cbind(subj_test,xtest, activ_test)
comb_test$training_test<-"test"
# Merge Training and test data sets
tt<-rbind(comb_train, comb_test)

# extract the mean and sd

sub1<-grepl(("mean\\(\\)|std\\(\\)"),names(tt)) 
tt2<-cbind(tt[sub1], activities=tt$activities, activity_name=tt$activity_name, training_test=tt$training_test, subject= tt$subject)

# Approptiately labeling 
names(tt2)<-gsub("^t", "time", names(tt2))
names(tt2)<-gsub("^f", "frequency", names(tt2))
names(tt2)<-gsub("Acc", "Accelerometer", names(tt2))
names(tt2)<-gsub("Gyro", "Gyroscope", names(tt2))
names(tt2)<-gsub("Mag", "Magnitude", names(tt2))
names(tt2)<-gsub("BodyBody", "Body", names(tt2))


# second data set

tt4<-aggregate(.~activities+subject, data = tt2, mean)
tt5<-tt4[order(tt4$subject,tt4$activity),]
write.table(tt5, file="df_final_c.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=TRUE)







