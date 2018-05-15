library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("Pollution heatmap"),
  
  fluidRow(
    column(width = 3,
           helpText("Select a pollutant"),
           selectInput("pollutant", label = "Pollutant",
                       choices = parameters$param_Form, selected = 1)
    ),
    #column(width = 1),
    column(width = 3,
           helpText("Select a station"),
           selectInput("station", label = "Station",
                       choices = stations$station_Name, selected = 28079004)
    ),
    column(width = 3,
           helpText("Select a year"),
           selectInput("year", label = "Year",
                       choices = unique(h_data$year), 
                       selected = 2011)
    )
    
  ),
  
  plotOutput("heatmap", width = "100%", height = 700)
)
)

server <- shinyServer(function(input,output) {
  output$heatmap = renderPlot({
    
    library(ggplot2)
    library(dplyr) # easier data wrangling 
    library(viridis) # colour blind friendly palette, works in B&W also
    library(Interpol.T) #  will generate a large dataset on initial load
    library(lubridate) # for easy date manipulation
    library(ggExtra) # because remembering ggplot theme options is beyond me
    library(tidyr) 
    
    df <- subset(h_data, year == input$year & station_Name == input$station & param_Form == input$pollutant, c("day", "month", "year", "hour", "value"))
    df$day <- as.numeric(df$day)
    df$hour <- as.numeric(df$hour)
    df$month <- as.numeric(df$month)
    df$year <- as.numeric(df$year)
    df$value <- as.numeric(df$value)
    plot(ggplot(df,aes(day,hour,fill=as.numeric(value))) + geom_tile(color= "white",size=0.1) 
         + scale_fill_viridis_c(name="Hourly Value (microg/m^3)  ",option ="C")
         + facet_grid(year~month)
         + scale_y_continuous(trans = "reverse", breaks = unique(df$hour))
         + scale_x_continuous(breaks =c(1,10,20,31))
         + theme_minimal(base_size = 8)
         + labs(title= paste("Hourly Pollution values - Station", input$station), x="Day", y="Hour")
         + theme(legend.position = "bottom")+
           theme(plot.title=element_text(size = 14))+
           theme(axis.text.y=element_text(size=6)) +
           theme(strip.background = element_rect(colour="white"))+
           theme(plot.title=element_text(hjust=0))+
           theme(axis.ticks=element_blank())+
           theme(axis.text=element_text(size=7))+
           theme(legend.title=element_text(size=8))+
           theme(legend.text=element_text(size=6))+
           removeGrid())
    
  })
})

# Run the application 
shinyApp(ui = ui, server = server)