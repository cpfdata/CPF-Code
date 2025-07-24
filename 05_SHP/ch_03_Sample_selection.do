/*
===============================================================================
CPF Version 2.0 
SHP 
Syntax 03: Sample selection 
===============================================================================
Purpose: Select sample based on criteria
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
log using "${shp_out}/ch_03_sample_selection.log", replace
display "Starting SHP sample selection at $S_TIME"

**--------------------------------------
** Open merged dataset
**-------------------------------------- 
* 
use "${shp_out}/ch_02_CPF.dta", clear 

*################################################################################
*#							
*#	Criteria			
*#							
*################################################################################
**--------------------------------------
** Intreview status
**--------------------------------------
* Status - non-resp have some values on educ, marita and employment - can also keep them if useful for some analysis
keep if respstat==1
drop respstat2


**--------------------------------------
** Age criteria
**--------------------------------------

keep if age>=18 //  



**--------------------------------------
** MV in age and gender
**--------------------------------------

keep if female~=.	// delets 7700 obs with mostly MV and not info on resp. status 
keep if age~=.



*################################################################################
*#							
*#	Save				
*#							
*################################################################################
save "${shp_out}/ch_03_CPF.dta" , replace


*** Log close
display "Ending SHP sample selection at $S_TIME"
log close

*____________________________________________________________________________
*--->	END	 OF FILE  <---


