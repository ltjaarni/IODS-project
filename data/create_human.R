# Leo Aarnio, 2023/11/23, data wrangling in assignment 4

# ASSIGNMENT 4 CODE CHUNK, GO DOWN TO FIND ASSIGNMENT 5
# Read in the two dataset: ''human development'' and ''gender inequality''

# We require readr library for read_csv function
library(readr)

hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Explore dataset by dimensions and structure. First hd.
dim(hd)
# We have dimensions 195 (rows) by 8 (columns)

str(hd)
# We have 7 numeric variables measuring, roughly, the development level of the country on different
# features of development. We also have a rank variable for the HDI and a character string for the name of the country

# Look at the summary of the variables in the ''human development'' dataset
summary(hd)
# The world is a mysterious place, with whopping differences on the country-level. For instance,
# the expected year of education ranges from a little over 4 to a little over 20; life expectancy from
# 49 to 84.

# Then gii
dim(gii)
# We have dimensions 195 (rows) by 10 (columns)

str(gii)
# We have a similar dataset to the one on development, but this time with 8 numeric variables measuring different aspects of gender
# (in)equality, and one numeric rank-variable on GII as well as a character string for the country name.

# Look at the summary of the variables in the ''gender inequality'' dataset
summary(gii)
# There are large differences across the countries. There is a country with 100% of the women having secondary
# education (this must be some tiny country), and another with only 0.9 percent.

# Rename the variables, looking at the example provided
# We require dplyr for rename
library(dplyr)

# First for hd
hd<-rename(hd, "HDI"="Human Development Index (HDI)", 
           "Life.Exp"="Life Expectancy at Birth",
           "Edu.Exp"="Expected Years of Education",
           "Edu.Mean"="Mean Years of Education",
           "GNI"="Gross National Income (GNI) per Capita")

# Then for gii
gii<-rename(gii, "GII"="Gender Inequality Index (GII)", 
           "Mat.Mor"="Maternal Mortality Ratio",
           "Ado.Birth"="Adolescent Birth Rate",
           "Parli.F"="Percent Representation in Parliament",
           "Edu2.F"="Population with Secondary Education (Female)",
           "Edu2.M"="Population with Secondary Education (Male)",
           "Labo.F"="Labour Force Participation Rate (Female)",
           "Labo.M"="Labour Force Participation Rate (Male)")

# Create the new variables that are ratios of the proportions of female vs. male population with
# secondary education and that participate in the labor market, respectively
gii<-mutate(gii,Edu2.FM = Edu2.F / Edu2.M, Labo.FM = Labo.F / Labo.M)

# Use inner join to merge the two datasets by column ''Country''
human<-inner_join(hd, gii, by="Country")

# The new table has 195 observations with 19 variables, as should de

# Save the dataframe into csv in the data folder
write_csv(human,"~/Intro_to_ODS/IODS/data/human.csv")

# ----------------------------------------------------------------

# ASSIGNMENT 5 CODE CHUNK

# Leo Aarnio, 2023/12/1, 
# Link to data: https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.csv"

# Read in the dataset created last week
# we require readr for this
library(readr)
human<-read_csv("~/Intro_to_ODS/IODS/data/human.csv")

# Look at the dimensions
dim(human)
# 195 rows of observations of 19 variables

# Look at the structure
str(human)
# numeric measurements that concern the level of development of countries.
# HDI is a componsite index of human development,
# HDI rank is the rank of the country on the HDI
# Life.exp measures life-expectance at birth
# Edu. exc measures expected years of education
# Edu. mean measures mean of education
# GNI measures gross national income per capita
# GII is a composite gender inequality index
# GII rank is the rank of the country on the GII
# Mat.mor measures maternal mortality
# Ado.Birth measures adolescent birth rate
# Parli.F female representation in parliament
# Edu2.F measures the proportion of women with a secondary education
# Edu2.M measures the proportion of men with a secondary education
# Edu2.FM is the ratio of the above two (with F. the numerator)
# Labo.F measures proportion of women that are part of the labour force
# Labo.FM is the ratio of the above two (with F. the numerator)
# Labo.M measures the proportion of men that are part of the labour force

# Require dplyr for preprocessing
library(dplyr)

# Name the variables to keep and store in a character vector
keep<-c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# Keep the variables named in the human datase (drop all others)
human<-dplyr::select(human, one_of(keep))

# Count of missing values
sum(is.na(human))
# 55 missing values - not much

# Identify rows that have at least one missing value
complete.cases(human)

# Keep rows that do not have missing values (with value TRUE for complete.case)
human <- filter(human, complete.cases(human))

# Count of missing values
sum(is.na(human))
# 0 missing values, so everything in order

# The regions that are not countries are in the tail of the dataset
tail(human, n=10)

# These are the regions from Arab States to World: 7 last rows in the dataset
# Since we do not know what 162-7 amounts to we let R calculate it for us
n_countryrows<-nrow(human)-7

# Keep the rows prior to that
human<-human[1:n_countryrows,]

# check that everything is in order
tail(human,n=10)
# Looks good: the last row is that of Niger

# Save the dataset to data folder
write_csv(human,"~/Intro_to_ODS/IODS/data/human.csv")

#check the dataset is stored as should be
rm(human)
human<-read_csv("~/Intro_to_ODS/IODS/data/human.csv")
