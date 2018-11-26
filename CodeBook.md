# Code book of "run_analysis.R"

This codebook explains step by step the analysis performed on the UCI HAR Dataset in order to obtain
a tidy summary of the mean values of some measurement of interest calculated for each subject 
of the experiment and for each activity he/she performed.

## UCI HAR Dataset
The original database, called "Human Activity Recognition Using Smartphones Dataset Version 1.0", 
consists in recordings of 30 subjects performing programmed activities of daily living which were 
monitored by a waist-mounted smartphone with embedded inertial sensors. 
Subjects were randomly selected to participate in a "test" or a "train" session, 
generating two separate data sets. 

Each observation of each dataset is characterized by:
* the identifier of the subject, i.e. an integer between 1 and 30
* the identifier of the activity, i.e. an integer between 1 and 6, which represents: walking, walking_upstairs, 
walking_downstairs, sitting, standing, or laying, respectively.
* a 561 vector of "features", i.e. quantities derived from the raw signals recorded by the accelerometer and gyroscope of the smartphone.

The features, which were normalized and bounded within [-1,1], are:
* tAcc-XYZ, tGyro-XYZ: accelerometer and gyroscope 3-axial signals (the prefix "t" indicates the time domain)
* tBodyAccJerk-XYZ, tBodyGyroJerk-XYZ: body linear acceleration and angular velocity, derived in time to obtain Jerk signals 
* tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag: magnitude of the previous three-dimensional signals calculated with the Euclidean norm
* fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag: Fast Fourier Transform (the prefix "f" indicate the frequency domain signals)
* The above quantities were further processed by calculating the mean, the standard deviation, the maximum, 
the minimum, etc.

## Script
### Pre-requirements
* package "dplyr"
* the complete UCI HAR Dataset 
* two data frames stored in memory and denoted as "dataTest" and "dataTrain". 
The column names of data set are 561 features, with the same labels of the original data set, 
a column with the subject identifyer, a column with the activity identifyer.

Note that these data frames can be constructed by the readUciHarData() function. 

### Analysis

Data are processed as follow:

1. A column "session" is added to dataTest and dataTrain with the value "test" and "train", respectively.
Then, dataTest and dataTrain are combined together forming one data frame, called dataComb, 
which has the same number of columns and the number of rows equal to the sum of the two input data frames, 
i.e. 10299 observation and 564 variables

2. From dataComb are selected the variables of interest, i.e. the mean and the standard deviation of the 
features described above, the subject identifier, the activity identifier, and the session, creating a new 
data frame called dataSub

3. In dataSub the labels of the activity identifiers are changed from integers into descriptive variables, accordingly to the codification described by the original data set

4. In dataSub the variable names are modified to be more readable by eliminating special characters

5. From dataSub is created a summary with the average of each measurement calculated for each activity 
and for each subject. The variable names are modified to be more readable and descriptive.
