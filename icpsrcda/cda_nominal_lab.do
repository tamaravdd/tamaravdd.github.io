//5.1a) Set-up your do-file. 
capture log close
log using icpsrcda14-05-nominal, replace text

//  program:    icpsrcda14-05-nominal.do
//  task:       Review 5 - Nominal Regression
//  project:    ICPSR CDA
//  author:     Trent Mize \ 2014-06-24

*program setup
version 	13.0
clear 		all 
set 		linesize 80

//5.1b) Load the Data.
spex 	icpsr_scireview3, clear

//5.1c) Examine data, select variables, drop missing, and verify. 
codebook, 	compact
keep 		jobprst female mcit3 pub1 phd 
misschk, 	gen(m)
tab 		mnumber
keep if 	mnumber==0
tab1 		jobprst 

//5.2) Verify data are clean. 
codebook 	jobprst female mcit3 pub1 phd, compact
sum 		jobprst female mcit3 pub1 phd

//5.4a) Multinomial Logit. 
mlogit 		jobprst i.female mcit3 pub1 phd, baseoutcome(4) nolog

//5.4b) Multinomial Logit. 
listcoef, 	help

//5.5) Single Coefficient Wald & LR Test. 
mlogtest 	1.female mcit3, wald lr

//5.6) OR Plot using mlogitplot
mlogitplot 	female mcit3, amount(one sd) ///
			symbols(Ad Good Str Dis) ///
			note(Job: 1=Adeq 2=Good 3=Strong 4=Distinguished)

graph export icpsrcda05-nominal-fig1.png , width(1200) replace

//5.8a) Discrete Change.  
mchange, atmeans

//5.8b) Marginal Effects Plot
mchangeplot female mcit3, amount(one sd) ///
			symbols(Ad Good Str Dis) ///
			note(Job: 1=Adeq 2=Good 3=Strong 4=Distinguished)

graph export icpsrcda05-nominal-fig2.png , width(1200) replace
	
//5.9) 	Calculating and Plotting Discrete Change II at specified levels
*		of the covariates
mchange, at(phd=4 pub1=4) atmeans
mchangeplot female mcit3, amount(one sd) ///
			symbols(Ad Good Str Dis) ///
			note(Job: 1=Adeq 2=Good 3=Strong 4=Distinguished) ///
			min(-.27) max(.29)

graph export icpsrcda05-nominal-fig3.png , width(1200) replace
 
//5.END) Close Log File and Exit Do File.
log close
exit






 
