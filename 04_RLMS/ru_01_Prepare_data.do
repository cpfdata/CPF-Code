*
**|=========================================================================|
**|	    ####	CRITEVENTS	####											|
**|		>>>	RLMS						 									|
**|		>>	Prepare data - Merge			 	 							|
**|-------------------------------------------------------------------------|
**|		Konrad Turek 	| 	2020	|	turek@nidi.nl						|			
**|=========================================================================|
*



*############################
*#							#
*#	Merged dataset			#
*#							#
*############################
* Data already merged into one file (long)
// USER_RLMS-HSE_IND_1994_2018_v2_eng_STATA.dta
// USER_RLMS-HSE_HH_1994_2018_eng.dta

use "${rlms_in}\\${rlms_dataIND}", clear
disp "vars: " c(k) "   N: " _N

* Add HH variables
merge m:1 ID_H ID_W using "${rlms_in}\\${rlms_dataHH}" , ///
	keep(1 3) nogen keepusing(F14 nfm)

disp "vars: " c(k) "   N: " _N

*
save "${rlms_out}\ru_01.dta", replace  	



*---
*eof
