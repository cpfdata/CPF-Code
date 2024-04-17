*
**|=============================================|
**|	    ####	CPF	v1.5		####			|
**|		>>>	KLIPS						 		|
**|		>>	03_ Sample selection				|
**|---------------------------------------------|
**|		Konrad Turek		| 	2023			|	
**|=============================================|
* 


**--------------------------------------
** Open merged dataset
**-------------------------------------- 
use "${klips_out}/ko_02_CPF.dta", clear


*############################
*#							#
*#	Criteria				#
*#							#
*############################
**--------------------------------------
** Intreview status
**--------------------------------------

* No criteria, keep all like in CNEF 

// p_9509
// (1)  personal interview
// (2)  self-report 
// (3)  phone
// (4)  personal interview+phone
// (5)  self-report+phone
// (6)  personal interview+self-report 
// (7)  personal interview+self-report+phone
 

**--------------------------------------
** Age criteria
**--------------------------------------

keep if age>=18  



**--------------------------------------
** MV in age and gender
**--------------------------------------

keep if female~=.
keep if age~=.



*############################
*#							#
*#	Save					#
*#							#
*############################
save "${klips_out}/ko_03_CPF.dta" , replace



*____________________________________________________________________________
*--->	END	OF FILE <---

