**# Distributional statistics

use the_data, clear
qui sum log_real_minwage if year==${y0}
gen mw_share${y0} = log_real_wage<=r(mean)
qui sum log_real_minwage if year==${y1}
gen mw_share${y1} = log_real_wage<=r(mean)

matrix stats = J(9,7,.)

//${y0}
qui sum log_real_wage if year==${y0}, detail
matrix stats[1,1] = round(r(sd), 0.01)
matrix stats[1,2] = round(r(p90)-r(p10), 0.01)
matrix stats[1,3] = round(r(p90)-r(p50), 0.01)
matrix stats[1,4] = round(r(p50)-r(p10), 0.01)
matrix stats[1,7] = round(r(mean), 0.01)
qui sum mw_share${y0} if year==${y0}
matrix stats[1,5] = round(r(mean), 0.01)
qui sum mw_share${y1} if year==${y0}
matrix stats[1,6] = round(r(mean), 0.01)

//${y1}
qui sum log_real_wage if year==${y1}, detail
matrix stats[2,1] = round(r(sd), 0.01)
matrix stats[2,2] = round(r(p90)-r(p10), 0.01)
matrix stats[2,3] = round(r(p90)-r(p50), 0.01)
matrix stats[2,4] = round(r(p50)-r(p10), 0.01)
matrix stats[2,7] = round(r(mean), 0.01)
qui sum mw_share${y0} if year==${y1}
matrix stats[2,5] = round(r(mean), 0.01)
qui sum mw_share${y1} if year==${y1}
matrix stats[2,6] = round(r(mean), 0.01)

//${y1} w/ ${y0} minimum wage
qui sum log_real_wage [w=rw_mw] if year==${y1}, detail
matrix stats[3,1] = round(r(sd), 0.01)
matrix stats[3,2] = round(r(p90)-r(p10), 0.01)
matrix stats[3,3] = round(r(p90)-r(p50), 0.01)
matrix stats[3,4] = round(r(p50)-r(p10), 0.01)
matrix stats[3,7] = round(r(mean), 0.01)
qui sum mw_share${y0} [w=rw_mw] if year==${y1}
matrix stats[3,5] = round(r(mean), 0.01)
qui sum mw_share${y1} [w=rw_mw] if year==${y1}
matrix stats[3,6] = round(r(mean), 0.01)

//${y1} w/o spillovers
qui sum log_real_wage [w=rw_ns] if year==${y1}, detail
matrix stats[4,1] = round(r(sd), 0.01)
matrix stats[4,2] = round(r(p90)-r(p10), 0.01)
matrix stats[4,3] = round(r(p90)-r(p50), 0.01)
matrix stats[4,4] = round(r(p50)-r(p10), 0.01)
matrix stats[4,7] = round(r(mean), 0.01)
qui sum mw_share${y0} [w=rw_ns] if year==${y1}
matrix stats[4,5] = round(r(mean), 0.01)
qui sum mw_share${y1} [w=rw_ns] if year==${y1}
matrix stats[4,6] = round(r(mean), 0.01)

//total change
forvalues c = 1/7 {
	matrix stats[5,`c'] = stats[2,`c']-stats[1,`c']
}

//underlying change
forvalues c = 1/7 {
	matrix stats[6,`c'] = stats[3,`c']-stats[1,`c']
}
//Change due to MW bite
forvalues c = 1/7 {
	matrix stats[7,`c'] = stats[4,`c']-stats[3,`c']
}
//Change due to spillovers
forvalues c = 1/7 {
	matrix stats[8,`c'] = stats[2,`c']-stats[4,`c']
}
//Percentage of change explained by the MW
forvalues c = 1/7 {
	matrix stats[9,`c'] = round(((stats[7,`c']+stats[8,`c'])/stats[5,`c']), 0.01)
}

//Put in excel
putexcel set results, modify sheet("Results")
putexcel A${line2} = "${y0}"
putexcel A${line3} = "${y1}"
putexcel A${line4} = "${y1} w/ ${y0} MW"
putexcel A${line5} = "${y1} w/o spillovers"
putexcel A${line6} = "Total change"
putexcel A${line7} = "Underlying change"
putexcel A${line8} = "Change due to MW bite"
putexcel A${line9} = "Change due to spillovers"
putexcel A${line10} = "Percentage of change explained by the MW"
putexcel B${line2} = matrix(stats)
