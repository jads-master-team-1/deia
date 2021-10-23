# Basic Data Analysis

## Load data (WARNING: these files are very large)
parking_sessions <- data.table::fread("./data/parking_sessions.csv",
                                      header = TRUE,
                                      sep = ",")
vehicles <- data.table::fread("./data/vehicles.csv",
                              header = TRUE,
                              sep = ",")
zones <- data.table::fread("./data/zones.csv",
                           header = TRUE,
                           sep = ",")
