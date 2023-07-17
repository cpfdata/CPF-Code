*
**|=========================================|
**|	    ####	CPF	v1.5	####			|
**|		>>>	RLMS							|
**|		>>	Harmonize variables 			|
**|-----------------------------------------|
**|		Konrad Turek 	| 	2023			|
**|=========================================|
* 

**--------------------------------------
** Open merged dataset
**-------------------------------------- 
* 
use "${rlms_out}\ru_01.dta", clear  	


**--------------------------------------
** Common lables 
**-------------------------------------- 
lab def yesno 0 "[0] No" 1 "[1] Yes" ///
	-1 "-1 MV general" -2 "-2 Item non-response" ///
	-3 "-3 Does not apply" -8 "-8 Question not asked in survey", replace
// numlabel, add


*################################
*#								#
*#	Technical					#
*#								#
*################################	
* pid
* intyear 
* intmonth
* wave 
rename  IDIND pid
rename  YEAR wavey
rename  INT_Y  intyear
recode H7_2 (13/max=-1), gen(intmonth)

egen wave = group(wavey)

gen country=4

sort pid wave

bysort pid: egen wave1st = min(wave)
replace wave1st=1 if wave==1

gen respstat= H4_1 
	lab def respstat 	1 "Interviewed" 					///
						2 "Not interviewed (has values)" 	///
						3 "Not interviewed (no values)"
	lab val respstat respstat
replace respstat=1 if respstat==. & wave==1	
	


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
recode AGE (999/max=.)
rename AGE age

* Birth year

gen yborn=H6
recode yborn (9990/max=-1) 
	lab var yborn "Birth year" 

	
	
	* Correct yborn if not consistent values of yborn across weaves
		bysort pid: egen temp_min=min(yborn)
		bysort pid: egen temp_max=max(yborn)
		gen temp_check=temp_max-temp_min if temp_max>0 & temp_max<. & temp_min>0 & temp_min<.
		replace temp_check=999 if temp_min==-1 & temp_max>0 
		// 			bro pid intyear age yborn  temp_min temp_max temp_check if temp_check>0 & temp_check<.
		bysort pid: egen temp_yborn=mode(yborn) if temp_check>0 & temp_check<., maxmode
		bysort pid: egen temp_yborn_max=max(yborn) if temp_check>0 & temp_check<. 
		replace temp_yborn=temp_yborn_max if temp_yborn==-1 & temp_yborn_max>0 & temp_yborn_max<.
// 					bro pid intyear age age2 yborn temp_yborn temp_min temp_max temp_check if  temp_yborn<. & temp_yborn>0
				
		replace yborn=temp_yborn if temp_yborn<. & temp_yborn>0
		
		// 		bysort pid: egen temp_sd=sd(yborn)
		// 		tab temp_sd
		
		
	* Correct age based on corrected yborn
		replace age=intyear-yborn  if temp_yborn>0 & temp_yborn<.  
// 					bro pid intyear age age2 yborn temp_yborn temp_min temp_max temp_check if  age!=age2 

	* Fill age based on yborn if missing
		replace age=intyear-yborn  if yborn>0 & yborn<. & (age<0 | age==.)

		drop temp*
	* Correct age if values inconsistent with yborn (only if difference more than +/-1)
		gen temp_age_yborn=intyear-yborn if yborn>1000 & yborn<. 
		gen temp_age_err=age-temp_age_yborn if temp_age_yborn>0 & temp_age_yborn<120 & age>0 & age<120
// 		bysort pid: egen temp_difmax=max(abs(temp_age_err))
		replace age=temp_age_yborn if (temp_age_err>1 | temp_age_err<-1) & temp_age_err!=.

	

	
	
* Gender
recode H5 (1=0) (2=1), gen(female)
	lab def female 0 "Male" 1 "Female" 
	lab val female female 
	lab var female "Gender" 
	
**--------------------------------------
** Place of living (e.g. size/rural)
**--------------------------------------
* place
recode STATUS (1 2 3=1) (4=2), gen (place)

	lab var place "Place of living"
	lab def place 1 "city" 2 "rural area"
	lab val place place 

**--------------------------------------
** Education 
**--------------------------------------
* eduy
/* Notes:
- can be calculated from educ
*/

// lab var eduy "Education: years"

* edu3
// diplom educ  DIPLOM_1
//            1 0-6 grades of comprehensive school
//            2 Unfinished secondary education [7-8 grades of school]
//            3 Unfinished secondary education [7-8 grades of school] +smth else
//            4 Secondary School Diploma
//            5 Vocational secondary education Diploma
//            6 Higher education Diploma and more

recode EDUC (0/13=1) (14/18 =2) (19/23=3) (999/max .=-1), gen(edu3)
	lab def edu3  1 "Low" 2 "Medium" 3 "High" // 2 incl Vocational
	lab val edu3 edu3
	lab var edu3 "Education: 3 levels"
	
*** edu4 
recode EDUC (0/6=1) (7/13=2) (14/18=3) (19/23=4) (999/max .=-1), gen(edu4)

	lab def edu4  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" 4 "[5-8] Tertiary" 
	lab val edu4 edu4
	lab var edu4 "Education: 4 levels"
	
