*
**|=============================================|
**|	    ####	CPF	v1.5	####				|
**|		>>>	UK							 		|
**|		>>	04_ Sample selections	 			|
**|---------------------------------------------|
**|		Konrad Turek 	| 	2023				|
**|=============================================|
* 


**--------------------------------------
** Open merged dataset
**-------------------------------------- 
use "${ukhls_out}\uk_02_CPF.dta" , clear


*############################
*#							#
*#	Criteria				#
*#							#
*############################
**--------------------------------------
** Intreview status
**--------------------------------------

// ivfio // Interview outcome  
* proxy and refusal have values 
// bro pid wave   ivfio edu3 mlstat5 emplst5 whweek_ctr whmonth incjobs_mgLC srh5 satlife5 if ivfio==3

**--------------------------------------
** Age criteria
**--------------------------------------

keep if age>=18 //  



**--------------------------------------
** MV in age and gender
**--------------------------------------

keep if female~=.	 
keep if age~=.

drop if female==-1 


*############################
*#							#
*#	Save					#
*#							#
*############################
save "${ukhls_out}\uk_03_CPF.dta" , replace


*---
*eof
	







