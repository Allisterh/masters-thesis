**# Table with estimates

//2006-2019
est use  models/estimates_20062019.ster
est store estimates_20062019
//1994-2006
est use  models/estimates_19942006.ster
est store estimates_19942006
//1986-1994
est use  models/estimates_19861994.ster
est store estimates_19861994
//2006-2019 w/ base wage
est use  models/estimates_basewage.ster
est store estimates_basewage

*Get table
est table estimates_20062019 estimates_19942006 estimates_19861994 estimates_basewage, b(%7.3f) se(%7.3f) stats(N) keep(min3b min2b min1b min min1a min2a min3a min4a min5a min6a min7a min8a)
//save
putexcel set results, modify sheet("Coefficients")
putexcel A1 = etable
