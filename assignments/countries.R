library(data.table)
library(ggplot2)

runoff_year <- readRDS('./data/runoff_stations_year.rds')
runoff_day <- readRDS('./data/runoff_stations_day.rds')

color_set <- c('#A85CCE', '#5E5CCE', '#6CA6DE', '#6DD9B2', '#6DD972', '#C3E558')

# 5 countries, annual runoff post 1980.

unique(runoff_year$Country)
runoff_year

runoff_year_country <- runoff_year[Country == 'CH' | Country == 'DE' | Country == 'FI' | Country == 'SE' | Country == 'NO']

#LQ
ggplot(runoff_year_country[Year > 1980 & Year < 2011], aes(factor(Year), LQ)) +
  geom_boxplot(fill = color_set[4]) +
  facet_wrap(~Country, scales = 'free') +
  theme_bw() +
  ggtitle('Runoff per Country - Low Flow')

#MQ
ggplot(runoff_year_country[Year > 1980 & Year < 2011], aes(factor(Year), MQ)) +
  geom_boxplot(fill = color_set[1]) +
  facet_wrap(~Country, scales = 'free') +
  theme_bw() +
  ggtitle('Runoff per Country - Mean Flow')

#HQ
ggplot(runoff_year_country[Year > 1980 & Year < 2011], aes(factor(Year), HQ)) +
  geom_boxplot(fill = color_set[6]) +
  facet_wrap(~Country, scales = 'free') +
  theme_bw() +
  ggtitle('Runoff per Country - High Flow')


