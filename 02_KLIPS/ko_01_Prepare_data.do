*
**|=======================================================|
**|	    ####	CPF	ver 1.5		####					  |
**|		>>>	KLIPS						 				  |
**|		>>	Prepare data + Combine (all files, all vars)  |
**|-------------------------------------------------------|
**|		Konrad Turek		| 	2023					  |	
**|=======================================================|
* 



**--------------------------------------
** Generate a string of waves' numbers  
**--------------------------------------
local waves `" "01" "02" "03" "04" "05" "06" "07" "08" "09" "' 
local n=10
local last=${klips_w}
while `n'<= `last' {
    local i="`n'"
    local waves = `" `waves'"' + `" "`i'" "' 
	local ++n
}
global waves= `"`waves'"'
 
 
**--------------------------------------
** Install ado renvars (for renaming)
**--------------------------------------
* renvars
// net install http://www.stata-journal.com/software/sj5-4/dm88_1




*############################
*#							#
*#	Prepare p-files 		#
*#							#
*############################
*

**--------------------------------------
** p-files Step 1: var names 
**--------------------------------------
/*Note:
- The code:
	- Deletes wave identifier in var names 
	(using "renvars" which does not stop if var is missing)
	- Adds variable wave to each file 
*/


local year=1998
foreach w in $waves {
		use "${klips_in}\eklips`w'p.dta", clear
			gen wave=`year'
			gen hid=hhid`w'
			foreach x in p pa w sw	{
				renvars , subs(`x'`w' `x'_)
			}
			foreach var in jobclass jobnum jobtype {
				capture confirm variable `var'
				if (_rc == 0) {
				rename `var' `var'`w'
			}
			}
			sort pid
			order pid wave, first
		save "${klips_out_work}\p_klips`w'.dta", replace
		local ++year
}  
*

**--------------------------------------
** p-files Check
**--------------------------------------
foreach w in $waves {
	  qui use "${klips_out_work}\p_klips`w'.dta", clear
	  display "Wave `w'  Vars: " c(k) " N: " _N
}
*
**--------------------------------------
** p-files Correct before appending
**--------------------------------------

*** Delete unuseful vars or correct vars with errors in coding before appending
foreach w in $waves {
		use "${klips_out_work}\p_klips`w'.dta", clear
			foreach var in p_4712 p_4722 p_4732 p_4742 p_4752 p_4762 p_4772 ///
			p_4782 p_4792 	///
			p_5241 p_5261 p_5281 p_5301 p_5132 p_5321 p_5111 p_5116 p_5201	///
			p_9058	 p_9511 p_9064 {
			capture confirm variable `var'
				if (_rc == 0) {
					drop `var'
					}
			foreach var in p_2892 pa_5803 pa_5804 {
			capture confirm str# variable `var'
				if (_rc == 0) {
				destring `var', replace
				}
			}
			}
		save "${klips_out_work}\p_klips`w'.dta", replace
}  

**--------------------------------------
** p-files Append waves
**--------------------------------------

*** Append
// use "${klips_out_work}\p_klips01.dta", clear
clear
foreach w in $waves {
	  display "Appending wave: "`w'
			qui append using "${klips_out_work}\p_klips`w'.dta"
	  display "After appned of wave `w' - Vars:" c(k) " N: " _N
	  display ""
	}
*	
sort pid wave
*
save "${klips_out}\ko_all_p.dta", replace






*############################
*#							#
*#	Prepare h-files 		#
*#							#
*############################
*

**--------------------------------------
** h-files Step 1: var names 
**--------------------------------------
/*Note:
- To delete wave identifier in var names
  (using "renvars" which does not stop if var is missing)
- To add variable wave to each file 
*/
 
local year=1998
foreach w in $waves {
		use "${klips_in}\eklips`w'h.dta", clear
			gen wave=`year'
			foreach x in h w sw	{
				renvars , subs(`x'`w' `x'_)
			}
			foreach var in hwaveent {
				capture confirm variable `var'
				if (_rc == 0) {
				rename `var' `var'`w'
			}
			}
			drop if hhid`w' == .
			sort hhid`w'
			order hhid`w' wave, first
		save "${klips_out_work}\h_klips`w'.dta", replace
		local ++year
}  
*

**--------------------------------------
** h-files Check
**--------------------------------------
foreach w in $waves {
	  qui use "${klips_out_work}\h_klips`w'.dta", clear
	  display "Wave `w'  Vars: " c(k) " N: " _N
}
*
/**--------------------------------------
** h-files Correct before appending
**--------------------------------------

*** Delete unuseful vars with errors in coding before appending
foreach w in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 {
		use "${klips_out_work}\h_klips`w'.dta", clear
			foreach var in ... {
			capture confirm variable `var'
				if (_rc == 0) {
					drop `var'
					}
			foreach var in ... {
			capture confirm str# variable `var'
				if (_rc == 0) {
				destring `var', replace
				}
			}
			}
		save "${klips_out_work}\h_klips`w'.dta", replace
} 
*/

**--------------------------------------
** h-files Append waves
**--------------------------------------

*** Append
// use "${klips_out_work}\h_klips01.dta", clear
clear
foreach w in $waves {
	  display "Appending wave: "`w'
			qui append using "${klips_out_work}\h_klips`w'.dta"
	  display "After appned of wave `w' - Vars:" c(k) " N: " _N
	  display ""
	}
*	
*
save "${klips_out}\ko_all_h.dta", replace




*############################
*#							#
*#	Combine p & h files		#
*#							#
*############################

/* Note:
- must be done first within then acrross waves
*/

**--------------------------------------
** ph-files Merge p & h within waves
**--------------------------------------
clear
foreach w in $waves {
		use "${klips_out_work}\p_klips`w'.dta", clear
		merge m:1 hhid`w' using "${klips_out_work}\h_klips`w'.dta", nogen 
		sort pid wave
		save "${klips_out_work}\ph_klips`w'.dta", replace
}
*
		
**--------------------------------------
** ph-files Append ph waves
**--------------------------------------

*** Append
// use "${klips_out_work}\ph_klips01.dta", clear
clear
foreach w in $waves {
	  display "Appending wave: "`w'
			qui append using "${klips_out_work}\ph_klips`w'.dta"
	  display "After append of wave `w' - Vars:" c(k) " N: " _N
	  display ""
	}
qui tab wave
display "Total ->> Vars: " c(k) "; N: " _N "; Waves: " r(r)

*	
sort pid wave
drop if pid==.
order hhid*, after(wave)
*


**--------------------------------------
** ph-files done: ko_all_ph.dta
**--------------------------------------
save "${klips_out}\ko_01.dta", replace

**--------------------------------------
** Delete unnecessary files 
**--------------------------------------
erase  "${klips_out}\ko_all_p.dta"
erase  "${klips_out}\ko_all_h.dta" 

!del "${klips_out}\temp\*.dta"



*____________________________________________________________________________
*--->	END	OF FILE <---
