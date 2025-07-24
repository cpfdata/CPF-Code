/*			
===============================================================================
	CPF Version 2.0 
	KLIPS 
	Syntax 02: Harmonize variables
===============================================================================
Purpose: Harmonize variables
Author:  Konrad Turek
Date:    06.2025
Input:   ko_01.dta (combined person-household file)
Output:  ko_02.dta (harmonized dataset)
===============================================================================

TABLE OF CONTENTS:
1.  Setup and Configuration
2.  Technical Variables
3.  Socio-demographic 
4.  Education 
5.  Family Relationship 
6.  Labour Market 
7.  Income and Wealth 
8.  Health Status 
9.  Subjective Wellbeing 
10. Other 
11. SES Indices
12. Parents 
13. Ethnicity 
14. Migration 
15. Religion 
16. Weights 
17. Data Export
===============================================================================
*/
	
*################################################################################
*# 
*# SETUP AND CONFIGURATION
*# 
*################################################################################

* Log
capture log close 
log using "${klips_out}/ko_02_harmonize.log", replace
display "Starting KLIPS data harmonization at $S_TIME"

* Configuration
global start_year = 1998
global waves_n = "${klips_w}"
global data_path = "${klips_out}"
global output_path = "${klips_out}"

display "Configuration:"
display "  Start year: $start_year"
display "  The latest wave: $waves_n"
display "  Data path: $data_path"
display "  Output path: $output_path"

**--------------------------------------
** Open merged dataset
**-------------------------------------- 
use "${klips_out}/ko_01.dta", clear

qui tab wave
display _newline(1) "   Total ->> Vars: " c(k) "; N: " _N "; Waves: " r(r)  

**--------------------------------------
** Common labels 
**-------------------------------------- 
lab def yesno 0 "[0] No" 1 "[1] Yes" ///
	-1 "-1 MV general" -2 "-2 Item non-response" ///
	-3 "-3 Does not apply" -8 "-8 Question not asked in survey", replace


*################################################################################
*# 
*#	TECHNICAL VARIABLES
*# 
*################################################################################

* pid
* intyear 
* intmonth
* wave 

rename wave wavey
gen intyear=wavey
gen intmonth=p_9501
recode intmonth (.=-1)

egen wave = group(wavey)

sort pid wave

gen country=2
 
bysort pid: egen wave1st = min(wave) // hwaveent for HH entry (sometimes different sample entry)

*** Respondent status 
recode p_9509 (-1/8=1), gen(respstat)
	lab def respstat 	1 "Interviewed" 					///
						2 "Not interviewed (has values)" 	///
						3 "Not interviewed (no values)"
	lab val respstat respstat
	
*################################################################################
*# 
*# SOCIO-DEMOGRAPHIC BASIC VARIABLES
*# 
*################################################################################

*** Age
gen age=p_0107
	lab var age "Age" 

*** Birth year
gen yborn=p_0104
	lab var yborn "Birth year" 
	
*** Gender
recode p_0101 (1=0) (2=1), gen(female)
	lab def female 0 "Male" 1 "Female" 2 "Other"
	lab val female female 
	lab var female "Gender" 
	
	
* Place of living (e.g. size/rural) NA
* place

recode h_0141 (1/7 19=1) (8/18=2), gen(place2)

 	lab var place2 "Place of living [KOR]"
	lab def place2 1 "large city" 2 "province"
	lab val place2 place2 

//  	lab var place "Place of living"
// 	lab def place 1 "city" 2 "rural area"
// 	lab val place place 



*################################################################################
*# 
*# EDUCATION
*# 
*################################################################################

*** eduy
// lab var eduy "Education: years"

*** edu3
/* p__0110 -  Level of education (schooling) [attend last or is attending]
(1)  before school age
(2)  no schooling 
(3)  elementary school
(4)  lower secondary
(5)  upper secondary
(6)  2-years college, vocational, technical, associate degree
(7)  university (4 years or more)
(8)  graduate school (master's)
(9)  graduate school (doctoral)
*/

/* p_0111 - Whether or not completed the schooling
 (1) Graduated with a diploma/degree 
 (2) Finished course but did Not acquire a diploma/degree 
 (3) Dropped out  
 (4) Attending Now 
 (5) Temporarily Not attending  */


* Create hierarchical education variable (hiedu) from p_0110
* This represents the highest level of education completed
gen hiedu=p_0110

* Adjust education level based on current enrollment status (p_0111)
* If currently enrolled in higher education (p_0111>2), reduce by 1 or more levels
* This accounts for individuals who haven't completed their current program
* Logic: Someone enrolled in upper secondary (level 5) but not graduated should be coded as lower secondary (level 4)
* 		Note: Someone enrolled in university (level 7) but not graduated is coded as 6 but could also be 5 
* 		This however has no implications for edu* variables
replace hiedu=hiedu-1 if p_0111>2 & p_0111<. & p_0110>1 & p_0110<=9

* Create 3-level education classification
* Level 1 (Low): No schooling, elementary, lower secondary (levels 1-4)
* Level 2 (Medium): Upper secondary, vocational/technical (levels 5-6) 
* Level 3 (High): University and graduate education (levels 7-9)
recode hiedu (1 2 3 4=1) (5 6=2) (7 8 9=3), gen(edu3)

	lab def edu3  1 "Low" 2 "Medium" 3 "High" // 2 incl Vocational
	lab val edu3 edu3
	lab var edu3 "Education: 3 levels"

	
*** edu4 - 4-level education classification
* Level 1: Primary education (no schooling, elementary, lower secondary)
* Level 2: Lower secondary only
* Level 3: Upper secondary and vocational/technical
* Level 4: Tertiary education (university and graduate)
recode hiedu (1 2 3=1) (4=2) (5 6=3) (7 8 9=4), gen(edu4)

	lab def edu4  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" 4 "[5-8] Tertiary" 
	lab val edu4 edu4
	lab var edu4 "Education: 4 levels"
	
*** edu5 - 5-level education classification
* Level 1: Primary education (no schooling, elementary, lower secondary)
* Level 2: Lower secondary only
* Level 3: Upper secondary and vocational/technical
* Level 4: Bachelor's degree
* Level 5: Master's and doctoral degrees
recode hiedu (1 2 3=1) (4=2) (5 6=3) (7=4) (8 9=5), gen(edu5)

	lab def edu5  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" ///
				  4 "[5-6] Tertiary lower(bachelore)"  ///
				  5 "[7-8] Tertiary upper (master/doctoral)"
				  
	lab val edu5 edu5
	lab var edu5 "Education: 5 levels"

	* Alternative version (edu5v2) - Different grouping for tertiary education
	* Level 4: Bachelor's and Master's degrees combined
	* Level 5: Doctoral degree only
	* This alternative classification groups master's with bachelor's rather than doctoral
recode hiedu (1 2 3=1) (4=2) (5 6=3) (7 8=4) (9=5), gen(edu5v2)

	lab def edu5v2  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
					3 "[3-4] Secondary upper" ///
					4 "[5-7] Tertiary first(bachelore/master)"  ///
					5 "[8] Tertiary third (doctoral)"
	
	lab val edu5v2 edu5v2
	lab var edu5v2 "Education: 5 levels v2"
	
	
	
*################################################################################
*# 
*# FAMILY RELATIONSHIP
*# 
*################################################################################

**--------------------------------------
** Primary partnership status  (from CNEF) 	 
**--------------------------------------
* Approach based on CNEF 
* in KLIPS mlstat5=marstat5
* KLIPS recognises only spouses (not partners)

recode p_5501 (2=1) (1=2) (5=3) (4=4) (3=5) (.=-1), gen(marstat5)

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
** Formal marital status 	 
**--------------------------------------
* in KLIPS mlstat5=marstat5
 

recode p_5501 (2=1) (1=2) (5=3) (4=4) (3=5) (.=-1), gen(mlstat5)
		
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
** Partner 
**--------------------------------------	
* KLIPS recognises only spouses (not partners)

recode p_5501 (1 3 4 5=0)(2=1) (.=-1), gen(livpart)
replace livpart=0 if h_0150==1

// 		lab var haspart "Has a partner"
		lab var livpart "Living together with partner"
		lab val livpart    yesno
		
		
