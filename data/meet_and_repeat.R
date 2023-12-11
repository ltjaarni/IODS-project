# Leo Aarnio, 2023/12/7, data wrangling for meet and repeat

# Read the BPRS data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)

# Look at the (column) names of BPRS
names(BPRS)
# (More on this below)

# Look at the structure of BPRS
str(BPRS)

# Dimensions are 40*11

# The structure of the dataset is wide and such that for each row, we have an indidividual* treatment pair, 
# and then on the consecutive columns a value for that pair on the weekly BPRS, with BPRS measurement 
# values ordered by week number in an ascending order. There are two treatments and the individuals
# with the same subject number are not the same individual (since only one of the two treatments is delivered to each patient).
# The key that indexes a vector of observations is thus the Cartesian product of treatment*index.

# All of our variables are encoded as integers 
# (but the first two ought be statistically treated as categorical, so we turn them into factors)

# Print out summaries of the variables
summary(BPRS)

# We already observe that the means of BPRS decline by week, so when considered as one, 
# the treatments show promise (assuming the reduction not to be entirely natural course of the disease)

# Read the RATS data

# read in the RATS data
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# Look at the (column) names of RATS
names(RATS)
# (More on this below)

# Look at the structure of RATS
str(RATS)

# We have the same wide format as with BPRS, where each repeated measurement is on its own distinct column.
# Unlike for BPRS, We have ID that serves as the key uniquely identifying the vector of observations,
# and linking them to the identifier for the rat on which the measurement is made. We have three
# ''treatment'' groups and 12 measurements that are, unlike for BPRS, ordered and denoted by days, instead
# weeks, and the time intervals between the measurements are not constant

# We then turn the integer variables concerning the IDs and the treatment groups into factors for both datasets.

# Require dplyr (as always)
library(dplyr)

# Glimpse the data
glimpse(BPRS)
glimpse(RATS)

# Factor variables ID and Group
BPRS$subject <- as.factor(BPRS$subject)
BPRS$treatment <- as.factor(BPRS$treatment)

RATS$ID <- as.factor(RATS$ID)
RATS$Group <- as.factor(RATS$Group)

# We next turn the datasets into the long format, which simply means that we have the repeated measurements
# on (consecutive) rows within the same column that identifies the measurement type (such as the BPRS
# for the BPRS dataset or the weights for the RATS dataset)

# We require tidyr for its function pivot_longer to turn the wide into the long
library(tidyr)

# Convert the BPRS data to the long format
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>% arrange(weeks) #order by weeks variable

# Extract the week number for bprs
BPRSL <-  BPRSL %>% 
  mutate(week = as.integer(substr(weeks,5,5)))


# Convert the RATS data into the long format
RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD,3,4))) %>%
  arrange(Time)

# Glimpse the datasets
glimpse(BPRSL)
glimpse(RATSL)

# We have the BPRS dataset ordered by row so that we first have the observations for each individual in treatment 1 for the baseline week (0)
# then for each individual for the same week on treatment group 2; then the same for the consecutive week; etc.
# The long format makes the structure of the dataset clear: all repeated measurements are within the same column,
# so that we would not be tempted to treat them simply as utterly distinct variables. Each measurement could be interpreted
# as being sampled from a distribution indexed by the ID/subject and or the treatment/group and or the week.

# Let us check that things are in order. The means should be the same, since what we have in effect done is
# taken all the repeated measurement values on distinct columns of the wide format, appended them underneath each 
# other within the same column, and indexed them on separate rows by the week number, the IDs and the treatments.

mean(as.matrix(BPRS[,3:11]))
mean(BPRSL$bprs)

mean(as.matrix(RATS[,3:13]))
mean(RATSL$Weight)

# Since we have sorted our dataset for both the original and the long format in the same way,
# so that we have observations ordered by subject and then by treatment and then by week in both datasets,
# we should have identity of the following vectors. This is because in effect we have lumped consecutive
# column vectors into one long column vector grouped together by its name.

# So we have the forty observations appended for each measurement, so 9 times for the case of BPRS, which then
# makes the counts of rows 40*9=360 for BPRS and 16*11=176 for RATSL.

test<-as.vector(as.matrix(BPRS[,3:11]))
test2<-as.vector(BPRSL$bprs)

test
test2

test_dif<-test-test2
sum(test_dif)
# and we indeed get a vector of but zeros, which means the two sequences are identical.

# We can repeat for the rats dataset
test<-as.vector(as.matrix(RATS[,3:13]))
test2<-as.vector(RATSL$Weight)

test_dif<-test-test2
sum(test_dif)
# and we indeed get a vector of but zeros, which means the two sequences are identical.

# We can look at some of the summaries, but we have already checked that structure-wise everything is ok.
summary(BPRS)
summary(BPRSL)

summary(RATS)
summary(RATSL)

# Let us save the long format of both datasets to file
write_csv(BPRSL,"~/Intro_to_ODS/IODS/data/BPRSL.csv")
write_csv(RATSL,"~/Intro_to_ODS/IODS/data/RATSL.csv")
