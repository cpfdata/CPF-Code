
/*
===============================================================================
>> CPF Version 2.0 
File: 	"2_CPF-Data-Run.do"
Purpose: 
		- This is the second CPF file to run 
		- Fill in the part (A) to setup data characteristics (select surveys, specify waves and files) 
		- Run the do-files in part (B) together with part (A) 
===============================================================================
Author:  Konrad Turek
Date:    07.2025
===============================================================================

INSTRUCTIONS:
1. Before running this code, extract the original survey data files into specific folders "Data"
   (follow instructions in the Manual). 
2. Fill-in the part (A) to setup data characteristics (select surveys, specify waves and files) 
   - see Workflow A, B and C in Manual
   - for Workflow A (no modifications, all surveys), do not change anything 
3. Run the do-files in part (B) together with part (A) 
4. In case of problems or new variables added - go to the lower-level codes
   (see Workflow D in Manual)
*/


set maxvar 15000
	
*################################################################################
*#																			
*#	(A) Setup data 		 													
*#																			
*################################################################################

** Define CPF version
	global cpfv "2.0"
	
**==============================================================================
**============= FILL-IN THIS PART ==============================================
**==============================================================================

**------------------------------------------------------------------------------
**	1. Your local directory	
**------------------------------------------------------------------------------
// Inster the main directory for storing original datasets and CPF working files 

	global your_dir "/Users/..."  // <--insert your directory 
	
* temp:
global disk "C:/Users/klturek/OneDrive - Tilburg University"
global your_dir "${disk}/_KT_work/_CPF/__CPF_2.0draft"  

**------------------------------------------------------------------------------
** 2. Define surveys to be included 
**------------------------------------------------------------------------------
// keep all or choose selected surveys from: hilda klips psid shp soep ukhls liss 

	global surveys "   hilda  klips psid shp soep ukhls liss   " 

to do:
psid 
 

	global surveys "      liss     " 

**------------------------------------------------------------------------------
** 3. Insert number of waves for selected surveys
**------------------------------------------------------------------------------
// This is required for some surveys due to names of files
// Inster the version that you have and want to harmonize (not necessairly the latest release)

	global hilda_w 	"20"		// version of HILDA, number of waves
	global klips_w 	"26"		// number of waves  
	global psid_w	"2023"		// latest year of PSID
	global shp_w 	"25"		// number of waves  
	global soep_w 	"40"		// version and number of waves  
	global ukhls_w	"14"		// version, number of UKHLS waves (without BHPS)
	global liss_w	"2024"		// latest year of LISS data (for LISS, this information is not necessary for the code to run)

**------------------------------------------------------------------------------
** 4. Insert names of files of directories for some of the selected surveys
**------------------------------------------------------------------------------
// For surveys below, the file names or directories may change in subsequent editions. 
// Note, also other surveys not listed here might require updating with subsequent editions. 
// If surveys are not listed below, you don't have to do anything with them. 

/* RLMS (EXCLUDED)
	global rlms_dataIND 	"RLMS_IND_1994_2021_2022_08_21_1_v2_eng_DTA"
	global rlms_dataHH 		"RLMS_HH_1994_2021_eng_DTA.dta" */
	
* UKHLS
	global ukhls_data 	"UKDA-6614-stata/stata/stata13_se" // folder that contains Stata raw data 




**==============================================================================
**============= END OF FILL-IN PART ============================================
**==============================================================================



*################################################################################
*#																			
*#	(B) Run Do-files 		 													
*#																			
*################################################################################


**--------------------------------------
** 5. Create directories and define global macros  
**--------------------------------------
// Directory "11_CPF_in_syntax/00_master/" was created in syntax 1_Folder_setup.do. Copy there the "_10_Directories_global.do". 
// Additionally, the code downloads the CPF documentation and sytaxes 
do "${your_dir}/11_CPF_in_syntax/00_master/_10_Directories_global.do" 		



**--------------------------------------
** 6. Run country-specific do-files 
**--------------------------------------
/* NOTE:
- Operations are complex and long.
- We recommend running each country separately for better control and debugging 
- If one country fails, others can still be processed
- Skip specific countries as needed
- Errors may appear (e.g., with new waves added) - then go to the lower level do-files 
  (usually do-files 01 and 02 at the country level)	- see Workflows C or D  
*/

	* 6A. HILDA
	do "${your_dir}/11_CPF_in_syntax/_au_00_Run_HILDA.do"

	* 6B. KLIPS
	do "${your_dir}/11_CPF_in_syntax/_ko_00_Run_KLIPS.do"

	* 6C. PSID
	do "${your_dir}/11_CPF_in_syntax/_us_00_Run_PSID.do"

	* 6D. SHP
	do "${your_dir}/11_CPF_in_syntax/_ch_00_Run_SHP.do"

	* 6E. SOEP
	do "${your_dir}/11_CPF_in_syntax/_ge_00_Run_SOEP.do"

	* 6F. UKHLS
	do "${your_dir}/11_CPF_in_syntax/_uk_00_Run_UKHLS.do"

	* 6G. LISS
	do "${your_dir}/11_CPF_in_syntax/_nl_00_Run_LISS.do"


		/* Information about RLMS (CPF 2.0)
		Russian data (RLMS) are no longer supported by CPF. For more information, see release notes */
		type "${your_dir}/11_CPF_in_syntax/04_RLMS/RLMS_excluded_CPF2.0.txt"

**--------------------------------------
** 7. Combine country-specific CPF files 
**--------------------------------------
// Modify the do-files if new variables added - see Workflow D  

* Append country files into one CPF file
do "${your_dir}/11_CPF_in_syntax/00_master/_12_Append.do" 		

* Apply unified labels
do "${your_dir}/11_CPF_in_syntax/00_master/_13_Labels.do" 	

display "$S_TIME"



*_______________________________________________________________________________
* END of file

