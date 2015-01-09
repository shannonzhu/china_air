#!/bin/bash

# Set directory that we are storing the new files in
dir=/tmp/

# Format current date as a string
formattedDate=`date +'%Y%m%d'`

# Download the 3 data files for the day
curl -o $dir$formattedDate-01.tar 'http://aqi.cga.harvard.edu/china/'$formattedDate'010000.tar'
curl -o $dir$formattedDate-09.tar 'http://aqi.cga.harvard.edu/china/'$formattedDate'090000.tar'
curl -o $dir$formattedDate-17.tar 'http://aqi.cga.harvard.edu/china/'$formattedDate'170000.tar'

# Set output file name
outname=$formattedDate.csv

# Start output file with headers
echo locationid,stationname,chinesename,latitude,longitude,pm25,pm10,o3,no2,so2,co,temperature,dewpoint,pressure,humidity,wind,est_time > $dir$outname

# Extract the 3 aqi.csv data files from the tar files, add the data to the output file, then clean up
tar --extract --file=$dir$formattedDate-01.tar --directory=/tmp aqi.csv
tail -n +2 ${dir}aqi.csv >> $dir$outname
rm $dir$formattedDate-01.tar ${dir}aqi.csv

tar --extract --file=$dir$formattedDate-09.tar --directory=/tmp aqi.csv
tail -n +2 ${dir}aqi.csv >> $dir$outname
rm $dir$formattedDate-09.tar ${dir}aqi.csv

tar --extract --file=$dir$formattedDate-17.tar --directory=/tmp aqi.csv
tail -n +2 ${dir}aqi.csv >> $dir$outname
rm $dir$formattedDate-17.tar ${dir}aqi.csv