/*
**--------------------------------------
** Partnership living-status 	 
**--------------------------------------
* Includes inforamtion on marital status and whether living with partner in HH 
* KLIPS recognises only spouses (not partners)
* So the variables equal mlstat5 

	recode  mlstat5 (1/5=0), gen(parstat6)
	replace parstat6=3 if mlstat5!=1 & livpart==0
	replace parstat6=5 if mlstat5==4 & livpart==0
	replace parstat6=4 if mlstat5==3 & livpart==0
	replace parstat6=6 if mlstat5==5 & livpart==0
	replace parstat6=6 if mlstat5==1 & livpart==0
	// replace parstat6=2 if mlstat5!=1 & livpart==1 // not possible 
	replace parstat6=1 if mlstat5==1 & livpart==1

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
	lab val parstat6 parstat6*/
	
	
 	
**--------------------------------------
** Binary specific current partnership status (yes/no)
**--------------------------------------
*** Specific current marital statuses 
* No mater if currently living with a partner
	

*** Single
// 		lab var csing "Single: not married and no partner"
// 		lab val csing yesno
								
*** Never married 
	recode  p_5501  (2/5=0)(1=1)(.=-1), gen(nvmarr)

		lab var nvmarr "Never married"
		lab val nvmarr yesno						
				
*** Widowed
recode mlstat5 (3=1) (1 2 4 5=0), gen(widow)

		lab var widow "Widowed (current status)"
		lab val widow yesno	
		
*** Divorced
recode mlstat5 (4=1) (1 2 3 5=0), gen(divor)

		lab var divor "Divorced (current status)"
		lab val divor yesno	


*** Separated
recode mlstat5 (5=1) (1/4=0), gen(separ)

		lab var separ "Separated (current status)"
		lab val separ yesno	

				
				
				
**--------------------------------------
** Year married	 
**--------------------------------------
* ymarr 

//  	lab var ymarr "Year married	"
	
	
	
**--------------------------------------
** Children 
**--------------------------------------
/* Notes:
- Info in vars: p_9074 p_9075, more specific: h_1502 h_2002 h_1505 h_1506
-- PROBLEM: NOT RELIABLE -- 
*/

* kidsn_hh - As in CNEF - HH members < 18 y.o. 
* Calculate number of children aged 0-17 in the household
* Uses household roster variables: h_03XX (age) and h_04XX (relationship to head)
* h_04XX codes 1 and 2 indicate children (sons/daughters)
forvalue i=1/15 {
local a=`i'+60
local b=`i'+20
gen temp`i'=(h_03`a'<18 & (h_04`b'==1|h_04`b'==2))
}
egen kidsn_hh17=rowtotal(temp*)
drop temp*

* kidsn_18  -- PROBLEM: NOT RELIABLE -- 
// Probably covers the whole HH (e.g. includes respondent, grandchildren) 
// e.g. 
// tab age h_1501 if age<20, row
//  bro pid wave age h_1501 h_0261 p_9071 p_9074 p_9075  if age<20
	// recode h_1502 (.=0), gen (kidsn_18)

	* Additional var: ever kid - from 1st interveiw only
// 	recode p_9071 (1=1) (2 -1=.) if wavey==1998, gen(temp1) // different coding in 1st wave
// 	replace temp1=1 if p_9071==2 & wavey>1998			   // different coding in other waves
// 	by pid: egen everkid= min(temp1)
// 		drop temp1
 
* kids_any
// recode kidsn_18 (1/99=1) , gen(temp_kids1)  // only <18 
// recode everkid (1=1) (.=0), gen(temp_kids2) // add info from 1-st interveiw 
// gen kids_any=temp_kids1 
// ...
// by pid: replace kids_any=kids_any[_n-1] if kids_any==0 & kids_any[_n-1]==1
// 	drop temp*  


	
// 	lab var kids_any  "Has children"
// 	lab val kids_any   yesno
// 	lab var kidsn_all  "Number Of Children" 
//  lab var kidsn_18   "Number Of Children <18 y.o." 
// 	lab var kidsn_15   "Number Of Children <15 y.o." 
 	lab var kidsn_hh17   "Number of Children in HH aged 0-17"
	
*** Added in CPF 1.52 - Age-specific children counts
* Create detailed age breakdowns for children in household
* These variables are useful for analyzing childcare needs and family composition
*
forvalue i=1/15 {
local a=`i'+60
local b=`i'+20
* Children aged 0-2: Infants and toddlers requiring intensive care
gen tempa`i'=(h_03`a'<=2 & (h_04`b'==1|h_04`b'==2))
* Children aged 0-4: Preschool age children (0-4 years)
gen tempb`i'=(h_03`a'<=4 & (h_04`b'==1|h_04`b'==2))
* Children aged 3-4: Preschool age children (3-4 years only)
gen tempc`i'=(h_03`a'>=3 & h_03`a'<=4 & (h_04`b'==1|h_04`b'==2))
* Children aged 5-10: School age children (primary school)
gen tempd`i'=(h_03`a'>=5 & h_03`a'<=10 & (h_04`b'==1|h_04`b'==2))
}
* Sum across all household members to get total counts for each age group
egen kidsn_hh_02=rowtotal(tempa*)
egen kidsn_hh_04=rowtotal(tempb*)
egen kidsn_hh_34=rowtotal(tempc*)
egen kidsn_hh_510=rowtotal(tempd*)

drop temp*
	
	lab var kidsn_hh_02   "Number of Children in HH aged 0-2"
	lab var kidsn_hh_34   "Number of Children in HH aged 3-4"
	lab var kidsn_hh_04   "Number of Children in HH aged 0-4"
	lab var kidsn_hh_510   "Number of Children in HH aged 5-10"
*
* Binary indicator for presence of young children (0-4 years)
recode kidsn_hh_04 (0=0)(1/20=1), gen(kids_hh_04)
	lab var kids_hh_04   "Any children in HH aged 0-4?"
	lab val kids_hh_04   yesno

*	
* Find the youngest household member
* First, recode missing values in age variables to system missing for proper calculation
recode h_0361-h_0369 (min/-1=.)
forvalue i=1/15 {
local a=`i'+60
local b=`i'+20
* Extract age for children only (relationship codes 1 or 2)
gen tempy`i'= h_03`a' if (h_04`b'==1|h_04`b'==2) // to find the youngest 
}
* Find the minimum age across all children
egen youngest_hh= rowmin(tempy*) 
drop temp*
	
	lab var youngest_hh  "Age of the youngest HH member"
	
		
**--------------------------------------
** People in HH  
**--------------------------------------

clonevar nphh=h_0150 

	lab var nphh   "Number of People in HH" 

*** New in CPF 1.52
*
forvalue i=1/15 {
local a=`i'+60
local b=`i'+20
gen tempf`i'=(h_03`a'>=70 & h_03`a'<. & (h_04`b'==1|h_04`b'==2))
gen tempg`i'=(h_03`a'>=80 & h_03`a'<. & (h_04`b'==1|h_04`b'==2))
}
egen oldern_hh70=rowtotal(tempf*)
egen oldern_hh80=rowtotal(tempg*)
drop temp*
	
	lab var oldern_hh70   "Number of people in HH aged 70+"
	lab var oldern_hh80   "Number of people in HH aged 80+"


*################################################################################
*# 
*# LABOUR MARKET SITUATION: Employment Status
*# 
*################################################################################
	
**--------------------------------------
** Currently working 
**--------------------------------------
* work_py  work_d
* p_0211 p_0202 p_0203

recode p_0203 (1=1) (-1 2/20 =0) , gen(work_d)
replace work_d=1 if p_0204==1

// 	lab var work_py "Working: last year (based on hours)"	
	lab var work_d "Working: currently (based on selfrep)" //last week
	lab val work_d yesno
	
**--------------------------------------
** Employment Status 
**--------------------------------------
/* NOTE:
Classification can differ from other specific variables (e.g. unemployed, retired),
due to prioritisation of statuses in classification rules.
*/

/*
p__0202	
	(1)  mainly working
	(2)  mainly looking after family or home, but also working
	(3)  mainly attending school or academic institutes but also working
	(4)  mainly doing activities other than household work or studying but also working
	(5)  looking after family or home
	(6)  child-caring
	(7)  attending school only
	(8)  doing nothing
	(9) other
	
p__0203	
	(1)  worked
	(2)  temporarily away from work
	(3)  searched for a job
	(4)  looked after family or home/child-caring
	(5) childcare
	(6)  attended school
	(7)  attended preparatory academic institutes to enter a school of higher grade
	(8) attended non-academic institutes or vocational training institutes for finding a job
	(9)  old age
	(10) mental/physical illness
	(11) preparation to find a job(not attending institutes)
	(12) preparation to enter a school of higher grade(not attending academic institutes or schooling)
	(13) waited for military service
	(14) waiting to be stationed at work
	(15) preparation for marriage
	(16) did not work in the past week but found a job during the period of the survey.
	(17) rest
	(18) other
	(19) quit job
	(20) worked during the past week, but quit during the week of the interview

	
p__0211	
	(1) in paid employment: employed by others or a company, receiving wages or salaries 
	(2) self-employed: own and manage my business with or without hired workers 
	(3) working for family or relatives and not paid
*/