*** edu5
recode EDUC (0/6=1) (7/13=2) (14/18=3) (19/20=4) (21/23=5) (999/max .=-1), gen(edu5)

	lab def edu5  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" ///
				  4 "[5-6] Tertiary lower(bachelore)"  ///
				  5 "[7-8] Tertiary upper (master/doctoral)"
				  
	lab val edu5 edu5
	lab var edu5 "Education: 5 levels"




**--------------------------------------
** Primary partnership status  
**--------------------------------------
* Approach based on CNEF 
* NOTE: 
* - categories of 'single' and 'living with partner' not fully precise and can be contradictory to other variables 
* - country differences in inclusion of having/living with partner
* - country differences in definition of ‘single’ 

* marstat
// alternative: J72_17 and J322  - more-less fits marst

recode MARST (2 3 7=1)(1=2)(4=4)(5=3)(6=5) (999/max .=-1), gen(marstat5)

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

recode MARST (2 7=1)(1 3=2)(4=4)(5=3)(6=5) (999/max .=-1), gen(mlstat5)


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
* NOTE: not full reliable 
* - J324 only for w14+

recode mlstat5 (1=1)(2/5=0) , gen(livpart)
	replace livpart=1 if (J324==1|J324==2) 
	replace livpart=0 if (J324==3) 
	replace livpart=0 if NFM==1
				
// 		lab var haspart "Has a partner"
		lab var livpart "Living together with partner"
		lab val livpart    yesno
		


**--------------------------------------
** Partnership living-status 	 
**--------------------------------------
* Includes inforamtion on marital status and whether living with partner in HH 
* NOTE: not full reliable 
* - J324 only for w14+

	recode  mlstat5 (1/5=0), gen(parstat6)
	replace parstat6=3 if mlstat5!=1 & livpart==0
	replace parstat6=5 if mlstat5==4 & livpart==0
	replace parstat6=4 if mlstat5==3 & livpart==0
	replace parstat6=6 if mlstat5==5 & livpart==0
	replace parstat6=6 if mlstat5==1 & livpart==0
	replace parstat6=2 if mlstat5!=1 & livpart==1
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
	lab val parstat6 parstat6

	
	
**--------------------------------------
** Binary specific current partnership status (yes/no)
**--------------------------------------
*** Specific current marital statuses (probably the same as Formal marital status)
* No mater if currently living with a partner


*** Single
// 		lab var csing "Single: not married and no partner"
// 		lab val csing yesno
								
*** Never married 
recode MARST (1=1)(2/7=0) (999/max .=-1), gen(nvmarr)

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
* NOTE: Not defined is 1st marriage, probably valid only for the current one

// recode J323Y (9999/max=-1), gen(ymarr)
// 	lab var ymarr "Year married	"


**--------------------------------------
** Children  
**--------------------------------------
*  
recode J72_171 (2=0) (9999/max=-1), gen(kids_any)	// 2004+
//  (N1_1==1 | N1_2==1)  - asked <2004 but on limied sample of women 

recode J72_172 (9999/max=-1), gen(kidsn_all)	// 2004+
replace kidsn_all=0 if kids_any==0
// recode J72_173 (9999/max=-1), gen(kidsn_17)	// 2004+
recode J72_173 (9999/max=-1), gen(kidsn_hh17)	// 2004+
replace kidsn_hh17=0 if kids_any==0

// gen kidsn_hh=kidsn_18	// not precise 

	lab var kids_any  "Has children"
	lab val kids_any   yesno
	lab var kidsn_all  "Number Of Children Ever Had" 
//  	lab var kidsn_17   "Number Of Own Children 0-17 (any children)" 
// 	lab var kidsn_15   "Number Of Children <15 y.o." 
	lab var kidsn_hh17   "Number of Children in HH"

	
**--------------------------------------
** People in HH 
**--------------------------------------
	clonevar nphh=NFM
	
	lab var nphh   "Number of People in HH" 
	
 


*################################
*#								#
*#	Labour market situation		#
*#								#
*################################
 
**--------------------------------------
** Currently working
**--------------------------------------
* work_py  work_d

recode J1 (1=1) (2/5=0) (999/max=-1), gen(work_d)

	*lab var work_py "Working: last year (based on hours)"	
	lab var work_d "Working: currently (based on selfrep)"
	lab val work_d yesno
	
	
**--------------------------------------
** Employment Status  
**--------------------------------------
* emplst5
gen emplst5=.
replace emplst5=4 if ((J1==4 | J1==5) & J73==2) | (J90==7 | J90==9)

replace emplst5=3 if J1==5 & (J73==1 | J90==4 | J90==3) & age>=50

replace emplst5=5 if J90==15 | J90==16 | J90==1 | J90==2

replace emplst5=2 if (J1==4 | J1==5) & ((J82==1) | (J81==1 & J90==8))
replace emplst5=2 if (J1==4 | J1==5) & J90==8   
 
replace emplst5=1 if J1<=3 // incl. mater.leave and paid leave 
replace emplst5=1 if (J90==10 & J1==1) | J90==11 | J90==12 | J90==13

replace emplst5=-1 if J1>999 & J90>999 & J1<. & J90<.
	recode J90(1 2 15 16=5) (3 7 9=4) (4=3) (8=2) (5 6 10/13=1) (999/max=-1), gen(temp_J90)
