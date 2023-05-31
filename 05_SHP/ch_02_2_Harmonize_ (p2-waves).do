*
**|=========================================|
**|	    ####	CPF	v1.5	####		  	|
**|		>>>	SHP						 		|
**|		>>	03_ Prepare data - waves 		|
**|-----------------------------------------|
**|		Konrad Turek 	| 	2023			|
**|=========================================|
*  




**--------------------------------------
** Open merged dataset
**-------------------------------------- 
 

*** Work on waves:
use "${shp_out}\ch_01_selected_long.dta", clear 





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

// rename  idpers pid
rename  idhous hid
rename   wave intyear
egen wave = group(intyear)
gen wavey=intyear

gen intmonth=month(pdate)
recode intmonth (.=-1)

sort pid wave


* Responded in the survey
recode status (0=1) (1=2) (2 4=3), gen(respstat)
	lab def respstat 	1 "Interviewed" 					///
						2 "Not interviewed (has values)" 	///
						3 "Not interviewed (no values)"
	lab val respstat respstat
	
	
*################################
*#								#
*#	Socio-demographic basic 	#
*#								#
*################################
**--------------------------------------
** Demographic
**--------------------------------------
* age
// age 

* Birth year
rename birthy yborn
	lab var yborn "Birth year" 
	
	* Correct age if values inconsistent with yborn (only if difference more than +/-1)
		gen temp_age_yborn=intyear-yborn if yborn>1000 & yborn<. 
		gen temp_age_err=age-temp_age_yborn if temp_age_yborn>0 & temp_age_yborn<120 & age>0 & age<120
// 		bysort pid: egen temp_difmax=max(abs(temp_age_err))
		replace age=temp_age_yborn if (temp_age_err>1 | temp_age_err<-1) & temp_age_err!=.
		
		drop temp*		
		
* Gender
* cnef
	
	
**--------------------------------------	 
** Place of living (e.g. size/rural) NA
**--------------------------------------
* place 

//  lab var place "Place of living"
// 	lab def place 1 "city" 2 "rural area"
// 	lab val place place 


*################################
*#								#
*#	Education					#
*#								#
*################################
**--------------------------------------
** Education  
**--------------------------------------
* eduy

// recode d11109 (-1=-3) (-2 -3=-2), gen(eduy)
// 	lab var eduy "Education: years"

* edu3
* educat isced


recode isced (-6 0 10 20=1) (31/33 41=2) (51/60=3) (-2=-2) (-1 -3 16=-1), gen(edu3)
	lab def edu3  1 "Low" 2 "Medium" 3 "High" // 2 incl Vocational
	lab val edu3 edu3
	lab var edu3 "Education: 3 levels"

/*
Original survey variables in files shp$$_p_user ($$=1999-2017):
gen D11108_y=-1 if (educat$$<-2 & educat$$!=-6) | D11101<16
replace D11108=1 if D11108==. & (educat$$==-6 | (educat$$>-1 & educat$$<4))
replace D11108=2 if D11108==. & (educat$$>3 & educat$$<7)
replace D11108=3 if D11108==. & (educat$$>6 & educat$$<11)
replace D11108=-2 if D11108==. & ((educat$$==-1 | educat$$==-2) & status$$!=2 & status$$!=.) /* Item NR */
replace D11108=-3 if D11108==. & status$$==2 /* Survey NR */
*/


*** edu4
recode isced (-6 0 10=1) (20=2) (31/33 41=3) (51/60=4) (-2=-2) (-1 -3 16=-1), gen(edu4)

	lab def edu4  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" 4 "[5-8] Tertiary" 
	lab val edu4 edu4
	lab var edu4 "Education: 4 levels"
	
*** edu5
recode isced (-6 0 10=1) (20=2) (31/33 41=3) (51=4) (52 60=5) (-2=-2) (-1 -3 16=-1), gen(edu5)

	lab def edu5  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" ///
				  4 "[5-6] Tertiary lower(bachelore)"  ///
				  5 "[7-8] Tertiary upper (master/doctoral)"
				  
	lab val edu5 edu5
	lab var edu5 "Education: 5 levels"

	* Alternative version:
recode isced (-6 0 10=1) (20=2) (31/33 41=3) (51 52=4) (60=5) (-2=-2) (-1 -3 16=-1), gen(edu5v2)

	lab def edu5v2  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
					3 "[3-4] Secondary upper" ///
					4 "[5-7] Tertiary first(bachelore/master)"  ///
					5 "[8] Tertiary second (doctoral)"
	
	lab val edu5v2 edu5v2
	lab var edu5v2 "Education: 5 levels v2"


*################################
*#								#
*#	Family and relationships	#
*#								#
*################################	

