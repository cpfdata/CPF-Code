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

use "${rlms_in}//${rlms_dataIND}", clear
disp "vars: " c(k) "   N: " _N

* Add HH variables
merge m:1 ID_H ID_W using "${rlms_in}//${rlms_dataHH}" , ///
	keep(1 3) nogen keepusing(F14 NFM ///
	B1_5 B2_5 B3_5 B4_5 B5_5 B6_5 B7_5 B8_5 B9_5 B10_5 B11_5 B12_5 B13_5 ///
	B14_5 B15_5 B16_5 B17_5 B18_5 B19_5 B20_5 B21_5 B22_5 B23_5 B24_5    ///
	)

disp "vars: " c(k) "   N: " _N

*
save "${rlms_out}/ru_01.dta", replace  	



*---
*eof
