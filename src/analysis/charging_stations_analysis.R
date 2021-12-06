# Charging Stations Data Analysis

## Load data
charging_stations_government <- data.table::fread("./data/charging_stations_government.csv",
                                                  header = TRUE,
                                                  sep = ",")
charging_stations_openchargemap <- data.table::fread("./data/charging_stations_openchargemap.csv",
                                                     header = TRUE,
                                                     sep = ",")

## Set Types

### Set charge device status to factor
charging_stations_government$chargedevicestatus <- as.factor(charging_stations_government$chargedevicestatus)
charging_stations_openchargemap$chargedevicestatus <- as.factor(charging_stations_openchargemap$chargedevicestatus)

### Set connector count to factor
charging_stations_government$connectorcount <- as.factor(charging_stations_government$connectorcount)
charging_stations_openchargemap$connectorcount <- as.factor(charging_stations_openchargemap$connectorcount)

## Create subset
columns <- c("chargedeviceid",
             "name",
             "latitude",
             "longitude",
             "chargedevicestatus",
             "datecreated",
             "dateupdated",
             "connectorcount")
charging_stations_government_subset <- charging_stations_government[, ..columns]
charging_stations_openchargemap_subset <- charging_stations_openchargemap[, ..columns]

## Descriptive statistics

### Summary
summary(charging_stations_government_subset)
summary(charging_stations_openchargemap_subset)

stargazer::stargazer(charging_stations_government_subset,
                     table.placement = "H",
                     digit.separator = "",
                     flip = TRUE,
                     header = FALSE,
                     label = "tab:charging_stations_government_numerical_summary_statistics",
                     title = "Charging Stations Government (numerical) summary statistics")

stargazer::stargazer(charging_stations_openchargemap_subset,
                     table.placement = "H",
                     digit.separator = "",
                     flip = TRUE,
                     header = FALSE,
                     label = "tab:charging_stations_openchargemap_numerical_summary_statistics",
                     title = "Charging Stations OpenChargeMap (numerical) summary statistics")

## Create plots

### charging stations over time: timeseries
ggplot2::ggplot(charging_stations_government_subset) +
  ggplot2::aes(x = format(datecreated, "%Y")) +
  ggplot2::geom_bar() +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Charging Stations Over Time",
                x = "Dates",
                y = "Frequency")

ggplot2::ggplot(charging_stations_openchargemap_subset) +
  ggplot2::aes(x = format(datecreated, "%Y")) +
  ggplot2::geom_bar() +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Charging Stations Over Time",
                x = "Dates",
                y = "Frequency")

# charge device status: barplot
ggplot2::ggplot(charging_stations_government_subset) +
  ggplot2::aes(x = chargedevicestatus) +
  ggplot2::geom_bar() +
  ggplot2::geom_text(stat = "count",
                     ggplot2::aes(label = ggplot2::after_stat(count)),
                     vjust = -1) +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Charge Device Status Distribution",
                x = "Charge Device Status",
                y = "Frequency")

ggplot2::ggplot(charging_stations_openchargemap_subset) +
  ggplot2::aes(x = chargedevicestatus) +
  ggplot2::geom_bar() +
  ggplot2::geom_text(stat = "count",
                     ggplot2::aes(label = ggplot2::after_stat(count)),
                     vjust = -1) +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Charge Device Status Distribution",
                x = "Charge Device Status",
                y = "Frequency")

# connector count: barplot
ggplot2::ggplot(charging_stations_government_subset) +
  ggplot2::aes(x = connectorcount) +
  ggplot2::geom_bar() +
  ggplot2::geom_text(stat = "count",
                     ggplot2::aes(label = ggplot2::after_stat(count)),
                     vjust = -1) +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Connector Count Distribution",
                x = "Connector Count",
                y = "Frequency")

ggplot2::ggplot(charging_stations_openchargemap_subset) +
  ggplot2::aes(x = connectorcount) +
  ggplot2::geom_bar() +
  ggplot2::geom_text(stat = "count",
                     ggplot2::aes(label = ggplot2::after_stat(count)),
                     vjust = -1) +
  ggplot2::theme_grey() +
  ggplot2::labs(title = "Connector Count Distribution",
                x = "Connector Count",
                y = "Frequency")