library(foreign)
library(dplyr)
library(tidyr)

#Merge FIPS county and state from geo shape files with median income information

median.inc<-read.csv('~/Documents/CUNY/data_class/project-final/median2014.csv')

centroids<-read.dbf('~/Documents/CUNY/data_class/project-final/county_shapefiles/county_centroids.dbf')
  
cnty.shp<-read.dbf('~/Documents/CUNY/data_class/project-final/county_shapefiles/cnty_2010_data.dbf')

names(centroids)
names(cnty.shp)

head(centroids) #GEOID... 5 digits
head(cnty.shp) #fips... 5 digits
head(median.inc)
g<-sapply(median.inc$cnty.code,length)
sapply(median.inc,class)
max(median.inc$cnty.code) #3 digit max

#in order to merge, need to insert a 0 in front of state code to ensure a 2-digit length... county code must be 3 digits
test<-median.inc %>%
  mutate_if(is.integer, as.character)

gh<-sapply(sapply(test$st.code,length),function(x) if (x==1) '0' else '')

min(sapply(test$cnty.code,nchar))
max(sapply(test$cnty.code,nchar))
nchar(test$cnty.code[6])

hd<-sapply(sapply(test$cnty.code,nchar),function(x) 
  if (x==1) {
    '00'
    } else if(x==2) {
      '0'
      }   else 
        ''
  )

#concatenate vectors: gh with test$st.code & hd w/test$cnty.code
first<-paste0(gh,test$st.code)
sec<-paste0(hd,test$cnty.code)
test$t.fips<-paste0(first,sec)

#test that we created suitable field with which to merge (but we must do it in QGIS)
legit<-merge(test,cnty.shp,by.x='t.fips',by.y='fips')