**--------------------------------------
** Primary partnership status   
**--------------------------------------
* Approach based on CNEF 
* NOTE: 
* - categories of 'single' and 'living with partner' not fully precise and can be contradictory to other variables 
* - country differences in inclusion of having/living with partner
* - country differences in definition of ‘single’ 

	
recode civsta (2 6=1)(1 7=2)(5=3)(4=4)(3=5) (-8=-1)(-1=-3)(-2 -3=-2), gen(marstat5)
replace marstat5=1 if p_d29==1
 
// gen marstat5=-3 if age<16
// replace marstat5=-1 if civsta==-8
// replace marstat5=-3 if civsta==-1
// replace marstat5=-2 if civsta==-2|civsta==-3
//
// replace marstat5=1 if (civsta==2 | civsta==6 | p_d29==1)
// replace marstat5=3 if civsta==1 & p_d29!=1
// replace marstat5=3 if civsta==7 & p_d29!=1
// replace marstat5=4 if civsta==5 & p_d29!=1
// replace marstat5=5 if civsta==4 & p_d29!=1
// replace marstat5=6 if civsta==3 & p_d29!=1

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
* Formal marital status
* Only formal marital status included, no info on having/living with partner
* Never married include singles 
 
recode civsta (2 6=1)(1 7=2)(5=3)(4=4)(3=5) (-8=-1)(-1=-3)(-2 -3=-2), gen(mlstat5)

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

* haspart
recode p_d29 (1 2=1)(3=0) (-8=-1)(-1=-3)(-2 -3=-2), gen(haspart) // Has partner
	* Fill MV (problem SHP: filter not explained) 
	* Filled using civsta (warning: assumptions)
	replace haspart=1 if hasp<0 & (civsta==2|civsta==6)
	replace haspart=0 if hasp<0 & (civsta==1|civsta==3|civsta==4|civsta==5|civsta==7)
	replace haspart=1 if mlstat5==1
	
* livpart
recode p_d29 (1=1)(2 3=0) (-8=-1)(-1=-3)(-2 -3=-2), gen(livpart) // Living with partner
	* Fill MV (problem SHP: filter not explained) with civsta (assumptions)
	replace livpart=1 if livpart<0 & (civsta==2|civsta==6)
	replace livpart=0 if livpart<0 & (civsta==1|civsta==3|civsta==4|civsta==5|civsta==7)
	replace livpart=1 if livpart==0 & mlstat5==1 & p_d29==2
	replace livpart=0 if livpart==0 & mlstat5==1 & p_d29==3
	
		lab var haspart "Has a partner"
		lab var livpart "Living together with partner"
		lab val livpart haspart yesno
		

		

**--------------------------------------
** Partnership living-status 	 
**--------------------------------------
* Includes inforamtion on marital status and whether living with partner in HH 

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
* Not married and no partner 
// recode civsta (1/7=0) (-8=-1)(-1=-3)(-2 -3=-2), gen(csing)
// replace csing=1 if civsta!=2 & civsta!=6 & haspart==0
//	
// 		lab var csing "Single: not married and no partner"
// 		lab val csing  yesno
		
*** Never married 
recode civsta (1=1)(2/7=0) (-8=-1)(-1=-3)(-2 -3=-2), gen(nvmarr)
		
		lab var nvmarr "Never married"
		lab val nvmarr  yesno
		
		
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
** Year married	 NA
**--------------------------------------
* ymarr 

//  	lab var ymarr "Year married	"
	
	
	
**--------------------------------------
** Children 
**--------------------------------------
*  
// kidshh from CNEF

clonevar kidsn_all=ownkid 
recode kidsn_all (0=0) (1/50=1), gen(kids_any)


	lab var kids_any  "Has any children"
	lab val kids_any   yesno
	lab var kidsn_all  "Number Of Children Ever Had" 
//  lab var kidsn_18   "Number Of Children <18 y.o." 
// 	lab var kidsn_15   "Number Of Children <15 y.o." 
//  lab var kidsn_hh   "Number of Children in HH"

	
**--------------------------------------
** People in HH F14
**--------------------------------------
// In CNEF_file



	
	
*################################
*#								#
*#	Labour market situation		#
*#								#
*################################
 
**--------------------------------------
** Currently working  
**--------------------------------------
* work_py  work_d
// recode e11102 (-1=-3) (-2 -3=-2), gen(work_d)

// 	lab var work_py "Working: last year (based on hours)"	
// 	lab var work_d "Working: currently (based on selfrep)" // last week
// 	lab val work_d yesno

// recode p_w01 (2=0),  gen(work_d_w)	
	
**--------------------------------------
** Employment Status  
**--------------------------------------
* emplst5
/* Note from manual:
Work status (WSTAT$$) is constructed from P$$W01 (working for pay last week), P$$W03 (have a job although not working last week) and P$$W06 (can start work imme-diately), from the individual questionnaire. Another occupational variable is OCCUPA$$, this information comes from the grid and should be considered as less reliable.
*/

