#!/bin/bash

# Download all the files listed on the site
wget -r -np http://aqi.cga.harvard.edu/china/

# Start the air.csv with headers; this file will contain all our data
echo locationid,stationname,chinesename,latitude,longitude,pm25,pm10,o3,no2,so2,co,temperature,dewpoint,pressure,humidity,wind,est_time > air.csv

# Loop through the tar files
for filename in ./*.tar; do
	# Just extract the aqi.csv file, nothing else
	tar --extract --file=$filename aqi.csv
	
	# Add the data to air.csv, but skip the first line which is headers
	tail -n +2 aqi.csv >> air.csv
	
	# Done with tar file and aqi.csv, so remove them
	rm $filename aqi.csv
done

# Then, remove other junk wget downloaded from the site
rm AQI_feb_legend.jpg China_AQI_from_VGI_2014.pdf DataDictionary_AQI_units.xls README.txt header.csv
rm -rf about
