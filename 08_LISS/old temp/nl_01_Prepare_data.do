/*
===============================================================================
CPF Version 2.0 
LISS 
Syntax 01: Data Preparation
===============================================================================
Purpose: Prepare and combine LISS panel data files across all waves
Author:  Konrad Turek
Date:    06.2025
Input:   - background variables in folder 01 (e.g., avars_200711_EN_3.0p.dta)
         - topic files in folders 02-11 (e.g., ch07a_2p_EN.dta)
Output:  nl_01.dta (combined file: person + household / topic + background)
===============================================================================
*/
* Log
capture log close 
log using "${liss_out}/nl_01_preparation.log", replace
display "Starting LISS data preparation at $S_TIME"


*################################################################################
*# 
*# SETUP AND CONFIGURATION
*# 
*################################################################################

global start_year = 2007
global waves_n = "${liss_w}"
global data_path = "${liss_in}"
global output_path = "${liss_out}"

* Display configuration
display "Configuration:"
display "  Start year: $start_year"
display "  The lastest wave: $waves_n"
display "  Data path: $data_path"
display "  Output path: $output_path"


**--------------------------------------
**  Setup and directories 
**--------------------------------------

*** Create additional folders for LISS output data

capture mkdir "${liss_out}/temp"
capture mkdir "${liss_out}/temp/topics"
foreach folder in 01 02 03 04 05 06 07 08 09 10 11  {
	capture mkdir "${liss_out}/temp/`folder'/"
}


*** Install ado for scaning files 
capture ssc install fs


*################################################################################
*#
*# Step 1: Background variables - prepare and combine files 
*#
*################################################################################

***--------------------------------------
*** 1a: Prepare background variables 
***--------------------------------------
/*
 * This step prepares and combines background variables from the LISS panel
 * It processes files from folder 01, creates wave and month variables,
 * and prepares background datasets for merging 
 */

cd "${liss_in}/01"
fs "*.dta"
*
foreach file in `r(files)' {
    use "`file'", clear
    di "Processing file: `file'"
			* rename 
			rename wave intdate
			gen wavey= floor(intdate / 100)
			gen intmonth= mod(intdate, 100)

		* get year for file name 
		egen temp_wavey = mode(wavey)
		egen temp_month = mode(intmonth)
		local year = temp_wavey[1]
		local year2 = substr("`year'",3,2)
		local month = temp_month[1]
		di "The wave: `year2', month: `month'"
		* save
 		drop temp_wavey temp_month
		order n*encr wave* intmonth intdate
		save "${liss_out}/temp/01/bckgr`year2'_`month'.dta", replace
}

***--------------------------------------
*** 1b: Combine background variables - all months included (large file)
***--------------------------------------
/*
 * This step combines all background variables from LISS 
 * generating a large file with all months included 
 */

cd "${liss_out}/temp/01"
fs "*.dta"
* Define files lists to work with 
local  filesexist "`r(files)'"
global filelist ""
	foreach f in `r(files)' {
	global filelist "$filelist `f'" 
	}
global first_file = word("$filelist", 1)  // first wave 
global remaining_files = subinstr("$filelist", "$first_file", "", 1)  // Remove the first file from the list 
	* Check if folder is empty (no files to combine)
		if missing(`"`filesexist'"')  {
		di "No files found in 01"
		}
		else {
		* Open first wave 
		use "${liss_out}/temp/01/$first_file", clear 
			* Append following waves 
			foreach f in $remaining_files { 
			qui append using "${liss_out}/temp/01/`f'" 
			} 
		order no*_encr wavey , first
		sort nomem_encr wavey intmonth
		save "${liss_out}/temp/liss01_bckgr_all.dta", replace 
		} 




***--------------------------------------
*** 1c: Compute incomes from all months to be used in the main file during harmonization 
***--------------------------------------

 * use "${liss_out}/temp/liss01_bckgr_all.dta", clear 

bysort nomem_encr wavey: gen n_months = _N

