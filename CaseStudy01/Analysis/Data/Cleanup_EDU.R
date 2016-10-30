# Author: gino
# Case study 01
# Download and cleanup Education data

#load the initial csv file into RAWedu
RAWedu <- read.csv("EDUbyCountry.csv", header=FALSE,  stringsAsFactors = FALSE)

#Review the raw file, for issues
str(RAWedu)
head(RAWedu)
tail(RAWedu)

# Replaced Rawedu data set to a newer EDU data set were clean up work can be performed
EDU <- RAWedu

#replaced row 1 as columns
colnames(EDU) <- EDU[1,]
EDU <- EDU[-1,]

#column names to lower case
names(EDU) <- tolower(names(EDU))

#verify row 1 are columns
names(EDU)
str(EDU)

#creating a new iso3 country code
EDU$iso3.countrycode <- countrycode(EDU$`short name` ,"country.name","iso3c")

#include Kosovo, Channel islands and sodom and principe as they are not found in iso3.countrycode data set
EDU$iso3.countrycode[which(EDU$countrycode=="KSV")] <- "KSV"
EDU$iso3.countrycode[which(EDU$countrycode=="CHI")] <- "CHI"
EDU$iso3.countrycode[which(EDU$countrycode=="STP")] <- "STP"

#isolating countries that do not have iso3 code
EduNoCountryCode <- EDU[is.na(EDU$iso3.countrycode)==TRUE,]

#delteing countries that do not match iso3 code
EDU <- EDU[is.na(EDU$iso3.countrycode)==FALSE,]

#Number of rows before tidying data
dim(RAWedu)

#Number of rows ready for analysis
dim(EDU)

#Number of rows with NA
dim(EduNoCountryCode)

#export final EDU for analysis
write.csv(EDU,"EDU_Final.csv")
write.csv(EduNoCountryCode,"EDUNoCountryCode.csv")




