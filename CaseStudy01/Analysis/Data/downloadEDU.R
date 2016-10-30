# Author: gino
# Case study 01
# Download and cleanup Education data

#setup and download gdp file
eduurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

download.file(eduurl, destfile="EDUbyCountry.csv",quiet = TRUE)
