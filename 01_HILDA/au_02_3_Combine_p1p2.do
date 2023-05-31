*
**|=====================================|
**|	    ####	CPF	ver 1.5		####	|
**|		>>>	HILDA						|
**|		>>	02_2 - Combine p1 & p2		|									
**|-------------------------------------|
**|		Konrad Turek 	| 	2023		|
**|=====================================|



*############################
*#							#
*#	Combine datasets		#
*#							#
*############################
*** equiv:
use "${hilda_out}\au_02a_cnef.dta", clear 
*
disp "vars: " c(k) "   N: " _N

*** add waves:
merge 1:1 pid wave using "${hilda_out}\au_02b_waves.dta" , ///
	keep(1 2 3) nogen 
*
disp "vars: " c(k) "   N: " _N

***
order pid wave inty* country  , first
order hh* jbm* x1* w1* hhw* lnw*, last
order hhin*, after(incjobs_yg)
order age* edu* edhigh1, after(country)

*############################
*#							#
*#	Destring pid			#
*#							#
*############################
destring pid , replace


*############################
*#							#
*#	Cross-file fill MV		#
*#							#
*############################
*** wh
* Fill MV based on whyear (imputed by CNEF)

replace whmonth=whyear/12 if (whmonth==.|whmonth<0) & whyear>0 & whyear<.
replace whweek=whyear/(12*4.3) if (whweek==.|whweek<0) & whyear>0 & whyear<. 




****
label data "CPF_Australia v1.5"

save "${hilda_out}\au_02_CPF.dta" , replace




*____________________________________________________________________________
*--->	END	OF FILE <---
	

