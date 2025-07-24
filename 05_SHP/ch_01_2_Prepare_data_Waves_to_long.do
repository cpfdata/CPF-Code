/*
===============================================================================
CPF Version 2.0 
SHP 
Syntax 01_2: Waves to long
===============================================================================
Purpose: Prepare and combine SHP panel data files across all waves
Author:  Konrad Turek
Date:    06.2025
Input:   shp_mp.dta files
Output:  ch_01_shpL.dta (long file)
===============================================================================
*/

* Log
capture log close 
log using "${shp_out}/ch_01_2_preparation.log", replace
display "Starting SHP data preparation at $S_TIME"

/*
================================================================================
SHP Data Preparation Description - ch_01_2_Prepare_data_Waves_to_long.do
================================================================================
The ch_01_2_Prepare_data_Waves_to_long.do file transforms SHP panel data 
from wide format (separate wave files) to long format (person-year observations), 
producing a harmonized dataset for CPF analysis.

Setup and Configuration:
• Generates wave number strings for dynamic processing
• Configures paths and wave parameters
• Installs required Stata packages (svmat2)

Step 1: Data Merging
--------------------
• Merges wave-specific files from SHP-Data-W1-W${shp_w}-STATA directories
• Combines shp_mp.dta (master file) with individual wave files (shp99_p_user, 
  shp00_p_user, etc.)
• Creates comprehensive wide-format dataset with all waves
• Output: shp_allw_wide.dta

Step 2: Variable Selection
--------------------------
• Keeps only selected variables for CPF analysis

Step 3: Variable Renaming
-------------------------
• Handles two types of variable naming patterns:
  - Variables with year inside name (e.g., p17e50 → p_e50_)
  - Variables with year at end (e.g., educat17 → educat_)
• Standardizes variable names for reshaping process
• Preserves variable labels for final dataset

Step 4: Reshape to Long Format
------------------------------
• Transforms wide format to long format using Stata's reshape command
• Creates person-year observations (idpers × wave structure)
• Recodes wave numbers to calendar years (1999, 2000, etc.)
• Maintains variable labels and value labels

Step 5: Add variables from additional files
------------------------------------------
• Merges time-invariant variables from shp_so.dta
• Adds parental information (education, occupation) and family background

Step 6: SAVE FINAL DATASET
--------------------------
• Creates final long-format dataset: ch_01_selected_long.dta
• Cleans temporary working files

================================================================================
*/



/*
================================================================================
Instructions for adding new variables at
three specific marked locations, supporting flexible dataset customization.
================================================================================
1. Adding new variables
- 	there are 3-4 places you have to put a name of a new variable from the wave-specific
	files you want to add
-	these places are indicated as below:
		*>>>
		*>>> NEW VARS [x*x; y*] 1/3:  
		*>>>
-	you must adjust formating of the name in each case 
-	x*x - variables with year inside of the name, e.g. p17e50 (3 places to add)
-	y*  - variables with year at the end of the name, e.g. educat17 (4 places to add)
-	please, verifiy if the resuls are correct, there are a few rules which help
	to check it
================================================================================
*/



***
// clear
// set more off
// clear matrix
// set maxvar 32767

*** NOTE: Must istall svmat2 (STB-56 dm79):
* net install  http://www.stata.com/stb/stb56/dm79



*################################################################################	
*#	
*#	Setup and Configuration:
*#	Generate strings of waves' numbers  
*#	
*################################################################################

local waves `" "00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "' 
local n=10
local last=${shp_w}
while `n'<= `last' {
    local i="`n'"
    local waves = `" `waves'"' + `" "`i'" "' 
	local ++n
}
global waves= `"`waves'"'
di $waves

*
local waves2 `" "00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "' 
local n=10
local last=${shp_w}-2
while `n'<= `last' {
    local i="`n'"
    local waves2 = `" `waves2'"' + `" "`i'" "' 
	local ++n
}
global waves2= `"`waves2'"'
di $waves2

*
global years =   "99"  + `" `waves2'"' 
di $years
 
*
local n=1
local last=${shp_w}
while `n'<= `last' {
    local i="`n'"
    local wavesn = `" `wavesn'"' + `" "`i'" "' 
	local ++n
}
global wavesn= `"`wavesn'"'
di $wavesn


