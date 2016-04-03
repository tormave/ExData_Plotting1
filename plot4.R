library(dplyr)
library(sqldf)

data = read.csv.sql("household_power_consumption.txt",
                    header = TRUE,
                    sep = ";",
                    sql = "select * from file where Date in ('2/1/2007', '2/2/2007')")
data[ data == "?" ] = NA
data <- arrange(data, Date, Time) # just to be sure

data$Time <- strptime(paste(data$Date, data$Time, sep = " "), "%m/%d/%Y %X")
data$Date <- unlist(as.Date(data$Date, "%m/%d/%Y"), use.names = FALSE)

png("plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))

# top left
plot(data$Time,
     data$Global_active_power,
     type = "l",
     ylab = "Global Active Power (kilowatts)",
     xlab = "")

#top right
plot(data$Time,
     data$Voltage,
     type = "l",
     ylab = "Global Active Power (kilowatts)",
     xlab = "datetime")

# bottom left
plot(data$Time,
     rep(c(0, 12, 24, 36), 720), # scale the y-axis with diff data
     type = "n",
     ylab = "Energy sub metering",
     xlab = "",
     yaxt = "n")
axis(2, at=seq(0, 30, 10))
cols = c("Black", "Red", "Blue")
points(data$Time, data$Sub_metering_1, type = "l", col = cols[1])
points(data$Time, data$Sub_metering_2, type = "l", col = cols[2])
points(data$Time, data$Sub_metering_3, type = "l", col = cols[3])

legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = cols,
       text.col = cols,
       lty = 1,
       bty = "n")

# bottom right
plot(data$Time,
     data$Global_reactive_power,
     type = "l",
     ylab = "Global_reactive_power",
     xlab = "datetime")

dev.off()