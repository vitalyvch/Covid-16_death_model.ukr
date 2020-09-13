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
set output 'Померли всього --- full range.png'
# The graphic title
set title 'Covid19 Death Model --- Ukr. Full Range. Approximated using Levenberg–Marquardt algorithm. © Vitalii Chernookyi'
set key left box
set xtics 62,7
set grid back

#set timefmt '%d.%m.%Y'
#set xdata time
#set format x '%d.%m.%Y'

F0(x) = A0 + C0*exp(D0*x + E0)
F1(x) = A1 + B1*x + C1*exp(D1*x + E1)
F2(x) = A2 + B2*x + G2*x*x + C2*exp(D2*x + E2)

### Let's use Levenberg–Marquardt algorithm
###
fit [80:211][0:3000] F0(x) 'data.dat' u 1:3 via 'Померли всього-start0.par'
fit [62:211][0:3000] F1(x) 'data.dat' u 1:3 via 'Померли всього-start1.par'
fit [62:211][0:3000] F2(x) 'data.dat' u 1:3 via 'Померли всього-start2.par'

#plot the graphic
set logscale y 10
set logscale y2 10
set y2tics
set yrange [10:100000]
set y2range [10:100000]
set bmargin 4 # leave room for 2 lines of x labels
label(i1,i2) = sprintf("%d\n%s",column(i1),stringcolumn(i2))

plot [62:275] \
	'data.dat' u 1:(valid(3) ? $3 : 0):xtic(int($0)%14==0 ? "+\n".stringcolumn(1)."\n".stringcolumn(2) : "") \
		t "COVID-19: Померли всього : Данные" with points ps 2 lw 2, \
	F0(x) with lines lw 3 t "«TRUE» Covid-19 deaths   ---   F0(x) = A0 + C0*exp(D0*x + E0)", \
	F1(x) with lines lw 2 t "F1(x) = A1 + B1*x + C1*exp(D1*x + E1)", \
	F2(x) with lines lw 2 t "F2(x) = A2 + B2*x + G2*x*x + C2*exp(D2*x + E2)", \
	(x<182 ? 1 : abs(F1(x)-F0(x))) with lp axes x1y2 t "«EXTRA» deaths, guess #1   ---   abs(F1(x)-F0(x))", \
	(x<182 ? 1 : abs(F2(x)-F0(x))) with lp axes x1y2 t "«EXTRA» deaths, guess #2   ---   abs(F2(x)-F0(x))"


######################################################################################################################
set output 'Померли всього --- September.png'
set logscale y 2
set logscale y2 2
set yrange [2048:8192]
set y2range [128:2048]

plot [181:219] \
	'data.dat' u 1:(valid(3) ? $3 : 0):xtic(int($0)%7==0 ? "+\n".stringcolumn(1)."\n".stringcolumn(2) : "") \
		t "COVID-19: Померли всього : Данные" with points ps 2 lw 2, \
	F0(x)  with lines lw 3 t "«TRUE» Covid-19 deaths   ---   F0(x) = A0 + C0*exp(D0*x + E0)", \
	F1(x)  with lines lw 2 t "F1(x) = A1 + B1*x + C1*exp(D1*x + E1)", \
	F2(x)  with lines lw 2 t "F2(x) = A2 + B2*x + G2*x*x + C2*exp(D2*x + E2)", \
	(x<182 ? 1 : abs(F1(x)-F0(x))) with lp axes x1y2 t "«EXTRA» deaths, guess #1   ---   RIGHT SCALE   ---   abs(F1(x)-F0(x))", \
	(x<182 ? 1 : abs(F2(x)-F0(x))) with lp axes x1y2 t "«EXTRA» deaths, guess #2   ---   RIGHT SCALE   ---   abs(F2(x)-F0(x))"
