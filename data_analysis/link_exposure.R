library(tidyverse)
library(parallel)
library(magrittr)
library(raster)
library(sp)
library(dplyr)

births <- read.csv('bir0615_xy_modifiedrawvars.csv')

births <- mutate(births, DOB = as.Date(DOB, '%m/%d/%Y'), conception = DOB -
                   CA_DaysGestation) %>%
  filter(format(conception, '%Y')==2013, CA_DaysGestation <= 44*7 & CA_DaysGestation >= 22*7) %>%
  mutate(exposure_cohort = interaction(conception, CA_DaysGestation)) 




births.red = select(births, unique_id, exposure_cohort, X, Y)
saveRDS(births.red, 'births.red.rds')

cohorts = unique(births.red$exposure_cohort) %>% as.vector()

get_exposure = function(ec){
  
  births.red = readRDS('births.red.rds')
  
  dat = filter(births.red, exposure_cohort==ec) %>% droplevels()
  
  day = strsplit(ec, '\\.')[[1]][1] %>% as.Date() - 1
  
  gestation = strsplit(ec, '\\.')[[1]][2] %>% as.numeric()
  
  start = gsub('-', "", toString(day)) 
  end = gsub('-', "", toString(day + gestation + 1)) 
  
  if(start == '20121231'){
    
    diff = readRDS(file.path('cumsums', paste0(end, '.rds')))
    coords = dat[,c('X','Y')]
    spdf = SpatialPointsDataFrame(coords, dat,
                                  proj4string=CRS("+proj=longlat +datum=WGS84"))
    
    out<-raster::extract(diff, spdf, method="simple", sp=T) %>% as.data.frame() %>%
      rename(pm25 = layer) %>% mutate(pm25 = pm25/(gestation+1))
    
    return(out)
    
  } else{
    
    start_cumsum = readRDS(file.path('cumsums', paste0(start, '.rds')))
    end_cumsum = readRDS(file.path('cumsums', paste0(end, '.rds')))
    
    diff = overlay(start_cumsum, end_cumsum, fun = function(a,b) b-a)
    
    coords = dat[,c('X','Y')]
    spdf = SpatialPointsDataFrame(coords, dat,
                                  proj4string=CRS("+proj=longlat +datum=WGS84"))
    
    out<-raster::extract(diff, spdf, method="simple", sp=T) %>% as.data.frame() %>%
      rename(pm25 = layer) %>% mutate(pm25 = pm25/(gestation+1))
  
    return(out)
  }
  
}

cl <- makeCluster(30)
clusterExport(cl, list('get_exposure', 'cohorts'))
clusterEvalQ(cl, {
  library(sp)
  library(dplyr)
  library(raster)
  library(magrittr)
  })

pm25_linked <- do.call(rbind, parLapply(cl, cohorts, get_exposure)) 

saveRDS(pm25_linked, 'pm25_linked.rds')


dat <- merge(births, pm25_linked, by = 'unique_id')

#not using this greenspace data anymore!! but does exist in out.rds

greenspace <- raster('NAIP 2020 NDVI, California.tiff')
extent(greenspace) = c(-1.38528908903E7, -1.27037018903E7,3828732.2941999976,5170895.294199998)
#https://map.dfg.ca.gov/ArcGIS/rest/services/Base_Remote_Sensing/NAIP_2012_NDVI/ImageServer
crs(greenspace)<-'+proj=webmerc +datum=WGS84'

spdf <- SpatialPointsDataFrame(dat[,c('X.x','Y.y')], dat,
                               proj4string=CRS("+proj=longlat +datum=WGS84"))
out <- raster::extract(greenspace, spdf, method='simple', sp=T)

saveRDS(out, 'out.rds')
 
