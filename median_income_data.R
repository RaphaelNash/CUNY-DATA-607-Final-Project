library('httr')
library('stringr')
library('XML')
library(dplyr)
library(tidyr)

download.file('https://www.census.gov/did/www/saipe/downloads/estmod14/est14ALL.txt','~/Documents/CUNY/data_class/project-final/census2014.txt',method='libcurl')
test<-read.table('~/Documents/CUNY/data_class/project-final/census2014.txt',header=FALSE, sep="",skip=2,fill=TRUE,na.strings="NA")


#metadata... including column headers
readme<-GET('https://www.census.gov/did/www/saipe/downloads/estmod14/readme.txt')
readme.t<-content(readme,as='text')
cont<-str_split(readme.t,'-{3,}')
fg<-cont[[1]][[3]]
gf<-str_split(fg,'\r\n *[[:digit:]]')
gf[1]


tgt.data<-test[,c(1:4,21:23)]
names(tgt.data)<-c('st.code','cnty.code','all.poverty','poverty.lwr.bound','med.inc','med.inc.lwr','med.inc.uppr')

tgt.1<-tgt.data[!tgt.data$med.inc=='',]
sapply(tgt.1,class)
#state code is stored in tgt.1 as a factor with appropriate leading 0s, but written to file (as .csv) as an integer and leading 0s are dropped
as.numeric.factor<-function(x) {as.numeric(levels(x))[x]}

tgt.2<-tgt.1[,c(1,2)] %>%
  mutate_if(is.factor,as.character)
tgt.3<-tgt.1[,-c(1,2)] %>%
  mutate_if(is.factor,as.numeric.factor)
  

tgt.4<-as.data.frame(c(tgt.2,tgt.3),stringsAsFactors = F)
sapply(tgt.4,class)
head(tgt.4)
write.table(tgt.4,'~/Documents/CUNY/data_class/project-final/median2014.txt',sep=",",row.names=FALSE)