*################################################################################	
*#	
*#	STEP 1: DATA MERGING
*#	
*################################################################################
**--------------------------------------
** Get a wide file with all variables 
**--------------------------------------

use "${shp_in}/SHP-Data-WA-STATA/shp_mp.dta", clear
merge 1:1 idpers using "${shp_in}/SHP-Data-W1-W${shp_w}-STATA/W1_1999/shp99_p_user", nogen keep(1 3) 
gen wave99=1999
local m=2  // local macro for a loop
foreach y in $waves2 {
	merge 1:1 idpers using "${shp_in}/SHP-Data-W1-W${shp_w}-STATA/W`m'_20`y'/shp`y'_p_user", nogen keep(1 3) 
	gen wave`y'=20`y'
	local m = `m' + 1
}
save "${shp_out_work}/shp_allw_wide.dta", replace



/**--------------------------------------
** Option: Rename single vars to get a long file 
**--------------------------------------
**** to adjust 2
global data "E:/2019_20 CRITEVENTS/02_Cntry_Data_Orgin/05_SHP/Data STATA/SHP-Data-W1-W19-STATA/_w1-w19 p" 

foreach year in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 {
 use idpers p`year'c44 p`year'd29 sex`year' using "$data/shp`year'_p_user", clear
 gen lifesat=p`year'c44 if p`year'c44>-1
 gen partner=p`year'd29==1 | p`year'd29==2 if p`year'd29>0
 drop p`year'c44 p`year'd29
 keep if lifesat<. & partner<.
 save "E:/2019_20 CRITEVENTS/temp/temp`year'", replace
}
 
* Create a long file
use "E:/2019_20 CRITEVENTS/temp/temp00", clear
foreach year in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 {
 append using "E:/2019_20 CRITEVENTS/temp/temp`year'"
}
*/
 

**--------------------------------------
** Open merged dataset
**-------------------------------------- 

*** Work on waves:
* use "${shp_out_work}/shp_allw_wide.dta", clear


disp "vars: " c(k) "   N: " _N


*################################################################################	
*#	
*#	STEP 2: VARIABLE SELECTION
*#	
*################################################################################

	*>>>
	*>>> NEW VARS [x*x; y*] 1/3: add variable here under the "keep" command (with * instead of year)
	*>>> e.g. P17E18 --> p*e18; IS3MAJ17 --> is3maj*
	*>>>

keep 			///
idpers* wave*  age*  idhous* birthy isced* educat* occupa*	pdate*	///
p*d110a p*d110b ownkid* civsta* p*c44 p*c01 p*c02 p*c19a		///
p*e03 p*e04 p*e05 p*e30		///
p*e14 p*e15a p*e15b p*e15 		///
wstat* p*w01 p*w03 p*w04 p*w05 p*w06 p*w613 p*w12 p*w13 p*w14		///
p*w610 p*w29 p*w291 p*w292 p*w293 p*w31 p*w32 p*w34a		///
p*w39 p*w42 p*w46 p*w85 p*w71a p*w74 p*w77 		///
p*w86a p*w87 p*w90 		///
p*w92 p*w93 p*w94 p*w229 p*w230 p*w615 p*w616 p*w228 p*w95 p*w96		///
p*w100 p*w101		///
is1maj* is2maj* is3maj* is4maj*		///
cspmaj* gldmaj* esecmj* tr1maj* caimaj* wr3maj*		///
noga2m* p*w608 p*w609		///
p*i01		///
p*i70 p*i80  p*i90 p*e18	 		 										///
i*ptotn i*ptotg i*empyn i*empyg i*indyn i*indyg i*wyg 		///
i*wyn i*empmg i*empmn i*indmg i*indmn		///
p*ql04 p*n35		///
x*c15 x*c16 x*c05 x*i04 x*w01 xis1ma* xis2ma* xis3ma* xis4ma* x*w02 x*w03 x*w04	 ///
p*d29 status* rnpx* ///
p*e16 nat_1_* reg_1_* p*d160 /// migration set indiv
p*r01 p*r04 //religion

