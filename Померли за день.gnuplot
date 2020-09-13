#!/usr/bin/gnuplot

#######################################
###
###   @author Vitalii Chernookyi
###                             
###   @copyright GPLv3
###
#######################################

#Set the output to a png file
set terminal png size 1920,1200
# The file we'll write to
set output 'Померли за день.png'
# The graphic title
set title 'Covid19 Death Model --- Ukr. Approximated using Levenberg–Marquardt algorithm. © Vitalii Chernookyi'
set key left box
set xtics 62,7
set grid back

#set timefmt '%d.%m.%Y'
#set xdata time
#set format x '%d.%m.%Y'

f0(x) = a0 + c0*exp(d0*x + e0)
f1(x) = a1 + b1*x + c1*exp(d1*x + e1)

### Let's use Levenberg–Marquardt algorithm
###
fit [62:211][0:60] f0(x) 'data.dat' u 1:4 via 'Померли за день-start0.par'
fit [62:211][0:60] f1(x) 'data.dat' u 1:4 via 'Померли за день-start1.par'

#plot the graphic
set logscale y 10
set logscale y2 10
set y2tics
set y2range [1:]
set bmargin 3 # leave room for 2 lines of x labels
label(i1,i2) = sprintf("%d\n%s",column(i1),stringcolumn(i2))

plot [62:275] \
	'data.dat' u 1:(valid(4) ? $4 : 0):xtic(int($0)%14==0 ? stringcolumn(2) : "") t "COVID-19: Померли за день : Данные", \
	f0(x) t "f0(x) = a0 + c0*exp(d0*x + e0)", \
	f1(x) t "f1(x) = a1 + b1*x + c1*exp(d1*x + e1)", \
	abs(f1(x)-f0(x)) axes x1y2
