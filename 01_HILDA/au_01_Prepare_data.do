*
**|=========================================================|
**|	    ####	CPF	v1.5		####						|
**|		>>>	HILDA						 					|
**|		>>	01 Prepare data + Combine (all files, all vars)	|
**|---------------------------------------------------------|
**|		Konrad Turek 	| 	2023		 					|			
**|=========================================================|
* 



*############################
*#							#
*#	Combined files	  		#
*#							#
*############################

**--------------------------------------
** Step 1: Rename 
**--------------------------------------

/*Note:
- Delete wave identifier in var names (letters) 
- Add variable wave to each file 
*/

local waves = substr(c(alpha), 1, ( ${hilda_w} *2)-1)		// letters identify waves 
local year=2001
foreach w in `waves' {
		use "${hilda_in}\STATA ${hilda_w}0c (Combined)\Combined_`w'${hilda_w}0c.dta", clear
			gen wave=`year'
			rename `w'* *
			sort xwaveid
			order xwaveid wave, first
		save "${hilda_out_work}\hilda`year'.dta", replace
		local ++year
}  
*

**--------------------------------------
** Step 2: Append waves 
**--------------------------------------

use "${hilda_out_work}\hilda2001.dta", clear 
local last = 20${hilda_w}
foreach w of numlist  2002/`last' {
	  display "Appending wave: "`w'
			qui append using "${hilda_out_work}\hilda`w'.dta"
	  display "After appned of wave `w' - Vars:" c(k) " N: " _N
	  display ""
	}
*	
sort xwaveid wave
*
save "${hilda_out}\au_01_combined_2001_20${hilda_w}.dta", replace
 

**--------------------------------------
** Delete temp files 
**--------------------------------------
!del "${hilda_out_work}\*.dta"



*____________________________________________________________________________
*--->	END	OF FILE <---