#  Understanding the relationship between Income group and GDP.
Gino Varghese  
October 25, 2016  

## Introdution
<br>     

#### For this analysis we will look at two different data sets      

* First set of data contains Gross Domestic Product which is comprised of 2012 GDP values for 190 countries throughout the world. More recent data is hosted on Worldbank.org.     
    + http://data.worldbank.org/data-catalog/GDP-ranking-table
* Second contains World Bank Education Stats data.       
    + http://data.worldbank.org/data-catalog/ed-stats
<br>

Our goal is to make some educated assumptions by combining both the data sets, to see if there is any relationship between the access to education, progression, completion, literacy, teachers, population, and expenditures boost's the countries income growth which will then lead to countries economic growth.

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

#### Now to start our analysis we need to first download the data sets        

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
    + **Tidying process**            
        + We modified the **GDP** data frame as follows:
            + V[n] column headers are removed        
            + Unwanted space between column header and data is removed    
            + Empty columns with no data are removed
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
## > dim(RAWgdp)
## [1] 331  10
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

<br>          

* **World Bank EdStats is loaded into R**        
    + The csv file is loaded into **Rawedu** data frame          
        + the data frame is reviewed by using R commands such as: head, tail and str        
    + The **Rawedu** is then loaded into **EDU** data frame to begin the tidying process          
    + **Tidying process**           
        + We modified the **EDU** data frame as follows:
            + V[n] column headers are removed        
            + Unwanted space between column header and data is removed    
            + Empty columns with no data are removed
            + column names are renamed to lower case
            + ISO3.CountryCode are generated for each row and stored in iso3.countrycode
                + using countrycode package     
            + "Kosovo", "Channel Islands" and "Sodom and Principe" iso3 country codes are added to the data set
            + Rows that are not related to any countries are moved to another data frame **EDUNoCountryCode**      
                + these data sets are also removed from **EDU** data frame     
            + The final rows for each data frame are as follows:
                + Raw EDU file : 331 rows      
                + EDU data with NA : 23 rows      
                + Tidy EDU data : 211 rows  
    + Tidy data is then written to **"EDU_Final.csv"** file, to facilitate analysis.
                


```r
source("Cleanup_EDU.R", echo = TRUE)
```

