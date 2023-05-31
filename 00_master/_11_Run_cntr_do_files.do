*
**|=============================================|
**|	    ####	CPF	ver 1.5		####			|									
**|		>>>	_11_ Run country-specific do-files 	|						 		
**|---------------------------------------------|
**|		Konrad Turek 	| 	2023				|									
**|=============================================|
* 

** II. Run Do-files 
**--------------------------------------
** 2. Run country-specific do-files 
**--------------------------------------

/* NOTE:
- Operations are complex and long.
- Errors may appear with new waves added - then go to the lower level do-files 
  (usually do-files 01 and 02 at the country level)	
- When the code 11_Run_cntr_do_files does not run smoothly 
  (e.g. due to memory or disk space limitations),
  run one country at a time or additionally do-files 01, 02 and 03 step-by-step. 
*/

 

local data= "$surveys"	// hilda klips psid rlms shp soep ukhls
foreach data in  `data' {

clear
di  _newline "### CPF: ${`data'} ###########################################"
di  "Preparing CPF datafile for ${`data'} based on do-files in:"
cd "${your_dir}\11_CPF_in_syntax\\${`data'}\"
	local do01: 	dir . files "${`data'2}_01_Prepare_data.do"		, respectcase  
	local do01_1: 	dir . files "${`data'2}_01_1*.do"				, respectcase
	local do01_2: 	dir . files "${`data'2}_01_2*.do"				, respectcase
	local do01_3: 	dir . files "${`data'2}_01_3*.do"				, respectcase
	local do02: 	dir . files "${`data'2}_02_Harmonize*.do"		, respectcase
	local do02_1: 	dir . files "${`data'2}_02_1*.do"				, respectcase
	local do02_2: 	dir . files "${`data'2}_02_2*.do"				, respectcase
	local do02_3: 	dir . files "${`data'2}_02_3*.do"				, respectcase
	local do03: 	dir . files "${`data'2}_03*.do"					, respectcase

	di  "->> Running do-files:"
	foreach dof in  `do01' `do01_1' `do01_2' `do01_3' `do02' `do02_1' `do02_2' `do02_3' `do03' {
		di "`dof'"
		capture do "`dof'"
	}
di "->> CPF version ${cpfv} of ${`data'} saved"
qui tab wave
di "->> Variables: " c(k) "; N: " _N "; Waves: " r(r)
di "_____________________________________________________________"
}  


