library(foreign)
library(dplyr)
library(tidyr)

#Merge FIPS county and state from geo shape files with median income information

#first import the data
median.inc<-read.csv('~/Documents/CUNY/data_class/project-final/median2014.csv')
cls<-c(st.code="character",cnty.code="character")
median.inc.t<-read.table('~/Documents/CUNY/data_class/project-final/median2014.txt',sep=',',stringsAsFactors = F,header=T,colClasses = cls)

sapply(median.inc.t,class) #lots of fields need to change datatype

#I made centroids separately in QGIS; these will be used within QGIS... not paramount to work with it now
centroids<-read.dbf('~/Documents/CUNY/data_class/project-final/county_shapefiles/county_centroids.dbf')
#shapefiles of the actual counties - I will build a cluster analysis on this layer in QGIS
cnty.shp<-read.dbf('~/Documents/CUNY/data_class/project-final/county_shapefiles/cnty_2010_data.dbf')
sapply(cnty.shp,class) #importantly - 'fips' is a factor and needs to be changed to character
names(centroids)
names(cnty.shp)

head(centroids) #target 'GEOID' field... 5 digits
head(cnty.shp) #target 'fips' for merging... 5 digits
head(median.inc)

#let's determine the treatment required of the median.inc table & cnty.shp to facilitate a merge on the "target" fields specified above
#we explore the characteristics of the county and state codes in the median.inc table
g<-sapply(median.inc$cnty.code,length)
sapply(median.inc,class)
max(median.inc$cnty.code) #3 digit max

#here we fill a vector w/the required number of '0's in order to normalize for later merging w/shapefiles
hd<-sapply(sapply(median.inc.t$cnty.code,nchar),function(x) 
  if (x==1) {
    '00'
    } else if(x==2) {
      '0'
      }   else 
        ''
  )

#concatenate vectors: gh with test$st.code & hd w/test$cnty.code
sec<-paste0(hd,median.inc.t$cnty.code)
#final product: 5 digit fips codes
median.inc.t$t.fips<-paste0(median.inc.t$st.code,sec)

#test that we created suitable field with which to merge (but we must do it in QGIS)
legit<-merge(median.inc.t,cnty.shp,by.x='t.fips',by.y='fips')
write.csv(median.inc.t[c(3:8)],'~/Documents/CUNY/data_class/project-final/treatedMedian2014.csv',row.names = F)