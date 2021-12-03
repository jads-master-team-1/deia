library(dplyr)

# Operators
`%!in%` <- Negate(`%in%`)

# Settings
parking_zones_file <- "./data/parking_aggregated_ev.csv"
charging_stations_government_file <- "./data/charging_stations_government_scotland.csv"
charging_stations_openchargemap_file <- "./data/charging_stations_openchargemap_scotland.csv"
charging_stations_coordinate_precision <- 4 # gov -> lat: 5.78, long: 5.77 ocm -> lat: 6.85, long: 7.34 

parking_zones_size_factor <- 1000
parking_zones_color <- "#006D2C"
parking_zones_opacity <- 0.5

charging_stations_size_factor <- 50
charging_stations_color_map <- RColorBrewer::brewer.pal(8, "Blues")
charging_stations_opacity <- 0.5

map_latitude <- 57
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
  charging_stations_government <- data.table::fread(charging_stations_government_file,
                                                    header = TRUE,
                                                    sep = ",")
  charging_stations_government$longitude <- as.numeric(charging_stations_government$longitude)
  charging_stations_government$latitude <- as.numeric(charging_stations_government$latitude)
  charging_stations_government$source <- "GOVERNMENT"
  
  charging_stations_openchargemap <- data.table::fread(charging_stations_openchargemap_file,
                                                       header = TRUE,
                                                       sep = ",")
  charging_stations_openchargemap$longitude <- as.numeric(charging_stations_openchargemap$longitude)
  charging_stations_openchargemap$latitude <- as.numeric(charging_stations_openchargemap$latitude)
  charging_stations_openchargemap$source <- "OPENCHARGEMAP"
  
  # Discard duplicate charging stations data
  charging_stations_government <- charging_stations_government[round(charging_stations_government$latitude,
                                                                     digits = charging_stations_coordinate_precision) %!in% round(charging_stations_openchargemap$latitude,
                                                                                                                                  digits = charging_stations_coordinate_precision) &
                                                               round(charging_stations_government$longitude,
                                                                     digits = charging_stations_coordinate_precision) %!in% round(charging_stations_openchargemap$longitude,
                                                                                                                                  digits = charging_stations_coordinate_precision)]
  
  # Merge charging stations data
  charging_stations <- rbind(charging_stations_government, charging_stations_openchargemap)

  # Create parking zones size map
  parking_zones_size <- parking_zones$session_count / max(parking_zones$session_count) * parking_zones_size_factor

  # Create charging stations color map
  charging_stations_color <- unique(charging_stations[["connectorcount"]])
  charging_stations_palette <- leaflet::colorFactor(charging_stations_color_map,
                                                    charging_stations_color)
  
  # Log settings
  cat(paste("[INFO] Showing Map -",
            "LAT:",
            map_latitude,
            "-",
            "LONG:",
            map_longitude,
            "-",
            "ZOOM:",
            map_zoom,
            "\n"))
  cat(paste("[INFO] Showing Parking Zones -",
            "PN (1259):",
            nrow(parking_zones),
            "\n"))
  cat(paste("[INFO] Showing Charging Stations -",
            "GOV (1122):",
            nrow(charging_stations_government),
            "-",
            "OCM (1453):",
            nrow(charging_stations_openchargemap),
            "-",
            "TOT (2575):",
            nrow(charging_stations),
            "-",
            "PRC:",
            charging_stations_coordinate_precision,
            "\n"))

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
                          fillColor = parking_zones_color,
                          popup = paste0("<b>",
                                         "Zone ID: ",
                                         htmltools::htmlEscape(parking_zones$zoneid),
                                         "</b>",
                                         "<br/>",
                                         "Session Count: ",
                                         parking_zones$session_count,
                                         "<br/>",
                                         "Session Average: ",
                                         round(parking_zones$session_average, digits = 2),
                                         " minutes")) %>%
      
      # Add charging stations layer
      leaflet::addCircles(lng = charging_stations$longitude,
                          lat = charging_stations$latitude,
                          radius = charging_stations_size_factor,
                          stroke = FALSE,
                          fillOpacity = charging_stations_opacity,
                          fillColor = charging_stations_palette(charging_stations_color),
                          popup = paste0("<b>",
                                         "Name: ",
                                         htmltools::htmlEscape(charging_stations$name),
                                         "</b>",
                                         "<br/>",
                                         "Location: ",
                                         charging_stations$town,
                                         "<br/>",
                                         "Connector Status: ",
                                         charging_stations$chargedevicestatus,
                                         "<br/>",
                                         "Connector Count: ",
                                         charging_stations$connectorcount,
                                         "<br/>",
                                         "Source: ",
                                         charging_stations$source)) %>%
      
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
