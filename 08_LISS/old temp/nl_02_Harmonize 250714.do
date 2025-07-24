/*
===============================================================================
CPF Version 2.0 
LISS 
Syntax 02: Harmonize
===============================================================================
Purpose: Harmonize LISS panel data files across all waves
Author:  Konrad Turek
Date:    06.2025
Input:   nl_01.dta (combined person-household file)
Output:  nl_02.dta (harmonized dataset)
===============================================================================
*/
* Log
capture log close 
log using "${liss_out}/nl_02_harmonize.log", replace
display "Starting LISS data harmonization at $S_TIME"


*################################################################################
*# 
*# SETUP AND CONFIGURATION
*# 
*################################################################################

* Configuration
global start_year = 2007
global waves_n = "${liss_w}"
global data_path = "${liss_out}"
global output_path = "${liss_out}"

display "Configuration:"
display "  Start year: $start_year"
display "  The latest wave: $waves_n"
display "  Data path: $data_path"
display "  Output path: $output_path"



**--------------------------------------
** Open merged dataset
**-------------------------------------- 
use "${liss_out}/nl_01.dta", clear


qui tab wavey
display _newline(1) "   Total ->> Vars: " c(k) "; N: " _N "; Waves: " r(r)  


**--------------------------------------
** Common lables 
**-------------------------------------- 
lab def yesno 0 "[0] No" 1 "[1] Yes" ///
	-1 "-1 MV general" -2 "-2 Item non-response" ///
	-3 "-3 Does not apply" -8 "-8 Question not asked in survey", replace




*################################################################################
*#
*#	Technical Variables				
*#							
*################################################################################	

* gen intyear= // Already created

// Intmonth not applicable for LISS
rename intmonth intmonth_liss
gen intmonth=-3

 
* gen wavey=syear // Already created
egen wave = group(wavey)

*
gen country=8

*
rename nomem_encr pid
rename nohouse_encr hhid
sort pid wave


*** Responded in the survey
* positie - HH (=1) updates the background variables for him/herself and other HH members

gen respstat=1
	lab def respstat 	1 "Interviewed" 					///
						2 "Not interviewed (has values)" 	///
						3 "Not interviewed (no values)"
	lab val respstat respstat


* NOTE: many people have information in the LISS as HH members, before they become active respondents 
* So wave1st is not accurate here 

	bysort pid: egen wave1st = min(cond(respstat == 1, wave, .))
	
	
*################################################################################
*#
*#	Socio-demographic basic 				
*#							
*################################################################################
**--------------------------------------
** Demographic
**--------------------------------------
* age
gen age=intyear-gebjaar
recode age (15/17=2) (18/24=3) (25/34=4) (35/44=5) (45/54=6) (55/64=7) (65/max=8) (.=-1), gen(age7)



* Birth year
gen yborn=gebjaar
	lab var yborn "Birth year" 

* Gender
* There is also gender (self-identification) asked 
* but only from 2022 onwards and to part of the sample 
recode geslacht (1=0) (2=1) (3=2), gen(female)
	lab def female 0 "Male" 1 "Female" 2 "Other/No answer"
	lab val female female 
	lab var female "Gender" 
	

// **--------------------------------------
// ** Place of living (e.g. size/rural) NA
// **--------------------------------------
// * place
//
//  lab var place "Place of living"
// 	lab def place 1 "city" 2 "rural area"
// 	lab val place place 


*################################################################################
*#
*#	Education				
*#							
*################################################################################
**--------------------------------------
** Years 
**--------------------------------------

/* gen eduy=		

recode eduy (.=-1) (-2=-1)
lab var eduy "Education: years" */

/*
--- 
* Main variable:
cw005 - Highest level of education completed
	If OTHER in cw005 --> cw006 for clarification

* Supporting variables:
cw008 - What is the highest level of education that you have attended
	If OTHER in cw008 --> cw009 for clarification
Oplzon - Highest level of education irrespective of diploma (from HH box)

* Approach:
cw005 is prioritized. If no info (also in cw006), then oplzon and cw008 used 
*/


*** edu3

recode cw005 /// 
    (1/11=1) ///   
    (12/19=2) ///  
    (20/27=3) /// 
    (28 29 .=-1) ///    /* NA */
    (else=-1), gen(edu3a)

recode cw006 ///
    (1/3=1) ///    none, elementary, middle school -> Low
    (4/5=2) ///    secondary, post-secondary non-tertiary -> Medium
    (6/7=3) ///    tertiary, post-tertiary -> High
    (0 8 99=-1) ///  0, other, don't know -> Missing
    (else=-1), gen(edu3b)

recode oplzon ///
    (1=1) ///    /* primary school -> Low */
    (2=1) ///    /* vmbo -> Low */
    (3=2) ///    /* havo/vwo -> Medium */
    (4=2) ///    /* mbo -> Medium */
    (5=3) ///    /* hbo -> High */
    (6=3) ///    /* wo -> High */
    (8=-7) ///  Not competed - to fill with cw005
    (9=-8) ///  Not started - to fill with cw005
    (7=-9) ///  Other - to fill with cw005 
    (else=-1), gen(edu3c)

recode cw008 ///
	(1/10=1) ///
	(11/17=2) ///
	(18/25=3) ///
	(26/27 .=-1), gen(edu3d)


gen edu3=edu3a
replace edu3=edu3b if edu3==-1 & edu3b>0
replace edu3=edu3c if edu3==-1 & edu3c>0
replace edu3=edu3d if edu3==-1 & edu3d>0



	lab def edu3  1 "[0-2] Low" 2 "[3-4] Medium" 3 "[5-8] High" // 2 incl Vocational
	lab val edu3 edu3
	lab var edu3 "Education: 3 levels"


	
*** edu4
recode cw005 /// 
    (1/4=1) ///   
    (5/11=2) ///  
    (12/19=3) ///  
    (20/27=4) /// 
    (28 29 .=-1) ///    /* NA */
    (else=-1), gen(edu4a)

recode cw006 ///
    (1/2=1) ///    none, elementary -> Primary
    (3=2)   ///    middle school -> Secondary lower
    (4/5=3) ///    secondary, post-secondary non-tertiary -> Secondary upper
    (6/7=4) ///    tertiary, post-tertiary -> Tertiary
    (0 8 99=-1) ///
    (else=-1), gen(edu4b)


recode oplzon ///
    (1=1) ///    /* primary school -> Primary */
    (2=2) ///    /* vmbo -> Secondary lower */
    (3=3) ///    /* havo/vwo -> Secondary upper */
    (4=3) ///    /* mbo -> Secondary upper */
    (5=4) ///    /* hbo -> Tertiary */
    (6=4) ///    /* wo -> Tertiary */
    (8 9=1) ///    /* they are 15+, so 1 is assumed */
    (else=-1), gen(edu4c)
    
recode cw008 ///
	(1/3=1) ///
	(4/10=2) ///
	(11/17=3) ///
	(18/25=4) ///
	(26/27 .=-1), gen(edu4d)

	gen edu4=edu4a
	replace edu4=edu4b if edu4==-1 & edu4b>0
	replace edu4=edu4c if edu4==-1 & edu4c>0
	replace edu4=edu4d if edu4==-1 & edu4d>0

	
	lab def edu4  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" 4 "[5-8] Tertiary" 
	lab val edu4 edu4
	lab var edu4 "Education: 4 levels"



	
*** edu5
recode cw005 /// 
    (1/4=1) ///   
    (5/11=2) ///  
    (12/19=3) ///  
    (20/23 25=4) /// 
    (24 26 27 =5) /// 
    (28 29 .=-1) ///    /* NA */
    (else=-1), gen(edu5a)

recode cw006 ///
    (1/2=1) ///   // none, elementary -> Primary
    (3=2)   ///   // middle school -> Secondary lower
    (4/5=3)   ///   // secondary -> Secondary upper
    (6/7=5) ///   // tertiary, post-tertiary -> Tertiary upper
    (0 8 99=-1) ///
    (else=-1), gen(edu5b)


recode oplzon ///
    (1=1) ///    /* primary school -> Primary */
    (2=2) ///    /* vmbo -> Secondary lower */
    (3=3) ///    /* havo/vwo -> Secondary upper */
    (4=3) ///    /* mbo -> Secondary upper */
    (5=4) ///    /* hbo -> Tertiary lower */
    (6=5) ///    /* wo -> Tertiary upper */
    (8 9=1) ///    /* they are 15+, so 1 is assumed */
    (else=-1), gen(edu5c)


