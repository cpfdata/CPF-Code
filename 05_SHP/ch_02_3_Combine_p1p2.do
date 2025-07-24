/*
===============================================================================
CPF Version 2.0 
SHP 
Syntax 02_3: Combine p1 and p2 
===============================================================================
Purpose: Combine eqiv (p1) & waves (p2) datasets	
Author:  Konrad Turek
Date:    06.2025
Input:   ch_02a_cnef.dta, ch_02b_wave.dta 
Output:  ch_02_CPF.dta 
===============================================================================
*/

*################################################################################
*# 
*# SETUP AND CONFIGURATION
*# 
*################################################################################

* Log
capture log close 
log using "${shp_out}/ch_02_3_preparation.log", replace
display "Starting SHP data preparation at $S_TIME"


*################################################################################
*#							
*#	Combine datasets	
*#							
*################################################################################
*** equiv:
use "${shp_out}/ch_02a_cnef.dta", clear 
*
disp "vars: " c(k) "   N: " _N

*** add waves:
merge 1:1 pid wave using "${shp_out}/ch_02b_wave.dta" , ///
	keep(1 2 3) nogen 
*
disp "vars: " c(k) "   N: " _N


*################################################################################
*#							
*#	Cross-fill MV		
*#							
*################################################################################

* wh
* Fill MV based on whyear (imputed by CNEF)

replace whmonth=whyear/12 if (whmonth==.|whmonth<0) & whyear>0 & whyear<.
replace whweek=whyear/(12*4.3) if (whweek==.|whweek<0) & whyear>0 & whyear<. 



*################################################################################
*#							
*#	SAVE
*#							
*################################################################################

label data "CPF_SHP_${cpfv}"
save "${shp_out}/ch_02_CPF.dta" , replace


*** Log close
display "Ending SHP data preparation at $S_TIME"
log close

*____________________________________________________________________________
*--->	END	 OF FILE  <---






	
	


