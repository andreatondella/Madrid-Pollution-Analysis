# Library
library(leaflet)

# load example data (Fiji Earthquakes) + keep only 100 first lines
map_data = subset(daily_data_pp, ob_date == "2016-10-30", c("Lng", "Lat", "NO2", "temp_avg", "station_Name", "Alt", "Type"))
min_v <- min(map_data$NO2)
max_v <- max(map_data$NO2)

# Create a color palette with handmade bins.
mybins=seq(min_v, max_v, by=(max_v-min_v)/9)
mypalette = colorBin( palette="YlOrRd", domain=map_data$NO2, na.color="black", bins=mybins)

# Prepar the text for the tooltip:
mytext=paste("Station: ", map_data$station_Name, "<br/>", "Value: ", round(map_data$NO2, 1), "<br/>", "Temperature: ", map_data$temp_avg, "<br/>", "Altitude: ", map_data$Alt, "<br/>", "Station Type: ", map_data$Type, sep="") %>%
  lapply(htmltools::HTML)

# Final Map
style <- providers$Stamen.Toner
leaflet(map_data) %>%  
  
  addTiles() %>% 
  
  #clearBounds()
  fitBounds(map_data$Lng[22],map_data$Lat[22],map_data$Lng[8],map_data$Lat[5]) %>%
  addProviderTiles("Esri.WorldImagery") %>%
  addProviderTiles(providers$Esri.WorldGrayCanvas) %>% addProviderTiles(providers$Stamen.TonerLabels) %>%
  addProviderTiles(providers$Stamen.TonerLines,options = providerTileOptions(opacity = 0.35)) %>%
  addCircleMarkers(~Lng, ~Lat, 
                   fillColor = ~mypalette(NO2), fillOpacity = 0.7, color="white", radius=25, stroke=F,
                   label = mytext,
                   labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto")
  ) %>%
  addLegend( pal=mypalette, values=~NO2, opacity=0.9, title = "microg/m^3", position = "bottomright" )
