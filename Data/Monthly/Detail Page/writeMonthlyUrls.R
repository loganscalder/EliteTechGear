writeUrls = function(recentFromDate = "2015-05-24", numberOfWeeks = 13){
  FromDate = 
    as.Date(recentFromDate, format = "%Y-%m-%d") - 
    seq(from = 0, to = (numberOfWeeks-1)*7, by = 7)
  FromDate = FromDate[order(FromDate)]
  ToDate = 
    FromDate + 6
  
  
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
  setwd('/Users/loganscalder/Google Drive/EliteTechGear/Data/Weekly from Detail Page Sales and Traffic')
  write.csv(urls, "urls.csv")
  message(paste0("This Does not Do what It is Intended to Do!
  terminal commands to open urls with weekly product performance
                 are now saved under ", getwd(), "/urls.csv'"))
}
writeUrls()