```
## 
## > RAWedu <- read.csv("EDUbyCountry.csv", header = FALSE, 
## +     stringsAsFactors = FALSE)
## 
## > str(RAWedu)
## 'data.frame':	235 obs. of  31 variables:
##  $ V1 : chr  "CountryCode" "ABW" "ADO" "AFG" ...
##  $ V2 : chr  "Long Name" "Aruba" "Principality of Andorra" "Islamic State of Afghanistan" ...
##  $ V3 : chr  "Income Group" "High income: nonOECD" "High income: nonOECD" "Low income" ...
##  $ V4 : chr  "Region" "Latin America & Caribbean" "Europe & Central Asia" "South Asia" ...
##  $ V5 : chr  "Lending category" "" "" "IDA" ...
##  $ V6 : chr  "Other groups" "" "" "HIPC" ...
##  $ V7 : chr  "Currency Unit" "Aruban florin" "Euro" "Afghan afghani" ...
##  $ V8 : chr  "Latest population census" "2000" "Register based" "1979" ...
##  $ V9 : chr  "Latest household survey" "" "" "MICS, 2003" ...
##  $ V10: chr  "Special Notes" "" "" "Fiscal year end: March 20; reporting period for national accounts data: FY." ...
##  $ V11: chr  "National accounts base year" "1995" "" "2002/2003" ...
##  $ V12: chr  "National accounts reference year" "" "" "" ...
##  $ V13: chr  "System of National Accounts" "" "" "" ...
##  $ V14: chr  "SNA price valuation" "" "" "VAB" ...
##  $ V15: chr  "Alternative conversion factor" "" "" "" ...
##  $ V16: chr  "PPP survey year" "" "" "" ...
##  $ V17: chr  "Balance of Payments Manual in use" "" "" "" ...
##  $ V18: chr  "External debt Reporting status" "" "" "Actual" ...
##  $ V19: chr  "System of trade" "Special" "General" "General" ...
##  $ V20: chr  "Government Accounting concept" "" "" "Consolidated" ...
##  $ V21: chr  "IMF data dissemination standard" "" "" "GDDS" ...
##  $ V22: chr  "Source of most recent Income and expenditure data" "" "" "" ...
##  $ V23: chr  "Vital registration complete" "" "Yes" "" ...
##  $ V24: chr  "Latest agricultural census" "" "" "" ...
##  $ V25: chr  "Latest industrial data" "" "" "" ...
##  $ V26: chr  "Latest trade data" "2008" "2006" "2008" ...
##  $ V27: chr  "Latest water withdrawal data" "" "" "2000" ...
##  $ V28: chr  "2-alpha code" "AW" "AD" "AF" ...
##  $ V29: chr  "WB-2 code" "AW" "AD" "AF" ...
##  $ V30: chr  "Table Name" "Aruba" "Andorra" "Afghanistan" ...
##  $ V31: chr  "Short Name" "Aruba" "Andorra" "Afghanistan" ...
## 
## > head(RAWedu)
##            V1                           V2                   V3
## 1 CountryCode                    Long Name         Income Group
## 2         ABW                        Aruba High income: nonOECD
## 3         ADO      Principality of Andorra High income: nonOECD
## 4         AFG Islamic State of Afghanistan           Low income
## 5         AGO  People's Republic of Angola  Lower middle income
## 6         ALB          Republic of Albania  Upper middle income
##                          V4               V5           V6             V7
## 1                    Region Lending category Other groups  Currency Unit
## 2 Latin America & Caribbean                                Aruban florin
## 3     Europe & Central Asia                                         Euro
## 4                South Asia              IDA         HIPC Afghan afghani
## 5        Sub-Saharan Africa              IDA              Angolan kwanza
## 6     Europe & Central Asia             IBRD                Albanian lek
##                         V8                       V9
## 1 Latest population census  Latest household survey
## 2                     2000                         
## 3           Register based                         
## 4                     1979               MICS, 2003
## 5                     1970 MICS, 2001, MIS, 2006/07
## 6                     2001               MICS, 2005
##                                                                           V10
## 1                                                               Special Notes
## 2                                                                            
## 3                                                                            
## 4 Fiscal year end: March 20; reporting period for national accounts data: FY.
## 5                                                                            
## 6                                                                            
##                           V11                              V12
## 1 National accounts base year National accounts reference year
## 2                        1995                                 
## 3                                                             
## 4                   2002/2003                                 
## 5                        1997                                 
## 6                                                         1996
##                           V13                 V14
## 1 System of National Accounts SNA price valuation
## 2                                                
## 3                                                
## 4                                             VAB
## 5                                             VAP
## 6                        1993                 VAB
##                             V15             V16
## 1 Alternative conversion factor PPP survey year
## 2                                              
## 3                                              
## 4                                              
## 5                       1991-96            2005
## 6                                          2005
##                                 V17                            V18
## 1 Balance of Payments Manual in use External debt Reporting status
## 2                                                                 
## 3                                                                 
## 4                                                           Actual
## 5                              BPM5                         Actual
## 6                              BPM5                         Actual
##               V19                           V20
## 1 System of trade Government Accounting concept
## 2         Special                              
## 3         General                              
## 4         General                  Consolidated
## 5         Special                              
## 6         General                  Consolidated
##                               V21
## 1 IMF data dissemination standard
## 2                                
## 3                                
## 4                            GDDS
## 5                            GDDS
## 6                            GDDS
##                                                 V22
## 1 Source of most recent Income and expenditure data
## 2                                                  
## 3                                                  
## 4                                                  
## 5                                         IHS, 2000
## 6                                        LSMS, 2005
##                           V23                        V24
## 1 Vital registration complete Latest agricultural census
## 2                                                       
## 3                         Yes                           
## 4                                                       
## 5                                                1964-65
## 6                         Yes                       1998
##                      V25               V26                          V27
## 1 Latest industrial data Latest trade data Latest water withdrawal data
## 2                                     2008                             
## 3                                     2006                             
## 4                                     2008                         2000
## 5                                     1991                         2000
## 6                   2005              2008                         2000
##            V28       V29         V30         V31
## 1 2-alpha code WB-2 code  Table Name  Short Name
## 2           AW        AW       Aruba       Aruba
## 3           AD        AD     Andorra     Andorra
## 4           AF        AF Afghanistan Afghanistan
## 5           AO        AO      Angola      Angola
## 6           AL        AL     Albania     Albania
## 
## > tail(RAWedu)
##      V1                               V2                  V3
## 230 WSM                            Samoa Lower middle income
## 231 YEM                Republic of Yemen Lower middle income
## 232 ZAF         Republic of South Africa Upper middle income
## 233 ZAR Democratic Republic of the Congo          Low income
## 234 ZMB               Republic of Zambia          Low income
## 235 ZWE             Republic of Zimbabwe          Low income
##                             V4    V5   V6                 V7   V8
## 230        East Asia & Pacific   IDA             Samoan tala 2006
## 231 Middle East & North Africa   IDA             Yemeni rial 2004
## 232         Sub-Saharan Africa  IBRD      South African rand 2001
## 233         Sub-Saharan Africa   IDA HIPC    Congolese franc 1984
## 234         Sub-Saharan Africa   IDA HIPC     Zambian kwacha 2000
## 235         Sub-Saharan Africa Blend         Zimbabwe dollar 2002
##               V9
## 230             
## 231   MICS, 2006
## 232    DHS, 2003
## 233     DHS 2007
## 234    DHS, 2007
## 235 DHS, 2005/06
##                                                                             V10
## 230                                                                            
## 231                                                                            
## 232 Fiscal year end: March 31; reporting period for national accounts data: CY.
## 233                                                                            
## 234                                                                            
## 235  Fiscal year end: June 30; reporting period for national accounts data: CY.
##      V11 V12  V13 V14        V15  V16  V17         V18     V19
## 230 2002          VAB                 BPM5 Preliminary General
## 231 1990          VAP    1990-96 2005 BPM5      Actual General
## 232 2000     1993 VAB            2005 BPM5 Preliminary General
## 233 1987     1993 VAB    1999-01 2005 BPM5    Estimate Special
## 234 1994          VAB    1990-92 2005 BPM5 Preliminary General
## 235 1990          VAB 1991, 1998 2005 BPM5      Actual General
##              V20  V21            V22 V23  V24  V25  V26  V27 V28 V29
## 230                                      1999      2008       WS  WS
## 231    Budgetary GDDS    ES/BS, 2005     2002 2005 2008 2000  YE  RY
## 232 Consolidated SDDS    ES/BS, 2000     2000 2005 2008 2000  ZA  ZA
## 233 Consolidated GDDS 1-2-3, 2005-06     1990      1986 2000  CD  ZR
## 234    Budgetary GDDS   IHS, 2004-05     1990      2008 2000  ZM  ZM
## 235 Consolidated GDDS                    1960 1995 2008 2002  ZW  ZW
##                  V30             V31
## 230            Samoa           Samoa
## 231      Yemen, Rep.           Yemen
## 232     South Africa    South Africa
## 233 Congo, Dem. Rep. Dem. Rep. Congo
## 234           Zambia          Zambia
## 235         Zimbabwe        Zimbabwe
## 
## > EDU <- RAWedu
## 
## > colnames(EDU) <- EDU[1, ]
## 
## > EDU <- EDU[-1, ]
## 
## > names(EDU) <- tolower(names(EDU))
## 
## > names(EDU)
##  [1] "countrycode"                                      
##  [2] "long name"                                        
##  [3] "income group"                                     
##  [4] "region"                                           
##  [5] "lending category"                                 
##  [6] "other groups"                                     
##  [7] "currency unit"                                    
##  [8] "latest population census"                         
##  [9] "latest household survey"                          
## [10] "special notes"                                    
## [11] "national accounts base year"                      
## [12] "national accounts reference year"                 
## [13] "system of national accounts"                      
## [14] "sna price valuation"                              
## [15] "alternative conversion factor"                    
## [16] "ppp survey year"                                  
## [17] "balance of payments manual in use"                
## [18] "external debt reporting status"                   
## [19] "system of trade"                                  
## [20] "government accounting concept"                    
## [21] "imf data dissemination standard"                  
## [22] "source of most recent income and expenditure data"
## [23] "vital registration complete"                      
## [24] "latest agricultural census"                       
## [25] "latest industrial data"                           
## [26] "latest trade data"                                
## [27] "latest water withdrawal data"                     
## [28] "2-alpha code"                                     
## [29] "wb-2 code"                                        
## [30] "table name"                                       
## [31] "short name"                                       
## 
## > str(EDU)
## 'data.frame':	234 obs. of  31 variables:
##  $ countrycode                                      : chr  "ABW" "ADO" "AFG" "AGO" ...
##  $ long name                                        : chr  "Aruba" "Principality of Andorra" "Islamic State of Afghanistan" "People's Republic of Angola" ...
##  $ income group                                     : chr  "High income: nonOECD" "High income: nonOECD" "Low income" "Lower middle income" ...
##  $ region                                           : chr  "Latin America & Caribbean" "Europe & Central Asia" "South Asia" "Sub-Saharan Africa" ...
##  $ lending category                                 : chr  "" "" "IDA" "IDA" ...
##  $ other groups                                     : chr  "" "" "HIPC" "" ...
##  $ currency unit                                    : chr  "Aruban florin" "Euro" "Afghan afghani" "Angolan kwanza" ...
##  $ latest population census                         : chr  "2000" "Register based" "1979" "1970" ...
##  $ latest household survey                          : chr  "" "" "MICS, 2003" "MICS, 2001, MIS, 2006/07" ...
##  $ special notes                                    : chr  "" "" "Fiscal year end: March 20; reporting period for national accounts data: FY." "" ...
##  $ national accounts base year                      : chr  "1995" "" "2002/2003" "1997" ...
##  $ national accounts reference year                 : chr  "" "" "" "" ...
##  $ system of national accounts                      : chr  "" "" "" "" ...
##  $ sna price valuation                              : chr  "" "" "VAB" "VAP" ...
##  $ alternative conversion factor                    : chr  "" "" "" "1991-96" ...
##  $ ppp survey year                                  : chr  "" "" "" "2005" ...
##  $ balance of payments manual in use                : chr  "" "" "" "BPM5" ...
##  $ external debt reporting status                   : chr  "" "" "Actual" "Actual" ...
##  $ system of trade                                  : chr  "Special" "General" "General" "Special" ...
##  $ government accounting concept                    : chr  "" "" "Consolidated" "" ...
##  $ imf data dissemination standard                  : chr  "" "" "GDDS" "GDDS" ...
##  $ source of most recent income and expenditure data: chr  "" "" "" "IHS, 2000" ...
##  $ vital registration complete                      : chr  "" "Yes" "" "" ...
##  $ latest agricultural census                       : chr  "" "" "" "1964-65" ...
##  $ latest industrial data                           : chr  "" "" "" "" ...
##  $ latest trade data                                : chr  "2008" "2006" "2008" "1991" ...
##  $ latest water withdrawal data                     : chr  "" "" "2000" "2000" ...
##  $ 2-alpha code                                     : chr  "AW" "AD" "AF" "AO" ...
##  $ wb-2 code                                        : chr  "AW" "AD" "AF" "AO" ...
##  $ table name                                       : chr  "Aruba" "Andorra" "Afghanistan" "Angola" ...
##  $ short name                                       : chr  "Aruba" "Andorra" "Afghanistan" "Angola" ...
## 
## > EDU$iso3.countrycode <- countrycode(EDU$`short name`, 
## +     "country.name", "iso3c")
## 
## > EDU$iso3.countrycode[which(EDU$countrycode == "KSV")] <- "KSV"
## 
## > EDU$iso3.countrycode[which(EDU$countrycode == "CHI")] <- "CHI"
## 
## > EDU$iso3.countrycode[which(EDU$countrycode == "STP")] <- "STP"
## 
## > EduNoCountryCode <- EDU[is.na(EDU$iso3.countrycode) == 
## +     TRUE, ]
## 
## > EDU <- EDU[is.na(EDU$iso3.countrycode) == FALSE, ]
## 
## > dim(RAWedu)
## [1] 235  31
## 
## > dim(EDU)
## [1] 211  32
## 
## > dim(EduNoCountryCode)
## [1] 23 32
## 
## > write.csv(EDU, "EDU_Final.csv")
## 
## > write.csv(EduNoCountryCode, "EDUNoCountryCode.csv")
```

