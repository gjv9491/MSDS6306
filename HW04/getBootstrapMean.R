## Function: getBootstrapMean()
## Description: Generates bootstrap mean when
## [Normal|Exponential] distribution are passed in with 
## desired number of boot strap samples
##
## Parameters:  
## distribution = sample distribution
## bootsamples = number of sample data to collect
##
## Returns: 
## bootmean = BootMean
##


getBootstrapMean <- function(distribution,bootsamples){
  bootmean <- numeric(bootsamples)
  
  ## Run bootstrap sequence
  for (i in 1:bootsamples){
    bootsample <- sample(distribution, size = length(distribution), replace = TRUE)
    bootmean[i] <- mean(bootsample)
  }
  
  return(c(bootmean))
}