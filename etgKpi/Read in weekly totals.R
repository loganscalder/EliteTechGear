# Read in Weekly Totals
weeklyTotalFiles = list.files(pattern = "^weeklyTotalsPastYearFromWeek")
if(length(weeklyTotalFiles) !=1) {
  stop('check to see that there is one data file that starts with 
       "weeklyTotalsPastYearFromWeek"')
}
weeklyTotalsFile = weeklyTotalFiles

weeklyTotals = read.csv(weeklyTotalsFile)
head(weeklyTotals)
require(plyr)
weeklyTotals = 
  colwise(.fun = gsub, pattern = "([$%,])", replacement = "")(weeklyTotals)
head(weeklyTotals)
weeklyTotals = cbind(Week = as.Date(weeklyTotals$Date, format = "%m/%d/%Y"),
                     colwise(.fun = as.numeric)(
                       weeklyTotals[2:length(weeklyTotals)]))
head(weeklyTotals)
# Week should be changed to week number... nah. 


