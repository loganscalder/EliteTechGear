# Read in and apply week of date for weekly sku orders

readWithDate = function(file, weekOf,...){
  data.frame(read.csv(file, ...),
             weekOf = as.Date(weekOf, format = "%m-%d-%Y")
  )
}

addPositive = function(x) {
  # This will take vectors and add all the positive elements
  sum(x[x>0])
}
