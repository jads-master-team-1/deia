# Basic Data Analysis

## Load data (WARNING: these files are very large)
parking_sessions <- data.table::fread("./data/parking_sessions.csv.txt",
                                      header = TRUE,
                                      sep = ",")
vehicles <- data.table::fread("./data/vehicles.csv",
                              header = TRUE,
                              sep = ",")
zones <- data.table::fread("./data/zones.csv.txt",
                           header = TRUE,
                           sep = ",")
# making hard subset
subset_parking_sessions <- parking_sessions[c(1:5000),]

# cleaning

# exploratory analysis
  # Barcharts
# plots histogram / density plot / iscorporate 
hist(subset_parking_sessions$iscorporate, breaks = 20, 
     main = "Split between consumer and professional usage",
     xlab = "Isprofessional = 1",
     probability = TRUE,
     col = "peachpuff")
lines(density(subset_parking_sessions$iscorporate, na.rm=TRUE), lwd = 2, col = "chocolate3") # removed NAs

# bar plots of iscorporate
library(ggplot2)
library(reshape)
# counting number of data points
incorporaterows <- sum(subset_parking_sessions$iscorporate)
consumerrows <- length(subset_parking_sessions$iscorporate)-incorporaterows
len = c(consumerrows, incorporaterows)
##get frequencies of col d
test.summary<-table(subset_parking_sessions$iscorporate)
## re-shape the data 
test.summary.m<-reshape::melt(test.summary)
ggplot2::ggplot(test.summary.m,aes(x=as.factor(Var.1),y=value)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=len), vjust=1.6, color="white", size=3.5)+
  theme_minimal()+ labs(x = "Is corporate or not", y = "Number of rows")

  # check NAs
library(naniar)
naniar::vis_miss(subset_parking_sessions)
  # outliers - boxplot + grubb test ?
# timespan - time series graph
  # plot number of parking reservations per day
# how to model - regression - which variables - hypotheses

