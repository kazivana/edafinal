library(data.table)
library(ggplot2)

cz_runoff_day <- readRDS('./data/cz_runoff_day.rds')
de_runoff_day <- readRDS('./data/de_runoff_day.rds')
is_runoff_day <- readRDS('./data/is_runoff_day.rds')
no_runoff_day <- readRDS('./data/no_runoff_day.rds')
se_runoff_day <- readRDS('./data/se_runoff_day.rds')
runoff_day <- readRDS('./data/runoff_day.rds')
runoff_day_stats <- readRDS('./data/runoff_day_stats.rds')
runoff_month <- readRDS('./data/runoff_month.rds')
runoff_stations_day <- readRDS('./data/runoff_stations_day.rds')
runoff_stations_year <- readRDS('./data/runoff_stations_year.rds')
runoff_summary <- readRDS('./data/runoff_summary.rds')
runoff_summer <- readRDS('./data/runoff_summer.rds')
runoff_winter <- readRDS('./data/runoff_winter.rds')
runoff_year <- readRDS('./data/runoff_year.rds')
runoff_year_river <- readRDS('./data/runoff_year_river.rds')

color_set <- c('#A85CCE', '#5E5CCE', '#6CA6DE', '#6DD9B2', '#6DD972', '#C3E558')
n_stations <- nrow(runoff_summary)
theme_set(theme_bw())

runoff_winter
runoff_summer
runoff_day_stats
runoff_day
runoff_stations_day

year_thres <- 1980

runoff_summer[year < year_thres, period := factor('pre 2000')]
runoff_summer[year >= year_thres, period := factor('post 2000')]
runoff_winter[year < year_thres, period := factor('pre 2000')]
runoff_winter[year >= year_thres, period := factor('post 2000')]

bind_to_plot <- rbind(cbind(runoff_winter, season = factor('winter')),
                      cbind(runoff_summer, season = factor('summer')))

ggplot(bind_to_plot, aes(season, value, fill = period)) +
  geom_boxplot() +
  facet_wrap(~Country, scales = 'free_y') +
  scale_fill_manual(values = color_set[c(4,3)]) +
  xlab('Season') +
  ylab('Runoff (m3/s)') +
  theme_bw()

ggplot(bind_to_plot[year > 1950], aes(season, value, fill = period)) +
  geom_boxplot() +
  facet_wrap(~Country, scales = 'free_y') +
  scale_fill_manual(values = color_set[c(5,6)]) +
  xlab('Season') +
  ylab('Runoff (m3/s)') +
  theme_bw()

ggplot(runoff_summer, aes(x = year, y = value)) +
  geom_line(col = color_set[3]) +
  geom_point(col = color_set[5]) +
  facet_wrap(~Country, scales = 'free') +
  geom_smooth(method = 'lm', formula = y~x, se = 0, col = color_set[1]) +
  geom_smooth(method= 'loess', formula = y~x, se = 0, col = color_set[2]) +
  scale_color_manual(values = color_set[c(4, 5, 6)]) +
  xlab('Year') +
  ylab('Runoff (m3/s)')+
  theme_bw()

ggplot(runoff_winter, aes(x = year, y = value)) +
  geom_line(col = color_set[3]) +
  geom_point(col = color_set[5]) +
  facet_wrap(~Country, scales = 'free') +
  geom_smooth(method = 'lm', formula = y~x, se = 0, col = color_set[1]) +
  geom_smooth(method= 'loess', formula = y~x, se = 0, col = color_set[2]) +
  scale_color_manual(values = color_set[c(4, 5, 6)]) +
  xlab('Year') +
  ylab('Runoff (m3/s)')+
  theme_bw()

runoff_winter[, value_norm := scale(value), Country]
runoff_summer[, value_norm := scale(value), Country]

ggplot(runoff_winter[year > 1950], aes(x = year, y = value_norm, col = Country)) +
  geom_smooth(method = 'loess', formula = y~x, se = 0) +
  scale_color_manual(values = colorRampPalette(color_set)(n_countries)) +
  ggtitle('Winter runoff') +
  xlab('Year') +
  ylab('Runoff (m3/s)') +
  theme_bw()

ggplot(runoff_summer[year > 1950], aes(x = year, y = value_norm, col = Country)) +
  geom_smooth(method = 'loess', formula = y~x, se = 0) +
  scale_color_manual(values = colorRampPalette(color_set)(n_countries)) +
  ggtitle('Winter runoff') +
  xlab('Year') +
  ylab('Runoff (m3/s)') +
  theme_bw()

year_thres <- 1980
to_plot <- rbind(cbind(runoff_winter, season = factor('winter')), 
                 cbind(runoff_summer, season = factor('summer'))) 

to_plot[year < year_thres, period := factor('1950-1980')]
to_plot[year >= year_thres, period := factor('1981-2016')]
to_plot[year < year_thres, period := factor('1950-1980')]
to_plot[year >= year_thres, period := factor('1981-2016')]

to_plot <- to_plot[year >= 1950]

ggplot(to_plot, aes(season, value, fill = period)) +
  geom_boxplot() +
  facet_wrap(~Country, scales = 'free_y') +
  scale_fill_manual(values = color_set[c(4, 1)]) +
  xlab(label = "Season") +
  ylab(label = "Runoff (m3/s)") +
  theme_bw()