recode wstat (1=1)  (2 3=4), gen(emplst5)
replace emplst5=3 if (p_w12==2 | p_w13==2 | p_w14==2) & age>=50
replace emplst5=3 if (p_w12==3 | p_w13==3 | p_w14==3)
replace emplst5=5 if (p_w12==1 | p_w13==1 | p_w14==1)
replace emplst5=2 if p_w05==1
replace emplst5=1 if (x_w02>0 & x_w02<.)

	lab def emplst5	///
			1 "Employed" 			/// including leaves
			2 "Unemployed (active)"	///
			3 "Retired, disabled"	///
			4 "Not active/home"		/// home-working separate?  
			5 "In education"		///
			-3 "Not Apply"			///
			-1 "MV"
	lab val emplst5 emplst5
	lab var emplst5 "Employment status [5]"

* emplst6

recode wstat (1=1)   (3=4) , gen(emplst6)
replace emplst6=6 if p_w03==1
replace emplst6=3 if (p_w12==2 | p_w13==2 | p_w14==2) & age>=50
replace emplst6=3 if p_w12==3 | p_w13==3 | p_w14==3
replace emplst6=5 if p_w12==1 | p_w13==1 | p_w14==1
replace emplst6=2 if p_w05==1
replace emplst6=1 if x_w02>0 & x_w02<.

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

// **--------------------------------------
// ** Occupation ISCO  
// **--------------------------------------
// * 
// * Check is1maj is2maj is3maj is4maj caimaj xis1ma xis2ma xis3ma xis4ma
//


*  e11105
/*Notes: 
- e11105 - isco 88 (3 digits)
- maybe correct some codes: (100=110) (10=100)
*/

*** isco88_4
clonevar isco88_4 = is4maj
replace isco88_4=xis4ma if status==1 & xis4ma>0 & xis4ma<. & isco88_4<0 //proxy interview
iscolbl isco88com  isco88_4 

recode isco88_4 (-3/-1=.)

*** isco08_4
iscogen isco08_4= isco08(isco88_4) ,  from(isco88)

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
generate isco_1 = cond(isco88_4 >=1000, int(isco88_4/1000), isco88_4)
replace isco_1=0 if isco88_4==100
// iscogen isco_1b= major(isco88_4)  


*
generate isco_2 = cond(isco88_4 >1000, int(isco88_4/100), isco88_4)
replace isco_2=0 if isco88_4==100
replace isco_2=10 if isco88_4==1000

// iscogen isco_2b= submajor(isco88_4)  

	lab val isco_1 isco_1
	lab var isco_1 "Occupation: ISCO-1digit"

	lab val isco_2 isco_2
	lab var isco_2 "Occupation: ISCO-2digit"





//
// **--------------------------------------
// ** Industry 
// **--------------------------------------
// *  
//



**--------------------------------------
** Public sector
**--------------------------------------
recode p_w32 (2=1) (1=0) (-7=-1), gen(public)

	lab val public yesno
	lab var public "Public sector"

**--------------------------------------
** Size of organization	!! Harm
**--------------------------------------
*size 
recode p_w85 (1 2=1) (3 4 5=2) (6=3) (7 8=4) (9=5) (-7=-1) , gen(size5)

	lab var size5 "Size of organization [5]"
	lab def size5 1 "<10" 2 "10-49" 3 "50-99" 4 "100-999" 5 "1000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5 size5

 
// 	lab var size4 "Size of organization [4]"
// 	lab def size4 1 "<20" 2 "20-199" 3 "200-1999" 4 "2000+"  	///
// 				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
// 				-1 "-1 MV general" -2 "-2 Item non-response" 	///
// 				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val size4 size4
	
*	
recode p_w85 (1 2=1) (3 4 5=2) (6=3) (7=4) (8 9=5) (-7=-1) , gen(size5b)

	lab var size5b "Size of organization [5b]"
	lab def size5b 1 "<10" 2 "10-49" 3 "50-99" 4 "100-499" 5 "500+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5b size5b	
	
	
**--------------------------------------
** hours conracted
**--------------------------------------
* whweek_ctr

recode p_w74 (-7 -5=-1), gen(whweek_ctr)

	lab var whweek_ctr "Work hours per week: conracted"

**--------------------------------------
** hours worked
**--------------------------------------
* wh_real wh_year

// recode e11101 (-1=-3) (-2 -3=-2), gen(whyear)

recode p_w77 (-7 -5=-1), gen(whweek)

gen whmonth=whweek*4.3
replace whmonth=whweek if whweek<0

// 	lab var whday "Work hours per day: worked"
	lab var whweek "Work hours per week: worked"
	lab var whmonth "Work hours per month: worked"
// 	lab var whyear "Work hours per year: worked"
 
 

**--------------------------------------
** full/part time
**--------------------------------------
* fptime_r fptime_h

// recode e11103 (-1=-3) (-2 -3=-2), gen(fptime_h)
recode p_w39 (1=2) (2=1) , gen(fptime_r)
replace fptime_r=3 if p_w39==-3 & (wstat==2 | wstat==3)