* Number of months duing year with income information 
foreach var of varlist brutoink nettoink brutoink_f netinc nettoink_f brutohh_f nettohh_f {
    gen temp_`var' = 0
    replace temp_`var' = 1 if `var' > 0 & `var' < .
    bysort nomem_encr wavey: egen `var'_count = total(temp_`var')
    drop temp_`var'
    lab var `var'_count "Number of months duing year with income information (bckgr vars)"
}

* Sum of income from all months within a year
foreach var of varlist brutoink nettoink brutoink_f netinc nettoink_f brutohh_f nettohh_f {
    bysort nomem_encr wavey: egen temp_`var'_sum = total(`var') if `var' > 0 & `var' < .
    bysort nomem_encr wavey: egen `var'_sum = min(temp_`var'_sum) // fill sum value across the year 
    lab var `var'_sum "Sum of income from all months within a year (bckgr vars)"
}
drop temp*


***--------------------------------------
*** 1d: Select refernce months per year - main file for CPF 
***--------------------------------------
/*
 * This step selects reference months per year 
 * and generates the main background file for CPF integration with reference months
 * Note: users might want to adjust the reference month 
 */

*** Selecting reference months - the general approach 
/* 
a) Reference month selected to be optimal for the topic of Work & Schooling (month==4). 
b) However, for other topics, users might want to adjust the reference month. See some suggestions below,
or consult the LISS data collection table (in CPF materials) to select the month that best fits your research needs. 
c) Values from 2007 ignored, but the might be used for Health topic in the 1st wave if needed 
d) If information from month==4 is missing, then the backup reference month is selected (the closest)
   This includes the most recent wave (month 4 may  not yet be avaliable) - then also select the closest. 
*/ 

* use "${liss_out}/temp/liss01_bckgr_all.dta", clear 

gen refmont=.

*** Select reference month for the main file 
** For waves 1-7 (period 2007/08 - 2013/14): set month 4 
/*Alternatives:
Month 4 - optimal for topics of Work, Schooling, Family and HH, Social Intergration
Month 1 - optimal for Health, Politics, Religion
Month 6 - optimal for Economic situation, Personality 
*/	
	replace refmont = 1 if wavey>=2008 & wavey<=2014 & intmonth==4 

** For waves 8-9 (period 2015/16 - 2016/17) - : set month 4 
* From wave 8, changed data collection schedule (note also some changes between 8 and 9)
/*Alternatives:
Month 4 - optimal for Work, Schooling
Month 7 or 11 - optimal for Health
Month 7 - optimal for Economic situation 
Month 12 - optimal for Politics, Personality 
Month 9-10 - optimal for other topics 
*/
	replace refmont = 1 if wavey>=2015 & wavey<=2016 & intmonth==4 

** For waves 10+ (period 2017 - 20) - : set month 4
* Note some changes in data collection for specific topics 
/*Alternatives:
Month 4 - optimal for Work, Schooling
Month 11 - optimal for Health
Month 2 - optimal for Politics
*/
	* Identify the most recent year 
	egen temp_maxw = max(wavey)

	// replace temp_maxm=. if wavey<temp_maxw

	* For for the rest of the waves (except the most recent year) 
	replace refmont = 1 if wavey>=2017 & wavey<temp_maxw & intmonth==4 

	* For the most recent year if month 4 exist 
	bysort nomem_encr wavey: egen temp_maxm = max(intmonth)  
	replace refmont = 1 if wavey==temp_maxw & intmonth==4 & temp_maxm>=4 //  set month 4 as ref if 4 or more months avaliable

** Check if intmonth==4 exist (the main reference month)
* Foe cases with no observation in month==4, select a backup reference month 
	bysort nomem_encr wavey: egen has_month4 = max(intmonth == 4)
	bysort nomem_encr wavey: gen wave_order = _n

** Select backup reference month 
* For individuals without month 4, select the closest month 
	bysort nomem_encr wavey: egen temp_minm = min(intmonth)
	replace refmont = 1 if has_month4 == 0 & ( ///
	    (temp_maxm > 4 & intmonth == temp_minm) | /// select the min month if >4
	    (temp_maxm < 4 & intmonth == temp_maxm)   /// select the max month if <4
	    )

drop temp_*


save "${liss_out}/temp/liss01_bckgr_all.dta", replace


*** Keep only reference months (1 per wave)
keep if refmont==1

*** Save
save "${liss_out}/temp/liss01_bckgr_ref.dta", replace 



*################################################################################
*#
*# Step 2: Topic files - Rename and correct vars 
*#
*################################################################################

***--------------------------------------
*** 2a: Renaming and basic cleaning source file (file by file)
***--------------------------------------
/*
 * This step renames and cleans the source files (file by file)
 * It corrects variable names and prepares specific files for later merging
 */

*** Preparation of specific files in 08
* Correcting a different variable name for intdate 
use "${liss_in}/08/cv16h_en_1.0p.dta", clear
gen  cv16h_m = maandnr
save "${liss_in}/08/cv16h_en_1.0p.dta", replace

// UPDATE NOTE: Check and update if waves >2024 added 
* For recent waves in 08 - three variables for intdate due to data collection done in parts 
* Select the middle data collection period as a reference
forvalues year = 18/24  {
    local letter = substr("jklmnopqrs", `year'-17, 1)
    local file "cv`year'`letter'_en_1.0p.dta"
    use "${liss_in}/08/`file'", clear
    capture drop  cv`year'_m
    gen cvx`year'_m = cv`year'`letter'_m2
    replace cvx`year'_m=cv`year'`letter'_m1 if cvx`year'_m==-9 // replace -9
    replace cvx`year'_m=cv`year'`letter'_m3 if cvx`year'_m==-9 // replace -9 if any remaining
    save "${liss_in}/08/`file'", replace
}


