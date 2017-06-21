capture log close       			  
log using icpsrcda14-02-brm-p2, replace text   

//  program:    icpsrcda14-02-brm-p2.do
//  task:       Review 2 - Binary-part 2
//  project:    ICPSR CDA
//  author:     Trent Mize \ 2014-06-24

*program setup
version 	13.0 
clear 		all                 
set 		linesize 80           


//2.1b) Load the Data. 
spex 	icpsr_scireview3, clear

//2.1c) Re-estimate your binary logit model. 
logit 	faculty fellow phd mcit3 mnas
 
//2.2) Predicted Probabilities using predict. 
predict 	prlogit
label var 	prlogit "Logit: Predicted Probability"
sum 		prlogit
dotplot 	prlogit

graph export icpsrcda02-binary-fig1.png , width(1200) replace

//2.3) Discrete change. Marginal Effects at the Mean
mchange, atmeans

//2.4) Discrete change + confidence interval. 
mchange	fellow, atmeans stats(ci)

//2.5) Discrete change for C + confidence interval. 
mchange mcit3, atmeans stats(ci)

//2.6) Plot predicted probabilities.  
**For Fellows, across the range of mentor citations
mgen, 		at(fellow=1 mcit3=(0(5)130)) atmeans stub(fel1)
label var	fel1pr1 "Fellow"

**For Non-Fellows, across the range of mentor citations
mgen, 		at(fellow=0 mcit3=(0(5)130)) atmeans stub(fel0)
label var	fel0pr1 "Not a Fellow"

graph twoway ///
	(rarea fel1ul1 fel1ll1 fel1mcit3, color(gs10)) ///
	(rarea fel0ul1 fel0ll1 fel1mcit3, color(gs10)) ///
	(connected fel1pr1 fel1mcit3, lpattern(dash) msize(zero)) ///
	(connected fel0pr1 fel1mcit3, lpattern(solid) msize(zero)), ///
	legend(on order(3 4)) ///
	ylabel(0(.25)1) ytitle("Pr(Fellow)") ///
	xlabel(0(10)130) xtitle("Mentor's # of Citations") ///
	title("Predicted Probability of Having a Faculty Postion")

graph export icpsrcda02-binary-fig2.png , width(1200) replace

//2.END) Close Log File and Exit Do File. 
log close
exit





