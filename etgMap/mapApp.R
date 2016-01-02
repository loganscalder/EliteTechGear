library(shiny)

ui <- fluidPage(
  load("processedShipmentData.RData"),
  dateRangeInput(inputId = "date_range", 
                 label = "Choose date range", 
                 min = "2015-05-01", 
                 max = "2015-09-30"  ),
  plotOutput(outputId = "plot", click = "plot_click", dblclick = "dbl"),
  dataTableOutput(outputId = "table")
  )

server<- function(input, output){
  require(maps)
  
  output$plot <- renderPlot({
    map("usa")
    load("processedShipmentData.RData")
    with(subset(processed.shipment.data,
                subset = as.Date(shipment.date) >= min(input$date_range) & 
                  as.Date(shipment.date) <= max(input$date_range)),
         points(longitude, latitude, pch = 16, col = rgb(0,0,1,.1), cex = .5))
  })
  
  output$table <- renderDataTable({
    subset(processed.shipment.data,
           subset = shipment.date >= min(input$date_range) & 
             shipment.date <= max(input$date_range))})
  
}

shinyApp(ui = ui, server = server)

