# A understanding of countries GDP in respect to its educational data
Gino Varghese  
October 25, 2016  

## Introdution
<br>     

#### For this analysis we will look at two different data sets      

* First set of data contains Gross Domestic Product which is comprised of 2012 GDP values for 190 countries throughout the world. More recent data is hosted on Worldbank.org.     
    + http://data.worldbank.org/data-catalog/GDP-ranking-table
* Second contains educational data of these countries more.       
    + http://data.worldbank.org/data-catalog/ed-stats
<br>

Our goal is to make some educated assumptions by combining both the data sets, to see if there is any relationship between the access to education, progression, completion, literacy, teachers, population, and expenditures to a givens countries economic growth.

The indicators cover the education cycle from pre-primary to vocational and tertiary education.
together after tidying the raw files      

<br>
<br>

#### Before we start our analysis, we set the following:                

* set working directory          
* install necessary packages       
* R version     


```r
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_knit$set(root.dir = "~/git/MSDS6306/CaseStudy01/Analysis/Data")
require(knitr)
require(dplyr)
require(plyr)
require(ggplot2)
require(downloader)
require(countrycode)
sessionInfo()
```

```
## R version 3.2.3 (2015-12-10)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 16.04.1 LTS
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] countrycode_0.18 downloader_0.4   ggplot2_2.1.0    plyr_1.8.4      
## [5] dplyr_0.5.0      knitr_1.14      
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.7      digest_0.6.10    assertthat_0.1   grid_3.2.3      
##  [5] R6_2.2.0         gtable_0.2.0     DBI_0.5-1        formatR_1.4     
##  [9] magrittr_1.5     scales_0.4.0     evaluate_0.10    stringi_1.1.2   
## [13] rmarkdown_1.1    tools_3.2.3      stringr_1.1.0    munsell_0.4.3   
## [17] yaml_2.1.13      colorspace_1.2-7 htmltools_0.3.5  tibble_1.2
```

<br>
<br>

##### Now to start our analysis we need to first download the data sets        

* **Gross Domestic Product download**         
    + This process downloads Gross Domestic Product data sets and renames it as "GDPbyCountry.csv"     
    + Downloaded file are listed below in Data directory        

```r
source("downloadGDP.R", echo = TRUE)
```

```
## 
## > gdpurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
## 
## > download.file(gdpurl, destfile = "GDPbyCountry.csv", 
## +     quiet = TRUE)
```

```r
list.files()
```

```
## [1] "Cleanup_EDU.R"    "Cleanup_GDP.R"    "downloadEDU.R"   
## [4] "downloadGDP.R"    "GDPbyCountry.csv" "removeObjects.R"
```

<br>        

* **Education data download**      
    + This process downloads Education data set and renames it as "EDUbyCountry.csv"          
    + Downloaded file are listed below  in Data directory         

```r
source("downloadEDU.R", echo = TRUE)
```

```
## 
## > eduurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
## 
## > download.file(eduurl, destfile = "EDUbyCountry.csv", 
## +     quiet = TRUE)
```

```r
list.files()
```

```
## [1] "Cleanup_EDU.R"    "Cleanup_GDP.R"    "downloadEDU.R"   
## [4] "downloadGDP.R"    "EDUbyCountry.csv" "GDPbyCountry.csv"
## [7] "removeObjects.R"
```

<br>
<br>         

##### Once the data is dowloaded to the projects "Data"  directory, it is ready to be imported into the R as a data frame. Once importation, the data frame is observed for internal structure details and beginning and ending rows, to determine what actions should be taken when tidying the data.        
<br>          

* **Gross Domestic Product is loaded into R**        
    + The csv file is loaded into **Rawgdp** data frame          
        + the data frame is reviewed by using R commands such as: head, tail and str        
    + The **Rawgdp** is then loaded into **GDP** data frame to begin the tidying process          
    + *_Tidying process_*            
        + We modified the **GDP** data frame as follows:
            + V[n] column headers are removed        
            + Unwanted space between column header and data is removed        
            + column names are renamed to lower case
            + "us dollars)" column name is renamed to us.dollars
            + ISO3.CountryCode are generated for each row and stored in iso3.countrycode
                + using countrycode package     
            + "Kosovo", "Channel Islands" and "Sodom and Principe" iso3 country codes are added to the data set
            + The us.dollars column is converted into numeric, removing "," from the dollars and "NA" rows are converted to "0"
            + Rows that are not related to any countries are moved to another data frame **GDPNoCountryCode**      
                + these data sets are also removed from **GDP** data frame     
            + The final rows for each data frame are as follows:
                + Raw GDP file : 331 rows      
                + GDP data with NA : 112 rows      
                + Tidy GDP data : 214 rows  
    + Tidy data is then written to **"GDP_Final.csv"** file, to facilitate analysis.
                
                
            
    


