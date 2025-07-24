
/*
===============================================================================
CPF Version 2.0 
SOEP 
Syntax 03: Sample Selection
===============================================================================
Purpose: Select sample of the SOEP data
Author:  Konrad Turek
Date:    06.2025
Input:   ge_02.dta (combined person-household file)
Output:  ge_03.dta (selected sample)
===============================================================================
*/

* Log
capture log close 
log using "${soep_out}/ge_03_sample_selection.log", replace
display "Starting SOEP sample selection at $S_TIME"



**--------------------------------------
** Open merged dataset
**-------------------------------------- 
* 
use "${soep_out}/ge_02_CPF.dta", clear  	



*################################################################################
*# 
*# SAMPLE SELECTION
*# 
*################################################################################


**--------------------------------------
** Interview status
**--------------------------------------
* Sample similar to pequiv (2016-17 differs slightly)
* Only Befragungsperson (Interviewed) 
* then also respstat==1
keep if netto>=10 & netto<=19 /// == nett[1] Befragungsperson (_P, _JUGEND) 
		& hnetto==1

  
  
	**--------------------------------------
	** Other filters by DIW			
	**--------------------------------------
	/* * * BALANCED VS UNBALANCED * * *

	keep if ( (vnetto >= 10 & vnetto < 20) )


	* * * PRIVATE VS ALL HOUSEHOLDS * * *

	keep if ( (vpop == 1 | vpop == 2) )
	*/


**--------------------------------------
** Age criteria
**--------------------------------------

keep if age>=18 //  



**--------------------------------------
** MV in age and gender
**--------------------------------------

keep if female~=.	 
keep if age~=.



*################################################################################
*# 
*# SAVE
*# 
*################################################################################
save "${soep_out}/ge_03_CPF.dta" , replace

* Log close
display "SOEP sample selection completed at $S_TIME"
log close
	
	
*---
* eof