<br>                                      
                                      
* **Clearing existing objects**

```r
source("removeObjects.R", echo = TRUE)
```

```
## 
## > remove(list = ls())
```
             
<br>

* **Loading tidy data for analysis**

```r
#Load cleaned up csv file for GDP

#setwd("~/git/MSDS6306/CaseStudy01/Analysis")
gdppath <- "GDP_Final.csv"
edupath <- "EDU_Final.csv"

#load and 
GDP <- read.csv(gdppath,header=TRUE)
names(GDP)[names(GDP)=="X"] <- "ID"
str(GDP)
```

```
## 'data.frame':	214 obs. of  7 variables:
##  $ ID              : int  6 7 8 9 10 11 12 13 14 15 ...
##  $ countrycode     : Factor w/ 214 levels "ABW","ADO","AFG",..: 201 37 96 49 63 67 27 162 93 87 ...
##  $ ranking         : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ economy         : Factor w/ 214 levels "Afghanistan",..: 204 41 95 71 66 203 27 157 93 86 ...
##  $ us.dollars      : int  16244600 8227103 5959718 3428131 2612878 2471784 2252664 2014775 2014670 1841710 ...
##  $ Comments        : Factor w/ 7 levels "","Covers mainland Tanzania only",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ iso3.countrycode: Factor w/ 214 levels "ABW","AFG","AGO",..: 203 37 98 50 65 69 27 165 95 89 ...
```

