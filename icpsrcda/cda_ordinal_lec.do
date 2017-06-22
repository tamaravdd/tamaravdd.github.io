**Ordinal
spex ordwarm3
codebook warm yr89 male age ed prst, compact
sum warm yr89 male age ed prst
tab warm

ologit warm i.yr89 i.male age ed prst, nolog
oprobit warm i.yr89 i.male age ed prst, nolog

qui ologit warm i.yr89 i.male age ed prst, nolog
est sto ologit
qui oprobit warm i.yr89 i.male age ed prst, nolog
est sto oprobit

esttab ologit oprobit , ///
    mtitle(OLogit OProbit) b(%9.2f) wide nostar noparen nogaps nonumbers

gen warm1 = warm <= 1 if warm<.
label variable warmlt2 "1=SD; 0=D,A,SA"
gen warm2 = warm <= 2 if warm<.
label variable warmlt3 "1=SD,D; 0=A,SA"
gen warm3 = warm <= 3 if warm<.
label variable warmlt4 "1=SD,D,A; 0=SA"
qui logit warm1 yr89 male age ed prst, nolog
eststo warm1
qui logit warm2 yr89 male age ed prst, nolog
eststo warm2
qui logit warm3 yr89 male age ed prst, nolog
eststo warm3


esttab warm*, b(%9.2f) nonumber not mtitles(warm1 warm2 warm3)

ologit warm yr89 male age ed prst
listcoef, help
listcoef, help percent

qui ologit warm i.yr89 i.male age ed prst, nolog
predict pry1 pry2 pry3 pry4
label var pry1 "Pr(SD)"
label var pry2 "Pr(D)"
label var pry3 "Pr(A)"
label var pry4 "Pr(SA)"
dotplot pry1 pry2 pry3 pry4, ylabel(0(.25).75)

graph export orm-02-dotplot.png , width(1200) replace


mtable, at(male=(0 1) yr89=(0 1)) atmeans

mgen, at(male=1 yr89=1 age=(20(5)80)) atmeans stub(M89)
label var M89pr1 "SD"
label var M89pr2 "D"
label var M89pr3 "A"
label var M89pr4 "SD"

graph twoway connected M89pr1 M89pr2 M89pr3 M89pr4 M89age ///
 , title("Support for Working Women By Age") ///
 lcolor(red orange green blue) ///
 subtitle(Males in Survey Year 1989) ///
 xtitle("Age") ///
 ytitle("Predicted Pr(Support)") ///
 xlabel(20(10)80) ylabel(0(.25).50, grid) ///
 msymbol(none none none none) ///
 saving(orm-m89.gph,replace)

mgen, at(male=0 yr89=1 age=(20(5)80)) atmeans stub(F89) 
label var F89Cpr1 "SD"
label var F89Cpr2 "SD or D"
label var F89Cpr3 "SD, D or A"

codebook F89C*, compact 
 
graph twoway connected F89Cpr1 F89Cpr2 F89Cpr3 F89Cpr4 F89age ///
 , title("Support for Working Women By Age") ///
 lcolor(red orange green blue) ///
 subtitle(Females in Survey Year 1989) ///
 xtitle("Age") ///
 ytitle("Cumulative Pr(Support)") ///
 xlabel(20(10)80) ylabel(0(.25)1, grid) ///
 msymbol(none none none none) ///
 text(.89 25 "Strongly Agree",place(e)) ///
 text(.44 25 "Agree",place(e)) ///
 text(.19 58 "Disagree",place(e)) ///
 text(.055 65 "Strongly Disagree",place(e)) ///
 , legend(off)

 graph export orm-06-cumulativeprob-agew89.png , width(1200) replace 


graph twoway ///
 (area F89Cpr1 F89age, color(red) fintensity(40)) ///
 (rarea F89Cpr1 F89Cpr2 F89age, color(orange) fintensity(40)) ///
 (rarea F89Cpr2 F89Cpr3 F89age, color(green) fintensity(40)) ///
 (rarea F89Cpr3 F89Cpr4 F89age, color(blue) fintensity(40)) ///
 , title("Support for Working Women By Age") ///
 subtitle(Females in Survey Year 1989) ///
 xtitle("Age") ///
 ytitle("Cumulative Pr(Support)") ///
 xlabel(20(10)80) ylabel(0(.25)1, grid) ///
 text(.89 25 "Strongly Agree",place(e)) ///
 text(.44 25 "Agree",place(e)) ///
 text(.19 58 "Disagree",place(e)) ///
 text(.055 65 "Strongly Disagree",place(e)) ///
 legend(off)

 
graph twoway ///
 (area F89Cpr1 F89age, color(red)) ///
 (rarea F89Cpr1 F89Cpr2 F89age, color(orange)) ///
 (rarea F89Cpr2 F89Cpr3 F89age, color(green)) ///
 (rarea F89Cpr3 F89Cpr4 F89age, color(blue)) ///
 , title("Support for Working Women By Age") ///
 subtitle(Females in Survey Year 1989) ///
 xtitle("Age") ///
 ytitle("Cumulative Pr(Support)") ///
 xlabel(20(10)80) ylabel(0(.25)1, grid) ///
 text(.89 25 "Strongly Agree",color(white) place(e)) ///
 text(.44 25 "Agree",color(white) place(e)) ///
 text(.19 58 "Disagree",place(e)) ///
 text(.055 65 "Strongly Disagree",place(e)) ///
 legend(off)
 
 
mchange, atmeans

//gender difference for 1989 and 1977
margins, at(male=(0 1) yr89=(0 1)) atmeans predict(outcome(1)) post

mlincom (2-1)
mlincom (4-3)

foreach out in 1 2 3 4 {
 qui ologit warm i.yr89 i.male age ed prst, nolog
 di "**Outcome=`out'"
 margins, at(male=(0 1) yr89=(0 1)) ///
 atmeans predict(outcome(`out')) post
 mlincom (2-1)
 mlincom (4-3)
 }
 
 
qui ologit warm i.yr89 i.male age ed prst, nolog
qui margins, at(male=(0 1) yr89=(0 1)) ///
atmeans predict(outcome(1)) post
mlincom (4-3)-(2-1)
 
 foreach out in 1 2 3 4 {
 qui ologit warm i.yr89 i.male age ed prst, nolog
 qui margins, at(yr89=(0 1) male=(0 1)) ///
 predict(outcome(`out')) post // predictions posted
 qui mlincom (2-1)-(4-3), add rowname(Outcome`out') ///
 stats(est p lb ub)
 }

mlincom
 
qui ologit warm i.yr89 i.male age ed prst, nolog
brant, detail 
 
gologit2 warm yr89 male white age ed prst, auto lrforce



