library('httr')
library('stringr')
library('XML')
library('stringr')

download.file('https://www.census.gov/did/www/saipe/downloads/estmod14/est14ALL.txt','~/Documents/CUNY/data_class/project-final/census2014.txt',method='libcurl')
test<-read.table('~/Documents/CUNY/data_class/project-final/census2014.txt',header=FALSE, sep="",skip=2,fill=TRUE)


#metadata... including column headers
readme<-GET('https://www.census.gov/did/www/saipe/downloads/estmod14/readme.txt')
readme.t<-content(readme,as='text')
cont<-str_split(readme.t,'-{3,}')
fg<-cont[[1]][[3]]
gf<-str_split(fg,'\r\n *[[:digit:]]')
gf[1]


tgt.data<-test[,c(1:4,21:23)]
names(tgt.data)<-c('st.code','cnty.code','all.poverty','poverty.lwr.bound','med.inc','med.inc.lwr','med.inc.uppr')