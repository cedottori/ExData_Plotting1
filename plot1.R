library(lubridate)
library(data.table)
library(stringr)

Sys.setenv(LANG = "en")

load <- FALSE ## parameter to reload file

workingDir <- "c:/rawdata/electric_data"
setwd(workingDir)

## read electric_data
if (load){
    electricData <- read.csv(file='household_power_consumption.txt',sep=";",stringsAsFactors = FALSE)
}

## filter days interval
electricity <- rbind(electricData[electricData$Date=="1/2/2007",],electricData[electricData$Date=="2/2/2007",])

## convert to data table and create new datetime column
electricDT  <- data.table(electricity)
electricDT [,Datetime  :=paste(electricDT$Date,electricDT$Time)]

## reconvert to data frame
electricity          <- data.frame(electricDT)

## convert data type as necessary
electricity$Datetime            <- strptime(electricity$Datetime, format="%d/%m/%Y %H:%M:%S")
electricity$Global_active_power <- as.numeric(electricity$Global_active_power)

## exit to png directly because screen then png is getting truncated
png(filename = "plot3.png")

par(mfrow=c(1,1))

## plot graphic 1
hist(electricity$Global_active_power
    ,xlab="Global Active Power (kilowatts)"
    ,col ="red"
    ,main="Global Active Power")

## save to file device
dev.off()

