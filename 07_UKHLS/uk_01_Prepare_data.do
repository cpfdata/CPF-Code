*
**|=========================================================================|
**|	    ####	CPF			####											|
**|		>>>	UK							 									|
**|		>>	Prepare data + Combine (all files, all vars)					|
**|-------------------------------------------------------------------------|
**|		Konrad Turek 	| 	2020	|	turek@nidi.nl						|
**|=========================================================================|
* 



**--------------------------------------
** Additional macros
**--------------------------------------
global uk_n= ${ukhls_w}+18 // number of all waves including BHPS
global BHPSwaves "a b c d e f g h i j k l m n o p q r"
global UKHLSwaves_bh = substr(c(alpha), 1,  ($ukhls_w *2) )		// letters identify waves 
// e.g. global UKHLSwaves_bh "a b c d e f g h i"  
 

* global UKHLSno 9	// number of waves of UKHLS data	

// clear
// set maxvar 10000

*############################
*#							#
*#	Combine all ind files	#
*#							#
*############################
/*Note:
-  Partly based on sytax provided on UKHLS web page
*/
 

**--------------------------------------
** Step 1: rename 
**--------------------------------------

*** BHPS
foreach w of global BHPSwaves {
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	use "$ukhls_in\bhps_w`waveno'\b`w'_indresp", clear
		rename b`w'_* *
		gen wave=`waveno'
		gen uk_ver = "bhps"
		sort pidp
		order pidp wave, first
	save "${ukhls_out_work}\tmp_b`waveno'_indresp", replace
}
*** UKHLS
foreach w of global UKHLSwaves_bh {
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	use  "$ukhls_in/ukhls_w`waveno'/`w'_indresp", clear
		rename `w'_* *
		// generate a variable which records the wave number + 18 
		gen wave=`waveno'+18
		gen uk_ver = "ukhls"
		local x=`waveno'+18
		sort pidp
		order pidp wave, first
	save "${ukhls_out_work}\tmp_`x'_indresp", replace
}
*

**--------------------------------------
** Step 2: Append  
**--------------------------------------

*** BHPS
use "${ukhls_out_work}\tmp_b1_indresp", clear
foreach w of numlist 2/18 {
		display "Appending wave: "`w'
			qui append using "${ukhls_out_work}\tmp_b`w'_indresp"
		display "After appned of wave `w' - Vars:" c(k) " N: " _N
		display ""
	}
sort pidp wave
save "${ukhls_out}\uk_01_bhps.dta", replace

*** UKHLS
local last = ${uk_n}
foreach w of numlist 19/`last' {
		display "Appending wave: "`w'
			qui append using "${ukhls_out_work}\tmp_`w'_indresp"
		display "After appned of wave `w' - Vars:" c(k) " N: " _N
		display ""
}
*
sort pidp wave
rename pid pid_bhps
rename pidp pid
save "${ukhls_out}\uk_01_bhps_hls.dta", replace


**--------------------------------------
** Step 3: Delete temp files 
**--------------------------------------
 
// erase each temporary file using loops
foreach w of numlist 1/18 {
	erase "${ukhls_out_work}\tmp_b`w'_indresp.dta"
}
local last = ${uk_n}
foreach w of numlist 19/`last'  {
	erase "${ukhls_out_work}\tmp_`w'_indresp.dta"
}
*




*############################
*#							#
*#	Combine HH files		#
*#							#
*############################
/*Note:
-  Partly based on sytax provided on UKHLS web page
*/
 

**--------------------------------------
** Step 1: rename 
**--------------------------------------

*** BHPS
foreach w of global BHPSwaves {
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	use "$ukhls_in/bhps_w`waveno'/b`w'_hhresp", clear  
		rename b`w'_* *
		gen wave=`waveno'
		gen uk_ver = "bhps"
		sort hidp
		order hidp wave, first
	save "${ukhls_out_work}\tmp_b`waveno'_hhresp", replace
}
*** UKHLS
foreach w of global UKHLSwaves_bh {
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	use  "$ukhls_in/ukhls_w`waveno'/`w'_hhresp", clear
		rename `w'_* *
		// generate a variable which records the wave number + 18 
		gen wave=`waveno'+18
		gen uk_ver = "ukhls"
		local x=`waveno'+18
		sort hidp
		order hidp wave, first
	save "${ukhls_out_work}\tmp_`x'_hhresp", replace
}
*

