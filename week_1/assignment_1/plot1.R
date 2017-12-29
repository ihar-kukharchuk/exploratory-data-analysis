text_data_file <- "household_power_consumption.txt"

## retrieve data
zip_data_file <- "household_power_consumption.zip"
data_url <-
        "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists(text_data_file) && !file.exists(zip_data_file)) {
        download.file(data_url, zip_data_file, method = "auto")
}
if (!file.exists(text_data_file) && file.exists(zip_data_file)) {
        unzip(zip_data_file)
}
if (!file.exists(text_data_file)) {
        stop("there is not household power consumption data to process")
}

## read data
hpc_data <- read.table(
        text_data_file,
        header = TRUE,
        sep = ";",
        stringsAsFactors = FALSE,
        na.strings = "?"
)

## prepare dataset
hpc_data <- subset(hpc_data, grepl("^[1,2]{1}/2/2007", Date))
hpc_data[, -(1:2)] <- sapply(hpc_data[, -(1:2)], as.numeric)

## create image with global active power
png(filename = "plot1.png",
    width = 480,
    height = 480)
hist(
        hpc_data$Global_active_power,
        xlab = "Global Active Power (kilowatts)",
        ylab = "Frequency",
        main = "Global Active Power",
        col = "red"
)
dev.off()