***--------------------------------------
*** 2b: Prepare all source files 
***--------------------------------------
/*
•	Data collection period for each LISS wave is spread over many months and has been changing over the years. 
Some topics (e.g. Health, Politics) were collected over two separate calendar years, 
and additionally, the period has been significantly changing. 
Therefore, constructing the CPF-LISS files requires designing waves that will cover 
all modules collected over a longer period and combine them into a single wave. 
Please, consult the LISS data collection table (in CPF materials) for an overview of the LISS waves' design for CPF integration. 
Additional notes:
- 07 Personality - skipped wave 9 (2016)
- 08 Politics and Values - skipped Wave 10 (2017) dues to modification in the LISS data collection schedule. New data were combined with next wave 11
- 09 Economic Situation: Assets - asked every 2nd wavey only 
*/

foreach folder in 02 03 04 05 06 07 08 09 10 11   {
cd "${liss_in}/`folder'"
fs "*.dta"
* for each file 
local fileorder = 1
foreach file in `r(files)' {
    use "`file'", clear
    di "Processing file: `file'"
			* rename 
			foreach var of varlist c* { 
			local newname = substr("`var'",1,2) + substr("`var'",6,.)
			rename `var' `newname'
			}
		* create wave and month 
		rename (c*_m) (intdate)
		gen intyear= floor(intdate / 100)
		gen intmonth= mod(intdate, 100)
		gen fileyear = real(substr("`file'", 3, 2))
		* add wave's main year of data collection  
		egen wavey = max(intyear) 
		egen temp_waveymin = min(intyear) 
		replace wavey = temp_waveymin if `folder' == 08 // data collection in years t and t+1  
		
		* specific for 02_Health wave (collected sometimes in different years that the main wave)  
		replace wavey = 2008 if "`folder'" == "02" & fileyear==7 // 1st Health wave 2007 combined with 2008 main wave 
		replace wavey = 2009 if "`folder'" == "02" & fileyear==8
		replace wavey = 2010 if "`folder'" == "02" & fileyear==9
		replace wavey = 2011 if "`folder'" == "02" & fileyear==10
		replace wavey = 2012 if "`folder'" == "02" & fileyear==11
		replace wavey = 2013 if "`folder'" == "02" & fileyear==12
		replace wavey = 2014 if "`folder'" == "02" & fileyear==13 // Note: file 14 is missing - modified data collection period in 2015, no data from 14
		replace wavey = 2015 if "`folder'" == "02" & fileyear==15
		replace wavey = 2016 if "`folder'" == "02" & fileyear==16
		replace wavey = 2017 if "`folder'" == "02" & fileyear==17
		replace wavey = 2018 if "`folder'" == "02" & fileyear==18
		replace wavey = 2019 if "`folder'" == "02" & fileyear==19
		replace wavey = 2020 if "`folder'" == "02" & fileyear==20
		replace wavey = 2021 if "`folder'" == "02" & fileyear==21
		replace wavey = 2022 if "`folder'" == "02" & fileyear==22
		replace wavey = 2023 if "`folder'" == "02" & fileyear==23
		replace wavey = 2024 if "`folder'" == "02" & fileyear==24

		* specific for 08_Politica (collected sometimes in different years that the main wave)  
		replace wavey = 2008 if "`folder'" == "08" & fileyear==8
		replace wavey = 2009 if "`folder'" == "08" & fileyear==9
		replace wavey = 2010 if "`folder'" == "08" & fileyear==10
		replace wavey = 2011 if "`folder'" == "08" & fileyear==11
		replace wavey = 2012 if "`folder'" == "08" & fileyear==12
		replace wavey = 2013 if "`folder'" == "08" & fileyear==13
		replace wavey = 2014 if "`folder'" == "08" & fileyear==14 
		replace wavey = 2015 if "`folder'" == "08" & fileyear==16 // Note: file 15 is missing - modified file naming by LISS
		replace wavey = 2016 if "`folder'" == "08" & fileyear==17
		* replace wavey = 2017 if "`folder'" == "08" & fileyear== XX // Note: no data for 2017, modified data collection time, 18 included in next wave 2018
		replace wavey = 2018 if "`folder'" == "08" & fileyear==18
		replace wavey = 2019 if "`folder'" == "08" & fileyear==19
		replace wavey = 2020 if "`folder'" == "08" & fileyear==20
		replace wavey = 2021 if "`folder'" == "08" & fileyear==21
		replace wavey = 2022 if "`folder'" == "08" & fileyear==22
		replace wavey = 2023 if "`folder'" == "08" & fileyear==23
		replace wavey = 2024 if "`folder'" == "08" & fileyear==24

		* get year for file name 
		local year = wavey[1]
		local year2 = substr("`year'",3,2)
		* create wave sequence file by file within topic (works only if all files downloaded)
		gen fileorder = `fileorder'  
		* order
		order nomem_encr intdate intyear intmonth wavey fileyear fileorder
		* save
		drop temp_waveymin
		save "${liss_out}/temp/`folder'/liss`folder'_`year2'.dta", replace
		local fileorder = `fileorder' + 1  
}
} 


