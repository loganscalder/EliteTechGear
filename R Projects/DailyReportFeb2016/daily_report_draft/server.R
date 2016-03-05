# Daily Report Draft

# Packages
require(ggplot2)

require(xtable)
require(plyr)
require(dplyr)
require(ggvis)
require(shiny)

# Read in and pre-process data
# bsrEx = read.csv("/Users/loganscalder/Google Drive/EliteTechGear/Data/SKU Performance/DailySKUBSR.csv",
#                colClasses = c("character", "character", "numeric"))
# bsr = bsrEx %>%
#     mutate(
#         Date = as.Date(Date, format = "%d/%m/%y")
#     )

# shinyServer
shinyServer(function(input, output){
    
    output$bsrFileLook <- renderPrint({input$bsrFile})
    
    bsrUpload <- reactive({
        if(is.null(input$bsrFile)){
            read.csv("data examples/bsrExample.csv",
                stringsAsFactors = F)
        } else{
            read.csv(
                input$bsrFile$datapath,
                stringsAsFactors = F
                ) %>%
                # consider changing the way we store dates in the future
                mutate(Date = as.Date(Date, format = "%d/%m/%y")) #%>%
                # filter(Date >= min(input$bsrDates),
                #        Date <= max(input$bsrDates),
                #        match(SKU, ))
        }
    })
                 
    output$bsrTable <- renderDataTable({bsrUpload()})
    
    # bsrVis <- reactive{
    #     bsrUpload() %>%
    #         filter()
    # }
    


    # bsrVis <-
    #     reactive({
    #         bsr %>%
    #             mutate(SKU = as.factor(SKU)) %>%
    #             ggvis(~Date, ~BSR) %>%
    #             group_by(SKU) %>%
    #             layer_paths(stroke = ~SKU)
    #             })
    # bsrVis %>% bind_shiny("bsrTimePlot")
        
    
    
})

