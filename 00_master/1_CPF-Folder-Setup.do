/*
===============================================================================
>> 	CPF Version 2.0 
File: 	"1_CPF-Folder-setup.do"
Purpose: 
		- This is the first CPF file to run 
		- Folder setup for extracting original data 
		- Create the folder structure for storing original datasets and all the CPF files 
===============================================================================
Author:  Konrad Turek
Date:    07.2025
===============================================================================

INSTRUCTIONS:
A. Insert your directory in #1 
B. Run the rest of the code unchanged (unless you want to change the folder structure) 
	- Codes #2-#3 create the folder structure
	- Install Stata ados required for the CPF syntax (#4)
	- Additional settings (#5)
C. Additionally, you can:
	- Download CPF documentation (#6)
D. Copy the original input datafiles to specific folders (#7). 
   You must do it manually according to the instructions in the Manual
E. Remember to copy all CPF-do-files to folder "11_CPF_in_syntax" 
   (Or simply rename downloaded "CPF-Code-main" as "11_CPF_in_syntax").
*/

*################################################################################
*#
*#	1. FILL-IN: Your local directory	
*#
*################################################################################
// Inster the main directory for storing original datasets and all the CPF files 
	
global your_dir "/Users/..."  // <--inster your directory 




*################################################################################
*#
*#	DO NOT change the following part if not neccessary	
*#
*################################################################################
* Simple run the code unchanged (ctrl+A -> ctrl+D)  

**-------------------------------------------
**	2. Define main global macros 
**-------------------------------------------

*** Create names for the main Folders

	global Fdocs		"01_CPF_docs" 			//CPF documentation 
	global Fin 			"02_Country_Data_Origin" 	//original input data 
	global Fsyntax 		"11_CPF_in_syntax"		//syntax
	global Fout 		"12_CPF_out_data"		//CPF working and output folder
	
*** Macros
	* Main folders 
	global Gdr_docs		"${your_dir}//${Fdocs}" 			 
	global Gdr_in 		"${your_dir}//${Fin}"  	
	global Gdr_syntax 	"${your_dir}//${Fsyntax}" 		
	global Gdr_out 		"${your_dir}//${Fout}" 		
	
	* Survey-specific folder names
	global hilda 	"01_HILDA"
	global klips 	"02_KLIPS"
	global psid 	"03_PSID"
	/* global rlms 	"04_RLMS" */ // RLMS excluded from CPF 2.0
	global shp		"05_SHP"
	global soep		"06_SOEP"
	global ukhls	"07_UKHLS"
	global liss		"08_LISS"
	global surv_fold  $hilda $klips $psid $shp $soep $ukhls $liss

**-------------------------------------------
**	3. Create main folders structure 
**-------------------------------------------

*** Create the main directory if it does not exist
capture mkdir 	"${your_dir}"   
		
*** Create the main CPF folders
capture mkdir 	"${Gdr_docs}" 			
capture mkdir 	"${Gdr_in}" 			 
capture mkdir   "${Gdr_syntax}"	
capture mkdir   "${Gdr_out}"	

	
*** Create output folders  
* The CPF main output folder 
capture mkdir "${Gdr_out}//10_CPF" 	
* Survey-specific output folders
foreach surv of global surv_fold  {
// capture mkdir	"${Gdr_syntax}//`surv'"
capture mkdir	"${Gdr_in}//`surv'"
capture mkdir 	"${Gdr_in}//`surv'/Data"
capture mkdir 	"${Gdr_out}//`surv'_cpf"  		//CPF main data folder
capture mkdir 	"${Gdr_out}//`surv'_cpf/temp"  	//working files
}


*** Additional survey-specific folders 
* PSID
capture mkdir 	"${Gdr_in}//${psid}/data/Cross-year Individual 1968-2023" 	// update name (year) with new waves		
capture mkdir 	"${Gdr_in}//${psid}/data/Cross-year Individual 1968-2023/pack" 	// update name (year) with new waves
capture mkdir  	"${Gdr_in}//${psid}/data/Family and Ind Files (zip)"
capture mkdir  	"${Gdr_in}//${psid}/data/PSIDtools_files"	
* SHP
capture mkdir "${Gdr_out}/05_SHP_cpf/temp/CNEF"
* LISS - create folders 01-11 for each module/topic 
forvalues i = 1/9 {
    capture mkdir "${Gdr_in}//${liss}/data/0`i'"
}
capture mkdir "${Gdr_in}//${liss}/data/10"
capture mkdir "${Gdr_in}//${liss}/data/11"




**------------------------------------------------------------------------------
**	4. Install Stata ados required for the CPF syntax 
**------------------------------------------------------------------------------
foreach ado in isvar iscogen psidtools fs {
	cap which `ado'
	if _rc ssc install `ado'
}

// renvars
cap which renvars
	if _rc net install http://www.stata-journal.com/software/sj5-4/dm88_1

	
// svmat2 (STB-56 dm79):
cap which svmat2
	if _rc	net install  http://www.stata.com/stb/stb56/dm79

**------------------------------------------------------------------------------
**	5. Additional settings 
**------------------------------------------------------------------------------

clear
set maxvar 10000
set more off

**==============================================================================
**======	Additional instructions	 ===============
**==============================================================================

**------------------------------------------------------------------------------
**	6. Download CPF documentation and sytaxes 
**------------------------------------------------------------------------------

// Copy the latest files from the CPF online platform 

copy "https://github.com/cpfdata/CPF-Documentation/raw/main/CPF_manual%20v1.5.pdf" "${your_dir}//${Fdocs}/CPF_manual_v1.5.pdf"
copy "https://github.com/cpfdata/CPF-Documentation/raw/main/CPF_Codebook_v1.5.pdf" "${your_dir}//${Fdocs}/CPF_Codebook_v1.5.pdf"


**------------------------------------------------------------------------------
** 7. Copy input data files into specific folders 
**------------------------------------------------------------------------------

/*
Extract survey-data to specific "data" folders accorgin 
to instructions in the Manual:

	`path'/`survey'/Data

*/



*################################################################################
*#
*#	Licence Apache-2
*#
*################################################################################
/* 
Copyright 2025 CPF Konrad Turek

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
