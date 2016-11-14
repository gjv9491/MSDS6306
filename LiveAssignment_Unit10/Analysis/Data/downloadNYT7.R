# Author: gino
# Case study 01
# Download data

#setup and download gdp file
nyt7url <- "http://stat.columbia.edu/~rachel/datasets/nyt7.csv"

download.file(nyt7url, destfile="nyt7.csv",quiet = TRUE)