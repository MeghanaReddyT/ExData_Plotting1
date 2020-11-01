#Downloading the dataset and getting the required table ready 
furl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fname<-"data.zip"
if(!file.exists(fname))
{
  download.file(furl, fname)
}
data<-unzip(fname)
library(dplyr)
tab<-read.table(data,sep = ";")
names(tab)<-c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
tab2<-tab[-1,]
ftab<-subset(tab2,tab2$Date=="1/2/2007" | tab2$Date =="2/2/2007")

#Making necessary formatting changes 
ftab$Date<-as.Date(ftab$Date,"%d/%m/%Y")
ftab$Time<-strptime(ftab$Time,"%H:%M:%S")
ftab[1:1440,"Time"]<-format(ftab[1:1440,"Time"],"2007-02-01 %H:%M:%S")
ftab[1441:2880,"Time"]<-format(ftab[1441:2880,"Time"],"2007-02-02 %H:%M:%S")

#Generating the plot
png(filename = "Plot4.png",height = 480,width = 480)
par(mfrow=c(2,2))
with(ftab,{
  plot(ftab$Time,as.numeric(as.character(ftab$Global_active_power)),type = "l",xlab = "",ylab = "Global Active Power(kilowatts)")
  plot(ftab$Time,as.numeric(as.character(ftab$Voltage)),type = "l",xlab = "datetime",ylab = "Voltage")
  plot(ftab$Time,as.numeric(as.character(ftab$Sub_metering_1)),type = "n",xlab = "",ylab = "Energy sub metering") 
       lines(ftab$Time,as.numeric(as.character(ftab$Sub_metering_1)),col="black")
       lines(ftab$Time,as.numeric(as.character(ftab$Sub_metering_2)),col="red")
       lines(ftab$Time,as.numeric(as.character(ftab$Sub_metering_3)),col="blue")
       legend("topright",col = c("black","red","blue"),lty = 1,legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),cex=0.5)
  plot(ftab$Time,as.numeric(as.character(ftab$Global_reactive_power)),type = "l",xlab = "datetime",ylab = "Global_reactive_power")
       })
dev.off()