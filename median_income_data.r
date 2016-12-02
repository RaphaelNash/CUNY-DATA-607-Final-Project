library ("readr")

#I started out thinking that using a fixed width reader would preserve the leading zero's because it
#does so in COBOL, apparently in R this does not work.  There is nothing wrong whith using REGEX like you did 
# I just thought I would try this, as you can see lines 47 and 48 are your same lines of code.  

test <-  read.fwf(file = 'https://www.census.gov/did/www/saipe/downloads/estmod14/est14ALL.txt',
         widths = c(2, 
                    -1, 3, 
                    -1,7,
                    -1, 9 ,
                    -1, 8,
                    -1, 4,
                    -1,4,
                    -1,4,
                    -1,8,
                    -1,8,
                    -1,8,
                    -1,4,
                    -1,4,
                    -1,4,
                    -1,8,
                    -1,8,
                    -1, 8,
                    -1,4,
                    -1,4,
                    -1,4,
                    -1,6,
                    -1,6,
                    -1,6,
                    -1,7,
                    -1,7,
                    -1,7,
                    -1,4,
                    -1,4,
                    -1,4,
                    -1,44,
                    -2,2
                    )) 



tgt.data<-test[,c(1:4,21:23)]
names(tgt.data)<-c('st.code','cnty.code','all.poverty','poverty.lwr.bound','med.inc','med.inc.lwr','med.inc.uppr')

#Use FormatC to pad Zeros and convert integer from int to string
tgt.data$st.code <- formatC(tgt.data$st.code, width = 2, format = "d", flag = "0")
tgt.data$cnty.code <- formatC(tgt.data$cnty.code, width = 3, format = "d", flag = "0")

#make sure all numeric data is numeric before saving or R will put it in quotes in the CSV file
#and this will cause issues on read

tgt.data$all.poverty <- as.numeric(tgt.data$all.poverty)
tgt.data$poverty.lwr.bound <- as.numeric(tgt.data$poverty.lwr.bound)
tgt.data$med.inc <- as.numeric(tgt.data$med.inc)
tgt.data$med.inc.lwr <- as.numeric(tgt.data$med.inc.lwr)
tgt.data$med.inc.uppr <- as.numeric(tgt.data$med.inc.uppr)
 
#get rid of summary records that are not at the county level
tgt.data <- tgt.data[ which(tgt.data$cnty.code !='000'),]


write.csv(tgt.data,'./median2014.csv',row.names=FALSE)


 
