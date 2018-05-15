library(shiny)


ui <- shinyUI(fluidPage(
  titlePanel("Time series"),
  
  fluidRow(
    column(width = 3,
           helpText("Select a pollutant"),
           selectInput("pollutant", label = "Pollutant",
                       choices = parameters$param_Form, selected = 1)
    ),
    
    column(width = 3,
           helpText("Select a pollutant"),
           selectInput("weather", label = "Weather",
                       choices = colnames(weather), selected = "wind_avg_speed")
    )
    
  ),
  
  dygraphOutput("timeseries2", width = "100%", height = 700)
)
)

server <- shinyServer(function(input,output) {
  output$timeseries2 = renderDygraph({
    
    library(dygraphs)
    library(tidyverse)
    library(lubridate)
    
    ts2 <- daily_data_pp
    ts2 <- ts2[complete.cases(ts2), ]
    
    ts2 <- subset(ts2, , c("ob_date", input$pollutant,input$weather))
    
    dygraph(ts2) %>% 
      dyAxis("y") %>%
      dyAxis('y2') %>%
      dySeries(input$pollutant, axis = "y", label = input$pollutant)  %>%
      dySeries(input$weather, axis = "y2", label = input$weather)  %>%
      dyOptions(stackedGraph = TRUE) %>% 
      dyRangeSelector() 
    
  })
})

# Run the application 
shinyApp(ui = ui, server = server)