**# Descriptive graphs

graph set window fontface "Times New Roman"

*First two graphs
use the_data, clear
gen rel_log_minwage = log_real_minwage-log_real_wage
gen mw_share_twage = log_t_real_wage<=log_real_minwage
gen mw_share_bwage = log_b_real_wage<=log_real_minwage
egen gini = gini(t_real_wage), by(year)
collapse (mean) male educ log_real_wage  log_real_minwage rel_log_minwage mw_share_twage mw_share_bwage gini (sd) sd=log_real_wage (p10) p10=log_real_wage (p25) p25=log_real_wage (p50) p50=log_real_wage (p75) p75=log_real_wage (p90) p90=log_real_wage, by(year) fast
gen p90p10 = p90-p10
gen p90p50 = p90-p50
gen p75p25 = p75-p25
gen p50p10 = p50-p10
replace mw_share_bwage = . if year==2002 | year==2014
replace mw_share_twage = . if year==2002 | year==2014


*Plot inequality measures
twoway (tsline sd) (tsline p90p10, yaxis(2)), ytitle(Standard deviation) ytitle("", axis(2)) ttitle(Year) tlabel(1985(5)2020) ylabel(, grid glcolor(gs15)) title("A) General inequality measures") legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "Standard deviation" 2 "90-10 differential")) tline(1994 2006, lwidth(vthin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(5) ysize(4) graphregion(lcolor(white) fcolor(white)) plotregion(lcolor(black)) name(generalinequality, replace)
twoway (tsline p90p50) (tsline p75p25) (tsline p50p10), ytitle(Percentile differential) ttitle(Year) tlabel(1985(5)2020) ylabel(0.4(0.1)0.9, grid glcolor(gs15)) title("B) Inequality across the distribution") ylabel(, grid glcolor(gs15)) legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "90-50 differential" 2 "75-25 differential" 3 "50-10 differential")) tline(1994 2006, lwidth(vthin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(5) ysize(4) graphregion(lcolor(white) fcolor(white)) plotregion(lcolor(black)) name(acrossinequality, replace)
graph combine generalinequality acrossinequality, imargin(zero) scheme(s2color) xsize(10) ysize(4) scale(1.5) graphregion(margin(small) fcolor(white) lcolor(white%0)) name(inequality, replace)
graph export "graphs/Measures of wage inequality.pdf", as(pdf) name("inequality") replace


*Plot real and relative minimum wage
twoway (tsline log_real_minwage) (tsline rel_log_minwage, yaxis(2)), ytitle(Log wage) ytitle(Log difference, axis(2)) ttitle(Year) tlabel(1985(5)2020) ylabel(, grid glcolor(gs15)) title("A) Real and relative minimum wage") legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "Real minimum wage" 2 "Relative minimum wage")) tline(1994 2006, lwidth(vthin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(5) ysize(4) graphregion(lcolor(white) fcolor(white)) plotregion(lcolor(black)) name(mwvalue, replace)
twoway (tsline mw_share_bwage mw_share_twage), ytitle(Percentage) ttitle(Year) tlabel(1985(5)2020) ylabel(, grid glcolor(gs15)) title("B) Share of workers on the minimum wage") legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "Base wage" 2 "Total wage")) tline(1994 2006, lwidth(vthin) lpattern(dash) lcolor(gs5)) scheme(s2color) xsize(5) ysize(4) graphregion(lcolor(white) fcolor(white)) plotregion(lcolor(black)) name(mwshare, replace)
graph combine mwvalue mwshare, imargin(zero) scheme(s2color) xsize(10) ysize(4) scale(1.5) graphregion(margin(small) fcolor(white) lcolor(white%0)) name(minwage, replace)
graph export "graphs/Minimum wage.pdf", as(pdf) name("minwage") replace


