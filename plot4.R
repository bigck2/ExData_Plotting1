#load packages used in script
library(lubridate)
library(dplyr)

#read in the data
power <- read.table("household_power_consumption.txt", 
                    header = T, sep = ";", na.strings = "?", 
                    stringsAsFactors = FALSE)

#convert Date column from character to Date
#then filter down to two relevant dates
power <- mutate(power, Date = as.Date(Date, format = "%d/%m/%Y")) %>%
  filter(Date == ("2007-02-01") | Date == ("2007-02-02") )

#convert Time from character to Time (via lubridate function)
power <- mutate(power, Time = hms(Time))

#Add Date and Time together to DateTime variable
#This becomes a POSIXlt and POSIXt variable
DateTime = power$Date + power$Time

#add DateTime to the power data frame with cbind
power <- cbind(power, DateTime)

#remove DateTime variable
rm(DateTime)

#create connection to new PNG file graphics device
png(filename = "plot4.png", type = "cairo")

#set graphics area to allow for 4 plots (2 rows, 2 columns)
par(mfrow = c(2, 2))

#make top left line graph
with(power, plot(DateTime, Global_active_power, type = "l", 
     ylab = "Global Active Power (kilowatts)", xlab = ""))

#make top right line graph
with(power, plot(DateTime, Voltage, type = "l"))     

#make bottom left line graph
with(power, plot(DateTime, Sub_metering_1, type = "n", 
                 ylab = "Energy sub metering",
                 xlab = "",
                 lwd = 0.5))

with(power, {
  lines(DateTime, Sub_metering_1)
  lines(DateTime, Sub_metering_2, col = "red")
  lines(DateTime, Sub_metering_3, col = "blue")    
})

#add legend to botton left graph
legend(max(power$DateTime) - hours(25), 39, 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = c(1,1,1), col = c("black", "blue", "red"), 
       cex = 0.75, bty ="n")

#make bottom right line graph
with(power, plot(DateTime, Global_reactive_power, type = "l", 
                 lwd = 0.5))

#close connection to PNG file graphics device
dev.off()
