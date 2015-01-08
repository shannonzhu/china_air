#!/bin/bash

formattedDate=`date +'%Y%m%d'`
echo $formattedDate

curl -o /tmp/$formattedDate-01.tar 'http://aqi.cga.harvard.edu/china/'$formattedDate'010000.tar'
curl -o /tmp/$formattedDate-09.tar 'http://aqi.cga.harvard.edu/china/'$formattedDate'090000.tar'
curl -o /tmp/$formattedDate-17.tar 'http://aqi.cga.harvard.edu/china/'$formattedDate'170000.tar'

#tar --extract --file=/tmp/$formattedDate-01.tar --directory=/tmp aqi.csv
#mv /tmp/aqi.csv /tmp/$formattedDate-01.csv
#rm /tmp/$formattedDate-01.tar

tar --extract --file=/tmp/$formattedDate-01.tar --directory=/tmp aqi.csv
tail -n +2 /tmp/aqi.csv >> /tmp/air.csv
rm /tmp/$formattedDate-01.tar /tmp/aqi.csv

tar --extract --file=/tmp/$formattedDate-09.tar --directory=/tmp aqi.csv
tail -n +2 /tmp/aqi.csv >> /tmp/air.csv
rm /tmp/$formattedDate-09.tar /tmp/aqi.csv

tar --extract --file=/tmp/$formattedDate-17.tar --directory=/tmp aqi.csv
tail -n +2 /tmp/aqi.csv >> /tmp/air.csv
rm /tmp/$formattedDate-17.tar /tmp/aqi.csv
