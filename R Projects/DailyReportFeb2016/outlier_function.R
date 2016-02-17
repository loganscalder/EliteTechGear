# a code to look for outliers
outlier <- function(x, 
                    iqrFactor = 1.5, 
                    lowOutlier = T,
                    highOutlier = T){
    # args:
        # x     an numeric vector to test for outliers
        # iqrFactor     a number
        # lowOutlier    Are we looking for low outliers?
        # highOutlier   Are we looking for high outliers?
    
    iqr = quantile(x, probs = c(.25, .75))
    
    if(lowOutlier){
        tooLow = which(x < min(iqr) - iqrFactor*diff(iqr))
    }
    
    if(highOutlier){
        tooHigh = which(x > max(iqr)+iqrFactor*diff(iqr))
    }
    
    if( lowOutlier & highOutlier){
        list(tooLow = tooLow, tooHigh = tooHigh)
    }
    
    if(!lowOutlier){
        tooHigh
    }
    
    if(!highOutlier){
        tooLow
    }
    message("there's an error in this function
            It needs to be taught wha the last line of
            code should be, or it needs to be taught what
            to print")
}