*
disp "vars: " c(k) "   N: " _N

*** Save working version
 save "${shp_out_work}/01_selected_w.dta", replace




*################################################################################	
*#	
*#	STEP 3: VARIABLE RENAMING
*#	
*################################################################################

* use "${shp_out_work}/01_selected_w.dta", clear

**--------------------------------------
** Rename vars with 'year' inside of the name
**--------------------------------------

*** Check no of variables to rename 

	*>>>
	*>>> NEW VARS [x*x] 2/3 : the same format as in step 1 
	*>>> e.g. P17E18 --> p*e18
	*>>>
		
unab all:    ///
	p*d110a p*d110b p*c44 p*c01 p*c02 p*c19a		///
	p9*e05 p9*e14 p9*e15 					/// to distinghuish from pdate*
	p0*e03 p0*e04 p0*e05 	p0*e14 p0*e15 	/// to distinghuish from pdate*
	p1*e03 p1*e04 p1*e05 	p1*e14 p1*e15 	/// to distinghuish from pdate*
	p*e15a p*e15b p*e30		///
	p*w01 p*w03 p*w04 p*w05 p*w06 p*w613 p*w12 p*w13 p*w14		///
	p*w610 p*w29 p*w291 p*w292 p*w293 p*w31 p*w32 p*w34a		///
	p*w39 p*w42 p*w46 p*w85 p*w71a p*w74 p*w77 		///
	p*w86a p*w87 p*w90 		///
	p*w92 p*w93 p*w94 p*w229 p*w230 p*w615 p*w616 p*w228 p*w95 p*w96		///
	p*w100 p*w101		///
	p*w608 p*w609		///
	p*i01		///
	p*ql04 p*n35		///
	p*i70 p*i80  p*i90 	p*e18			///
	i*ptotn i*ptotg i*empyn i*empyg i*indyn i*indyg i*wyg 		///
	i*wyn i*empmg i*empmn i*indmg i*indmn		///
	x*c15 x*c16 x*c05 x*i04 x*w01  x*w02 x*w03 x*w04 ///
	p*d29 ///
	p*e16 p*d160 /// migration indiv
	p*r01 p*r04 //religion

	
local allcount : word count `all'
disp `allcount'

