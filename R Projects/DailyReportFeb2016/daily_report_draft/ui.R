# Daily Report Draft
shinyUI(fluidPage(
    titlePanel("ETG Daily Report"),
    tabsetPanel(
        tabPanel("Welcome",
                 sidebarLayout(
                     sidebarPanel(h5("Left"),
                                  p("The tabs above will let you navigate
                                    to different parts of your daily report."),
                                  p("On the left of each page of the report will be parameters
                                    that you can control (dates and products
                                    to look at, etc.)"),
                                  p("On the right will be the graphical reports")),
                     mainPanel(h2("Right"),
                               p("If needed, there can be tabs underneath each
                                 page in the report"),
                               tabsetPanel(
                                   tabPanel("tab1",
                                            p("One thing to look at")),
                                   tabPanel("tab2",
                                            p("Another thing to look at"))
                         )
                     )
                 )),
        tabPanel("Advertising"),
        tabPanel("Pretend BSR",
                 sidebarLayout(
                     
                     sidebarPanel(
                         h3("Upload your file"),
                         p(em('The file here should be a csv
                                  with headings in the first row, data in 
                                  the rows that follow, and nothing else.
                                  The headings should at least include'),
                           strong("Date", "SKU"), em("and"), strong("BSR")),
                         fileInput("bsrFiles", label = "Upload your BSR file",
                                   multiple = F),
                         helpText("and a looky-loo into the file upload"),
                         verbatimTextOutput("fileFrame"),
                         
                         h3("Control yourself"),
                         dateRangeInput("bsrDate", "Choose your date range",
                                        start = min(bsr$Date),
                                        end = max(bsr$Date)),
                         helpText("Let me know what format you'd like to enter
                                  your date"),
                         
                         dateRangeInput("bsrDateExclude1", 
                                   "Choose date ranges to exclude",
                                   start = "1993-08-09",
                                   end = "1993-08-09"
                         ),
                         dateRangeInput("bsrDateExclude2",
                                        label = NULL,
                                        start = "1993-08-09",
                                        end = "1993-08-09"
                         ),
                         
                         selectInput("bsrSkus", 
                                     "Choose the products you want to see",
                                     choices = c(`All Products` = T,
                                                 "ETG-123-ABC",
                                                 "ETG-456-DEF"),
                                     selected = T,
                                     multiple = T)
                     ),
                     mainPanel(
                         h3("Graphics here"),
                         #ggvisOutput("bsrTimePlot"),
                         ggvisOutput(plot_id = "bsrTimePlot")
                     )
                 )),
        tabPanel("Sales and Such",
                 fluidRow(
                     column(3,
                            h3("Upload your files"),
                            helpText("This will likely be several files tracking
                                 daily sales and units ordered per sku. More
                                 details coming..."),
                            fileInput("salesFiles", label = "upload your file",
                                      multiple = T)
                     ),
                     column(9,
                            h3("See your stuff"),
                            ggvisOutput("bsrTimePlot"))
                 
                 
                 ),
                 fluidRow(
                     
                        h3("Control yourself"),
                        column(3,
                        dateRangeInput("salesDates", "Choose your date range",
                                       start = min(bsr$Date),
                                       end = max(bsr$Date)),
                        dateInput("salesDateExclude", 
                                  "Choose any dates to exclude",
                                  value = "1993-08-09"
                        )),
                        column(4,
                        selectInput("bsrSkus", 
                                    "Choose the products you want to see",
                                    choices = c(`All Products` = T,
                                                "ETG-123-ABC",
                                                "ETG-456-DEF"),
                                    selected = T,
                                    multiple = T)
                 ))),
        tabPanel("Inventory")
    )
    
))