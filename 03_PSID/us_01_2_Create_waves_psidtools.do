/*
===============================================================================
CPF Version 2.0 
PSID 
Syntax 01_2: Edit datasets with 'psidtools'
===============================================================================
Purpose: Create waves with psidtools
Author:  Konrad Turek
Date:    06.2025
Input:   Zip files from "data/Family and Ind Files (zip)" (e.g., fam1968.zip)
Output:  dta files in "data/PSIDtools_files" (e.g., fam1968.dta)
===============================================================================
*/
* Log
capture log close 
log using "${psid_out}/us_01_2_create_waves_psidtools.log", replace
display "Starting PSID waves creation at $S_TIME"

*################################################################################
*#							
*#	Install psidtools		
*#							
*################################################################################
* If not done yet, install psidtools
* The package is available at SSC
* Psidtools is a collection of Stata commands for working with the PSID.
* It administers the PSID data files and provides tools for working with the data.

 // ssc install psidtools


*################################################################################
*#							
*#	Install psidtools - temporary version for CPF 2.0
*#							
*################################################################################
/*
At the moment of preparing the CPF 2.0 (6.2025), Psidtools required a small 
update to work with 2023 wave. The original Psidtools package was updated only 
until PSID 2021 wave. Thus, it is required to install the temporary version of 
Psidtools - it is based on the original code of the Psidtools creator, Prof. Dr. 
Ulrich Kohler (https://gitup.uni-potsdam.de/ukohler)
- the source code is available at: 
  https://gitup.uni-potsdam.de/ukohler/psidtools/-/blob/main/psid.ado 
- it was updated by K.Turek (small adjustments at the end of the code 
  (e.g., 'stop at 2021' changed to 'stop at 2023'))
*/
cap program drop psidtools   // remove old version of psidtools if installed 
do "${psid_syntax}/psidtools cpf2/psidtools_cpf2.do"


*################################################################################
*#							
*#	PSIDtools - prapare PSID files using psidtools
*#							
*################################################################################
**--------------------------------------
** Unpack and prepare 
**--------------------------------------
* NOTE: The operation can take a while 

clear

psid install using "${psid_downl}", to("${psidtools_in}")

// !del "${psid_downl}/*" /q	// remove packed files 


* Log
display "Completed PSID us_01_2_create_waves_psidtools at $S_TIME"
log close

*____________________________________________________________________________
*--->	END	OF FILE <---
