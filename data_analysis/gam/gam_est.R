
gam_est = function(dat, ind, shift, vars){

  
	  
  suppressMessages(require(dbarts))
  suppressMessages(require(mgcv))
  suppressMessages(require(dplyr))
  suppressMessages(require(magrittr))
  dat <- dat[ind, ]
  
  formula.base = "age+sex+kotl_index+educ+race_eth+income+parity"
  
  formula.add = switch(vars, 'all' = '+ndvi+s(lat,lon)', 'ndvi' = '+ndvi', 
  'spatial'='+s(lat,lon)', 'none' = '')
  
  formula = paste0(formula.base, formula.add) 
  
  mumod = mgcv::gam(paste0('bw~',paste0('s(pm25)+', formula)) %>% as.formula, data = dat) #spatial term from this model for vars=spatial is where smooth in dat_norm_smooth comes from (after normalization)
  
  mu.fitted.shift = predict(mumod, dat %>% mutate(pm25 = pm25+shift)) 
  mu.fitted = mumod$fitted.values
  mu_qr = mean(mu.fitted.shift)
  
 
  folder = switch(vars, 'all'='alladj', 'ndvi'='ndviadj', 'spatial'='spatialadj', 'none'='unadj')
  if(seed == 1) saveRDS(mumod, file.path(folder,'mumod.rds')) 
  rm(mumod)	
 
  pimod = mgcv::gam(paste0('pm25 ~', formula) %>% as.formula(), data = dat)
  resid = dat$pm25 - pimod$fitted.values
  d_mod = density(resid)
  
  dens_est = function(dat.temp) approx(d_mod$x, d_mod$y, 
                                     dat.temp$pm25 - predict(pimod, dat.temp) )$y

  lambda = function(dat.temp) dens_est(dat.temp %>% mutate(pm25 = pm25-shift))/dens_est(dat.temp)

  comp_model = lm(dat$bw ~ lambda(dat) + offset(mu.fitted)+0)
  gamma_hat = coef(comp_model)
  
  mean(mu.fitted.shift + gamma_hat*lambda(dat %>% mutate(pm25=pm25+shift))) - mean(dat$bw)

}