replace emplst5=temp_J90 if emplst5==. 
	drop temp_J90

	lab def emplst5	///
			1 "Employed" 			/// including leaves
			2 "Unemployed (active)"	///
			3 "Retired, disabled"	///
			4 "Not active/home"		/// home-working separate?  
			5 "In education"		///
			-1 "MV"
	lab val emplst5 emplst5
	lab var emplst5 "Employment status [5]"

* emplst6
gen emplst6=emplst5
replace emplst6=6 if inlist(J90, 5, 6)

	lab def emplst6	///
			1 "Employed" 			/// including leaves
			2 "Unemployed (active)"	///
			3 "Retired, disabled"	///
			4 "Not active/home"		/// home-working separate?  
			5 "In education"		///
			6 "On leave (employed)" ///
			-1 "MV"
	lab val emplst6 emplst6
	lab var emplst6 "Employment status [6]"


**--------------------------------------
** Occupation ISCO  
**--------------------------------------
* isco1 isco2
*
 // ssc install iscogen
 
* 

clonevar isco08_4=J2COD08
recode isco08_4 (10000/max=.)


*** Recode isco88 into 08 (4 digits) 
iscogen isco88_4= isco88(isco08_4) ,  from(isco08)
replace isco88_4=isco08_4 if isco08_4<1000 // 1-2 digit are universal, 3 digit are according to isco08


*** isco_1 isco_2
generate isco_2 = cond( isco08_4 > 1000, int(isco08_4/100), .)
replace isco_2 = cond( isco08_4 > 100 & isco08_4<1000, int(isco08_4/10), isco_2)
replace isco_2 = isco08_4 if isco08_4 > 10 & isco08_4<100
replace isco_2 = isco08_4*10 if isco08_4 >=0 & isco08_4<10
recode isco_2 (999/max=-1)
*
generate isco_1 = cond( isco_2 > -1, int(isco_2/10), .)
replace isco_1 = -1 if isco_2==-1

* RLMS provides also OCCUP08 (ISCO08-major), but it is inconsistent with J2COD08
// clonevar isco_1_org=OCCUP08
// recode isco_1_org (999/max=-1)


*** Labels: isco_1 isco_2

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
		  
 
 
	lab val isco_1 isco_1
	lab var isco_1 "Occupation: ISCO-1digit"

	lab val isco_2 isco_2
	lab var isco_2 "Occupation: ISCO-2digit"
 
 
 
**--------------------------------------
** Industry 
**--------------------------------------
*  
* sector 
* J4_1

 * Major groups 
recode J4_1 (1/6 8 16 23 24=1)(7 14 15 17/20 25 27/31=2)(9/13 21/22 26 32=3) ///
			(99999996/max=-1) , gen(indust1)
		
			
lab def indust1											///
           1 "[1] Production, Construction, Heavy Ind"	///
           2 "[2] Trade and Services"					///
		   3 "[3] Public services"						///
		  -1 "[-1] MV general"							///
		  -3 "[-3] Does not apply"	  
		  
	lab val indust1 indust1		  
	lab var indust1 "Industry (major groups)" 
	
* Submajor groups 
recode J4_1 (8 24 28=1)(16=2)(4 5=3)(1 3 23=4)(2 6=5) ///
			(14 19=6)(7 30=7)(15=8)(29 17 18 27 31 9 10 12 11 20  25 26=9)	///
			( 13 21 22 32 99999996=10) (99999997/max=-1), gen(indust2)

			
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
recode J4_1 (8 24 28=1) (4 5=3)(1 3 23=4)(16=5) ///
			(2 6=6)(14 19=7)(29=8)(7 30=9)(15=10) ///
			(17 18 27 31=11)(9 13 21=12)(10=13)(12=14)(11 20 22 25 26 32=15) ///
			(  99999996 / 99999999=-1) , gen(indust3)
		
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
//   J23 - Government  
recode J23 (2=0) (999/max=-1), gen(public)
	lab val public yesno
	lab var public "Public sector"

**--------------------------------------
** Size of organization	 
**--------------------------------------
*size 
clonevar size=J13
recode size (99999990/max=-1)

recode size (1/19=1) (20/199=2) (200/1999=3) (2000/max=4), gen(size4)
	* Note: no self-empl, can add based on other vars 
 
 	lab var size "Size of organization [cont]"
	lab var size4 "Size of organization [4]"
	lab def size4 1 "<20" 2 "20-199" 3 "200-1999" 4 "2000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size4 size4
 
recode size (1/9=1) (10/49=2) (50/99=3) (100/999=4) (1000/max=5), gen(size5)
	* Note: no self-empl, can add based on other vars 

	lab var size5 "Size of organization [5]"
	lab def size5 1 "<10" 2 "10-49" 3 "50-99" 4 "100-999" 5 "1000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5 size5
	
recode size (1/9=1) (10/49=2) (50/99=3) (100/499=4) (500/max=5), gen(size5b)
	
	lab var size5b "Size of organization [5b]"
	lab def size5b 1 "<10" 2 "10-49" 3 "50-99" 4 "100-499" 5 "500+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5b size5b	

**--------------------------------------
** hours conracted
**--------------------------------------
* wh_ctr
// 	lab var whweek_ctr "Work hours per week: conracted"

**--------------------------------------
** hours worked
**--------------------------------------
* wh_real wh_year
/*Note:
- difficult to choose which source variable is better (day, week, month)
- inconsistent results
- for some years job1 + job2 gives too high sums 
- For analysis - must decide which to use, maybe clean and combine 
*/

