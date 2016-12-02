library(foreign)
library(dplyr)
library(tidyr)

#Merge FIPS county and state from geo shape files with median income information

# read meadian2014.csv I used colClasses and stringsAsFactors to make sure everything stayed
# in the formats that I saved it in the the meadian_income_data.r

median.inc<-read.csv('./median2014.csv', stringsAsFactors = FALSE,
                     colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric")) 

centroids<-read.dbf('./county_centroids.dbf')
  
cnty.shp<-read.dbf('./cnty_2010_data.dbf')

names(centroids)
names(cnty.shp)

head(centroids) #GEOID... 5 digits
head(cnty.shp) #fips... 5 digits
head(median.inc)
 
median.inc$fips <- paste(median.inc$st.code, median.inc$cnty.code, sep ="")

#test that we created suitable field with which to merge (but we must do it in QGIS)
legit<-inner_join(median.inc, cnty.shp)

nrow(legit)