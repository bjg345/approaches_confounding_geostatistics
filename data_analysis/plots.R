## make plots

library(rspatial)
library(rgdal)
library(scales)
library(rgeos)
library(ggplot2)
library(viridis)

dat = readRDS('dat_bart.rds')

webmerc = crs('+proj=webmerc +datum=WGS84')

counties <- sp_data('counties.rds')

counties = spTransform(counties, webmerc)
county.fort <- fortify(counties, region='COUNTY')

#pm25

pm25_plot = ggplot(county.fort, aes(x = long, y = lat, group = id)) + 
  geom_polygon(colour='black', fill='white') +
  geom_point(data = data.frame(temp = 1:nrow(dat)), aes(dat$lat, dat$lon, colour = dat$pm25), alpha = .01, inherit.aes = F) +
  scale_color_viridis(name='pm2.5') +
  xlim(extent(counties)[1:2]) + ylim(extent(counties)[3:4]) +
  ggtitle('average daily pm2.5 exposure')


ndvi_plot = ggplot(county.fort, aes(x = long, y = lat, group = id)) + 
  geom_polygon(colour='black', fill='white') +
  geom_point(data = dat, aes(lat, lon, colour = ndvi), alpha = .01, inherit.aes = F) +
  scale_color_viridis(name ='NVDI') +  
  xlim(extent(counties)[1:2]) + ylim(extent(counties)[3:4]) +
  ggtitle('ndvi')

bw_hist = ggplot(dat, aes(x=bw))+geom_histogram()+ggtitle('birthweight histogram')

ndvi_hist = ggplot(dat, aes(x=ndvi))+geom_histogram()+ggtitle('ndvi histogram')

pm25_bw_plot = ggplot(data = dat,
       aes(x = pm25, y = bw)) + geom_point( alpha = .1)  + ggtitle('pm25 and birthweight')

income_bw_plot = ggplot(data = dat, 
       aes(x = income, y = bw)) + geom_point( alpha = .1) + ggtitle('income and birthweight')

pm25_bw_sex_plot = ggplot(data = dat, 
       aes(x = pm25, y = bw)) + geom_point( alpha = .1) + facet_wrap(~sex) + ggtitle('pm2.5 - birthweight by sex')

pm25_bw_ki_plot = ggplot(data = dat, 
       aes(x = pm25, y = bw)) + geom_point( alpha = .1) + facet_wrap(~kotl_index) + ggtitle('pm2.5 - birthweight by kotelchuck index')

pm25_bw_parity_plot = ggplot(data = dat, 
       aes(x = pm25, y = bw)) + geom_point( alpha = .1) + facet_wrap(~parity) + ggtitle('pm2.5 - birthweight by parity')

pm25_bw_race_plot = ggplot(dat,  
       aes(x = pm25, y = bw)) + geom_point( alpha = .1) + facet_wrap(~race_eth) + ggtitle('pm2.5 - birthweight by race/ethnicity')

save.image('plots.Rdata')
