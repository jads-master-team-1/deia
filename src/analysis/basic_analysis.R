# Basic Data Analysis

## Load data (WARNING: these files are very large)
parking_sessions <- data.table::fread("./data/parking_sessions.csv",
                                      header = TRUE,
                                      sep = ",")
parking_sessions_2019<- data.table::fread("./data/parking_sessions_2019.csv",
                                          header = TRUE,
                                          sep = ",")
parking_sessions_2020<- data.table::fread("./data/parking_sessions_2020.csv",
                                          header = TRUE,
                                          sep = ",")
parking_sessions_2021<- data.table::fread("./data/parking_sessions_2021.csv",
                                          header = TRUE,
                                          sep = ",")
vehicles <- data.table::fread("./data/vehicles.csv",
                              header = TRUE,
                              sep = ",")
zones <- data.table::fread("./data/zones.csv",
                           header = TRUE,
                           sep = ",")

# which data do you want to analyse today ?
subset_parking_sessions <- parking_sessions_2019

#################### cleaning
# check NAs
library(naniar)
naniar::vis_miss(subset_parking_sessions,warn_large_data=FALSE)
# outliers - boxplot + grubb test ?
# timespan - time series graph
# plot number of parking reservations per day
# how to model - regression - which variables - hypotheses
#################### exploratory analysis
##### calculation duration
subset_parking_sessions$duration<-difftime(subset_parking_sessions$endofsession,subset_parking_sessions$startofsession)
subset_parking_sessions$duration <- as.numeric(subset_parking_sessions$duration)
## plots histogram / density plot / duration 
hist(log(subset_parking_sessions$duration), breaks = 20, 
     main = "Split between consumer and professional usage",
     xlab = "Isprofessional = 1",
     probability = TRUE,
     col = "peachpuff")
lines(density(log(subset_parking_sessions$duration), na.rm=TRUE), lwd = 2, col = "chocolate3") # removed NAs

# qq plot
qqnorm(subset_parking_sessions$duration, pch = 1, frame = FALSE, na.rm=TRUE)
qqline(subset_parking_sessions$duration, col = "steelblue", lwd = 2, na.rm=TRUE)

## Barcharts
##### bar plots of iscorporate
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
  theme_minimal()+ labs(x = "On street or parking garage", y = "Number of rows")

##### bar plots of onstreet
# counting number of data points
library(plyr)
incorporaterows <- sum(subset_parking_sessions$onstreet)
consumerrows <- length(subset_parking_sessions$onstreet)-incorporaterows
#round the numbers?
#round_any(length(subset_parking_sessions$onstreet), 100) 
len = c(round(consumerrows), round(incorporaterows))
##get frequencies of col d
test.summary<-table(subset_parking_sessions$onstreet)
## re-shape the data 
test.summary.m<-reshape::melt(test.summary)
ggplot2::ggplot(test.summary.m,aes(x=as.factor(Var.1),y=value)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=len), vjust=1.6, color="white", size=3.5)+
  theme_minimal()+ labs(x = "Is corporate or not", y = "Number of rows")

##### bar plots of vehicle type
# counting number of data points
library(plyr)
incorporaterows <- sum(subset_parking_sessions$vehicledescription)
consumerrows <- length(subset_parking_sessions$vehicledescription)-incorporaterows
#round the numbers?
#round_any(length(subset_parking_sessions$onstreet), 100) 
len = c(round(consumerrows), round(incorporaterows))
##get frequencies of col d
test.summary<-table(subset_parking_sessions$onstreet)
## re-shape the data 
test.summary.m<-reshape::melt(test.summary)
ggplot2::ggplot(test.summary.m,aes(x=as.factor(Var.1),y=value)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=len), vjust=1.6, color="white", size=3.5)+
  theme_minimal()+ labs(x = "Is corporate or not", y = "Number of rows")


#Checking for NAs
any(is.na(subset_parking_sessions$vehicledescription))

# #change empty string to UNKNOWN
# subset_parking_sessions$vehicledescription[subset_parking_sessions$FuelGroup == ""]<- "UNKNOWN"

#create bar chart for vehicle description 
counts <- table(subset_parking_sessions$vehicledescription)
barplot(log(counts), main="Vehicle type description", xlab="Vehicle type", ylab="Log scale of frequency count")
barplot(counts, main="Vehicle type description", xlab="Vehicle type")

##### plots zone ID per vehicle type/fuel

# library
library(ggplot2)
summary(subset_parking_sessions$zoneid)
counts2 <- table(subset_parking_sessions$zoneid)
# Stacked barplot per zoneID 
ggplot2::ggplot(subset_parking_sessions$, aes(fill=condition, y=value, x=specie)) + 
  geom_bar(position="stack", stat="identity")
