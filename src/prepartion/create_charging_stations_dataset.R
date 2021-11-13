# Create Charging Station Dataset

## Load charging stations data
charging_stations <- data.table::fread("./data/charging_stations.csv",
                                       header = TRUE,
                                       sep = ",",
                                       na.strings = c("", "NULL", "NA"))

## Create subset
columns <- c("chargeDeviceID",
             "name",
             "latitude",
             "longitude",
             "town",
             "chargeDeviceStatus",
             "locationType",
             "dateCreated",
             "dateUpdated")
charging_stations <- charging_stations[, ..columns]

## Clean data

### Convert name string to uppercase
charging_stations$name <- toupper(charging_stations$name)

### Convert town string to uppercase
charging_stations$town <- toupper(charging_stations$town)

### Convert charge device status string to uppercase
charging_stations$chargeDeviceStatus <- toupper(charging_stations$chargeDeviceStatus)

### Convert location type string to uppercase
charging_stations$locationType <- toupper(charging_stations$locationType)

### Set NA name string to "UNKNOWN"
charging_stations$name[is.na(charging_stations$name)] <- "UNKNOWN"

### Set NA town string to "UNKNOWN"
charging_stations$town[is.na(charging_stations$town)] <- "UNKNOWN"

## Rename columns
data.table::setnames(charging_stations, "chargeDeviceID", "chargedeviceid")
data.table::setnames(charging_stations, "chargeDeviceStatus", "chargedevicestatus")
data.table::setnames(charging_stations, "locationType", "locationtype")
data.table::setnames(charging_stations, "dateCreated", "datecreated")
data.table::setnames(charging_stations, "dateUpdated", "dateupdated")

## Save data
data.table::fwrite(charging_stations,
                   "./data/charging_stations.csv",
                   row.names = FALSE,
                   quote = FALSE)
