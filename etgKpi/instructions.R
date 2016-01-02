##### Follow this procedure to compare weekly kpi's
# Writen by Logan Calder for use by his brother Mitchell
# May 16, 2015 Salt Lake City, Utah

###Summary###
# This document details a procedure that will allow you to examine and 
# document your kpi's as I've demonstrated to you.  The key things to 
# to remember are these:  
#   names of raw data files need to fit the specified format
#   data files should be in your working directory 
#     or preferably in the same folder as the R project.
#   processed data and charts will be saved in that same
#     directory
  

# Download as csv files the data for the weeks you want to anlyze.  
#  The first part of the file names should all be 
#  "salesByAsinWeek"
#   the second parts of the file names should be something that uniquely 
#   describes the week for each file.  
#   Ex:  "salesByAsinWeek12.csv"  for data on the 12th week of the year
#     (Keep the last part short. That last part of the name will be 
#       used to label the charts and datatables)

# Move the files
#  by default the files should be located in the same folder as the R code.
#  do not attempt to change the name of the folder.  If you'd like things to 
#  be organized a little differently, I can help with that.

# Define your weeks. 
# These should match the last part of the file names described above.
 
  # ex:   evenWeeks = c(2,4,6)
  # or    recentWeeks = 12:18   # for all weeks between and including 12 through 18
  # or    namedWeeks = c("something", "else") if you chose to name  your weekly 
  #         files with something else. Quotation marks needed for lettered names.
  
  
# load the latest weeklyKpi function
source(weeklyKpiFunction.R)

# run the function 
#  The function currently has two inputs:  weeks and fileName
#   The function has a default file name,
#   so only the weeks input is mandatory
# Ex: weeklyKpi(weeks = recentWeeks)
# Or: weeklyKpi(weeks = recentWeeks, fileName = "somethingElse" )



# OUTPUT VALUES
# Currently the function saves a 5 page pdf of kpi's for every product 
# The function will also save csv's of the computed kpi's
#  kpi's will be given for each week, 2 weeks, 4 weeks, and 8 weeks
#  or as othewise desired.  
# By Default, the kpi pdf is saved as 'kpiWeeks__-__.pdf' filled in
# with the names of the first and last supplied week. 
# The files will be saved to the same folder that supplies the data.

# Feedback
#  Your feedback is very important to me.  I hope to make a product 
#  that is informative, user friendly, and flexible to your needs and 
#  interests.  
#  I also know that timely information is important for a business.  If 
#  something doesn't appear to be correct or if you need instrucion,
#  I will sacrifice even my own sleep to address the issue.
  