recode cw008 ///
	(1/3=1) ///
	(4/10=2) ///
	(11/17=3) ///
	(18/23=4) ///
	(24/25=5) ///
	(26/27 .=-1), gen(edu5d)


	gen edu5=edu5a
	replace edu5=edu5b if edu5==-1 & edu5b>0
	replace edu5=edu5c if edu5==-1 & edu5c>0
	replace edu5=edu5d if edu5==-1 & edu5d>0



	lab def edu5  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" ///
				  4 "[5-6] Tertiary lower(bachelore)"  ///
				  5 "[7-8] Tertiary upper (master/doctoral)"
				  
	lab val edu5 edu5
	lab var edu5 "Education: 5 levels"

	

* Alternative version:
* edu5v2 based on cw005
recode cw005 /// 
    (1/4=1) ///   
    (5/11=2) ///  
    (12/19=3) ///  
    (20/26 25=4) /// 
    (27 =5) /// 
    (28 29 .=-1) ///    /* NA */
    (else=-1), gen(edu5v2a)

recode cw006 ///
    (1/2=1) ///    none, elementary -> Primary
    (3=2)   ///    middle school -> Secondary lower
    (4/5=3)   /// secondary -> Secondary upper
    (6=4) ///    post-secondary non-tertiary, tertiary -> Tertiary first)
    (7=5) ///    tertiary, post-tertiary -> Tertiary upper
    (0 8 99=-1) ///
    (else=-1), gen(edu5v2b)


recode cw008 ///
	(1/3=1) ///
	(4/10=2) ///
	(11/17=3) ///
	(18/24=4) ///
	(25=5) ///
	(26/28 .=-1), gen(edu5v2c)


	gen edu5v2=edu5
	replace edu5v2=4 if edu5v2>=4 & edu5v2<.
	replace edu5v2=edu5v2a if  edu5v2a>=4
	replace edu5v2=edu5v2b if  edu5v2b>=4 & (edu5v2==. | edu5v2==-1)
	replace edu5v2=edu5v2c if  edu5v2c>=4 & (edu5v2==. | edu5v2==-1)
 

	lab def edu5v2  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
					3 "[3-4] Secondary upper" ///
					4 "[5-7] Tertiary first(bachelore/master)"  ///
					5 "[8] Tertiary second (doctoral)"
	
	lab val edu5v2 edu5v2
	lab var edu5v2 "Education: 5 levels v2" 

drop edu3a edu3b edu3c edu3d edu4a edu4b edu4c edu4d edu5a edu5b edu5c edu5d edu5v2a edu5v2b edu5v2c

*################################################################################
*#
*#	Family and relationships	
*#							
*################################################################################		

**--------------------------------------
** Formal marital status 	 
**--------------------------------------
* Formal marital status
* Only formal marital status included, no info on having/living with partner
* Never married include singles  

recode  burgstat  (1=1)(5=2)(4=3)(3=4)(2=5)	///
				(.=-1), gen(mlstat5)

	lab var mlstat5 "Formal marital status [5]"
	lab def mlstat5				///
	1	"Married/registered"	///
	2	"Never married" 		///
	3	"Widowed" 				///
	4	"Divorced" 				///
	5	"Separated" 			///
	-1 "-1 MV general" -2 "-2 Item non-response" ///
	-3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	lab val mlstat5 mlstat5


**--------------------------------------
** Primary partnership status  (from CNEF) 	 
**--------------------------------------
* LESS USEFUL FOR LISS!
* Approach based on CNEF 
// Cat 1 prioritized 
// Cat 2 not precise - mixes sinlges without partners & those with partners but not living together 

recode  burgstat  (1=1)(5=2)(4=3)(3=4)(2=5)	///
				(.=-1), gen(marstat5)

replace marstat5=1 if cf025==1
* replace marstat5=2 if cf024==2 // not a precise approach for LISS


	lab var marstat5 "Primary partnership status [5]"
	lab def marstat5				///
	1	"Married or Living with partner"	///
	2	"Single" 				///
	3	"Widowed" 				///
	4	"Divorced" 				///
	5	"Separated" 			///
	-1 "-1 MV general" -2 "-2 Item non-response" ///
	-3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	lab val marstat5 marstat5
		
		

**--------------------------------------
** Partner
**--------------------------------------

	recode cf024 (2=0)(1=1), gen(haspart)
	recode cf025 (2=0)(1=1), gen(livpart)
	replace livpart=0 if haspart==0
 		lab var haspart "Has a partner"
		lab var livpart "Living together with partner"
		lab val haspart livpart  yesno


**--------------------------------------
** Partnership living-status 	 
**--------------------------------------
* Includes inforamtion on marital status and whether living with partner in HH 
* Note: many cases with marital info have no info if living with a partner 

gen parstat6 = .
replace parstat6 = 6 if burgstat == 2 & (cf024==2 | cf025==2)      // Separated, No P
replace parstat6 = 5 if burgstat == 3 & (cf024==2 | cf025==2)     // Divorced, No P
replace parstat6 = 4 if burgstat == 4 & (cf024==2 | cf025==2)     // Widowed, No P
replace parstat6 = 3 if burgstat == 5 & (cf024==2 | cf025==2)     // Single, No P
replace parstat6 = 2 if burgstat != 1 & cf024 == 1 & cf025 == 1  // Cohabiting (Not married, Living with P)
replace parstat6 = 1 if burgstat == 1 & cf024 == 1 & cf025 == 1  // Married/registered, with P


* Filling MV for some cases
replace parstat6 = 6 if parstat6 ==. & mlstat5==1 & livpart ==0 & haspart==0 // Separated: married but with no partner 
* replace parstat6 = 6 if parstat6 ==. & mlstat5==1 & livpart ==0 & haspart==1 // married, has a partner, but not in HH 

	lab var parstat6 "Partnership living-status [6]"
	lab def parstat6				///
	1	"Married/registered, with P"	///
	2	"Cohabiting (Not married, Living with P)"				///
	3	"Single, No P" 				///
	4	"Widowed, No P" 				///
	5	"Divorced, No P" 			///
	6	"Separated, No P" 			///
	-1 "-1 MV general" -2 "-2 Item non-response" ///
	-3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	lab val parstat6 parstat6
	
	
**--------------------------------------
** Binary specific current partnership status (yes/no)
**--------------------------------------
*** Specific current marital statuses, but independent (without prioritization) 
* No mater if currently living with a partner

// 		lab var cmarr   "Currently: married"
// 		lab var cwidow 	"Currently: widowed (no mater partner)"
// 		lab var cdivor  "Currently: divorced (no mater partner)"
// 		lab var csepar  "Currently: separated (no mater partner)"
// 		lab val cmarr cwidow cdivor csepar yesno
		


*** Single
// 		lab var csing "Single: not married and no partner"
// 		lab val csing yesno
								
*** Never married 
recode burgstat (5=1)(1/4=0)(.=-1), gen(nvmarr)

		lab var nvmarr "Never married"
		lab val nvmarr yesno					
		
		
*** Widowed
recode burgstat (4=1) (1 2 3 5=0)(.=-1), gen(widow)

		lab var widow "Widowed (current status)"
		lab val widow yesno	
		
*** Divorced
recode burgstat (3=1) (1 2 4 5=0)(.=-1), gen(divor)

		lab var divor "Divorced (current status)"
		lab val divor yesno	


*** Separated
recode burgstat (2=1) (1 3 4 5=0)(.=-1), gen(separ)

		lab var separ "Separated (current status)"
		lab val separ yesno	

							


**--------------------------------------
** Children , people in HH
**--------------------------------------
*  
/*Until wave 8: 
cf035 (Have you had any children?)
cf036 (how many chidlren (incl deceased)), 
cf037 - cf051 (birth year). 

From wave 8: 
cf454 (Have you had any children?)
cf455 (how many chidlren (incl deceased)), 
cf456 - cf470 (birthyear)

All waves: 
cf083 – cf097 (living in household/independently)

aantalki - Number of living-at-home children, age not specified

*/

*** Prepar vars
recode cf035 cf454 (2=0)
* Set value ZERO kids if no kids at all 
replace cf036=0 if cf035==0 & cf036==.
replace cf455=0 if cf454==0 & cf455==.

* Set value YES/NO kids (if number of kids provided)
replace cf035=1 if cf036>0 & cf036<. & cf035==.
replace cf035=0 if cf036==0 & cf035==.
replace cf036=. if cf035==1 & cf036==0 // additional correction 
replace cf455=. if cf454==1 & cf455==0 // additional correction 

* Set unknown number of children, but has some (-9)
replace cf036=-9 if cf035==1 & cf036==.
replace cf455=-9 if cf454==1 & cf455==.

 
*** Combine vars 
gen temp_anykids = cf035
replace temp_anykids = cf454 if wavey >=2015
 
gen temp_nkids = cf036
replace temp_nkids = cf455 if wavey >=2015