*
gen fptime_h=.
replace fptime_h=1 if whweek>=35 & whweek<.
replace fptime_h=2 if whweek<35 & whweek>0
replace fptime_h=3 if whweek==0
replace fptime_h=3 if emplst5>1 & emplst5<.
replace fptime_h=whweek if whweek<0 & fptime_h==.

	lab var fptime_r "Employment Level (self-report)"
	lab var fptime_h "Employment Level (based on hours)"
	
  	lab def fptime 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other"
  	lab val fptime_r fptime
	lab val fptime_h fptime
**--------------------------------------
** overtime working NA
**--------------------------------------
 
**--------------------------------------
** Supervisor 	
**--------------------------------------
* supervis
* w87 - official part of work (y/n) + p_w90 (number)
* w34a - less accurate 


recode p_w87 (2=0) (-7=-1), gen(supervis)
replace supervis=0 if p_w87==1 & p_w90<1

	lab val supervis yesno
	lab var supervis "Supervisory position"
	
**--------------------------------------
** maternity leave  NA
**--------------------------------------
 
// 	lab val mater yesno
// 	lab var mater "maternity leave "
	
**--------------------------------------
** Work-type 	!!! Check if harm possib
**--------------------------------------
// recode p_w34a


*################################
*#								#
*#	Currently unemployed 		#
*#								#
*################################


**--------------------------------------
** Unempl: registered  NA
**--------------------------------------
* un_reg

// 	lab val un_reg yesno
// 	lab var un_reg "Unemployed: registered"

**--------------------------------------
** Unempl: reason    NA
**--------------------------------------
* 
/*Notes: 
- create set of categories if harmon possible
*/
 

**--------------------------------------
** Unempl: actively looking for work 
**--------------------------------------
* un_act
recode wstat (1/3=0), gen(un_act)
replace un_act=1 if p_w05==1

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

gen selfemp=0
replace selfemp=1  if  p_w29==2 | p_w291==2 |  p_w293==2 | ///
						  p_w29==3 | p_w291==3 |  p_w293==3
replace selfemp=-1 if  (p_w29<0 | p_w29==.) & (p_w291<0 | p_w291==.) ///
						  &  (p_w293<0 | p_w293==.)
replace selfemp=1 if x_w02==2 | x_w02==3 
replace selfemp=-1 if  selfemp==. & (x_w02<0 | x_w02==.)  						  

replace selfemp=0 if selfemp==-1 & emplst5>1 & emplst5<.
						  
gen selfemp_v3=1  if i_indmg >0 & i_indmg <.
replace selfemp_v3=0 if i_indmg <0						 

// 	lab val selfemp_v1 selfemp selfemp_v3 yesno
// 	lab var selfemp_v1 "Self-employed 1: all without Family Business"
	lab var selfemp "Self-employed 2: all with Family Business"
	lab var selfemp_v3 "Self-employed 3: based on income from self-empl"
	
	lab val selfemp_* yesno
**--------------------------------------
** Entrepreneur 
**--------------------------------------
* entrep

gen entrep2=1 if (p_w29==2 | p_w291==2 |  p_w293==2 | ///
				  p_w29==3 | p_w291==3 |  p_w293==3) & p_w31>1 & p_w31<.
replace entrep2=0 if selfemp==0 | (entrep2==. & selfemp==1)
replace entrep2=1 if (x_w02==2 | x_w02==3) & x_w03>1 & x_w03<.
 
//   	lab val entrep yesno
//   	lab var entrep  "Entrepreneur (not farmer; has employees)"
// 
		lab val entrep2 yesno
		lab var entrep2 "Entrepreneur (incl. farmers; has employees)"

**--------------------------------------
** Number of employees 
**--------------------------------------
gen temp_nempl = p_w31
replace temp_nempl=x_w03 if (temp_nempl<0 | temp_nempl==.) & x_w03>=0 & x_w03<.

recode entrep2 (0 1=-1), gen(nempl)
replace nempl=1 if entrep2==1 & (temp_nempl==2 | temp_nempl==3)
replace nempl=2 if entrep2==1 & temp_nempl>3 & temp_nempl<=7

	drop temp_nempl
	
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
** Fully retired - identification
**--------------------------------------
* retf 

gen retf=0 if emplst5>0 & emplst5<.
replace retf=1 if (p_w12==2 | p_w13==2 | p_w14==2) & age>=50 & wstat!=1 // Self-cat & age 50+ & NW
replace retf=1 if (p_i70==1 | p_i90==1) & age>=50 & wstat!=1 // Receives old-age pension & age 50+
replace retf=1 if age>=65 & wstat!=1 // Age 65+  
replace retf=0 if retf==. & age<50 //age below 50
					  
	lab var retf "Retired fully (NW, old-age pens, 45+)"
	lab val retf yesno 

* retf2

