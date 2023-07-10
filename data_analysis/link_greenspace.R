##gets greenspace by census block and creates ndvi.rds which is ndvi values at observation locations

library(ipumsr)
library(sf)
library(rgdal)
library(sp)
library(magrittr)
library(raster)
library(dplyr)

out = readRDS('out.rds')

shape <- readOGR(dsn = "tl_2017_06_tabblock10.shp") 
shape$GEOID10 = as.numeric(shape$GEOID10)

greenspace <- read.csv("NDVI_Block_CA_2013.csv" ) %>% rename(GEOID10 = blockid10)

dat = merge(shape@data, greenspace, by = 'GEOID10')
ord = match(shape@data$GEOID10, dat$GEOID10)
shape@data = dat[ord,]

saveRDS(shape, 'shape.rds')


y = over(out %>% spTransform(crs(shape)),shape)
saveRDS(y, 'ndvi.rds')