*** Carry forward info about kids if missing
bysort pid (wavey): replace temp_anykids=temp_anykids[_n-1] if temp_anykids==. & temp_anykids[_n-1]>=0 & temp_anykids[_n-1]<. 
bysort pid (wavey): replace temp_nkids=temp_nkids[_n-1] if temp_nkids==. & temp_nkids[_n-1]>=0 & temp_nkids[_n-1]<.  
replace temp_nkids=-9 if temp_anykids==1 & temp_nkids==.

*** Carry forward info about kids if have kids (minor correction)
bysort pid (wavey): replace temp_anykids=1 if temp_anykids[_n-1]==1 




*** How many chidlren in total (incl deceased)
gen kidsn_all = temp_nkids 
recode temp_anykids (.=-1), gen(kids_any) //Note: not fully consistent with aantalki

 	
	lab var kids_any  "Has any children"
	lab val kids_any   yesno
	lab var kidsn_all  "Number Of Children Ever Had" 
	lab def kidsn_all  -9 "Yes, but unknown number of kind"
	lab val kidsn_all kidsn_all

drop temp_*

****** Children in HH by age 
/*Until wave 8: cf037 - cf051 (birth year). 
From wave 8: cf456 - cf470 (birthyear)
All waves: cf083 – cf097 (living in household/independently)
*/

*** Generate 15 kids-related variables (the same for both sets of vars)
* birth year
local n=1
foreach var of varlist cf037-cf051 {
	gen kidbirthy`n' = `var'
	local n = `n' + 1
}
local n=1
foreach var of varlist cf456-cf470 {
	replace kidbirthy`n' = `var' if wavey>=2015
	local n = `n' + 1
}

* living at home?
local n=1
foreach var of varlist cf083-cf097 {
	gen kidhh`n' = `var'
	local n = `n' + 1
}


*** Carry forward info about kids birthyear if missing in following waves 
foreach n of numlist 1/15 {
bysort pid (wavey): replace kidbirthy`n'=kidbirthy`n'[_n-1] if kidbirthy`n'==. & kidbirthy`n'[_n-1]>0 & kidbirthy`n'[_n-1]<. 
} 

*** Fill MV=living_at_home if age of kid<12 and earlier/next are also like this 
foreach n of numlist 1/15 {
bysort pid (wavey): replace kidhh`n'=1 if kidhh`n'==. & kidhh`n'[_n-1]==1 & kidhh`n'[_n+1]==1 
} 


*** Calculate current age of kids 
foreach n of numlist 1/15 {
	gen kidage`n' = intyear-kidbirthy`n'  
}
* correct if no precision
recode kidage* (-1=0)


*** Current age only if living at HH 
foreach n of numlist 1/15 {
	gen kidhhage`n' = kidage`n' if kidhh`n'==1
}



*** Count children in HH by age groups (only if living in HH)
//Note: not fully consistent with aantalki

egen kidsn_hh_02 = anycount(kidhhage1-kidhhage15), values(0/2) 
egen kidsn_hh_34 = anycount(kidhhage1-kidhhage15), values(3/4) 
egen kidsn_hh_04 = anycount(kidhhage1-kidhhage15), values(0/4) 
egen kidsn_hh_510 = anycount(kidhhage1-kidhhage15), values(5/10) 

egen kidsn_hh17 = anycount(kidhhage1-kidhhage15), values(0/17) 
egen kidsn_hh15 = anycount(kidhhage1-kidhhage15), values(0/15) 
egen kidsn_hh18 = anycount(kidhhage1-kidhhage15), values(0/18) 


//  lab var kidsn_18   "Number Of Children <18 y.o." 
// 	lab var kidsn_15   "Number Of Children <15 y.o." 
 	lab var kidsn_hh17   "Number of Children in HH aged 0-17"
 	lab var kidsn_hh_02   "Number of Children in HH aged 0-2"
 	lab var kidsn_hh_34   "Number of Children in HH aged 3-4"
	lab var kidsn_hh_04   "Number of Children in HH aged 0-4"
	lab var kidsn_hh_510  "Number of Children in HH aged 5-10"

*
recode kidsn_hh_04 (0=0)(1/20=1), gen(kids_hh_04)
	lab var kids_hh_04   "Any children in HH aged 0-4?"
	lab val kids_hh_04   yesno


*
drop kidbirthy* kidhh* kidage* kidhhage*

**--------------------------------------
** People in HH F14
**--------------------------------------
clonevar nphh= aantalhh

	lab var nphh   "Number of People in HH" 



*################################################################################
*#
*#	Labour market situation: working, occupation, industry, size	
*#							
*################################################################################
 
