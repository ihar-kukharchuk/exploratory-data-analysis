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

## prepare dataset (better to replace 'motor' to 'vehicle' here)
SCC_motor <- subset(SCC, grepl("motor", Short.Name, ignore.case = TRUE))
NEI_ca_md_motor <- subset(NEI, SCC %in% SCC_motor$SCC & (fips == "24510" | fips == "06037"))

## create image with total PM2.5 emission per year
## from motor vehicle sources for Los Angeles, CA and Baltimore, MD
png(filename = "plot6.png", width = 480, height = 480)
chart <-
        ggplot(NEI_ca_md_motor, aes(year, Emissions, color = fips)) +
        geom_line(stat = "summary", fun.y = "sum") +
        geom_point(stat = "summary", fun.y = "sum", size = 1) +
        xlab("Year") +
        ylab("Total PM2.5 Emission (tons)") +
        scale_colour_discrete(name = "County", label = c("Los Angeles, CA","Baltimore, MD")) +
        ggtitle("Total PM2.5 Emission Per Year In Baltimore, MD and Los Angeles, CA\n\t\t\t\t[Motor Vehicle Sources]")
print(chart)
dev.off()