* per day
gen whday=.
replace whday = J6_1 if wavey>=1995 & wavey<=2000
replace whday = J6_1A + (J6_1B/60) if wavey>=2001 & J6_1A <9999
replace whday=-1 if whday>999 & whday<.

* per week 
gen whweek= J6_2 
replace whweek= whweek+ J36_2 if J36_2<9999
replace whweek=-1 if whweek>999 & whweek<.

* per month 
gen whmonth= J8
replace whmonth= whmonth+ J38 if J38<9999
replace whmonth=-1 if whmonth>9999 & whmonth<.

		/* For cleaning
		gen temp_week1=whday*5
		replace  temp_week1=-1 if whday>999
		gen temp_week2=whmonth/4.2
		bro wavey whday whweek temp_week1 temp_week2 whmonth    
		*/
*
	lab var whday "Work hours per day: worked"
	lab var whweek "Work hours per week: worked"
	lab var whmonth "Work hours per month: worked"
// 	lab var whyear "Work hours per year: worked"
 


**--------------------------------------
** full/part time  
**--------------------------------------
* fptime_r fptime_h

*
gen fptime_h=.
replace fptime_h=1 if whweek>=35 & whweek<.
replace fptime_h=2 if whweek<35 & whweek>0
replace fptime_h=3 if whweek==0
replace fptime_h=3 if emplst5>1 & emplst5<.


	lab def fptime 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other"
	lab val fptime_h fptime
//
// 	lab var fptime_r "Employment Level (self-report)"
	lab var fptime_h "Employment Level (based on hours)"


**--------------------------------------
** Supervisor 	
**--------------------------------------
* supervis

recode J6 (1=1) (2=0) (999/max=-1), gen(supervis)
	
	lab val supervis yesno
	lab var supervis "Supervisory position"

**--------------------------------------
** maternity leave  
**--------------------------------------
recode J90 (5=1) (1/4 6/16=0) (999/max=-1), gen(mater)
	lab val mater yesno
	lab var mater "maternity leave "

*################################
*#								#
*#	Currently unemployed 		#
*#								#
*################################


**--------------------------------------
** Unempl: registered  
**--------------------------------------
* un_reg
recode J85 (2=0) (999/max=-1), gen(un_reg)

	lab val un_reg yesno
	lab var un_reg "Unemployed: registered"
 
**--------------------------------------
** Unempl: reason  
**--------------------------------------
* 

 

**--------------------------------------
** Unempl: actively looking for work 
**--------------------------------------
* un_act

gen un_act=.
replace un_act=1 if J1>=4 & J1<999 & J82==1  //NW(or unpaid leave)+actively looking
replace un_act=0 if J1<=3 | J81==2
replace un_act=-1 if J1>999 & J81>999
replace un_act=1 if un_act==0 & J90==8 & J1>=4 & J1<999 // Info from J90

	lab val un_act yesno
	lab var un_act "Unemployed: actively looking for work "

*################################
*#								#
*#	Self-empl / Entrepreneur	#
*#								#
*################################
**--------------------------------------
** Self-imployed	 
**--------------------------------------
* selfemp v1-v3 	 

recode J90 (10 11=1) (1/9 12/16=0) (999/max=-1), gen(selfemp)	
				 
// 	lab val selfemp_v1 selfemp selfemp_v3 yesno
// 	lab var selfemp_v1 "Self-employed 1: all without Family Business"
	lab var selfemp "Self-employed 2: all with Family Business"
// 	lab var selfemp_v3 "Self-employed 3: based on income from self-empl"

**--------------------------------------
** Entrepreneur    
**--------------------------------------
* 
/*Note:
- J29 J55 - opinion about job (entrepreneurial work at this job)
  is less reliable. Thus, we rely on self-classification. 
*/

recode J90 (11=1) (1/10 12/16=0) (999/max=-1), gen(entrep)	
recode J90 (10 11=1) (1/9 12/16=0) (999/max=-1), gen(entrep2)	

	lab val entrep entrep2 yesno
	lab var entrep "Entrepreneur (not farmer; has employees)"
	lab var entrep2 "Entrepreneur (incl. farmers; has employees)"
	

**--------------------------------------
** Number of employees 
**--------------------------------------
recode entrep2 (0 1=-1), gen(nempl)
replace nempl=1 if entrep2==1 & size>1 & size<=9
replace nempl=2 if entrep2==1 & size>=10 & size<.


	lab def nempl 1 "1-9" 2 "10+" 	///
		-1 "-1 MV general" -2 "-2 Item non-response" 	///
		-3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	lab val nempl nempl
	lab var nempl "Number of employees (entrepreneurs)"
	
	
*################################
*#								#
*#	Retired						#
*#								#
*################################
**--------------------------------------
** Receiving old-age pension   
**--------------------------------------					  
* oldpens
/*Note: 
-	J74– waves 1994-2000
-	J74_1- waves 2001-03
-	J74A J74B  - waves 2004
-	J74_1A/J74_1C  waves  2005+
*/								  
gen oldpens=.
replace oldpens=1 if J74==1 & wavey<=2000
replace oldpens=1 if J74_1==1 & wavey>=2001 & wavey<=2003
replace oldpens=1 if (inlist(J74A, 1, 7, 8) | inlist(J74B, 1, 7, 8)) & wavey==2004
replace oldpens=1 if (inlist(J74_1A, 6, 8, 9, 10, 11) | ///
	inlist(J74_1B, 6, 8, 9, 10, 11) | inlist(J74_1C, 6, 8, 9, 10, 11)) & wavey>=2005

