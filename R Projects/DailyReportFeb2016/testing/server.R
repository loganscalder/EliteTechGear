# testing server

############
# with tabs inside of tabs, file upload, download:
############
# shinyServer(function(input, output){
#     output$fileDownload <- downloadHandler(
#         "downloadTest",
#         content = 
#             function(file){
#                 write.csv(x = data.frame(week = c(1,2,3), 
#                                          measure = c(12,43,56)),
#                           file)
#             }
#         )
#     
# })


##############
# choices of selectInput coming from uploaded data
##############
# shinyServer(function(input,output){
#     bsrUpload <- reactive({
#         read.csv(input$file$datapath,
#                  stringsAsFactors = F) %>%
#             mutate(Date = as.Date(Date, format = "%d/%m/%y"))
#     })
#     
#     output$uploadTable <- renderDataTable({
#         bsrUpload()
#     })
#     
#     output$chooseSkus <- renderUI(
#         selectInput("chooseSkus",
#             "Choose Your Skus",
#             choices = c("All SKU's" = "blah", unique(bsrUpload()$SKU)))
#     )
#     
#     output$chosenSkus <- renderPrint(
#         match(bsrUpload()$SKU, input$chooseSkus, 
#               nomatch = 1) > 0)
#     
#     output$filteredData <- 
#         renderDataTable({
#             bsrUpload() %>%
#                 filter(
#                     match(as.character(SKU), as.character(input$chooseSkus), 
#                           nomatch = 1) > 0
#                 )
#         })
# })


#############
# Getting at the html behind ui inputs and panels... how to do that.
# I think some of the documentation on shiny's website would tell me.
#############
wellPanelBlue = function (...) 
{
    div(class = "well", style="color:blue;")
}

shinyServer(function(input,output){
    
})