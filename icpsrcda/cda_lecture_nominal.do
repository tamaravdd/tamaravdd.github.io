**MNLM

spex nomocc2
codebook, compact
sum
tab occ

mlogit occ i.white ed exper, base(1) nolog
listcoef, help

listcoef white, pval(.05)

quietly mlogit occ white ed exper , base(1)
mchange

mchangeplot 1.white ed exper, ///
 note(Job: M=Menial B=BlCol C=Craft W=WhCol P=Prof)

margins, at(white=(0 1)) atmeans post 
mlincom (2-1)

quietly mlogit occ white ed exper , base(1)
listcoef, help

//OR plot
quietly mlogit occ white ed exper , base(1)
mchange
mlogitplot , amount(sd) symbols(M B C W P) mcolor(rainbow) ///
note(Job: M=Menial B=BlColl C=Craft W=WhColl P=Prof) ///
min(-3) max(0.5) gap(.5)

graph export mnlm-02-ORplot.png , replace

//DC and OR combined
mlogitplot , amount(sd) symbols(M B C W P) mcolor(rainbow) ///
note(Job: M=Menial B=BlColl C=Craft W=WhColl P=Prof) ///
min(-3) max(0.5) gap(.5) meffect

graph export mnlm-03-DCORplot.png , replace
 
quietly mlogit occ i.white ed exper, base(1) nolog
estimates store base
quietly mlogit occ i.white exper, base(1) nolog
estimates store noed
lrtest base noed
 
quietly mlogit occ i.white ed exper,base(1)
test ed
 
quietly mlogit occ white ed exper,base(1)
mlogtest ed , lr wald 
 
mlogtest, combine
mlogtest, lrcombine

set seed 112
mlogtest , iia 
 
set seed 1821
mlogtest , iia 