**--------------------------------------
** Currently working 
**--------------------------------------
* Check if any of the employment status variables are 1
gen empl_info = 0
foreach var of varlist cw088-cw102 {
    replace empl_info = 1 if `var' == 1
}
* Set to missing (-1) if all employment status variables are missing
egen all_missing = rowmiss(cw088-cw102)
replace empl_info = -1 if all_missing == 15
drop all_missing


*  
recode empl_info(0 1=0)(-1=.), gen(work_d)
replace work_d=1 if cw088==1|cw102==1 // main info - from core questionaire 
replace work_d=cw001 if work_d==. & cw001<. // fill MV based on hh box info 
	
	* lab var work_py "Working: last year (based on hours)"	
	lab var work_d 	"Working: currently (based on selfrep)"
	lab val work_d yesno

*** additional variable - includes all info about emplyoment status 
gen working=work_d
replace working=1 if belbezig==1 & working==. // Paid employment
replace working=1 if belbezig==2 & working==. // Works or assists in family business
replace working=1 if belbezig==3 & working==. // Autonomous professional, freelancer, or self-employed
replace working=0 if belbezig>=4 & belbezig<=14 & working==.  // all non working situations 



**--------------------------------------
** Occupation ISCO  
**--------------------------------------
// ssc install iscogen
// numlabel cw20m611, add

/* 
Var cw611 available only from wave 13 (2020)!
*/

*** isco88_4
clonevar isco08_4 = cw611  
recode isco08_4 (-9=-1) 
replace  isco08_4 =-2 if wavey<2020

capture lab copy cw20m611 isco08_4
capture lab def isco08_4 -1 "[-1] MV general"					///
				-2 "[-2] Not asked"	 , modify
capture lab val isco08_4 isco08_4


*** Recode isco88 into 08 (4 digits) 
* iscogen isco88_4= isco88(isco08_4) ,  from(isco08)

*** isco_1 isco_2
lab def isco_1															///
           0 "[0] Armed forces occupations" 							///
           1 "[1] Managers"												///
           2 "[2] Professionals" 										///
           3 "[3] Technicians and associate professionals" 				///
           4 "[4] Clerical support workers" 							///
           5 "[5] Services and sales workers" 							///
           6 "[6] Skilled agricultural, forestry and fishery workers" 	///
           7 "[7] Craft and related trades workers" 					///
           8 "[8] Plant and machine operators and assemblers" 			///
           9 "[9] Elementary occupations"   							///
		  -1 "[-1] MV general"				 							///
		  -3 "[-3] Does not apply"
		  
lab def isco_2															///
		0 "[0] Armed forces occupations"     ///
		1 "[1] Commissioned armed forces officers"     ///
		2 "[2] Non-commissioned armed forces officers"     ///
		3 "[3] Armed forces occupations, other ranks"     ///
		10 "[10] Managers"     ///
		11 "[11] Chief executives, senior officials and legislators"     ///
		12 "[12] Administrative and commercial managers"     ///
		13 "[13] Production and specialized services managers"     ///
		14 "[14] Hospitality, retail and other services managers"     ///
		20 "[20] Professionals"     ///
		21 "[21] Science and engineering professionals"     ///
		22 "[22] Health professionals"     ///
		23 "[23] Teaching professionals"     ///
		24 "[24] Business and administration professionals"     ///
		25 "[25] Information and communications technology professionals"     ///
		26 "[26] Legal, social and cultural professionals"     ///
		30 "[30] Technicians and associate professionals"     ///
		31 "[31] Science and engineering associate professionals"     ///
		32 "[32] Health associate professionals"     ///
		33 "[33] Business and administration associate professionals"     ///
		34 "[34] Legal, social, cultural and related associate professionals"     ///
		35 "[35] Information and communications technicians"     ///
		40 "[40] Clerical support workers"     ///
		41 "[41] General and keyboard clerks"     ///
		42 "[42] Customer services clerks"     ///
		43 "[43] Numerical and material recording clerks"     ///
		44 "[44] Other clerical support workers"     ///
		50 "[50] Services and sales workers"     ///
		51 "[51] Personal services workers"     ///
		52 "[52] Sales workers"     ///
		53 "[53] Personal care workers"     ///
		54 "[54] Protective services workers"     ///
		60 "[60] Skilled agricultural, forestry and fishery workers"     ///
		61 "[61] Market-oriented skilled agricultural workers"     ///
		62 "[62] Market-oriented skilled forestry, fishery and hunting workers"     ///
		63 "[63] Subsistence farmers, fishers, hunters and gatherers"     ///
		70 "[70] Craft and related trades workers"     ///
		71 "[71] Building and related trades workers (excluding electricians)"     ///
		72 "[72] Metal, machinery and related trades workers"     ///
		73 "[73] Handicraft and printing workers"     ///
		74 "[74] Electrical and electronics trades workers"     ///
		75 "[75] Food processing, woodworking, garment and other craft and related trades workers"     ///
		80 "[80] Plant and machine operators and assemblers"     ///
		81 "[81] Stationary plant and machine operators"     ///
		82 "[82] Assemblers"     ///
		83 "[83] Drivers and mobile plant operators"     ///
		90 "[90] Elementary occupations"     ///
		91 "[91] Cleaners and helpers"     ///
		92 "[92] Agricultural, forestry and fishery labourers"     ///
		93 "[93] Labourers in mining, construction, manufacturing and transport"     ///
		94 "[94] Food preparation assistants"     ///
		95 "[95] Street and related sales and services workers"     ///
		96 "[96] Refuse workers and other elementary workers"     ///
		-1 "[-1] MV general"				 							///
		-3 "[-3] Does not apply"	  
		  
*		  
generate isco_1 = cond(isco08_4 > 100, int(isco08_4/1000), isco08_4)
generate isco_2 = cond(isco08_4 > 100, int(isco08_4/100), isco08_4)

	lab val isco_1 isco_1
	lab var isco_1 "Occupation: ISCO-1digit"

	lab val isco_2 isco_2
	lab var isco_2 "Occupation: ISCO-2digit"




**--------------------------------------
** Industry 
**--------------------------------------
*  

* Major groups 
recode cw402 (1/5=1)(6/10=2)(11/14=3)(15=4) (-9=-1), gen(indust1)

lab def indust1											///
           1 "[1] Production, Construction, Heavy Ind"	///
           2 "[2] Trade and Services"					///
		   3 "[3] Public services"						///
		   4 "[4] Other"								///
		  -1 "[-1] MV general"							///
		  -3 "[-3] Does not apply"	  

		  
	lab val indust1 indust1		  
	lab var indust1 "Industry (major groups)" 
	
* Submajor groups 
// Not precise for LISS
recode cw402 (1=1) (2=3) (3=4) (4=2) (5=5) (6=6) (7=9) (8=7) (9=8) (10/14=9) ///
             (15=10) (-9=-1), gen(indust2)

lab def indust2						///
           1 "[1] Agriculture"		///
           2 "[2] Energy"			///
           3 "[3] Mining"			///
           4 "[4] Manufacturing"	///
           5 "[5] Construction"		///
           6 "[6] Trade"			///
           7 "[7] Transport"		///
           8 "[8] Bank,Insurance"	///
           9 "[9] Services"			///
          10 "[10] Other"			///
		  -1 "[-1] MV general"		///
		  -3 "[-3] Does not apply"	  

	lab val indust2 indust2		  
	lab var indust2 "Industry (submajor groups/1 dig)" 
	
* Minor groups 
// 1 & 2 not possible to distinguish 
recode cw402 (1=1) (2=3) (3=4) (4=5) (5=6) (6=7) (7=8) (8=9) (9=10) ///
(10=11) (11=12) (12=13) (13=14) (14=15) (15=18) (-9=-1), gen(indust3)
			  
lab def indust3											///
           1 "[1] Agriculture, hunting, forestry"	///
           2 "[2] Fishing and fish farming"	///
           3 "[3] Mining and quarrying"	///
           4 "[4] Manufacturing"	///
           5 "[5] Electricity, gas and water supply"	///
           6 "[6] Construction"	///
           7 "[7] Wholesale,retail; repair; other services"	///
           8 "[8] Hotels and restaurants"	///
           9 "[9] Transport, storage and communication"	///
          10 "[10] Financial intermediation; insurance"	///
          11 "[11] Real estate; renting; computer; research"	///
          12 "[12] Public admin,national defence; compulsory social security"	///
          13 "[13] Education"	///
          14 "[14] Health and social work"	///
          15 "[15] Other community, social and personal service activities"	///
          16 "[16] Private households with employed persons"	///
          17 "[17] Extra-territorial organizations and bodies"	///
		  18 "[18] Other"				///
		  -1 "[-1] MV general"							///
		  -3 "[-3] Does not apply"	  
		  	  
	lab val indust3 indust3		  
	lab var indust3 "Industry (minor groups)"   
		  
		  
**--------------------------------------
** Public sector
**--------------------------------------
*

recode cw122 (1=1) (2=0) , gen(public)

	lab val public yesno
	lab var public "Public sector"

**--------------------------------------
** Size of organization	 
**--------------------------------------
/*
How many people in the branch/location where you mainly work. 
Additional information from: 
cw121 - self-employed, independent professional
cw125 - self-employed, freelancer
*/

*** size
recode cw408 (999999=-1), gen(size_a)

replace size_a=0 if cw408==1 & (cw121==5|cw121==6) // 5	self-employed/freelancer; 6	independent professional
replace size_a=0 if cw408==1 & (cw125==1|cw125==3) // 1 self-employed, 3 freelancer

* f0r 2011+
recode cw528 (-9 -8=-1)	, gen(size_b)

replace size_b=0 if (cw528==0|cw528==1) & (cw121==5|cw121==6) // 5	self-employed/freelancer; 6	independent professional
replace size_b=0 if (cw528==0|cw528==1) & (cw125==1|cw125==3) // 1 self-employed, 3 freelancer

*
gen size=size_a
replace size=size_b if wavey>=2011

drop size_a size_b


*** size4
* before 2011
recode cw408 (1/19=1)(20/199=2)(200/1999=3)(2000/100000=4)	///
		(999999=-1)	///
		, gen(size4a)

replace size4a=0 if cw408==1 & (cw121==5|cw121==6) // 5	self-employed/freelancer; 6	independent professional
replace size4a=0 if cw408==1 & (cw125==1|cw125==3) // 1 self-employed, 3 freelancer

* f0r 2011+
recode cw528 (0=0)(1/19=1)(20/199=2)(200/1999=3)(2000/100000=4)	///
	(-9 -8=-1)	///
	, gen(size4b)

replace size4b=0 if (cw528==0|cw528==1) & (cw121==5|cw121==6) // 5	self-employed/freelancer; 6	independent professional
replace size4b=0 if (cw528==0|cw528==1) & (cw125==1|cw125==3) // 1 self-employed, 3 freelancer

*
gen size4=size4a
replace size4=size4b if wavey>=2011

*
	lab var size4 "Size of organization [4]"
	lab def size4 1 "<20" 2 "20-199" 3 "200-1999" 4 "2000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size4 size4
 
drop size4a size4b


*** size5
recode cw408 (1/9=1)(10/49=2)(50/99=3)(100/999=4) (1000/100000=5)	///
		(999999=-1)	///
		, gen(size5a)

replace size5a=0 if cw408==1 & (cw121==5|cw121==6) // 5	self-employed/freelancer; 6	independent professional
replace size5a=0 if cw408==1 & (cw125==1|cw125==3) // 1 self-employed, 3 freelancer

* f0r 2011+
recode cw528 (0=0)(1/9=1)(10/49=2)(50/99=3)(100/999=4) (1000/100000=5)	///
	(-9 -8=-1)	///
	, gen(size5b)

replace size5b=0 if (cw528==0|cw528==1) & (cw121==5|cw121==6) // 5	self-employed/freelancer; 6	independent professional
replace size5b=0 if (cw528==0|cw528==1) & (cw125==1|cw125==3) // 1 self-employed, 3 freelancer

*
gen size5=size5a
replace size5=size5b if wavey>=2011

*
 	lab var size5 "Size of organization [5]"
	lab def size5 1 "<10" 2 "10-49" 3 "50-99" 4 "100-999" 5 "1000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5 size5

drop size5a size5b


*** size5b
recode cw408 (1/9=1)(10/49=2)(50/99=3)(100/499=4) (500/100000=5)	///
		(999999=-1)	///
		, gen(size5b1)

replace size5b1=0 if cw408==1 & (cw121==5|cw121==6) // 5	self-employed/freelancer; 6	independent professional
replace size5b1=0 if cw408==1 & (cw125==1|cw125==3) // 1 self-employed, 3 freelancer

* f0r 2011+
recode cw528 (0=0)(1/9=1)(10/49=2)(50/99=3)(100/499=4) (500/100000=5)	///
	(-9 -8=-1)	///
	, gen(size5b2)

replace size5b2=0 if (cw528==0|cw528==1) & (cw121==5|cw121==6) // 5	self-employed/freelancer; 6	independent professional
replace size5b2=0 if (cw528==0|cw528==1) & (cw125==1|cw125==3) // 1 self-employed, 3 freelancer

*
gen size5b=size5b1
replace size5b=size5b2 if wavey>=2011

 	lab var size5b "Size of organization [5b]"
	lab def size5b 1 "<10" 2 "10-49" 3 "50-99" 4 "100-499" 5 "500+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5b size5b	

drop size5b1 size5b2


*################################################################################
*#
*#	Labour market situation: hours worked, full/part time, parental leave
*#							
*################################################################################

**--------------------------------------
** hours conracted
**--------------------------------------
* cw126 - How many hours per week are you employed in your job, according to your employment contract]?
* cw144 - How many hours per week do you usually work in this sideline job or second work setting? 
* 	Whether extra hours are paid or not is irrelevant. 
*	If you [have / had] multiple sideline jobs, please indicate the total amount of hours.
* For on-call employee / self-employed/freelancer / independent professional, actual hours from the main job 

gen whweek_ctr=cw126
replace whweek_ctr=cw127 if whweek_ctr==. & (cw121==3|cw121==5|cw121==6) // on-call employee / self-employed/freelancer / independent professional
replace whweek_ctr=. if working==0
	lab var whweek_ctr "Work hours per week: conracted"


**--------------------------------------
** hours worked 
**--------------------------------------
* Main job + side job 
* cw127 - How many hours per week do you work on average?
* cw144 - How many hours per week do you usually work in this sideline job or second work setting? 

gen whweek= cw127
replace whweek=cw127+cw144 if cw144 >0 & cw144 <.
replace whweek=. if working==0

gen whyear= whweek*12*4.3
gen whmonth=whweek*4.3
  
//  lab var whday "Work hours per day: worked"
	lab var whweek "Work hours per week: worked"
	lab var whmonth "Work hours per month: worked"
	lab var whyear "Work hours per year: worked"
 
 
  
**--------------------------------------
** full/part time
**--------------------------------------
*  --> moved after emplst5


**--------------------------------------
** overtime working  
**--------------------------------------
* 

**--------------------------------------
** parental leave   
**--------------------------------------
recode working (0 1=0), gen(mater)
replace mater=1 if cw440==1
 
 	lab val mater yesno
 	lab var mater "Parental leave "	
	


*################################################################################
*#
*#	Currently unemployed 	
*#							
*################################################################################


**--------------------------------------
** Unempl: registered  
**--------------------------------------
*  
/*recode  , gen(un_reg)
lab val un_reg yesno
lab var un_reg "Unemployed: registered"*/
 
**--------------------------------------
** Unempl: reason   
**--------------------------------------
 
 

**--------------------------------------
** Unempl: actively looking for work 
**--------------------------------------
/*
cw091 	I am looking for work following the loss of my previous job
cw093	I am a first-time job seeker
cw094	I am seeking work following a lengthy interruption
*/

recode working (0 1=0), gen(un_act)
replace un_act=1 if (cw091==1|cw093==1|cw094==1) & working==0
 
lab val un_act yesno
lab var un_act "Unemployed: actively looking for work "

*################################################################################
*#
*#	Self-empl / Entrepreneur	
*#							
*################################################################################
**--------------------------------------
** Self-employed	 
**--------------------------------------
/* Note: Only for currently working 
cw121 - 5 self-employed/freelancer; 6	independent professional
cw125 - 1 self-employed, 2 family business, 3 freelancer
*/
 
*** v1 - all without Family Business
*
recode working (0 1=0), gen(selfemp_v1)

replace selfemp_v1=1 if cw121==5|cw121==6 // 5	self-employed/freelancer; 6	independent professional
replace selfemp_v1=0 if cw125==2 // 2 family business

*** v2 - with Family Business
recode working (0 1=0), gen(selfemp)
replace selfemp=1 if cw121==5|cw121==6 // 5	self-employed/freelancer; 6	independent professional

/**** v3 - based on income from self-empl
gen 	selfemp_v3=1  */
***
	lab val selfemp_v1 selfemp   yesno
	lab var selfemp_v1 "Self-employed 1: all without Family Business"
	lab var selfemp "Self-employed 2: all with Family Business"
	* lab var selfemp_v3 "Self-employed 3: based on income from self-empl"

/*
**--------------------------------------
** Entrepreneur 
**--------------------------------------
*** v1 - Not farmer; including info about employees 
 

  entrep= 
 	
	lab val entrep yesno
	lab var entrep "Entrepreneur (not farmer; has employees)"

  entrep2= 
	lab val entrep2 yesno
	lab var entrep2 "Entrepreneur (incl. farmers; has employees)"
	
**--------------------------------------
** Number of employees 
**--------------------------------------
recode   (0 1=-1), gen(nempl)
 
	lab def nempl 1 "1-9" 2 "10+" 	///
		-1 "-1 MV general" -2 "-2 Item non-response" 	///
		-3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	lab val nempl nempl
	lab var nempl "Number of employees (entrepreneurs)"
*/


*################################################################################
*#
*#	Retired					
*#							
*################################################################################

**--------------------------------------
** Fully retired - identification
**--------------------------------------
*   
* Criteria for 1
/*
belbezig 9	Is pensioner ([voluntary] early retirement, old age pension scheme)
cw098	I have taken early retirement or job-related early retirement (‘functioneel leeftijdsontslag’, FLO)
cw099	I am a pensioner
cw104 	11	I have taken early retirement, 12	I am a pensioner
ci067 Receive  old age pensions or life annuities: state old age pension (Dutch: AOW)
*/


* create zeros (obs with any type of information)
recode working   (0 1=0), gen (retf)

/*
retf =1 if not working &:
o	Self-categorisation as retired & age 50+  
o	Receives old-age pension & age 50+
o	Age 65+  
*/

* not working & Self-categorisation as retired & age 50+  
replace retf=1  if  working==0 & cw099==1 & age>=50 
replace retf=1  if  working==0 & cw098==1 & age>=50 
* not working & Receives old-age pension & age 50+
replace retf=1  if  working==0 & ci067==1 & age>=50 
* not working & Age 65+ 
 replace retf=1  if  working==0 & age>=65

	lab var retf "Retired fully (NW, old-age pens, 45+)"
	lab val retf yesno 	
	

*################################################################################
*#
*#	Employment Status 
*#							
*################################################################################
	
**--------------------------------------
** Employment Status 
**--------------------------------------
// uses info from retf and un_act 
 
* emplst5
* create zeros (obs with any type of information)
recode   empl_info (0 1=0)(-1=-1), gen (emplst5)


* Categories 
replace emplst5=4 if (cw089==1|cw090==1|cw092==1|cw096==1|cw097==1|cw100==1|cw101==1) & working==0
replace emplst5=3 if retf==1
replace emplst5=5 if cw095==1 
replace emplst5=2 if un_act==1  
	// un_act=1 if (cw091==1|cw093==1|cw094==1) & working==0
replace emplst5=1 if  cw088==1|cw102==1

* corrections
replace emplst5=3 if emplst5==0 & (cw098==1 | cw099==1)
replace emplst5=-1 if emplst5==0 & empl_info==0

* fill MV based on hhbox info (belbezig)
/* NOTE: This step aims to increase information based on all available sources.
 Users may wish to skip it if:
- only the most accurate information is needed (i.e., from core questionnaire)
- the reference month is changed to one more distanced from Work & Schooling module 

*/
/* belbezig
---> 1
1	Paid employment
2	Works or assists in family business
3	Autonomous professional, freelancer, or self-employed
---> 2
4	Job seeker following job loss
5	First-time job seeker
---> 5
7	Attends school or is studying
14	Is too young to have an occupation
---> 4
6	Exempted from job seeking following job loss
8	Takes care of the housekeeping
10	Has (partial) work disability
11	Performs unpaid work while retaining unemployment benefit
12	Performs voluntary work
---> 3
9	Is pensioner ([voluntary] early retirement, old age pension scheme)
---> 4 (if no other info about working) OR -1
13	Does something else
*/

replace emplst5=4 if emplst5==-1 & (belbezig==6|belbezig==8|belbezig==10|belbezig==11|belbezig==12)
replace emplst5=4 if emplst5==-1 & (belbezig==13) & cw001!=1
replace emplst5=3 if emplst5==-1 & (belbezig==9)
replace emplst5=5 if emplst5==-1 & (belbezig==7|belbezig==14)
replace emplst5=2 if emplst5==-1 & (belbezig==4|belbezig==5)
replace emplst5=1 if emplst5==-1 & (belbezig==1|belbezig==2|belbezig==3)
replace emplst5=1 if emplst5==-1 & work_d==1 // 4 remaining cases based on hhbox 

*
	lab def emplst5	///
			1 "Employed" 			/// including leaves
			2 "Unemployed (active)"	///
			3 "Retired, disabled"	///
			4 "Not active/home"		///   
			5 "In education"		///
			-1 "MV"
	lab val emplst5 emplst5
	lab var emplst5 "Employment status [5]"
	

* bro pid wavey emplst5 work_d working belbezig cw001 cw088-cw101 cw102 if emplst5==-1


* emplst6

gen emplst6=emplst5

replace emplst6=6 if mater==1

	lab def emplst6	///
			1 "Employed" 			///  
			2 "Unemployed (active)"	///
			3 "Retired, disabled"	///
			4 "Not active/home"		///   
			5 "In education"		///
			6 "On leave (employed)" ///
			-1 "MV"
	lab val emplst6 emplst6
	lab var emplst6 "Employment status [6]"


*################################################################################
*#
*#	Employment - other variables: full/part time, supervisor
*#							
*################################################################################
**--------------------------------------
** full/part time
**--------------------------------------

*** based on actual hours - as in other countires
gen fptime_h=.
replace fptime_h=1 if whweek>=35 & whweek<.
replace fptime_h=2 if whweek<35 & whweek>0
replace fptime_h=3 if whweek==0 // 
replace fptime_h=3 if emplst5>1 & emplst5<.
replace fptime_h=-1 if fptime_h==. & emplst5==1 



*** based on contracted hours 
gen fptime_r=.
replace fptime_r=1 if whweek_ctr>=35 & whweek_ctr<.
replace fptime_r=2 if whweek_ctr<35 & whweek_ctr>0
replace fptime_r=3 if whweek_ctr==0
replace fptime_r=3 if emplst5>1 & emplst5<.
replace fptime_r=-1 if fptime_r==. & emplst5==1 

/*NOTE: Information ignored but can be included: 
You work(ed) for less than 36 hours. Can you indicate for what reason(s) you work(ed) parttime? 
cw526 - a fulltime job in my company amounts to less than 36 hours*/

*** 
	lab def fptime 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/0 hours/other" -1 "Emplyed but no info on hours"
	lab val fptime_r fptime_h fptime

	lab var fptime_r "Employment Level (self-report)"
	lab var fptime_h "Employment Level (based on hours)"


	  
**--------------------------------------
** Supervisor 	
**--------------------------------------
* cw409 Do you supervise other employees in your profession or position?

recode cw409 (2=0) (1=1), gen(supervis)
replace supervis=-1 if emplst5!=1
	
		lab val supervis yesno 

*################################################################################
*#
*#	Old-age pension, disability pension	
*#							
*################################################################################

**--------------------------------------
** Receiving old-age pension  
**--------------------------------------					  
*   
								  
gen  oldpens= ci067

	lab var oldpens "Receiving old-age pension"
	lab val oldpens yesno 
	

**--------------------------------------
** Receiving disability pension   
**--------------------------------------		
* disabpens
/*
Receive one or more of the following benefits or allowances:
ci095 - Act on Income Provisions for Older or Partially Disabled Unemployed Persons/Formerly Self-Employed Persons (Dutch: IOAW/IOAZ)
ci096 - WGA (Return to Work Scheme), 
		IVA (Income Provision Scheme for People Fully Occupationally Disabled) 
		or WAO (Disability Insurance Act for  permanently fully occupationally disabled persons)
ci328 - Wajong (Work and Employment Support for Disabled Young Persons Act)
*/
* to create 0 and MV - based on weather they answerd anything in the block on benefits 
gen temp=0
foreach var of varlist ci100 ci327	ci087	ci374	ci090	ci091	ci092	ci341	ci094	ci095	ci096	ci098	ci099	ci328	ci329	ci393	ci398	ci101 {
replace temp=1 if `var'==0|`var'==1
}

