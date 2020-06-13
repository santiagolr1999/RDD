
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear
 
***************************
*************2*************
***************************


gen DUI=1 if bac1>=0.08
replace DUI=0 if DUI==.


***************************
*************3*************
***************************

*Eyeball test

histogram bac1, xline(0.08) bin(1000) xtitle(BAC)
graph export "C:\Users\santi\Documents\RDD\Figures\Histogram bac1-eyeball test.png", replace


*McCrary

DCdensity bac1, breakpoint(0.08) generate(Xj Yj r0 fhat se_fhat) 
drop Yj Xj r0 fhat se_fhat
graph export "C:\Users\santi\Documents\RDD\Figures\Histogram bac1-eyeball test.png", replace

rddensity bac1, c(0.08) plot all


***************************
*************4*************
***************************
gen bac_dui=DUI*bac1


cd "C:\Users\santi\Documents\RDD\Tables"
reg male DUI bac1 bac_dui if inrange(bac1,0.03,0.13)
outreg2 using punto4.doc, replace
reg white DUI bac1 bac_dui if inrange(bac1,0.03,0.13)
outreg2 using punto4.doc, append
reg aged DUI bac1 bac_dui if inrange(bac1,0.03,0.13)
outreg2 using punto4.doc, append
reg acc DUI bac1 bac_dui if inrange(bac1,0.03,0.13)
outreg2 using punto4.doc, append



***************************
*************5*************
***************************

*Linear fit

rename bac1 BAC

cmogram acc BAC, lfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel A: Accident at scene) legend lineat(0.08)
cmogram male BAC, lfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel B: Male) legend lineat(0.08)
cmogram aged BAC, lfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel C: Age) legend lineat(0.08)
cmogram white BAC, lfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel D: White) legend lineat(0.08)

*Quadratic fit


cmogram acc BAC, qfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel A: Accident at scene) legend lineat(0.08)
cmogram male BAC, qfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel B: Male) legend lineat(0.08)
cmogram aged BAC, qfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel C: Age) legend lineat(0.08)
cmogram white BAC, qfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel D: White) legend lineat(0.08)

***************************
*************6*************
***************************

*Bandwidth (0.03-0.13)

cd "C:\Users\santi\Documents\RDD\Tables"

gen bac_dui_sq=bac_dui*bac_dui

reg recidivism DUI BAC male white aged acc if inrange(BAC, 0.03, 0.13), r
outreg2 using punto6a.doc, replace

reg recidivism DUI BAC bac_dui male white aged acc if inrange(BAC, 0.03, 0.13), r
outreg2 using punto6a.doc, append 

reg recidivism DUI BAC bac_dui bac_dui_sq male white aged acc if inrange(BAC, 0.03, 0.13), r
outreg2 using punto6a.doc, append

*Bandwidth (0.055-0.105)

reg recidivism DUI BAC male white aged acc if inrange(BAC, 0.055, 0.105), r
outreg2 using punto6b.doc, replace

reg recidivism DUI BAC bac_dui male white aged acc if inrange(BAC, 0.055, 0.105), r
outreg2 using punto6b.doc, append 

reg recidivism DUI BAC bac_dui bac_dui_sq male white aged acc if inrange(BAC, 0.055, 0.105), r
outreg2 using punto6b.doc, append 


***************************
*************7*************
***************************

cmogram recidivism BAC if BAC<=0.15, lfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel A: Linear Fit) legend lineat(0.08) 

cmogram recidivism BAC if BAC<=0.15, qfit  histopts(bin(30)) cutpoint(0.08) scatter title(Panel B: Quadratic Fit) legend lineat(0.08) 
