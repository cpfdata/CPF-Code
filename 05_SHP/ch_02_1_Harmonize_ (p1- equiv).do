*
**|=========================================|
**|	    ####	CPF	v1.5		####		|
**|		>>>	SHP						 		|
**|		>>	03_ Prepare data - pequiv		|
**|-----------------------------------------|
**|		Konrad Turek 	| 	2023			|
**|=========================================|
*


**--------------------------------------
** Open merged dataset
**-------------------------------------- 
*** CNEF
use "${shp_out}\ch_01_shpequivL.dta", clear




*############################
*#							#
*#	Vars					#
*#							#
*############################

// numlabel, add
**--------------------------------------
** Common lables 
**-------------------------------------- 
lab def yesno 0 "[0] No" 1 "[1] Yes" ///
	-1 "-1 MV general" -2 "-2 Item non-response" ///
	-3 "-3 Does not apply" -8 "-8 Question not asked in survey", replace

	


*################################
*#								#
*#	Technical					#
*#								#
*################################	
* pid
* intyear 
* wave 

rename  x11101ll pid
rename  x11102 hid
// rename   wave
rename wave intyear
egen wave = group(intyear)
gen wavey=intyear

gen country=5


sort pid wave

*** Repsondent status 
recode status (0 1=1) (2=2), gen(respstat2)
	lab def respstat2 	1 "Interviewed" 					///
						2 "Not interviewed (has values)" 	///
						3 "Not interviewed (no values)"
	lab val respstat respstat2
	
*** 1st wave included
* NOTE: Includes grid-only respondents as valid interviews (becouse have some values)					
bysort pid: egen wave1st = min(wave)


*################################
*#								#
*#	Socio-demographic basic 	#
*#	Family and relationships	#
*#								#
*################################
**--------------------------------------
** Demographic
**--------------------------------------
* age
// rename d11101 age

* Birth year

// 	lab var yborn "Birth year" 
	
* Gender
recode d11102ll (1=0) (2=1), gen(female)
	lab def female 0 "Male" 1 "Female" 
	lab val female female 
	lab var female "Gender" 
	
	
**--------------------------------------
** Place of living (e.g. size/rural)
**--------------------------------------
* place

//  	lab var place "Place of living"
// 	lab def place 1 "city" 2 "rural area"
// 	lab val place place 

**--------------------------------------
** Education  
**--------------------------------------
* eduy
recode d11109 (-1=-3) (-2 -3=-2), gen(eduy)
	lab var eduy "Education: years"

* edu3

/*
Original survey variables in files shp$$_p_user ($$=1999-2017):
gen D11108_y=-1 if (educat$$<-2 & educat$$!=-6) | D11101<16
replace D11108=1 if D11108==. & (educat$$==-6 | (educat$$>-1 & educat$$<4))
replace D11108=2 if D11108==. & (educat$$>3 & educat$$<7)
replace D11108=3 if D11108==. & (educat$$>6 & educat$$<11)
replace D11108=-2 if D11108==. & ((educat$$==-1 | educat$$==-2) & status$$!=2 & status$$!=.) /* Item NR */
replace D11108=-3 if D11108==. & status$$==2 /* Survey NR */
*/


// 	lab def edu3  1 "Low" 2 "Medium" 3 "High" // 2 incl Vocational
// 	lab val edu3 edu3
// 	lab var edu3 "Education: 3 levels"


**--------------------------------------
** Marital status 	   
**--------------------------------------
* marstat5
// recode d11104 (1=1) (2=3) (3=4) (4=5) (5=6) (-1=-3) (-2 -3=-2), gen(marstat5)
//
// 	lab var marstat5 "Marital status [5]"
// 	lab def marstat5				///
// 	-1 	"MV" 					///
// 	1	"Married or Living with partner"	///
// 	3	"Single" 				///
// 	4	"Widowed" 				///
// 	5	"Divorced" 				///
// 	6	"Separated" 	
// 	lab val marstat5 marstat5

 

**--------------------------------------
** Children 
**--------------------------------------
*  
clonevar kidsn_hh17=d11107 

// 	lab var kids_any  "Has children"
// 	lab val kids_any   yesno
// 	lab var kidsn_all  "Number Of Children" 
//  lab var kidsn_18   "Number Of Children <18 y.o." 
// 	lab var kidsn_15   "Number Of Children <15 y.o." 
	lab var kidsn_hh17   "Number of Children in HH aged 0-17"

**--------------------------------------
** People in HH F14
**--------------------------------------
clonevar nphh=d11106 

	lab var nphh   "Number of People in HH" 

