# Leo Aarnio, 13.11.2023, data wrangling for assignment 2

# read the data into memory
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Look at the dimensions of the data
dim(lrn14)

# The dimensions are 183 rows (observations) and 60 columns (variables)

# Look at the structure of the data
str(lrn14)

# The str function provides the names of the variables and a peak of their values
# The same can be achieved from clicking the down arrow of the dataframe in the
# global environment. All our variables are integer-valued, except the 
# character vector for gender, encoded "F" for female and "M" for male.

# Looking at the names of the variables, apparently there is a structure such that
# the first (few) letter(s) of the name denote a group to which the variable belongs.

# Create column 'attitude' by scaling the column "Attitude"
# The original Attitude is a composite that is a sum of ten integer variables, so this 
# effectively takes the mean  of these ten variables
lrn14$attitude <- lrn14$Attitude / 10

# Access the dplyr library
library(dplyr)

# Here I construct three composite variables, 'deep', 'surf' and 'stra' that are means 
# of variables measuring a deep, surface and strategic approach to learning, respectively. 

# Identify the names of the deep questions and store them in a character vector.
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")

# Identify the surface questions and store them in a character vector.
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")

# Identify the strategic questions and store them in a character vector.
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# Select all the columns related to deep learning and store them as a dataframe
deep_columns <- select(lrn14, one_of(deep_questions))

# Create column 'deep' in lrn14 dataframe by calculating the average over the deep variables.
lrn14$deep <- rowMeans(deep_columns)

# Select all the columns related to surface learning and store them as a dataframe
surface_columns <- select(lrn14, one_of(surface_questions))

# Create column 'surf' by calculating the average over the surface variables.
lrn14$surf <- rowMeans(surface_columns)

# Select all the columns related to strategic learning and store them as a dataframe 
strategic_columns <- select(lrn14, one_of(strategic_questions))

# Create column 'stra' by calculating the average over the strategic variables.
lrn14$stra <- rowMeans(strategic_columns)

# Store the names of the variables we want to keep in our analysis dataframe
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# Select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14,one_of(keep_columns))

# Change the name of "Age" to "age", since it is capitalized
colnames(learning2014)[which(names(learning2014) == "Age")] <- "age"

# Change the name of "Points" to "points", since it is capitalized
colnames(learning2014)[which(names(learning2014) == "Points")] <- "points"

# Select rows where points is greater than zero (which is the same as that it is not zero)
learning2014 <- filter(learning2014, points>0) 

# Look at the dimensions
dim(learning2014)

# Removed 17 rows where "points"-variable had a value of 0

# Set working directory to project directory (from Session->Set Working Directory)
# I have copied the command from the console below
setwd("~/Intro_to_ODS/IODS")
getwd()

# Save the dataset as a csv file to the data folder

# The suggested function write_csv is part of readr package
library(readr)

# Save as csv named 'learning2014'
write_csv(learning2014,"~/Intro_to_ODS/IODS/data/learning2014.csv")

# Test reading the file

# Remove the dataframe from workspace
rm(learning2014)

# Read the file into the workspace
learning2014<-read_csv("~/Intro_to_ODS/IODS/data/learning2014.csv")

# Check the head and structure of the data
head(learning2014)
str(learning2014)

# Everything looks correct