// gen retf2=retf
// replace retf2=1 if p_i80==1 & wstat!=1
//
// 	lab var retf2 "Retired"
// 	lab val retf2 yesno 
	
**--------------------------------------
** Age of retirement  
**--------------------------------------					  
*   
 		  


**--------------------------------------
** Receiving old-age pension  
**--------------------------------------					  
* oldpens  
 
gen oldpens=0 if emplst5>0 & emplst5<.	
replace oldpens=1 if p_i70==1 | p_i90==1  
					  
	lab var oldpens "Receiving old-age pension"
	lab val oldpens yesno 
	
	

**--------------------------------------
** Receiving disability pension   
**--------------------------------------		
* disabpens
recode p_i80 (2=0) (-7=-1), gen (disabpens)

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
**   Total Labor market experience (full+part time) !!!
**--------------------------------------
* exp	

recode p_w609 (-7=-1), gen(exp)

	lab var exp "Labor market experience"

**--------------------------------------
**   Experience in org
**--------------------------------------
* exporg
 	
// 	lab var exporg "Experience in organisation"
	
**--------------------------------------
**   Never worked
**--------------------------------------	
*neverw
recode p_w608 (-9=1) (0/99=0) (-7=-1), gen(neverw)
replace neverw=0 if emplst5==1 & neverw==1
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
recode i_ptotn (-8 -5 -4=-1), gen (inctot_mn)

// 	lab var inctot_yn "Individual Income (All types, year, net)"
	lab var inctot_mn "Individual Income (All types, month, net)"



*
**--------------------------------------
*   HH wealth
**--------------------------------------

	
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
// recode m11126 (5=1) (4=2) (3=3) (2=4) (1=5) (-2=-3) (-1=-2) , gen(srh5)
//
// 	lab var srh5 "Self-rated health"
// 	lab def srh5 1 "Very bad" 2 "Bad" 3 "Satisfactory" 4 "Good" 5 "Very good"
// 	lab val srh5 srh5
	
**--------------------------------------
**  Disability 
**--------------------------------------
* disab
// only pension

gen disab=0 if  wstat>0 &  wstat<.	
replace disab=1 if (p_w12==9 | p_w13==9 | p_w14==9) & wave<=5
replace disab=1 if (p_w12==3 | p_w13==3 | p_w14==3) & wave>5 // changed coding from wave 6 (2004) onwards


	lab var disab	"Disability (any)"
// 	lab var disab2c "Disability (min. category 2 or >30%)"
	lab val disab   yesno
	
**--------------------------------------
**  Chronic diseases
**--------------------------------------
* chron
recode p_c19a (2=0), gen(chron)

	lab var chron	"Chronic diseases"
	lab val chron   yesno
	
*################################
*#								#
*#	Subjective wellbeing		#
*#								#
*################################
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
// 	 foreach var in sat_hlth sat_life {
// 		 recode  `1' (0 1=1)(2 3 4=2)(5=3)(6 7 8=4)(9 10=5)(-3 -2=-2)(-1=-3), gen(`var'5)
// 		 recode  `1' (-3 -2=-2) (-1=-3), 	 gen(`var'10)
// 			 lab val `var'5  sat5
// 			 lab val `var'10 sat10
// 	 macro shift 1  
//  }
// 

 tokenize "			p_w92 		p_w228 		p_i01		p_ql04	p_c02 	p_c44 " 
	 foreach var in satinc 	satwork 	satfinhh 	satfam	sathlth satlife	{
		 recode  `1' (0 1=1)(2 3 4=2)(5=3)(6 7 8=4)(9 10=5)(-3 -2=-2)(-1=-3), gen(`var'5)
		 recode  `1'  (-1=-2), 	 gen(`var'10)
			 lab val `var'5  sat5
			 lab val `var'10 sat10
	 macro shift 1  
 }
 
*################################    
*#								#
*#	Other						#
*#								#
*################################
**--------------------------------------
**   Training
**--------------------------------------
* train train2
* NOTE: if age < 67, except if P$$E14=1

recode p_e18 (1 2=1)(3=0), gen(train)
replace train=0 if p_e14==1 & train<0 // Are you CURRENTLY studying at a school? - they were not asked

	lab val train yesno
	lab var train "Training (previous year)"

**--------------------------------------
**   work-edu link
**--------------------------------------
* eduwork
recode p_w100 (1 3 4=0) (2=1), gen(eduwork)


	lab var eduwork "Work-education skill fit"
	lab def eduwork 0 "0 Poor" 1 "1 Good" ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val eduwork eduwork
	
**--------------------------------------
**   Qualifications for job
**--------------------------------------
* wqualif
recode p_w100 (1 4=1) (2=2) (3=3), gen(wqualif)

	lab var wqualif "Qualifications for job"
	lab def wqualif 1 "1 Underqualified/Not qualified" 2 "2 Qualified (fit)" 3 "3 Overqualified" ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val wqualif wqualif
	
	
**--------------------------------------
**   Volunteering
**--------------------------------------
* volunt

