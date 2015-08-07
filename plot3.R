#####################################
##Set Working Directory to local REPO
#####################################

##only active on my own computer
setwd("C:/Users/Aletta/Documents/_ALLEFILES/LOCALREPO/ExData_Plotting1/ExData_Plotting1")


############################
##GETTING THE DATA
############################

##download the file (if it is not there)
if(!file.exists("exdata-data-household_power_consumption.zip")) {
  tijdelijk <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", tijdelijk)
  bestand <- unzip(tijdelijk)
  unlink(tijdelijk)
  rm(tijdelijk)
}
##read the file into a dataframe
##say that the set has a header
##separate into columns with ";" as a separator
##and that missing values are "?"
dataset <- read.table(bestand, header=T, sep=";", na.strings="?")
unlink(bestand)
rm(bestand)

############################
##CLEANING THE DATA
############################

##make the Dates into real dates 
##and subset 1 and 2 februari 2007
dataset$Date = as.Date(dataset$Date, "%d/%m/%Y")
subsetFeb1207 <- dataset[(dataset$Date=="2007-02-01") | (dataset$Date=="2007-02-02"),]

##in the subset: make sure all results from meters is numeric
subsetFeb1207$Global_active_power <- as.numeric(subsetFeb1207$Global_active_power)
subsetFeb1207$Global_reactive_power <- as.numeric(subsetFeb1207$Global_reactive_power)
subsetFeb1207$Voltage <- as.numeric(subsetFeb1207$Voltage)
subsetFeb1207$Sub_metering_1 <- as.numeric(subsetFeb1207$Sub_metering_1)
subsetFeb1207$Sub_metering_2 <- as.numeric(subsetFeb1207$Sub_metering_2)
subsetFeb1207$Sub_metering_3 <- as.numeric(subsetFeb1207$Sub_metering_3)
##in the subset: make the time a real time 
##(did not write this line myself; I still get confused with time)
subsetFeb1207 <- transform(subsetFeb1207, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

############################
##PLOT THE THING
##############################

##so finally, function plot2: 
##a histogram of Global Active Power (red bars)
##with the main title: "Global Active Power" and x-label: "Global Active Power (kilowatts)"
plot3 <- function() {
  png("plot3.png")
  ##have to make sure the days of the week appear as "thu", "fri", "sat" and not in Dutch translation
  Sys.setlocale("LC_TIME", "English")
  plot(subsetFeb1207$timestamp, subsetFeb1207$Sub_metering_1, type="l", xlab="", ylab="Energy Submetering")
  points(subsetFeb1207$timestamp, subsetFeb1207$Sub_metering_2, type="l", col="red")
  points(subsetFeb1207$timestamp, subsetFeb1207$Sub_metering_3, type="l", col="blue")
  legend("topright", col = c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1), lwd=c(1,1))         
  dev.off()
}
plot3()
