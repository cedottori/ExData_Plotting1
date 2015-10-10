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
electricity$Datetime              <- strptime(electricity$Datetime, format="%d/%m/%Y %H:%M:%S")
electricity$Global_active_power   <- as.numeric(electricity$Global_active_power)
electricity$Global_reactive_power <- as.numeric(electricity$Global_reactive_power)
electricity$Sub_metering_1        <- as.numeric(electricity$Sub_metering_1)
electricity$Sub_metering_2        <- as.numeric(electricity$Sub_metering_2)
electricity$Sub_metering_3        <- as.numeric(electricity$Sub_metering_3)
electricity$Voltage               <- as.numeric(electricity$Voltage)

## exit to png directly because screen then png is getting truncated
png(filename = "plot4.png")

## set 2x2 
par(mfrow=c(2,2))

## plot graphic 1
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

lines(electricity$Datetime,electricity$Global_active_power,lwd=1)

## plot graphic 2
plot(electricity$Datetime
     ,electricity$Voltage
     ,xlab="datetime"
     ,ylab="Voltage"
     ,xaxt="n"
     ,type="n") ## wait to plot, clear plot


## plots x axis and labels
dias  <- c("Thu","Fri","Sat")
local <- c(strptime("01/02/2007", "%d/%m/%Y")
           ,strptime("02/02/2007", "%d/%m/%Y")
           ,strptime("03/02/2007", "%d/%m/%Y"))
axis.POSIXct(1, electricity$Datetime,at=local,labels=dias)

lines(electricity$Datetime,electricity$Voltage,lwd=1)

## plot graphic 3
plot(electricity$Datetime
    ,electricity$Sub_metering_1
    ,xlab=""
    ,ylab="Energy sub metering"
    ,xaxt="n"
    ,type="n") ## wait to plot, clear plot


## plots x axis and labels
dias  <- c("Thu","Fri","Sat")
local <- c(strptime("01/02/2007", "%d/%m/%Y")
           ,strptime("02/02/2007", "%d/%m/%Y")
           ,strptime("03/02/2007", "%d/%m/%Y"))
axis.POSIXct(1, electricity$Datetime,at=local,labels=dias)
  # legend
  legend("topright"
         ,legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
         ,lty=c(1,1)
         ,col=c("black","red","blue")
         ,bty="n" # no box
         )

  # draw a smooth line 
  lines(electricity$Datetime,electricity$Sub_metering_1,lwd=1)
  lines(electricity$Datetime,electricity$Sub_metering_2,lwd=1,col="red")
  lines(electricity$Datetime,electricity$Sub_metering_3,lwd=1,col="blue")

## plot graphic 4
plot(electricity$Datetime
     ,electricity$Global_reactive_power
     ,xlab="datetime"
     ,ylab="Global_reactive_power"
     ,xaxt="n"
     ,type="n") ## wait to plot, clear plot


## plots x axis and labels
dias  <- c("Thu","Fri","Sat")
local <- c(strptime("01/02/2007", "%d/%m/%Y")
           ,strptime("02/02/2007", "%d/%m/%Y")
           ,strptime("03/02/2007", "%d/%m/%Y"))
axis.POSIXct(1, electricity$Datetime,at=local,labels=dias)

lines(electricity$Datetime,electricity$Global_reactive_power,lwd=1)
  
  
## save to file device
dev.off()



