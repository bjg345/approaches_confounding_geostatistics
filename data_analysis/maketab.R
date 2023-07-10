## tabulate results

require(mgcv)
require(xtable)
require(tidyverse)

lin.mods = data.frame(model = 'Linear/GAM', adjustment = c("Neither", "NDVI", "Spatial location", "Both"), estimate = NA)
gam.mods = data.frame(model = 'Non-linear/GAM (DML)', adjustment = c("Neither", "NDVI", "Spatial location", "Both"), estimate = NA)
bart.smooth.mods = data.frame(model = 'BART - smooth (DML)', adjustment = c("Spatial location", "Both"), estimate = NA)
bart.mods = data.frame(model = 'BART (DML)', adjustment = c("Neither", "NDVI", "Spatial location", "Both"), estimate = NA)

setwd('gam')
dat = readRDS('dat.rds')
scale = sd(dat$pm25)
load('linear.models.Rdata')
temp.est = coef(unadj.mod)[2] / scale * .1
temp.sd = vcov(unadj.mod)[2,2]^.5 / scale * .1
lin.mods$estimate[1] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                   digits=2), ')')
temp.est = coef(ndviadj.mod)[2] / scale * .1
temp.sd = vcov(ndviadj.mod)[2,2]^.5 / scale * .1
lin.mods$estimate[2] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                   digits=2), ')')
temp.est = coef(spatialadj.mod)[2] / scale * .1
temp.sd = vcov(spatialadj.mod)[2,2]^.5 / scale * .1
lin.mods$estimate[3] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                   digits=2), ')')
temp.est = coef(alladj.mod)[2] / scale * .1
temp.sd = vcov(alladj.mod)[2,2]^.5 / scale * .1
lin.mods$estimate[4] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                   digits=2), ')')

temp.ests = lapply(1:121, function(i) readRDS(file.path('unadj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
gam.mods$estimate[1] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                                                 digits=2), ')')


temp.ests = lapply(1:121, function(i) readRDS(file.path('ndviadj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
gam.mods$estimate[2] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                                                 digits=2), ')')


temp.ests = lapply(1:121, function(i) readRDS(file.path('spatialadj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
gam.mods$estimate[3] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                                                 digits=2), ')')


temp.ests = lapply(1:121, function(i) readRDS(file.path('alladj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
gam.mods$estimate[4] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                                                 digits=2), ')')
setwd('../bart_smooth')

temp.ests = lapply(1:121, function(i) readRDS(file.path('spatialadj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
bart.smooth.mods$estimate[1] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd, digits=2), ')')

temp.ests = lapply(1:121, function(i) readRDS(file.path('alladj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
bart.smooth.mods$estimate[2] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,  digits=2), ')')

setwd('../bart')

temp.ests = lapply(1:121, function(i) readRDS(file.path('unadj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
bart.mods$estimate[1] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                                                         digits=2), ')')

temp.ests = lapply(1:121, function(i) readRDS(file.path('ndviadj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
bart.mods$estimate[2] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                                                         digits=2), ')')

temp.ests = lapply(1:121, function(i) readRDS(file.path('spatialadj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
bart.mods$estimate[3] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                                                         digits=2), ')')

temp.ests = lapply(1:121, function(i) readRDS(file.path('alladj', paste0('est_', i, '.rds')))) %>% unlist()
temp.est = temp.ests[1]
temp.sd = sd(temp.ests)
bart.mods$estimate[4] = paste0(formatC(format='f', temp.est, digits=2), ' (', formatC(format='f', temp.est-1.96*temp.sd, digits=2), ', ', formatC(format='f', temp.est+1.96*temp.sd,
                                                                                                                                                  digits=2), ')')                                                                                                                                                        

setwd('..')

df = rbind(lin.mods, gam.mods, bart.mods, bart.smooth.mods)
names(df) = c('Method', 'Adjustment', 'Estimate')

tab = xtable(df)

print(tab, file = 'tab.txt', include.rownames = F)
