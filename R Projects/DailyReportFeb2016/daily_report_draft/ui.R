# Daily Report Draft
shinyUI(fluidPage(
    titlePanel("ETG DailyReport"),
    
    tabsetPanel(
        tabPanel("Welcome"),
        
        tabPanel("BSR",
            fluidPage(
                sidebarLayout(
                    sidebarPanel(
                        h3("Upload your data"),
                        fileInput("bsrFile", "Upload BSR file"),
                        verbatimTextOutput("bsrFileLook"),
                        helpText("Help Text"),
                        
                        h3("Filter your data"),
                        dateRangeInput("bsrDates", "Choose your date range",
                            start = Sys.Date() - 365,
                            end = Sys.Date())#,
                        #selectInput("bsrSkus", label = "Choose your SKU's")
                        
                    ),
                    
                    mainPanel(
                        tabsetPanel(
                            tabPanel("Uploaded Data",
                                dataTableOutput("bsrTable"),
                                p()
                                ),
                            
                            tabPanel("Data Visual",
                                ggvisOutput("bsrVis"))
                        )
                    )
                )
            ))
    )
))


# There are several fishy things I see happening with shiny here.
# Is there something I can do to keep myself more sure and organized?
# I guess when I see a problem that I don't expect, I should make
# simple examples, in another document that will let me test things
# out. 
# One fishy thing I consider a problem with this preview version
# of RStudio: it appears that packages aren't being loaded when I
# run shiny. I kept receiving the error that ggvisOutput() could not
# be found. I then loaded the package in my console, re ran the app, and
# everything worked fine. 
# On the testing docket: 
# test packages being loaded.
# Downloading file, 
# uploading and processing a file.