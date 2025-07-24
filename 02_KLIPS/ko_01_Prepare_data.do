/*
===============================================================================
CPF Version 2.0 
KLIPS 
Syntax 01: Data Preparation
===============================================================================
Purpose: Prepare and combine KLIPS panel data files across all waves
Author:  Konrad Turek
Date:    06.2025
Input:   eklips{w}p.dta, eklips{w}h.dta files
Output:  ko_01.dta (combined person-household file)
===============================================================================
*/

* Log
capture log close 
log using "${klips_out}/ko_01_preparation.log", replace
display "Starting KLIPS data preparation at $S_TIME"


/* 
================================================================================
KLIPS Data Preparation Description - ko_01_Prepare_data.do
================================================================================

The ko_01_Prepare_data.do file processes KLIPS panel data by standardizing 
variable names across waves and combining person and household files into 
a single harmonized dataset for CPF analysis.

Setup and Configuration:
• Generates wave number strings for dynamic processing
• Configures paths and wave parameters
• Installs required Stata packages (renvars for variable renaming)

Step 1: Person Files (p-files) Processing
------------------------------------------
• Processes individual person files (eklips{w}p.dta) for each wave
• Standardizes variable names by removing wave identifiers from variable names
• Adds wave and household ID variables to each file
• Corrects problematic variables and removes unuseful variables
• Appends all person waves into single file: ko_all_p.dta

Step 2: Household Files (h-files) Processing  
---------------------------------------------
• Processes household files (eklips{w}h.dta) for each wave
• Applies similar variable name standardization as person files
• Removes households with missing household IDs
• Appends all household waves into single file: ko_all_h.dta

Step 3: Combine Person and Household Data
------------------------------------------
• Merges person and household files within each wave using household ID
• Appends all combined person-household waves
• Creates final integrated dataset with both individual and household 
  information

Step 4: Final Dataset Creation
------------------------------
• Saves final combined dataset: ko_01.dta
• Removes temporary files and working datasets
• Provides foundation for subsequent harmonization steps

================================================================================
Note: The process handles wave-specific variable naming inconsistencies and 
creates a standardized person-year dataset with linked household information.
================================================================================
*/


*################################################################################
*# 
*# SETUP AND CONFIGURATION
*# 
*################################################################################

global start_year = 1998
global waves_n = "${klips_w}"
global data_path = "${klips_in}"
global output_path = "${klips_out}"

display "Configuration:"
display "  Start year: $start_year"
display "  The lastest wave: $waves_n"
display "  Data path: $data_path"
display "  Output path: $output_path"

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


*################################################################################
*# 
*# Step 1: Prepare p-files 	
*# 
*################################################################################

**--------------------------------------
** p-files: var names 
**--------------------------------------
/*Note:
- The code:
	- Deletes wave identifier in var names 
	(using "renvars" which does not stop if var is missing)
	- Adds variable wave to each file 
*/


local year=1998
foreach w in $waves {
		use "${klips_in}/eklips`w'p.dta", clear
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
		save "${klips_out_work}/p_klips`w'.dta", replace
		local ++year
}  
*

**--------------------------------------
** p-files Check
**--------------------------------------
foreach w in $waves {
	  qui use "${klips_out_work}/p_klips`w'.dta", clear
	  display "Wave `w'  Vars: " c(k) " N: " _N
}
*
**--------------------------------------
** p-files Correct before appending
**--------------------------------------

*** Delete unuseful vars or correct vars with errors in coding before appending
foreach w in $waves {
		use "${klips_out_work}/p_klips`w'.dta", clear
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
		save "${klips_out_work}/p_klips`w'.dta", replace
}  

**--------------------------------------
** p-files Append waves
**--------------------------------------

*** Append
// use "${klips_out_work}/p_klips01.dta", clear

*	
clear
local total_waves: word count $waves
local current_wave = 0
foreach w in $waves {
    local ++current_wave
    display "Processing wave `w' (`current_wave' of `total_waves')"
	  display "Appending wave: "`w'
			qui append using "${klips_out_work}/p_klips`w'.dta"
	  display "After appned of wave `w' - Vars:" c(k) " N: " _N
	  display ""
	}
*	

sort pid wave
*
save "${klips_out}/ko_all_p.dta", replace



*################################################################################
*# 
*# Step 2: Prepare h-files 	
*# 
*################################################################################
*

**--------------------------------------
** h-files: var names 
**--------------------------------------
/*Note:
- To delete wave identifier in var names
  (using "renvars" which does not stop if var is missing)
- To add variable wave to each file 
*/
 
local year=1998
foreach w in $waves {
		use "${klips_in}/eklips`w'h.dta", clear
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
		save "${klips_out_work}/h_klips`w'.dta", replace
		local ++year
}  
*

**--------------------------------------
** h-files Check
**--------------------------------------
foreach w in $waves {
	  qui use "${klips_out_work}/h_klips`w'.dta", clear
	  display "Wave `w'  Vars: " c(k) " N: " _N
}
*
/**--------------------------------------
** h-files Correct before appending
**--------------------------------------

*** Delete unuseful vars with errors in coding before appending
foreach w in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 {
		use "${klips_out_work}/h_klips`w'.dta", clear
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
		save "${klips_out_work}/h_klips`w'.dta", replace
} 
*/

**--------------------------------------
** h-files Append waves
**--------------------------------------

*** Append
// use "${klips_out_work}/h_klips01.dta", clear


clear
local total_waves: word count $waves
local current_wave = 0
foreach w in $waves {
    local ++current_wave
    display "Processing wave `w' (`current_wave' of `total_waves')"
	  display "Appending wave: "`w'
			qui append using "${klips_out_work}/h_klips`w'.dta"
	  display "After appned of wave `w' - Vars:" c(k) " N: " _N
	  display ""
	}
*	
*

*
save "${klips_out}/ko_all_h.dta", replace




*################################################################################
*# 
*# Step 3: Combine p & h files	
*# 
*################################################################################

/* Note:
- must be done first within, and then across the waves
*/

**--------------------------------------
** ph-files Merge p & h within waves
**--------------------------------------
clear
foreach w in $waves {
		use "${klips_out_work}/p_klips`w'.dta", clear
		merge m:1 hhid`w' using "${klips_out_work}/h_klips`w'.dta", nogen 
		sort pid wave
		save "${klips_out_work}/ph_klips`w'.dta", replace
}
*
		
**--------------------------------------
** ph-files Append ph waves
**--------------------------------------

*** Append
// use "${klips_out_work}/ph_klips01.dta", clear
clear
foreach w in $waves {
	  display "Appending wave: "`w'
			qui append using "${klips_out_work}/ph_klips`w'.dta"
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

*################################################################################
*# 
*# Step 4: Save the final file
*# 
*################################################################################

save "${klips_out}/ko_01.dta", replace

**--------------------------------------
** Delete unnecessary files 
**--------------------------------------
erase  "${klips_out}/ko_all_p.dta"
erase  "${klips_out}/ko_all_h.dta" 

// capture shell rmdir /s /q "${klips_out}/temp" // delete 'temp' folder

* Remove all temporary .dta files in the output work directory
local files : dir "${klips_out_work}" files "*.dta"
foreach f of local files {
    erase "${klips_out_work}/`f'"
}


// Close log
display "Completed KLIPS data preparation at $S_TIME"
log close


*____________________________________________________________________________
*--->	END	OF FILE <---



