library(ggplot2)

nei_rds_data_file <- "summarySCC_PM25.rds"
scc_rds_data_file <- "Source_Classification_Code.rds"

## retrieve data in working directory
zip_data_file <- "NEI_data.zip"
data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if ((!file.exists(nei_rds_data_file) || !file.exists(scc_rds_data_file)) &&
    !file.exists(zip_data_file)) {
        download.file(data_url, zip_data_file, method = "auto")
}
if ((!file.exists(nei_rds_data_file) || !file.exists(scc_rds_data_file)) &&
    file.exists(zip_data_file)) {
        unzip(zip_data_file)
}
if (!file.exists(nei_rds_data_file) || !file.exists(scc_rds_data_file)) {
        stop("there is not NEI or SCC data to process")
}

## read data
NEI <- readRDS(nei_rds_data_file)
SCC <- readRDS(scc_rds_data_file)

## prepare dataset
NEI_baltimore_md <- subset(NEI, fips == "24510")

## create image with total PM2.5 emission per type per year
png(filename = "plot3.png", width = 480, height = 480)
chart <-
        ggplot(NEI_baltimore_md, aes(year, Emissions, color = type)) +
        geom_line(stat = "summary", fun.y = "sum") +
        geom_point(stat = "summary", fun.y = "sum", size = 1) +
        xlab("Year") +
        ylab("Total PM2.5 Emission (tons)") +
        ggtitle("Total PM2.5 Emission Per Year Per Type In Baltimore, MD")
print(chart)
dev.off()