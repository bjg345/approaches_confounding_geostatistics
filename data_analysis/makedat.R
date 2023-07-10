#creates analysis data frame from income, ndvi, and exposure data

library(dplyr)

income = readRDS('income.rds')
ndvi = readRDS('ndvi.rds')
out = readRDS('out.rds')

dat = out@data %>% mutate(lon = out@coords[,1], lat = out@coords[,2], income = income$JQBE001, ndvi = ndvi$NDVI) %>%
	filter(CA_DaysGestation > 7*22 & CA_DaysGestation < 7*44) %>%
	rename(sex = natCA_CSex, age = natCA_DMAge, bw = natCA_DBirWt, educ = CA_MEduc) %>%
	mutate(sex = as.factor(sex), race_eth = as.factor(race_eth), parity = as.factor(parity), kotl_index = as.factor(kotl_index), educ=as.factor(educ)) %>%
	select(bw, age, sex, kotl_index, educ, race_eth, lat, lon, pm25, income, parity, ndvi) %>% 
	filter(bw < 9999, bw >= 500, age >= 15, age < 50, sex != 9, educ !=9)


dat = dat[complete.cases(dat),]


saveRDS(dat, 'dat_bart.rds')