*
recode temp(1=0), gen (disabpens)
replace disabpens=1 if ci095==1|ci096==1|ci328==1 

drop temp

 	lab var disabpens "Receiving disability pension"
 	lab val disabpens yesno 

*################################################################################
*#
*#	Work history 			
*#							
*################################################################################

**--------------------------------------
**   Labor market experience full time
**--------------------------------------
*   expft= 
 
**--------------------------------------
**   Labor market experience part time 
**--------------------------------------
*   exppt= 
 
**--------------------------------------
**   Total Labor market experience (full+part time)  
**--------------------------------------
*  exp "Labor market experience"	

**--------------------------------------
**   Experience in org
**--------------------------------------
* cw134 In which year did you enter into employment with your current employer? 
 
  gen exporg=intyear-cw134  
  recode exporg (min/-1=0)
  	* remove unreliable values 
	  gen temp_exp=age-exporg
	  replace exporg=. if temp_exp<=15 & age>30
	  replace exporg=. if temp_exp<=13 
	  drop temp* 

	lab var exporg "Experience in organisation"

**--------------------------------------
**   Never worked   
**--------------------------------------	
*neverw

// 	lab var neverw "Never worked"
// 	lab val neverw yesno
	
*################################################################################
*#
*#	Income and wealth		
*#							
*################################################################################

