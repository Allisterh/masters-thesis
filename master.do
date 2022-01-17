**# Master .do file (it takes ~3h)
clear all
//Choose directory
cd "/Users/carlosoliveira/Desktop/Mestrado/Tese/Stata/Distribution regressions"
//Choose main data file
use "QP_CARLOS_Tese.dta", clear
//Choose sample size
set seed 2021
sample 10

**# Pre-code
do do_files/precode.do

**# Run the models and get reweighting factors
//2006-2019
global y0 = 2006
global y1 = 2019
do do_files/model.do
//1994-2006
global y0 = 1994
global y1 = 2006
do do_files/model_2.do
//1986-1994
global y0 = 1986
global y1 = 1994
do do_files/model_3.do
//2006-2019 by gender
global y0 = 2006
global y1 = 2019
do do_files/model_bysex.do
//2006-2019 w/ base wage
global y0 = 2006
global y1 = 2019
do do_files/model_basewage.do

**# Get graphs
//descriptive graphs
do do_files/descriptivegraphs.do
//2006-2019
global y0 = 2006
global y1 = 2019
do do_files/plots.do
//1994-2006
global y0 = 1994
global y1 = 2006
do do_files/plots.do
//1986-1994
global y0 = 1986
global y1 = 1994
do do_files/plots.do
//2006-2019 by sex
do do_files/plots_bysex.do
//2006-2019 w/ base wage
do do_files/plots_basewage.do
//specific plots
do do_files/plots_specific.do

**# Compute statistics, results and estimates
//descriptive statistics
do do_files/descriptivestatistics.do
//distributional statistics and results
do do_files/all_statistics.do
//table with estimates
do do_files/estimates.do
