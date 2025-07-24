/*
===============================================================================
CPF Version 2.0 
HILDA 
Syntax 02_3: Combine p1 & p2
===============================================================================
Purpose: Combine p1 & p2
Author:  Konrad Turek
Date:    06.2025
Input:   au_02a_cnef.dta, au_02b_waves.dta
Output:  au_02_CPF.dta
===============================================================================
*/

*################################################################################
*# 
*# SETUP AND CONFIGURATION
*# 
*################################################################################


* Log
capture log close 	
log using "${hilda_out}/au_02_3_preparation.log", replace
display "Starting HILDA data preparation at $S_TIME"


*################################################################################	
*#	
*#	Combine datasets	
*#	
*################################################################################	
*** equiv:
use "${hilda_out}/au_02a_cnef.dta", clear 
*
disp "vars: " c(k) "   N: " _N

*** add waves:
merge 1:1 pid wave using "${hilda_out}/au_02b_waves.dta" , ///
	keep(1 2 3) nogen 
*
disp "vars: " c(k) "   N: " _N

***
order pid wave inty* country  , first
order hh* jbm* x1* w1* hhw* lnw*, last
order hhin*, after(incjobs_pyg)
order age* edu* edhigh1, after(country)

*################################################################################	
*#	
*#	Destring pid		
*#	
*################################################################################	
destring pid , replace


*################################################################################	
*#	
*#	Cross-file fill MV	
*#	
*################################################################################	
*** wh
* Fill MV based on whyear (imputed by CNEF)

replace whmonth=whyear/12 if (whmonth==.|whmonth<0) & whyear>0 & whyear<.
replace whweek=whyear/(12*4.3) if (whweek==.|whweek<0) & whyear>0 & whyear<. 


*################################################################################	
*#	
*#	Create additional variables
*#	
*################################################################################	
**--------------------------------------
*   HH income - equivalized 
**--------------------------------------

* Set negative values to zero
recode hhinc_pypost (min/0=0), gen (temp_hhinc_pypost)
recode nphh (min/0=.), gen(temp_nphh)
recode kidsn_hh17 (min/0=0), gen(temp_kidsn_hh17)

* Check if the number of people in the household is consistent with the number of children aged 0-17
gen temp_err = temp_nphh-temp_kidsn_hh17
recode temp_err (min/-1=-1) (0/20=1)
tab temp_err

*** Equivalized HH income
gen hhinc_pypost_eq = temp_hhinc_pypost/(1 + .5*(temp_nphh - temp_kidsn_hh17 - 1) + .3*temp_kidsn_hh17) if temp_err==1
	drop temp*
lab var hhinc_pypost_eq "HH income(prev. year, post, equivalized)"





*################################################################################	
*#	
*#	Save
*#	
*################################################################################	

label data "CPF_Australia_${cpf_v}"
save "${hilda_out}/au_02_CPF.dta" , replace

*** Log close
display "Ending SHP data preparation at $S_TIME"
log close


*____________________________________________________________________________
*--->	END	OF FILE <---
	

