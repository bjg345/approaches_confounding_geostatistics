library(tidyverse)
library(boot)

dir = 'ndviadj'
if(!dir.exists(dir)) dir.create(dir)

seed = as.numeric(commandArgs(trailingOnly=T))
set.seed(seed)

out.file = file.path(dir, paste0('est_', seed, '.rds'))
if(file.exists(out.file)) quit()

source('bart_est.R')

dat = readRDS('dat_norm_smooth.rds') %>% select(-c(smooth)) 
n = nrow(dat)

dat.temp = readRDS('dat.rds')
scale = sd(dat.temp$pm25)

if(seed == 1){
	ind = 1:n
} else{
	ind = sample.int(n, n, T)
}

est = bart_est(dat, shift=.1/scale, ind=ind)
#est = boot(dat, bart_est, shift=-1, R=120, ncpus=8, parallel='multicore')

saveRDS(est, out.file)
