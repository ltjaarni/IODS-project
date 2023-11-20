# Leo Aarnio, 20.11.2023
# Data preprocessing for student alcoholol consumption dataset

# Read the two files into the workspace

# The function read_delim is part of readr package
# Read_csv and read_tsv are special cases with delimitors comma and tab, respectively.
# Here we seem to have a semicolon, so we specify that with delim command

library(readr)

student_mat<-read_delim("~/Intro_to_ODS/IODS/data/student-mat.csv", delim=";")
student_por<-read_delim("~/Intro_to_ODS/IODS/data/student-por.csv",delim=";")

# Dimensions by command, also visible in global environment
dim(student_mat)
dim(student_por)

# The dimensions are: 395 observations of 33 variables and 649 rows of 33 variables, respectively

# Structure of the dataset by command, also available through global environment
str(student_mat)
str(student_por)

# The datasets seem quite rich in terms of their contents, including data
# on the pupil, his school, and parents; background variables such as socioeconomic status and demography
# Apparently the dataset concerns variables that are potentially explanatory or predictive of
# school performance. There are two similar datasets: apparently one is based on a questionnaire in a math
# class and another in a portuguese class. From a quick glance it would appear that the datasets
# have the same columns, and even in the same order. We do not have an identification variable so there
# might be same pupils in the two datasets.

# access the dplyr package
library(dplyr)

# Our task in the following is to append the two datasets so that we use those variables
# that have the same values across the two datasets to identify each pupil

# There are six columns for which one has varying values across the two datasets
# We will not use these for identification, and we need to decide how to summarize them
# after joining the two datasets, since we have conflicting values for the two datasets.

# We provide the names for these columns
free_cols<-c("failures", "paid", "absences", "G1", "G2", "G3")

# The rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(student_por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(student_mat, student_por, by = join_cols, suffix = c(".math", ".por"))

# Look at the dimensions of the joint dataset (also available from global environment)
dim(math_por)

# We have 370 observations that have the same values for the join cols in the two data sets
# There are 39 variables in the novel dataset, since the six variables in free cols have been doubled

# Explore the structure of the joint dataset (also available from global environment)
str(math_por)

# We see that we have duplicates for the six variables the origin dataset of which we may
# identify by the suffix. 

# These variables will have to be combined in some way

# We start by creating a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

# The following function will calculate the mean for the two values from the distinct 
# datasets and use that as the variable for each of the varying columns that are numeric.
# For the non-numeric one ("paid"), we will just take the value from the first dataset having
# been merged

# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

# We add a new variable that is the average of workday and weekend consumption
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# We then define a new logical column 'high_use', which is determined by a value above 2
# for the average of alcohol use (the scale is from 1="very low" to 5="very high" consumption)
alc <- mutate(alc, high_use = alc_use > 2)

# We'll take a glimpse of the dataset
glimpse(alc)

# Everything seems in order. We have 370 observation of 35 variables

# We end preprocessing by saving the joint dataset to file
write_csv(alc,"~/Intro_to_ODS/IODS/data/alc.csv")
