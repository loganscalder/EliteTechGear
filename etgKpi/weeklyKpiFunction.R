# kpiFunctions
# for testing:   rm(list = ls())  weeks = 16:23   fileName = paste0("kpiWeeks",weeks[1],"-", weeks[length(weeks)])

# Thoughts to consider: 
#  How can we test my automation?  I guess we have to test it on what's already been calculated
#   Test:  Download data for weeks that you've already analyzed.  Process the data with the
#   weeklyKpi function and compare the numbers the function gives with the numbers you saw before.

# put default values into dailyTotals, weeklyTotals, 
#  check for 

weeklyKpi = function(weeks, 
                     fileName = paste0("kpiWeeks",
                                       weeks[1],
                                       "-", 
                                       weeks[length(weeks)])
){
  ### Input Variables
  # weeks   character or numerical vector of the weeks you want to look at (1 to 52)
  #           ex: weeks = c(2,3,4,5,6,7)
  
  ### Output Values
  # An object that contains data tables calculated from KPI's 
  # and the graphs of the weekly KPI's
  # Graphs will also be saved... Haven't decided on the naming convention yet
  # Data tables will be exported as csv's.  Again, naming of exports TBD.
  
  # Load packages
  require(plyr)
  require(lattice)
  #===========================
  ### Load and Transform Data
  #===========================
  weeklyList = list()
  length(weeklyList) = length(weeks)
  names(weeklyList) = weeks
  
  for (i in 1:length(weeklyList)){
    weeklyList[[i]] = read.csv(paste0("salesByAsinWeek",weeks[i],".csv"),
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
             # Calculate additional data
             itemsPerDay = Units.Ordered/7,
             salesPerDay = Ordered.Product.Sales/7,
             week = weeks[i]) 
  }  # read in the weekly data, to each data frame, cbind the date range
  # lapply(weeklyList,head)
  
  #===========================
  ### Subset Data
  #===========================
  relevantList = lapply(weeklyList, 
                        function(x){
                          x[,c("SKU", "Total.Order.Items", "Units.Ordered", "Ordered.Product.Sales", 
                               "itemsPerDay", "salesPerDay", "week")]
                        })
  #lapply(relevantList, head)
  #s = lapply(relevantList, function(x){
  #summary(as.factor(x[,"SKU"]))  
  #})  # checking SKU's for repeats in each week
  
  # One data frame for all weeks
  relevantData = do.call(rbind, relevantList)
  rownames(relevantData) <- with(relevantData, paste0("week",week," ",SKU))
  
  #===================
  # Find avg sales by sku
  #==================
  bySku =
    ddply(relevantData,
          .var = .(SKU),
          .fun = summarise,
          avgSales = sum(Ordered.Product.Sales)/length(SKU))
  
  ## set sku levels by avg sales over period
  rankedSku = bySku$SKU[order(bySku$avgSales,decreasing = T)]
  relevantData = transform(relevantData, 
                           SKU = factor(SKU, levels = rankedSku))
  #===================
  # Plot Data
  #===================
  # choose the data
  relevantData = transform(relevantData, week = as.factor(week))
  
  # source daily and weekly totals
  source("Read in daily totals.R", local = T)
  source("Read in weekly totals.R", local = T)
  
  # open graphics device
  pdf(file = paste0(fileName,".pdf"), width = 12, height = 12, onefile = T)
  # plot
  print(barchart(Total.Order.Items ~ week | SKU, data = relevantData, 
                 panel = function(...){
                   panel.abline(h = seq(0, 1000, by = 50), col = "grey")
                   panel.barchart(...)
                   panel.lmline(..., col = 2)
                 },
                 main = paste0("Total.Order.Items each week ","(",weeks[1],"-",weeks[length(weeks)],")"),
                 xlab = "week",
                 ylab = "Total.Order.Items"))
  
  print(barchart(Units.Ordered ~ week | SKU, data = relevantData, 
                 panel = function( ...){
                   panel.abline(h = seq(0, 1000, by = 50), col = "grey")
                   panel.barchart(...)
                   panel.lmline(..., col = 2)
                 },
                 main = paste0("Units.Ordered each week ","(",weeks[1],"-",weeks[length(weeks)],")"),
                 xlab = "week",
                 ylab = "Units.Ordered"))
  
  print(barchart(Ordered.Product.Sales ~ week | SKU, data = relevantData, 
                 panel = function(...){
                   panel.abline(h = seq(0, 5000, by = 500), col = "grey")
                   panel.barchart(...)
                   panel.lmline(..., col = 2)
                 },
                 main = paste0("Ordered.Product.Sales each week ","(",weeks[1],"-",weeks[length(weeks)],")"),
                 xlab = "week",
                 ylab = "Ordered.Product.Sales"))
  
  print(barchart(itemsPerDay ~ week | SKU, data = relevantData, 
                 panel = function(...){
                   panel.abline(h = seq(0, 100, by = 10), col = "grey")
                   panel.barchart(...)
                   panel.lmline(..., col = 2)
                 },
                 main = paste0("avg items per day each week ","(",weeks[1],"-",weeks[length(weeks)],")"),
                 xlab = "week",
                 ylab = "avg items per day"))
  
  print(barchart(salesPerDay~week | SKU, data = relevantData, 
                 panel = function(...){
                   panel.abline(h = seq(0, 1000, by = 100), col = "grey")
                   panel.barchart(...)
                   panel.lmline(..., col = 2)
                 },
                 main = paste0("avg sales per day each week ","(",weeks[1],"-",weeks[length(weeks)],")"),
                 xlab = "week",
                 ylab = "avg sales per day ($)"))
  par(mfrow = c(2,1))
  if(file.exists(dailyTotalsFile)){
    with(dailyTotals,
         plot(Date,
              Ordered.Product.Sales,
              type = "o", 
              ylab = "Ordered Product Sales ($)",
              main = "Sales Last 56 days"))
  } else{
    message(
      paste("could not find file",
            dailyTotalsFile,
            "for plot of daily sales. \n",
            dailyTotalsFile,
            "is the file name searched for by deafault. \n",
            "if you'd like to use a different file name, change the code in 'Read in daily totals.R'"))
  }
  with(weeklyTotals,
       plot(Week,
            Ordered.Product.Sales,
            type = "o",
            ylab = "Ordered Product Sales ($)",
            main = "Sales last 52 weeks"))
  dev.off()
  
  pastWeek = weeks[length(weeks)]
  pastWeekKpi = subset(relevantData, week == pastWeek)
  write.csv(x = pastWeekKpi, file = paste0("kpi7DaysWeek",pastWeek,".csv"))
  
  past14Days = weeks[c(length(weeks)-1, length(weeks))]
  past14DaysData = subset(relevantData, week == past14Days[1] | week == past14Days[2])
  past14DaysKpi = ddply(past14DaysData,
                        .var = .(SKU),
                        .fun = summarise,
                        Total.Order.Items = sum(Total.Order.Items),
                        Units.Ordered = sum(Units.Ordered),
                        Ordered.Product.Sales = sum(Ordered.Product.Sales),
                        itemsPerDay = Total.Order.Items/14,
                        salesPerDay = Ordered.Product.Sales/14,
                        week = paste0(unique(week), collapse = "-"))
  weekNames = paste0(past14Days, collapse = "-")
  write.csv(x = past14DaysKpi, file = paste0("kpi14DaysWeeks", weekNames, ".csv"))
  
  past28Days = weeks[(length(weeks)-3):length(weeks)]
  past28DaysData = subset(relevantData, 
                          week == past28Days[1] | 
                            week == past28Days[2] |
                            week == past28Days[3] |
                            week == past28Days[4])
  past28DaysKpi  = ddply(past28DaysData,
                         .var = .(SKU),
                         .fun = summarise,
                         Total.Order.Items = sum(Total.Order.Items),
                         Units.Ordered = sum(Units.Ordered),
                         Ordered.Product.Sales = sum(Ordered.Product.Sales),
                         itemsPerDay = Total.Order.Items/28,
                         salesPerDay = Ordered.Product.Sales/28,
                         week = paste0(unique(week), collapse = "-"))
  weekNames = paste0(past28Days, collapse = "-")
  write.csv(x = past28DaysKpi, file = paste0("kpi28DaysWeeks", weekNames, ".csv"))
  
  past56Days = weeks[(length(weeks)-7):length(weeks)]
  past56DaysData = subset(relevantData, 
                          week == past56Days[1] | 
                            week == past56Days[2] |
                            week == past56Days[3] |
                            week == past56Days[4] |
                            week == past56Days[5] |
                            week == past56Days[6] |
                            week == past56Days[7] |
                            week == past56Days[8])
  past56DaysKpi  = ddply(past56DaysData,
                         .var = .(SKU),
                         .fun = summarise,
                         Total.Order.Items = sum(Total.Order.Items),
                         Units.Ordered = sum(Units.Ordered),
                         Ordered.Product.Sales = sum(Ordered.Product.Sales),
                         itemsPerDay = Total.Order.Items/56,
                         salesPerDay = Ordered.Product.Sales/56,
                         week = paste0(unique(week), collapse = "-"))
  weekNames = paste0(past56Days, collapse = "-")
  write.csv(x = past56DaysKpi, file = paste0("kpi56DaysWeeks", weekNames, ".csv"))
  message(
"You have just saved a bunch of csv's to your working directory.
These report KPI's grouped by 7,14,28,&56 days. If you did not supply the function
with 8 consecutive weeks, these could be in error" )
}

# test 

weeklyKpi(16:23)

