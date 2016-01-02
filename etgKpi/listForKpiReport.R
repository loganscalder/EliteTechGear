# for testing:   rm(list = ls())  weeks = 16:23   fileName = paste0("kpiWeeks",weeks[1],"-", weeks[length(weeks)])

listForKpiReport = function(){
  # What will be the inputs for this function? To keep it as simple as possible,
  # just the weeks that we download the data for.
  
  # the output, we want
#   KPI's visualized for the top products
#   KPI's listed for the top products
#   KPI's visualized for the not top products
#   KPI's listed for the aggregate of not top products
#   Total company sales by day for bast 56 days
#   Total company sales by week for past 52 weeks
  #   Sales by week compared to YTD last year
#   Something for margins 
#   Something for inventory
  require(plyr)
  require(ggplot2)
  #===========================
  ### Load and Transform Data
  #===========================
  output = list()
  weeklyList = list()
  # list.files
  weeklyFiles = list.files(pattern = "^salesByAsinWeek")
  # substr out the weeks
  weeks = 
    mapply(FUN = substr,
           x = weeklyFiles,
           stop = nchar(weeklyFiles) - 4,
           MoreArgs = list(start = 16),
           SIMPLIFY = T,
           USE.NAMES = F)
  #prep weeklyList
  length(weeklyList) = length(weeks)
  names(weeklyList) = weeks
  
  for (i in 1:length(weeklyList)){
    # read in the files
    weeklyList[[i]] = read.csv(paste0("salesByAsinWeek",weeks[i],".csv"),
                               stringsAsFactors = F
                               )
    # select relevant columns
    weeklyList[[i]] <- subset(weeklyList[[i]],
                              select = c("SKU", "Units.Ordered", "Unit.Session.Percentage",
                                         "Ordered.Product.Sales", "Total.Order.Items"))
    # take out the lame symbols
    weeklyList[[i]] = 
      colwise(.fun = gsub, pattern = "([$%,])", replacement = "")(weeklyList[[i]])
   
    # make things numeric
    weeklyList[[i]] = 
      cbind(
        weeklyList[[i]][1],
        colwise(.fun = as.numeric)((weeklyList[[i]])[2:5])
      )
    
    # calculate additional kpi's and the week
    weeklyList[[i]] = 
      mutate(weeklyList[[i]],
             itemsPerDay = Units.Ordered/7,
             salesPerDay = Ordered.Product.Sales/7,
             week = as.Date(weeks[i])) 
  } 

  # lapply(weeklyList,head)
  
  #===========================
  ### Subset Data
  #===========================
  relevantList = 
    lapply(weeklyList, 
           FUN = subset,
           select = c("SKU", "Units.Ordered", "Ordered.Product.Sales",
                      "Total.Order.Items", "itemsPerDay", "salesPerDay", "week"))
  
  #lapply(relevantList, head)
  #s = lapply(relevantList, function(x){
  #summary(as.factor(x[,"SKU"]))  
  #})  # checking SKU's for repeats in each week
  
  # One data frame for all weeks
  relevantData = do.call(rbind, relevantList)
  rownames(relevantData) <- NULL
  
  #===================
  # Find total sales by sku
  #==================
  bySku = 
    ddply(relevantData,
          .var = "SKU",
          .fun = summarise,
          totalSales = sum(Ordered.Product.Sales))
  
  bySku = arrange(bySku, totalSales, decreasing = T) #order
  
  ## set sku levels by total sales over period
  rankedSku = bySku$SKU
  relevantData = transform(relevantData, 
                           SKU = factor(SKU, levels = rankedSku),
                           week = as.factor(week))
  ## set the top 20% and bottom 80
  top20 = rankedSku[1:(.2*length(rankedSku))]
  bottom80 = rankedSku[!(rankedSku %in% top20)]
  
  top20Data = with(relevantData,
                   relevantData[SKU %in% top20,])
  bottom80Data = with(relevantData,
                      relevantData[SKU %in% bottom80,])
  
  ## aggregate bottom 80 by week
  aggie80 = 
    ddply(bottom80Data,
          .fun = summarize,
          .var = "week",
          SKU = "Combo of Bottom 80",
          Total.Order.Items = sum(Total.Order.Items),
          Units.Ordered = sum(Units.Ordered),
          Ordered.Product.Sales = sum(Ordered.Product.Sales),
          itemsPerDay = sum(itemsPerDay),
          salesPerDay = sum(salesPerDay))
  
  # plot the top 20% and aggregate of bottom 80
  theme_update(
    axis.text.x = element_text(angle = -85))
  top20AndAggie80Data = rbind(top20Data, aggie80)
  top20.plot = ggplot(top20AndAggie80Data)
  sales.geom = geom_bar(aes(week, Ordered.Product.Sales), stat = "identity", fill = "dodgerblue1")
  items.geom = geom_bar(aes(week, Units.Ordered), stat = "identity", fill = "dodgerblue2")
  top20.sales = 
    top20.plot + 
    sales.geom + 
    facet_wrap(~SKU, ncol = 4)+
    ggtitle("Weekly Sales of top 20%")
  top20.items = 
    top20.plot+
    items.geom+
    facet_wrap(~SKU, ncol = 4)+
    ggtitle("Weekly Items of top 20%")
  output$topSales = top20.sales
  output$topItems = top20.items
  
  # plot the bottom 80%
  bottom80.plot = ggplot(bottom80Data)
  bottom80.sales = 
    bottom80.plot +
    sales.geom+
    facet_wrap(~SKU, ncol = 4)+
    ggtitle("Weekly Sales of bottom 80%")
  bottom80.items = 
    bottom80.plot +
    items.geom+
    facet_wrap(~SKU, ncol = 4)+
    ggtitle("Weekly Items of bottom 80%")
  output$bottomSales = bottom80.sales
  output$bottomItems = bottom80.items
#=========
#make tables
#=========

  
  # output weekly and daily totals (data frames...)
  source("Read in daily totals.R", local = T)
  source("Read in weekly totals.R", local = T)
  output$dailyTotals = dailyTotals
  output$weeklyTotals = weeklyTotals
  
  output
}