*Base-total wage plots
//Total-base log wage differential
use the_data, clear
collapse log_real_minwage (p5) p5_t=log_real_wage p5_b=log_b_real_wage (p10) p10_t=log_real_wage p10_b=log_b_real_wage (p15) p15_t=log_real_wage p15_b=log_b_real_wage (p20) p20_t=log_real_wage p20_b=log_b_real_wage (p25) p25_t=log_real_wage p25_b=log_b_real_wage (p50) p50_t=log_real_wage p50_b=log_b_real_wage (p90) p90_t=log_real_wage p90_b=log_b_real_wage, by(year) fast
g dif10 = p10_t-p10_b
g dif50 = p50_t-p50_b
g dif90 = p90_t-p90_b
twoway (tsline dif10 dif50 dif90), title("A) Total-Base log wage differential at different wage percentiles") ytitle(Total-base log wage differential) ttitle(Year) tlabel(1985(5)2020) ylabel(, grid glcolor(gs15)) legend(rows(1) region(lcolor(none)) bmargin(tiny) span order(1 "Differential at p10" 2 "Differential at p50" 3 "Differential at p90")) scheme(s2color) xsize(10) ysize(5) graphregion(lcolor(white) fcolor(white)) plotregion(lcolor(black)) name(basetotal, replace)
graph export "graphs/Total-base log wage differential.pdf", as(pdf) name("basetotal") replace
//Total and base wage percentiles
twoway (tsline log_real_minwage) (tsline p5_b p10_b p15_b p20_b p25_b, lcolor(%40 ..)), title("1) Base wage", size(medsmall)) ytitle(Log real wage) ttitle(Year) tlabel(1985(5)2020) ylabel(, grid glcolor(gs15)) legend(rows(2) region(lcolor(none)) bmargin(tiny) order(1 "MW" 2 "p5" 3 "p10" 4 "p15" 5 "p20" 6 "p25")) scheme(s2color) graphregion(lcolor(white) fcolor(white)) plotregion(lcolor(black)) name(min_base, replace)
twoway (tsline log_real_minwage) (tsline p5_t p10_t p15_t p20_t p25_t, lcolor(%40 ..)), title("2)Total wage", size(medsmall)) ytitle(Log real wage) ttitle(Year) tlabel(1985(5)2020) ylabel(, grid glcolor(gs15)) legend(rows(2) region(lcolor(none)) bmargin(tiny) order(1 "MW" 2 "p5" 3 "p10" 4 "p15" 5 "p20" 6 "p25")) scheme(s2color) graphregion(lcolor(white) fcolor(white)) plotregion(lcolor(black)) name(min_total, replace)
graph combine min_base min_total, title("B) Base wage and Total wage percentiles", size(medium)) ycommon imargin(zero) scheme(s2color) xsize(10) ysize(5) scale(1.5) graphregion(margin(small) fcolor(white) lcolor(white%0)) name(min_basetotal, replace)
graph export "graphs/Total and base wage percentiles.pdf", as(pdf) name("min_basetotal") replace


