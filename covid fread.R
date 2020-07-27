# covid fread tutorial

library(data.table)
library(ggplot2)

setwd("~")

mydt <- fread(input = "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv", select = c("date", "county", "state", "cases"), colClasses = c("date" = "Date"))
mydt <- mydt[county == "Allegheny"]
mydt[, new.past14day:= c(rep(NA, times=14), diff(cases, lag = 14))]

mydt[, ggplot( mapping = aes(x = date, y = new.past14day)) + geom_point() ]

# change 2020-07-27 17:19