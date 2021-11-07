# Create Parking Sessions Dataset

## Load parking sessions data
parking_sessions <- data.table::fread("./data/parking_sessions.csv",
                                      header = TRUE,
                                      sep = ",")

## Filter rows (FuelGroup = ELECTRIC | HYBRID)
parking_sessions <- parking_sessions[FuelGroup == "ELECTRIC" | FuelGroup == "HYBRID"]

## Load vehicles & zones data
vehicles <- data.table::fread("./data/vehicles.csv", header = TRUE, sep = ",")
zones <- data.table::fread("./data/zones.csv", header = TRUE, sep = ",")

## Merge vehicles data
data.table::setkey(parking_sessions, vehcileid)
data.table::setkey(vehicles, ID)
parking_sessions <- parking_sessions[vehicles, nomatch = 0]

## Merge zones data
data.table::setkey(parking_sessions, zoneid)
data.table::setkey(zones, ID)
parking_sessions <- parking_sessions[zones, nomatch = 0]

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
