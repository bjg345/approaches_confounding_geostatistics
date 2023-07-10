library(lubridate) day0 <- as_date('20121231') data_string = 'aqdh-pm2-5-concentrations-contiguous-us-1-km-2000-2016-' out_dir = 'cumsums' 
if (! dir.exists(out_dir)) dir.create(out_dir) for(i in 1:730){
  
  day = day0 + i
  
  ymd_string = gsub('-', "", toString(day))
  
  ym_string = ymd_string %>% substring(1,6)
  
  day_raster = raster(file.path(paste0(data_string, ym_string, '-geotiff'),
                                paste0(ymd_string, '.tif')))
  
  ext = extent(-2.3e6, -1.55e6, -6.4e5, 5.7e5)
  
  day_raster = crop(day_raster, ext)
  
  if(i == 1) cumsum = day_raster
  
  else cumsum = overlay(cumsum, day_raster, fun = sum)
  
  saveRDS(cumsum, file.path(out_dir, paste0(ymd_string, '.rds')))
  
  print(i)
    
}