```r
EDU <- read.csv(edupath,header=TRUE)
names(EDU)[names(EDU)=="X"] <- "ID"
str(EDU)
```

```
## 'data.frame':	211 obs. of  33 variables:
##  $ ID                                               : int  2 3 4 5 6 7 8 9 10 11 ...
##  $ countrycode                                      : Factor w/ 211 levels "ABW","ADO","AFG",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ long.name                                        : Factor w/ 211 levels "American Samoa",..: 5 85 48 80 90 206 4 91 1 2 ...
##  $ income.group                                     : Factor w/ 6 levels "","High income: nonOECD",..: 2 2 5 4 6 2 6 4 6 6 ...
##  $ region                                           : Factor w/ 8 levels "","East Asia & Pacific",..: 4 3 7 8 3 5 4 3 2 4 ...
##  $ lending.category                                 : Factor w/ 4 levels "","Blend","IBRD",..: 1 1 4 4 3 1 3 2 1 3 ...
##  $ other.groups                                     : Factor w/ 3 levels "","Euro area",..: 1 1 3 1 1 1 1 1 1 1 ...
##  $ currency.unit                                    : Factor w/ 155 levels "","Afghan afghani",..: 8 49 2 5 3 144 6 7 148 44 ...
##  $ latest.population.census                         : Factor w/ 28 levels "","1970","1979",..: 17 28 3 2 18 22 18 18 17 18 ...
##  $ latest.household.survey                          : Factor w/ 56 levels "","CPS (monthly)",..: 1 1 35 34 37 1 1 14 1 1 ...
##  $ special.notes                                    : Factor w/ 48 levels "","A simple multiplier is used to convert the national currencies of EMU members to euros. The following irrevocable euro conversi"| __truncated__,..: 1 1 22 1 1 1 1 1 1 43 ...
##  $ national.accounts.base.year                      : Factor w/ 43 levels "","1954","1973",..: 24 1 37 27 1 24 21 1 1 17 ...
##  $ national.accounts.reference.year                 : int  NA NA NA NA 1996 NA NA 1996 NA NA ...
##  $ system.of.national.accounts                      : int  NA NA NA NA 1993 NA 1993 1993 NA NA ...
##  $ sna.price.valuation                              : Factor w/ 3 levels "","VAB","VAP": 1 1 2 3 2 2 2 2 1 2 ...
##  $ alternative.conversion.factor                    : Factor w/ 33 levels "","1960-85","1965-84",..: 1 1 1 25 1 1 6 21 1 1 ...
##  $ ppp.survey.year                                  : int  NA NA NA 2005 2005 NA 2005 2005 NA NA ...
##  $ balance.of.payments.manual.in.use                : Factor w/ 3 levels "","BPM4","BPM5": 1 1 1 3 3 2 3 3 1 3 ...
##  $ external.debt.reporting.status                   : Factor w/ 4 levels "","Actual","Estimate",..: 1 1 2 2 2 1 2 2 1 1 ...
##  $ system.of.trade                                  : Factor w/ 3 levels "","General","Special": 3 2 2 3 2 2 3 3 1 2 ...
##  $ government.accounting.concept                    : Factor w/ 3 levels "","Budgetary",..: 1 1 3 1 3 3 3 3 1 1 ...
##  $ imf.data.dissemination.standard                  : Factor w/ 3 levels "","GDDS","SDDS": 1 1 2 2 2 2 3 3 1 2 ...
##  $ source.of.most.recent.income.and.expenditure.data: Factor w/ 77 levels "","1-2-3, 2005-06",..: 1 1 1 35 66 1 45 46 1 1 ...
##  $ vital.registration.complete                      : Factor w/ 2 levels "","Yes": 1 2 1 1 2 1 2 2 2 2 ...
##  $ latest.agricultural.census                       : Factor w/ 45 levels "","1960","1964-65",..: 1 1 1 3 32 32 41 1 1 1 ...
##  $ latest.industrial.data                           : int  NA NA NA NA 2005 NA 2001 NA NA NA ...
##  $ latest.trade.data                                : int  2008 2006 2008 1991 2008 2008 2008 2008 NA 2007 ...
##  $ latest.water.withdrawal.data                     : int  NA NA 2000 2000 2000 2005 2000 2000 NA 1990 ...
##  $ X2.alpha.code                                    : Factor w/ 207 levels "","AD","AE","AF",..: 13 2 4 8 6 3 9 7 10 5 ...
##  $ wb.2.code                                        : Factor w/ 208 levels "","AD","AE","AF",..: 13 2 4 8 6 3 9 7 10 5 ...
##  $ table.name                                       : Factor w/ 211 levels "Afghanistan",..: 10 5 1 6 2 200 8 9 4 7 ...
##  $ short.name                                       : Factor w/ 211 levels "Afghanistan",..: 10 5 1 6 2 200 8 9 4 7 ...
##  $ iso3.countrycode                                 : Factor w/ 210 levels "ABW","AFG","AGO",..: 1 5 2 3 4 6 7 8 9 10 ...
```
<br>
<br>

