library(data.table)

runoff_info <- readRDS('./data/raw/runoff_eu_info.rds')
runoff_day <- readRDS('./data/raw/runoff_eu_day.rds')
runoff_year <- readRDS('./data/raw/runoff_eu_year.rds')

runoff_info
runoff_day
runoff_year

saveRDS(runoff_info, './data/runoff_info.rds')
saveRDS(runoff_day, './data/runoff_day.rds')
saveRDS(runoff_Year, '.data/runoff_year.rds')

