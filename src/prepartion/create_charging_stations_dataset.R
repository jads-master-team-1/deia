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
             "dateUpdated",
             "connector1ID",
             "connector2ID",
             "connector3ID",
             "connector4ID",
             "connector5ID",
             "connector6ID",
             "connector7ID",
             "connector8ID")
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

### Remove punctuation from name
charging_stations$name <- gsub(",", "", charging_stations$name)

### Remove punctuation from town
charging_stations$town <- gsub(",", "", charging_stations$town)

### Set NA name string to "UNKNOWN"
charging_stations$name[is.na(charging_stations$name)] <- "UNKNOWN"

### Set NA town string to "UNKNOWN"
charging_stations$town[is.na(charging_stations$town)] <- "UNKNOWN"

### Set dateCreated 0000-00-00 00:00:00 string to "NA"
charging_stations$dateCreated[charging_stations$dateCreated == "0000-00-00 00:00:00"] <- NA

### Set dateUpdated 0000-00-00 00:00:00 string to "NA"
charging_stations$dateUpdated[charging_stations$dateUpdated == "0000-00-00 00:00:00"] <- NA

### Create connector count column
charging_stations$connectorcount <- (!is.na(charging_stations$connector1ID)) +
                                    (!is.na(charging_stations$connector2ID)) +
                                    (!is.na(charging_stations$connector3ID)) +
                                    (!is.na(charging_stations$connector4ID)) +
                                    (!is.na(charging_stations$connector5ID)) +
                                    (!is.na(charging_stations$connector6ID)) +
                                    (!is.na(charging_stations$connector7ID)) +
                                    (!is.na(charging_stations$connector8ID))

### Remove connector id columns
charging_stations <- charging_stations[, -c("connector1ID", "connector2ID",
                                            "connector3ID", "connector4ID",
                                            "connector5ID", "connector6ID",
                                            "connector7ID", "connector8ID")]

## Set types
charging_stations$dateCreated <- as.POSIXct(charging_stations$dateCreated)
charging_stations$dateUpdated <- as.POSIXct(charging_stations$dateUpdated)

## Filter rows (dateCreated <= 2020-07-31)
charging_stations <- subset(
  charging_stations,
  dateCreated <= as.POSIXct("2021-02-01 00:00:00")
)

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
