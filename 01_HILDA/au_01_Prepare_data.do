/*
===============================================================================
CPF Version 2.0 
HILDA 
Syntax 01: Data Preparation
===============================================================================
Purpose: Prepare and combine HILDA panel data files across all waves
Author:  Konrad Turek
Date:    06.2025
Input:   hilda{w}c.dta files
Output:  au_01.dta (combined person-household file)
===============================================================================
NOTE: This code does not include yet waves after 2020 (wave 20)

*/

* Log
capture log close 
log using "${hilda_out}/au_01_preparation.log", replace
display "Starting HILDA data preparation at $S_TIME"


/*
================================================================================
HILDA Data Preparation Description - au_01_Prepare_data.do
================================================================================
The au_01_Prepare_data.do file processes HILDA panel data by standardizing 
variable names across waves and combining pre-existing combined files into 
a single longitudinal dataset.

Setup and Configuration:
• Configures paths and wave parameters for HILDA data processing
• Sets start year (2001) and generates alphabetical wave identifiers

Step 1: Variable Renaming
-------------------------
• Processes combined wave files (Combined_{w}{year}c.dta) 
• Removes wave letters from variable names (e.g., a* → *)
• Adds standardized wave variable with calendar year
• Orders files by person ID and wave

Step 2: Append Waves
--------------------
• Appends all processed wave files into single longitudinal dataset
• Maintains person-year structure across all waves
• Sorts by person ID and wave

Step 3: Final Dataset Creation
------------------------------
• Saves final combined dataset: au_01_combined_2001_20{wave}.dta
• Removes temporary working files
• Provides foundation for subsequent harmonization steps

================================================================================
NOTES: 
- Users might have to adjust the command when adding new variables. Additionally, 
  if the order of the variables changes with new editions, the DROP command must 
  be modified (or deleted). 
*/






*################################################################################
*# 
*# SETUP AND CONFIGURATION
*# 
*################################################################################

global start_year = 2001
global waves_n = "${hilda_w}"
global data_path = "${hilda_in}"
global output_path = "${hilda_out}"

display "Configuration:"
display "  Start year: $start_year"
display "  The lastest wave: $waves_n"
display "  Data path: $data_path"
display "  Output path: $output_path"



*################################################################################	
*#							
*#	Combined files	  		
*#							
*################################################################################

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
		use "${hilda_in}/STATA ${hilda_w}0c (Combined)/Combined_`w'${hilda_w}0c.dta", clear
			gen wave=`year'
			rename `w'* *
			sort xwaveid
			order xwaveid wave, first
		save "${hilda_out_work}/hilda`year'.dta", replace
		local ++year
}  
*

**--------------------------------------
** Step 2: Append waves 
**--------------------------------------

use "${hilda_out_work}/hilda2001.dta", clear 
local last = 20${hilda_w}
foreach w of numlist  2002/`last' {
	  display "Appending wave: "`w'
			qui append using "${hilda_out_work}/hilda`w'.dta"
	  display "After appned of wave `w' - Vars:" c(k) " N: " _N
	  display ""
	}
*	
sort xwaveid wave


*################################################################################
*# 
*#	Step 3: Save combined file
*# 
*################################################################################

save "${hilda_out}/au_01_combined_2001_20${hilda_w}.dta", replace


* Remove all temporary .dta files in the output work directory
local files : dir "${hilda_out_work}" files "*.dta"
foreach f of local files {
    erase "${hilda_out_work}/`f'"
}

*** Log close
display "Ending SHP data preparation at $S_TIME"
log close

*____________________________________________________________________________
*--->	END	OF FILE <---

