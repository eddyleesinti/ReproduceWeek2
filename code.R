# File Location and URL
data.dir <- "./data"
file.loc <- paste(data.dir, "activity.csv",sep = "/")

# One time file download and directory creation
if (!file.exists(data.dir)) {
        dir.create(data.dir)
        source.file.url<-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"        
        download.file(source.file.url, "source.zip",method = "curl")
        unzip(zipfile="source.zip",exdir = data.dir)
}

# Read in data from file
data <- read.table(file=file.loc,sep = ",",header = TRUE, na.strings = "NA")

# Check for total row count
# nrow(data) = 17568




