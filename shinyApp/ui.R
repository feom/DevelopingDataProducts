library(shiny)

shinyUI(fluidPage(
  titlePanel("Stock Visualization & Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Enter a Yahoo symbol (e.g. GS) with a date range for chart visualization and/or prediction."),
      
      textInput("symb", "Yahoo Symbol", "GS"),
      
      dateRangeInput("dates", 
                     "Date Range",
                     start = "2013-12-31", 
                     end = as.character(Sys.Date())),
      
      br(),
      
      actionButton("loadTimeSeriesButton", "Show Chart"),
      br(),
      br(),
      actionButton("predictTimeSeriesButton", "Predict Direction")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Chart", plotOutput("plot")),
        tabPanel("Prediction Results", dataTableOutput(outputId="resultTable")),
        tabPanel("Documentation",
                 h3("Getting Started"),
                 helpText("This shiny application has two features:"),
                 tags$div(
                   tags$ul(
                     tags$li("Stock Visualization:"),
                     tags$ul(
                       tags$li("Show a candlestick chart for a quote time series of an input Yahoo symbol and an input date range (from/to date)."),
                       tags$br(),
                       tags$li("Enter a valid Yahoo symbol, e.g. GS (Goldman Sachs) into the text box."),
                       tags$li("Choose the from/to date range for which the data should be displayed."),
                       tags$li("Press the Show Chart Button."),
                       tags$li("The candlestick chart for the Yahoo symbol is displayed on the Chart tab panel."),
                       tags$br()
                     ),
                     tags$li("Stock Prediction:"),
                     tags$ul(
                       tags$li("Predict the stock direction (up/down) by using a random forest classification model."),
                       tags$li("The symbol time series is partitioned into a training (75%) and testing data set (25%)."),
                       tags$li("The model uses the technical indicators (RSI, SMA, MACD) as classification features."),
                       tags$li("For the RSI, SMA the parameter number of periods (days) is set to five."),
                       tags$li("For the MACD, the standard configuration fast = 12, slow = 26, signal = 9 periods is used."),
                       tags$li("The model variable to be predicted is the binary variable direction (up/down) that is defined as the delta between the opening and closing price of the symbol."),
                       tags$li("The results for the model applied to the testing data set are displayed in a data table."),
                       tags$br(),
                       tags$li("Enter a valid Yahoo symbol, e.g. GS (Goldman Sachs) into the text box."),
                       tags$li("Choose the from/to date range for which the data should be displayed."),
                       tags$li("Press the Predict Direction Button."),
                       tags$li("The results are shown on the Prediction Results tab panel."),
                       tags$li("The data table shows the quote date, the technical indicators (RSI, SMA, MACD) used as classification features, the given direction from the testing data set and the resulting predicted direction.")
                     )
                     
                   )
                 ),
                 h3("Disclaimer"),
                 helpText("This prediction strategy is not intended to be used for real trading. The author is not liable for any harm - usage at your own risk.")
        ),
        selected="Documentation"
      )
    )
    
  )
))