recode oldpens(.=0) if (J74<. | J74_1<. | J74A<. | J74B<. | ///
						J74_1A<. | J74_1B<. | J74_1C<.)
recode oldpens(.=0) if J73==2
					  
	lab var oldpens "Receiving old-age pension"
	lab val oldpens yesno 
	
**--------------------------------------
** Fully retired - identification
**--------------------------------------
* retf
/* Notes:
*/

/* retf - Critetia:
- Not working (J1)
- Age 50+
- Receives pension (old-age)
- 65+ 
*/
recode J1 (1/5=0) (999/max=.) , gen(retf)
replace retf=1 if J1==5	& age>=50 & oldpens==1 	//Receives pension (old-age)
replace retf=1 if J1==5 & age>=50 & J90==4   //	Self-categorisation as retired & age 50+ 
replace retf=1 if J1==5 & age>=65	
   
	lab var retf "Retired fully (NW, old-age pens)"
	lab val retf yesno 
	


/* retf2 - Critetia:
- Receive other pension  
*/
// gen retf2=retf
// replace retf2=1 if J1==5 & age>=50	& J73==1 
//	
// 	lab var retf2 "Retired (any pension)"
// 	lab val retf2 yesno 
	
	

**--------------------------------------
** Receiving disability pension   
**--------------------------------------		
* disabpens
/*Note: 
// J74==1 - 1994-2000
// J74_1==1 - 2001-03
// J74A J74B ==1 - 2004
// J74_1A/J74_1C ==11 6  - 2005+
*/								  
gen disabpens=.
replace disabpens=1 if J74==2 & wavey<=2000
replace disabpens=1 if J74_2==1 & wavey>=2001 & wavey<=2003
replace disabpens=1 if (J74A==2 | J74B==2) & wavey==2004
replace disabpens=1 if (inlist(J74_1A, 1, 2, 3, 4) | ///
	inlist(J74_1B, 1, 2, 3, 4) | inlist(J74_1C, 1, 2, 3, 4)) & wavey>=2005

recode disabpens(.=0) if (J74<. | J74_1<. | J74A<. | J74B<. | ///
						J74_1A<. | J74_1B<. | J74_1C<.)
recode disabpens(.=0) if J73==2
					  
	lab var disabpens "Receiving disability pension"
	lab val disabpens yesno 



*################################
*#								#
*#	Work history 				#
*#								#
*################################

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
/*Note
- we recommend cleaning the variable before use, eg.:
- age-exp<12
- inconsistency across waves, jumps from wave to wave
*/
gen exp=.
replace exp=J79				if wavey <=2003 | wavey==2006
replace exp=J161 			if wavey==2004
replace exp=J161_1Y ///
	if inlist(wavey,2005,2007, 2006, 2007, 2008, 2010, 2011, 2012) & J161_2Y>999
replace exp=J161_2Y ///
	if inlist(wavey,2005,2007, 2006, 2007, 2008, 2010, 2011, 2012) & J161_1Y>999	
replace exp=J161_1Y+J161_2Y ///
	if inlist(wavey,2005,2007, 2006, 2007, 2008, 2010, 2011, 2012) ///
	& J161_1Y<999 & J161_2Y<999		
replace exp=J79A 			if wavey==2009
replace exp=J161_3Y			if wavey>=2013

recode exp (999/max=-1)

* Do cleaning before using!

	lab var exp "Labor market experience (not cleaned)"


	
**--------------------------------------
**   Experience in org
**--------------------------------------
* exporg
* J5A 
	
gen exporg=intyear-J5A if J5A <9999 & J5A<=intyear
	
	lab var exporg "Experience in organisation"

	
**--------------------------------------
**   Never worked
**--------------------------------------	
*neverw
recode J78 (2=1) (1=0) (999/max=-1), gen(neverw)
replace neverw=0 if work_d==1
	lab var neverw "Never worked"
	lab val neverw yesno
	
	
*################################
*#								#
*#	Income and wealth			#
*#								#
*################################

**--------------------------------------
**   Work Income - detailed
**--------------------------------------

* whole income (jobs, benefits)

clonevar inctot_mn=J60
recode inctot_mn (99999990/max=-1)

// 	lab var inctot_yn "Individual Income (All types, year, net)"
	lab var inctot_mn "Individual Income (All types, month, net)"


	
* all jobs 
clonevar incjobs_mn=J10
replace incjobs_mn=incjobs_mn + J40 if J40<99999996
recode incjobs_mn (99999990/max=-1)

// 	lab var incjobs_yn "Individual Labor Earnings (All jobs, year, net)"
// 	lab var incjobs_yg "Individual Labor Earnings (All jobs, year, gross)"
	lab var incjobs_mn "Individual Labor Earnings (All jobs, month, net)"


* main job
clonevar incjob1_mn=J10
recode incjob1_mn (99999990/max=-1)

// 	lab var incjob1_yg  "Salary from main job (year, gross)"
// 	lab var incjob1_yn  "Salary from main job (year, net)"
// 	lab var incjob1_mg "Salary from main job (month, gross)"
	lab var incjob1_mn "Salary from main job (month, net)"




