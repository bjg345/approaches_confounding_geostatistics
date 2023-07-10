#fit models with linear effects

library(mgcv)

dat = readRDS('dat_bart.rds')
scale = sd(dat$pm25)

dat = readRDS('dat_bart_norm.rds')

unadj.mod = lm(data=dat, bw~pm25+age+sex+kotl_index+educ+race_eth+income+parity)
ndviadj.mod = lm(data=dat, bw~pm25+age+sex+kotl_index+educ+race_eth+income+parity+ndvi)
spatialadj.mod = gam(data=dat, bw~pm25+age+sex+kotl_index+educ+race_eth+income+parity+s(lat,lon))
alladj.mod = gam(data=dat, bw~pm25+age+sex+kotl_index+educ+race_eth+income+parity+ndvi+s(lat,lon))

save.image('linear.models.Rdata')

coef(unadj.mod)[2]/scale/10
confint(unadj.mod)[2,]/scale/10

coef(ndviadj.mod)[2]/scale/10
confint(ndviadj.mod)[2,]/scale/10

coef(spatialadj.mod)[2]/scale/10
1/scale/10*(coef(spatialadj.mod)[2]-1.96*sqrt(vcov(spatialadj.mod)[2,2]))
1/scale/10*(coef(spatialadj.mod)[2]+1.96*sqrt(vcov(spatialadj.mod)[2,2]))

coef(alladj.mod)[2]/scale/10
1/scale/10*(coef(alladj.mod)[2]-1.96*sqrt(vcov(alladj.mod)[2,2]))
1/scale/10*(coef(alladj.mod)[2]+1.96*sqrt(vcov(alladj.mod)[2,2]))


cor(predict(spatialadj.mod,type='terms')[,9], dat$ndvi)
