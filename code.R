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

# 1.Code for reading in the dataset and/or processing the data
# Read in data from file
data <- read.csv(file=file.loc,header = TRUE, na.strings = "NA")

# Column Type Conversation
data$date <- as.Date(data$date, "%Y-%m-%d")

# Check for total row count
# nrow(data) = 17568

# 2.Histogram of the total number of steps taken each day
# Summary of steps by date
steps.by.date.sum <- with(data, aggregate(steps ~ date, FUN=sum))
hist(x = steps.by.date$steps, breaks=10, ylab="Count", xlab="Steps", main = "Steps by Date")

# 3.Mean and median number of steps taken each day
median.steps.by.date <- median(steps.by.date$steps, na.rm=T)
mean.steps.by.date <- mean(steps.by.date$steps, na.rm=T)

# 4.Time series plot of the average number of steps taken
steps.by.interval.mean <- with(data, aggregate(steps~interval, FUN=mean))
ggplot(steps.by.interval.mean,aes(interval, steps)) + geom_line() + title(main = "Average Steps By Time Interval")

# 5.The 5-minute interval that, on average, contains the maximum number of steps
steps.by.interval.mean[which.max(steps.by.interval.mean$steps),]

# 6.Code to describe and show a strategy for imputing missing data

## Profile the data set to understand quantum of missing data
table(is.na(data$steps))

## Determine logics to impute missing value. In this example, I just impute with 0 for the variable
data[is.na(data$steps),c("steps")] <- 0


# 7.Histogram of the total number of steps taken each day after missing values are imputed
steps.by.date.sum <- with(data, aggregate(steps ~ date, FUN=sum))
hist(x = steps.by.date$steps, breaks=10, ylab="Count", xlab="Steps", main = "Steps by Date")


# 8.Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends
data$weekend <- weekdays(data$date) %in% c("Saturday","Sunday")

data.weekend <-subset(data, weekend==TRUE)
data.weekday <-subset(data, weekend==FALSE)

data.weekend.mean <- aggregate(steps ~ interval, data.weekend, mean,na.rm=TRUE)
data.weekend.mean$weekend <- "WEEKEND"
data.weekday.mean <- aggregate(steps ~ interval, data.weekday, mean,na.rm=TRUE)
data.weekday.mean$weekend <- "WEEKDAY"

data.weekend.weekday <- rbind(data.weekend.mean, data.weekday.mean)


ggplot(data.weekend.weekday,aes(interval, steps)) + geom_line() + facet_grid(~weekend)+ title(main = "Average Steps By Time Interval") 



# 9.All of the R code needed to reproduce the results (numbers, plots, etc.) in the report