**--------------------------------------
*   HH wealth
**--------------------------------------
* hhinc_pre
* hhinc_post - //better indicator

clonevar hhinc_post=F14
recode hhinc_post (99999990/max=-1)

//  	lab var hhinc_pre "HH income(month, pre)"	
	
 	lab var hhinc_post "HH income(month, post)"	

**--------------------------------------
**   Income - subjective 
**--------------------------------------
* incsubj9
recode J62 (999/max=-1), gen(incsubj9)

	lab var incsubj9 "Income: subjective rank [9]"
	lab def incsubj9 1 "Lo step" 9 "Hi step" 
	lab val incsubj9 incsubj9




*################################
*#								#
*#	Health status				#
*#								#
*################################
**--------------------------------------
**  Self-rated health 
**--------------------------------------
* srh
recode M3   (999/max=-1) , gen(srh5)

	lab var srh5 "Self-rated health"
	lab def srh5 5 "Very bad" 4 "Bad" 3 "Satisfactory" 2 "Good" 1 "Very good"
	lab val srh5 srh5



**--------------------------------------
**  Disability 
**--------------------------------------
*  
recode M20_7 (1=1) (2 5=0) (999/max=-1) , gen(disab)
gen disab2c=disab
replace disab2c=0 if M20_8==1 | (M20_8>999 & M20_8<.)
	
	lab var disab	"Disability (any)"
	lab var disab2c "Disability (min. category 2 or >30%)"
	lab val disab disab2c yesno

**--------------------------------------
**  Chronic diseases
**--------------------------------------

// M20_61 M20_62 M20_63 M20_64 M20_65 M20_66 M20_69 // 2000+
// M20_610 M20_611 M20_612 M20_613 M20_614 M20_615 M20_616 M20_617 M20_618 M20_619 M20_620 //2012+


*################################
*#								#
*#	Subjective wellbeing		#
*#								#
*################################
**--------------------------------------
**   Satisfaction with  
**--------------------------------------
* satlife satwork satfam satfinhh satinc sathlth

/*
  J1_1_1  	//2002+
  J1_1_3  	//2002+
  J65 // +  J1_1_5 // for 2003-2005
  J66_1  //2000+
 */
	
	lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" ///
				 4  "4 Mostly sat" 5 "5 Completely sat"					 ///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
 	lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
 	

* Recode into 5-point (original) and 10-point versions 
 tokenize "J1_1_1 J1_1_3 J65 J66_1"
	 foreach var in satwork satinc satlife satfinhh {
		 recode  `1' (1=5)  (2=4) (3=3) (4=2) (5=1) (999/max=-1), gen(`var'5)
		 recode  `1' (1=10) (2=7) (3=5) (4=3) (5=0) (999/max=-1), gen(`var'10)
			 lab val `var'5  sat5
			 lab val `var'10 sat10
	 macro shift 1  
 }
 *
 



*################################
*#								#
*#	Other						#
*#								#
*################################
**--------------------------------------
**   Training
**--------------------------------------
* train
// J72_11 - last y
// J72_111 J72_110- last 2 years
// Note, we include 1995-2000 , but it refers to the last 2 years

recode J72_11 (1=1) (2=0) (999/max=-2), gen(train) // for 2001+

replace train=1 if J72_111==1 & wavey==2000 // for 2000 (last 2y) 
replace train=0 if J72_111==2 & wavey==2000
replace train=-2 if J72_111>999 & J72_111<. & wavey==2000

replace train=1 if J72_110==1 & wavey<2000 // for 95 96 98 (last 2y) 
replace train=0 if J72_110==2 & wavey<2000
replace train=-2 if J72_110>999 & J72_110<. & wavey<2000

	lab val train yesno
	lab var train "Training (previous year)"


**--------------------------------------
**   work-edu link
**--------------------------------------
* eduwork
/* Note:
- asked only 2008-2010
- J4_3 - less MV, asked in 2008-2010
- J72_26 - more accurate, but also 2008-2010
*/
recode J72_26 (1 2=1)  (3=0) (999/max=-2) (.=-1), gen(eduwork)
	* Alternative variable:
// 		recode J4_3 (1 2=1) (3 4=0) (999/max=-2) (.=-1), gen(eduwork)

	lab var eduwork "Work-education skill fit"
	lab def eduwork 0 "0 Poor" 1 "1 Good" ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	
	lab val eduwork eduwork
	
	
*--------------------------------------
**   Job security
**--------------------------------------
* NOTE:

recode J31 (1 2=1)(3 4 5=0) (999/max=-2) (.=-1), gen(jsecu)
recode J31 (1 2=1)(4 5=0)(3=2)  (999/max=-2) (.=-1), gen(jsecu2)


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
	 
	 
	 
**|=========================================================================|
**|  SES Indices
**|=========================================================================|	

**--------------------------------------
**   Occupational status (ISEI)
**--------------------------------------
* isei 
iscogen isei08 = isei(isco08_4)
	lab var isei08 "ISEI-08: International Socio-Economic Index of occupational status"

iscogen isei88 = isei(isco88_4), from(isco88)
	lab var isei88 "ISEI-88: International Socio-Economic Index of occupational status"	
	

	