* emplst5 - 5-category employment status classification
* Priority-based classification system that assigns individuals to their primary status
* Start with all cases as unclassified (0)
recode p_0202 (1/9=0), gen(emplst5)

* Priority 1: In education (p_0205==1 indicates currently in education)
* This takes precedence over other statuses as it's a clear educational activity
replace emplst5=4 if p_0205==1 

* Priority 2: Retired/disabled (age 50+ with retirement-related activities)
* Combines old age retirement (p_0203==19), quit job (p_0203==9), rest (p_0203==17)
* Also includes disability (p_0203==10) for those not actively seeking work
* Age 50+ requirement ensures we're capturing actual retirement rather than temporary inactivity
replace emplst5=3 if ((p_0203==19 | p_0203==9 | p_0203==17) & age>=50) | (p_0203==10 & p_0205==1 ///
			& p_2801==2 & p_2802==2 ) 

* Priority 3: In education (alternative pathway - p_5101==1 indicates educational institution)
* This captures those in education who might not be captured by p_0205
replace emplst5=5 if (p_0205==1 | p_0205==.) & p_5101==1

* Priority 4: Unemployed (actively seeking work)
* p_2801 and p_2802 indicate job search activities in the past week/month
* This identifies those who are actively looking for employment
replace emplst5=2 if (p_0205==1 | p_0205==.) & (p_2801==1 | p_2802==1)

* Priority 5: Employed (any form of work activity)
* Includes paid employment, self-employment, family work, and temporary leave
* p_0205==2 indicates temporarily away from work (still employed)
replace emplst5=1 if p_0211==1 | p_0211==2 | p_0211==3 | p_0205==2  

* Clean-up: Assign remaining unclassified cases based on their main activity
* These are cases that weren't captured by the priority system above
replace emplst5=4 if emplst5==0 & (p_0203==4 | p_0203==18)  // Not active/home activities
replace emplst5=5 if emplst5==0 &  p_0203==6               // Attending school
replace emplst5=1 if emplst5==0 & (p_0203==20 | p_0203==1) // Work activities

	lab def emplst5	///
			1 "Employed" 			/// including: leaves, Working for family or relatives and not paid
			2 "Unemployed (active)"	///
			3 "Retired, disabled"	///
			4 "Not active/home"		///  
			5 "In education"		///
			-1 "MV"
	lab val emplst5 emplst5
	lab var emplst5 "Employment status [5]"

* emplst6 - 6-category employment status (adds "on leave" as separate category)
* Creates a separate category for employed individuals who are temporarily away from work
* This provides more granular information about employment status
gen emplst6=emplst5
replace emplst6=6 if emplst6==1 & (p_0205==2)  // p_0205==2 indicates temporarily away from work

	lab def emplst6	///
			1 "Employed" 			/// including leaves
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
*# LABOUR MARKET SITUATION: Occupation, Industry, Sector
*# 
*################################################################################

**-------------------------------------- 		
** Occupation ISCO  
**--------------------------------------
* isco1 isco2
/* NOTES:
- p_0350 (old p_0332) - for all (best) KSCO 2000
- p_0351 (old p_0333) & p_0352 - only from 2009+ KSCO 2017
*/

	
*** isco_1 - 1-digit ISCO classification
* Convert Korean Standard Classification of Occupations (KSCO) 2000 to ISCO major groups
* KSCO codes are 3-digit, ISCO-08 uses 1-digit major groups (0-9)
	// 0	Legislators, Senior Officials and Managers
	// 1	Proffesionals  
	// 2	Technicians and Associate Professionals
	// 3	Clerks
	// 4	Service Workers
	// 5	Sale Workers
	// 6	Skilled Agricultural, Forestry and Fishery Workers
	// 7	Craft and Related Trades Workers
	// 8	Plant and Machine Operators and Assemblers
	// 9	Elementary Workers

* Step 1: Extract major group from KSCO code
* For codes >=100, divide by 100 to get first digit
* For codes <100, assign to group 0 (military/armed forces)
* For codes 980-989, assign to group 10 (special category)
generate ksco_1 = cond(p_0350>=100, int(p_0350 /100), .)
replace ksco_1 = 0 if p_0350<100 & p_0350>=0
replace ksco_1 = 10 if p_0350>=980 & p_0350<990
replace ksco_1 = -1 if p_0350==-1

* Step 2: Map KSCO major groups to ISCO-08 major groups
* KSCO groups: 0=Managers, 1=Professionals, 2=Technicians, 3=Clerks, 4=Service, 5=Sales, 6=Agricultural, 7=Craft, 8=Operators, 9=Elementary, 10=Armed forces
* ISCO-08 groups: 0=Armed forces, 1=Managers, 2=Professionals, 3=Technicians, 4=Clerks, 5=Services & Sales, 6=Agricultural, 7=Craft, 8=Operators, 9=Elementary
* Note: Services and Sales are combined in ISCO-08 (groups 4&5 → 5)
recode ksco_1 (0=1)(1=2)(2=3)(3=4)(4 5=5) ///
			  (6=6)(7=7)(8=8)(9=9)(10=0)(-1=-1) , gen(isco_1)

			  
*** isco_2 - 2-digit ISCO classification
* Convert KSCO to ISCO-08 sub-major groups (2-digit codes)
* This provides more detailed occupational classification

* Step 1: Extract sub-major group from KSCO code
* For codes >=100, divide by 10 to get first two digits
generate ksco_2 = cond(p_0350>=100, int(p_0350 /10), .)
replace ksco_2 = -1 if p_0350==-1

* Step 2: Manual recoding from KSCO 2-digit to ISCO-08 2-digit codes
* This mapping is based on detailed crosswalk between KSCO 2000 and ISCO-08
* Each KSCO sub-group is mapped to the most appropriate ISCO sub-group
* See excel file "KSCO_2 to isco_2.xls" for complete mapping reference
recode ksco_2	///
	(10=20)(11=21)(12=21)	///
	(13=21)(14=22)(15=23)(16=24)(17=26)(18=25)(21=32)(22=30)(23=31)(24=32)	///
	(25=30)(26=33)(27=34)(28=34)(29=30)(31=40)(32=42)(41=51)(42=50)(43=50)	///
	(44=54)(51=52)(52=52)(53=50)(61=61)(62=62)(63=62)(71=71)(72=72)(73=70)	///
	(74=70)(75=70)(81=81)(82=81)(83=82)(84=83)(91=90)(92=92)(93=90)(94=93)(98=0)	///
	, gen(isco_2)
	
* Step 3: Handle special cases for codes <100 (military and special categories)
* These codes require special handling as they don't follow the standard pattern
* Manual mapping for specific military and special occupation codes
recode p_0350 ///
(011=11)(012=11)(013=11)(021=11)(022=12)(023=13)(024=10)(030=10)(else=.), gen(temp_isco_2)
* Combine the special cases with the main recoding
replace isco_2=temp_isco_2 if temp_isco_2!=.
	drop temp_isco_2 ksco_2


*** Labels: isco_1 isco_2
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
		  
 
 
	lab val isco_1 isco_1
	lab var isco_1 "Occupation: ISCO-1digit"

	lab val isco_2 isco_2
	lab var isco_2 "Occupation: ISCO-2digit"




**--------------------------------------
** Industry 
**--------------------------------------
*  

* sector 
// p_0340 (old p_0330) - for all (best) KSIC 2000 
// p_0341 (old p_0331) - only from 2009+