#### Merging GDP and EDU data
The original data have been cleaned and only the columns of interest have been set aside for merging, GDP and EDU data are ready to be merged together. After merging the two data sets together by *iso3.countrycode*


<br>

#### Reduce to columns of interest       
* iso3.countrycode
* "economy"
* "ranking"
* "income group"
* "us.dollars"      


```r
names(MergeGDPInc)[names(MergeGDPInc)=="iso3.countrycode"] <- "country.code"
names(MergeGDPInc)[names(MergeGDPInc)=="economy"] <- "country.name"
names(MergeGDPInc)[names(MergeGDPInc)=="ranking"] <- "gdp.ranking"
names(MergeGDPInc)[names(MergeGDPInc)=="income group"] <- "income.group"
names(MergeGDPInc)[names(MergeGDPInc)=="us.dollars"] <- "gdp.usd"

MergeGDPInc <- subset(MergeGDPInc,select = c("country.code","country.name","gdp.ranking","income.group","gdp.usd"))

str(MergeGDPInc)
```

```
## 'data.frame':	215 obs. of  5 variables:
##  $ country.code: Factor w/ 214 levels "ABW","AFG","AGO",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ country.name: Factor w/ 214 levels "Afghanistan",..: 10 1 6 2 5 202 8 9 4 7 ...
##  $ gdp.ranking : int  161 105 60 125 NA 32 26 133 NA 172 ...
##  $ income.group: Factor w/ 6 levels "","High income: nonOECD",..: 2 5 4 6 2 2 6 4 6 6 ...
##  $ gdp.usd     : int  2584 20497 114147 12648 0 348595 475502 9951 0 1134 ...
```
            