**--------------------------------------
** Living together with partner  
**--------------------------------------
* livpart
// recode d11104 (1=1) (2/5=0) (-1=-3) (-2 -3=-2), gen(livpartX)
//
// 	lab var livpartX "Living together with partner"
// 	lab val livpartX yesno
	
	
*################################
*#								#
*#	Labour market situation		#
*#								#
*################################
 
**--------------------------------------
** Currently working 
**--------------------------------------
* work_py  work_d
recode e11102 (-2 -3=-2), gen(work_py)
recode e11104 (-2 -3=-2) (2=0), gen(work_d)

	lab var work_py "Working: last year (based on hours)"	
	lab var work_d "Working: currently (based on selfrep)" // last week
	lab val work_d work_py yesno
	


**--------------------------------------
** Occupation ISCO  
**--------------------------------------
* 

*  e11105
/*Notes: 
- e11105 - isco 88 (3 digits)
- maybe correct some codes: (100=110) (10=100)
*/
*** isco88_4

/*
clonevar isco88_3 = e11105
recode isco88_3 (-1=-3) (-2 -3=-2)   

lab copy E11105 isco88_3
lab def isco88_3 100 "Legislators and senior officials" 		///
				 10 "Armed forces"								///
				 -2 "[-2] Item non-response"					///
				 -3 "[-3] Does not apply"	 , modify
lab val isco88_3 isco88_3

// iscolbl isco88com  isco88_3, minor // the same 
 

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
		  -2 "[-2] Item non-response"		 							///
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
		-2 "[-2] Item non-response"			 							///
		-3 "[-3] Does not apply"	  
		  
 
*		  
generate isco_1 = cond(isco88_3 >=100, int(isco88_3/100), isco88_3)
replace isco_1=0 if isco88_3==10

generate isco_2 = cond(isco88_3 >100, int(isco88_3/10), isco88_3)
replace isco_2=0 if isco88_3==10
replace isco_2=10 if isco88_3==100
 
	lab val isco_1 isco_1
	lab var isco_1 "Occupation: ISCO-1digit"

	lab val isco_2 isco_2
	lab var isco_2 "Occupation: ISCO-2digit"

*/

**--------------------------------------  
** Industry 
**--------------------------------------
*  
/*Notes: 
//  recode e11106 // 1 digit
//  recode e11107 // 2 digits
 
*/


	
* Major groups 
recode e11107 (1/6=1)(7/11 16=2)(12/15 17=3) (-1=-3)(-2 -3=-2)  , gen(indust1)
		
lab def indust1											///
           1 "[1] Production, Construction, Heavy Ind"	///
           2 "[2] Trade and Services"					///
		   3 "[3] Public services"						///
		  -2 "[-2] Item non-response"					///
		  -3 "[-3] Does not apply"	  
		  
	lab val indust1 indust1		  
	lab var indust1 "Industry (major groups)" 
	
* Submajor groups 
recode e11106 (-1=-3)(-2 -3=-2) (0=10), gen(indust2)

lab def indust2							///
           1 "[1] Agriculture"			///
           2 "[2] Energy"				///
           3 "[3] Mining"				///
           4 "[4] Manufacturing"		///
           5 "[5] Construction"			///
           6 "[6] Trade"				///
           7 "[7] Transport"			///
           8 "[8] Bank,Insurance"		///
           9 "[9] Services"				///
          10 "[10] Other"				///
		  -2 "[-2] Item non-response"	///
		  -3 "[-3] Does not apply"	  

	lab val indust2 indust2		  
	lab var indust2 "Industry (submajor groups/1 dig)" 
	
* Minor groups 
recode e11107 (-1=-3)(-2 -3=-2), gen(indust3)
		
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
		  -2 "[-2] Item non-response"							///
		  -3 "[-3] Does not apply"	  
		  	  
	lab val indust3 indust3		  
	lab var indust3 "Industry (minor groups)"   
		  
		  

**--------------------------------------
** hours worked
**--------------------------------------
* wh_real wh_year

recode e11101 (-1=-3) (-2 -3=-2), gen(whyear)

// 	lab var whday "Work hours per day: worked"
// 	lab var whweek "Work hours per week: worked"
// 	lab var whmonth "Work hours per month: worked"
	lab var whyear "Work hours per year: worked"
 
 

**--------------------------------------
** full/part time
**--------------------------------------
* fptime_r fptime_h

// recode e11103 (-1=-3) (-2 -3=-2), gen(fptime_h)

// 	lab var fptime_r "Employment Level (self-report)"
// 	lab var fptime_h "Employment Level (based on hours)"
//	
// 	lab def fptime 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other"
// 	lab val fptime_h fptime
	

**--------------------------------------
** Supervisor 	
**--------------------------------------
* supervis
	
// 	lab val supervis yesno
// 	lab var supervis "Supervisory position"
	
