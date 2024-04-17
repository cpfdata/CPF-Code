*
**|=========================================|
**|	    ####	CPF	ver 1.5		####		|
**|		>>>	Fill in and run					|
**|-----------------------------------------|
**|		Konrad Turek 	| 	2023			|			
**|=========================================|

/* INSTRUCTIONS:
Before running this code, extract the original survey data files into specific folders "Data"
(follow instructions in the Manual). 
1. Fill-in the part (A) to setup data characteristics (select surveys, specify waves and files) 
   - see Workflow A, B and C in Manual
   - for Workflow A (no modifications, all surveys), do not change anything 
2. Run the do-files in part (B) together with part (A) 
3. In case of problems or new variables added - go to the lower-level codes
   (see Workflow D in Manual)
*/


set maxvar 15000
	
*############################
*#							#
*#	(A) Setup data 		 	#
*#							#
*############################

** Define CPF version
	global cpfv "1.5"
	
**==============================================================================
**============= FILL-IN THIS PART ==============================================
**==============================================================================

**------------------------------------------------------------------------------
**	1. Your local directory	
**------------------------------------------------------------------------------
// Inster the main directory for storing original datasets and CPF working files 

	global your_dir "/Users/..."  // <--insert your directory 

**------------------------------------------------------------------------------
** 2. Define surveys to be included 
**------------------------------------------------------------------------------
// keep all or choose selected surveys from: hilda klips psid rlms shp soep ukhls 

	global surveys "   hilda  klips psid rlms shp soep ukhls   " 

**------------------------------------------------------------------------------
** 3. Insert number of waves for selected surveys
**------------------------------------------------------------------------------
// This is required for some surveys due to names of files
// Inster the version that you have and want to harmonize (not necessairly the latest release)

	global hilda_w 	"20"		// version of HILDA, number of waves
	global klips_w 	"24"		// number of waves  
	global psid_w	"2019"		// latest year of PSID
	global shp_w 	"22"		// number of waves  
	global soep_w 	"37"		// version and number of waves  
	global ukhls_w	"12"			// version, number of UKHLS waves (without BHPS)

**------------------------------------------------------------------------------
** 4. Insert names of files of directories for some of the selected surveys
**------------------------------------------------------------------------------
// For surveys below, the file names or directories may change in subsequent editions. 
// Note, also other surveys not listed here might require updating with subsequent editions. 
// If surveys are not listed below, you don't have to do anything with them. 

* RLMS
	global rlms_dataIND 	"RLMS_IND_1994_2021_2022_08_21_1_v2_eng_DTA"
	global rlms_dataHH 		"RLMS_HH_1994_2021_eng_DTA.dta"
	
* UKHLS
	global ukhls_data 	"UKDA-6614-stata/stata/stata13_se" // folder that contains Stata raw data 




**==============================================================================
**============= END OF FILL-IN PART ============================================
**==============================================================================




*############################
*#							#
*#	(B) Run Do-files 		#
*#							#
*############################


**--------------------------------------
** 5. Create directories and define global macros  
**--------------------------------------
// Directory "11_CPF_in_syntax/00_master/" was created in syntax 1_Folder_setup.do. Copy there the "_10_Directories_global.do". 
// Additionally, the code downloads the CPF documentation and sytaxes 
do "${your_dir}/11_CPF_in_syntax/00_master/_10_Directories_global.do" 		



**--------------------------------------
** 6. Run country-specific do-files 
**--------------------------------------
* 
/* NOTE:
- Operations are complex and long.
- Errors may appear with new waves added - then go to the lower level do-files 
  (usually do-files 01 and 02 at the country level)	- see Workflows C or D  
- When the code 11_Run_cntr_do_files does not run smoothly 
  (e.g. due to memory or disk space limitations), run one country at a time 
  or additionally run step-by-step do-files 01, 02 and 03 by country. 
*/
display "$S_TIME"
do "${your_dir}/11_CPF_in_syntax/00_master/_11_Run_cntr_do_files.do" 		

display "$S_TIME"

**--------------------------------------
** 7. Combine country-specific CPF files 
**--------------------------------------
// Modify the do-files if new variables added - see Workflow D  

* Append country files into one CPF file
do "${your_dir}/11_CPF_in_syntax/00_master/_12_Append.do" 		

* Apply unified labels
do "${your_dir}/11_CPF_in_syntax/00_master/_13_Labels.do" 	

display "$S_TIME"

***
*END
