*
**|=============================================|
**|	    ####	CPF	v1.5		####			|
**|		>>>	HILDA						 		|
**|		>>	02_1 Harm - CNEF file equiv			|
**|---------------------------------------------|
**|		Konrad Turek 	| 	2023				|
**|=============================================|
*


**--------------------------------------
** Open merged dataset
**-------------------------------------- 
*** CNEF
local w=word("`c(alpha)'", ${hilda_w})	// convert wave's number to letter 
use "${hilda_in}\STATA ${hilda_w}0c (Other)\CNEF_Long_`w'${hilda_w}0c.dta", clear


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
*#	Delet prefix zz				#
*#								#
*################################	

rename zz* *


*################################
*#								#
*#	Technical					#
*#								#
*################################	
* pid
* intyear 							 
* wave 

rename  xwaveid pid
rename  x11102 hid
rename  year intyear
egen wave = group(intyear)



sort pid wave

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


* Birth year

// 	lab var yborn "Birth year" 
	
* Gender
recode d11102ll (1=0) (2=1), gen(female)
	lab def female 0 "Male" 1 "Female" 
	lab val female female 
	lab var female "Gender" 
	
	


**--------------------------------------
** Education  
**--------------------------------------
* eduy
// recode d11109 (-1=-3) (-3=-1), gen(eduy)
// 	lab var eduy "Education: years"

* edu3

// 	lab def edu3  1 "Low" 2 "Medium" 3 "High" 
// 	lab val edu3 edu3
// 	lab var edu3 "Education: 3 levels"


**--------------------------------------
** Marital status 	   
**--------------------------------------
// * marstat5
// recode d11104 (1=1) (2=3) (3=4) (4=5) (5=6) (-1=-3) (-3=-1), gen(marstat5)
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

/*
	lab var marstat "Marital status"
	lab def marstat				///
	-1 	"MV" 					///
	1	"Married"		 		///
	2	"Living with partner (not harm)"	///
	3	"Single" 				///
	4	"Widowed" 				///
	5	"Divorced" 				///
	6	"Separated" 	
	lab val marstat marstat
*/

**--------------------------------------
** Never Year  !! check if possible harm
**--------------------------------------
* nvmarr

**--------------------------------------
** Year married	 
**--------------------------------------
* ymarr 

//  	lab var ymarr "Year married	"
	
	
	
**--------------------------------------
** Children 
**--------------------------------------
*  
clonevar kidsn_hh18=d11107 

// 	lab var nkids_any	 "Has children"
// 	lab val nkids_any	 yesno
// 	lab var nkids_all "Number Of Children" 
// 	lab var kidsn_18   "Number Of Children <18 y.o." 
	lab var kidsn_hh   "Number of Children in HH"

**--------------------------------------
** People in HH F14
**--------------------------------------
clonevar nphh=d11106 

	lab var nphh   "Number of People in HH" 

**--------------------------------------
** Living together with partner  
**--------------------------------------
* livpart
recode d11104 (1=1) (2/5=0) (-1=-3) (-3=-1), gen(livpart)

	lab var livpart "Living together with partner"
	lab val livpart yesno
	
	
*################################
*#								#
*#	Labour market situation		#
*#								#
*################################
 
**--------------------------------------
** Currently working !!!!
**--------------------------------------
* work_py  work_d
recode e11102 (-1=-3) , gen(work_py)
recode e11104 (-1=-3) (2=0), gen(work_d)

	lab var work_py "Working: last year (based on hours)"	
	lab var work_d "Working: currently (based on selfrep)" // last week
	lab val work_py work_d yesno
	
	
**--------------------------------------
** Employment Status 
**--------------------------------------
* emplst5
//
// 	lab def emplst5	///
// 			1 "Employed" 			/// including leaves
// 			2 "Unemployed (active)"	///
// 			3 "Retired, disabled"	///
// 			4 "Not active/home"		/// home-working separate?  
// 			5 "In education"		///
// 			-1 "MV"
// 	lab val emplst5 emplst5
// 	lab var emplst5 "Employment status [5]"
//
// * emplst6
//
// 	lab def emplst6	///
// 			1 "Employed" 			/// including leaves
// 			2 "Unemployed (active)"	///
// 			3 "Retired, disabled"	///
// 			4 "Not active/home"		/// home-working separate?  
// 			5 "In education"		///
// 			6 "On leave (employed)" ///
// 			-1 "MV"
// 	lab val emplst6 emplst6
// 	lab var emplst6 "Employment status [6]"

**--------------------------------------
** Occupation ISCO  
**--------------------------------------
* isco1 isco2

