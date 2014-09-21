### Course Project
# merging test and train data sets

#reading test 
xtest<-read.table("D:/COURSEERA/Getting and cleaning data/week3/Project/UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("D:/COURSEERA/Getting and cleaning data/week3/Project/UCI HAR Dataset/test/y_test.txt")
stest<-read.table("D:/COURSEERA/Getting and cleaning data/week3/Project/UCI HAR Dataset/test/subject_test.txt")

#reading training
xtrain<-read.table("D:/COURSEERA/Getting and cleaning data/week3/Project/UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("D:/COURSEERA/Getting and cleaning data/week3/Project/UCI HAR Dataset/train/y_train.txt")
strain<-read.table("D:/COURSEERA/Getting and cleaning data/week3/Project/UCI HAR Dataset/train/subject_train.txt")

#Merging
X_<-rbind(xtest, xtrain)
Y_<-rbind(ytest, ytrain)
S<-rbind(stest, strain)

#Naming
FEAT<-read.table("D:/COURSEERA/Getting and cleaning data/week3/Project/UCI HAR Dataset/features.txt")
colnames(X_)<-FEAT[,2]

# measurements : mean and sd
g<-grepl("mean()",colnames(X_)) | grepl("std()",colnames(X_))
XMSD <- X_[,g]

#activity names to name the activities in the data set
library(plyr)
AL<-read.table("D:/COURSEERA/Getting and cleaning data/week3/Project/UCI HAR Dataset/activity_labels.txt")
yfac<-as.factor(Y_[,1])
Y_factor <- mapvalues(Y_factor,from = as.character(AL[,1]), to = as.character(AL[,2]))
XMSD<-cbind(yfac,XMSD)
colnames(XMSD)[1] <- "activity"
XMSD <- cbind(S, XMSD)
colnames(XMSD)[1] <- "subject"

#independent tidy data
library(reshape2)
X_indep<- melt(XMSD,id.vars=c("subject","activity"))
X <- dcast(X_indep, subject + activity ~ ..., mean)
write.table(X, "tidy Data set.txt")
