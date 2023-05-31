*
**|=====================================|
**|	    ####	CPF	v1.5	####		|
**|		>>>	SOEP						|
**|		>>	04_ Sample selection		|
**|-------------------------------------|
**|		Konrad Turek 	| 	2023		|
**|=====================================|
*




**--------------------------------------
** Open merged dataset
**-------------------------------------- 
* 
use "${soep_out}\ge_02_CPF.dta", clear  	

*############################
*#							#
*#	Criteria				#
*#							#
*############################
**--------------------------------------
** Intreview status
**--------------------------------------
* Sample similar to pequiv (2016-17 differs slightly)
* Only Befragungsperson (Interviewed) 
* then also respstat==1
keep if netto>=10 & netto<=19 /// == nett[1] Befragungsperson (_P, _JUGEND) 
		& hnetto==1

  
  
	**--------------------------------------
	** Other filters by DIW			
	**--------------------------------------
	/* * * BALANCED VS UNBALANCED * * *

	keep if ( (vnetto >= 10 & vnetto < 20) )


	* * * PRIVATE VS ALL HOUSEHOLDS * * *

	keep if ( (vpop == 1 | vpop == 2) )
	*/


**--------------------------------------
** Age criteria
**--------------------------------------

keep if age>=18 //  



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
save "${soep_out}\ge_03_CPF.dta" , replace


	
	
*---
* eof