**--------------------------------------
** Step 2: Append  
**--------------------------------------

*** BHPS
use "${ukhls_out_work}\tmp_b1_hhresp", clear
foreach w of numlist 2/18 {
		display "Appending wave: "`w'
			qui append using "${ukhls_out_work}\tmp_b`w'_hhresp"
		display "After appned of wave `w' - Vars:" c(k) " N: " _N
		display ""
	}
sort hidp wave
save "${ukhls_out}\uk_01hh_bhps.dta", replace

*** UKHLS
local last = ${uk_n}
foreach w of numlist 19/`last' {
		display "Appending wave: "`w'
			qui append using "${ukhls_out_work}\tmp_`w'_hhresp"
		display "After appned of wave `w' - Vars:" c(k) " N: " _N
		display ""
}
*
sort hidp wave
save "${ukhls_out}\uk_01hh_bhps_hls.dta", replace


**--------------------------------------
** Step 3: Delete temp files 
**--------------------------------------
 
// erase each temporary file using loops
foreach w of numlist 1/18 {
	erase "${ukhls_out_work}\tmp_b`w'_hhresp.dta"
}
local last = ${uk_n}
foreach w of numlist 19/`last'  {
	erase "${ukhls_out_work}\tmp_`w'_hhresp.dta"
}




*################################
*#								#
*#	Merge Ind + HH (selected)	#
*#								#
*################################
/*Note:
-  only selected var
- update if needed 
*/
use "${ukhls_out}\uk_01_bhps_hls.dta", clear

**--------------------------------------
**  
**--------------------------------------
rename hhsize hhsize_1_18
merge m:1 hidp wave using "${ukhls_out}\uk_01hh_bhps_hls.dta" , ///
		keep(1 3) nogen ///
		keepusing(nkids015   hhsize nkids_dv nch02_dv nch34_dv nch511_dv nch1215_dv ///
		ieqmoecd_dv fihhmnnet1_dv fihhmngrs_dv fihhmngrs1_dv)  
		
save "${ukhls_out}\uk_01.dta", replace



**--------------------------------------  
**  Drop some vars to make the database smaller 
**--------------------------------------
drop   ///
j2pay_if-fihhmni netph_1-netkn_3 pyspn1- pysts3 bwtpn1-bwtg54  ///
chaid1- paidu96 jbst1h-lwsdnw7  edqnn3-edoql3  scptrt5a1-scptrt5o3   ///
debtpn0-debtpn16 unsafew11- carmiles natch01-natch16    adoptch01-  adoptch16   ///
allch01- allch16 mstatsamn -cmlstat3  lmcbm1-lmspy44 pregm1- lchmulti5   ///
ff_bentype01-ff_yr2uk4  resunsafe1_1- resattacked97_12 netlv_1 - netdo96_3	///
comimmls11-clangab chbrfed01- chbrfed16 opserv1 -  srvynot10 svamt1-svsk6    ///
ccjtp1-ccjtp16  debt1-olymact398 csakidno1-cmvolkidno5 netett_1-netetbt_3    ///
mstatch4-aepuda5  alllang1-mlivedc5 hinfano1-hinfano9  hinfbno1-hinfbno9    ///
helpcode1-nopayb  pregft11- pregspd3 reasend1_1-reasend97_6   ///
missource01-cmcokidno16 cmvolkidno6-cmvolkidno16 respchild1-respchild16   ///
stendoth_code-lmspy47

**--------------------------------------  
**  Save
**--------------------------------------

save "${ukhls_out}\uk_01.dta", replace



* You can remove the large file if not needed
erase "${ukhls_out}\uk_01_bhps_hls.dta"

*____________________________________________________________________________
*--->	END	OF FILE <---