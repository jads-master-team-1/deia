# Create Open Charge Map Charging Stations Dataset

## Create dataset
files <- list.files("./data/openchargemap/")

for (file in files) {
  ### Load data
  data <- rjson::fromJSON(file=paste0("./data/openchargemap/", file))
  
  ### Calculate connector count
  if (length(data$Connections) == 0 | sum(purrr::map_int(data$Connections, function(x) !is.null(x$Quantity))) != length(data$Connections)) {
    connectorcount <- length(data$Connections)
  } else {
    connectorcount <- sum(purrr::map_dbl(data$Connections, function(x) x$Quantity))
  }
  
  ### Create dataset (if required)
  if (!exists("charging_stations")) {
    charging_stations <- data.table::data.table(chargedeviceid = data$UUID,
                                                name = data$AddressInfo$Title,
                                                latitude = data$AddressInfo$Latitude,
                                                longitude = data$AddressInfo$Longitude,
                                                town = data$AddressInfo$Town,
                                                chargedevicestatus = "IN SERVICE",
                                                locationtype = NA,
                                                datecreated = data$DateCreated,
                                                dateupdated = data$DateLastStatusUpdate,
                                                connectorcount = connectorcount)
  } else {
    charging_stations <- rbind(charging_stations, list(data$UUID,
                                                       data$AddressInfo$Title,
                                                       data$AddressInfo$Latitude,
                                                       data$AddressInfo$Longitude,
                                                       data$AddressInfo$Town,
                                                       "IN SERVICE",
                                                       NA,
                                                       data$DateCreated,
                                                       data$DateLastStatusUpdate,
                                                       connectorcount))
  }
  
  rm(connectorcount)
  rm(data)
}

## Clean data

### Convert name string to uppercase
charging_stations$name <- toupper(charging_stations$name)

### Convert town string to uppercase
charging_stations$town <- toupper(charging_stations$town)

### Convert charge device status string to uppercase
charging_stations$chargedevicestatus <- toupper(charging_stations$chargedevicestatus)

### Remove punctuation from name
charging_stations$name <- gsub(",", "", charging_stations$name)
charging_stations$name <- gsub('"', "", charging_stations$name)

### Remove punctuation from town
charging_stations$town <- gsub(",", "", charging_stations$town)
charging_stations$town <- gsub('"', "", charging_stations$town)

### Set NA name string to "UNKNOWN"
charging_stations$name[is.na(charging_stations$name)] <- "UNKNOWN"

### Set NA town string to "UNKNOWN"
charging_stations$town[is.na(charging_stations$town)] <- "UNKNOWN"

### Set datecreated 0000-00-00 00:00:00 string to "NA"
charging_stations$datecreated[charging_stations$datecreated == "0000-00-00 00:00:00"] <- NA

### Set dateupdated 0000-00-00 00:00:00 string to "NA"
charging_stations$dateupdated[charging_stations$dateupdated == "0000-00-00 00:00:00"] <- NA

## Set types
charging_stations$datecreated <- as.POSIXct(charging_stations$datecreated)
charging_stations$dateupdated <- as.POSIXct(charging_stations$dateupdated)

## Filter rows (datecreated <= 2020-07-31)
charging_stations <- subset(
  charging_stations,
  datecreated <= as.POSIXct("2021-02-01 00:00:00")
)

## Store dataset
data.table::fwrite(charging_stations,
                   "./data/charging_stations_openchargemap.csv",
                   row.names = FALSE,
                   quote = FALSE)
