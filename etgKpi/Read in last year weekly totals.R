# Read in last year weekly totals
# test weeks = 18:25
lastYear = read.csv(paste0("lastYearToWeek",weeks[length(weeks)],".csv"))
require(plyr)

lastYear = 
  colwise(gsub, pattern = "([$%,])", replacement = "")(lastYear)
head(lastYear)

lastYear = 
  with(lastYear,
       cbind(
         Week = as.Date(Date, format = "%m/%d/%Y"),
         colwise(as.numeric)(lastYear[-1])))
head(lastYear)
