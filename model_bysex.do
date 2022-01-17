**# Model by gender

**# Females
use "models/stacked_data_${y0}${y1}",clear
est use "models/estimates_${y0}${y1}"
keep if male==0

*Construct actual and counterfactual distributions ($y1 distr with $y0 mw)
//fitted distribution
predict p_cumwage
//fitted distribution without spillovers
replace min1a=0 if diff>0
replace min2a=0 if diff>0
replace min3a=0 if diff>0
replace min4a=0 if diff>0
replace min5a=0 if diff>0
replace min6a=0 if diff>0
replace min7a=0 if diff>0
replace min8a=0 if diff>0
*replace min9a=0 if diff>0
*replace min10a=0 if diff>0
predict pn_cumwage
//CF distribution with $y0 mw
gen byte cdiff=bin-$mwbin${y0}
*replace min3b=cdiff<=-3
*replace min2b=cdiff<=-2
*replace min1b=cdiff<=-1
replace min=cdiff<=0
replace min1a=cdiff<=1
replace min2a=cdiff<=2
replace min3a=cdiff<=3
replace min4a=cdiff<=4
replace min5a=cdiff<=5
replace min6a=cdiff<=6
replace min7a=cdiff<=7
replace min8a=cdiff<=8
*replace min9a=cdiff<=9
*replace min10a=cdiff<=10
predict c_cumwage

*Compute reweighting factors
//set predicted to actual for bin==1 or bin>35
replace p_cumwage=cumwage if bin==1 | bin>35
replace pn_cumwage=cumwage if bin==1 | bin>35
replace c_cumwage=cumwage if bin==1 | bin>35
//collapse
collapse cumwage p_cumwage c_cumwage pn_cumwage, by(bin year) fast

*Compute probabilities by wage bin
sort year bin
by year: gen prw=cumwage-cumwage[_n+1]
by year: gen p_prw=p_cumwage-p_cumwage[_n+1]
by year: gen c_prw=c_cumwage-c_cumwage[_n+1]
by year: gen pn_prw=pn_cumwage-pn_cumwage[_n+1]
//replace last bin
replace prw=cumwage if bin==62
replace p_prw=p_cumwage if bin==62
replace c_prw=c_cumwage if bin==62
replace pn_prw=pn_cumwage if bin==62

*Compute reweighting factors
gen rw_ns_${y0}${y1}=pn_prw/p_prw
gen rw_mw_${y0}${y1}=c_prw/p_prw
//arrange
sort year bin
keep year bin rw*
//save
save "models/reweight_factors_females",replace

*Merge
use the_data, clear
merge m:m year bin using "models/reweight_factors_females"
replace rw_ns_bysex = rw_ns_${y0}${y1} if year>=${y0} & year<=${y1} & male==0
replace rw_mw_bysex = rw_mw_${y0}${y1} if year>=${y0} & year<=${y1} & male==0
drop _merge rw_ns_${y0}${y1} rw_mw_${y0}${y1}
save the_data, replace


**# Males
use "models/stacked_data_${y0}${y1}",clear
est use "models/estimates_${y0}${y1}"
keep if male==1

*Construct actual and counterfactual distributions ($y1 distr with $y0 mw)
//fitted distribution
predict p_cumwage
//fitted distribution without spillovers
replace min1a=0 if diff>0
replace min2a=0 if diff>0
replace min3a=0 if diff>0
replace min4a=0 if diff>0
replace min5a=0 if diff>0
replace min6a=0 if diff>0
replace min7a=0 if diff>0
replace min8a=0 if diff>0
replace min9a=0 if diff>0
replace min10a=0 if diff>0
predict pn_cumwage
//CF distribution with $y0 mw
gen byte cdiff=bin-$mwbin${y0}
*replace min3b=cdiff<=-3
*replace min2b=cdiff<=-2
*replace min1b=cdiff<=-1
replace min=cdiff<=0
replace min1a=cdiff<=1
replace min2a=cdiff<=2
replace min3a=cdiff<=3
replace min4a=cdiff<=4
replace min5a=cdiff<=5
replace min6a=cdiff<=6
replace min7a=cdiff<=7
replace min8a=cdiff<=8
*replace min9a=cdiff<=9
*replace min10a=cdiff<=10
predict c_cumwage

*Compute reweighting factors
//set predicted to actual for bin==1 or bin>35
replace p_cumwage=cumwage if bin==1 | bin>35
replace pn_cumwage=cumwage if bin==1 | bin>35
replace c_cumwage=cumwage if bin==1 | bin>35
//collapse
collapse cumwage p_cumwage c_cumwage pn_cumwage, by(bin year) fast

*Compute probabilities by wage bin
sort year bin
by year: gen prw=cumwage-cumwage[_n+1]
by year: gen p_prw=p_cumwage-p_cumwage[_n+1]
by year: gen c_prw=c_cumwage-c_cumwage[_n+1]
by year: gen pn_prw=pn_cumwage-pn_cumwage[_n+1]
//replace last bin
replace prw=cumwage if bin==62
replace p_prw=p_cumwage if bin==62
replace c_prw=c_cumwage if bin==62
replace pn_prw=pn_cumwage if bin==62

*Compute reweighting factors
gen rw_ns_${y0}${y1}=pn_prw/p_prw
gen rw_mw_${y0}${y1}=c_prw/p_prw
//arrange
sort year bin
keep year bin rw*
//save
save "models/reweight_factors_males",replace

*Merge
use the_data, clear
merge m:m year bin using "models/reweight_factors_males"
replace rw_ns_bysex = rw_ns_${y0}${y1} if year>=${y0} & year<=${y1} & male==1
replace rw_mw_bysex = rw_mw_${y0}${y1} if year>=${y0} & year<=${y1} & male==1
drop _merge rw_ns_${y0}${y1} rw_mw_${y0}${y1}
save the_data, replace
