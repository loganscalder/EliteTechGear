FromDate = 
  as.Date("2015-09-06") - seq(from = 0, to = 91-7, by = 7)
FromDate = FromDate[order(FromDate)]
ToDate = 
  FromDate + 6


data.frame(FromDate, ToDate)

urls = 
  paste0("open ",
         "'https://sellercentral.amazon.com/gp/site-metrics/report.html#&cols=/c3/c9/c10/c11/c12&sortColumn=13&filterFromDate=",
         strftime(FromDate, format = "%m/%d/%Y"), 
         "&filterToDate=", 
         strftime(ToDate, format = "%m/%d/%Y"), 
         "&fromDate=",
         strftime(FromDate, format = "%m/%d/%Y"), 
         "&toDate=",
         strftime(ToDate, format = "%m/%d/%Y"), 
         "&reportID=102:DetailSalesTrafficBySKU&sortIsAscending=0&currentPage=0&dateUnit=1&viewDateUnits=ALL&runDate='"
  )

write.csv(urls, "urls.csv")
