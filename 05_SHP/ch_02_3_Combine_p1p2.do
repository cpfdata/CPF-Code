*
**|=============================================|
**|	    ####	CPF	v1.5	####				|
**|		>>>	SHP						 			|
**|		>>	03_ Combine eqiv & waves			|
**|---------------------------------------------|
**|		Konrad Turek 	| 	2023				|
**|=============================================|
*  




*############################
*#							#
*#	Combine datasets		#
*#							#
*############################
*** equiv:
use "${shp_out}\ch_02a_cnef.dta", clear 
*
disp "vars: " c(k) "   N: " _N

*** add waves:
merge 1:1 pid wave using "${shp_out}\ch_02b_wave.dta" , ///
	keep(1 2 3) nogen 
*
disp "vars: " c(k) "   N: " _N


*############################
*#							#
*#	Cross-fill MV			#
*#							#
*############################

* wh
* Fill MV based on whyear (imputed by CNEF)

replace whmonth=whyear/12 if (whmonth==.|whmonth<0) & whyear>0 & whyear<.
replace whweek=whyear/(12*4.3) if (whweek==.|whweek<0) & whyear>0 & whyear<. 



****
label data "CPF_SWITZ v1.5"
save "${shp_out}\ch_02_CPF.dta" , replace




*---
* eof
	
	