**--------------------------------------
**   Work Income - detailed
**--------------------------------------
	
*** All jobs - year (previous callendar year) 
// Previous callendar year (lagged varaible), based on background variables (nettoink_sum & nettoink_count)
// Only if information availible for all 12 months of the previous year
// If <12 months of information --> MV 

gen incjobs_pyn= .
bysort pid (wavey): replace incjobs_pyn=nettoink_f_sum[_n-1] if nettoink_f_count[_n-1]==12
bysort pid (wavey): replace incjobs_pyn=-9 if nettoink_f_count[_n-1]<12 & nettoink_f_count[_n-1]>0 // some information avaliable

gen incjobs_pyg= .
bysort pid (wavey): replace incjobs_pyg=brutoink_f_sum[_n-1] if brutoink_f_count[_n-1]==12
bysort pid (wavey): replace incjobs_pyg=-9 if brutoink_f_count[_n-1]<12 & brutoink_f_count[_n-1]>0 // some information avaliable


	lab var incjobs_pyn "Individual Labor Earnings (All jobs, prev cal year, net)"
	lab var incjobs_pyg "Individual Labor Earnings (All jobs, prev cal year, gross)"


*** Month - average from recent months / reference month

* 1. Takes value from HH box (imputed) for the reference month for backgroung varialbes
	gen incjobs_mn=nettoink_f

* 2. If #1 is missing, takes computed average across the year 
* Average (from entire current year)
	gen inc_n_average = nettoink_f_sum/nettoink_f_count 
	replace incjobs_mn=inc_n_average if incjobs_mn==. & inc_n_average<. & inc_n_average>0

	lab var incjobs_mn "Individual Labor Earnings (All jobs, month, net)"


**--------------------------------------
*   HH wealth
**--------------------------------------
/*Note: 
Background vars. Imputed monthly income of all household members combined.
- brutohh_f - Gross household income in Euros - Imputed monthly
- nettohh_f - Net household income in Euros - Imputed monthly income
*/

* 1. Takes value from HH box (imputed) for the reference month for backgroung varialbes
  gen hhinc_pypre=brutohh_f  
  gen hhinc_pypost=nettohh_f   

* 2. If #1 is missing, takes computed average across the year 
* Average (from entire current year)
 gen hhinc_b_average = brutohh_f_sum/brutohh_f_count 
 gen hhinc_n_average = nettohh_f_sum/nettohh_f_count 

 replace hhinc_pypre=hhinc_b_average if hhinc_pypre==. & hhinc_b_average<. & hhinc_b_average>0
 replace hhinc_pypost=hhinc_n_average if hhinc_pypost==. & hhinc_n_average<. & hhinc_n_average>0

*
 	lab var hhinc_pypre 	 "HH income(prev. year, pre)"	
	lab var hhinc_pypost 	 "HH income(prev. year, post)"	


*################################################################################
*#
*#	Health status			
*#							
*################################################################################
**--------------------------------------
**  Self-rated health 
**--------------------------------------
/** ch004 How would you describe your health, generally speaking?
				--> srh5
1	poor 		--> 5 "Poor"
2	moderate  	--> 4 "Fair" 
3	good  		--> 3 "Good" 
4	very good  	--> 2 "Very good" 
5	excellent  	--> 1 "Excellent"

*/

/** New CPF scale labels 
1 Excellent
2 Very good
3 Good
4 Fair
5 Poor*/


recode ch004 (1=5)(2=4)(3=3)(4=2)(5=1), gen(srh5)

	lab var srh5 "Self-rated health"
	lab def srh5 5 "Poor" 4 "Fair" 3 "Good" 2 "Very good" 1 "Excellent"
	lab val srh5 srh5

**--------------------------------------
**  Disability 
**--------------------------------------
 
