library(data.table)
library(mapview)
library(sf)
library(plyr)

runoff_info <- readRDS('./data/runoff_info.rds')
runoff_info

##############################################################################################################

## Q1: where are the stations located

stations_coords <- st_as_sf(runoff_info,
                                  coords = c('Lon', 'Lat'),
                            crs = 4326)

mapview(stations_coords, map.types = 'Stamen.TerrainBackground')

## A1:The stations are scattered throughout Europe. Higher concentrations of stations in the Nordics and DE

##############################################################################################################


## Q2: How many stations/rivers per country


stations_per_country <- runoff_info[, .(Station), by = Country]
stations_df <- as.data.frame(table(stations_per_country))
stations_df

stations_df_table <- ddply(stations_df, "Country", numcolwise(sum))
stations_df_table

## A2a: The table shows us Germany has the most stations, 78, followed by
# NO and SE, and CH afterwards in the 20s. FI has 16 and the rest <10. 19 countries total.


station_river_country <- runoff_info[,2:4]
station_river_country

river_country <- runoff_info[,3:4]
river_country

melt(river_country, id.vars = 'Country')

fr <- river_country[Country == 'FR']
unique(fr$River)
# 1 river in France
cz <- river_country[Country == 'CZ']
unique(cz$River)
# 4 rivers in Czech R
sk <- river_country[Country == 'SK']
unique(sk$River)
# 2 rivers in Slovakia
se <- river_country[Country == 'SE']
unique(se$River)
# 26 rivers in Sweden
de <- river_country[Country == 'DE']
unique(de$River)
# 54 rivers in Germany
is <- river_country[Country == 'IS']
unique(is$River)
# 2 rivers in Iceland
nl <- river_country[Country == 'NL']
unique(nl$River)
# 2 rivers in netherlands
hu <- river_country[Country == 'HU']
unique(hu$River)
# 1 river in Hungary
pl <- river_country[Country == 'PL']
unique(pl$River)
# 1 river in poland
rs <- river_country[Country == 'RS']
unique(rs$River)
# 2 rivers in Serbia
gb <- river_country[Country == 'GB']
unique(gb$River)
# 4 rivers in UK
no <- river_country[Country == 'NO']
unique(no$River)
# 23 rivers in Norway
ro <- river_country[Country == 'RO']
unique(ro$River)
# 2 rivers in Romania
fi <- river_country[Country == 'FI']
unique(fi$River)
# 10 rivers in Finland
dk <- river_country[Country == 'DK']
unique(dk$River)
# 5 rivers in Denmark
ch <- river_country[Country == 'CH']
unique(ch$River)
# 16 rivers in Switzerland
ru <- river_country[Country == 'RU']
unique(ru$River)
# 7 rivers in Russia
lt <- river_country[Country == 'LT']
unique(lt$River)
# 1 river in Latvia
ua <- river_country[Country == 'UA']
unique(ua$River)
# 1 river in Ukraine

## A2b: The distribution of the rivers per country is seen above

###########################################################################

## Q3: How many stations exist per river?

station_river <- station_river_country[,1:2]
stations_per_river <- station_river[, .N, by = 'River']

stations_per_river

## A3: The no of stations per river varies depending on size, from only 1 or 2
# to multiple and > 10. 

###########################################################################


########## other attempts below, unused code ##########

rivers_per_country <- runoff_info[, .(River), by = Country]
rivers_df <- as.data.frame(table(rivers_per_country))
rivers_df

rivers_df_table <- ddply(rivers_df, 'Country', numcolwise(sum))
rivers_df_table

# Quick check to see stations per river, since the no of rivers is suspiciously identical to the no of stations

stations_per_river <- runoff_info[, .(Station), by = River]
stations_per_river_df <- as.data.frame(table(stations_per_river))

ddply(stations_per_river_df, 'River', numcolwise(sum))

country_per_river <- runoff_info[, .(Country), by = River]
country_per_river_df <- as.data.frame(table(country_per_river))

ddply(country_per_river_df, 'River', numcolwise(sum))


rivers_per_country[, .N, by = Country]
stations_per_country[, .N, by = Country]
stations_per_river[, .N, by = River]

runoff_info_de <- runoff_info[Country == 'DE']
unique(runoff_info_de$River)

# there are 54 unique River values, while above I am getting 78 (no of stations)

unique_river <- runoff_info[, .(unique(runoff_info$River)), by = Country]
unique_river[, .N, by = Country]

rivers_tidy <- melt(rivers_per_country, id.vars = 'Country')