**--------------------------------------
** Matternity leave  
**--------------------------------------
 
// 	lab val matter yesno
// 	lab var matter "Matternity leave "
	



*################################
*#								#
*#	Income and wealth			#
*#								#
*################################

**--------------------------------------
**   Work Income - detailed
**--------------------------------------


* whole income (jobs, benefits)

// 	lab var inctot_yn "Individual Income (All types, year, net)"
// 	lab var inctot_mn "Individual Income (All types, month, net)"


	
* all jobs 
clonevar incjobs_yg=i11110

// 	lab var incjobs_yn "Individual Labor Earnings (All jobs, year, net)"
	lab var incjobs_yg "Individual Labor Earnings (All jobs, year, gross)"
// 	lab var incjobs_mn "Individual Labor Earnings (All jobs, month, net)"


* main job

// 	lab var incjob1_yg  "Salary from main job (year, gross)"
// 	lab var incjob1_yn  "Salary from main job (year, net)"
// 	lab var incjob1_mg "Salary from main job (month, gross)"
// 	lab var incjob1_mn "Salary from main job (month, net)"
	
*
**--------------------------------------
*   HH wealth
**--------------------------------------
* hhinc_pre
* hhinc_post - //better indicator

recode i11101 (-2 -3=-2), gen(hhinc_pre)
recode i11102 (-2 -3=-2), gen(hhinc_post)

 	lab var hhinc_pre "HH income(month, pre)"	
 	lab var hhinc_post "HH income(month, post)"	
	
**--------------------------------------
**   Income - subjective 
**--------------------------------------
* incsubj9

// 	lab var incsubj9 "Income: subjective rank [9]"
// 	lab def incsubj9 1 "Lo step" 9 "Hi step" 
// 	lab val incsubj9 incsubj9


*################################
*#								#
*#	Health status				#
*#								#
*################################
**--------------------------------------
**  Self-rated health 
**--------------------------------------
* srh
recode m11126   (-2=-3) (-1=-2) , gen(srh5)

	lab var srh5 "Self-rated health"
	lab def srh5 5 "Very bad" 4 "Bad" 3 "Satisfactory" 2 "Good" 1 "Very good"
	lab val srh5 srh5
	

*################################
*#								#
*#	Subjective wellbeing		#
*#								#
*################################
**--------------------------------------
**   Satisfaction with  
**--------------------------------------
* sat_life sat_work sat_fam sat_finhh sat_finind sat_hlth


// 	lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" 	///
// 				 4  "4 Mostly sat" 5 "5 Completely sat"						///
// 				 -1 "-1 MV general" -2 "-2 Item non-response" 		 		///
// 				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
// 
//
// 	lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
// 				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
// 				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
//	 
/*
* Recode   5-point into 10-point versions / must modify
 tokenize "x x"
	 foreach var in sat_work sat_finind sat_life sat_finhh {
		 recode  `1' (1=5) (2=4) (3=3) (4=2) (5=1) (999/max=-1), gen(`var'5)
		 recode  `1' (1=0) (2=3) (3=5) (4=7) (5=10) (-1=-1), 	 gen(`var'10)
			 lab val `var'5  sat5
			 lab val `var'10 sat10
	 macro shift 1  
 }
*/
 * Recode   10-point into 5-point versions / must modify
//  tokenize "m11125 p11101" 
// 	 foreach var in sathlth satlife {
// 		 recode  `1' (0 1=1)(2 3 4=2)(5=3)(6 7 8=4)(9 10=5)(-3 -2=-2)(-1=-3), gen(`var'5)
// 		 recode  `1' (-3 -2=-2) (-1=-3), 	 gen(`var'10)
// 			 lab val `var'5  sat5
// 			 lab val `var'10 sat10
// 	 macro shift 1  
//  }

 
*################################
*#								#
*#	Other						#
*#								#
*################################

**--------------------------------------
**   Sample identifier
**--------------------------------------	
clonevar sampid_shp  = x11104ll
lab var sampid_shp  "Sample identifier: SHP "
 
**|=========================================================================|
**|  RENAME
**|=========================================================================|




**|=========================================================================|
**|  KEEP
**|=========================================================================|

keep													///
x11105 w11101 w11102 w11105 w11113 status	///
wave pid intyear country       edu* 	///
   inc*  						///
kid*  female nphh work_* 			///
wh*  								///
hhinc* srh* 						///
 	indust* 	wavey		///
wave1st respstat sampid*			
				

sort pid wave 
order pid wave wave1st respstat	status   female
order x11* w11* sampid*, last



**|=========================================================================|
**|  SAVE
**|=========================================================================|
 
	 
save "${shp_out}\ch_02a_cnef.dta", replace  	

	 
*____________________________________________________________________________
*--->	END	 <---