```r
source("Cleanup_GDP.R", echo = TRUE)
```

```
## 
## > RAWgdp <- read.csv("GDPbyCountry.csv", header = FALSE, 
## +     stringsAsFactors = FALSE)
## 
## > str(RAWgdp)
## 'data.frame':	331 obs. of  10 variables:
##  $ V1 : chr  "" "" "" "" ...
##  $ V2 : chr  "Gross domestic product 2012" "" "" "Ranking" ...
##  $ V3 : logi  NA NA NA NA NA NA ...
##  $ V4 : chr  "" "" "" "Economy" ...
##  $ V5 : chr  "" "" "(millions of" "US dollars)" ...
##  $ V6 : chr  "" "" "" "" ...
##  $ V7 : logi  NA NA NA NA NA NA ...
##  $ V8 : logi  NA NA NA NA NA NA ...
##  $ V9 : logi  NA NA NA NA NA NA ...
##  $ V10: logi  NA NA NA NA NA NA ...
## 
## > head(RAWgdp)
##    V1                          V2 V3            V4           V5 V6 V7 V8
## 1     Gross domestic product 2012 NA                               NA NA
## 2                                 NA                               NA NA
## 3                                 NA               (millions of    NA NA
## 4                         Ranking NA       Economy  US dollars)    NA NA
## 5                                 NA                               NA NA
## 6 USA                           1 NA United States  16,244,600     NA NA
##   V9 V10
## 1 NA  NA
## 2 NA  NA
## 3 NA  NA
## 4 NA  NA
## 5 NA  NA
## 6 NA  NA
## 
## > tail(RAWgdp)
##     V1 V2 V3 V4 V5 V6 V7 V8 V9 V10
## 326       NA          NA NA NA  NA
## 327       NA          NA NA NA  NA
## 328       NA          NA NA NA  NA
## 329       NA          NA NA NA  NA
## 330       NA          NA NA NA  NA
## 331       NA          NA NA NA  NA
## 
## > GDP <- RAWgdp
## 
## > for (i in 1:3) {
## +     GDP <- GDP[-1, ]
## +     cat("remove rows: ", i, "\n")
## + }
## remove rows:  1 
## remove rows:  2 
## remove rows:  3 
## 
## > colnames(GDP) <- GDP[1, ]
## 
## > GDP <- GDP[-1, ]
## 
## > GDP <- GDP[-1, ]
## 
## > names(GDP) <- tolower(names(GDP))
## 
## > names(GDP)[1] <- "countrycode"
## 
## > names(GDP)[names(GDP) == "us dollars)"] <- "us.dollars"
## 
## > str(GDP)
## 'data.frame':	326 obs. of  10 variables:
##  $ countrycode: chr  "USA" "CHN" "JPN" "DEU" ...
##  $ ranking    : chr  "1" "2" "3" "4" ...
##  $ na         : logi  NA NA NA NA NA NA ...
##  $ economy    : chr  "United States" "China" "Japan" "Germany" ...
##  $ us.dollars : chr  " 16,244,600 " " 8,227,103 " " 5,959,718 " " 3,428,131 " ...
##  $            : chr  "" "" "" "" ...
##  $ na         : logi  NA NA NA NA NA NA ...
##  $ na         : logi  NA NA NA NA NA NA ...
##  $ na         : logi  NA NA NA NA NA NA ...
##  $ na         : logi  NA NA NA NA NA NA ...
## 
## > GDP$iso3.countrycode <- countrycode(GDP$economy, "country.name", 
## +     "iso3c")
## 
## > GDP$iso3.countrycode[which(GDP$countrycode == "KSV")] <- "KSV"
## 
## > GDP$iso3.countrycode[which(GDP$countrycode == "CHI")] <- "CHI"
## 
## > GDP$iso3.countrycode[which(GDP$countrycode == "STP")] <- "STP"
## 
## > GDPNoCountryCode <- GDP[is.na(GDP$iso3.countrycode) == 
## +     TRUE, ]
## 
## > GDP <- GDP[is.na(GDP$iso3.countrycode) == FALSE, ]
## 
## > GDP <- GDP[, colSums(is.na(GDP)) == 0]
## 
## > GDP$us.dollars <- as.numeric(gsub("[^[:digit:]]", 
## +     "", GDP$us.dollars))
## 
## > GDP$us.dollars[which(is.na(GDP$us.dollars) == TRUE)] <- 0
## 
## > dim(GDP)
## [1] 214   6
## 
## > dim(GDPNoCountryCode)
## [1] 112  11
## 
## > write.csv(GDP, "GDP_Final.csv")
## 
## > write.csv(GDPNoCountryCode, "GDPNoCountryCode.csv")
```



## Including Plots

You can also embed plots, for example:

![](CaseStudy01_files/figure-html/pressure-1.png)<!-- -->

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