*** trim
generate ksic_2 = cond(p_0340>=0, int(p_0340 /10), .)
replace ksic_2 = -1 if p_0340==-1
* recode by hand (see excel "KSIC_2 to industr.xls")

	
* Major groups 
recode ksic_2 	///
	(1=1)(2=1)(5=1)(10=1)(11=1)(12=1)(15=1)(16=1)(17=1)(18=1)(19=1)	///
	(20=1)(21=1)(22=1)(23=1)(24=1)(25=1)(26=1)(27=1)(28=1)(29=1)(30=1)(31=1)	///
	(32=1)(33=1)(34=1)(35=1)(36=1)(37=1)(40=1)(41=1)(45=1)(46=1)(50=2)(51=2)	///
	(52=2)(55=2)(60=2)(61=2)(62=2)(63=2)(64=2)(65=2)(66=2)(67=2)(70=2)(71=2)	///
	(72=2)(73=2)(74=2)(75=2)(76=3)(80=3)(85=3)(86=3)(87=2)(88=2)(90=2)(91=2)	///
	(92=2)(93=2)(95=2)(99=3)	///
	(-1 .=-1), gen(indust1)
		
lab def indust1											///
           1 "[1] Production, Construction, Heavy Ind"	///
           2 "[2] Trade and Services"					///
		   3 "[3] Public services"						///
		  -1 "[-1] MV general"							///
		  -3 "[-3] Does not apply"	  
		  
	lab val indust1 indust1		  
	lab var indust1 "Industry (major groups)" 
	
* Submajor groups 
recode ksic_2 	///
		(1=1)(2=1)(5=1)(10=3)(11=3)(12=3)(15=4)(16=4)(17=4)(18=4)(19=4)	///
		(20=4)(21=4)(22=4)(23=4)(24=4)(25=4)(26=4)(27=4)(28=4)(29=4)	///
		(30=4)(31=4)(32=4)(33=4)(34=4)(35=4)(36=4)(37=4)(40=2)(41=2)	///
		(45=5)(46=5)(50=6)(51=6)(52=6)(55=6)(60=7)(61=7)(62=7)(63=7)	///
		(64=9)(65=8)(66=8)(67=8)(70=9)(71=9)(72=9)(73=9)(74=9)(75=9)	///
		(76=9)(80=9)(85=9)(86=9)(87=9)(88=9)(90=9)(91=10)(92=9)(93=9)	///
		(95=10)(99=10) 	///
		(-1 .=-1), gen(indust2)

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
recode  ksic_2 ///
		(1=1)(2=1)(5=2)(10=3)(11=3)(12=3)(15=4)(16=4)(17=4)(18=4)(19=4)(20=4) ///
		(21=4)(22=4)(23=4)(24=4)(25=4)(26=4)(27=4)(28=4)(29=4)(30=4)(31=4)(32=4) ///
		(33=4)(34=4)(35=4)(36=4)(37=4)(40=5)(41=5)(45=6)(46=6)(50=7)(51=7)(52=7) ///
		(55=8)(60=9)(61=9)(62=9)(63=9)(64=9)(65=10)(66=10)(67=11)(70=11)(71=11) ///
		(72=11)(73=11)(74=11)(75=11)(76=12)(80=13)(85=14)(86=15)(87=9)(88=15)(90=7) ///
		(91=15)(92=7)(93=7)(95=15)(99=17)  ///
		(-1 .=-1), gen(indust3)
		
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
		  -1 "[-1] MV general"							///
		  -3 "[-3] Does not apply"	  
		  	  
	lab val indust3 indust3		  
	lab var indust3 "Industry (minor groups)"   
		  


**--------------------------------------
** Public sector
**--------------------------------------
/* NOTE:
- 4 is not precisely public
- 4 decided to be included after inspection of sectors (p_0340/p_0341)
*/
recode p_0401 (5 7=1) (1/4 6/8=0)(.=-1) , gen(public) 

/*
(1)  private company 
(2)  foreign company 
(3)  government related company (government-financed or public corporation)
(4)  a foundation or corporation
(5)  government or government branch (civil servants, military personnel, etc.)
(6)  does not belong to any specific company or institution 
(7)  civic or religious group
(8)  other
*/

	lab val public yesno
	lab var public "Public sector"

**--------------------------------------
** Size of organization	
**--------------------------------------
*size 

// clonevar size=p_0402 // many MV
// recode p_0402 (1/19=1) (20/199=2) (200/1999=3) (2000/max=4), gen(size5) // not useful 

recode p_0402 (1/9=1) (10/49=2) (50/99=3) (100/999=4) (1000/max=5), gen(size5x)
recode p_0403 (1 2=1) (3 4=2) (5 6=3) (7/9=4) (10=5) (11=-1), gen(size5y)
gen size5=size5x
replace size5=size5y if size5==.
replace size5=1 if size5==0

drop size5x size5y

//  	lab var size  "Size of organization [cont]"
// 		lab var size4 "Size of organization [4]"
// 	lab def size4 1 "<20" 2 "20-199" 3 "200-1999" 4 "2000+"  	///
// 				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
// 				-1 "-1 MV general" -2 "-2 Item non-response" 	///
// 				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val size4 size4
	
*	
	lab var size5 "Size of organization [5]"
	lab def size5 1 "<10" 2 "10-49" 3 "50-99" 4 "100-999" 5 "1000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5 size5
	
*
recode p_0402 (1/9=1) (10/49=2) (50/99=3) (100/499=4) (500/max=5), gen(size5x)
recode p_0403 (1 2=1) (3 4=2) (5 6=3) (7 8=4) (9 10=5) (11=-1), gen(size5y)
gen size5b=size5x
replace size5b=size5y if size5==.
replace size5b=1 if size5b==0

drop size5x size5y

	lab var size5b "Size of organization [5b]"
	lab def size5b 1 "<10" 2 "10-49" 3 "50-99" 4 "100-499" 5 "500+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5b size5b
	
*################################################################################
*# 
*# LABOUR MARKET SITUATION: Working hours, contract, other aspects of employment
*# 
*################################################################################

**-------------------------------------- 		
** Hours contracted
**--------------------------------------
* wh_ctr

clonevar whweek_ctr=p_1006 // fixed - regular wh
replace whweek_ctr=-2 if p_1003==2 // no fixed hours
	
	lab var whweek_ctr "Work hours per week: conracted"
	lab def whweek_ctr -2 "No fixed hours" 

**--------------------------------------
** Hours worked
**--------------------------------------
* wh_real wh_year
/*NOTE:
- for workers with fixed time: regular time + overtime
- for workers without fixed time: average working time 
*/

* Convert missing value codes to system missing for proper calculations
mvdecode p_1004 p_1006  p_1012 , mv(-1=.a)

* Calculate weekly working hours based on different employment arrangements
* Scenario 1: Workers with fixed hours who have overtime (p_1003==1 & p_1011==2)
* Add regular hours (p_1006) and overtime hours (p_1012)
egen 	whweek=rowtotal(p_1006 p_1012) 		if p_1003==1 & p_1011==2 

* Scenario 2: Workers with monthly overtime (p_1019==2)
* Convert monthly overtime to weekly equivalent (divide by 4.3 weeks per month)
* Add to regular weekly hours
replace whweek=p_1006+(p_1012/4.3) 	if p_1019==2 & p_1012<.   // month to week

* Scenario 3: Workers with fixed hours but no overtime (p_1003==1 & p_1011==1)
* Use only regular weekly hours
replace whweek=p_1006 				if p_1003==1 & p_1011==1

* Scenario 4: Workers without fixed hours (p_1003==2)
* Use reported average working hours (p_1004)
replace whweek=p_1004 				if p_1003==2

* Restore missing value codes for consistency
mvencode  p_1004 p_1006  p_1012 , mv (.a=-1)

* Convert weekly hours to monthly hours for alternative time unit
* Multiply by 4.3 (average weeks per month)
* Preserve negative values (missing value codes) without conversion
gen whmonth=whweek*4.3
replace whmonth=whweek if whweek <0

// gen whyear=whmonth*12
// replace whyear=whmonth if whmonth <0

// 		lab var whday "Work hours per day: worked"
		lab var whweek "Work hours per week: worked"
		lab var whmonth "Work hours per month: worked"
// 		lab var whyear "Work hours per year: worked"
 
 

**-------------------------------------- 
** Full/part time
**--------------------------------------
* fptime_r fptime_h
recode p_0315 (2=1) (1=2) , gen(fptime_r)
replace fptime_r=3 if emplst5!=1

*
gen fptime_h=.
replace fptime_h=1 if whweek>=35 & whweek<.
replace fptime_h=2 if whweek<35 & whweek>0
replace fptime_h=3 if whweek==0
replace fptime_h=3 if emplst5>1 & emplst5<.

	lab def fptime_r 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other"
	lab val fptime_r fptime_h fptime
	
	lab var fptime_r "Employment Level (self-report)"
	lab var fptime_h "Employment Level (based on hours)"

