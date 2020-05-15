library(data.table)
library(ggplot2)

runoff_info <- readRDS('./data/runoff_info_raw.rds')
runoff_day <- readRDS('./data/runoff_day_raw.rds')
runoff_year <- readRDS('./data/runoff_year_raw.rds')


runoff_station_day <- merge(runoff_info, runoff_day, by = "id")
runoff_station_day

runoff_station_year <- merge(runoff_info, runoff_year, by = 'id')
runoff_station_year


CZ_runoff_day <- runoff_station_day[Country == "CZ"]

ggplot(data = CZ_runoff_day) +
  geom_line(aes(x = date, y = value))

ggplot(data = CZ_runoff_day) +
  geom_point(aes(x = date, y = value))

ggplot(data = CZ_runoff_day,
       aes(x = date, y = value)) +
  geom_point() +
  geom_line()

RU_CZ_runoff_day <- runoff_station_day[Country == 'CZ' | Country == "RU"]

ggplot(RU_CZ_runoff_day, aes(date, value)) +
  geom_line() +
  facet_wrap(~ Country) +
  theme_bw()

missing_value <- runoff_station_day[value < 0, .(missing = .N), by = Country]

sample_size <- runoff_station_day[, .(size = .N), by = sname]
runoff_station_day <- runoff_station_day[sample_size, on = 'sname']
runoff_station_day[is.na(missing), missing := 0]
runoff_station_day[, missing := missing /size]
runoff_station_day[, missing := round(missing, 3)]
setcolorder(runoff_station_day,
            c(setdiff(names(runoff_station_day), 'missing'), 'missing'))

runoff_station_day <- runoff_station_day[value >= 0]

ggplot(CZ_runoff_day, aes(date, value)) +
  geom_line() +
  geom_point() +
  theme_bw()

max_year <- max(runoff_station_year$Year)
min_year <- max_year - 60

country_time <- runoff_station_day[, .(start = min(year(date)),
                                       end = max(year(date))),
                                   by = Country]


runoff_station_day <- runoff_station_day[country_time, on = 'Country']
runoff_station_day <- runoff_station_day[start <= min_year &
                                           end >= max_year &
                                           size >= 30 * 2 * 365]

runoff_station_day <- runoff_station_day[id %in% runoff_statio_day$id]
runoff_station_day <- runoff_station_day[year(date) <= 2014]

saveRDS(runoff_station_day, './data/runoff_stations_day.rds')
saveRDS(runoff_station_year, './data/runoff_stations_year.rds')
