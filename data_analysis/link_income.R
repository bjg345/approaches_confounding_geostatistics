#link income data from NHGIS to observations

library(ipumsr)
library(sf)
library(rgdal)
library(sp)
library(magrittr)
library(raster)
library(dplyr)

out <- readRDS("out.rds")

cens.income = readRDS('cens.income.rds')
#cens.income= read_nhgis_sf('nhgis0002_ds176_20105_tract.csv', 'nhgis0002_shape.zip')
#cens.income=cens.income[!st_is_empty(cens.income),,drop=FALSE]
#cens.income = as(cens.income, 'Spatial')
#cens.income = cens.income[cens.income@data$STATE == 'California',]

cens.income = spTransform(cens.income, crs(out))

k = ceiling(nrow(out) / 200)
splits = list()
for(i in 1:(k-1)){
  
  splits[i] = out[(1+200*(i-1)):(200*i),]
  
}
splits[[k]] = out[(1+200*(k-1)):nrow(out),]

x = do.call(rbind,
            lapply(splits, function(df) extract(cens.income, df)) 
)
saveRDS(x, 'income.rds')

