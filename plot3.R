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
electricity$Sub_metering_1      <- as.numeric(electricity$Sub_metering_1)
electricity$Sub_metering_2      <- as.numeric(electricity$Sub_metering_2)
electricity$Sub_metering_3      <- as.numeric(electricity$Sub_metering_3)

## exit to png directly because screen then png is getting truncated
png(filename = "plot3.png")

## plot graphic 2
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
#       ,cex=0.7 # text size
       )

# draw a smooth line 
lines(electricity$Datetime,electricity$Sub_metering_1,lwd=1)
lines(electricity$Datetime,electricity$Sub_metering_2,lwd=1,col="red")
lines(electricity$Datetime,electricity$Sub_metering_3,lwd=1,col="blue")

## save to file device
dev.off()



