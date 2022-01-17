**# Density change plot
//1986-1994
global y0 = 1986
global y1 = 1994
use the_data, clear
//Minimum wages
qui sum log_real_minwage if year==$y0
global mw$y0 = r(mean)
qui sum log_real_minwage if year==$y1
global mw$y1 = r(mean)
*Change in density
gen densvalues = 4.5+(_n-1)*(3)/1000 if _n<=1000
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y1}) at(densvalues) nograph
kdens log_real_wage if year==$y0 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y0}) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_mw], a generate(dens${y1}_mw) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_ns], a generate(dens${y1}_ns) at(densvalues) nograph
gen chdens${y0}${y1} = dens${y1}-dens${y0}
gen chdens${y0}${y1}_mw = dens${y1}_mw-dens${y0}
gen chdens${y0}${y1}_ns = dens${y1}_ns-dens${y0}
gen chdens${y1}${y1}_mw = dens${y1}-dens${y1}_mw
gen chdens${y1}${y1}_ns = dens${y1}-dens${y1}_ns
twoway (line chdens${y1}${y1}_mw densvalues if densvalues<=6, xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y0}} "$y0 MW" ${mw${y1}} "$y1 MW", axis(2) labsize(small) alternate)), title("A) ${y0}-${y1}") ytitle(Change in density) xtitle(Log Real Wage) xlabel(4.5(0.5)6) ylabel(-0.4(0.2)0.6, grid glcolor(gs15)) xline(${mw${y0}} ${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(6) ysize(8) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) yline(0, lcolor(gs5)) name(densityeffect1, replace) fxsize(100)
//1994-2006
global y0 = 1994
global y1 = 2006
use the_data, clear
//Minimum wages
qui sum log_real_minwage if year==$y0
global mw$y0 = r(mean)
qui sum log_real_minwage if year==$y1
global mw$y1 = r(mean)
*Change in density
gen densvalues = 4.5+(_n-1)*(3)/1000 if _n<=1000
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y1}) at(densvalues) nograph
kdens log_real_wage if year==$y0 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y0}) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_mw], a generate(dens${y1}_mw) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_ns], a generate(dens${y1}_ns) at(densvalues) nograph
gen chdens${y0}${y1} = dens${y1}-dens${y0}
gen chdens${y0}${y1}_mw = dens${y1}_mw-dens${y0}
gen chdens${y0}${y1}_ns = dens${y1}_ns-dens${y0}
gen chdens${y1}${y1}_mw = dens${y1}-dens${y1}_mw
gen chdens${y1}${y1}_ns = dens${y1}-dens${y1}_ns
twoway (line chdens${y1}${y1}_mw densvalues if densvalues<=6, xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y0}} "$y0 MW" ${mw${y1}} "$y1 MW", axis(2) labsize(small) alternate)), title("B) ${y0}-${y1}") yscale(off) xtitle(Log Real Wage) xlabel(4.5(0.5)6) ylabel(-0.4(0.2)0.6, grid glcolor(gs15)) xline(${mw${y0}} ${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(5) ysize(8) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) yline(0, lcolor(gs5)) name(densityeffect2, replace)
//2006-2019
global y0 = 2006
global y1 = 2019
use the_data, clear
//Minimum wages
qui sum log_real_minwage if year==$y0
global mw$y0 = r(mean)
qui sum log_real_minwage if year==$y1
global mw$y1 = r(mean)
*Change in density
gen densvalues = 4.5+(_n-1)*(3)/1000 if _n<=1000
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y1}) at(densvalues) nograph
kdens log_real_wage if year==$y0 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y0}) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_mw], a generate(dens${y1}_mw) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_ns], a generate(dens${y1}_ns) at(densvalues) nograph
gen chdens${y0}${y1} = dens${y1}-dens${y0}
gen chdens${y0}${y1}_mw = dens${y1}_mw-dens${y0}
gen chdens${y0}${y1}_ns = dens${y1}_ns-dens${y0}
gen chdens${y1}${y1}_mw = dens${y1}-dens${y1}_mw
gen chdens${y1}${y1}_ns = dens${y1}-dens${y1}_ns
twoway (line chdens${y1}${y1}_mw densvalues if densvalues<=6, xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y0}} "$y0 MW" ${mw${y1}} "$y1 MW", axis(2) labsize(small) alternate)), title("C) ${y0}-${y1}") yscale(off) xtitle(Log Real Wage) xlabel(4.5(0.5)6) ylabel(-0.4(0.2)0.6, grid glcolor(gs15)) xline(${mw${y0}} ${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(5) ysize(8) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) yline(0, lcolor(gs5)) name(densityeffect3, replace)
//save
graph combine densityeffect1 densityeffect2 densityeffect3, xcommon ycommon rows(1) xsize(12) ysize(4) scale(1.25) graphregion(margin(zero) fcolor(white)) name(densityeffect, replace)
graph export "graphs/Effect in density.pdf", as(pdf) name("densityeffect") replace



**# 2006-2019 wage percentile
use the_data, clear
global y0 = 2006
global y1 = 2019
pctile pc${y0} = log_real_wage if year==${y0}, nq(99) genp(percent)
pctile pc${y1} = log_real_wage if year==${y1}, nq(99)
pctile pc${y1}_mw = log_real_wage if year==${y1} [w=rw_mw], nq(99)
gen cg${y1} = pc${y1}-pc${y0}
gen cg${y1}_mw = pc${y1}_mw-pc${y0}
sum log_real_wage if year==${y1}
global cgline1 = r(mean)
sum log_real_wage [w=rw_mw] if year==${y1}
global cgline2 = r(mean)
sum log_real_wage if year==${y0}
global cgline1 = $cgline1 - r(mean)
global cgline2 = $cgline2 - r(mean)
twoway (connected cg${y1} percent if percent>=2, msize(3-pt) msymbol(circle) mfcolor(%25)) (connected cg${y1}_mw percent if percent>=2, msize(3-pt) msymbol(diamond) mfcolor(%25)), ytitle(Log point change) xtitle(Percentile) xlabel(0(10)100) ylabel(, grid glcolor(gs15)) legend(cols(1) position(3) region(lcolor(none)) bmargin(tiny) span order(1 "Actual wage growth, ${y0}-${y1}" 2 "CF wage growth with $y0 MW")) scheme(s2color) xsize(12) ysize(4) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) yline(0, lcolor(gs5)) name(wagechange, replace) yline($cgline1 , lcolor(navy%25)) yline($cgline2 , lcolor(cranberry%25)) scale(1.2)
graph export "graphs/Alone - $y1 wage change by percentile.pdf", as(pdf) name("wagechange") replace
