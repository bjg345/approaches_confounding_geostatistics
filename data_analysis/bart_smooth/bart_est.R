
bart_est = function(dat, ind, shift){

 
	  
  suppressMessages(require(dbarts))
  suppressMessages(require(mgcv))
  suppressMessages(require(dplyr))
  dat <- dat[ind, ]
  
  
  mumod = bart(dat %>% select(-bw), y.train = dat$bw, keeptrees=T, ndpost=5000, keepevery=5)
  
  mu.fitted.shift = colMeans( predict(mumod, dat %>% mutate(pm25 = pm25+shift)) )
  mu.fitted = fitted(mumod)
  mu_qr = mean(mu.fitted.shift)
 
  rm(mumod)	
 
  pimod = bart(dat %>% select(-c(bw, pm25)), y.train = dat$pm25, keeptrees=T, ndpost=5000, keepevery=5)
  resid = dat$pm25 - fitted(pimod)
  d_mod = density(resid)
  
  dens_est = function(dat.temp) approx(d_mod$x, d_mod$y, 
                                     dat.temp$pm25 - colMeans(predict(pimod, dat.temp)) )$y

  lambda = function(dat.temp) dens_est(dat.temp %>% mutate(pm25 = pm25-shift))/dens_est(dat.temp)

  comp_model = lm(dat$bw ~ lambda(dat) + offset(mu.fitted)+0)
  gamma_hat = coef(comp_model)
  
  mean(mu.fitted.shift + gamma_hat*lambda(dat %>% mutate(pm25=pm25+shift))) - mean(dat$bw)

}
