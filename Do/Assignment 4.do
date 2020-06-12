
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear
 
***************************
*************2*************
***************************


gen diu=1 if bac1>=0.08
replace diu=0 if diu==.


***************************
*************3*************
***************************

*Eyeball test

histogram bac1, xline(0.08) bin(1000) xtitle(BAC)
graph export "C:\Users\santi\Documents\RDD\Figures\Histogram bac1-eyeball test.png", replace


*McCrary

DCdensity bac1, breakpoint(0.08) generate(Xj Yj r0 fhat se_fhat) 
drop Yj Xj r0 fhat se_fhat
*t=0.069589706
*Approximate p-value=0.472296
*Do not reject H0
*Therefore is not manipulated

graph export "C:\Users\santi\Documents\RDD\Figures\Histogram bac1-eyeball test.png", replace


***************************
*************4*************
***************************
gen bac_dui=diu*bac1

reg male diu bac1 bac_dui
reg white diu bac1 bac_dui
reg aged diu bac1 bac_dui
reg acc diu bac1 bac_dui

