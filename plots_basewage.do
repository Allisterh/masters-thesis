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
twoway (kdens log_b_real_wage if year==$y1 & log_b_real_wage>=4.5 & log_b_real_wage<=7.5 [aw=rw_mw_basewage], a xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1 MW" ${mw${y0}} "$y0 MW", axis(2) labsize(small))) (kdens log_b_real_wage if year==$y0 & log_b_real_wage>=4.5 & log_b_real_wage<=7.5, a lcolor(%50)) (kdens log_b_real_wage if year==$y1 & log_b_real_wage>=4.5 & log_b_real_wage<=7.5, a lcolor(%50)), title("A) Counterfactual of $y1 with $y0 minimum wage") ytitle(Density) xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(, grid glcolor(gs15)) legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "$y1 counterfactual with $y0 minimum wage" 2 "$y0" 3 "$y1")) xline(${mw${y0}} ${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(8) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) name(past_mw, replace)
graph export "graphs/Base wage - $y1 with $y0 minimum wage.pdf", as(pdf) name("past_mw") replace
 
* Actual and counterfactual with no spillovers
twoway (kdens log_b_real_wage if year==$y1 & log_b_real_wage>=4.5 & log_b_real_wage<=7.5 [aw=rw_ns_basewage], a xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1 MW", axis(2) labsize(small))) (kdens log_b_real_wage if year==$y1 & log_b_real_wage>=4.5 & log_b_real_wage<=7.5, a lcolor(%50)), title("C) Counterfactual of $y1 with no spillovers") ytitle(Density) xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(, grid glcolor(gs15)) legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "$y1 counterfactual with no spillovers" 2 "$y1")) xline(${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(8) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) name(no_spillovers, replace)
graph export "graphs/Base wage - $y1 without spillovers.pdf", as(pdf) name("no_spillovers") replace

*Change in density
gen densvalues = 4.5+(_n-1)*(3)/1000 if _n<=1000
kdens log_b_real_wage if year==$y1 & log_b_real_wage>=4.5 & log_b_real_wage<=7.5, a generate(dens${y1}) at(densvalues) nograph
kdens log_b_real_wage if year==$y0 & log_b_real_wage>=4.5 & log_b_real_wage<=7.5, a generate(dens${y0}) at(densvalues) nograph
kdens log_b_real_wage if year==$y1 & log_b_real_wage>=4.5 & log_b_real_wage<=7.5 [aw=rw_mw_basewage], a generate(dens${y1}_mw) at(densvalues) nograph
kdens log_b_real_wage if year==$y1 & log_b_real_wage>=4.5 & log_b_real_wage<=7.5 [aw=rw_ns_basewage], a generate(dens${y1}_ns) at(densvalues) nograph
gen chdens${y0}${y1} = dens${y1}-dens${y0}
gen chdens${y0}${y1}_mw = dens${y1}_mw-dens${y0}
gen chdens${y0}${y1}_ns = dens${y1}_ns-dens${y0}
gen chdens${y1}${y1}_mw = dens${y1}-dens${y1}_mw
gen chdens${y1}${y1}_ns = dens${y1}-dens${y1}_ns
twoway (line chdens${y1}${y1}_mw densvalues, xaxis(1 2) xtitle("", axis(2)) xlabel(${mw${y1}} "$y1 MW", axis(2) labsize(small))), title("B) Change in density attributed to the change in the minimum wage") ytitle(Change in density) xtitle(Log Real Wage) xlabel(4.5(0.5)7.5) ylabel(, grid glcolor(gs15)) xline(${mw${y1}}, lwidth(thin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(8) ysize(5) graphregion(lcolor(white) fcolor(white) margin(tiny)) plotregion(lcolor(black)) yline(0, lcolor(gs5)) name(densityeffect, replace)
graph export "graphs/Base wage - $y1 effect in density.pdf", as(pdf) name("densityeffect") replace
