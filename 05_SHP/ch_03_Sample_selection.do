*
**|=========================================|
**|	    ####	CPF	v1.5	####			|
**|		>>>	SHP						 		|
**|		>>	04_ Sample selection			|
**|-----------------------------------------|
**|		Konrad Turek 	| 	2023			|
**|=========================================|
*




**--------------------------------------
** Open merged dataset
**-------------------------------------- 
* 
use "${shp_out}\ch_02_CPF.dta", clear 

*############################
*#							#
*#	Criteria				#
*#							#
*############################
**--------------------------------------
** Intreview status
**--------------------------------------
* Status - non-resp have some values on educ, marita and employment - can also keep them if useful for some analysis
keep if respstat==1
drop respstat2


**--------------------------------------
** Age criteria
**--------------------------------------

keep if age>=18 //  



**--------------------------------------
** MV in age and gender
**--------------------------------------

keep if female~=.	// delets 7700 obs with mostly MV and not info on resp. status 
keep if age~=.



*############################
*#							#
*#	Save					#
*#							#
*############################
save "${shp_out}\ch_03_CPF.dta" , replace


	
*---
*eof	


