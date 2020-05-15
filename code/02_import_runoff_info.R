library(data.table)

runoff_info <- readRDS('./data/raw/runoff_eu_info.rds')

runoff_info[, sname := factor(abbreviate(Station))]
runoff_info[, id := factor(ID)]
runoff_info[, lat := round(Lat, 3)]
runoff_info[, lon := round(Lon, 3)]
runoff_info[, alt := round(Alt, 0)]

saveRDS(runoff_info, './data/runoff_info_raw.rds')