*Plot wage histograms
use the_data, clear
local j = 1
qui sum log_real_minwage if year==1986
local mw86 = r(mean)
qui sum log_real_minwage if year==1994
local mw94 = r(mean)
qui sum log_real_minwage if year==2006
local mw06 = r(mean)
qui sum log_real_minwage if year==2019
local mw19 = r(mean)
foreach i of numlist 1986/1989 1991/1994 {
	qui sum log_real_minwage if year==`i'
	local mw = r(mean)
	histogram log_t_real_wage if year==`i' & log_t_real_wage>=4.5 & log_t_real_wage<=7.5, w(0.05) fcolor(forest_green) fintensity(50) lcolor(forest_green) xaxis(1 2) xtitle("", axis(2)) xlabel(`mw' "`i' MW", axis(2) labsize(small)) xtitle("") xline(`mw86', lpattern(dash) lcolor(gs8)) xline(`mw', lcolor(gs5)) xlabel(none) ylabel(0(0.5)1.5, grid glcolor(gs15)) scheme(s2color) graphregion(margin(zero) fcolor(white) lcolor(white)) plotregion(lcolor(black))  title("A) Total wages", position(1) ring(0) margin(small) box bmargin(small) fcolor(white) justification(center)) name(htotal, replace)
	histogram log_b_real_wage if year==`i' & log_b_real_wage>=4.5 & log_b_real_wage<=7.5, w(0.05) fcolor(forest_green) fintensity(50) lcolor(forest_green) xtitle(Log Real Wage) xline(`mw86', lpattern(dash) lcolor(gs8)) xline(`mw', lcolor(gs5)) xlabel(4.5(0.5)7.5) ylabel(0(2)6, grid glcolor(gs15)) scheme(s2color) graphregion(margin(zero) fcolor(white) lcolor(white)) plotregion(lcolor(black))   title("B) Base wages", position(1) ring(0) margin(small) box bmargin(small) fcolor(white) justification(center)) name(hbase, replace)
	graph combine htotal hbase, title(`i') cols(1) xcommon imargin(zero) scheme(s2color) xsize(10) ysize(10) graphregion(margin(small) fcolor(white) lcolor(white%0)) name(h`i', replace)
	graph export "graphs/histograms/h`j'.pdf", as(pdf) name("h`i'") replace
	local j = `j'+1
}
foreach i of numlist 1995/2000 2002/2006 {
	qui sum log_real_minwage if year==`i'
	local mw = r(mean)
	histogram log_t_real_wage if year==`i' & log_t_real_wage>=4.5 & log_t_real_wage<=7.5, w(0.05) fcolor(forest_green) fintensity(50) lcolor(forest_green) xaxis(1 2) xtitle("", axis(2)) xlabel(`mw' "`i' MW", axis(2) labsize(small)) xtitle("") xline(`mw86', lpattern(dash) lcolor(gs12)) xline(`mw94', lpattern(dash) lcolor(gs8)) xline(`mw', lcolor(gs5)) xlabel(none) ylabel(0(0.5)1.5, grid glcolor(gs15)) scheme(s2color) graphregion(margin(zero) fcolor(white) lcolor(white)) plotregion(lcolor(black))  title("A) Total wages", position(1) ring(0) margin(small) box bmargin(small) fcolor(white) justification(center)) name(htotal, replace)
	histogram log_b_real_wage if year==`i' & log_b_real_wage>=4.5 & log_b_real_wage<=7.5, w(0.05) fcolor(forest_green) fintensity(50) lcolor(forest_green) xtitle(Log Real Wage) xline(`mw86', lpattern(dash) lcolor(gs12)) xline(`mw94', lpattern(dash) lcolor(gs8)) xline(`mw', lcolor(gs5)) xlabel(4.5(0.5)7.5) ylabel(0(2)6, grid glcolor(gs15)) scheme(s2color) graphregion(margin(zero) fcolor(white) lcolor(white)) plotregion(lcolor(black))   title("B) Base wages", position(1) ring(0) margin(small) box bmargin(small) fcolor(white) justification(center)) name(hbase, replace)
	graph combine htotal hbase, title(`i') cols(1) xcommon imargin(zero) scheme(s2color) xsize(10) ysize(10) graphregion(margin(small) fcolor(white) lcolor(white%0)) name(h`i', replace)
	graph export "graphs/histograms/h`j'.pdf", as(pdf) name("h`i'") replace
	local j = `j'+1
}
foreach i of numlist 2007/2019 {
	qui sum log_real_minwage if year==`i'
	local mw = r(mean)
	histogram log_t_real_wage if year==`i' & log_t_real_wage>=4.5 & log_t_real_wage<=7.5, w(0.05) fcolor(forest_green) fintensity(50) lcolor(forest_green) xaxis(1 2) xtitle("", axis(2)) xlabel(`mw' "`i' MW", axis(2) labsize(small)) xtitle("") xline(`mw86' `mw94', lpattern(dash) lcolor(gs12)) xline(`mw06', lpattern(dash) lcolor(gs8)) xline(`mw', lcolor(gs5)) xlabel(none) ylabel(0(0.5)1.5, grid glcolor(gs15)) scheme(s2color) graphregion(margin(zero) fcolor(white) lcolor(white)) plotregion(lcolor(black))  title("A) Total wages", position(1) ring(0) margin(small) box bmargin(small) fcolor(white) justification(center)) name(htotal, replace)
	histogram log_b_real_wage if year==`i' & log_b_real_wage>=4.5 & log_b_real_wage<=7.5, w(0.05) fcolor(forest_green) fintensity(50) lcolor(forest_green) xtitle(Log Real Wage) xline(`mw86' `mw94', lpattern(dash) lcolor(gs12)) xline(`mw06', lpattern(dash) lcolor(gs8)) xline(`mw', lcolor(gs5)) xlabel(4.5(0.5)7.5) ylabel(0(2)6, grid glcolor(gs15)) scheme(s2color) graphregion(margin(zero) fcolor(white) lcolor(white)) plotregion(lcolor(black))   title("B) Base wages", position(1) ring(0) margin(small) box bmargin(small) fcolor(white) justification(center)) name(hbase, replace)
	graph combine htotal hbase, title(`i') cols(1) xcommon imargin(zero) scheme(s2color) xsize(10) ysize(10) graphregion(margin(small) fcolor(white) lcolor(white%0)) name(h`i', replace)
	graph export "graphs/histograms/h`j'.pdf", as(pdf) name("h`i'") replace
	local j = `j'+1
}


