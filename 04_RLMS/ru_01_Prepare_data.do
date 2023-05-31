*
**|=============================================|
**|	    ####	CPF v1.5 / CRITEVENTS	####	|
**|		>>>	RLMS								|
**|		>>	Prepare data - Merge				|
**|---------------------------------------------|
**|		Konrad Turek 	| 	2023				|			
**|=============================================|
*



*############################
*#							#
*#	Merged dataset			#
*#							#
*############################
* Data already merged into one file (long)
// RLMS_IND_1994_2021_2022_08_21_1_v2_eng_DTA.dta
// RLMS_HH_1994_2021_eng_DTA.dta

use "${rlms_in}\\${rlms_dataIND}", clear
disp "vars: " c(k) "   N: " _N

* Add HH variables
merge m:1 ID_H ID_W using "${rlms_in}\\${rlms_dataHH}" , ///
	keep(1 3) nogen keepusing(F14 NFM)

disp "vars: " c(k) "   N: " _N

*
save "${rlms_out}\ru_01.dta", replace  	



*---
*eof
