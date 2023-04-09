library(tidyverse)
library(sf)     # R wrapper around GDAL/OGR
library(leaflet)    # for fortifying shapefiles
library(leaflet.extras)   # For leaflet heatmaps


mn_1937 <- st_read(dsn = "MNMinneapolis1937/", layer = "cartodb-query")

glimpse(mn_1937)

# Now make the leaflet map!
mn_1937 |> 
  leaflet() |> 
  addTiles() |> 
  addPolygons(weight = 1,
              color = "white",
              fillColor = ~holc_grade,
              fillOpacity = 0.3,
              popup = ~holc_id)


# Define your factors of the different colors
neighbor_pal <-colorFactor(palette = "YlGnBu", 
                           domain = c("A","B","C","D")
)

# Now we add in the code
mn_map <- mn_1937 |> 
  leaflet() |> 
  addTiles() |> 
  addPolygons(weight = 1,
              color = "white",
              fillColor = ~neighbor_pal(holc_grade),
              fillOpacity = 0.6,
              popup = ~holc_id) |>
  addLegend(title = "Neighborhood Rating",
            pal = neighbor_pal,
            values = ~holc_grade,
            opacity = 0.6)

mn_map


# Read in the parks data
mn_parks <- st_read(dsn = "Parks-shp/", layer = "Parks")

# Helpful just to see what the data frame contains
glimpse(mn_parks)


# Now make the leaflet map!
mn_map |>
  addPolylines(data = mn_parks,
               weight = 2,
               color = "purple",
               fillColor = 'purple',
               opacity = 0.5) |>
  addPolygons()
  # addPolygons(weight=1,
  #             color = "red",
  #             fillColor = ~neighbor_pal(PARK_NAME1),
  #             fillOpacity=0.6,
  #             popup = ~PARK_NAME1)
