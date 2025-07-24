/*
===============================================================================
	CPF Version 2.0 
	UKHLS 
	Syntax 03: Sample selection
===============================================================================
Purpose: Sample selection
Author:  Konrad Turek
Date:    06.2025
Input:   uk_02.dta (harmonized dataset)
Output:  uk_03.dta (sample selection)
===============================================================================
*/

* Log
capture log close 
log using "${ukhls_out}/uk_03_sample_selection.log", replace
display "Starting UKHLS sample selection at $S_TIME"

*################################################################################
*# 
*#  Open merged dataset
*# 
*################################################################################

use "${ukhls_out}/uk_02_CPF.dta" , clear


*################################################################################
*# 
*#	Criteria			
*# 
*################################################################################
**--------------------------------------
** Intreview status
**--------------------------------------

// ivfio // Interview outcome  
* proxy and refusal have values 
// bro pid wave   ivfio edu3 mlstat5 emplst5 whweek_ctr whmonth incjobs_mgLC srh5 satlife5 if ivfio==3

**--------------------------------------
** Age criteria
**--------------------------------------

keep if age>=18 //  


**--------------------------------------
** MV in age and gender
**--------------------------------------

keep if female~=.	 
keep if age~=.

drop if female==-1 


*################################################################################
*# 
*#	Save
*# 
*################################################################################
save "${ukhls_out}/uk_03_CPF.dta" , replace

* Close log	
display "Completed UKHLS sample selection at $S_TIME"
log close


*____________________________________________________________________________
*--->	END	OF FILE <---
	