recode p_n35 (2=0), gen(volunt)

	lab val volunt yesno
	lab var volunt "Volunteering"

**--------------------------------------
**   Job security
**--------------------------------------
* volunt
recode p_w86a (1 2=0) (3 4=1), gen(jsecu)
	
	lab def jsecu 	 1 "Insecure" 0 "Secure"  ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab def jsecu2 	 1 "Insecure" 0 "Secure" 2 "Hard to say" ///
// 					-1 "-1 MV general" -2 "-2 Item non-response" ///
// 					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab var jsecu "Job insecurity [2]"
// 	lab var jsecu2  "Job insecurity [3]"


**|=========================================================================|
**|  SES Indices
**|=========================================================================|	

**--------------------------------------
**   Occupational status (ISEI)
**--------------------------------------
* isei 
iscogen isei08 = isei(isco08_4), from(isco08)
 	lab var isei08 "ISEI-08: International Socio-Economic Index of occupational status"

iscogen isei88 = isei(isco88_4), from(isco88)
	lab var isei88 "ISEI-88: International Socio-Economic Index of occupational status"
	
 
 
	
	
**--------------------------------------
**   Treiman's international prestige scale (SIOPS) 
**--------------------------------------
iscogen siops08 = siops(isco08_4) , from(isco08)
	lab var siops08 "SIOPS-08: Treiman's international prestige scale" 

iscogen siops88 = siops(isco88_4) , from(isco88)
	lab var siops88 "SIOPS-88: Treiman's international prestige scale" 
	
**--------------------------------------
*** MPS (German Magnitude Prestige Scale; Christoph 2005)
**--------------------------------------	
iscogen mps88 = mps(isco88_4), from(isco88)


**--------------------------------------
**   EGP / ESEC
**--------------------------------------	
// 	iscogen EGP = egp11(job selfemp nemployees), from(isco88)
//
// 	 oesch
	 
	 
**--------------------------------------
**  Indexes already availible in SHP 
**--------------------------------------	

// cspmaj gldmaj esecmj  caimaj wr3maj //  
// tr1maj - siops 88 version 

 
	 
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
recode p__o17 (0/1=1)(2/4 5 6/8 18=2)(12/17 =3) , gen(fedu3)

	lab val fedu3 edu3
	lab var fedu3 "Father's education: 3 levels"

	
* edu4
recode p__o17 (0=1)(1=2)(2/4 5 6/8 18=3)(12/17 =4) , gen(fedu4)

	lab val fedu4 edu4
	lab var fedu4 "Father's education: 4 levels"
	

*** Mother 
*edu3
recode p__o34 (0/1=1)(2/4 5 6/8 18=2)(12/17 =3) , gen(medu3)

	lab val medu3 edu3
	lab var medu3 "Mother's education: 3 levels"

	
* edu4
recode p__o34 (0=1)(1=2)(2/4 5 6/8 18=3)(12/17 =4) , gen(medu4)

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

*** migr - specifies if respondent foreign-born or not.
lab def migr ///
0 "Native-born" ///
1 "Foreign-born" ///
-1 "MV General" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

gen migr=. 
replace migr=0 if p_d160==1 //native-born
replace migr=1 if p_d160==2 // foreign born
*replace migr=0 if migr==. & nat_1_==8100 & (p_d160<=0 | p_d160==.) // born in Switzerland, but p_d160 missing
*replace migr=1 if migr==. & inrange(nat_1_, 8200, 8999) & (p_d160<=0 | p_d160==.) //foreign-born based on first nationality, but p_d160 missing

lab val migr migr

*fill MV
	bysort pid: egen temp_migr=mode(migr), maxmode // identify most common response
	replace migr=temp_migr if migr==. & temp_migr>=0 & temp_migr<.
	replace migr=temp_migr if migr!=temp_migr // correct inconsistent cases
	
*specify some missing:
replace migr=-2 if migr==. & (p_d160==-1 | p_d160==-2) //DK/Refusal
replace migr=-3 if migr==. & p_d160==-3 //NA

**--------------------------------------
**   COB respondent, father and mother
**--------------------------------------	
// NOTE:because of the extensive list of countries, a separate do-file generates the variables for the country of birth of the respondent and their parents categories by region. (see additional do-file for details)

do "${Grd_syntax}\05_SHP\ch_02add_labels_COB.do" 
//generates temporary workingvariables (*t) for cob respondent and both parents	

*** Identify valid COB and fill across waves  
sort pid wave 

*** Generate valid stage 1 - mode across the waves (values 0-10)
	// It takes the value of the most common valid answer between 0 and 10 
	// If there is an equal number of 2 or more answers, it returns "." - filled in next steps
	
	foreach var in cob_rt cob_mt cob_ft {
	bysort pid: egen mode_`var'=mode(`var')
	}
	
