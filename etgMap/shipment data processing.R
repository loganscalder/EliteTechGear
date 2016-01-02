shipments = read.csv("shipment_sales.csv")
head(shipments)
summary(shipments)

# clean up shipment.date
shipments$shipment.date = substr(as.character(shipments$shipment.date),
                                 start = 1,
                                 stop = 19)
shipments$shipment.date = as.POSIXct(shipments$shipment.date, 
                                     format = "%Y-%m-%dT%H:%M:%S",
                                     tz = "PST8PDT")
summary(shipments)
# trim zip codes
# erase dashes and everything before a dash
names(shipments)
longcodes = grep(shipments$ship.postal.code, 
                 pattern = "-",
                 value = F)
head(shipments$ship.postal.code[longcodes], 30)


# split the zip codes
# remove everything to the right of the dash (keep first element in each element of the list)
splitcodes <- strsplit(as.character(shipments$ship.postal.code), 
                       split = "-",
                       fixed = T)
maincodes <- sapply(splitcodes, `[`,1)
maincodes <- as.numeric(maincodes)
summary(maincodes)
length(maincodes)
library(stringr)
# polish zip code formatting, compare to zipcodes dataset
maincodes = 
  str_pad(string = maincodes,
          width = 5,
          pad = "0")
library(zipcode)
data(zipcode)
names(zipcode)
setdiff(maincodes, zipcode$zip)
# replace shipment.zip with formatted zipcodes 
data.frame(head(maincodes), head(shipments$ship.postal.code)) #double check
data.frame(tail(maincodes), tail(shipments$ship.postal.code)) # triple check
shipments$ship.postal.code <- maincodes

#attach lat and longitude to shipments
?merge
shipments = 
  merge(shipments,
        zipcode[,c("zip", "latitude", "longitude")],
        by.x = "ship.postal.code",
        by.y = "zip",
        all = F,
        suff = c("",""))

processed.shipment.data <- shipments
save("processed.shipment.data", file = "processedShipmentData.RData")
