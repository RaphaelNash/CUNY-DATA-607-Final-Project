library(foreign)
library(dplyr)
library(tidyr)

#Merge FIPS county and state from geo shape files with median income information

#first import the data
median.inc<-read.csv('~/Documents/CUNY/data_class/project-final/median2014.csv')

#I made centroids earlier; these will be used within QGIS... not paramount to work with it now
centroids<-read.dbf('~/Documents/CUNY/data_class/project-final/county_shapefiles/county_centroids.dbf')
#shapefiles of the actual counties - I will build a cluster analysis on this layer in QGIS
cnty.shp<-read.dbf('~/Documents/CUNY/data_class/project-final/county_shapefiles/cnty_2010_data.dbf')

names(centroids)
names(cnty.shp)

head(centroids) #target 'GEOID' field... 5 digits
head(cnty.shp) #target 'fips' for merging... 5 digits
head(median.inc)

#let's determine the treatment required of the median_income table to facilitate a merge with the shapefile on the "target" fields specified above
#we explore the characteristics of the county and state codes in the median.inc table
g<-sapply(median.inc$cnty.code,length)
sapply(median.inc,class)
max(median.inc$cnty.code) #3 digit max

#in order to merge, need to insert a '0' in front of state code to ensure a 2-digit length... county code must be 3 digits... concatenating these should facilitate merging w/the shapefiles
test<-median.inc %>%
  mutate_if(is.integer, as.character)

#a vector of '0's or blanks that we concatenate to the st.code vector in order to normalize
gh<-sapply(sapply(test$st.code,length),function(x) if (x==1) '0' else '')
#determine min and max length of the county codes within the median.inc table:
min(sapply(test$cnty.code,nchar))
max(sapply(test$cnty.code,nchar))
nchar(test$cnty.code[6])

#like the vector we created above, here we fill a vector w/the required number of '0's in order to normalize for later merging w/shapefiles
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
#final product: 5 digit fips codes
test$t.fips<-paste0(first,sec)

#test that we created suitable field with which to merge (but we must do it in QGIS)
legit<-merge(test,cnty.shp,by.x='t.fips',by.y='fips')