*** Generate valid stage 2 - first valid answer provided (values 1-9)
	// It takes the value of the first recorded answer between 0 and 9 (so ignores 10 "other")
	// These are used to fill COB in cases: 
	//	(a) equal number of 2 or more answers (remaining MV)
	//	(b) there is a valid answer other than 10 but the mode (stage 1) returns 10
	
	foreach var in cob_rt cob_mt cob_ft {
	by pid (wave), sort: gen temp_first_`var'=`var' if ///
			sum(inrange(`var', 0,9)) == 1 &      ///
			sum(inrange(`var'[_n - 1],0,9)) == 0 // identify 1st valid answer in range 0-9
	bysort pid: egen first_`var'=max(temp_first_`var') // copy across waves within pid
	drop  temp_first_`var'
	}
	
*** Fill the valid COB across waves
	foreach var in cob_r cob_m cob_f {
	gen `var' = mode_`var't // stage 1 - based on mode
	replace `var' = first_`var't if `var'==. & inrange(first_`var't, 0,9) // stage 2 - based on the first for MV
	replace `var' = first_`var't if `var'==10 & inrange(first_`var't, 0,9) // stage 2 - based on the first for 10'other'
	drop `var't
	*
	label values `var' COB
	}
	
	rename cob_r cob
	
replace migr=0 if (migr==. | migr<0) & cob==0
replace migr=1 if (migr==. | migr<0) & inrange(cob, 1, 10)
replace cob=0 if (cob==. | cob<0) & migr==0
replace cob=10 if (cob==. | cob<0) & migr==1


**--------------------------------------
**   Migration Background (parents foreign-born)
**--------------------------------------	
//if father/mother foreign born
gen migr_f=.
replace migr_f=0 if p__o20==8100 //Swiss-born
replace migr_f=1 if inrange(p__o20, 8200, 8999) //foreign-born

gen migr_m=.
replace migr_m=0 if p__o37==8100 //Swiss-born
replace migr_m=1 if inrange(p__o37, 8200, 8999) //foreign-born

*fill MV
	bysort pid: egen temp_migr_f=mode(migr_f), maxmode // identify most common response
	replace migr_f=temp_migr_f if migr_f==. & temp_migr_f>=0 & temp_migr_f<.
	replace migr_f=temp_migr_f if migr_f!=temp_migr_f // correct a few inconsistent cases

	bysort pid: egen temp_migr_m=mode(migr_m), maxmode // identify most common response
	replace migr_m=temp_migr_m if migr_m==. & temp_migr_m>=0 & temp_migr_m<.
	replace migr_m=temp_migr_m if migr_m!=temp_migr_m // correct a few inconsistent cases

	drop temp*

**--------------------------------------
**   Migrant Generation
**--------------------------------------	
//NOTE: migr_gen - migrant generation of the respondent - is a derived variable (from migr, migr_f and migr_m)

lab def migr_gen ///
0 "no migration background" ///
1 "1st generation" ///
2 "2st generation" ///
3 "2.5th generation" ///
4 "incomplete information parents"

gen migr_gen=.

* 0 "No migration background"
replace migr_gen=0 if migr==0 & (migr_f==0 & migr_m==0) // respondent and both parents native-born
replace migr_gen=0 if migr==0 & ///
	 ((migr_f==0 & migr_m==.) | (migr_f==. & migr_m==0)) // respondent native-born, one parent native other unknown
replace migr_gen=0 if migr==1 & (migr_f==0 & migr_m==0) // respondent foreign-born but both parents native

* 1 "1st generation"
replace migr_gen=1 if migr==1 & (migr_f==1 & migr_m==1) // respondent and both parents foreign-born
replace migr_gen=1 if migr==1 & ///
	((migr_f==1 & migr_m==.) | (migr_m==1 & migr_f==.)) // respondent, one parent foreign-born other  unknown
replace migr_gen=1 if migr==1 & ///
	((migr_f==1 & migr_m==0) | (migr_m==1 & migr_f==0)) // respondent and one parent foreign-born, other native born

*2 "2st generation"
replace migr_gen=2 if migr==0 & (migr_f==1 & migr_m==1) // native-born, both parents foreign born
replace migr_gen=2 if migr==0 & ///
	((migr_f==1 & migr_m==.) | (migr_m==1 & migr_f==.)) // native-born, one parent foreign-born other missing

*3 "2.5th generation"
replace migr_gen=3 if migr==0 & ///
	((migr_f==1 & migr_m==0) | (migr_m==1 & migr_f==0)) // native-born, one parent foreign-born other native-born	
	 
* Incomplete information parents
replace migr_gen=4 if migr==0 & migr_f==. & migr_m==. // respondent native-born, both parents unknown
replace migr_gen=4 if migr==1 & (migr_f==. & migr_m==.) // respondent foreign-born, both parents unknown
replace migr_gen=0 if migr==1 & ///
	 ((migr_f==0 & migr_m==.) | (migr_f==. & migr_m==0)) // respondent native-born, one parent native other unknown

  
	label values migr_gen migr_gen

**--------------------------------------------
**   Mother tongue / language spoken as child
**--------------------------------------------	
/* Not indluded in the current version due to too many MV
lab def langchild ///
0 "same as country of residence" ///
1 "other" ///
-1 "MV general" ///
-2 "DK/refusal" ///
-3 "NA" ///

//NB multiple officially recognised languages: German, French, Italian and Romansh
// 'Which language do you relate to and master best?'

gen langchild=.
replace langchild=0 if p_e16==1 //Swiss-German
replace langchild=0 if p_e16==2 // German
replace langchild=0 if p_e16==3 // French
replace langchild=0 if p_e16==4 // Swiss-French
replace langchild=0 if p_e16==5 // Romansh-Italian
replace langchild=0 if p_e16==6 // Romansh
replace langchild=0 if p_e16==7 // Italian
replace langchild=1 if inrange(p_e16, 8, 14) // Other specified languages

lab val langchild langchild
	
*fill MV
	bysort pid: egen temp_lc=mode(langchild), maxmode // identify most common response
	replace langchild=temp_lc if langchild==. & temp_lc>=0 & temp_lc<.
	replace langchild=temp_lc if langchild!=temp_lc // correct a few inconsistent cases
	
	drop temp_lc
*/
*################################
*#								#
*#	Religion					#
*#								#
*################################	 
**--------------------------------------
**   Religiosity
**--------------------------------------
lab def relig ///
0 "Not religious/Atheist/Agnostic" ///
1 "Religious" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

/*
p_r01 coding:
-3.Inap
-2.NA
-1.DK
1.Protestant or Reformed
2.Roman Catholic
3.Christian Catholic
4.Other Christian
5.Jewish
6.Muslim
7.Other
8.No denomination or religion
9.Evangelical (free)
10.Christian orthodox
11.Buddhist
12.Hindu
*/

recode p_r01 (8=0) (1/7=1) (9/12=1) (-3=-3) (-2=-2) (-1=-1), gen(relig)

*specify waves when not asked
replace relig=-8 if inlist(wavey, 2010, 2011, 2013, 2014, 2016, 2017, 2019, 2020)

lab val relig relig


**--------------------------------------
**   Religion - Attendance
**--------------------------------------	
lab def attendance ///
1 "Never or practically never" ///
2 "Less than once a month" ///
3 "At least once a month" ///
4 "Once a week or more" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

recode p_r04 (1/3=1) (4/5=2) (6/7=3) (8/9=4) (-3=-3) (-2=-2) (-1=-1), gen(relig_att)

*specify for years when not asked (i.e. prior to 2016)
replace relig_att=-8 if inlist(wavey, 2010, 2011, 2013, 2014, 2016, 2017, 2019, 2020)


lab val relig_att attendance

	 
	 
*################################
*#								#
*#	Weights						#
*#								#
*################################	 
**--------------------------------------
**   Cross-sectional sample weight
**--------------------------------------	
// must add vars to the main file (in sytax 02) - vars changes names! 
// wi17css
// gen wtcs= 
 
  
**--------------------------------------
**   Cross-sectional population weight
**--------------------------------------	
/*
// must add vars to the main file (in sytax 02) - vars changes names! 
CNEF info:
All weights listed for individuals other than those with a full interview are 0 (this applies especially for all Proxy Individuals!).
Original survey variables in files shp$$_p_user ($$=1999-2017):
gen W11101_y=weip$$tp (from 2004 on, the SHP weights wp$$t1p are used (apply to the combined samples SHP I and SHP II, see variable X11104), from 2014 on, the weights wi$$csp are used (apply to the combined samples SHP I and SHP II and SHP III)
*/
// wi17csp
// gen wtcp= 
 

**--------------------------------------
**   Longitudinal Weight
**--------------------------------------		 
	



**|=========================================================================|
**|  KEEP
**|=========================================================================|

keep													///
wave pid hid   age*    edu* intmonth intyear	///
yborn kid*  emplst* public* size* wh* fptime* 	///
supervis  	un_* selfemp* entrep* retf* oldpens disabpens exp		///
neverw inc* disab chron sat*  train 						///
eduwork wqualif volunt jsecu		///
pdate isced occupa		///
is1maj is2maj is3maj is4maj cspmaj gldmaj esecmj tr1maj caimaj wr3maj noga2m		///
xis1ma xis2ma xis3ma xis4ma		///
p_c01 x_c05 wavey	///
marstat* parstat* mlstat* livpart civsta p_d29	///
nvmarr haspart livpart respstat	///
divor separ widow	///
nempl isei* siops* mps* isco* fedu* medu* ///
migr* cob*   relig*



**|=========================================================================|
**|  SAVE
**|=========================================================================|
 
	 
save "${shp_out}\ch_02b_wave.dta", replace  	

	 
*____________________________________________________________________________
*--->	END	 <---








