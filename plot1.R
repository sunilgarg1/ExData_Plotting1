# load the data.table library. Will need this to use the fread command for reading the files
library(data.table)
# load the deplyr library. Useful for manipulating data frames and data tables. 
library(dplyr)

# Download the Zip file with data to the R working directory. Will download and unzip for the first plot only.
electricConsumptionDataFileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(electricConsumptionDataFileURL,"household_power_consumption.zip", mode = "wb")

# unzip the file in the working directory. This will extract the files with the folder structure present in the zip file
unzip("household_power_consumption.zip")

# The unzipped file is named as household_power_consumption.txt.


# Estimate of memory required 
# There are 7 numeric columns: 8 bytes per numeric. There are two character fields date and time with a total of 18 characters
# approxMemoryRequired = no. of numeric columns * no. of rows * 8 + no. of characters * no. of rows
approxMemoryRequiredGB <- ((7*2075259*8)+(18*2075259))/(2^30)
# Have sufficient memory


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

#Histogram for Global_active_power
png(filename = "plot1.png", width = 480, height = 480)
hist(electricConsumption_Df$Global_active_power, xlab="Global Active Power (kilowatts)", ylab="Frequency", main = "Global Active Power", col = "red")
dev.off()

