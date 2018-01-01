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
hpc_data$datetime <-
        strptime(paste(hpc_data$Date, hpc_data$Time, sep = "|"),
                 format = "%d/%m/%Y|%H:%M:%S")

## create image with energy sub metering
png(filename = "plot3.png",
    width = 480,
    height = 480)
plot(
        x = hpc_data$datetime,
        y = hpc_data$Sub_metering_1,
        xlab = "",
        ylab = "Energy sub metering",
        col = "black",
        type = "l"
)
with(hpc_data, lines(x = datetime, y = Sub_metering_2, col = "red"))
with(hpc_data, lines(x = datetime, y = Sub_metering_3, col = "blue"))
legend(
        "topright",
        legend = names(hpc_data[7:9]),
        lty = c(1, 1, 1),
        col = c("black", "red", "blue")
)
dev.off()