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
SCC_motor <- subset(SCC, grepl("motor", Short.Name, ignore.case = TRUE))
NEI_baltimore_md_motor <- subset(NEI, SCC %in% SCC_motor$SCC & fips == "24510")
NEI_total_emission_per_year_baltimore_md_motor <-
        aggregate(Emissions ~ year, NEI_baltimore_md_motor, sum)

## create image with total PM2.5 emission per year from motor vehicle sources
png(filename = "plot5.png", width = 480, height = 480)
plot(
        x = NEI_total_emission_per_year_baltimore_md_motor$year,
        y = NEI_total_emission_per_year_baltimore_md_motor$Emissions,
        xlab = "Year",
        ylab = "Total PM2.5 Emission (tons)",
        main = "Total PM2.5 Emission Per Year In Baltimore, MD\n[Motor Vehicle Sources]",
        col = "blue",
        type = "l"
)
dev.off()