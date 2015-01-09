#!/bin/bash

# Download all the files listed on the site
#wget -r -np http://aqi.cga.harvard.edu/china/
#mv aqi.cga.harvard.edu/china/* .
#rm -rf aqi.cga.harvard.edu

# Loop through the tar files
i=0
for filename in ./*.tar; do
	# Just extract the aqi.csv file, nothing else
	tar --extract --file=$filename aqi.csv

	if [ $i -eq 0 ]
	then
		# Generate output file name
		outname=${filename%??????????}.csv
		
		# Start each csv file with headers
		echo locationid,stationname,chinesename,latitude,longitude,pm25,pm10,o3,no2,so2,co,temperature,dewpoint,pressure,humidity,wind,est_time > $outname
	fi
	
	# Add the data to air.csv, but skip the first line which is headers
	tail -n +2 aqi.csv >> $outname
	
	# Done with tar file and aqi.csv, so remove them
	rm $filename aqi.csv
	
	if [ $i -eq 2 ] 
	then
		i=0
	else
		((i++))
	fi
	
done

# Then, remove other junk wget downloaded from the site
rm AQI_feb_legend.jpg China_AQI_from_VGI_2014.pdf DataDictionary_AQI_units.xls README.txt header.csv index.htm*
rm -rf about
