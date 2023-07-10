library(tidyverse)
library(boot)

dir = 'spatialadj'
if(!dir.exists(dir)) dir.create(dir)

seed = as.numeric(commandArgs(trailingOnly=T))
set.seed(seed)

out.file = file.path(dir, paste0('est_', seed, '.rds'))
if(file.exists(out.file)) quit()

source('gam_est.R')

dat = readRDS('dat_norm.rds') 
n = nrow(dat)

dat.temp = readRDS('dat.rds')
scale = sd(dat.temp$pm25)

if(seed == 1){
	ind = 1:n
} else{
	ind = sample.int(n, n, T)
}

est = gam_est(dat, shift=.1/scale, ind=ind, vars = 'spatial')

saveRDS(est, out.file)
