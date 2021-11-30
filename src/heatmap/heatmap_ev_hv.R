library(dplyr)

# Settings
parking_zones_file <- "./data/parking_aggregated_ev_hv.csv"
charging_stations_file <- "./data/charging_stations_Scotland.csv"

parking_zones_size_factor <- 1000
colors_parking <- RColorBrewer::brewer.pal(9, "Greens")
colors_parking <- colors_parking[6:9]
parking_zones_color_map <- "#006D2C"
parking_zones_color_bins <- 1
parking_zones_opacity <- 0.5

charging_stations_size_factor <- 50
colors_charging <- RColorBrewer::brewer.pal(6, "Blues") #YlOrBr
colors_charging <- colors_charging[3:6]
charging_stations_color_map <- colors_charging
charging_stations_color_bins <- 4
charging_stations_opacity <- 0.5

map_latitude <- 57
# 54.2086818
map_longitude <- -2.751867
map_zoom <- 7

# Create ui
ui <- shiny::fillPage(
  padding = 0,
  title = "Parking Sessions UK",
  
  # Create map
  leaflet::leafletOutput("map", width="100%", height="100%"),
)

# Create server
server <- function(input, output) {
  # Import parking zones data
  parking_zones <- data.table::fread(parking_zones_file,
                                     header = TRUE,
                                     sep = ",")
  parking_zones$longitude <- as.numeric(parking_zones$longitude)
  parking_zones$latitude <- as.numeric(parking_zones$latitude)
  
  # Import charging stations data
  charging_stations <- data.table::fread(charging_stations_file,
                                         header = TRUE,
                                         sep = ",")
  charging_stations$longitude <- as.numeric(charging_stations$longitude)
  charging_stations$latitude <- as.numeric(charging_stations$latitude)
  
  # Create parking zones size map
  parking_zones_size <- parking_zones$session_count / max(parking_zones$session_count) * parking_zones_size_factor
  
  # Create parking zones color map
  # parking_zones_color <- parking_zones[["session_average"]]
  # parking_zones_palette <- leaflet::colorBin(parking_zones_color_map,
  #                                            parking_zones_color,
  #                                            parking_zones_color_bins,
  #                                            pretty = TRUE)
  
  # Create charging stations color map
  charging_stations_color <- unique(charging_stations[["connectorcount"]])
  charging_stations_palette <- leaflet::colorFactor(charging_stations_color_map,
                                                    charging_stations_color)
  
  # Create map
  output$map <- leaflet::renderLeaflet({
    leaflet::leaflet(parking_zones, charging_stations) %>%
      leaflet::addTiles() %>%
      
      # Add parking zones layer
      leaflet::addCircles(lng = parking_zones$longitude,
                          lat = parking_zones$latitude,
                          radius = parking_zones_size,
                          stroke = FALSE,
                          fillOpacity = parking_zones_opacity,
                          fillColor = "#006D2C") %>% #parking_zones_palette(parking_zones_color))
      
      # # Add parking zones legend
      # leaflet::addLegend("bottomleft",
      #                    pal = parking_zones_palette,
      #                    values = parking_zones_color,
      #                    opacity = 1.0,
      #                    title="Session Duration (Average)") %>%
      
      # Add charging stations layer
      leaflet::addCircles(lng = charging_stations$longitude,
                          lat = charging_stations$latitude,
                          radius = charging_stations_size_factor,
                          stroke = FALSE,
                          fillOpacity = charging_stations_opacity,
                          fillColor = charging_stations_palette(charging_stations_color)) %>%
      
      # Add charging stations legend
      leaflet::addLegend("bottomright",
                         pal = charging_stations_palette,
                         values = charging_stations_color,
                         opacity = 1.0,
                         title="Connector Count") %>%
      
      # Set base view
      leaflet::setView(lng = map_longitude, lat = map_latitude, zoom = map_zoom)
  })
}

# Run app
shiny::shinyApp(ui = ui, server = server)
