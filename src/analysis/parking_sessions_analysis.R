# Parking Sessions Data Analysis

## Load data
parking_sessions <- data.table::fread("./data/parking_sessions_ev_hv.csv",
                                      header = TRUE,
                                      sep = ",")

## Set Types

### Set fuel group to factor
parking_sessions$fuelgroup <- as.factor(parking_sessions$fuelgroup)

### Set fuel type to factor
parking_sessions$fueltype <- as.factor(parking_sessions$fueltype)

### Set brand to factor
parking_sessions$brand <- as.factor(parking_sessions$brand)

## Create subset
columns <- c("sessionid",
             "zoneid",
             "latitude",
             "longitude",
             "startofsession",
             "endofsession",
             "sessionduration",
             "fuelgroup",
             "fueltype",
             "brand")
parking_sessions_subset <- parking_sessions[, ..columns]

## Remove outliers

### Session duration
parking_sessions_subset <- parking_sessions_subset[parking_sessions_subset$sessionduration < 40000]

## Descriptive statistics

### Summary
summary(parking_sessions_subset)

stargazer::stargazer(parking_sessions_subset,
                     table.placement = "H",
                     digit.separator = "",
                     flip = TRUE,
                     header = FALSE,
                     label = "tab:parking_sessions_numerical_summary_statistics",
                     title = "Parking sessions (numerical) summary statistics")

## Create plots

### parking sessions over time: timeseries
ggplot2::ggplot(parking_sessions_subset) +
  ggplot2::aes(x = format(startofsession, "%Y-%m")) +
  ggplot2::geom_bar() +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Parking Sessions Over Time",
                x = "Dates",
                y = "Frequency")

# session duration: boxplot
ggplot2::ggplot(parking_sessions_subset) +
  ggplot2::aes(y = sessionduration) +
  ggplot2::geom_boxplot() +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Session Duration Boxplot",
                y = "Session Duration")

# log(session duration): boxplot
ggplot2::ggplot(parking_sessions_subset) +
  ggplot2::aes(y = log(sessionduration)) +
  ggplot2::geom_boxplot() +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "LOG(Session Duration) Boxplot",
                y = "LOG(Session Duration)")

# fuel group: barplot
ggplot2::ggplot(parking_sessions_subset) +
  ggplot2::aes(x = fuelgroup) +
  ggplot2::geom_bar() +
  ggplot2::geom_text(stat = "count",
                     ggplot2::aes(label = ggplot2::after_stat(count)),
                     vjust = -1) +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Fuel Group Distribution",
                x = "Fuel Groups",
                y = "Frequency")

# fuel type: barplot
ggplot2::ggplot(parking_sessions_subset) +
  ggplot2::aes(x = fueltype) +
  ggplot2::geom_bar() +
  ggplot2::geom_text(stat = "count",
                     ggplot2::aes(label = ggplot2::after_stat(count)),
                     vjust = -1) +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Fuel Type Distribution",
                x = "Fuel Types",
                y = "Frequency")

# brand: barplot
ggplot2::ggplot(parking_sessions_subset) +
  ggplot2::aes(x = brand) +
  ggplot2::geom_bar() +
  ggplot2::geom_text(stat = "count",
                     ggplot2::aes(label = ggplot2::after_stat(count)),
                     vjust = -1) +
  ggplot2::theme_grey() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
  ggplot2::labs(title = "Brand Distribution",
                x = "Brands",
                y = "Frequency")
