## Function: getNormalDistribution()
## Description: Random generation for the normal distribution, 
## requires the number of samples to be generated with a desired 
## mean and standard deviation, by default the mean and standard 
## deviation is set to 0 and 1, returns the normaly distributed samples
##
## Parameters:  
## n = number of sample data to collect
## meanval = desired mean
## sdval = desired standard deviation
##
## Returns:  
## getNormalDistributionVal = normal distributed values
##

getNormalDistribution <- function(n,meanval=0,sdval=1){

  getNormalDistributionVal <- (rnorm(n,meanval,sdval))
  getNormalDistributionMean <- mean(getNormalDistributionVal)
  getNormalDistributionSD <- sd(getNormalDistributionVal)

  return(getNormalDistributionVal)
}