<br>
<br>

### Results:

#### **Question 1:** Match the data based on the country shortcode. How many of the IDs match?
<br>

```r
## how many of the IDs match?
nrow(MergeGDPInc)
```

```
## [1] 215
```

```r
## how many of the rows contain NAs?
sum(!complete.cases(MergeGDPInc))
```

```
## [1] 26
```

```r
## Remove rows with missing data
MergeGDPInc01 <- MergeGDPInc[complete.cases(MergeGDPInc),]
nrow(MergeGDPInc01) 
```

```
## [1] 189
```

```r
str(MergeGDPInc01)
```

```
## 'data.frame':	189 obs. of  5 variables:
##  $ country.code: Factor w/ 214 levels "ABW","AFG","AGO",..: 1 2 3 4 6 7 8 10 11 12 ...
##  $ country.name: Factor w/ 214 levels "Afghanistan",..: 10 1 6 2 202 8 9 7 11 12 ...
##  $ gdp.ranking : int  161 105 60 125 32 26 133 172 12 27 ...
##  $ income.group: Factor w/ 6 levels "","High income: nonOECD",..: 2 5 4 6 2 6 4 6 3 3 ...
##  $ gdp.usd     : int  2584 20497 114147 12648 348595 475502 9951 1134 1532408 394708 ...
```

