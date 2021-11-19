# Create Parking Sessions Dataset

## Load parking sessions data
parking_sessions <- data.table::fread("./data/parking_sessions.csv",
                                      header = TRUE,
                                      sep = ",")

## Set types
parking_sessions$startofsession <- as.POSIXct(parking_sessions$startofsession)
parking_sessions$endofsession <- as.POSIXct(parking_sessions$endofsession)

## Filter rows (FuelGroup = ELECTRIC | HYBRID)
parking_sessions <- parking_sessions[FuelGroup == "ELECTRIC" | FuelGroup == "HYBRID"]

## Filter rows (startofsession >= 2020-07-31 & endofsession <= 2021-07-31)
parking_sessions <- subset(
  parking_sessions,
  startofsession >= as.POSIXct("2021-01-31 00:00:00") &
    endofsession <= as.POSIXct("2021-07-31 23:59:59")
)

## Load vehicles, vehicle brands & zones data
vehicles <- data.table::fread("./data/vehicles.csv", header = TRUE, sep = ",")
vehicle_brands <- data.table::fread("./data/vehicle_brands.csv", header = TRUE, sep = ",")
zones <- data.table::fread("./data/zones.csv", header = TRUE, sep = ",")

## Merge vehicles data
data.table::setkey(parking_sessions, vehcileid)
data.table::setkey(vehicles, ID)
parking_sessions <- parking_sessions[vehicles, nomatch = 0]

## Merge vehicle brands data
data.table::setkey(parking_sessions, vehcileid)
data.table::setkey(vehicle_brands, ID)
parking_sessions <- parking_sessions[vehicle_brands, nomatch = 0]

## Merge zones data
data.table::setkey(parking_sessions, zoneid)
data.table::setkey(zones, ID)
parking_sessions <- parking_sessions[zones, nomatch = 0]

## Clean data

### Set is corporate string to "UNKNOWN"
parking_sessions$iscorporate[parking_sessions$iscorporate == ""] <- "UNKNOWN"

### Set on street empty string to "UNKNOWN"
parking_sessions$onstreet[parking_sessions$onstreet == ""] <- "UNKNOWN"

### Set vehicle description empty string to "UNKNOWN"
parking_sessions$vehicledescription[parking_sessions$vehicledescription == ""] <- "UNKNOWN"
parking_sessions$Vehicle_Description[parking_sessions$Vehicle_Description == ""] <- "UNKNOWN"

### Set fuel group empty string to "UNKNOWN"
parking_sessions$FuelGroup[parking_sessions$FuelGroup == ""] <- "UNKNOWN"

### Set interface empty string to "UNKNOWN"
parking_sessions$Interface[parking_sessions$Interface == ""] <- "UNKNOWN"

### Set brand empty string to "UNKNOWN"
parking_sessions$brand[parking_sessions$brand == ""] <- "UNKNOWN"

### Set postcode empty string to "UNKNOWN"
parking_sessions$Postcode[parking_sessions$Postcode == ""] <- "UNKNOWN"

### Create session duration column (minutes)
parking_sessions$sessionduration <- difftime(parking_sessions$endofsession,
                                             parking_sessions$startofsession)
parking_sessions$sessionduration <- as.numeric(parking_sessions$sessionduration)

## Rename columns
data.table::setnames(parking_sessions, "Interface", "interface")
data.table::setnames(parking_sessions, "CO2", "co2")
data.table::setnames(parking_sessions, "EngineCC", "enginecc")
data.table::setnames(parking_sessions, "Fuel", "fueltype")
data.table::setnames(parking_sessions, "FuelGroup", "fuelgroup")
data.table::setnames(parking_sessions, "yearOfManufacture", "yearofmanufacture")
data.table::setnames(parking_sessions, "vehicledescription", "vehicledescription1")
data.table::setnames(parking_sessions, "Vehicle_Description", "vehicledescription2")
data.table::setnames(parking_sessions, "Active", "active")
data.table::setnames(parking_sessions, "Postcode", "postcode")
data.table::setnames(parking_sessions, "Latitude", "latitude")
data.table::setnames(parking_sessions, "Longitude", "longitude")
data.table::setnames(parking_sessions, "DateEnabledStart", "dateenabledstart")
data.table::setnames(parking_sessions, "DateEnabledEnd", "dateenabledend")
data.table::setnames(parking_sessions, "Geometery_point", "geometerypoint")

## Save data
data.table::fwrite(parking_sessions,
                   "./data/parking_sessions_ev_hv.csv",
                   row.names = FALSE,
                   quote = FALSE)
