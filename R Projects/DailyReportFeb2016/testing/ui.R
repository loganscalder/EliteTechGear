# testing ui


############
# with tabs inside of tabs, file upload, download:
############
# shinyUI(
#     fluidPage(
#         tabPanel("Test site 1",
#                  tabPanel("File Upload",
#                     fileInput("uploadTest", "Upload")),
#                  
#                  tabPanel("FileDownload",
#                     downloadLink("fileDownload"))
#         )
#     )
# )


##############
# choices of selectInput coming from uploaded data
#############
# shinyUI(
#     fluidPage(
#         sidebarLayout(
#             sidebarPanel(
#                 fileInput("file", label = "upload yer file"),
#                 # selectInput("bsrSkus", "Choose your SKU's",
#                 #     choices = "choices that come from file upload"),
#                 uiOutput("chooseSkus"),
#                 verbatimTextOutput("chosenSkus")
#             ),
#             
#             mainPanel(
#                 h3("Uploaded Data"),
#                 dataTableOutput("uploadTable"),
#                 br(),
#                 h3("Filtered Data"),
#                 dataTableOutput("filteredData")
#             )
#         )
#     )
# )


#############
# Getting at the html behind ui inputs and panels... how to do that.
# I think some of the documentation on shiny's website would tell me.
#############
shinyUI(fluidPage(
    sidebarLayout(
        HTML('<div class="well"></div>'),
        
        wellPanelBlue()
    )
))