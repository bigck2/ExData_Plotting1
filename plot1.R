
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
png(filename = "plot1.png")

#build desired histogram
hist(power$Global_active_power, col = "red", 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

#close connection to PNG file graphics device
dev.off()

