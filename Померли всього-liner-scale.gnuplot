#!/usr/bin/gnuplot

#######################################
###
###   @author Vitalii Chernookyi
###                             
###   @copyright GPLv3
###
#######################################

#Set the output to a png file
set terminal png size 2048,1024
# The file we'll write to
set output 'Померли всього-liner-scale.png'
# The graphic title
set title 'Covid19 Data --- Ukr'
set key left box
set grid
set xdata time
set timefmt '%d.%m.%Y'
#set logscale y 10


#plot the graphic
plot [:"31.09.2020"] \
	'data.dat' u 2:3
