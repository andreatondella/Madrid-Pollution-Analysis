library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("Time series"),
  
  fluidRow(
    column(width = 3,
           helpText("Select a pollutant"),
           selectInput("pollutant1", label = "Pollutant",
                       choices = parameters$param_Form, selected = 1)
    ),

    column(width = 3,
           helpText("Select a pollutant"),
           selectInput("pollutant2", label = "Pollutant",
                       choices = parameters$param_Form, selected = 1)
    )
    
  ),
  
  dygraphOutput("timeseries", width = "100%", height = 700)
)
)

server <- shinyServer(function(input,output) {
  output$timeseries = renderDygraph({
    
    library(dygraphs)
    library(tidyverse)
    library(lubridate)
    
    ts1 <- daily_data_pp
    
    ts1 <- ts1[complete.cases(ts1), ]
    
    ts1 <- subset(ts1, , c("ob_date", input$pollutant1,input$pollutant2))
    
    dygraph(ts1) %>% 
      dyAxis("y") %>%
      dyAxis('y2') %>%
      dySeries(input$pollutant1, axis = "y", label = input$pollutant1)  %>%
      dySeries(input$pollutant2, axis = "y2", label = input$pollutant2)  %>%
      dyOptions(stackedGraph = TRUE) %>% 
      dyRangeSelector() 

  })
})

# Run the application 
shinyApp(ui = ui, server = server)