**-------------------------------------- 
** Overtime working 
**--------------------------------------
 * p_1011 ; p_1012
 
 
**-------------------------------------- 
** Supervisor 	NA
**--------------------------------------
* supervis
// 	p_0714 - 2000 only
//	
// 	lab val supervis yesno
// 	lab var supervis "Supervisory position"
	
**--------------------------------------
** Parental leave  
**--------------------------------------
/*NOTE:
- small numbers of users 
- combines social insurance (v.small numbers) and company-provided maternity leave
- "1" indicates that was used in the last year (not necessarily currently)
*/
recode p_2142 (-1 1 2 3=0),gen(temp_mater1) // social insurance 
foreach n in 5 6 7 8 {
	replace temp_mater1=1 if p_21`n'1==15 // & p_21`n'5==2 --> currently used (v.small n)
 }
*
recode p_4109 (-1 1 2 3=0), gen(temp_mater2) // company-provided 
replace temp_mater2=1 if p_4163>0 & p_4163<.
 
gen 	mater=temp_mater2
replace mater=temp_mater1 if mater==. | mater==0

drop temp_mater*

	lab val mater yesno
	lab var mater "Parental leave   "
	


*################################################################################
*# 
*# LABOUR MARKET SITUATION: Currently unemployed
*# 
*################################################################################

**--------------------------------------
** Unempl: registered  NA
**--------------------------------------
* un_reg

// 	lab val un_reg yesno
// 	lab var un_reg "Unemployed: registered"
 
**--------------------------------------
** Unempl: reason  NA
**--------------------------------------
* 
/*Notes: 
- create set of categories if harmon possible
*/
 

**-------------------------------------- 
** Unempl: actively looking for work 
**--------------------------------------
* un_act
* p_0203== 3 / 11 // unempl status main last week

recode p_0202 (1/9=0), gen(un_act)
replace un_act=1 if (p_2801==1 | p_2802==1) & p_0205==1   // searched last week / last month
replace un_act=1 if (p_2801==1 | p_2802==1) & p_0205==. & ///
			p_0211!=1 & p_0211!=2 & p_0211!=3 & p_0205!=2
 
	lab val un_act yesno
	lab var un_act "Unemployed: actively looking for work "


*################################################################################
*# 
*# LABOUR MARKET SITUATION: Self-employment, entrepreneur
*# 
*################################################################################

**-------------------------------------- 
** Self-employed	 
**--------------------------------------
* selfemp v1-v3 
* job class 3 & 7 
recode p_0202 (1/9=0), gen(selfemp)
replace selfemp=1 if p_0211==2
replace selfemp=1 if pa_5501==1 // free-lancer
replace selfemp=1 if p_0314==4  // employer/self employed


 
	lab val   selfemp   yesno
// 	lab var selfemp_v1 "Self-employed 1: all without Family Business"
	lab var selfemp "Self-employed 2: all with Family Business"
// 	lab var selfemp_v3 "Self-employed 3: based on income from self-empl"


 
		
**--------------------------------------
** Entrepreneur 
**-------------------------------------- 
* entrep
* job class 3 & 7 
gen entrep2=selfemp
replace entrep2=0 if p_0409!=1 & selfemp==1
 
//    	lab val entrep yesno
//   	lab var entrep  "Entrepreneur (not farmer; has employees)"
 
	lab val entrep2 yesno
	lab var entrep2 "Entrepreneur (incl. farmers; has employees)"


**--------------------------------------
** Number of employees 
**--------------------------------------

recode entrep2 (0=-3) (1=-1), gen(nempl)

replace nempl=1 if entrep2==1 & (p_0402>=1 & p_0402<10)
replace nempl=2 if entrep2==1 & (p_0402>=10 & p_0402<.)

replace nempl=1 if entrep2==1 & (p_0403>=1 & p_0403<=2)
replace nempl=2 if entrep2==1 & (p_0403>=3 & p_0403<11)



	lab def nempl 1 "1-9" 2 "10+" 	///
		-1 "-1 MV general" -2 "-2 Item non-response" 	///
		-3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	lab val nempl nempl
	lab var nempl "Number of employees (entrepreneurs)"
		
*################################################################################
*# 
*# RETIREMENT
*# 
*################################################################################

**-------------------------------------- 
** Fully retired - identification
**--------------------------------------
/* retf - Criteria for retirement identification:
- Not working (no current employment)
- Self-categorisation as retired & age 50+ 
- Receives old-age pension & age 50+
- Age 65+ & not active

This multi-criteria approach ensures comprehensive identification of retired individuals
while avoiding misclassification of temporarily inactive working-age individuals.
*/

* Start with all individuals as not retired (0)
recode p_0202 (1/9=0), gen(retf)

* Criterion 1: Self-reported retirement activities (age 50+)
* p_0203 codes: 19=old age, 9=quit job, 17=rest
* Only applies to individuals aged 50+ to avoid misclassifying young people who quit jobs
* Must also not be currently working (p_0211 codes 1-3 indicate employment, p_0205==2 indicates leave)
replace retf=1 if (p_0203==19 | p_0203==9 | p_0203==17) 		/// old age, quit, rest 
				& age>=50 & 									/// age 50+
				p_0211!=1 & p_0211!=2 & p_0211!=3 & p_0205!=2	// NW, no job

* Criterion 2: Receiving old-age pension (age 50+)
* Check if receiving any form of old-age pension (p_2151, p_2161, p_2171, p_2181)
* Pension codes 1,3,5,6,7,8,17 indicate old-age related benefits
* Must be aged 50+ and not currently working
egen temp=anymatch (p_2151 p_2161 p_2171 p_2181), val(1 3 5 6 7 8 17)	// old-age pension 
replace retf=1 if temp==1 & age>=50 & 									/// old-age pension & age 50+ & NW
				p_0211!=1 & p_0211!=2 & p_0211!=3 & p_0205!=2

* Criterion 3: Age-based retirement (65+)
* Standard retirement age threshold
* Must not be currently working
replace retf=1 if age>=65 & 									/// age 65+ & NW, no job
				p_0211!=1 & p_0211!=2 & p_0211!=3 & p_0205!=2	  

	lab var retf "Retired fully"
	lab val retf yesno 

	
	
**-------------------------------------- 
** Age of retirement  
**--------------------------------------					  
*   
 	

**--------------------------------------
** Receiving old-age pension   
**--------------------------------------					  
* oldpens  
/*Note: 
- not many cases; read carefully quest and definitions before using 
*/								  
egen oldpens=anymatch (p_2151 p_2161 p_2171 p_2181), val(1 3 5 6 7 8 17)				  
	lab var oldpens "Receiving old-age pension"
	lab val oldpens yesno 
	
 
**-------------------------------------- 
** Receiving disability pension   
**--------------------------------------		
* disabpens
egen disabpens=anymatch (p_2151 p_2161 p_2171 p_2181), val(2)				  

	lab var disabpens "Receiving disability pension"
	lab val disabpens yesno 
	

*################################################################################
*# 
*#    WORK HISTORY
*# 
*################################################################################

**-------------------------------------- 
**   Labor market experience full time
**--------------------------------------
* expft
// 	lab var expft "Labor market experience: full time"

	**--------------------------------------
**   Labor market experience part time 
**--------------------------------------
* exppt

// 	lab var exppt "Labor market experience: part time"
	
**--------------------------------------
**   Total Labor market experience (full+part time) 
**--------------------------------------
* exp	
// 	lab var exp "Labor market experience"

**--------------------------------------
**   Experience in org
**-------------------------------------- 
* exporg
 	
// 	lab var exporg "Experience in organisation"
	
**--------------------------------------
**   Never worked
**--------------------------------------	
*neverw

// 	lab var neverw "Never worked"
// 	lab val neverw yesno
	



*################################################################################
*# 
*#    INCOME AND WEALTH
*# 
*################################################################################

**--------------------------------------  
**   Work Income - detailed
**--------------------------------------

*** whole income (jobs, benefits)

