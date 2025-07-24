
/*
===============================================================================
>> CPF Version 2.0 
File: 	"2_CPF-Data-Run.do"
Purpose: 
		- This is the second CPF file to run 
		- Fill in the part (A) to setup data characteristics
		- Run part (B) to create country-specific and harmonized CPF files
===============================================================================
Author:  Konrad Turek
Date:    07.2025
===============================================================================

INSTRUCTIONS:
1. Before running this code, extract the original survey data files into specific folders "Data"
   (follow instructions in the Manual). 
2. Fill-in the part (A) to setup data characteristics:
    - Insert your local directory (A1), the same as in 1_CPF-Folder-setup.do
    - Define surveys to be included (A2)
    - Specify number of waves for selected surveys (A3)
3. Run part (A) 
4. Run part (B) 
    - Run country-specific do-files (B1) one by one
    - Combine country-specific files into a single CPF file (B2)
5. ADDITIONAL INFORMATION: 
    - For more information, see Workflow A, B and C in the Manual. 
    - If you follow  Workflow A (no modifications), do not change anything in the code below. 
    - In case of problems or new variables added - go to the lower-level codes
      (see Workflow D in the Manual)
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
**============= FILL-IN PART A1-A3 =============================================
**==============================================================================

**------------------------------------------------------------------------------
**	A1. Your local directory	
**------------------------------------------------------------------------------
// Inster the main directory for storing original datasets and CPF working files 

	global your_dir "/Users/..."  // <--insert your directory 
	

* 
**------------------------------------------------------------------------------
** A2. Define surveys to be included 
**------------------------------------------------------------------------------
// keep all or choose selected surveys from: hilda klips psid shp soep ukhls liss 

	global surveys "   hilda  klips psid shp soep ukhls liss   " 

**------------------------------------------------------------------------------
** A3. Insert number of waves for selected surveys
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



**==============================================================================
**============= END OF THE FILL-IN PART ========================================
**============= NOW RUN THE PART A1-A3 =========================================
**==============================================================================



*################################################################################
*#																			
*#	(B) Run Do-files 		 													
*#																			
*################################################################################


**--------------------------------------
** 5. Create directories and define global macros  
**--------------------------------------
/*  Notes:
    - Directory "11_CPF_in_syntax/00_master/" was created in syntax 1_CPF-Folder-Setup.do. 
      Copy there the "_10_Directories_global.do". 
    -  Additionally, the code downloads the CPF documentation and sytaxes 
    - Note that for some surveys, the file names or directories may change in subsequent editions (and require updating the code) 
*/

    do "${your_dir}/11_CPF_in_syntax/00_master/_10_Directories_global.do" 		



**--------------------------------------
** B1. Run country-specific do-files 
**--------------------------------------
/* NOTE:
- Operations are complex and long.
- We recommend running each country separately for better control and debugging 
- If one country fails, others can still be processed
- Skip specific countries as needed
- Errors may appear (e.g., with new waves added) - then go to the lower level do-files 
  (usually do-files 01 and 02 at the country level)	- see Workflows C or D  
*/

	* B1A. HILDA
	do "${Gdr_syntax}/01_HILDA/_au_00_Run_HILDA.do"

	* B1B. KLIPS
	do "${Gdr_syntax}/02_KLIPS/_ko_00_Run_KLIPS.do"

	* B1C. PSID
	do "${Gdr_syntax}/03_PSID/_us_00_Run_PSID.do"

	* B1D. SHP
	do "${Gdr_syntax}/05_SHP/_ch_00_Run_SHP.do"

	* B1E. SOEP
	do "${Gdr_syntax}/06_SOEP/_ge_00_Run_SOEP.do"

	* B1F. UKHLS
	do "${Gdr_syntax}/07_UKHLS/_uk_00_Run_UKHLS.do"

	* B1G. LISS
	do "${Gdr_syntax}/08_LISS/_nl_00_Run_LISS.do"


		/* Information about RLMS (CPF 2.0)
		Russian data (RLMS) are no longer supported by CPF. For more information, see release notes */
		type "${Gdr_syntax}/04_RLMS/RLMS_excluded_CPF2.0.txt"

**--------------------------------------
** B2. Combine country-specific CPF files 
**--------------------------------------
// Modify the do-files if new variables added - see Workflow D  

* Append country files into one CPF file
    do "${Gdr_syntax}/00_master/_11_Append.do" 		

* Apply unified labels
    do "${Gdr_syntax}/00_master/_12_Labels.do" 	



*_______________________________________________________________________________
* END OF THE CODE

