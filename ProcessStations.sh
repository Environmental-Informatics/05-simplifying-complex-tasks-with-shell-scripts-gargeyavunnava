#!/bin/bash
# Gargeya Vunnava 2/21/2020

#Looking for data in the directory 'Station data' which is stored as a variable 'dir'
dir="StationData/"
#Creating a a new directroy for storing higher elevation data
mkdir -p "HigherElevation" 
a=0

#For loop used for reading all the data from each stating and sorting out only higher elevation stations in the newly created dir.
for f in "$dir"/*; do
	alt=$(grep "$f" -e 'Station Altitude'| awk '$4 > 199')
	if [ "$alt">199 ]; then 
	  cp "$f" "HigherElevation/"
	fi
rm 199
done

#Storing lon and lat data for all the stations and higher station seperately
awk '/Longitude/ {print -1*$NF}' StationData/Station_*.txt > Long.list
awk '/Latitude/ {print $NF}' StationData/Station_*.txt > Lat.list
paste Long.list Lat.list > AllStation.xy

awk '/Longitude/ {print -1*$NF}' HigherElevation/Station_*.txt > Long.list
awk '/Latitude/ {print $NF}' HigherElevation/Station_*.txt > Lat.list
paste Long.list Lat.list > HEStations.xy


#Loading the gmt module
module load gmt

#filling the lakes with blue color '-Cl/blue'. state borders are red - '-Na/red'
gmt pscoast -JU16/4i -R-93/-86/36/43 -Cl/blue -Dh[+] -B2f0.5 -Ia/blue -Na/red -P -K -V > SoilMoistureStations.ps

#using black dots with 0.25 size to identify all stations - 'Sc0.25 -Gblack'
gmt psxy AllStation.xy -J -R -Sc0.25 -Gblack -K -O -V >> SoilMoistureStations.ps

#using red dots with 0.10 size to identify higher elevation stations - '-Sc0.10 -Gred'
gmt psxy HEStations.xy -J -R -Sc0.10 -Gred -K -O -V >> SoilMoistureStations.ps

#gv SoilMoistureStations.ps &

#convert SoilMoistureStations.ps to epsi file
ps2epsi SoilMoistureStations.ps

#convert .epsi to .tiff at the 150 dpi res
convert SoilMoistureStations.epsi -density 150 -units pixelsperinch SoilMoistureStations.tiff

#Show the fig SoilMoistureStations.ps
display SoilMoistureStations.ps

#Show the fig SoilMoistureStations.epsi
display SoilMoistureStations.epsi

#Show the fig SoilMoistureStations.tiff
display SoilMoistureStations.tiff