// 	lab var inctot_yn "Individual Income (All types, year, net)"
// 	lab var inctot_mn "Individual Income (All types, month, net)"

	
*** all jobs 
/*NOTE:
Before using:
- incjobs_yn & incjob1_yn differ sliglty for some cases. 
- differnt structure of MV - best to combine before using
- p_1702 - (All Respondents, last year) Total pre-tax yearly earned income (unit: KRW 10,000)
- p_1703 -  (All Respondents, last year) Total after-tax yearly earned income (unit: KRW 10,000) 
*/
clonevar incjobs_pyg=p_1702
clonevar incjobs_pyn=p_1703

recode incjobs_pyn (-1=.)

	lab var incjobs_pyg "Individual Labor Earnings (All jobs, prev. year, gross)"
 	lab var incjobs_pyn "Individual Labor Earnings (All jobs, prev. year, net)"

*** main job
// in 10,000 KRW

/*
	-- p__1642 (Main Job) (Wage Worker) Amount of average monthly pay (unit: KRW 10,000)-
	-- p__1642 - only includes the wage information for wage-worker (employee),  
	-- p__1642 is net income, so you need to add p__1643 to p__1642 to get a gross income. 
	-- p__1672 - only includes the wage information for self-employed worker, such as employer, 
		-- own=account worker, or unpaid family worker. 
*/

/*NOTE:
Before using:
- incjobs_yn & incjob1_yn differ sliglty for some cases. 
- differnt structure of MV - best to combine before using
*/

clonevar incjob1_mn= p_1642 
replace incjob1_mn=0 if p_1641==2
replace incjob1_mn=p_1672 if p_1672<. & p_1672>0 & incjob1_mn==.
 
gen incjob1_cyn=incjob1_mn*12 if incjob1_mn>=0


 	lab var incjob1_cyn  "Salary from main job (current year-estimated, net)"
 	lab var incjob1_mn "Salary from main job (month, net)"	
*
**--------------------------------------
*   HH income
**--------------------------------------
* hhinc_pypre
* hhinc_pypost 

* Based on KLIPS FAQ:
* Convert missing value codes (-1) to system missing for proper calculation
* This ensures that missing values don't interfere with income calculations
mvdecode 	h_2102 h_2112 h_2113 h_2114 h_2115 h_2116	 	///
			h_2122 h_2123 h_2126 h_2124 h_2125 				///
			h_2134 h_2136 h_2138 h_2140 h_2142				///
			h_2152 h_2154 h_2155 h_2156 h_2153 h_2157 h_2158 h_2159 h_2160	/// 
			h_2186 h_2187 h_2183 h_2184 h_2185 h_2188 h_2189 h_2190 h_2191 	///	
			h_4002 				///	
			, mv(-1=.a) 

* Sums of each income sub-category
* Create total income by source type for comprehensive household income calculation

* Earned income: Wages, salaries, and business income
gen t_inc_e=h_2102 /*earned income*/

* Financial income: Interest, dividends, and other financial returns
* Combines multiple financial income sources (h_2112-h_2116)
egen t_inc_m=rowtotal(h_2112 h_2113 h_2114 h_2115 h_2116) ,missing /*financial income*/

* Real estate income: Rental income and property-related earnings
* Combines various real estate income sources (h_2122-h_2125, h_2126)
egen t_inc_p=rowtotal(h_2122 h_2123 h_2126 h_2124 h_2125 ) ,missing /*real estate income*/

* Social insurance income: Pensions, unemployment benefits, and social transfers
* Combines different social insurance benefits (h_2134, h_2136, h_2138, h_2140, h_2142)
egen t_inc_i=rowtotal(h_2134 h_2136 h_2138 h_2140 h_2142) ,missing /*social insurance*/

* Transfer income: Other government transfers and assistance
* Combines various transfer payments (h_2152-h_2160, h_4002)
egen t_inc_t=rowtotal(h_2152 h_2154 h_2155 h_2156 h_2153 h_2157 h_2158 h_2159 h_2160 h_4002) ,missing /*transfer income*/

* Other income: Miscellaneous income sources
* Combines other income sources (h_2186-h_2191)
egen t_inc_o=rowtotal(h_2186 h_2187 h_2183 h_2184 h_2185 h_2188 h_2189 h_2190 h_2191) ,missing /*other income*/

* existence of each type of income 
	// gen t_inc_ey=h_2101
	// gen t_inc_my=h_2111
	// gen t_inc_py=h_2121
	// gen t_inc_iy=h_2131
	// gen t_inc_ty=1 if h_2151==1|h_4001==1
	// replace t_inc_ty=2 if h_2151==2&h_4001==2
	// gen t_inc_oy=h_2181
	
* Annual total household income
* Sum all income components to create comprehensive household income measure
* Missing values are handled appropriately (households with missing components get missing total)
egen hhinc_pypost=rowtotal(t_inc_e t_inc_m t_inc_p t_inc_i t_inc_t t_inc_o) ,mis
drop t_in*

* Restore missing value codes for consistency with original data structure
mvencode 	h_2102 h_2112 h_2113 h_2114 h_2115 h_2116	 	///
			h_2122 h_2123 h_2126 h_2124 h_2125 				///
			h_2134 h_2136 h_2138 h_2140 h_2142				///
			h_2152 h_2154 h_2155 h_2156 h_2153 h_2157 h_2158 h_2159 h_2160	/// 
			h_2186 h_2187 h_2183 h_2184 h_2185 h_2188 h_2189 h_2190 h_2191 	///	
			h_4002 				///	
			, mv(.a=-1) 
			
//  	lab var hhinc_pypre 	 "HH income(prev. year, pre)"	
		lab var hhinc_pypost "HH income(prev. year, post)"	

	
**--------------------------------------
*   HH income - equivalized 
**--------------------------------------

* Set negative values to zero
recode hhinc_pypost (min/0=0), gen (temp_hhinc_pypost)
recode nphh (min/0=.), gen(temp_nphh)
recode kidsn_hh17 (min/0=0), gen(temp_kidsn_hh17)

* Check if the number of people in the household is consistent with the number of children aged 0-17
gen temp_err = temp_nphh-temp_kidsn_hh17
recode temp_err (min/-1=-1) (0/20=1)
tab temp_err

*** Equivalized HH income
gen hhinc_pypost_eq = temp_hhinc_pypost/(1 + .5*(temp_nphh - temp_kidsn_hh17 - 1) + .3*temp_kidsn_hh17) if temp_err==1
	drop temp*
lab var hhinc_pypost_eq "HH income(prev. year, post, equivalized)"
	
**--------------------------------------
**   Income - subjective 
**--------------------------------------
* incsubj9
// h_2705 - hh current financial condition
 
// 	lab var incsubj9 "Income: subjective rank [9]"
// 	lab def incsubj9 1 "Lo step" 9 "Hi step" 
// 	lab val incsubj9 incsubj9


*################################################################################
*# 
*#    HEALTH STATUS
*# 
*################################################################################

**-------------------------------------- 
**  Self-rated health 
**--------------------------------------
* srh
/** New CPF 2.0 scale labels 
KLIPS original scale labels --> New CPF 2.0 scale labels:
 (1) Excellent --> Excellent
 (2) Good --> Very good
 (3) Fair --> Good
 (4) Poor --> Fair
 (5) Very poor --> Poor
*/

gen srh5 = p_6101  

	lab var srh5 "Self-rated health"
	lab def srh5 5 "Poor" 4 "Fair" 3 "Good" 2 "Very good" 1 "Excellent"
	lab val srh5 srh5

**--------------------------------------
**  Disability NA, asked only in one wave
**--------------------------------------
* disab

// only pension: p_2151 itd ==2

// 	lab var disab	"Disability (any)"
// 	lab var disab2c "Disability (min. category 2 or >30%)"
// 	lab val disab disab2c yesno
//	
	
**--------------------------------------
**  Chronic diseases NA, asked only in one wave 
**--------------------------------------
* chron

// 	lab var chron	"Chronic diseases"
// 	lab val chron   yesno


*################################################################################
*# 
*#    SUBJECTIVE WELLBEING
*# 
*################################################################################

**--------------------------------------
**   Satisfaction with  
**--------------------------------------
* sat_life sat_work sat_fam sat_finhh sat_finind sat_hlth

	lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" 	///
				 4  "4 Mostly sat" 5 "5 Completely sat"						///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 		///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	 

	lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
 


* Recode   5-point into 10-point versions (and reverse) / must modify
 tokenize "p_6508 p_6501 p_6504 p_4311 p_4321"
	 foreach var in satlife satfinhh satfam satinc satwork {
		 recode  `1' (1=5) (2=4) (3=3) (4=2) (5=1) (999/max=-1), gen(`var'5)
		 recode  `1' (1=10) (2=7) (3=5) (4=3) (5=0) , 	 gen(`var'10)
		 	 lab val `var'5  sat5
			 lab val `var'10 sat10
	 macro shift 1  
 }

