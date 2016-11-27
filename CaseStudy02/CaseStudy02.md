# Case Study 02
contributed by Ramesh and gino  
December 08, 2016  
## Introduction

Case Study 02, final case study.    

* installation and loading of necessary packages              
* R version        
<br>


```r
knitr::opts_chunk$set(echo = TRUE)
require(tseries)
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
## [1] tseries_0.10-35
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.7     quadprog_1.5-5  lattice_0.20-33 zoo_1.7-13     
##  [5] digest_0.6.10   assertthat_0.1  grid_3.2.3      formatR_1.4    
##  [9] magrittr_1.5    evaluate_0.10   stringi_1.1.2   rmarkdown_1.1  
## [13] tools_3.2.3     stringr_1.1.0   yaml_2.1.13     htmltools_0.3.5
## [17] knitr_1.14      tibble_1.2
```

<br>
<br>

### Question 1                                                        
##### Create the X matrix and print it from SAS, R, and Python.                            
<br>

#### SAS Code



```sas
data mylib.Xmatrix;
input x0 x1 x2 x3;
datalines;
4 5 1 2
1 0 3 5
2 1 8 2
;
run;
quit;

Proc IML;
use mylib.Xmatrix;
read all;
x = x0 || x1 || x2 || x3;
print x;
run;
quit;
```
![alt text](https://github.com/gjv9491/MSDS6306/blob/casestudy02/CaseStudy02/CaseStudy02_files/figure-html/SASQ01-1.png "SAS output")
<br>

#### R Code



```r
new_vector <- c(4,5,1,2,1,0,3,5,2,1,8,2)
X <- matrix(new_vector, ncol=4, nrow=3, byrow=TRUE)
X
```

```
##      [,1] [,2] [,3] [,4]
## [1,]    4    5    1    2
## [2,]    1    0    3    5
## [3,]    2    1    8    2
```
<br>

#### Python Code



```python
import numpy as np

new_array = np.array([4,5,1,2,1,0,3,5,2,1,8,2])
new_matrix = np.matrix(new_array)
X = new_matrix.reshape(3,4)
print(X)
```
![alt text](https://github.com/gjv9491/MSDS6306/blob/casestudy02/CaseStudy02/CaseStudy02_files/figure-html/PYTHONQ01-1.png "Python output")
<br>

### Question 2                                                        
##### Please do the following with your assigned stock. "ADP" 
<br>

#### Download "ADP" data.

```r
ADP_data <- get.hist.quote('ADP',quote="Close")
```

```
## time series ends   2016-11-25
```
<br>

#### Calculate log returns.                        

```r
ADP_return <- log(lag(ADP_data)) - log(ADP_data)
ADP_volatility <- sd(ADP_return) * sqrt(250) * 100
```
<br>

#### Calculate volatility measure.

```r
getVol <- function(d, log_returns){
  var = 0
  lam = 0
  varlist <- c()

  for (r in log_returns) {
    lam = lam*(1 - 1/d) + 1
    var = (1 - 1/lam)*var + (1/lam)*r^2
    varlist <- c(varlist, var)
  }
  sqrt(varlist)
}
```
<br>

#### Calculate volatility over entire length of series for various three different decay factors.

```r
volest <- getVol(10,ADP_return)
volest2 <- getVol(30,ADP_return)
volest3 <- getVol(100,ADP_return)
```
<br>                

#### Plot the results, overlaying the volatility curves on the data, just as was done in the S&P example.              

```r
plot(volest, type="l", col="green", main="Volatility curves for ADP stock", ylab = "Volitality Estimate")
lines(volest2,type="l",col="red")
lines(volest3, type = "l", col="blue")
```

![](CaseStudy02_files/figure-html/radp05-1.png)<!-- -->
<br>  
<br>