##### **There are 215 matching IDs. Once all 26 NAs are removed, there remain 189 matching country code IDs.**       

<br>
<br>

#### **Question 2:** Sort the data frame in ascending order by GDP (so United States is last). What is the 13th country in the resulting data frame?
<br>

```r
MergeGDPInc01 <- MergeGDPInc01[order(MergeGDPInc01$gdp.usd, decreasing = FALSE),] # Sort the data by GDP
MergeGDPInc01$country.name[13]
```

```
## [1] St. Kitts and Nevis
## 214 Levels: Afghanistan Albania Algeria American Samoa Andorra ... Zimbabwe
```
                   
##### **St. Kitts and Nevis is the 13th country in the data frame**            

<br>
<br>

#### **Question 3:** What are the average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups?
<br>

```r
mean(subset(MergeGDPInc01, income.group == "High income: OECD")$gdp.ranking)    # Mean High income: OECD rank
```

```
## [1] 32.96667
```

```r
mean(subset(MergeGDPInc01, income.group == "High income: nonOECD")$gdp.ranking) # Mean High income: nonOECD rank
```

```
## [1] 91.91304
```
       
##### **Average *High income: OECD* GDP ranking is 32.96667.**
##### **Average *High income: nonOECD* GDP ranking is 91.91304.**

