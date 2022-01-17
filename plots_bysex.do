**# Plot distributions

use the_data, clear

//Macros
global y0 = 2006
global y1 = 2019
qui sum log_real_minwage if year==$y0
global mw$y0 = r(mean)
qui sum log_real_minwage if year==$y1
global mw$y1 = r(mean)

* Actual and counterfactual with past minimum wage
twoway (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==0 [aw=rw_mw_bysex], a xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1" ${mw${y0}} "$y0", axis(2) labsize(small))) (kdens log_real_wage if year==$y0 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==0, a lcolor(%50)) (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==0, a lcolor(%50)), title("1) Females") ytitle(Density) xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(, grid glcolor(gs15)) legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "$y1 CF with $y0 MW" 2 "$y0" 3 "$y1")) xline(${mw${y0}} ${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(4) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) name(past_mw_females, replace)
twoway (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==1 [aw=rw_mw_bysex], a xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1" ${mw${y0}} "$y0", axis(2) labsize(small))) (kdens log_real_wage if year==$y0 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==1, a lcolor(%50)) (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==1, a lcolor(%50)), title("2) Males") ytitle("") xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(, grid glcolor(gs15)) legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "$y1 CF with $y0 MW" 2 "$y0" 3 "$y1")) xline(${mw${y0}} ${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(4) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) name(past_mw_males, replace)
graph combine past_mw_females past_mw_males, title("A) Counterfactual of $y1 with $y0 minimum wage") ycommon xsize(12) ysize(5) graphregion(margin(zero) fcolor(white) lcolor(white%0)) name(past_mw_bysex, replace)
graph export "graphs/By sex - $y1 with $y0 minimum wage.pdf", as(pdf) name("past_mw_bysex") replace

* Actual and counterfactual with no spillovers
twoway (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==0 [aw=rw_ns_bysex], a xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1 MW", axis(2) labsize(small))) (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==0, a lcolor(%50)), title("1) Females") ytitle(Density) xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(, grid glcolor(gs15)) legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "$y1 CF w/o spillovers" 2 "$y1")) xline(${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(4) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) name(no_spillovers_females, replace)
twoway (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==1 [aw=rw_ns_bysex], a xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1 MW", axis(2) labsize(small))) (kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 & male==1, a lcolor(%50)), title("2) Males") ytitle("") xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(, grid glcolor(gs15)) legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "$y1 CF w/o spillovers" 2 "$y1")) xline(${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(4) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) name(no_spillovers_males, replace)
graph combine no_spillovers_females no_spillovers_males, title("C) Counterfactual of $y1 with no spillovers") ycommon xsize(12) ysize(5) graphregion(margin(zero) fcolor(white) lcolor(white%0)) name(no_spillovers_bysex, replace)
graph export "graphs/By sex - $y1 without spillovers.pdf", as(pdf) name("no_spillovers_bysex") replace

*Change in density
use the_data, clear
keep if male==0
gen densvalues = 4.5+(_n-1)*(3)/1000 if _n<=1000
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y1}) at(densvalues) nograph
kdens log_real_wage if year==$y0 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y0}) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_mw_bysex], a generate(dens${y1}_mw) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_ns_bysex], a generate(dens${y1}_ns) at(densvalues) nograph
gen chdens${y0}${y1} = dens${y1}-dens${y0}
gen chdens${y0}${y1}_mw = dens${y1}_mw-dens${y0}
gen chdens${y0}${y1}_ns = dens${y1}_ns-dens${y0}
gen chdens${y1}${y1}_mw = dens${y1}-dens${y1}_mw
gen chdens${y1}${y1}_ns = dens${y1}-dens${y1}_ns
twoway (line chdens${y1}${y1}_mw densvalues, xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1 MW", axis(2) labsize(small))), title("1) Females") ytitle(Change in density) xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(, grid glcolor(gs15)) xline(${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(4) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) yline(0, lcolor(gs5)) name(densityeffect_females, replace)
use the_data, clear
keep if male==1
gen densvalues = 4.5+(_n-1)*(3)/1000 if _n<=1000
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y1}) at(densvalues) nograph
kdens log_real_wage if year==$y0 & log_real_wage>=4.5 & log_real_wage<=7.5, a generate(dens${y0}) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_mw_bysex], a generate(dens${y1}_mw) at(densvalues) nograph
kdens log_real_wage if year==$y1 & log_real_wage>=4.5 & log_real_wage<=7.5 [aw=rw_ns_bysex], a generate(dens${y1}_ns) at(densvalues) nograph
gen chdens${y0}${y1} = dens${y1}-dens${y0}
gen chdens${y0}${y1}_mw = dens${y1}_mw-dens${y0}
gen chdens${y0}${y1}_ns = dens${y1}_ns-dens${y0}
gen chdens${y1}${y1}_mw = dens${y1}-dens${y1}_mw
gen chdens${y1}${y1}_ns = dens${y1}-dens${y1}_ns
twoway (line chdens${y1}${y1}_mw densvalues, xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1 MW", axis(2) labsize(small))), title("2) Males") ytitle("") xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(, grid glcolor(gs15)) xline(${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(4) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) yline(0, lcolor(gs5)) name(densityeffect_males, replace)
graph combine densityeffect_females densityeffect_males, title("B) Change in density attributed to the change in the minimum wage") ycommon xsize(12) ysize(5) graphregion(margin(zero) fcolor(white) lcolor(white%0)) name(densityeffect_bysex, replace)
graph export "graphs/By sex - $y1 effect in density.pdf", as(pdf) name("densityeffect_bysex") replace
