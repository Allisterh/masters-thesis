**# All statistics

putexcel set results, modify sheet("Results")

//titles table 1
putexcel B1 = "Sd"
putexcel C1 = "90-10"
putexcel D1 = "90-50"
putexcel E1 = "50-10"
putexcel F1 = "Workers on 1st year MW"
putexcel G1 = "Workers on last year MW"
putexcel H1 = "Mean wage"
//titles table 2
putexcel B33 = "Sd"
putexcel C33 = "90-10"
putexcel D33 = "90-50"
putexcel E33 = "50-10"
putexcel F33 = "Workers on 1st year MW"
putexcel G33 = "Workers on last year MW"
putexcel H33 = "Mean wage"

*1986-1994
global y0 = 1986
global y1 = 1994
global line1 = 2
global line2 = ${line1} + 1
global line3 = ${line1} + 2
global line4 = ${line1} + 3
global line5 = ${line1} + 4
global line6 = ${line1} + 5
global line7 = ${line1} + 6
global line8 = ${line1} + 7
global line9 = ${line1} + 8
global line10 = ${line1} + 9
do do_files/statistics.do
putexcel A${line1} = "1986-1994"

*1994-2006
global y0 = 1994
global y1 = 2006
global line1 = ${line1} + 10
global line2 = ${line1} + 1
global line3 = ${line1} + 2
global line4 = ${line1} + 3
global line5 = ${line1} + 4
global line6 = ${line1} + 5
global line7 = ${line1} + 6
global line8 = ${line1} + 7
global line9 = ${line1} + 8
global line10 = ${line1} + 9
do do_files/statistics.do
putexcel A${line1} = "1994-2006"

*2006-2019
global y0 = 2006
global y1 = 2019
global line1 = ${line1} + 10
global line2 = ${line1} + 1
global line3 = ${line1} + 2
global line4 = ${line1} + 3
global line5 = ${line1} + 4
global line6 = ${line1} + 5
global line7 = ${line1} + 6
global line8 = ${line1} + 7
global line9 = ${line1} + 8
global line10 = ${line1} + 9
do do_files/statistics.do
putexcel A${line1} = "2006-2019"

*2006-2019 females
global y0 = 2006
global y1 = 2019
global line1 = ${line1} + 12
global line2 = ${line1} + 1
global line3 = ${line1} + 2
global line4 = ${line1} + 3
global line5 = ${line1} + 4
global line6 = ${line1} + 5
global line7 = ${line1} + 6
global line8 = ${line1} + 7
global line9 = ${line1} + 8
global line10 = ${line1} + 9
global sex = 0
do do_files/statistics_bysex.do
putexcel A${line1} = "Females"

*2006-2019 males
global y0 = 2006
global y1 = 2019
global line1 = ${line1} + 10
global line2 = ${line1} + 1
global line3 = ${line1} + 2
global line4 = ${line1} + 3
global line5 = ${line1} + 4
global line6 = ${line1} + 5
global line7 = ${line1} + 6
global line8 = ${line1} + 7
global line9 = ${line1} + 8
global line10 = ${line1} + 9
global sex = 1
do do_files/statistics_bysex.do
putexcel A${line1} = "Males"

*2006-2019 base wage
global y0 = 2006
global y1 = 2019
global line1 = ${line1} + 10
global line2 = ${line1} + 1
global line3 = ${line1} + 2
global line4 = ${line1} + 3
global line5 = ${line1} + 4
global line6 = ${line1} + 5
global line7 = ${line1} + 6
global line8 = ${line1} + 7
global line9 = ${line1} + 8
global line10 = ${line1} + 9
do do_files/statistics_basewage.do
putexcel A${line1} = "Base wage"