***--------------------------------------
*** 2c: Correct specific variables	 
***--------------------------------------
** Change format to string 
* Define here variables that need to be modified
local all_vars "ch256 ch258 cr117 cr119 cs376 cs378 cf394 cf396 cw502 cw504 cp190 cp192 cv162 cv164 ca072 ca074 ci319 ci321 cd079 cd081"

foreach yr in 02 03 04 05 06 07 08 09 10 11 {
    cd "${liss_out}/temp/`yr'"
    fs "*.dta"
    * Process each file in the directory
    foreach file in `r(files)' {
        use "`file'", clear
        * Check all possible variables from the macro
        foreach var of local all_vars {
            capture confirm variable `var'
            if !_rc {
                capture confirm string variable `var'
                if _rc {
                    tostring `var', replace force
                }
            }
        }
        save "`file'", replace
    }
}


*################################################################################
*#
*# Step 3: Topic files - Append waves within the topic
*#
*################################################################################

***  
foreach folder in  02 03 04 05 06 07 08 09 10 11 {
cd "${liss_out}/temp/`folder'"
fs "*.dta"
* Define files lists to work with 
local  filesexist "`r(files)'"
global filelist ""
	foreach f in `r(files)' {
	global filelist "$filelist `f'" 
	}
global first_file = word("$filelist", 1)  // first wave 
global remaining_files = subinstr("$filelist", "$first_file", "", 1)  // Remove the first file from the list 
	* Check if folder is empty (no files to combine)
		if missing(`"`filesexist'"')  {
		di "No files found in `folder'"
		}
		else {
		* Open first wave 
		use "${liss_out}/temp/`folder'/$first_file", clear 
			* Append following waves 
			foreach f in $remaining_files { 
			qui append using "${liss_out}/temp/`folder'/`f'" 
			} 
		order no*_encr wavey intdate intyear intmonth file*, first
		sort nomem_encr wavey intmonth
		save "${liss_out}/temp/topics/liss`folder'.dta", replace 
		} 
}