/*
ch018 Do you suffer from any kind of long-standing disease, affliction or handicap, 
	  or do you suffer from the consequences of an accident?
		1	yes
		2	no

ch022 To what extent did your physical health or emotional problems hinder your work 
	  over the past month, for instance in your job, the housekeeping, or in school?
		1	not at all
		2	hardly
		3	a bit
		4	quite a lot
		5	very much

ch100 At this moment, do you go to work as normal, 
	  or do you not or only partly go to work because of your health?
		1	I work as normal (full-time or part-time)
		2	I work, but because of my health I do not work a full working week
		3	I do not work because of my health
		4	I do not work for another reason

ch105 To what extent does your health trouble you in your work? 
	  Are you able to perform your work without any trouble? 
	  Does it cause you a bit of trouble, or does it cause you a lot of trouble?
		1	I can do my work without any trouble
		2	Doing my work causes me some trouble
		3	Doing my work causes me a lot of trouble
		4	I can no longer do my work at all
*/


/*** disab 
Persons has any type disability (physical, mental or nervous condition) 
that affects her/him everyday activities or work.
	disab = 1 if 
	ch018==1 	
	ch022>=4 & ch022<.
	ch100>=2 & ch100<.
	ch105>=2 & ch105<.  */

recode ch018 (1 2=0), gen (disab)
replace disab = 1 if ch018==1 &	(ch022==4 | ch022==5) 
replace disab = 1 if ch018==1 & (ch100==2 | ch100==3) 
replace disab = 1 if ch018==1 & (ch105>=2 & ch105<=4)  


/*** disab2c
Persons has a more sever type of disability (physical, mental or nervous condition) 
that restricts her/him in everyday activities or at work. 
As a more sever we consider an equivalent of category 2 disability or >30% limitation of functioning. 
	disab2c = 1 if 
	ch018==1
	ch022==4|ch022==5
	ch100==3
	ch105==4 */

recode ch018 (1 2=0), gen (disab2c)
replace disab2c = 1 if ch018==1 & ch100==3
replace disab2c = 1 if ch018==1 & ch105==4 

/*recode ch018 (1 2=0), gen (disab2c)
replace disab2c = 1 if ch018==1 & ch022==5
replace disab2c = 1 if ch018==1 & ch100==3 
replace disab2c = 1 if ch018==1 & ch105==4 */



	lab var disab	"Disability (any)"
	lab var disab2c "Disability (min. category 2 or >30%)"
	lab val disab disab2c yesno


**--------------------------------------
**  Chronic diseases
**--------------------------------------
* chron
/* ch018 - Do you suffer from any kind of long-standing disease, 
 affliction or handicap, or do you suffer from the consequences of an accident? */

recode ch018  (1=1)(2=0), gen(chron)

	lab var chron	"Chronic diseases"
	lab val chron   yesno
	
	
	
*################################################################################
*#
*#	Subjective wellbeing	
*#							
*################################################################################
**--------------------------------------
**   Satisfaction with  
**--------------------------------------
/*Note: 

*/

/*** Life
cp011 - How satisfied are you with the life you lead at the moment? (0-10)
	0 not at all satisfied
	10 completely satisfied 
* Similar: 
* cp016 - I am satisfied with my life (1-7)
* cp076 - On the whole, I am satisfied with myself (1-7)
*/

/*** Work 
cw133 How satisfied are you with your current work?
0 not at all satisfied; 10 fully satisfied*/ 

/*** Family relationships
cf181 How satisfied are you with your family life?
0 not at all satisfied; 10 fully satisfied
*/

/*** Financial sit i income
cw128 wages or salary or profit earnings
0 not at all satisfied; 10 fully satisfied
*/


	lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" 	///
				 4  "4 Mostly sat" 5 "5 Completely sat"						///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 		///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	 

	lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
 

 * Recode   10-point into 5-point versions 
 // satwork satfam satfinhh satinc sathlth
 tokenize "cp011 cw133 cw128 cf181 "
	 foreach var in satlife satwork satinc satfam {
		 recode  `1' (0 1=1)(2 3 4=2)(5=3)(6 7 8=4)(9 10=5)(-9 999=-1), gen(`var'5)
		 recode  `1' (-9 999=-1), 	 gen(`var'10)
			 lab val `var'5  sat5
			 lab val `var'10 sat10
	 macro shift 1  
 }



*################################################################################
*#
*#	Other variables: training, work-education link, qualifications for job, volunteering, job security	
*#							
*################################################################################
**--------------------------------------
**   Training
**--------------------------------------
/* cw035 - Have you, in the past 12 months, followed any educational programs or courses 
or are you presently following one or more educational programs or courses?
This concerns educational programs or courses that are important for your work or profession.*/

recode cw035 (2=0), gen (train)
 
lab val train yesno
	lab var train "Training (previous year)"

**--------------------------------------
**   work-edu link
**--------------------------------------
/*
cw031
Which of these statements best describes your situation?
My education …
1	is approximately at the level required by my work
2	is higher than the level required by my work
3	is lower than the level required by my work
4	is for another kind of work than for my current work
5	has become outdated because the work has changed
6	has no relation at all to my current work
7	is insufficiently geared to the work practice
*/

recode cw031 (1=1)(2/7=0)(99=-1), gen(eduwork)

	lab var eduwork "Work-education skill fit"
	lab def eduwork 0 "0 Poor" 1 "1 Good" ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val eduwork eduwork	



**--------------------------------------
**   wqualif
**--------------------------------------
/*
cw033 - for all years, but from 2019+ lower priority than cw549 - cw556
Which of the statements below best describes your situation? My knowledge and skills…
Codes
1	are approximately at the level required by my work
2	are higher than the level required by my work
3	are lower than the level required by my work
4	are for another kind of work than for my current work
5	have become outdated because the work has changed
6	have no relation at all to my current work
7	are insufficiently geared to the work practice

cw549-cw556 - from 2019+ the main question (if more than 1 YES --> also cw033 asked)
Which of these statements best describes your situation?
Multiple answers possible.
My knowledge and skills…
	cw549- are approximately at the level required by my work
	cw550- are higher than the level required by my work
	cw551- are lower than the level required by my work
	cw552- are for another kind of work than for my current work
	cw553- have become outdated because the work has changed
	cw554- have no relation at all to my current work
	cw555- are insufficiently geared to the work practice
0 no; 1 yes
*/
gen wqualif=.
* check if more answers YES
recode cw549 cw550 cw551 cw552 cw553 cw554 cw555 (-9=.)
egen temp_sum=rowtotal(cw549 cw550 cw551 cw552 cw553 cw554 cw555), missing
* 
recode cw033 (3 4 5 6 7=1)(1=2)(2=3)(99=-1), gen(temp_wqualif)
* for <2019
replace wqualif=temp_wqualif if wavey<2019
* for 2019+
replace wqualif=1 if wavey>=2019 & (cw551==1|cw552==1|cw553==1|cw554==1|cw555==1) & temp_sum==1
replace wqualif=3 if wavey>=2019 & cw550==1 & temp_sum==1
replace wqualif=2 if wavey>=2019 & cw549==1 & temp_sum==1
* for 2019+ if more than 1 YES
replace wqualif=temp_wqualif if wavey>=2019 & temp_sum>1

drop temp_wqualif temp_sum

	lab var wqualif "Qualifications for job"
	lab def wqualif 1 "1 Underqualified/Not qualified" 2 "2 Qualified (fit)" 3 "3 Overqualified" ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val wqualif wqualif




**--------------------------------------
**   Volunteering NA
**--------------------------------------

// 	lab val volunt yesno
// 	lab var volunt "Volunteering"
	
	
**--------------------------------------
**   Job security
**--------------------------------------
/*  
cw435 - all years 
It is uncertain whether my job will continue to exist.
1 disagree entirely ; 2 disagree; 3 agree; 4 agree entirely

cw598 - 2019+ 
What is the chance that you lose your main job in the next 12 months?
Percent chance (0 to 100):
-9	I don’t know
-8	I prefer not to say
*/ 


recode cw435 (3 4=1)(1 2=0), gen(jsecu)
* Alternative, based on %. NOTE: Users might need to adjust it:
recode cw598 (min/-1=-1)(0/14=0)(15/100=1), gen(jsecu_alt) //similar to HILDA appraoch 

	lab def jsecu 	 1 "Insecure" 0 "Secure"  ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab def jsecu2 	 1 "Insecure" 0 "Secure" 2 "Hard to say" ///
// 					-1 "-1 MV general" -2 "-2 Item non-response" ///
// 					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab var jsecu "Job insecurity [2]"
// 	lab var jsecu2  "Job insecurity [3]"

	lab val jsecu jsecu




*################################################################################
*#
*#	SES Indices
*#							
*################################################################################	

**--------------------------------------
**   Occupational status (ISEI)
**--------------------------------------
* isei 
iscogen isei08 = isei(isco08_4), from(isco08)
	lab var isei08 "ISEI-08: International Socio-Economic Index of occupational status"
	