*** Alternatives:
* work sat: p_4301 and a few other following
// clonevar sat_work5=p_4301
// recode p_4301 (1=0)  (2=3) (3=5) (4=7) (5=10), 	 gen(sat_work10)
// 		 	 lab val sat_work5  sat5
// 			 lab val sat_work10 sat10
* work sat: p_4322



*################################################################################
*# 
*#    OTHER
*# 
*################################################################################

**-------------------------------------- 
**   Training
**--------------------------------------	
* train train2
// p_4501==2 // now
// p_4512 // from y
// p_4516 // to y

gen train=1 if p_4501==2
replace train=1 if p_4516==wavey 
replace train=1 if p_4556==wavey 
replace train=1 if p_4596==wavey 
replace train=1 if p_4516==wavey-1 & p_4517>=h_9102 // last 12 months before interview 
replace train=1 if p_4556==wavey-1 & p_4557>=h_9102 // last 12 months before interview 
replace train=1 if p_4596==wavey-1 & p_4597>=h_9102 // last 12 months before interview 
replace train=1 if p_4515==2
replace train=1 if p_4555==2
replace train=1 if p_4595==2
recode train(.=0)

	lab val train yesno
	lab var train "Training (previous year)"

**--------------------------------------
**   work-edu link
**--------------------------------------
* eduwork

recode p_4401 (1 2 4 5=0) (3 =1) if wavey>1999, gen( eduwork)
replace eduwork=0 if p_4401==1 & wavey==1999
replace eduwork=1 if (p_4401==2|p_4401==3) & wavey==1999

	lab var eduwork "Work-education skill fit"
	lab def eduwork 0 "0 Poor" 1 "1 Good" ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val eduwork eduwork
	
	
**--------------------------------------
**   Qualifications for job
**--------------------------------------
* wqualif

recode p_4402 (1 2=1) (3=2) (4 5=3) if wavey>1999, gen( wqualif)
replace wqualif=1 if p_4402==1 & wavey==1999
replace wqualif=2 if p_4402==2 & wavey==1999
replace wqualif=3 if p_4402==3 & wavey==1999

	lab var wqualif "Qualifications for job"
	lab def wqualif 1 "1 Underqualified/Not qualified" 2 "2 Qualified (fit)" 3 "3 Overqualified" ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val wqualif wqualif
	
	
**--------------------------------------
**   Volunteering NA
**--------------------------------------
* volunt

// 	lab val volunt yesno
// 	lab var volunt "Volunteering"
	
	
**-------------------------------------- 
**   Job security
**--------------------------------------
*  
recode p_4312 (1 2 3=0) (4 5=1) , gen(jsecu)
recode p_4312 (1 2=0) (4 5=1) (3=2), gen(jsecu2)

	lab def jsecu 	 1 "Insecure" 0 "Secure"  ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab def jsecu2 	 1 "Insecure" 0 "Secure" 2 "Hard to say" ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab var jsecu "Job insecurity [2]"
	lab var jsecu2  "Job insecurity [3]"

	lab val jsecu jsecu
	lab val jsecu2 jsecu2

*################################################################################
*# 
*#    SES Indices
*# 
*################################################################################

**--------------------------------------
**   Occupational status (ISEI)
**--------------------------------------
* isei 
gen temp_isco4=isco_2*100
iscogen isei08 = isei(temp_isco4)

	lab var isei08 "ISEI-08: International Socio-Economic Index of occupational status"

iscogen isei88 = isei(temp_isco4), from(isco88)
	lab var isei88 "ISEI-88: International Socio-Economic Index of occupational status"
	
*  -specific scale provided by  
// p__6615 - current perceived economic status
 
	
	
**--------------------------------------
**   Treiman's international prestige scale (SIOPS) 
**--------------------------------------
iscogen siops08 = siops(temp_isco4)

	lab var siops08 "SIOPS-08: Treiman's international prestige scale" 

iscogen siops88 = siops(temp_isco4) , from(isco88)
	lab var siops88 "SIOPS-88: Treiman's international prestige scale" 

**--------------------------------------
*** MPS (German Magnitude Prestige Scale; Christoph 2005)
**--------------------------------------	
iscogen mps88 = mps(temp_isco4) , from(isco88) 
	lab var mps88 "MPS: German Magnitude Prestige Scale" 
	drop temp_isco4	
	
**--------------------------------------
**   EGP / ESEC
**--------------------------------------	
// 	iscogen EGP = egp11(job selfemp nemployees), from(isco88)
//
// 	 oesch
	 
	 
*################################################################################
*# 
*#    PARENTS
*# 
*################################################################################


**--------------------------------------  
**   Parents' education
**--------------------------------------
// (1) no schooling
// (2) elementary school
// (3) middle school
// (4) high school
// (5) community college
// (6) college/ university
// (7) graduate degree

	 
*** Father 
*edu3
recode p_9051 (1 2=1)(3 4=2) (5/7=3), gen(fedu3)

	lab val fedu3 edu3
	lab var fedu3 "Father's education: 3 levels"

* edu4
recode p_9051 (1 2=1)(3=2) (4=3) (5/7=4), gen(fedu4)

	lab val fedu4 edu4
	lab var fedu4 "Father's education: 4 levels"
	

*** Mother 
*edu3
recode p_9053 (1 2=1)(3 4=2) (5/7=3), gen(medu3)

	lab val medu3 edu3
	lab var medu3 "Mother's education: 3 levels"

	
* edu4
recode p_9053 (1 2=1)(3=2) (4=3) (5/7=4), gen(medu4)

	lab val medu4 edu4
	lab var medu4 "Mother's education: 4 levels"
	
*** Fill MV based on other waves 
	foreach p in f m  			{    
	foreach e in 3 4  			{
	bysort pid: egen `p'temp`e'=max(`p'edu`e') 
	bysort pid (wave): replace `p'edu`e'=`p'temp`e' if (`p'edu`e'<0 | `p'edu`e'==.)  
	drop `p'temp`e'
	}
	}

**--------------------------------------  
**   Parents' occupation
**--------------------------------------
*** Father 

*** Mother  

**--------------------------------------  
**   Parents' SES
**--------------------------------------
*** Father 

*** Mother  

*################################################################################
*# 
*#    ETHNICITY
*# 
*################################################################################
//Not available for KLIPS

*################################################################################
*# 
*#    MIGRATION
*# 
*################################################################################

**--------------------------
**   Migration Background 
**--------------------------

*** migr - specifies if respondent foreign-born or not.
* Multi-step process to identify foreign-born individuals
* Uses both place of birth (p_9001) and country of residence at age 14 (p_9005)
lab def migr ///
0 "Native-born" ///
1 "Foreign-born" ///
-1 "MV general" ///
-2 "DK/refusal" ///
-3 "NA" ///
-8 "not asked in survey"

gen migr=.

* Step 1: Primary classification based on place of birth (p_9001)
* Codes 1-16: South Korean cities and provinces (native-born)
* Code 17: North Korea (foreign-born)
* Code 18: Overseas (foreign-born)
replace migr=0 if inrange(p_9001, 1, 16) // South Korean city or province
replace migr=1 if p_9001==17 // North Korea
replace migr=1 if p_9001==18 //Overseas

* Step 2: Secondary classification based on country of residence at age 14 (p_9005)
* This captures individuals who may have been born in Korea but lived abroad during childhood
* Codes 1-42 represent different countries (excluding code 16 which is "Don't know")
* Only applies to cases not already classified by place of birth
replace migr=1 if migr==. & inrange(p_9005, 1, 42) & p_9005!=16

lab val migr migr

* Step 3: Fill missing values using mode across waves
* This handles cases where migration status varies across waves due to reporting inconsistencies
* Uses mode function to identify the most common response for each individual
bysort pid: egen temp_migr=mode(migr), maxmode // identify most common response
replace migr=temp_migr if migr==. & temp_migr>=0 & temp_migr<.
replace migr=temp_migr if migr!=temp_migr // correct a few inconsistent cases

* Step 4: Specify missing values for cases with missing birth information
* Only assign missing value codes when the source variables are actually missing
replace migr=-1 if migr==. & (p_9001==-1 | p_9005==-1)


