
## Load data charging stations
charging_stations <- data.table::fread("./data/charging_stations.csv",
                                      header = TRUE,
                                      sep = ",")

parking_aggregated_ev <- data.table::fread("./data/parking_aggregated_ev.csv",
                                       header = TRUE,
                                       sep = ",")

# Reminder: latitude is about north and south! That's what we need to filter out England
minimumlatitude <- min(parking_aggregated_ev$latitude)
minimumlatitude <- as.numeric(floor(minimumlatitude))


# Take only latitude above a certain level
# We do this because we don't have any parking data below this point anyways
charging_stations_Scotland <- charging_stations[charging_stations$latitude >= minimumlatitude]

# write to csv
data.table::fwrite(charging_stations_Scotland,
                   "./data/charging_stations_Scotland.csv",
                   row.names = FALSE,
                   quote = FALSE)