**--------------------------------------
**   Treiman's international prestige scale (SIOPS) 
**--------------------------------------
iscogen siops08 = siops(isco08_4)
	lab var siops08 "SIOPS-08: Treiman's international prestige scale" 
	
iscogen siops88 = siops(isco88_4) , from(isco88)
	lab var siops88 "SIOPS-88: Treiman's international prestige scale" 	
**--------------------------------------
*** MPS (German Magnitude Prestige Scale; Christoph 2005)
**--------------------------------------	
iscogen mps88 = mps(isco88_4) , from(isco88)
	lab var mps88 "MPS: German Magnitude Prestige Scale" 
 		
**--------------------------------------
**   EGP / ESEC
**--------------------------------------	
// 	iscogen EGP = egp11(job selfemp nemployees), from(isco88)
//
// 	 oesch
	 
	 
*################################
*#								#
*#	Parents						#
*#								#
*################################		


**--------------------------------------  
**   Parents' education
**--------------------------------------
*** Father 

*edu3
capture recode J217A (1/5 12=1) (6/7=2) (8/11=3) (999/max =-1) , gen(fedu3)

	lab val fedu3 edu3
	lab var fedu3 "Father's education: 3 levels"

	
* edu4
capture recode J217A (1/3 12=1)(4/5=2)(6/7=3)(8/11=4) (999/max=-1), gen(fedu4)

	lab val fedu4 edu4
	lab var fedu4 "Father's education: 4 levels"
	

*** Mother 
*edu3
capture recode J217B (1/5 12=1)(6/7=2)(8/11=3) (999/max=-1), gen(medu3)

	lab val medu3 edu3
	lab var medu3 "Mother's education: 3 levels"

	
* edu4
capture recode J217B (1/3 12=1)(4/5=2)(6/7=3)(8/11=4) (999/max=-1), gen(medu4)

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

*################################
*#								#
*#	Migration					#
*#								#
*################################	 

**--------------------------------------
**   Migration Background
**--------------------------------------	
*migr - specifies if respondent foreign-born or not.
lab def migr ///
0 "native-born" ///
1 "foreign-born" ///
-1 "MV general" -2 "Item non-response" ///
-3 "Does not apply" -8 "Question not asked in survey"

gen migr=. 
replace migr=0 if I2==1 //Russia
replace migr=0 if I1==2 //Born in same place as current residence
replace migr=1 if inrange(I2, 2, 16) //Foreign

*fill MV / correct inconsistent responses
	bysort pid: egen temp_migr=mode(migr), maxmode // identify most common response
	replace migr=temp_migr if migr==. & temp_migr>=0 & temp_migr<.
	replace migr=temp_migr if migr!=temp_migr // correct a few inconsistent cases

*specify some missing values
replace migr=-1 if migr==. & (I2==99999997 | I2==99999998) //DK/Refusal
replace migr=-2 if migr==. & I2==99999999

lab val migr migr
	
**----------------------
**   COB respondent
**----------------------
*country of birth by global region, only if respondent non-native	

*NOTE: only broad region available if respondent not born in Russia

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
-1 "MV general" -2 "Item non-response" ///
-3 "Does not apply" -8 "Question not asked in survey"

gen cob_r=.
replace cob_r=0 if (I2==1 | I1==2) //Russia
replace cob_r=3 if I2==2 //Ukraine
replace cob_r=3 if I2==3 //Belarus
replace cob_r=7 if inrange(I2, 4, 8)
replace cob_r=3 if inrange(I2, 9, 11)
replace cob_r=7 if inrange(I2, 12, 14)
replace cob_r=3 if I2==15 //Estonia
replace cob_r=10 if I2==16 //Other
replace cob_r=0 if cob_r==. & migr==0 //Born in place of current residence (=Russia)
replace cob_r=10 if cob_r==. & migr==1 

rename cob_r cob_rt //temp working var 

*** Identify valid COB and fill across waves  
sort pid wave 

*** Generate valid stage 1 - mode across the waves (values 0-10)
	// It takes the value of the most common valid answer between 0 and 10 
	// If there is an equal number of 2 or more answers, it returns "." - filled in next steps
	
	bysort pid: egen mode_cob_rt=mode(cob_rt)
	
*** Generate valid stage 2 - first valid answer provided (values 0-9)
	// It takes the value of the first recorded answer between 1 and 9 (so ignors 10 "other")
	// These are used to fill COB in cases: 
	//	(a) equal number of 2 or more answers (remaining MV)
	//	(b) there is a valid answer other than 10 but the mode (stage 1) returns 10
	
	by pid (wave), sort: gen temp_first_cob_rt=cob_rt if sum(inrange(cob_rt, 0, 9)) == 1 & sum(inrange(cob_rt[_n - 1], 0, 9)) ==0 // identify first valid answer in range 0-9
	bysort pid: egen first_cob_rt=max(temp_first_cob_rt) // copy across waves within pid
	drop temp_first_cob_rt
	
*** Fill the valid COB across waves

	gen cob_r = mode_cob_rt // stage 1 - based on mode
	replace cob_r = first_cob_rt if cob_r ==. & inrange(first_cob_rt, 0, 9) // stage 2 - based on the first for MV
	replace cob_r = first_cob_rt if cob_r==10 & inrange(first_cob_rt, 1, 9) // stage 2 - based on the first for 10 'other'
	drop cob_rt
	
	rename cob_r cob

	*specify MV
	replace cob=-1 if cob==. & (I2==99999997 | I2==99999998) //DK/Refusal 
	replace cob=-2 if cob==. & I2==99999999 //non-response
	
	*correct a few migr values based on cob
	replace migr=0 if cob==0
	
