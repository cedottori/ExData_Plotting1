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

#electricity$Datetime            <- as.POSIXlt(electricity$Datetime, format="%d/%m/%Y %H:%M:%S")
#electricity$Global_active_power <- as.numeric(electricity$Global_active_power)


## exit to png directly because screen then png is getting truncated
png(filename = "plot2.png")

par(mfrow=c(1,1))

## plot graphic 2 without x axis marks
plot(electricity$Datetime
    ,electricity$Global_active_power
    ,xlab=""
    ,ylab="Global Active Power (kilowatts)"
    ,xaxt="n"
    ,type="n") ## wait to plot, clear plot


## plots x axis and labels
dias  <- c("Thu","Fri","Sat")
local <- c(strptime("01/02/2007", "%d/%m/%Y")
          ,strptime("02/02/2007", "%d/%m/%Y")
          ,strptime("03/02/2007", "%d/%m/%Y"))

axis.POSIXct(1, electricity$Datetime,at=local,labels=dias)


# draw a smooth line 
lines(electricity$Datetime,electricity$Global_active_power,lwd=1)

## save to file device
dev.off()




