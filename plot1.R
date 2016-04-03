library(dplyr)
library(sqldf)

data = read.csv.sql("household_power_consumption.txt",
                    header = TRUE,
                    sep = ";",
                    sql = "select * from file where Date in ('1/2/2007', '2/2/2007')")
data[ data == "?" ] = NA
data <- arrange(data, Date, Time) # just to be sure

data$Time <- strptime(paste(data$Date, data$Time, sep = " "), "%d/%m/%Y %X")
data$Date <- unlist(as.Date(data$Date, "%m/%d/%Y"), use.names = FALSE)

png("plot1.png", width = 480, height = 480)
hist(data$Global_active_power,
     col = "Red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()