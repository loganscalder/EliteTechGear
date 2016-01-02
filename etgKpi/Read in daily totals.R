dailyFiles = list.files(pattern = "^dailyTotals")
if(length(dailyFiles) != 1){
  stop('Check that there is only one data file that starts with "dailyTotals"')
}
dailyTotalsFile = dailyFiles

daily = read.csv(dailyTotalsFile)
require(plyr)
dim(daily)
daily = colwise(.fun = gsub, pattern = "([$%,])", replacement = "")(daily)
daily = cbind(Date = as.Date(daily$Date, format = "%m/%d/%Y"),
              colwise(.fun = as.numeric)(daily[2:length(daily)]))
daily = mutate(daily, Date = as.Date(Date, format = "%m/%d/%Y"))
dailyTotals = daily
rm(daily)
head(dailyTotals)
sapply(dailyTotals, class)
