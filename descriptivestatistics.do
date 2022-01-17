**# Compute descriptive statistics
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
putexcel set results, modify sheet("Descriptive Statistics")
mkmat year male educ log_real_wage p10 p50 p90 log_real_minwage rel_log_minwage mw_share_twage mw_share_bwage gini sd p90p10 p90p50 p75p25 p50p10, mat(descriptive)
putexcel A2 = matrix(descriptive)
putexcel A1 = "Year"
putexcel B1 = "Share of males"
putexcel C1 = "Average years of education"
putexcel D1 = "Mean log_real_wage"
putexcel E1 = "P10 log_real_wage"
putexcel F1 = "P50 log_real_wage"
putexcel G1 = "P90 log_real_wage"
putexcel H1 = "Log_real_minwage"
putexcel I1 = "Relative log_minwage"
putexcel J1 = "Share of workers on the minimum wage or less (total wage)"
putexcel K1 = "Share of workers on the minimum wage or less (base wage)"
putexcel L1 = "Gini"
putexcel M1 = "Standard deviation"
putexcel N1 = "90-10 differential"
putexcel O1 = "90-50 differential"
putexcel P1 = "75-25 differential"
putexcel Q1 = "50-10 differential"
