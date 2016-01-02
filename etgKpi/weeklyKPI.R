
rm(list = ls())
require(plyr)
dateRanges = c(
               "03-15--03-21",
               "03-22--03-28",
               "03-29--04-04",
               "04-05--04-11",
               "04-12--04-18",
               "04-12--04-18",
               "04-19--04-25",
               "04-26--05-02"
               )
weeklyList = list()
length(weeklyList) = 8
names(weeklyList) = dateRanges
for (i in 1:length(weeklyList)){
  weeklyList[[i]] = read.csv(paste0("salesByAsin",dateRanges[i],".csv"),
                             stringsAsFactors = F)
  weeklyList[[i]] = 
    mutate(weeklyList[[i]], 
           # Take out %
           Session.Percentage = as.numeric(gsub("%", "", Session.Percentage)),
           # Take out %
           Page.Views.Percentage = as.numeric(gsub("%", "", Page.Views.Percentage)),
           # Take out %
           Buy.Box.Percentage = as.numeric(gsub("%", "", Buy.Box.Percentage)),
           # Take out %
           Unit.Session.Percentage = as.numeric(gsub("%", "", Unit.Session.Percentage)),
           # Take out $ and ,
           Ordered.Product.Sales = 
             as.numeric(gsub("\\$", "",
                             gsub(",", "", Ordered.Product.Sales))),
           # Calculate data
           itemsPerDay = Units.Ordered/7,
           salesPerDay = Ordered.Product.Sales/7,
           week = dateRanges[i]) 
}  # read in the weekly data, to each data frame, cbind the date range
# should the dates be turned into factors?  ..Or the time series class...?
head(weeklyList[[1]])
names(weeklyList[[1]])
names(weeklyList)
lapply(weeklyList, summary)

relevantList = lapply(weeklyList, 
                      function(x){
                        x[,c("SKU", "Total.Order.Items", "Units.Ordered", "Ordered.Product.Sales", 
                             "itemsPerDay", "salesPerDay", "week")]
                      })
lapply(relevantList, head)

relevantData = do.call(rbind, relevantList)
head(relevantData)
rownames(relevantData) <- with(relevantData, paste0(week,SKU))
# ToDo:
#   Pull relevant Data (list?)
#   Export 56, 28, 14, and 7 day report (this takes priority, cuz, I should prove we can automate what we have)
#   Make Graphics :) this is the fun part.  
# What I want to do is plot the sales per day, items per day for every sku and every week
require(lattice)
barchart(itemsPerDay~week | SKU, data = relevantData, 
         main = "items per day each week")
barchart(salesPerDay~week | SKU, data = relevantData, 
         main = "sales per day each week")

# OOO, you don't need this, I think
byWeek = 
  ddply(relevantData,
        .var = .(week),
        .fun = summarise,
        totalOrderItems = sum(Total.Order.Items),
        unitsOrdered = sum(Units.Ordered),
        sales = sum(Ordered.Product.Sales),
        itemsPerDay = sum(itemsPerDay)/length(week),
        salesPerDay = sum(salesPerDay)/length(week)
  )
byWeek
