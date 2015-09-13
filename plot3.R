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
png(filename = "plot3.png")

#initiate plot but set type = "n" to not plot any lines yet
with(power, plot(DateTime, Sub_metering_1, type = "n", 
                 ylab = "Energy sub metering"))

#add three lines for each meter and use different colors
with(power, {
       lines(DateTime, Sub_metering_1)
       lines(DateTime, Sub_metering_2, col = "red")
       lines(DateTime, Sub_metering_3, col = "blue")    
 })

#add legend that fits in top right area
legend(max(power$DateTime) - hours(15), 39, 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = c(1,1,1), col = c("black", "blue", "red"), 
       cex = 0.75)

#close connection to PNG file graphics device
dev.off()

