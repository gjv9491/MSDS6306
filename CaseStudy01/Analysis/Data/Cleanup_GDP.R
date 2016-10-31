# Author: gino
# Case study 01
# Download and cleanup GDP data


RAWgdp <- read.csv("GDPbyCountry.csv", header=FALSE,  stringsAsFactors = FALSE)

#Review the raw file, for issues
str(RAWgdp)
head(RAWgdp)
tail(RAWgdp)

# Replaced Rawgdp data set to a newer GDP data set were clean up work can be performed
GDP <- RAWgdp

#removing first 3 rows
for (i in 1:3){
GDP <- GDP[-1,]
cat('remove rows: ',i,'\n')
}

#replaced row 1 as columns
colnames(GDP) <- GDP[1,]
GDP <- GDP[-1,]
GDP <- GDP[-1,]

#column names to lower case
names(GDP) <- tolower(names(GDP))
names(GDP)[1] <- "countrycode"
names(GDP)[names(GDP)=="us dollars)"] <- "us.dollars"

str(GDP)

#creating a new iso3 country code
GDP$iso3.countrycode <- countrycode(GDP$economy ,"country.name","iso3c")

#include Kosovo, Channel islands and sodom and principe as they are not found in iso3.countrycode data set
GDP$iso3.countrycode[which(GDP$countrycode=="KSV")] <- "KSV"
GDP$iso3.countrycode[which(GDP$countrycode=="CHI")] <- "CHI"
GDP$iso3.countrycode[which(GDP$countrycode=="STP")] <- "STP"


#isolating countries that do not have iso3 code
GDPNoCountryCode <- GDP[is.na(GDP$iso3.countrycode)==TRUE,]

#delteing countries that do not match iso3 code
GDP <- GDP[is.na(GDP$iso3.countrycode)==FALSE,]

#remove unwanted coulmns
GDP <- GDP[,colSums(is.na(GDP))==0]

#rename blank column to Column
colnames(GDP)
names(GDP)[5] <- "Comments"



  #### The original *Comments* column consists of letter designators which point to a legend (found at the bottom of the raw data set) that contains comments for some observations. In order to make these details accessible for future use after tidying the data, the *Comments* column letter designators are replaced with the original data set's legend contents.

## Replace comment reference with comment from original data's legend
GDP[GDP$Comments != "",] # View valid comment column entries before edits
GDP$Comments[GDP$Comments == 'a'] <- "Includes Former Spanish Sahara"
GDP$Comments[GDP$Comments == 'b'] <- "Excludes South Sudan"
GDP$Comments[GDP$Comments == 'c'] <- "Covers mainland Tanzania only"
GDP$Comments[GDP$Comments == 'd'] <- "Data are for the area controlled by the government of the Republic of Cyprus"
GDP$Comments[GDP$Comments == 'e'] <- "Excludes Abkhazia and South Ossetia"
GDP$Comments[GDP$Comments == 'f'] <- "Excludes Transnistria"
GDP[GDP$Comments != "",] 


#convert to digits
GDP$us.dollars <- as.numeric(gsub("[^[:digit:]]","",GDP$us.dollars))
GDP$us.dollars[which(is.na(GDP$us.dollars)==TRUE)] <- 0

#Number of rows before tidying data
dim(RAWgdp)

#Number of rows ready for analysis
dim(GDP)

#Number of rows with NA
dim(GDPNoCountryCode)

#export final GDP for analysis
write.csv(GDP,"GDP_Final.csv")
write.csv(GDPNoCountryCode,"GDPNoCountryCode.csv")

