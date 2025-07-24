/*
===============================================================================
>> CPF Version 2.0 
File: "_10_Directories_global.do"
Purpose: 
- This is a lower-level code to run automatically from 2_CPF-Data-Run.do
- Create directories for all syntaxes
===============================================================================
Author:  Konrad Turek
Date:    07.2025
===============================================================================
INSTRUCTIONS:
- The code is run automatically from 2_CPF-Data-Run.do
- Alternatively, users can run it independently 
	a) Instert your directory in #A (currently it refers to `your_dir' that was 
	   defined in higher-level code 2_CPF-Data-Run.do)
	b) Run the rest of the code unchanged (#B1, #B2, #B3). It defines global 
	   macros for all syntaxes and input/output folders 

*/



*################################################################################
*#
*#	A. FILL-IN: Your local directory	
*#
*################################################################################
/* Inster the main directory for storing original datasets and all the CPF files. 
   It's not necessary if you run it from the higher-level code
*/
// global your_dir "/User/..."  // <--insert your directory 




*################################################################################
*#
*#	B. Do not change the following part if not neccessary 
*#
*################################################################################

**-------------------------------------------
**	B1. Define main global macros 
**-------------------------------------------

*** Create names for the main folders

	global g_docs		"01_CPF_docs" 			//CPF documentation 
	global g_in 		"02_Country_Data_Origin" 	//original input data 
	global g_syntax 	"11_CPF_in_syntax"		//syntax
	global g_out 		"12_CPF_out_data"		//CPF working and output folder
	
*** Macros
	* Main folders 
	global Gdr_docs		"${your_dir}//${g_docs}" 			 
	global Gdr_in 		"${your_dir}//${g_in}"  	
	global Gdr_syntax 	"${your_dir}//${g_syntax}" 		
	global Gdr_out 		"${your_dir}//${g_out}" 		
	
	* Survey-specific folder names
	global hilda 	"01_HILDA"
	global klips 	"02_KLIPS"
	global psid 	"03_PSID"
	/* global rlms 	"04_RLMS" */
	global shp		"05_SHP"
	global soep		"06_SOEP"
	global ukhls	"07_UKHLS"
	global liss		"08_LISS"
	global surv_fold  $hilda $klips $psid $shp $soep $ukhls $liss
	
	* country prefix 
	global hilda2 	au
	global klips2 	ko	
	global psid2 	us
	/* global rlms2 	ru			  */
	global shp2 	ch	 
	global soep2 	ge			
	global ukhls2 	uk			
	global liss2 	nl


**--------------------------------------
** B2. Define specific input and output macros
**--------------------------------------
*** Macros: Input folders  
* HILDA
global hilda_in "${Gdr_in}//${hilda}/Data" 			

* KLPIS
global klips_in "${Gdr_in}//${klips}/Data" 	

* PSID
global psid_in 	"${Gdr_in}//${psid}/data/Cross-year Individual 1968-${psid_w}" 	// update with new waves  	 
global psid_downl   "${Gdr_in}//${psid}/data/Family and Ind Files (zip)"
global psidtools_in	"${Gdr_in}/${psid}/data/PSIDtools_files"
global psid_org "${psid_in}//psid_crossy_ind.dta"
global psid_syntax "${Gdr_syntax}//${psid}/"				//PSID syntax
global psid_ind_er_name	"IND${psid_w}ER.txt" 	// PSID "Cross-year Individual 1968-XXXX" file
global psid_ind_er "${psid_in}/pack//${psid_ind_er_name}" 	// PSID "Cross-year Individual 1968-XXXX" file
	
* RLMS
/* global rlms_in "${Gdr_in}//${rlms}/data" 		  */

* SHP
global shp_in "${Gdr_in}//${shp}/Data" 		 
global shp_in_cnef "${shp_in}/SHP-Data-CNEF-STATA" 		

* SOEP
global soep_in "${Gdr_in}//${soep}/Data/soep.v${soep_w}" 	 

//global soep_in "${Gdr_in}//${soep}/Data/soep.v${soep_w}" 	 
global soep_in "${Gdr_in}//${soep}/Data/Stata_DE/soepdata" 	 
					
* UKHLS
global ukhls_data 	"UKDA-6614-stata/stata/stata13_se" // Folder that contains Stata raw data. 
									// NOTE: It might need to be updated with subsequent editions.
global ukhls_in "${Gdr_in}//${ukhls}/Data//${ukhls_data}"

* LISS 
global liss_in "${Gdr_in}//${liss}/Data" 		 
		 

*** Macros: Output folders 
* for CPF-country data 
foreach surv in hilda klips psid shp soep ukhls liss {
global `surv'_out "${Gdr_out}//${`surv'}_cpf"		 
global `surv'_out_work "${`surv'_out}/temp"
}
* Aditional for SHP-CNEF
global shp_out_work_cnef "${shp_out_work}/CNEF"
* Output folders for CPF main data 
global CPF_out "${Gdr_out}//10_CPF" 	



**--------------------------------------
** B3. Create additional folders for input data 
**--------------------------------------

*** HILDA
capture mkdir "${Gdr_in}//${hilda}/data/STATA ${hilda_w}0c (Combined)"
capture mkdir "${Gdr_in}//${hilda}/data/STATA ${hilda_w}0c (Other)"


*_______________________________________________________________________________
* END OF THE CODE