*** Rename 
** Short version adjusted to no of waves:
set matsize 2000
 foreach i in p i x   {
    local n=1
    foreach y in $years {
		rename (`i'`y'*) (`i'_*_`n'), r
		local ++n 
		}
}

/*
** Explicite version of rename - prints results in Stata ("dryrun" option), but requires to update sytax with new waves 
set matsize 2000
foreach i in p i x   {
rename (`i'99*  `i'00*  `i'01*  `i'02*  `i'03*  `i'04*  `i'05*  `i'06*  `i'07* `i'08*  `i'09*  `i'10*  `i'11*  `i'12*  `i'13*  `i'14*  `i'15*  `i'16*  `i'17* `i'18*   )   /// 
(`i'_*_1 `i'_*_2 `i'_*_3 `i'_*_4 `i'_*_5 `i'_*_6 `i'_*_7 `i'_*_8 `i'_*_9 `i'_*_10 `i'_*_11 `i'_*_12 `i'_*_13 `i'_*_14 `i'_*_15 `i'_*_16 `i'_*_17 `i'_*_18 `i'_*_19 `i'_*_20 ), dryrun 
rename (`i'99*  `i'00*  `i'01*  `i'02*  `i'03*  `i'04*  `i'05*  `i'06*  `i'07* `i'08*  `i'09*  `i'10*  `i'11*  `i'12*  `i'13*  `i'14*  `i'15*  `i'16*  `i'17* `i'18*   )   /// 
(`i'_*_1 `i'_*_2 `i'_*_3 `i'_*_4 `i'_*_5 `i'_*_6 `i'_*_7 `i'_*_8 `i'_*_9 `i'_*_10 `i'_*_11 `i'_*_12 `i'_*_13 `i'_*_14 `i'_*_15 `i'_*_16 `i'_*_17 `i'_*_18 `i'_*_19 `i'_*_20 ), r

	* If needed: saves results in matrix (2 new vars in dataset) and Excel file 
		local old=r(oldnames)
		local new=r(newnames)
		local count`i' : word count `old'
		mat old = J(`count`i'',1,0)
			matrix rowname old = `old'
			svmat2 old, rnames(old)  
			*mat list old
		mat new = J(`count`i'',1,0)
			matrix rowname new = `new'
			svmat2 new, rnames(new)  
			*mat list vars new
		drop old1 new1
		di  "`i': " `count`i''	// check no of variables renamed 
		local count=`count'+`count`i''
		*bro old new
		export excel old new using "${shp_out_work}/rename_report_`i'.xls" if old !="", firstrow(variables) replace
		drop old new
}
disp "Variables renamed >> p: " `countp' ";   i: " `counti' ";   x: " `countx' ";   ALL: "`count'
*
disp "Variables remaining: " c(k)-`count'
*/


  
**--------------------------------------
** Renaming vars with year at the end 
**--------------------------------------

*** Check no of variables to rename 

	*>>>
	*>>> NEW VARS [y*] 2a/3 : the same format as in step 1 
	*>>> e.g. IS3MAJ17 --> is3maj*
	*>>>

unab all:    ///
	idpers* wave*  age*  idhous*   isced* educat* occupa*	pdate* ownkid*	///
	civsta* wstat*  is1maj* is2maj* is3maj* is4maj*	cspmaj* gldmaj* esecmj* 	///
	tr1maj* caimaj* wr3maj*	noga2m*  xis1ma* xis2ma* xis3ma* xis4ma*		///
	status* rnpx* nat_1_* reg_1_* 

local allcount : word count `all'
disp `allcount'


	*>>>
	*>>> NEW VARS [y*] 2b/3 : remove year-suffix 
	*>>> e.g. IS3MAJ17 --> is3maj
	*>>>
rename statuscovid COVIDstatuscovid

local x=0
foreach name in  wave age idhous   isced educat occupa pdate ownkid ///
	civsta wstat is1maj is2maj is3maj is4maj cspmaj gldmaj esecmj 	///
	tr1maj caimaj wr3maj noga2m xis1ma xis2ma xis3ma xis4ma status rnpx nat_1_ reg_1_ ///
{
rename `name'* `name'#, renumber dryrun  // Reports results 
rename `name'* `name'_#, renumber r
unab namess: `name'*
local count : word count `namess'
local x=`x'+`count'
}
di "Renamed variables: " `x' "+ birthy & idpers"

 
*** Save working version
save "${shp_out_work}/01_selected_w_v2.dta", replace


*################################################################################	
*#	
*#	STEP 4: RESHAPE TO LONG FORMAT
*#	
*################################################################################

* use "${shp_out_work}/01_selected_w_v2.dta", clear 

disp "vars: " c(k) "   N: " _N

**--------------------------------------
** Reshape
**--------------------------------------
* Variables to reshape 

	*>>>
	*>>> NEW VARS [x*x;y*] 3/3: substitute year by "_" and add suffix "_"  
	*>>> e.g. P17E18 --> p_e18_; IS3MAJ17 --> is3maj_
	*>>>

*only include time-changing variables:	
local vars1 	///
		age_ idhous_ isced_ educat_ occupa_ pdate_ ownkid_ 				///
		civsta_ wstat_ is1maj_ is2maj_ is3maj_ is4maj_ cspmaj_ gldmaj_ esecmj_ 	///
		tr1maj_ caimaj_ wr3maj_ noga2m_ xis1ma_ xis2ma_ xis3ma_ xis4ma_ 	///
		status_ rnpx_ nat_1__ reg_1__ 

local vars2 	///
		p_d110a_ p_d110b_ p_c44_ p_c01_ p_c02_ p_c19a_					///
		p_e05_ 	p_e03_ p_e04_  p_e14_ p_e15_ 							/// 
		p_e15a_ p_e15b_ p_e30_											///
		p_w01_ p_w03_ p_w04_ p_w05_ p_w06_ p_w613_ p_w12_ p_w13_ p_w14_	///
		p_w610_ p_w29_ p_w291_ p_w292_ p_w293_ p_w31_ p_w32_ p_w34a_	///
		p_w39_ p_w42_ p_w46_ p_w85_ p_w71a_ p_w74_ p_w77_ 				///
		p_w86a_ p_w87_ p_w90_ 											///
		p_w92_ p_w93_ p_w94_ p_w229_ p_w230_ p_w615_ p_w616_ p_w228_ p_w95_ p_w96_	///
		p_w100_ p_w101_													///
		p_w608_ p_w609_													///
		p_i01_															///
		p_ql04_ p_n35_													///
		p_i70_ p_i80_ p_i90_  p_e18_									///
		i_ptotn_ i_ptotg_ i_empyn_ i_empyg_ i_indyn_ i_indyg_ i_wyg_ 	///
		i_wyn_ i_empmg_ i_empmn_ i_indmg_ i_indmn_						///
		x_c15_ x_c16_ x_c05_ x_i04_ x_w01_  x_w02_ x_w03_ x_w04_ 		///
		p_d29_ p_e16_ p_d160_ 											
		
local vars3	///
		p_r01_ p_r04_ 	// religion

	

			
		 *Capture variable labels
			foreach n in `vars1' `vars2' {
				capture local `n'label: variable label `n'${shp_w} 
			}
			* for religion separate besouse of rotating panel
			foreach n in `vars3' {
				local `n'label: variable label `n'20
						}
			
local vars_all `vars1' `vars2' `vars3'


		* Reshape
		reshape long  "`vars_all'" ///
		, i(idpers) j(wave $wavesn)

		* Redefine labels
			foreach n in `vars1' `vars2' {
				label variable `n' "``n'label'"
			}
			* for religion separate besouse of rotating panel
			foreach n in `vars3' {
				label variable `n' "``n'label'"
			}
			lab val p_r01_ P18R01 //note: new labels can be added in future waves
			lab val p_r04_ P18R04 //
			*


***	
order wave_*, first
drop wave_1-wave_19


*** recode wave
local year=1999
local wavesn=`" ${wavesn} "'
foreach x in `wavesn' {
	recode wave  (`x'=`year')
	local ++year 
}
/* the above equals to: 
recode wave  (1=1999) (2=2000) (3=2001) (4=2002) (5=2003) (6=2004) (7=2005) ///
	(8=2006) (9=2007) (10=2008) (11=2009) (12=2010) (13=2011) (14=2012) ///
	(15=2013) (16=2014) (17=2015) (18=2016) (19=2017)  (20=2018)
*/

*
drop if pdate==. & age==.
*
rename *_ *
*
order idpers wave idhous pdate  birthy  age, first
***
disp "vars: " c(k) "   N: " _N


*** Save working version
save "${shp_out_work}/01_selected_long.dta", replace



*################################################################################	
*#	
*#	STEP 5: ADD VARIABLES FROM ADDITIONAL FILES
*#	
*################################################################################

* use "${shp_out_work}/01_selected_long.dta", clear 

**--------------------------------------
** shp_so.dta - pid-constant vars about history and parents
**--------------------------------------
* parents education (p__o17) and other 
// rename pid idpers		  
merge m:1 idpers  using "${shp_in}/SHP-Data-WA-STATA/shp_so.dta" , ///
	keep(1 2 3) nogen  keepusing(	///
	p__o07 is1faj__ is4faj__ cspfaj__ gldfaj__ esecfa__ tr1faj__ caifaj__ wr3faj__ p__o17	p__o20 /// father
	p__o24 is1moj__ is4moj__ cspmoj__ gldmoj__ esecmo__ tr1moj__ caimoj__ wr3moj__ p__o34	p__o37 /// mother
	)
rename  idpers pid

*
disp "vars: " c(k) "   N: " _N



*################################################################################	
*#	
*#	STEP 6: SAVEFINAL DATASET 
*#	
*################################################################################

*** Save final version
save "${shp_out}/ch_01_selected_long.dta", replace

* Remove all temporary .dta files in the output work directory
local files : dir "${shp_out_work}" files "*.dta"
foreach f of local files {
    erase "${shp_out_work}/`f'"
}

* Log close
display "Ending SHP data preparation at $S_TIME"
log close

*____________________________________________________________________________
*--->	END	 <---