//   e11105 () // ISCO-88 2-digit
/*

*		  
generate isco_1 = cond(e11105 >=10, int(e11105/10), .)
replace isco_1=0 if e11105==1
replace isco_1=-2 if e11105==-2
replace isco_1=-3 if e11105==0 & e11105==-1 | e11105==-3

*		  
recode e11105 	///
		(1=0)(10=11)(11=11)(12=10)(13=10)(20=20)(21=21)(22=22)(23=23)(24=20)	///
		(30=30)(31=31)(32=32)(33=30)(34=30)(40=40)(41=41)(42=42)(50=50)(51=51)	///
		(52=50)(61=61)(71=71)(72=72)(73=73)(74=70)(80=80)(81=81)(82=82)(83=83)	///
		(90=90)(91=95)(92=92)(93=93)	///
		(0 -1 -3=-2), gen(isco_2)


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
recode e11107 	///
		(1=1)(2=1)(5=1)(10=1)(11=1)(12=1)(13=1)(14=1)(15=1)(16=1)(17=1)(18=1)	///
		(19=1)(20=1)(21=1)(22=1)(23=1)(24=1)(25=1)(26=1)(27=1)(28=1)(29=1)(30=1)	///
		(31=1)(32=1)(33=1)(34=1)(35=1)(36=1)(37=1)(40=1)(41=1)(45=1)(50=2)(51=2)	///
		(52=2)(55=2)(60=2)(61=2)(62=2)(63=2)(64=2)(65=2)(66=2)(67=2)(70=2)(71=2)	///
		(72=2)(73=2)(74=2)(75=3)(80=3)(85=3)(90=2)(91=2)(92=2)(93=2)(95=2)(96=1)	///
		(97=2)(99=3)	///
		 (-1=-3)(-2 -3=-2) (0=-3) , gen(indust1)
		
lab def indust1											///
           1 "[1] Production, Construction, Heavy Ind"	///
           2 "[2] Trade and Services"					///
		   3 "[3] Public services"						///
		  -2 "[-2] Item non-response"					///
		  -3 "[-3] Does not apply"	  
		  
	lab val indust1 indust1		  
	lab var indust1 "Industry (major groups)" 
	
* Submajor groups 
recode e11106 (-1=-3)(-2 -3=-2) (0=-3), gen(indust2)

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
recode e11107 	///
	(1=1)(2=1)(5=2)(10=3)(11=3)(12=3)(13=3)(14=3)(15=4)(16=4)(17=4)(18=4)	///
	(19=4)(20=4)(21=4)(22=4)(23=4)(24=4)(25=4)(26=4)(27=4)(28=4)(29=4)(30=4)	///
	(31=4)(32=4)(33=4)(34=4)(35=4)(36=4)(37=4)(40=5)(41=5)(45=6)(50=7)(51=7)	///
	(52=7)(55=8)(60=9)(61=9)(62=9)(63=9)(64=9)(65=10)(66=10)(67=10)(70=11)	///
	(71=11)(72=11)(73=11)(74=11)(75=12)(80=13)(85=14)(90=7)(91=15)(92=15)(93=7)	///
	(95=16)(96=4)(97=7)(99=17)	///
	(-1=-3)(-2 -3=-2) (0=-3), gen(indust3)
		
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

recode e11101 (-1=-3) (-3=-1), gen(whyear)

// 	lab var whday "Work hours per day: worked"
// 	lab var whweek "Work hours per week: worked"
// 	lab var whmonth "Work hours per month: worked"
	lab var whyear "Work hours per year: worked"
 
 

**--------------------------------------
** full/part time
**--------------------------------------
* fptime_r fptime_h

recode e11103 (-1=-3) (-3=-1), gen(fptime_h)

// 	lab var fptime_r "Employment Level (self-report)"
	lab var fptime_h "Employment Level (based on hours)"
	
	lab def fptime 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other"
	lab val fptime_h fptime


	
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

	lab var incjobs_yg "Individual Labor Earnings (All jobs, year, gross)"
// 	lab var incjobs_yn "Individual Labor Earnings (All jobs, year, net)"
// 	lab var incjobs_mn "Individual Labor Earnings (All jobs, month, net)"

* main job

//
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
/* NOTE: 
	- HILDA provides values below zero - consider before using
*/

recode i11101 (-3=-1), gen(hhinc_pre)
recode i11102 (-3=-1), gen(hhinc_post)

 	lab var hhinc_pre "HH income(month, pre)"	
	
 	lab var hhinc_post "HH income(month, post)"	
	



*################################
*#								#
*#	Health status				#
*#								#
*################################
**--------------------------------------
**  Self-rated health 
**--------------------------------------
* srh
// recode m11126 (5=1) (4=2) (3=3) (2=4) (1=5) (-1=-3) (-3=-1) , gen(srh5)
//
// 	lab var srh5 "Self-rated health"
// 	lab def srh5 1 "Very bad" 2 "Bad" 3 "Satisfactory" 4 "Good" 5 "Very good"
// 	lab val srh5 srh5
//	
	
*################################
*#								#
*#	Subjective wellbeing		#
*#								#
*################################
**--------------------------------------
**   Satisfaction with  
**--------------------------------------
* sat_life sat_work sat_fam sat_finhh sat_finind sat_hlth

//
// 	lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" 	///
// 				 4  "4 Mostly sat" 5 "5 Completely sat"						///
// 				 -1 "-1 MV general" -2 "-2 Item non-response" 		 		///
// 				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
// 
//
// 	lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
// 				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
// 				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	 
/*
* Recode   5-point into 10-point versions 
 tokenize "x x"
	 foreach var in sat_work sat_finind sat_life sat_finhh {
		 recode  `1' (1=5) (2=4) (3=3) (4=2) (5=1) (999/max=-1), gen(`var'5)
		 recode  `1' (1=0) (2=3) (3=5) (4=7) (5=10) (-1=-1), 	 gen(`var'10)
			 lab val `var'5  sat5
			 lab val `var'10 sat10
	 macro shift 1  
 }
*/
 * Recode   10-point into 5-point versions 
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


**|=========================================================================|
**|  KEEP
**|=========================================================================|
keep													///
x11103 x11105 w11101 w11102 w11103 w11104 w11109  	 	///
wave pid          	///
 inc*  						///
kids*  female nphh work_*			///
wh*  								///
hhinc* 		 						///
fptime*								///
intyear   indust*	 livpart							

sort pid wave 
order pid wave intyear   female
order x11* w11*, last



**|=========================================================================|
**|  SAVE
**|=========================================================================|
 
	 
save "${hilda_out}\au_02a_cnef.dta", replace  	

	 
*____________________________________________________________________________
*--->	END	OF FILE <---








