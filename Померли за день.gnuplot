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
set grid back ytics mytics xtics

#set timefmt '%d.%m.%Y'
#set xdata time
#set format x '%d.%m.%Y'

f0(x) = a0 + c0*exp(d0*x + e0)
f1(x) = a1 + b1*x + c1*exp(d1*x + e1)
f2(x) = a2 + b2*x + g2*x*x + c2*exp(d2*x + e2)
f3(x) = a3 + b3*x + g3*x*x + h3*x*x*x + c3*exp(d3*x + e3)
f4(x) = a4 + b4*x + g4*x*x + h4*x*x*x + j4*x*x*x*x + c4*exp(d4*x + e4)

f_exp0_1(x) = a_exp0_1 + c_exp0_1*exp(d_exp0_1*x + e_exp0_1)
f_exp0_2(x) = a_exp0_2 + c_exp0_2*exp(d_exp0_2*x + e_exp0_2)

F1(x) = A1 + B1*x + C1*exp(D1*x + E1)

### Let's use Levenberg–Marquardt algorithm
###
fit [62:211][0:60] f0(x) 'data.dat' u 1:4 via 'Померли за день-start0.par'
fit [62:211][0:60] f1(x) 'data.dat' u 1:4 via 'Померли за день-start1.par'
fit [62:211][0:60] f2(x) 'data.dat' u 1:4 via 'Померли за день-start2.par'
fit [62:211][0:60] f3(x) 'data.dat' u 1:4 via 'Померли за день-start3.par'
fit [62:211][0:60] f4(x) 'data.dat' u 1:4 via 'Померли за день-start4.par'

fit [62:133][0:60] f_exp0_1(x) 'data.dat' u 1:4 via 'Померли за день-start_exp0_1.par'
fit [134:211][0:60] f_exp0_2(x) 'data.dat' u 1:4 via 'Померли за день-start_exp0_2.par'

fit [62:211][0:3000] F1(x) 'data.dat' u 1:3 via 'Померли всього-start1.par'

#plot the graphic
set logscale y 10
set logscale y2 10
set y2tics
set yrange [1:10000]
set y2range [1:10000]
set bmargin 4 # leave room for 2 lines of x labels
label(i1,i2) = sprintf("%d\n%s",column(i1),stringcolumn(i2))

plot [62:275] \
	'data.dat' u 1:(valid(4) ? $4 : 0):xtic(int($0)%14==0 ? "+\n".stringcolumn(1)."\n".stringcolumn(2) : "") \
		t "COVID-19: Померли за день : Данные" with points ps 2 lw 2, \
	abs(F1(x)-F1(x-1)) with impulses lw 3 t "d F1(x) / d x", \
	f0(x) with l lw 3  t "f0(x) = a0 + c0*exp(d0*x + e0)", \
	f_exp0_1(x) with lp lw 2 t "«TRUE» Exp #1", \
	f_exp0_2(x) with lp lw 2 t "«TRUE» Exp #2", \
	abs(abs(F1(x)-F1(x-1))-f0(x)) with l lw 2 axes x1y2

#	f1(x) t "f1(x) = a1 + b1*x + c1*exp(d1*x + e1)", \
#	f2(x) t "f2(x) = a2 + b2*x + g2*x*x + c2*exp(d2*x + e2)", \
#	f3(x) t "f3(x) = a3 + b3*x + g3*x*x + h3*x*x*x + c3*exp(d3*x + e3)", \
#	f4(x) t "f4(x) = a4 + b4*x + g4*x*x + h4*x*x*x + j4*x*x*x*x + c4*exp(d4*x + e4)", \
