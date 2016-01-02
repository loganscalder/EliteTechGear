# Import Data
#===============

# Import Sales Data
# How many weeks of sales do we need to make forecasts?
# We'll only need the ASIN (or whatever), date for the week, and total sales for the week


# Import Inventroy Data
  # just current inventory for the 
#https://sellercentral.amazon.com/gp/site-metrics/report.html#&cols=/c3/c9&sortColumn=13&filterFromDate=06/28/2015&filterToDate=07/04/2015&fromDate=06/28/2015&toDate=07/04/2015&reportID=102:DetailSalesTrafficBySKU&sortIsAscending=0&currentPage=0&dateUnit=1&viewDateUnits=ALL&runDate=


FromDate = 
    as.Date("2015-12-20", format = "%Y-%m-%d") - seq(from = 0, to = 91-7, by = 7)
FromDate = FromDate[order(FromDate)]
ToDate = 
  FromDate + 6
# ToDate = c("06/06/2015",
#            "06/13/2015",
#            "06/20/2015",
#            "06/27/2015",
#            "07/04/2015",
#            "07/11/2015",
#            "07/18/2015",
#            "07/25/2015",
#            "08/01/2015",
#            "08/08/2015",
#            "08/15/2015",
#            "08/22/2015",
#            "08/29/2015"
# )

data.frame(FromDate, ToDate)

urls = 
  paste0("open ",
         "'https://sellercentral.amazon.com/gp/site-metrics/report.html#&cols=/c3/c9&sortColumn=13&filterFromDate=",
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


