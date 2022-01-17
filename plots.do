**# Plot distributions

use the_data, clear

//Minimum wages
qui sum log_real_minwage if year==$y0
global mw$y0 = r(mean)
qui sum log_real_minwage if year==$y1
global mw$y1 = r(mean)

* Actual and counterfactual with past minimum wage
twoway (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_mw], a xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1 MW" ${mw${y0}} "$y0 MW", axis(2) labsize(small) alternate)) (kdens log_real_wage if year==$y0 & log_real_wage>=4.5 & log_real_wage<=7.5, a lcolor(%50)) (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5, a lcolor(%50)), title("${y0}-${y1}") ytitle(Density) xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(0(0.5)1.5, grid glcolor(gs15)) legend(cols(1) position(3) region(lcolor(none)) bmargin(tiny) span order(1 "$y1 CF w/ $y0 MW" 2 "$y0" 3 "$y1")) xline(${mw${y0}} ${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(12) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) name(past_mw, replace)
if $y0 == 1986 {
	gr_edit .title.text = {"A) ${y0}-${y1}"}
}
else if $y0 == 1994 {
 	gr_edit .title.text = {"B) ${y0}-${y1}"}
}
else if $y0 == 2006 {
	gr_edit .title.text = {"C) ${y0}-${y1}"}
}
graph export "graphs/$y1 with $y0 minimum wage.pdf", as(pdf) name("past_mw") replace

* Actual and counterfactual with no spillovers
twoway (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_ns], a xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1 MW", axis(2) labsize(small))) (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5, a lcolor(%50)), title("${y0}-${y1}") ytitle(Density) xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(0(0.5)2, grid glcolor(gs15)) legend(cols(1) position(3) region(lcolor(none)) bmargin(tiny) span order(1 "$y1 CF w/o spillovers" 2 "$y1")) xline(${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(12) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) name(no_spillovers, replace)
if $y0 == 1986 {
	gr_edit .title.text = {"A) ${y0}-${y1}"}
}
else if $y0 == 1994 {
 	gr_edit .title.text = {"B) ${y0}-${y1}"}
 }
else if $y0 == 2006 {
	gr_edit .title.text = {"C) ${y0}-${y1}"}
}
graph export "graphs/$y1 without spillovers.pdf", as(pdf) name("no_spillovers") replace

*Wage change by percentile
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
twoway (connected cg${y1} percent if percent>=2, msize(3-pt) msymbol(circle) mfcolor(%25)) (connected cg${y1}_mw percent if percent>=2, msize(3-pt) msymbol(diamond) mfcolor(%25)), ytitle(Log point change) xtitle(Percentile) xlabel(0(10)100) ylabel(, grid glcolor(gs15)) legend(region(lcolor(none)) bmargin(tiny) span order(1 "Actual wage growth between $y0 and $y1" 2 "CF wage growth with $y0 minimum wage")) scheme(s2color) xsize(10) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) yline(0, lcolor(gs5)) name(wagechange, replace) yline($cgline1 , lcolor(navy%25)) yline($cgline2 , lcolor(cranberry%25))
if $y0 == 1986 {
	gr_edit .title.text = {"A) ${y0}-${y1}"}
}
else if $y0 == 1994 {
 	gr_edit .title.text = {"B) ${y0}-${y1}"}
 }
else if $y0 == 2006 {
	gr_edit .title.text = {"C) ${y0}-${y1}"}
}
graph export "graphs/$y1 wage change by percentile.pdf", as(pdf) name("wagechange") replace