<br>
<br>

#### **Question 4:** Plot the GDP for all of the countries. Use ggplot2 to color your plot by Income.Group?
<br>

```r
 ggplot(data = MergeGDPInc01, aes(x=income.group, y=(gdp.usd/10000), fill=income.group)) + 
  geom_boxplot(outlier.colour = "red", outlier.shape = 8, outlier.size = 2) +
  ggtitle("GDP for All Countries by Income Group") +
  labs(x="Income Group", y="(GDP/10,000) (US Dollars in Millions)") + theme(text = element_text(size=12),
        axis.text.x = element_text(angle=90, vjust=1)) 
```

![](CaseStudy01_files/figure-html/[gdprankingplotgdp-1.png)<!-- -->
                         
##### **The first boxplot visualization depicts all *GDP (US Dollars in million)* data by *Income Group*.**             

##### **The data appears heavily skewed and large outliers in *High income: OECD* and *Lower middle income* make it difficult to compare each distribution by *Income.Group*. Its best to log transform the data and then visualize the box plots**        
<br>

```r
 ggplot(data = MergeGDPInc01, aes(x=income.group, y=log(gdp.usd/10000), fill=income.group)) + 
  geom_boxplot(outlier.colour = "red", outlier.shape = 8, outlier.size = 2) +
  ggtitle("Log of GDP for All Countries by Income Group") +
  labs(x="Income Group", y="Log of GDP (US Dollars in Millions)") + theme(text = element_text(size=12),
        axis.text.x = element_text(angle=90, vjust=1)) 
```

![](CaseStudy01_files/figure-html/[gdprankingplotgdplog-1.png)<!-- -->
<br>      

##### **As soon as the data was log transformed, it was evident that most of the *High income: OECD* group data exceed the remaining groups' data in terms of GDP, It appears that *High income: nonOECD's* appears to be nearly identical to *Upper middle income's* **

<br>
<br>

#### **Question 5:** Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries are lower middle income but among the 38 nations with the highest GDP?
##### *ntile* function is used to split the GDP rankings into 5 separate quantile groups, this function is from the *dplyr* package. 
<br>

```r
MergeQuantile <- MergeGDPInc01
MergeQuantile$gdp.quantile <- ntile(MergeQuantile$gdp.ranking, 5) # Add 5 quantiles by Country.Rank to new GDP.Quantile column

## Generate table by Income.Group output
table(MergeQuantile$income.group, MergeQuantile$gdp.quantile, dnn = c("Income.Group","GDP.Quantile"))
```

```
##                       GDP.Quantile
## Income.Group            1  2  3  4  5
##                         0  0  0  0  0
##   High income: nonOECD  4  5  8  5  1
##   High income: OECD    18 10  1  1  0
##   Lower middle income   5 13 12  8 16
##   Low income            0  1  9 16 11
##   Upper middle income  11  9  8  8  9
```

```r
## Confirm number of lower middle income countries as listed in the table above
sum(MergeQuantile[(nrow(MergeQuantile)-37):nrow(MergeQuantile),]$income.group == "Lower middle income")
```

```
## [1] 5
```
<br>          

##### **Based on the groupings, *Lower middle income* group are among the 38 nations with the highest GDP, especially 5 countries.**       

<br>
<br>
<br>       

#### Conclusion:      

