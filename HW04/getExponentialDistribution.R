## Function: getExponentialDistribution()
## Description: Random generation for the exponential distribution, 
## requires the number of samples to be generated with a desired 
## rate returns exponentially distributed samples
##
## Parameters:  
## n = number of sample data to collect
## rate = desired rate
##
## Returns:  
## getExponentialDistributionVal = Exponential distributed samples
##

getExponentialDistribution <- function(n,rate=1){
  
  getExponentialDistributionVal <- (rexp(n,rate))
  getExponentialDistributionMean <- mean(getExponentialDistributionVal)
  getExponentialDistributionSD <- sd(getExponentialDistributionVal)
  
  return(getExponentialDistributionVal)
}