**-------------------
**   COB respondent
**-------------------	
/// NOTE: item asks specific country where respondent lived at age 14 IF born in foreign country

label define COB ///
0 "Born in Survey-Country" ///
1 "Oceania and Antarctica" ///
2 "North-West Europe" ///
3 "Southern and Eastern Europe" ///
4 "North Africa and the Middle East" ///
5 "South-East Asia" ///
6 "North-East Asia" ///
7 "Southern and Central Asia" ///
8 "Americas" ///
9 "Sub-Saharan Africa" ///
10 "Other" ///
-1 "MV general" ///
-2 "DK/refusal" ///
-3 "NA" ///
-8 "not asked in survey"

gen cob_rt=. // temp working var
	replace cob_rt=6 if p_9005==1 //China
	replace cob_rt=2 if p_9005==2 //Germany
	replace cob_rt=6 if p_9005==3 //Japan
	replace cob_rt=2 if p_9005==4 //England
	replace cob_rt=5 if p_9005==7 //Thailand
	replace cob_rt=8 if p_9005==8 //USA
	replace cob_rt=6 if p_9005==9 //Taiwan
	replace cob_rt=8 if p_9005==10 //Paraguay
	replace cob_rt=8 if p_9005==12 //Canada
	replace cob_rt=8 if p_9005==13 //Saipan
	replace cob_rt=3 if p_9005==19 //Russia
	replace cob_rt=1 if p_9005==25 //NZ
	replace cob_rt=5 if p_9005==27 //Philippines
	replace cob_rt=6 if p_9005==30 //Mongolia
	replace cob_rt=5 if p_9005==31 //Malaysia
	replace cob_rt=5 if p_9005==32 //Vietnam
	replace cob_rt=6 if p_9005==35 //North Korea
	replace cob_rt=5 if p_9005==36 //Cambodia
	replace cob_rt=7 if p_9005==37 //Bangladesh
	replace cob_rt=7 if p_9005==38 //Nepal
	replace cob_rt=5 if p_9005==39 //Cambodia
	replace cob_rt=7 if p_9005==40 //Pakistan
	replace cob_rt=5 if p_9005==41 //Singapore
	replace cob_rt=-1 if p_9005==16 //DK
	replace cob_rt=-1 if p_9005==-1 //MV
	replace cob_rt=6 if (p_9005==. | p_9005<0) & p_9001==17 //North Korea 
	replace cob_rt=0 if migr==0 //native-born (i.e. cob = South Korea)
	replace cob_rt=10 if migr==1 & (p_9005==. | p_9005==-1) // foreign not specified

*fill MV: Identify valid COB and fill across waves  
sort pid wave 

*** Generate valid stage 1 - mode across the waves (values 1-10)
	// It takes the value of the most common valid answer between 1 and 10 
	// If there is an equal number of 2 or more answers, it returns "." - filled in next steps
	
	bysort pid: egen mode_cob_rt=mode(cob_rt)
	
*** Generate valid stage 2 - first valid answer provided (values 1-9)
	// It takes the value of the first recorded answer between 1 and 9 (so ignores 10 "other")
	// These are used to fill COB in cases: 
	//	(a) equal number of 2 or more answers (remaining MV)
	//	(b) there is a valid answer other than 10 but the mode (stage 1) returns 10
	
	by pid (wave), sort: gen temp_first_cob_rt=cob_rt if sum(inrange(cob_rt, 1, 9)) ==1 & sum(inrange(cob_rt[_n - 1], 1, 9)) == 0 //identify first valid answer in range 1-9
	bysort pid: egen first_cob_rt=max(temp_first_cob_rt) // copy across waves within pid
	drop temp_first_cob_rt
	

*** Fill the valid COB across waves
	gen cob_r = mode_cob_rt  // stage 1 (mode)
	replace cob_r = first_cob_rt if cob_r==. & inrange(first_cob_rt, 1, 9) // stage 2 - based on first for MV
	replace cob_r = first_cob_rt if cob_r==10 & inrange(first_cob_rt, 1, 9) // stage 2 - based on first for other
	drop cob_rt
	
*specify some missing values
replace cob_r=-1 if cob_r==. & (p_9001==-1 | p_9005==-1)
	
	label values cob_r COB
	rename cob_r cob
	
**--------------------------------------
**   Migrant Generation (respondent)
**--------------------------------------	
	//Not available (no information parents) 
	
**--------------------------------------------
**   Mother tongue / language spoken as child
**--------------------------------------------	
	//Not available
	
*################################################################################
*# 
*#    RELIGION
*# 
*################################################################################

**--------------------------------------  
** Religiosity
**--------------------------------------

lab def relig ///
0 "Not religious/Atheist/Agnostic" ///
1 "Religious" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey" ///

recode p_9031 (1=0) (2/10=1) (-1=-1) (.=-2), gen(relig)

*asked only of new respondents in wave 1-11
replace relig=-8 if relig==. & wavey<2009

lab val relig relig

**--------------------------------------  
** Religion - Attendance
**--------------------------------------
//note: Not available for harmonization
//Alternative item "active participation in religious activity" is available but not included in relig_att

lab define relig_KOR ///
1 "very actively" ///
2 "actively in general" ///
3 "not very actively" ///
4 "not actively at all" ///
-1 "MV general" ///
-8 "Question not asked in survey" ///


clonevar relig_KOR=p_9032 

*asked of all respondents from wave 12 onwards
replace relig_KOR=-8 if wavey<2009

lab val relig_KOR relig_KOR



*################################################################################
*# 
*#    WEIGHTS
*# 
*################################################################################

**--------------------------------------
**   Cross-sectional sample weight
**--------------------------------------	

// gen wtcs= 
 
  
**--------------------------------------
**   Cross-sectional population weight
**--------------------------------------	

gen wtcp=w_p 					// c-s weight for original sample 98  
replace wtcp=w_p_c if wave>=2 	// c-s weight for further waves 


gen wtcp2=sw_p 					 // Consolidated sample for 2009 
replace wtcp2=sw_p_c if wave>=13 // Consolidated sample for 2010+ 



**--------------------------------------
**   Longitudinal Weight
**--------------------------------------		 
	
**--------------------------------------
**   Sample identifier
**--------------------------------------	

gen sampid_klips1 = sample98 
gen sampid_klips2 = sample09
lab var sampid_klips1 "Sample identifier: KLIPS - 98"
lab var sampid_klips2 "Sample identifier: KLIPS - consolidated"

lab def sampid_klips1	///
	1 "98 sample original household"	///
	2 "branch household from '98 original sample"	///
	3 "not interview target"

lab def sampid_klips2	///
	1 "original consolidated sample household"	///
	2 "branch household from consolidated sample household"	///
	3 "not interview target"

lab val sampid_klips1 sampid_klips1
lab val sampid_klips2 sampid_klips2





*################################################################################
*# 
*#    KEEP
*# 
*################################################################################

keep    														///
wave pid intyear intmonth country respstat                                      ///
age place*    edu* female                                ///
marstat* mlstat* livpart nvmarr				///
sat* size* inc* hhinc* selfemp* entrep*  train*                ///
kids* yborn  nphh work_d empls* public                           ///
whweek*  whmonth mater un_* oldpens retf* disabpens   				///
fptime*   disab* eduwork* wqualif jsecu*                         ///
w_* sw_*        /// weights
jobclass* jobtype* hid hhid* orghid* /// other 
p_0350  p_0351 /// isco
p_0340 p_0341 /// sector 
isco* indust* 	ksco* wavey wave1st srh*	///
p_9509	/// interveiw results 
h_0261 h_0262 h_0263 h_0264 h_0265 h_0266 h_0267 h_0268 h_0269 h_0270 h_0271 h_0272 h_0273 h_0274 h_0275 /// relation to head 
isei* siops* mps* wtcp*  nempl	///
migr* cob* relig* /// migration & religion
widow divor separ fedu* medu*   sampid* ///
kidsn_hh_02 kidsn_hh_34 kidsn_hh_04 kidsn_hh_510 ///
kids_hh_04 youngest_hh oldern_hh70 oldern_hh80



*################################################################################
*# 
*#    SAVE
*# 
*################################################################################

 
label data "CPF_Korea v2.0"

save "${klips_out}/ko_02_CPF.dta", replace  	


* Close log
display "Completed KLIPS data harmonization at $S_TIME"
log close

*____________________________________________________________________________
*--->	END	OF FILE <---

