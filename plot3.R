#download the zip file and unzip it
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("household_power_consumption.txt")) {
        download.file(fileUrl, destfile = "c4p1.zip", method = "curl")
        dateDownloaded <- date()
        unzip("c4p1.zip")
}

#loading the dataset into r using "fread" (it is supposed to be much faster than
#"read.table" and you can limit the lines read into r)
DT <- fread("household_power_consumption.txt", sep=";", showProgress=FALSE)
#print the number of lines in full data set
sprintf("Number of lines in selected lines: %s", nrow(DT))
str(DT)
#select the dataset for "1/2/2007" and "2/2'2007" (d/m/y) to create a smaller DT1
DT1 <- filter(DT, Date == "1/2/2007" | Date =="2/2/2007")

#concatenate the "Date" and "Time" columns to form the "Date_Time" column
#convert the "Date_Time" from character to POSIXlt format
DT1$Date_Time <- with(DT1, paste(Date, Time, sep=" "))
DT1$Date_Time <- strptime(DT1$Date_Time, format = "%d/%m/%Y %H:%M:%S")
str(DT1)

#convert from character to numeric class

DT1$Global_active_power <- as.numeric(DT1$Global_active_power)
DT1$Global_reactive_power <- as.numeric(DT1$Global_reactive_power)
DT1$Voltage <- as.numeric(DT1$Voltage)
DT1$Sub_metering_1 <- as.numeric(DT1$Sub_metering_1)
DT1$Sub_metering_2 <- as.numeric(DT1$Sub_metering_2)
DT1$Sub_metering_3 <- as.numeric(DT1$Sub_metering_3)
str(DT1)

#plot3
png("plot3.png")
T <- DT1$Date_Time
Sub_metering_1 <- DT1$Sub_metering_1
Sub_metering_2 <- DT1$Sub_metering_2
Sub_metering_3 <- DT1$Sub_metering_3
plot(T, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
points(T, Sub_metering_1, type = "l")
points(T, Sub_metering_2, type = "l", col="red")
points(T, Sub_metering_3, type = "l", col="blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty = 1 )
dev.off()