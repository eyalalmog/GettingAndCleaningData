

library(reshape2)

####### Course Project #######

#### written by E. Almog


### get the zip file 

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

####unzip########################################

unzip(zipfile="./data/Dataset.zip",exdir="./data")
path_zip <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_zip, recursive=TRUE)

##### load all relevant files ####################################

ActivityTestData  <- read.table(file.path(path_zip, "test" , "Y_test.txt" ),header = FALSE)
ActivitTrainDatay <- read.table(file.path(path_zip, "train", "Y_train.txt"),header = FALSE)

SubjectTrainData <- read.table(file.path(path_zip, "train", "subject_train.txt"),header = FALSE)
SubjectTestData  <- read.table(file.path(path_zip, "test" , "subject_test.txt"),header = FALSE)


FeaturesTestData  <- read.table(file.path(path_zip, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrainData <- read.table(file.path(path_zip, "train", "X_train.txt"),header = FALSE)


######## Part 1 Merge the test and training Data by rbind


Subject <- rbind(SubjectTrainData, SubjectTestData)
Activity<- rbind(ActivityTrainData, ActivityTestData)
Features<- rbind(FeaturesTrainData, FeaturesTestData)



#### Assigning labels for easy reading


names(Subject)<-c("Subject")   
names(Activity)<- c("Activity")  
FeaturesNames <- read.table(file.path(path_zip, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames[,2]  

#### running cind to combine the columns


fullDataSet <- cbind(Subject, Activity,Features)

############### end of part 1 - we ended up with 10299 observations and 563 named columns



###### part 2 - extracts only the measurements on the mean and standard deviation for each measurement
### we will be looking for labels that contain the strings std and mean
## instead of looking at the entire data set , we can look at the FeaturesNames to extract columns that contain these values

subsetFeaturesNames<-FeaturesNames[,2][grep("mean\\(\\)|std\\(\\)", FeaturesNames[,2])]

### and now we can populate a subset of the data set

subsetNames<-c( "Subject", "Activity" , as.character(subsetFeaturesNames) )
subSetData<-subset(fullDataSet,select=subsetNames)

#write.table(subSetData, file="./eyal.txt", sep="\t", row.names=FALSE )


################   End of Part 2 #####################################################

meanGrouping <- aggregate(. ~ Subject + Activity , data=subSetData, FUN = mean)


########### Load decription for Activities

activity_labels <- read.table(file.path(path_zip, "." ,"activity_labels.txt"), header= FALSE)
names(activity_labels) <- c("Activity" ,"Desc")

df1 <- merge(x = meanGrouping , y = activity_labels , by  = "Activity", all= TRUE)
df2 <- as.character(df1[,69])
df3 <- cbind(df1[,2],df2, df1[,3:68])


write.table(df3, file="./eyal1.txt", sep="\t", row.names=FALSE )
               


                   


                   


Enter file contents here
