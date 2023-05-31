*
**|=============================================|
**|	    ####	CPF	v1.5	####				|
**|		>>>	SHP						 			|
**|		>>	01 Create long file (pequiv)		|
**|---------------------------------------------|
**|		Konrad Turek 	| 	2023				|
**|=============================================|
*
*############################
*#							#
*#	CNEF					#
*#							#
*############################


*** Prepare for appending 
/*Note:
- code deletes year in vars' names
*/
 
*** Correct var names
local wf 1999 // first wave
local wl `wf'+ ${shp_w}-1 // last wave
	while (`wf' <= `wl') {
		use "${shp_in_cnef}\shpequiv_`wf'.dta", clear
			rename *_`wf' *
			gen wave=`wf'
			save "${shp_out_work_cnef}\shpequiv_`wf'.dta", replace
		local `wf++'
}  

*** Append
local wf 1999 // first wave
local wl `wf'+ ${shp_w}-1 // last wave
	use "${shp_out_work_cnef}\shpequiv_`wf'.dta", clear
	while (`wf' < `wl') {
	  local `wf++'
	  display "Appending wave: "`wf'
			qui append using "${shp_out_work_cnef}\shpequiv_`wf'.dta"
	  display "No of vars after append: " c(k) " N: " _N
	  display ""
	}
*	

save "${shp_out}\ch_01_shpequivL.dta", replace


* NOTE: work with CENF first --> 02_Cnef_vars


* Delete temp files 

!del "${shp_out_work_cnef}\*.dta"


*____________________________________________________________________________
*--->	END	OF FILE <---