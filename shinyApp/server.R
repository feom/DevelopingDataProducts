# server.R

source("helpers.R")

shinyServer(function(input, output) {
  
  dataInput <- eventReactive(input$loadTimeSeriesButton, {
    getSymbolTimeSeries(input$symb, input$dates[1], input$dates[2])
  })
  
  predResult <- eventReactive(input$predictTimeSeriesButton, {
    trData <- createFeatureData(input$symb, input$dates[1], input$dates[2])
    res <- trainAndPredict(trData)
    res
  })
  
  output$plot <- renderPlot({    
    chartSeries(dataInput(), theme = chartTheme("white"), 
                type = "candlesticks", log.scale = FALSE, TA = NULL)
  })
  
  output$resultTable <- renderDataTable({
    predResult()
  })
  
})
