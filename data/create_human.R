# Leo Aarnio, 2023/11/23, data wrangling in assignment 4


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
# The world is a mysterious place, with whopping difference on the country-level. For instance,
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
           "Edo.Birth"="Adolescent Birth Rate",
           "Parli.F"="Percent Representation in Parliament",
           "Edu2.F"="Population with Secondary Education (Female)",
           "Edu2.M"="Population with Secondary Education (Male)",
           "Labo.F"="Labour Force Participation Rate (Female)",
           "Labo.M"="Labour Force Participation Rate (Male)")

# Create the new variables that are ratios of the proportions of female vs. male population with
# ceondary education and that participate in the labor market, respectively
gii<-mutate(gii,Edu2.FM = Edu2.F / Edu2.M, Labo.FM = Labo.F / Labo.M)

# Use inner join to merge the two datasets by country
human<-inner_join(hd, gii, by="Country")

# The new table has 195 observations with 19 variables, as should de

# Save the dataframe into csv in the data folder
write_csv(human,"~/Intro_to_ODS/IODS/data/human.csv")
