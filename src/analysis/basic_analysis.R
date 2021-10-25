# Basic Data Analysis

## Set subset ("pre", "during", "post")
subset <- "post"
title <- paste("(", subset, " covid-19)", sep = "")

## Load data
file_name <- paste("./data/parking_sessions_", subset, "_covid.csv", sep = "")
parking_sessions <- data.table::fread(file_name, header = TRUE, sep = ",")

## Clean data

### Set is corporate string to "UNKNOWN"
parking_sessions$iscorporate[parking_sessions$iscorporate == ""] <- "UNKNOWN"

### Set on street empty string to "UNKNOWN"
parking_sessions$onstreet[parking_sessions$onstreet == ""] <- "UNKNOWN"

### Set vehicle description empty string to "UNKNOWN"
parking_sessions$vehicledescription[parking_sessions$vehicledescription == ""] <- "UNKNOWN"

### Set fuel group empty string to "UNKNOWN"
parking_sessions$FuelGroup[parking_sessions$FuelGroup == ""] <- "UNKNOWN"

### Set interface empty string to "UNKNOWN"
parking_sessions$Interface[parking_sessions$Interface == ""] <- "UNKNOWN"

### Create session duration column (minutes)
parking_sessions$sessionduration <- difftime(parking_sessions$endofsession,
                                             parking_sessions$startofsession)
parking_sessions$sessionduration <- as.numeric(parking_sessions$sessionduration)

## Create subset
columns <- c("sessionid",
             "purchasedate",
             "startofsession",
             "endofsession",
             "sessionduration",
             "iscorporate",
             "userid",
             "vehcileid",
             "onstreet",
             "vehicledescription",
             "FuelGroup",
             "zoneid",
             "Interface",
             "qtypurchases")
parking_sessions_subset <- parking_sessions[, ..columns]

## Descriptive statistics

### Summary
sapply(parking_sessions_subset, summary)

### Number of NA's
sapply(parking_sessions_subset, function(x) {
  result <- c(length(x),
              sum(is.na(x)),
              ifelse(is.character(x), sum(x == ""), 0))
  names(result) <- c("Length", "No. NA", "No. Empty")
  
  return(result)
})

## Create plots

### parking sessions over time: timeseries
ggplot2::ggplot(parking_sessions) +
  ggplot2::aes(x = format(startofsession, "%Y-%m")) +
  ggplot2::geom_bar() +
  ggplot2::theme_minimal() +
  ggplot2::labs(title = paste("Parking Sessions Over Time", title),
                x = "Dates",
                y = "Frequency")

### is corporate: barplot
counts <- table(parking_sessions$iscorporate)

plt <- barplot(counts,
               main = paste("Is Corporate Distribution", title),
               xlab = "Is Corporate or Not",
               ylab = "Frequency")
text(plt, 0, as.character(counts), cex = 1, pos = 3)

### on street: barplot
counts <- table(parking_sessions$onstreet)

plt <- barplot(counts,
               main = paste("On Street Distribution", title),
               xlab = "On Street or Parking Garage",
               ylab = "Frequency")
text(plt, 0, as.character(counts), cex = 1, pos = 3)


### vehicle description: barplot
counts <- table(parking_sessions$vehicledescription)

plt <- barplot(counts,
               main = paste("Vehicle Description Distribution", title),
               xlab = "Vehicle Type",
               ylab = "Frequency")
text(plt, 0, as.character(counts), cex = 1, pos = 3)

### fuel group: barplot
counts <- table(parking_sessions$FuelGroup)

plt <- barplot(counts,
               main = paste("Fuel Group Distribution", title),
               xlab = "Type of fuel",
               ylab = "Frequency")
text(plt, 0, as.character(counts), cex = 1, pos = 3)

### top 10 zones over time: time series

# TODO: plot top 10 zones over time

### top 10 zones: barplot
counts <- sort(table(parking_sessions$zoneid), decreasing = TRUE)[1:10]

plt <- barplot(counts,
               main = paste("Top 10 Zones", title),
               xlab = "Zone ID",
               ylab = "Frequency")
text(plt, 0, as.character(counts), cex = 1, pos = 3)

### interface: barplot
counts <- table(parking_sessions$Interface)

plt <- barplot(counts,
               main = paste("Interface Distribution", title),
               xlab="Interface",
               ylab = "Frequency")
text(plt, 0, as.character(counts), cex = 1, pos = 3)
