# Author: gino
# Case study 01
# Download and cleanup GDP data

#setup and download gdp file
gdpurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"

download.file(gdpurl, destfile="GDPbyCountry.csv",quiet = TRUE)

