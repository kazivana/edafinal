library(data.table)

runoff_day <- readRDS('./data/raw/runoff_eu_day.rds')

runoff_day

runoff_day[, date := as.Date(date)]
