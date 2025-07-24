/*
===============================================================================
CPF Version 2.0 
SHP 
Syntax 01_1: Create long file (pequiv / CNEF)
===============================================================================
Purpose: Prepare and combine SHP panel data files across all waves
Author:  Konrad Turek
Date:    06.2025
Input:   shpequiv_long.dta 
Output:  ch_01_shpequivL.dta 
===============================================================================
*/

* Log
capture log close 
log using "${shp_out}/ch_01_1_preparation.log", replace
display "Starting SHP data preparation at $S_TIME"

/*** INFORMATION
========================================
The code prepares and combines the pequiv files 
(e.g., shpequiv_2023.dta) which are created for the CNEF.
NOTE: In 2025, the pequiv files are already combined into 
a single file by the SHP team (shpequiv_long.dta).
========================================
*/

*################################################################################	
*#	
*#  NEW CODE FROM CPF v.2.0:
*#	Using the shpequiv_long file (created by the SHP team)
*#	
*################################################################################
/*
For CPF v.2.0, the shpequiv_long file is used instead of the separate shpequiv files.
This file is created by the SHP team and is available in the shp_in_cnef folder.
Thus, the code below (OLD CODE) is not needed anymore but left here for reference.
*/
use "${shp_in_cnef}/shpequiv_long.dta", clear
* 
rename year wave 

*################################################################################	
*#	
*#  OLD CODE (NO LONGER NEEDED IN CPF v.2.0):
*#	Integrating separate shpequiv files - used until CPF v.1.6
*#	
*################################################################################
/*
*** Prepare for appending 
/*Note:
- code deletes year in vars' names
*/
 
*** Correct var names
local wf 1999 // first wave
local wl `wf'+ ${shp_w}-1 // last wave
	while (`wf' <= `wl') {
		use "${shp_in_cnef}/shpequiv_`wf'.dta", clear
			rename *_`wf' *
			gen wave=`wf'
			save "${shp_out_work_cnef}/shpequiv_`wf'.dta", replace
		local `wf++'
}  

*** Append
local wf 1999 // first wave
local wl `wf'+ ${shp_w}-1 // last wave
	use "${shp_out_work_cnef}/shpequiv_`wf'.dta", clear
	while (`wf' < `wl') {
	  local `wf++'
	  display "Appending wave: "`wf'
			qui append using "${shp_out_work_cnef}/shpequiv_`wf'.dta"
	  display "No of vars after append: " c(k) " N: " _N
	  display ""
	}
*/

*################################################################################
*#	
*#	Save
*#	
*################################################################################

save "${shp_out}/ch_01_shpequivL.dta", replace

* NOTE: work with CENF first --> 02_Cnef_vars

* Remove all temporary .dta files in the output work directory
local files : dir "${shp_out_work_cnef}" files "*.dta"
foreach f of local files {
    erase "${shp_out_work_cnef}/`f'"
}

*** Log close
display "Ending SHP data preparation at $S_TIME"
log close

*____________________________________________________________________________
*--->	END	OF FILE <---
