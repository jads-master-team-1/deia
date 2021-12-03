# Filter Charging Stations Only Scotland

## Load data
charging_stations_government <- data.table::fread("./data/charging_stations_government.csv",
                                                  header = TRUE,
                                                  sep = ",")
charging_stations_openchargemap <- data.table::fread("./data/charging_stations_openchargemap.csv",
                                                     header = TRUE,
                                                     sep = ",")
parking_aggregated_ev <- data.table::fread("./data/parking_aggregated_ev.csv",
                                           header = TRUE,
                                           sep = ",")

# Reminder: latitude is about north and south! That's what we need to filter out England
minimum_latitude <- min(parking_aggregated_ev$latitude)
minimum_latitude <- as.numeric(floor(minimum_latitude))

# Take only latitude above a certain level
# We do this because we don't have any parking data below this point anyways
charging_stations_government_scotland <- charging_stations_government[charging_stations_government$latitude >= minimum_latitude]
charging_stations_openchargemap_scotland <- charging_stations_openchargemap[charging_stations_openchargemap$latitude >= minimum_latitude]

# Write data
data.table::fwrite(charging_stations_government_scotland,
                   "./data/charging_stations_government_scotland.csv",
                   row.names = FALSE,
                   quote = FALSE)
data.table::fwrite(charging_stations_openchargemap_scotland,
                   "./data/charging_stations_openchargemap_scotland.csv",
                   row.names = FALSE,
                   quote = FALSE)