* iscogen isei88 = isei(isco88_4), from(isco88)
* 	lab var isei88 "ISEI-88: International Socio-Economic Index of occupational status"	
	
	
**--------------------------------------
**   Treiman's international prestige scale (SIOPS) 
**--------------------------------------
iscogen siops08 = siops(isco08_4) , from(isco08)
	lab var siops08 "SIOPS: Treiman's international prestige scale" 
	
* iscogen siops88 = siops(isco88_4) , from(isco88)
* 	lab var siops88 "SIOPS-88: Treiman's international prestige scale" 
	
**--------------------------------------
*** MPS (German Magnitude Prestige Scale)
**--------------------------------------	
* iscogen mps88 = mps(isco88_4), from(isco88)



	
**--------------------------------------
**   EGP / ESEC
**--------------------------------------	
// 	iscogen egp = egp11(isco88_4 selfemp  ), from(isco88)



*################################################################################
*#
*#	Parents					
*#							
*################################################################################		


**--------------------------------------  
**   Parents' education
**--------------------------------------
*** Father 
   /*
   
*edu3
recode , gen(fedu3)

	lab val fedu3 edu3
	lab var fedu3 "Father's education: 3 levels"

	
* edu4
recode , gen(fedu4)

	lab val fedu4 edu4
	lab var fedu4 "Father's education: 4 levels"
	

*** Mother 
*edu3
recode , gen(medu3)

	lab val medu3 edu3
	lab var medu3 "Mother's education: 3 levels"

	
* edu4
recode , gen(medu4)

	lab val medu4 edu4
	lab var medu4 "Mother's education: 4 levels"
	*/
	


*################################################################################
*#
*#	    Ethnicity			
*#							
*################################################################################	 
* ethn
* LISS does not ask directly about  the ethnicity, rather about national identification:
/* 
Availible from 2019+ 
cr165-cr179
Some people feel that they also belong to another group. To which of the following groups do you feel you belong? Choose all that applies to you.
cr165	No other group
cr166	Turks
cr167	Kurds
cr168	Moroccans
cr169	Berbers
cr170	Surinamese
cr171	Hindus
cr172	Creole groups
cr173	Javanese
cr174	Chinese
cr175	Curaçaoan
cr176	Aruban
cr177	Antillean
cr178	Indonesian
cr179	Other group, namely: ... --> coded in cr180
*/




*################################################################################
*#
*#	Migration				
*#							
*################################################################################	 

**--------------------------------------
**   COB respondent, father and mother
**--------------------------------------	

* cob
* 

**-------------------------------------------------
**   Migration Background (respondent)
**-------------------------------------------------
/*
herkomstgroep
This variable was added from October 2010 onwards
The variable is largely based on variables from the study Religion and Ethnicity 
0	Dutch background
101	First generation foreign, Western background
102	First generation foreign, non-western background
201	Second generation foreign, Western background
202	Second generation foreign, non-western background
*/

*migr - specifies if respondent foreign-born or not.

recode herkomstgroep (0 201 202 =0)(101 102 =1), gen(migr)


lab def migr ///
0 "Native-born" ///
1 "Foreign-born" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

 lab val migr migr

**--------------------------------------
**   Migration Background (parents)
**--------------------------------------	


**--------------------------------------
**   Migrant Generation
**--------------------------------------	
/*
herkomstgroep
This variable was added from October 2010 onwards
The variable is largely based on variables from the study Religion and Ethnicity 
0	Dutch background
101	First generation foreign, Western background
102	First generation foreign, non-western background
201	Second generation foreign, Western background
202	Second generation foreign, non-western background
*/

recode herkomstgroep (0=0)(101 102 =1)(201 202=2), gen(migr_gen)

*
lab def migr_gen ///
0 "no migration background" ///
1 "1st generation" ///
2 "2st generation" ///
3 "2.5th generation" ///
4 "incomplete information parents"

lab val migr_gen migr_gen

*################################################################################
*#
*#	    Religion			 
*#							
*################################################################################

**--------------------------------------  
** Religiosity
**--------------------------------------
//NOTE: because we do not want to assume religious affiliation to be time-constant, missing values are not filled automatically across waves. 

/*
cr012 (<2019) Do you see yourself as belonging to a church community or religious group?
1	yes
2	no
cr143 (2019+) Do you see yourself as belonging to a church community or religious group?
1	yes
2	no

cr162 (2019+) To what extent would you describe yourself as a religious person? Is that:
1	certainly religious
2	somewhat religious
3	barely religious
4	certainly not religious

CPF takes cr012/cr143 as the basis, but for 2019+ also cr162 is available as an alternative.
*/

recode cr012 (2=0)(99=-1), gen(relig_a)
recode cr143 (2=0)(-9=-1), gen(relig_b)
gen relig=relig_a
replace relig=relig_b if wavey>=2019

* Alternative for 2019+
* recode cr162 (1 2=1)(3 4=0)(-9=-1), gen(relig_c)


* Fill MV for 2019+ based on cr162
replace relig=0 if wavey>=2019 & (relig==.|relig==-1) & (cr162==3|cr162==4)
replace relig=1 if wavey>=2019 & (relig==.|relig==-1) &(cr162==1|cr162==2)

drop relig_a relig_b // relig_c


	lab def relig ///
	0 "Not religious/Atheist/Agnostic" ///
	1 "Religious" ///
	-1 "MV general" ///
	-2 "Item non-response" ///
	-3 "Does not apply" ///
	-8 "Question not asked in survey"
	lab val relig relig


**--------------------------------------  
** Attendance
**--------------------------------------

/*
cr041
Aside from special occasions such as weddings and funerals, 
how often do you attend religious gatherings nowadays?
1	every day
2	more than once a week
3	once a week
4	at least once a month
5	once or a few times per year
6	never
*/

recode cr041 (6=1) (5=2) (4=3) (1 2 3=4) (-9 99=-1) , gen(relig_att)

lab def attendance ///
1 "Never or practically never" ///
2 "Less than once a month" ///
3 "At least once a month" ///
4 "Once a week or more" ///
	-1 "MV general" ///
	-2 "Item non-response" ///
	-3 "Does not apply" ///
	-8 "Question not asked in survey"

lab val relig_att attendance


		
*################################################################################
*#
*#	Weights					
*#							
*################################################################################	 
**--------------------------------------
**   Cross-sectional sample weight
**--------------------------------------	
* gen wtcs= 
 
  
**--------------------------------------
**   Cross-sectional population weight
**--------------------------------------	
* gen wtcp= 
 


*################################################################################
*#
*#	Keep variables
*#							
*################################################################################	
	
keep			///
wave* pid hhid country respstat intyear intmonth  ///
age yborn female  		///
edu* indust*   isco* inc* fpt* 						///
size* inc* hhinc*  selfemp*			///
kids* kidsn_hh* nphh work_* empls* public 			///
wh* mater un_*   retf*  supervis exp* 	///
hhinc* srh* disab*  oldpens	train chron				/// 
mlstat* parstat*  livpart nvmarr	marst* widow divor separ 		///
sat*  ///
wqualif eduwork jsecu* ///
isei* siops*  /// nempl
migr*   relig* ///  
isei08 siops08 
	 
	
/*respstat wave1st age age7 yborn female edu3 edu4 edu5 edu5v2 
mlstat5 marstat5 haspart livpart parstat6 nvmarr widow divor separ 
kidsn_all kids_any  kidsn_hh_02 kidsn_hh_34 kidsn_hh_04 kidsn_hh_510 kidsn_hh17 kidsn_hh15 kidsn_hh18 kids_hh_04 nphh 
empl_info work_d working isco08_4 isco_1 isco_2 indust1 indust2 indust3 public size size4 size5 size5b 
whweek_ctr whweek whyear whmonth mater un_act selfemp_v1 selfemp retf emplst5 emplst6 fptime_h fptime_r 
supervis oldpens disabpens exporg 
incjobs_yn_prevyALLm incjobs_yg_prevyALLm incjobs_yn incjobs_yg incjobs_mn inc_n_average 
hhinc_pre hhinc_post hhinc_b_average hhinc_n_average 
srh5 disab disab2c chron 
satlife5 satlife10 satwork5 satwork10 satinc5 satinc10 satfam5 satfam10 
train eduwork wqualif jsecu jsecu_alt 
isei08 siops08 
migr migr_gen relig relig_att*/


*################################################################################
*#
*#	Save
*#							
*################################################################################
 
label data "CPF_nl_${cpfv}"	 
save "${liss_out}/nl_02_CPF.dta", replace  	



* Log
display "Ending LISS data harmonization at $S_TIME"
log close


	
*____________________________________________________________________________
*--->	END	OF FILE <---


