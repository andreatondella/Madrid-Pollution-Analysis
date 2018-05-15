library(dygraphs)
library(xts)          # To make the convertion data-frame / xts format
library(tidyverse)
library(lubridate)

#===================================================
ts <- daily_data_pp

ts <- ts[complete.cases(ts), ]

ts <- ts[ ,c("ob_date", "NO2","CO")]

map = dygraph(ts) %>% 
  dyAxis("y") %>%
  dyAxis('y2') %>%
  dySeries("NO2", axis = "y", label = "NO2")  %>%
  dySeries("CO", axis = "y2", label = "NO")  %>%
  dyOptions(stackedGraph = TRUE) %>% 
  dyRangeSelector() 
map

