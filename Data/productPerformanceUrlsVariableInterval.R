writeUrls = 
function(recentFromDate = "2015-05-24", 
intervalLength = 7,
numberOfIntervalsnumberOfIntervals = 13,
saveTo = "/Users/loganscalder/Google Drive/EliteTechGear/Data"){
  FromDate = 
    as.Date(recentFromDate, format = "%Y-%m-%d") - 
    seq(from = 0, to = (numberOfIntervals-1)*intervalLength, 
    	by = intervalLength)
  FromDate = FromDate[order(FromDate)]
  ToDate = 
    FromDate + intervalLength-1
  
  
  data.frame(FromDate, ToDate)
  
  urls = 
    paste0("open ",
           "'https://sellercentral.amazon.com/gp/site-metrics/report.html#&cols=/c0/c1/c2/c3/c4/c5/c6/c7/c8/c9/c10/c11/c12&sortColumn=13&filterFromDate=",
           strftime(FromDate, format = "%m/%d/%Y"), 
           "&filterToDate=", 
           strftime(ToDate, format = "%m/%d/%Y"), 
           "&fromDate=",
           strftime(FromDate, format = "%m/%d/%Y"), 
           "&toDate=",
           strftime(ToDate, format = "%m/%d/%Y"), 
           "&reportID=102:DetailSalesTrafficBySKU&sortIsAscending=0&currentPage=0&dateUnit=1&viewDateUnits=ALL&runDate='"
    )
  setwd(saveTo)
  write.csv(urls, "urls.csv")
  message(paste0("terminal commands to open urls data on product performance
                 are now saved under \n", getwd(), "/urls.csv'"))
}
writeUrls()