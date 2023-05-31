*
**|=========================================================|
**|	    ####	CPF	v1.5	####							|
**|		>>>	UK							 					|
**|		>>	Prepare data + Combine (all files, all vars)	|
**|---------------------------------------------------------|
**|		Konrad Turek 		| 	2023						|
**|=========================================================|
* 
clear
set maxvar 10000

**--------------------------------------
** Additional macros
**--------------------------------------
global uk_n= ${ukhls_w}+18 // number of all waves including BHPS
global BHPSwaves "a b c d e f g h i j k l m n o p q r"
global UKHLSwaves_bh = substr(c(alpha), 1,  (${ukhls_w}*2) )		// letters identify waves 
// e.g. global UKHLSwaves_bh "a b c d e f g h i"  
 

* global UKHLSno 9	// number of waves of UKHLS data	

*############################
*#							#
*#	Combine all ind files	#
*#							#
*############################
/*Note:
-  Partly based on sytax provided on UKHLS web page
*/
 

**--------------------------------------
** Step 1: rename & select variables 
**--------------------------------------



**selection of stable characteristics using xwavedat --> these are merged with the files for each wave
*
use "$ukhls_in\ukhls\xwavedat", clear
		keep pid pidp lprnt_bh bornuk_dv ukborn plbornc macob pacob race*
	save "${ukhls_out_work}\tmp_xwavedat", replace

*** The list of all variables used for harmonization (selection required due to file size)
*** HERE: Add all new variables to the local if you want to add them to harmonization
***		  code 02 - both from BHPS and UKHLS 

local all_vars /// 
age age_dv benpen1 birthy bornuk_dv chron country disab disab2c disdif* dissev* divor doby_dv ednew edu3 edu4 edu5 emplst5 emplst6 englang entrep2 fedu* female fihhmngrs_dv fimnlabgrs_dv fimnlagrs_dv fiyr fptime fptime_h fptime_r haspart health hgsex hgsex hhinc_* hhsize hhtype_dv hid hidp hlstat imp_edu incjob1* incjobs* indinub_lw indinub_xw indinui_lw indinui_xw indinus_lw indpxui_lw indpxui_xw indscui_lw indust* intdatm_dv intdaty_dv intmonth intyear isced isced11_dv isco* isei* istrtdatm istrtdaty ivfio j2hrs jbed jbft_dv jbhas jbhrs jbiindb_dv jbisco88_cc jbmngr jbnssec_dv jbnssec3_dv jbnssec5_dv jbnssec8_dv jboff jboffy_bh jbot jbrgsc_dv jbsat* jbsec jbsec* jbsectpub jbseg_dv jbsemp jbsic jbsic07_cc jbsic92 jbsize jbstat jhsic92 jliindb_dv jlnssec_dv jlnssec3_dv jlnssec5_dv jlrgsc_dv jlseg_dv jlsic92 jsboss jsecu jsecu2 jshrs jssat2 jssize julk4wk kidlang kidlang_all kids_any kidsn_hh15 kidsn_hh15 ladopt lewght lfsat1 lfsat2 lfsato livesp livewith livpart livpart lprnt lrwght macob maedqf marstat marstat_dv marstat5 mastat mastat_dv mater medu* memorig mlstat mlstat mlstat_bh mlstat_bh mlstat5 mps* mrjnssec_dv mrjnssec8_dv mrjsic mrjsic9 nch02_dv nch1215_dv nch34_dv nch511_dv ncrr1 ncrr13 nempl nipens nipens nmpsp_dv nnatch nnmpsp_dv nphh nrpart nrpart nunmpsp_dv nvmarr oprlg oprlg1 oprlg2 oprlg3 oprlg5 pacob paedqf parstat6 paygu_dv paynu_dv pbnft1 pensioner_dv pid pidp place plbornc public qfhigh_dv qfhighoth racel* respstat retf sampid_* sampst satfinhh10 satfinhh5 sathlth10 sathlth5 satlife* satlife10 satlife5 satwork10 satwork5 sclfsat* scsf1 selfemp* separ sex sf1 sf12mcs_dv sf12pcs_dv siops* size5 size5b spinhh srh5 supervis swemwbs_dv train trainany ukborn un_act urban_dv wave wavey whmonth whweek* widow work_d xewght xewghte xrwght xrwghte yborn jbsat_bh  
	
	
*** BHPS
foreach w of global BHPSwaves {
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	use "$ukhls_in\bhps\b`w'_indresp", clear
		rename b`w'_* *
		gen wave=`waveno'
			gen uk_ver = "bhps"
		sort pidp
		order pidp wave, first
		compress
	save "${ukhls_out_work}\tmp_b`waveno'_indresp", replace
}

foreach w of global BHPSwaves {
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	use "${ukhls_out_work}\tmp_b`waveno'_indresp", clear
	isvar `all_vars'
	
	keep `r(varlist)'
	merge 1:1 pidp using "${ukhls_out_work}\tmp_xwavedat", nogen keep(1 3)
		save "${ukhls_out_work}\tmp_b`waveno'_indresp", replace
}
	
*** UKHLS
foreach w of global UKHLSwaves_bh {
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	use  "$ukhls_in/ukhls/`w'_indresp", clear
		rename `w'_* *
		// generate a variable which records the wave number + 18 
		gen wave=`waveno'+18
		gen uk_ver = "ukhls"
		local x=`waveno'+18
		sort pidp
		order pidp wave, first
		compress
		isvar `all_vars'

	keep `r(varlist)'
	save "${ukhls_out_work}\tmp_`x'_indresp", replace
}


**--------------------------------------
** Step 2: Append  
**--------------------------------------


*** BHPS

use "${ukhls_out_work}\tmp_b1_indresp", clear
foreach w of numlist 2/18 {	
		display "Appending wave: "`w'
			qui append using "${ukhls_out_work}\tmp_b`w'_indresp"
		display "After append of wave `w' - Vars:" c(k) " N: " _N
		display ""
	}
	
sort pidp wave
save "${ukhls_out}\uk_01_bhps.dta", replace


*** UKHLS

local last = ${uk_n}
foreach w of numlist 19/`last' {
		display "Appending wave: "`w'
			qui append using "${ukhls_out_work}\tmp_`w'_indresp"
		display "After append of wave `w' - Vars:" c(k) " N: " _N
		display ""
}

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
	use "$ukhls_in/bhps/b`w'_hhresp", clear  
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
	use  "$ukhls_in/ukhls/`w'_hhresp", clear
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
merge m:1 hidp wave using "${ukhls_out}\uk_01hh_bhps_hls.dta" , ///
		keep(1 3) nogen ///
		keepusing(nkids015   hhsize nkids_dv nch02_dv nch34_dv nch511_dv nch1215_dv ///
		ieqmoecd_dv fihhmnnet1_dv fihhmngrs_dv fihhmngrs1_dv)  
		

**--------------------------------------  
**  Save
**--------------------------------------

save "${ukhls_out}\uk_01.dta", replace

*/

* You can remove the large file if not needed
erase "${ukhls_out}\uk_01_bhps_hls.dta"

*
qui tab wave
display _newline(1) "   Total ->> Vars: " c(k) "; N: " _N "; Waves: " r(r)  

*____________________________________________________________________________
*--->	END	OF FILE <---