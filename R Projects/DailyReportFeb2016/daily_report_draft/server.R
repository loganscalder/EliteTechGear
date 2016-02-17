# Daily Report Draft

# Packages
require(ggplot2)


require(ggvis)
require(shiny)

# Read in and pre-process data
bsr = read.csv("/Users/loganscalder/Google Drive/EliteTechGear/Data/SKU Performance/DailySKUBSR.csv",
               colClasses = c("character", "character", "numeric"))
bsr = bsr %>% 
    mutate(
        Date = as.Date(Date, format = "%d/%m/%y")
    )

# shinyServer
shinyServer(function(input, output){
    
    output$fileFrame <- renderPrint(input$bsrFiles)
    
    bsrVis <-
        reactive({
            bsr %>%
                mutate(SKU = as.factor(SKU)) %>%
                ggvis(~Date, ~BSR) %>%
                group_by(SKU) %>%
                layer_paths(stroke = ~SKU)
                })
    bsrVis %>% bind_shiny("bsrTimePlot")
        
    
    
})

