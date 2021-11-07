# Split Parking Sessions Dataset

## Load data (WARNING: this file is very large)
parking_sessions <- data.table::fread("./data/parking_sessions.csv",
                                      header = TRUE,
                                      sep = ",")

## Set types
parking_sessions$startofsession <- as.POSIXct(parking_sessions$startofsession)
parking_sessions$endofsession <- as.POSIXct(parking_sessions$endofsession)

## Split data

### 2019-01-01 - 2019-12-31
parking_sessions_2019 <- subset(
  parking_sessions,
  startofsession >= as.POSIXct("2019-01-01 00:00:00") &
    endofsession <= as.POSIXct("2019-12-31 23:59:59")
)

### 2020-01-01 - 2020-12-31
parking_sessions_2020 <- subset(
  parking_sessions,
  startofsession >= as.POSIXct("2020-01-01 00:00:00") &
    endofsession <= as.POSIXct("2020-12-31 23:59:59")
)

### 2021-01-01 - 2021-12-31
parking_sessions_2021 <- subset(
  parking_sessions,
  startofsession >= as.POSIXct("2021-01-01 00:00:00") &
    endofsession <= as.POSIXct("2021-12-31 23:59:59")
)

### Pre COVID - During COVID
parking_sessions_pre_covid <- subset(
  parking_sessions,
    startofsession >= as.POSIXct("2019-01-01 00:00:00") &
    endofsession <= as.POSIXct("2020-03-15 23:59:59")
)

### During COVID - Post COVID
parking_sessions_during_covid <- subset(
  parking_sessions,
  startofsession >= as.POSIXct("2020-03-16 00:00:00") &
  endofsession <= as.POSIXct("2021-05-16 23:59:59")
)

### Post COVID - Now
parking_sessions_post_covid <- subset(
  parking_sessions,
  startofsession >= as.POSIXct("2021-05-17 00:00:00") &
  endofsession <= as.POSIXct("2021-07-31 23:59:59")
)

## Save data

### 2019-01-01 - 2019-12-31
data.table::fwrite(parking_sessions_2019,
                   "./data/parking_sessions_2019.csv",
                   row.names = FALSE,
                   quote = FALSE)

### 2020-01-01 - 2020-12-31
data.table::fwrite(parking_sessions_2020,
                   "./data/parking_sessions_2020.csv",
                   row.names = FALSE,
                   quote = FALSE)

### 2021-01-01 - 2021-12-31
data.table::fwrite(parking_sessions_2021,
                   "./data/parking_sessions_2021.csv",
                   row.names = FALSE,
                   quote = FALSE)

### Pre COVID - During COVID
data.table::fwrite(parking_sessions_pre_covid,
                   "./data/parking_sessions_pre_covid.csv",
                   row.names = FALSE,
                   quote = FALSE)

### During COVID - Post COVID
data.table::fwrite(parking_sessions_during_covid,
                   "./data/parking_sessions_during_covid.csv",
                   row.names = FALSE,
                   quote = FALSE)

### Post COVID - Now
data.table::fwrite(parking_sessions_post_covid,
                   "./data/parking_sessions_post_covid.csv",
                   row.names = FALSE,
                   quote = FALSE)
