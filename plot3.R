# load the data.table library. Will need this to use the fread command for reading the files
library(data.table)
# load the deplyr library. Useful for manipulating data frames and data tables. 
library(dplyr)

# Assume that the file is already downloaded and unzipped in the R Working Directory
# The unzipped file is named as household_power_consumption.txt.

# Since the dataset is large, read the required data only for 2007-02-01 and 2007-02-02.
# The data is sampled at 1 min interval so this should equate to a maximum of 2*24*60 = 2880 records
# Start reading from 1/2/2007 using skip argument and read 2880 rows using nrows argument.
# This unfortunately skips the header record.See workaround later to assign the column names.
electricConsumption_Df <- fread("household_power_consumption.txt", na.strings="?", blank.lines.skip=TRUE, skip = "1/2/2007", nrows=2880)

#Read a couple of lines from the file to get the column names from the header
columnNames_Df <- fread("household_power_consumption.txt", na.strings="?", blank.lines.skip=TRUE, nrows=2)

#Assign Column Names to the first Data Table
colnames(electricConsumption_Df) <- colnames(columnNames_Df)

#Concatenate the Date and Time columns together to create a new column and convert it to Date/time tyoe
electricConsumption_Df <- mutate(electricConsumption_Df, Date_Time=paste(Date,Time))
electricConsumption_Df$Date_Time <- strptime(electricConsumption_Df$Date_Time, "%d/%m/%Y %H:%M:%S")

#Line plots for Sub_metering_* versus time
png(filename = "plot3.png", width = 480, height = 480)
with(electricConsumption_Df, plot(Date_Time, Sub_metering_1 , type="l", xlab = "", ylab = "Energy sub metering"))
with(electricConsumption_Df, lines(Date_Time, Sub_metering_2, col="red"))
with(electricConsumption_Df, lines(Date_Time, Sub_metering_3, col="blue"))
legend("topright", lty = 1, col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()




