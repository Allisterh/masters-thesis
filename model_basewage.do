**# Pre-code for base wage
use the_data, clear

**# Model
keep if year>=$y0 & year<=$y1

*Get $y0 minimum wage category
qui sum mwbin if year==$y0
global mwbin${y0} = r(mean)

*Create a big rectangular matrix
keep year nss male tenure age educ age_edu nut2 cpi basebin mwbin
sort year
gen pid=_n
compress
fillin pid basebin
gen wagein=1-_fillin
foreach var of varlist year nss male tenure age educ age_edu nut2 cpi mwbin {
	egen `var'2 = mean(`var'), by(pid)
	replace `var' = `var'2 if missing(`var')
	drop `var'2
}
//generate cumwage =1 if at or below wage bin
sort pid basebin
by pid: gen cumwage = 1-sum(wagein)
replace cumwage = cumwage+1 if wagein==1
//generate minimum wage parameters
gen byte diff = basebin-mwbin
gen byte min3b=diff<=-3
gen byte min2b=diff<=-2
gen byte min1b=diff<=-1
gen byte min=diff<=0
gen byte min1a=diff<=1
gen byte min2a=diff<=2
gen byte min3a=diff<=3
gen byte min4a=diff<=4
gen byte min5a=diff<=5
gen byte min6a=diff<=6
gen byte min7a=diff<=7
gen byte min8a=diff<=8
gen byte min9a=diff<=9
gen byte min10a=diff<=10
//continuous bins
gen lbasebin=(basebin-1)/10
//experience and tenure squared
gen age2 = age^2
gen tenure2 = tenure^2
//heaping variables
gen lcutoff = exp(4.5+(basebin-2)*.05)*cpi
gen heaping=(20-floor(lcutoff/50))
replace heaping=0 if heaping<0
//drop, compress and save data
drop pid _fillin wagein lcutoff
compress
save "models/stacked_data_basewage",replace

*Probit model
probit cumwage /*min3b min2b min1b*/ min min1a min2a /*min3a min4a min5a min6a min7a min8a min9a min10a*/ heaping male tenure tenure2 age age2 educ i.age_edu i.nut2 i.year i.age_edu#c.lbasebin i.year#c.lbasebin i.basebin if basebin>=2 & basebin<=25, vce(cluster nss)

//save estimates
est save "models/estimates_basewage", replace


**# Construct actual and counterfactual distributions ($y1 distr with $y0 mw)
//fitted distribution
predict p_cumwage
//fitted distribution without spillovers
replace min1a=0 if diff>0
replace min2a=0 if diff>0
replace min3a=0 if diff>0
replace min4a=0 if diff>0
replace min5a=0 if diff>0
/*replace min6a=0 if diff>0
replace min7a=0 if diff>0
replace min8a=0 if diff>0
replace min9a=0 if diff>0
replace min10a=0 if diff>0*/
predict pn_cumwage
//CF distribution with $y0 mw
gen byte cdiff=basebin-$mwbin${y0}
replace min3b=cdiff<=-3
replace min2b=cdiff<=-2
replace min1b=cdiff<=-1
replace min=cdiff<=0
replace min1a=cdiff<=1
replace min2a=cdiff<=2
replace min3a=cdiff<=3
replace min4a=cdiff<=4
replace min5a=cdiff<=5
/*replace min6a=cdiff<=6
replace min7a=cdiff<=7
replace min8a=cdiff<=8
replace min9a=cdiff<=9
replace min10a=cdiff<=10*/
predict c_cumwage

*Compute reweighting factors
//set predicted to actual for bin==1 or bin>25
replace p_cumwage=cumwage if basebin==1 | basebin>25
replace pn_cumwage=cumwage if basebin==1 | basebin>25
replace c_cumwage=cumwage if basebin==1 | basebin>25
//collapse
collapse cumwage p_cumwage c_cumwage pn_cumwage, by(basebin year) fast

*Compute probabilities by wage bin
sort year basebin
by year: gen prw=cumwage-cumwage[_n+1]
by year: gen p_prw=p_cumwage-p_cumwage[_n+1]
by year: gen c_prw=c_cumwage-c_cumwage[_n+1]
by year: gen pn_prw=pn_cumwage-pn_cumwage[_n+1]
//replace last bin
replace prw=cumwage if basebin==62
replace p_prw=p_cumwage if basebin==62
replace c_prw=c_cumwage if basebin==62
replace pn_prw=pn_cumwage if basebin==62

*Compute reweighting factors
gen rw_ns_${y0}${y1}=pn_prw/p_prw
gen rw_mw_${y0}${y1}=c_prw/p_prw
//arrange
sort year basebin
keep year basebin rw*
//save
save "models/reweight_factors_basewage",replace

*Merge
use the_data, clear
merge m:m year basebin using "models/reweight_factors_basewage"
replace rw_ns_basewage = rw_ns_${y0}${y1} if year>=${y0} & year<=${y1}
replace rw_mw_basewage = rw_mw_${y0}${y1} if year>=${y0} & year<=${y1}
drop _merge rw_ns_${y0}${y1} rw_mw_${y0}${y1}
save the_data, replace
