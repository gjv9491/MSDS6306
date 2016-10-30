#author: gino
# analysis of GDP data with Education

#Load cleaned up csv file for GDP

setwd("~/git/MSDS6306/CaseStudy01/Analysis")
gdppath <- paste(getwd(),"/Data/GDP_Final.csv",sep = "")
edupath <- paste(getwd(),"/Data/EDU_Final.csv",sep = "")

#load and 
GDP <- read.csv(gdppath,header=TRUE)
names(GDP)[names(GDP)=="X"] <- "ID"
names(GDP)[names(GDP)=="X.1"] <- "Val"

EDU <- read.csv(edupath,header=TRUE)
names(EDU)[names(EDU)=="X"] <- "ID"