*################################################################################
*#
*# Step 4: Topic files - Merge files from all topics 
*#
*################################################################################
***  
cd "${liss_out}/temp/topics"
fs "*.dta"
*
global filelist ""
foreach f in `r(files)' {
	global filelist "$filelist `f'" 
}
global first_file = word("$filelist", 1)  // first wave 
global remaining_files = subinstr("$filelist", "$first_file", "", 1)  // Remove the first file from the list 
* Open first file
use "${liss_out}/temp/topics/$first_file", clear 
qui tab wavey
display _newline(1) "   Total ->> Vars: " c(k) "; N: " _N "; Waves: " r(r)  
* Merge remainign files 
	foreach f in $remaining_files { 
	qui merge 1:1 nomem_encr wavey using "${liss_out}/temp/topics/`f'" , keep(1 2 3) nogen	
	qui tab wavey
	display _newline(1) "   Total ->> Vars: " c(k) "; N: " _N "; Waves: " r(r)  
	} 

*** Save temp
sort nomem_encr wavey
save "${liss_out}/temp/liss01_all_topics.dta", replace


*################################################################################
*#
*# Step 5: Final Dataset Creation - Merge Background & Topics  
*#
*################################################################################
*** Main CPF files 
** Create merging var for waves 
use "${liss_out}/temp/liss01_bckgr_ref.dta", replace
sort nomem_encr wavey
** Merge background with the selected months
* Keeps only matched cases (participants with background variables) 
merge 1:1 nomem_encr wavey using "${liss_out}/temp/liss01_all_topics.dta", keep( 3) nogen	// keep participants with background variables


*** Alternative merging if needed 
// merge 1:1 nomem_encr wavey using "${liss_out}/temp/liss01_all_topics.dta", keep(1 2 3) nogen	
// save "${liss_out}/nl_01_123.dta", replace

// merge 1:1 nomem_encr wavey using "${liss_out}/temp/liss01_all_topics.dta", keep(2 3) nogen	
// save "${liss_out}/nl_01_23.dta", replace




*################################################################################
*#
*# Save the final dataset 
*#
*################################################################################

save "${liss_out}/nl_01.dta", replace


*
qui tab wavey
display _newline(1) "   Total ->> Vars: " c(k) "; N: " _N "; Waves: " r(r) 


*################################################################################
*#
*# Additional: Cleaning the merged datafile 
*#
*################################################################################
/*
TO DO if necessary: Delete cases with no observations 

*** Count missing values per respondent
egen nmissing = rowmiss(_all)
label var nmissing "Number of missing values per respondent"
*
qui tab wavey
display _newline(1) "   Total ->> Vars: " c(k) "; N: " _N "; Waves: " r(r)  

*** Count number of valid (non-missing) values per respondent
egen nvalid = rownonmiss(_all), strok
label var nvalid "Number of valid (non-missing) values per respondent"

* Display summary of missing values
sum nmissing
sum nvalid if nvalid<70
*/
*################################################################################
*#
*# Additional file - create all months sequence 
*# Merge background with the all months (note: large file)
*#
*################################################################################

/*use "${liss_out}/temp/liss01_bckgr_all.dta", replace
gen waveliss_merge = wavey
sort nomem_encr waveliss_merge
merge 1:1 nomem_encr wavey intmonth using "${liss_out}/temp/temp_all_topics.dta", keep(1 2 3) nogen	
save "${liss_out}/temp/liss_all_months.dta", replace*/



*** Log
display "Ending LISS data preparation at $S_TIME"
log close


*____________________________________________________________________________
*--->	END	OF FILE <---
