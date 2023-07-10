## normalize covariates

library(dplyr)

dat = readRDS('dat.rds')

normalize = function(x) (x-mean(x))/sd(x)

dat.norm = mutate(dat, lat=normalize(lat), lon=normalize(lon), pm25=normalize(pm25), age=normalize(age), ndvi=normalize(ndvi), income=normalize(income))

saveRDS(dat.norm, 'dat_norm.rds')
print(names(dat.norm))
