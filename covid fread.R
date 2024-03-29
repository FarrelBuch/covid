# covid fread tutorial

library(data.table)
library(ggplot2)


mydt <- fread(input = "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv", select = c("date", "county", "state", "cases"), colClasses = c("date" = "Date"))
mydt <- mydt[state == "Pennsylvania" & (county == "Allegheny" | county == "Montgomery" | county == "Beaver"| county == "Butler")]

mydt[, new.past14day:= c(rep(NA, times=14), diff(cases, lag = 14)), by = county]
pop.mont <- 830915
pop.alleg <- 1216000
pop.beav <- 163929
pop.but <- 187853

thanksgiving <- as.IDate("2020-11-26")
christmas <- as.IDate("2020-12-25")
newyear <- as.IDate("2021-01-01")

# control for different population per county so that it is all per capita
mydt[county == "Montgomery", new.perday.per100000 := 100000*new.past14day/pop.mont/14]
mydt[county == "Allegheny", new.perday.per100000 := 100000*new.past14day/pop.alleg/14]
mydt[county == "Beaver", new.perday.per100000 := 100000*new.past14day/pop.beav/14]
mydt[county == "Butler", new.perday.per100000 := 100000*new.past14day/pop.but/14]



ggplot(data = mydt , aes(x = date, y = new.perday.per100000)) + geom_point() + facet_wrap(vars(county))
ggplot(data = mydt[county == "Allegheny" | county == "Beaver"] , aes(x = date, y = new.perday.per100000)) + geom_point()  + facet_wrap(vars(county))
ggplot(data = mydt[county == "Allegheny" | county == "Butler"] , aes(x = date, y = new.perday.per100000)) + geom_point()  + facet_wrap(vars(county)) + labs(title = "Average number of new cases in preceding two weeks")
ggplot(data = mydt[county == "Allegheny"] , aes(x = date, y = new.past14day)) + geom_point()
ggplot(data = mydt[date >= as.IDate("2021-04-30") & county == "Allegheny"] , aes(x = date, y = new.past14day)) + geom_point()

ggplot(data = mydt[county == "Allegheny" | county == "Butler"] , aes(x = date, y = log(new.perday.per100000))) + geom_point()  + facet_wrap(vars(county)) + labs(title = "Average number of new cases in preceding two weeks")
ggplot(data = mydt[county == "Allegheny"] , aes(x = date, y = log10(new.past14day))) + geom_point() + geom_hline(yintercept = quantile(mydt[county == "Allegheny", log10(new.past14day)], .4, na.rm = TRUE)) # the best graph, Allegheny County, log10



# when were things really good

mydt[date %between% c("2020-05-15", "2020-07-15") & county == "Allegheny", .SD[which.min(new.past14day)]] # first valley
mydt[date %between% c("2020-07-31", "2020-12-01") & county == "Allegheny", .SD[which.min(new.past14day)]] # second valley
mydt[county == "Allegheny", .SD[which.max(date)]]

mydt[county == "Allegheny", quantile(new.past14day, probs = 0.4, na.rm = TRUE)]
# Adam sure knows his git

# checking out access 2022-01-30 22:28

