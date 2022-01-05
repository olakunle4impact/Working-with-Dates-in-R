### Working with dates and time in R
library(lubridate)
today()
now()
x <- "1991-09-24"
str(x)
dob <- as.Date(x)
str(dob)
kdob <- as.Date("05/08/1996", format = "%m/%d/%Y")
str(kdob)
y <- "2021-01-10"
pd <- as.Date(y)
str(pd)

pd-dob
10701/365
dob>pd
pd>dob

## POSIXct: for time component
time1 <- as.POSIXct("2021-01-10 01:05:42")
time1
time2 <- as.POSIXct("1991-09-24 03:25:39", tz = "GMT") #specify time zone
time2
time1>time2
time1-time2

## Get Standard dates
ymd("2017-02-28") ## In case when year comes first
ymd(20170131)
mdy("January 31st, 2012") ## when month comes first
mdy("Jan 29,1992")
mdy(01302000)
dmy("12-08-2016") #when dates comes first
dmy("12th February, 1993")

ymd_hm("2018-07-05 12:40", tz = "UTC")
mdy("Mar 5, 2005", tz = "GMT")

pz <- read.csv("2.1 PlotNDMI.csv")
head(pz)
class(pz)
pz$date2 <- dmy(pz$Date) # creating a new column with standard date
head(pz)

datime <- ymd_hms("2004-08-03 19:23:45")
datime
## getting individual components
year(datime)
month(datime)
mday(datime)

pz$Year <- year(pz$date2) # year component
pz$Month <- month(pz$date2) # month component
head(pz)

pzNDMI <- aggregate(NDMI~Month+Year, pz, mean) ## nice code
head

library(nycflights13)
library(tidyverse)
library(dplyr)

flights %>%
  select(year, month, day, hour, minute, arr_time)

## combining individual bits
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = make_datetime(year, month, day, hour, minute))
## the above codes will help convert our date to standard date

##  PLOTTING TEMPORARL DATA IN R
stk <- read.csv("3.1 5stocks.csv")
head(stk, n=10)
tail(stk, n=10)
ncol(stk)

stkmove <- stk[,2:6]
## the code above is important before doing time series
head(stkmove)
stkmove <- na.omit(stkmove)

## convert data to a time series/ts object
skts <- ts(stkmove, start = c(2001, 7), end = c(2015,5), frequency = 12)
## ts is from the base package. We use 12 because its a monthly data and all
# months were represented.
# for yearly data, frequency is 1 and for quarterly 4
plot(skts)

start(skts)
end(skts)
frequency(skts)

## subsetting time series (June 2014 to April 2017)
skts2 <- window(skts, start = c(2014, 6), end = c(2017, 3))
plot(skts2)
plot.ts(skts2)

library(devtools)
install_github('sinhrks/ggfortify')
require(ggfortify) ## help plot ts object in ggplot)
autoplot(skts)
autoplot(skts, facets = FALSE) ##time series on one plot

library(xts)
autoplot(as.xts(skts), ts.colour = 'green')

## Moving Averages ###
day <- read.csv("5.1 day.csv", header = T, stringsAsFactors = FALSE)
head(day)

day$Date <- as.Date(day$dteday)
ggplot(day, aes(Date, cnt)) + geom_line() + scale_x_date('month') + 
  ylab("Daily Bike Checkouts") +
  xlab("")
count_ts <- ts(day[, c('cnt')])

## remove outliers, extreme values and missing values
