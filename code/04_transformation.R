library(data.table)
library(ggplot2)
library(mapview)
library(sf)

color_set <- c('#A85CCE', '#5E5CCE', '#6CA6DE', '#6DD9B2', '#6DD972', '#C3E558')

runoff_stations_day <- readRDS('./data/runoff_stations_day.rds')
runoff_stations_year <- readRDS('./data/runoff_stations_year.rds')

# summary stats

runoff_day_stats <- runoff_stations_day[, .(mean_day = round(mean(value), 0),
                                            sd_day = round(sd(value), 0),
                                            min_day = round(min(value), 0),
                                            max_day = round(max(value), 0)), by = Country]

head(runoff_day_stats, 5)

ggplot(runoff_stations_day, aes(value)) +
  geom_histogram(fill = '#A85CCE') +
  facet_wrap(~River, scales = 'free') +
  theme_bw()

ggplot(runoff_stations_day, aes(value)) +
  geom_histogram(fill = '#A85CCE') +
  facet_wrap(~Country, scales = 'free') +
  theme_bw()

# discretization 


runoff_day_stats_class <- runoff_day_stats[, .(Country,
                                               mean_day)]
runoff_day_stats_class[, runoff_class := factor('low')]
runoff_day_stats_class[mean_day >= 1000 & mean_day < 2000, runoff_class := factor('medium')]
runoff_day_stats_class[mean_day >= 2000, runoff_class := factor('high')]

runoff_stations_day[, alt_class := factor('small')]
runoff_stations_day[alt >= 50 & alt < 400, alt_class := factor('medium')]
runoff_stations_day[alt >= 400, alt_class := factor('high')]

to_merge_country <- runoff_day_stats_class[, .(Country, runoff_class)]
runoff_summary <- runoff_stations_day[to_merge_country, on = 'Country']

runoff_summary

# Aggregation

runoff_stations_day[, year := year(date)]
runoff_stations_day[, month := month(date)]

runoff_month <- runoff_stations_day[, .(value = mean(value)), by = .(month, year, Country)]
runoff_month[, date := as.Date(paste0(year, '-', month, '-1'))]

ggplot(runoff_month, aes(factor(month), value)) +
  geom_boxplot(fill = color_set[4]) +
  facet_wrap(~Country, scales = 'free') +
  theme_bw()

runoff_year <- runoff_stations_day[, .(value = mean(value)), by = .(year, Country)]

ggplot(runoff_year[year > 1950], aes(year, value)) +
  geom_line(col = color_set[1]) +
  geom_point(col = color_set[2]) +
  facet_wrap(~Country, scales = 'free') +
  theme_minimal()

runoff_year_river <- runoff_stations_day[, .(value = mean(value)), by = .(year, River)]

runoff_year

ggplot(runoff_year_river[year > 1950], aes(year, value)) +
  geom_line(col = color_set[1]) +
  geom_point(col = color_set[2]) +
  facet_wrap(~River, scales = 'free') +
  theme_minimal()

runoff_stations_day[month == 12 | month == 1 | month == 2, season := 'winter']
runoff_stations_day[month == 3 | month == 4 | month == 5, season := 'spring']
runoff_stations_day[month == 6 | month == 7 | month == 8, season := 'summer']
runoff_stations_day[month == 9 | month == 10 | month == 11, season := 'autumn']
runoff_stations_day[, season := factor(season, levels = c('winter', 'spring', 'summer', 'autumn'))]

runoff_year[, value_norm := (value - mean(value)) / sd(value), by = Country]
n_stations <- nrow(runoff_summary)

ggplot(runoff_year[year > 1980], aes(year, value_norm, col = Country)) +
  geom_line() +
  geom_point() +
  scale_color_manual(values = colorRampPalette(color_set)(n_stations)) +
  theme_bw()

runoff_winter <- runoff_stations_day[season == 'winter',
                                     .(value = mean(value)),
                                     by = .(Country, year)]
runoff_summer <- runoff_stations_day[season == 'summer',
                                     .(value = mean(value)),
                                     by = .(Country, year)]

# map

cz_runoff_day <- runoff_stations_day[Country == 'CZ']
de_runoff_day <- runoff_stations_day[Country == 'DE']
se_runoff_day <- runoff_stations_day[Country == 'SE']
is_runoff_day <- runoff_stations_day[Country == 'IS']
no_runoff_day <- runoff_stations_day[Country == 'NO']


stations_coords_sf_cz <- st_as_sf(cz_runoff_day,
                               coords = c('lon', 'lat'))

mapview(stations_coords_sf_cz, map.types = 'Stamen.TerrainBackground')

# not enough memory to create the maps :( 

saveRDS(runoff_summary, './data/runoff_summary.rds')
saveRDS(runoff_day_stats, './data/runoff_day_stats.rds')
saveRDS(runoff_day, './data/runoff_day.rds')
saveRDS(runoff_month, './data/runoff_month.rds')
saveRDS(runoff_year, './data/runoff_year.rds')
saveRDS(runoff_winter, './data/runoff_winter.rds')
saveRDS(runoff_summer, './data/runoff_summer.rds')
saveRDS(cz_runoff_day, './data/cz_runoff_day.rds')
saveRDS(se_runoff_day, './data/se_runoff_day.rds')
saveRDS(de_runoff_day, './data/de_runoff_day.rds')
saveRDS(is_runoff_day, './data/is_runoff_day.rds')
saveRDS(no_runoff_day, './data/no_runoff_day.rds')
saveRDS(runoff_year_river, './data/runoff_year_river.rds')
saveRDS(runoff_day_stats, './data/runoff_day_stats.rds')