lab val cob COB	

**--------------------------------------
**   Migration Background (parents)
**--------------------------------------	
//Not available

**--------------------------------------
**   Migrant Generation (respondent)
**--------------------------------------	
//Not available

**--------------------------------------------
**   Mother tongue / language spoken as child
**--------------------------------------------	
/* Not indluded in the current version due to too many MV
lab def langchild ///
0 "same as country of residence" ///
1 "other" ///
-1 "MV general" -2 "DK/refusal" ///
-3 "NA" -8 "not asked in survey"

///Note: dialects which are not officially recognised at the national level are categorised as 'other'

gen langchild=.
replace langchild=0 if I6==1 // russian
replace langchild=1 if inrange(I6, 2, 171) // other
replace langchild=-1 if I6==101 //handicapped, does not speak
replace langchild=-1 if I6==143 //slurs words
replace langchild=-1 if I6==155 //No nationality
replace langchild=-1 if I6==99999997 //DK
replace langchild=-1 if I6==99999998 //refusal
replace langchild=-3 if I6==99999999 //NA

lab val langchild langchild

*fill MV
	bysort pid: egen temp_lc=mode(langchild), maxmode // identify most common response
	replace langchild=temp_lc if langchild==. & temp_lc>=0 & temp_lc<.
	replace langchild=temp_lc if langchild!=temp_lc // correct a few inconsistent cases
	
	drop temp_lc 
	
*specify when question not asked and cannot be filled using data from other years:
replace langchild=-8 if langchild==. & wavey>=2008
*/


*################################
*#								#
*#	    Religion			 	#
*#								#
*################################

**--------------------------------------  
** Religiosity
**--------------------------------------
*J72 - Of what religion do you consider yourself?

lab def relig ///
0 "Not religious/Atheist/Agnostic" ///
1 "Religious" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

gen relig=1
replace relig=0 if J72_19==99999996 //No religion
replace relig=0 if J72_19==13 //
replace relig=0 if J72_19==21 //
replace relig=0 if J72_19==23 //
replace relig=0 if J72_19==37 //
replace relig=0 if J72_19==38 //
replace relig=0 if J72_19==48 //
replace relig=0 if J72_19==51 //
replace relig=0 if J72_19==59 //
replace relig=0 if J72_19==71 //
replace relig=0 if J72_19==88 //
replace relig=-1 if J72_19==99999997 //DK
replace relig=-1 if J72_19==99999998 //refusal
replace relig=-2 if J72_19==99999999 //No answer
replace relig=. if J72_19==.

replace relig=-8 if inrange(wavey, 1994, 1998)
replace relig=-8 if inrange(wavey, 2004, 2010)

lab val relig relig

**--------------------------------------  
** Religion - Attendance
**--------------------------------------
*J131.1 Do you visit divine services, meetings or other religious events? If yes how often?	

lab def attendance ///
1 "Never or practically never" ///
2 "Less than once a month" ///
3 "At least once a month" ///
4 "Once a week or more" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

recode J131_1 (1/2=1) (3/4=2) (5/6=3) (7=4) (99999997/99999998=-1) (99999999=-2), gen(relig_att)

*specify for years when not asked (i.e. prior to 2016)
replace relig_att=-8 if wavey<=2015

lab val relig_att attendance
 

 
*################################
*#								#
*#	Weights						#
*#								#
*################################	 
**--------------------------------------
**   Cross-sectional sample weight
**--------------------------------------	

gen wtcs= INWGT
 
  
**--------------------------------------
**   Cross-sectional population weight
**--------------------------------------	

// gen wtcp= 					



**--------------------------------------
**   Longitudinal Weight
**--------------------------------------		 
	
**--------------------------------------
**   Sample identifier
**--------------------------------------	

clonevar sampid_rlms  =   ORIGSM
lab var sampid_rlms  "Sample identifier: RLMS"

 
**|=========================================================================|
**|  KEEP 
**|=========================================================================|

keep			///
wave pid country  intyear intmonth wtcs INWGT  age place  isco*  		///
marstat* parstat* mlstat* livpart nvmarr				///
edu3 edu4 edu5 indust*  wavey	wave1st	respstat					///
sat* size* inc* entrep*  train* exp* superv*				///
kid* yborn female nphh work_d empls* public 			///
whday whweek whmonth fptime* mater un_* oldpens retf* disabpens 	///
neverw hhinc* srh* disab* eduwork*	jsecu*					///
H7_1 H7_2 			/// day month interv 
J1_1_2 J1_1_4 J1_1_6 J1_1_7 J1_1_8 J1_1_9 /// jo quality / sat
ID_H				/// hh num
migr* cob*   relig* /// 
wtcs isei* siops* mps* nempl selfemp*	///
widow divor separ fedu* medu*   sampid*



**|=========================================================================|
**|  SAVE
**|=========================================================================|
 
label data "CPF_RUS v1.5"
save "${rlms_out}\ru_02_CPF.dta", replace  	

	 
*____________________________________________________________________________
*--->	END	 <---


