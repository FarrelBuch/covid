# covid fread tutorial

library(data.table)
library(ggplot2)

mydt <- fread(input = "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv", select = c("date", "county", "state", "cases"), colClasses = c("date" = "Date"))
mydt <- mydt[state == "Pennsylvania" & (county == "Allegheny" | county == "Montgomery")]

mydt[, new.past14day:= c(rep(NA, times=14), diff(cases, lag = 14)), by = county]
pop.mont <- 830915
pop.alleg <- 1216000


mydt[county == "Montgomery", new.past14.per100000 := 100000*new.past14day/pop.mont]
mydt[county == "Allegheny", new.past14.per100000 := 100000*new.past14day/pop.alleg]

ggplot(data = mydt , aes(x = date, y = new.past14.per100000)) + geom_point() + facet_wrap(vars(county))
ggplot(data = mydt[county == "Allegheny"] , aes(x = date, y = new.past14day)) + geom_point()

# something change just to change