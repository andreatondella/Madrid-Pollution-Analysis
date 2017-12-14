# MBDO2-2
# R Group Assignment
# ===================================================

# Exploring the datasets

# ===================================================

#Loading libraries
source("lib_loading.R")

# ===================================================

# List of unique stations/parameters
stationlist <- unique(h_data$station)
paramlist <- unique(h_data$parameter)

# ===================================================

# Parameter per station
for(x in stationlist) {
  print(x)
  print(h_data[station == x, unique(parameter)])
}

#hello

#hi