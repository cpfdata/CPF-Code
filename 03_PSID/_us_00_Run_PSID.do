/*
===============================================================================
>> CPF Version 2.0 
File: "_11c_Run_PSID.do"
Purpose: Run PSID (USA) specific do-files
===============================================================================
*/

clear
di  _newline "### CPF: Preparing data for PSID (USA) ###"
di "Starting at time: $S_TIME"
di  "Preparing CPF datafile for PSID based on do-files in:"
cd "${your_dir}/11_CPF_in_syntax/03_PSID/"

local data "psid"
cd "${your_dir}/11_CPF_in_syntax/03_PSID/"
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
		cd "${your_dir}/11_CPF_in_syntax/03_PSID/"
		di "`dof'"
		capture noisily do "`dof'"
	}



di "->> CPF version ${cpfv} of PSID saved"
qui tab wave
di "->> Variables: " c(k) "; N: " _N "; Waves: " r(r)
di "Finished the code for [PSID]. At time:$S_TIME"
di "_____________________________________________________________"

*===============================================================================
