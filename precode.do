**# Pre-code
/*
* Restrictions
keep if sitpro==3
keep if age>=18 & age<65
keep if tenure<=600
keep if crem==0
keep if hnormais>=120
drop if nut2>=90

* Generate covariates
//profession
encode prof_1d, gen(prof)
//education
generate education = (hab_comp3==2)*1 + (hab_comp3==3)*2 + (hab_comp3==4)*3 + (hab_comp3>=5 & hab_comp3<7)*4 + (hab_comp3>=7)*5
label define educ 0 "Menos que 1o Ciclo" 1 "1o Ciclo" 2 "2o Ciclo" 3 "3o Ciclo" 4 "Secundário" 5 "Ensino superior", replace
label values education educ
*/
//years of education
gen educ = (hab_comp3<=1)*0 + (hab_comp3==2)*4 + (hab_comp3==3)*6 + (hab_comp3==4)*9 + (hab_comp3>=5 & hab_comp3<=6)*12 + (hab_comp3==7)*15 + (hab_comp3==8)*16 + (hab_comp3==9)*17 + (hab_comp3==10)*21
//age-education interactions
gen age_edu = .
local i = 0
forvalues e = 0/5 {
	replace age_edu = 1+`i' if education==`e' & inrange(age,0,27)
	replace age_edu = 2+`i' if education==`e' & inrange(age,28,38)
	replace age_edu = 3+`i' if education==`e' & inrange(age,38,.)
	local i = `i' + 3
}
//cpi
bysort year: egen cpi = median(round(rembase/real_wage, 0.00001))

* Use total wage
gen log_b_real_wage = log_real_wage
replace log_real_wage = log_t_real_wage
gen t_real_wage = exp(log_t_real_wage)

* Get minimum wage adjustment table before adjusting it
preserve
matrix mwadj = J(32,6,.)
forvalues i = 1/2 {
	bysor year: egen moda`i' = mode(log_t_real_wage)
	local j = 1
	foreach y of numlist 1986/1989 1991/2000 2002/2019 {
		qui sum moda`i' if year==`y'
		matrix mwadj[`j',`i'+2] = r(mean)
		local j = `j'+1
	}
	drop if moda`i'==log_t_real_wage
	drop moda`i'
}
restore
local j = 1
foreach y of numlist 1986/1989 1991/2000 2002/2019 {
	qui sum year if year==`y'
	matrix mwadj[`j',1] = r(mean)
	qui sum log_real_minwage if year==`y'
	matrix mwadj[`j',2] = r(mean)
	matrix mwadj[`j',5] = mwadj[`j',3] - mwadj[`j',2]
	matrix mwadj[`j',6] = mwadj[`j',4] - mwadj[`j',2]
	local j = `j'+1
}

* Adjust minimum wage
local j = 1
foreach y of numlist 1986/1989 1991/1992 {
	replace log_real_minwage = mwadj[`j',3] if year==`y'
	local j = `j'+1
}
replace log_real_minwage = mwadj[`j',4] if year==1993
local j = `j'+1
foreach y of numlist 1994/2000 {
	replace log_real_minwage = mwadj[`j',3] if year==`y'
	local j = `j'+1
}

* Create wage and minimum wage bins
gen bin=0
replace bin=1 if log_real_wage<=4.5
replace bin=62 if log_real_wage>7.5
gen basebin=0
replace basebin=1 if log_b_real_wage<=4.5
replace basebin=62 if log_b_real_wage>7.5
gen mwbin=0
replace mwbin=1 if log_real_minwage<=4.5
forvalues i = 1/60{
	replace bin=1+`i' if log_real_wage>4.5+(`i'-1)*.05 & log_real_wage<=4.5+`i'*.05
	replace basebin=1+`i' if log_b_real_wage>4.5+(`i'-1)*.05 & log_b_real_wage<=4.5+`i'*.05
	replace mwbin=1+`i' if log_real_minwage>4.5+(`i'-1)*.05 & log_real_minwage<=4.5+`i'*.05
}

* Create reweighting factor variables to add later
gen rw_ns = .
gen rw_mw = .
gen rw_ns_basewage = .
gen rw_mw_basewage = .
gen rw_ns_bysex = .
gen rw_mw_bysex = .

* save
compress
save the_data, replace
