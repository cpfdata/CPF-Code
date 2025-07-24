/*
===============================================================================
	CPF Version 2.0 
	KLIPS 
	Syntax 03: Sample selection
===============================================================================
Purpose: Sample selection
Author:  Konrad Turek
Date:    06.2025
Input:   ko_02.dta (harmonized dataset)
Output:  ko_03.dta (sample selection)
===============================================================================
*/

* Log
capture log close 
log using "${klips_out}/ko_03_sample_selection.log", replace
display "Starting KLIPS sample selection at $S_TIME"


**--------------------------------------
** Open merged dataset
**-------------------------------------- 
use "${klips_out}/ko_02_CPF.dta", clear

*################################################################################
*#							
*#	Criteria				
*#
*################################################################################


**--------------------------------------
** Intreview status
**--------------------------------------

* No criteria, keep all like in CNEF 

// p_9509
// (1)  personal interview
// (2)  self-report 
// (3)  phone
// (4)  personal interview+phone
// (5)  self-report+phone
// (6)  personal interview+self-report 
// (7)  personal interview+self-report+phone
 
    
**--------------------------------------
** Age criteria
**--------------------------------------

keep if age>=18  


**--------------------------------------
** MV in age and gender
**--------------------------------------

keep if female~=.
keep if age~=.


*################################################################################
*#							
*#	Save					
*#							
*################################################################################
save "${klips_out}/ko_03_CPF.dta" , replace

* Log close
display "Completed KLIPS sample selection at $S_TIME"
log close



*____________________________________________________________________________
*--->	END	OF FILE <---

