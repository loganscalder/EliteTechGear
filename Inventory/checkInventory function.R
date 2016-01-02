# Inventory forecasting

# Output should be 
  # warnings for inventory that will last less than 90 days (13 weeks)
    # For those, estimates on how many days (or weeks) the inventory will last
  # warnings for inventory that we have too much of (26 weeks)
    # estimates for how many days of inventory we have? Not hard, right?
  # Shouldn't we also suggest how much should be shipped? Maybe that's for version two. 
    # how easy will this be??? I would think pretty easy actually? But I will need to 
    # talk with mitch
  

# The process of using the function could be this:
  # put old data in separate folder
  # download new data (weekly order counts for each SKU and most recent inventory status)
    # There should be several files for the weekly SKU order counts and only one file for the most recent inventory
    # these files should be in the same folder as the r code.
  # use checkInventory() to check inventory
    # input the optional names of the weeks
    # input the optional factor for over or underestimation

# Testing
  source("getUrls function.R")
  source("slashToDash.R")
  weeks = slashToDash(FromDate)

checkInventory = function(weeks = "allInDirectory", 
                          over.underEstimation = 0
                          ){
  source("checkInventory internal functions.R")
  require(plyr)
  
    # find order files and Source the data 
  availableFiles = list.files(pattern = "^skuOrders")
  if(weeks == "allInDirectory"){
      # files of weekly SKU orders should start with "skuOrders"
    skuOrdersFiles = availableFiles 
  } else{
    skuOrderFiles = paste0("skuOrders", weeks, ".csv")
  }
  
    #Read in
  skuOrders = mapply(FUN = readWithDate, 
                     file = skuOrderFiles,
                     week = weeks,
                     # MoreArgs = list(characterAsStings = F),  
                     # I thought I would need the above to allow a clean rbind. 
                     # I thought rbind on different sets of factors would mess things up
                     # I was wrong... when do restrictions on factors come into play?
                     SIMPLIFY = F,
                     USE.NAMES = F
  )
    #Bind weekly orders
  skuOrders = do.call(what = rbind, skuOrders)
  skuOrders = mutate(skuOrders, 
                     Units.Ordered = 
                       as.numeric(
                         gsub(pattern = "([$%,])", rep = "", x = Units.Ordered)))
  summary(skuOrders)
  message(paste0("\nfiles \n", 
                 paste(skuOrderFiles, collapse = "\n"), 
                 "\nwill be used to predict future orders.",
                 "\nRevise your function inputs or file names if this doesn't look correct"))
  
    # find inventory, check
  inventoryFile = list.files(pattern = "^InventoryInStockReport") # the default name given by amazon
  if(length(inventoryFile) == 1){
  message(paste0("\nCheck: \nfile \n ",
                 inventoryFile,
                 "\nwill be used as a measure of current inventory"))
  currentInventory = subset(read.csv(inventoryFile), select = c("SKU", "Current.Inventory"))
  currentInventory$Current.Inventory = 
    as.numeric(
      gsub(pattern = "([$%,])", rep = "", x = currentInventory$Current.Inventory)
    )
  } else if(length(inventoryFile) ==0){
  stop(paste0("\nIt looks like you don't have inventory data in the working directory.\n",
              "The working directory is ", 
              getwd(),
              "\nPlease download current inventory from 'https://sellercentral.amazon.com/hz/sellingcoach/inventory'
              and save the file as something that starts with 'InventoryInStockReport'.")
  )
  }else 
    stop(paste0("\n  It looks like you have more than one file of inventory data in the working directory. \n",
                "I'm only a machine and can't decide which to choose.\n",
                "I see \n ", paste(inventoryFile, collapse = "\n "),
                "\nWill you remove the extra files and try rerunning the function again?"))
  
   # find outliers
  head(skuOrders)
  b = boxplot(Units.Ordered ~ SKU, skuOrders, varwidth = T)
  outies = 
    data.frame(outlier = b$out,  
               SKU = b$names[b$group], 
               lowerWhisker = b$stats[1, b$group],
               uppperWhisker = b$stats[5, b$group],
               sampleSize = b$n[b$group]
    )
  outies
  outiesAndDates = merge(outies, skuOrders, 
                         by.x = c("outlier", "SKU"), 
                         by.y = c("Units.Ordered", "SKU"),
                         all.x = T,
                         suffixes = c("", ""))
  names(outiesAndDates) = c("outlier", "SKU", "lowerWhisker", "upperWhisker",
                            "sampleSize", "weekOfOutlier")
  outiesAndDates = mutate(outiesAndDates, dateOfDocumentation = Sys.Date())
  rm(outies)
    # remove outliers
  skuOrders = #skuOrders 
    merge(skuOrders, outiesAndDates[c("outlier", "SKU", "weekOfOutlier")],
          by.x = c("weekOf", "SKU"),
          by.y = c("weekOfOutlier", "SKU"), 
          all.x = T,
          suffixes = c("", "")
          )
  skuOrders = mutate(skuOrders, outlier = !is.na(outlier))
  head(skuOrders)
  # Make predictions: max(lm(data), max(data))
    
  library(nlme)
  trimmedOrders = skuOrders[!skuOrders$outlier,]
  X = lmList(Units.Ordered ~ weekOf | SKU, skuOrders[!skuOrders$outlier,])
  # find date of inventory
  inventoryDate = 
    as.Date(
      substr(inventoryFile, start = 30, sto = 40),
      format = "%d-%m-%Y")
  datesOfNext13Weeks = 
    inventoryDate + seq(fro = 0, to = 84, by = 7)
  
  weeklyForecast= 
    predict(X, 
            data.frame(weekOf = datesOfNext13Weeks), 
            asList = T)
  next90days = sapply(weeklyForecast,sum)
  next90days = data.frame(SKU = names(next90days), ordersInNext90 = next90days,
                          row.names = NULL)
  invAndForecast = 
    merge(currentInventory, next90days, by = "SKU", suff = c("", ""))
  ggplot(trimmedOrders) + 
    geom_point(aes(x = weekOf, y = Units.Ordered)) + 
    facet_wrap(~SKU) + theme(axis.text.x = element_text( angle = -60, hjust = 0))
  
  library(lattice)
  xyplot(Units.Ordered ~ weekOf | SKU, 
         data = trimmedOrders,
         type = c("p", "r"))
  
}
  
  
  