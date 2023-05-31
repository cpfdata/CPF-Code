*
**|=========================================|
**|	    ####	CPF	v1.5		####		|
**|		>>>	HILDA						 	|
**|		>>	02_1 Harm - Combined			|
**|-----------------------------------------|
**|		Konrad Turek 	| 	2023			|
**|=========================================|
*

**--------------------------------------
** Open merged dataset
**-------------------------------------- 
*** Combined all waves (large file) 

use "${hilda_out}\au_01_combined_2001_20${hilda_w}.dta", clear

*############################
*#			-				#
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

rename  xwaveid pid
rename  hhrhid hid // from 1st interview, there are more ids for those who changed hh (hgxid*)


gen intyear=substr(hhhqivw, -4, 4)
	destring intyear, replace force  
	replace intyear=-1 if intyear==-4
	
gen intmonth=substr(hhhqivw, -7, 2)
	destring intmonth, replace force  
	replace intmonth=-1 if intmonth==-4
	
rename wave wavey
egen wave = group(wave)

// gen country="Australia"
gen country=1

// gen data="$cntr"


sort pid wave



*** Wave first interviewed 
* based on original variable - does not identify correctly all cases
// 	gen temp1=wave if hhpq==2
// 	bysort pid: egen wave1st=max(temp1)
// 	drop temp1
* to fill MV:
	bysort pid: egen wave1st = min(cond(hgint == 1, wave, .))

*** Respondent status 
recode hgint (0=3), gen(respstat)
	lab def respstat 	1 "Interviewed" 					///
						2 "Not interviewed (has values)" 	///
						3 "Not interviewed (no values)"
	lab val respstat respstat

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
rename hhiage age

 	lab var age "Age" 

 

* Birth year

gen yborn=hgyob

	lab var yborn "Birth year" 

	
* Gender
* cnef
	
	
**--------------------------------------
** Place of living (e.g. size/rural)	 
**--------------------------------------
* place
/*Note: 
- Based on Australian Statistical Geography Standard (ASGS): Volume 4
https://www.abs.gov.au/ausstats/abs@.nsf/Lookup/by%20Subject/1270.0.55.004~July%202016~Main%20Features~Design%20of%20SOS%20and%20SOSR~12
- more info: hhsra hhsgcc hhssos
*/	

recode hhssos (0 1 = 1) (2 3=2) (-7=-1), gen(place)

 	lab var place "Place of living"
	lab def place 1 "city" 2 "rural area"
	lab val place place 

**--------------------------------------
** Education  
**--------------------------------------

 
*** edu3

recode edhigh1 (9 =1) (8 5=2) (1/4=3) (-10=-3) (10 =-1), gen(edu3)
replace edu3=2 if edhigh1==9 & edhists==1

	lab def edu3  1 "[0-2] Low" 2 "[3-4] Medium" 3 "[5-8] High" // 2 incl Vocational
	lab val edu3 edu3
	lab var edu3 "Education: 3 levels"

	
*** edu4
recode edu3 (2=3) (3=4), gen(edu4)
replace edu4=2 if edhigh1==9 & edhists>1 & edhists<=5
replace edu4=3 if edhigh1==9 & edhists==1

	lab def edu4  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" 4 "[5-8] Tertiary" 
	lab val edu4 edu4
	lab var edu4 "Education: 4 levels"
	
*** edu5

recode edhigh1 (9 =1) (8 5=3) (4 3=4) (2 1=5) (-10=-3) (10 =-1), gen(edu5)
replace edu5=2 if edhigh1==9 & edhists>1 & edhists<=5
replace edu5=3 if edhigh1==9 & edhists==1


	lab def edu5  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" 4 "[5-6] Tertiary lower(bachelore)"  ///
				  5 "[7-8] Tertiary upper (master/doctoral)"
	lab val edu5 edu5
	lab var edu5 "Education: 5 levels"

 

*** Fill MV based on other waves 
* only 1 cases identified (0900830)
// 	bysort pid: egen temp2=min(edu3) 
// 	bro pid wave age eduyn edu3 temp  temp2 if temp2<0
		* correct - this is not a universal syntax, but can be extended 
		* eg. increase n (no of iterations) if necessary
		qui sum wave
		local max= r(max)
		forvalues  n= 1/`max'  {
		foreach e in 3 4 5 			{
		bysort pid (wave): replace edu`e'=edu`e'[_n+1] if age>24 & edu`e'[_n+1]>0 & edu`e'[_n+1]<. & edu`e'<0  		
		}
		}
 


*** eduy - based on the CNEF approach with minor modifications (almost exact results)
gen eduy=.
replace eduy=18.5 	if edhigh1==1
replace eduy=16		if edhigh1==2
replace eduy=15		if edhigh1==3
replace eduy=13		if edhigh1==4
replace eduy=12		if edhigh1==5
replace eduy=12		if edhigh1==8

replace eduy=0 if edhigh1==9 & edagels==1

replace eduy=11  if edhigh1==9 & edagels==2 & edhists==1
replace eduy=10  if edhigh1==9 & edagels==2 & edhists==2
replace eduy=9  if edhigh1==9 & edagels==2 & edhists==3
replace eduy=8  if edhigh1==9 & edagels==2 & edhists==4
replace eduy=7  if edhigh1==9 & edagels==2 & edhists==5
replace eduy=6  if edhigh1==9 & edagels==2 & edhists==6
replace eduy=6  if edhigh1==9 & edagels==2 & edhists==7
replace eduy=4  if edhigh1==9 & edagels==2 & edhists==8
 
replace eduy=11  if edhigh1==9 & edagels>2 & edhists==2
replace eduy=10  if edhigh1==9 & edagels>2 & edhists==3
replace eduy=9  if edhigh1==9 & edagels>2 & edhists==4
replace eduy=8  if edhigh1==9 & edagels>2 & edhists==5
replace eduy=7  if edhigh1==9 & edagels>2 & edhists==6
replace eduy=6  if edhigh1==9 & edagels>2 & edhists==7
replace eduy=4  if edhigh1==9 & edagels>2 & edhists==8

	* fill MV based on edu
	replace eduy=6 if eduy==. & edu5==1
	
	
	lab var eduy "Education: years"
	
	
	
*################################
*#								#
*#	Family relationship 		#
*#								#
*################################	


**--------------------------------------
** Primary partnership status  (from CNEF) 	 
**--------------------------------------
* Approach based on CNEF 
* NOTE: 
* - country differences in inclusion of having/living with partner
* - country differences in definition of ‘single’ 


recode mrcurr (1 2=1) (6=2)(5=3)(4=4)(3=5) (-10=-3) (-4 -3=-1), gen(marstat5)

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
*  De facto -> Never married (compare mrcms)


recode mrcurr (1=1) (2 6=2)(5=3)(4=4)(3=5) (-10=-3) (-4 -3=-1), gen(mlstat5)

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
* livpart
recode mrcms (1 5=1)(6=0)(2/4=0) (-10=-3)(-4 -3=-2), gen(livpart)
replace livpart=1 if (mrcms>=2 & mrcms<=4) & ordf==1
replace livpart=0 if (mrcms>=2 & mrcms<=4) & ordf==2

// 		lab var haspart "Has a partner"
		lab var livpart "Living together with partner"
		lab val livpart  yesno
		
		
		* Fill MV with cross-vars
		replace livpart=1 if mlstat5==1 & livpart==.
		replace livpart=1 if mlstat5==2 & livpart==. & marstat5==1
		replace livpart=0 if mlstat5==2 & livpart==. & marstat5==2
		replace livpart=0 if mlstat5==3 & livpart==.
		replace livpart=0 if mlstat5==4 & livpart==.
		replace livpart=0 if mlstat5==5 & livpart==.
		
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
	replace parstat6=1 if mlstat5==1 & livpart==.
	replace parstat6=2 if mlstat5==2 & livpart==. & marstat5==1
	replace parstat6=3 if mlstat5==2 & livpart==. & marstat5==2
	replace parstat6=4 if mlstat5==3 & livpart==.
	replace parstat6=5 if mlstat5==4 & livpart==.
	replace parstat6=6 if mlstat5==5 & livpart==.
	replace parstat6=1 if parstat6==0 & marstat5==1
 	replace parstat6=3 if parstat6==0 & marstat5==2

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
*  No mater if currently living with a partner
		

*** Single
// 		lab var csing "Single: not married and no partner"
// 		lab val csing yesno
								
*** Never married 
recode mrcms   (5 6=1) (1/4=0) (-10=-3) (-4 -3 .=-1), gen(nvmarr)

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
** Children 
**--------------------------------------
*  

gen kidsn_all=tchad
recode kidsn_all (-10=-3) (-4 -3=-1)

recode kidsn_all (1/max=1) (0=0), gen(kids_any)

egen kidsn_hh17= anycount(hgage1-hgage20), values(0/17)

egen kidsn_hh15= anycount(hgage1-hgage20), values(0/15)

*0-14 - several options 
egen kidsn_14=rowtotal(hhd0_4 hhd5_9 hhd1014) // Number of dependent children aged 0-4 (includes partner's children)
egen kidsn_hh14= anycount(hgage1-hgage20), values(0/14) // HH grid age info 
egen kidsn_hh14b=rowtotal(hh0_4 hh5_9 hh10_14) //Number of persons aged
	*kidsn_hh14 & kidsn_hh14 are very similar 

	lab var kids_any  "Has any children"
	lab val kids_any   yesno
	lab var kidsn_all  "Number Of Children Ever Had " 
	lab var kidsn_hh15   "Number Of Children in HH aged 0-15" 
	lab var kidsn_hh17   "Number of Children in HH aged 0-17"
	lab var kidsn_hh14   "Number Of Children in HH aged 0-14 (includes partner's children)" 
	lab var kidsn_14   	 "Number Of Dependent Children aged 0-14 (includes partner's children)" 

**--------------------------------------
** People in HH F14
**--------------------------------------
// clonevar nphh=d11106 
//
// 	lab var nphh   "Number of People in HH" 


	
*################################
*#								#
*#	Labour market situation		#
*#								#
*################################
 
**--------------------------------------
** Currently working 
**--------------------------------------
* cnef
	
	
**--------------------------------------  
** Employment Status 
**--------------------------------------
* emplst5

recode esbrd (1=1) (2=2) (3=4) (-10=-3), gen(emplst5)
replace emplst5=3 if (nlmact==1 | rtcomp==1 | rtcompn==1) 	/// self-rep retired completely 
					& hgage>=50 							/// age 45+
					& esbrd==3 								//  not active 
replace emplst5=3 if (nlmact==4 & helth==1 & (helthwk==1 | helthwk==3)) // disab
	egen temp=anymatch( ///
		edcq100 edcq110 edcq120 edcq200 edcq211 edcq221 edcq310 ///
		edcq311 edcq312 edcq400 edcq411 edcq413 edcq421 edcq500 ///
		edcq511 edcq514 edcq521 edcq524 edcq600 edcq611) 		///
		,v(1)
replace emplst5=5 if nlmact==3 & temp==1
	drop temp
replace emplst5=5 if emplst5==4 & edagels==2
replace emplst5=2 if esbrd==2
replace emplst5=1 if esbrd==1

	lab def emplst5	///
			1 "Employed" 			/// including leaves
			2 "Unemployed (active)"	///
			3 "Retired, disabled"	///
			4 "Not active/home"		/// home-working separate?  
			5 "In education"		///
			-1 "MV"
	lab val emplst5 emplst5
	lab var emplst5 "Employment status [5]"

	
// * emplst6
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
*
generate isco_1 = cond(jbm682 >=10, int(jbm682/10), .)
replace isco_1=0 if jbm682==1
replace isco_1=-2 if jbm682==-4|jbm682==-3
replace isco_1=-1 if jbm682==-7
replace isco_1=-3 if jbm682==-2 | jbm682==-1 | jbm682==-10


* For isco_2 a small recoding due to unfitting labels of categories
recode jbm682 	///
		(1=0)(10=11)(11=11)(12=10)(13=10)(20=20)(21=21)(22=22)(23=23)(24=20)	///
		(30=30)(31=31)(32=32)(33=30)(34=30)(40=40)(41=41)(42=42)(50=50)(51=51)	///
		(52=50)(61=61)(71=71)(72=72)(73=73)(74=70)(80=80)(81=81)(82=82)(83=83)	///
		(90=90)(91=95)(92=92)(93=93)	///
		(-4 -3=-2)(-7=-1)(-2 -1 -10=-3), gen(isco_2)


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




**--------------------------------------
** Industry
**--------------------------------------
* cnef
 
**--------------------------------------
** Public sector
**--------------------------------------
recode jbmmply (5=1) (1/4 6=0) (-10 -1=-3) (-4=-2) (-3=-1), gen(public)
replace public=0 if (public<0 | public==.) & (jbmmpl>0 & jbmmpl<.)
replace public=0 if (public<0 | public==.) & (jbmmplr>0 & jbmmplr<.)
replace public=1 if jbmmpl==5 | jbmmplr==5

	lab val public yesno
	lab var public "Public sector"

**--------------------------------------
** Size of organization	 
**--------------------------------------
*size 
/* NOTE:
- "Self-empl, no coworkers" only for waves 2005+
*/

//  	lab var size  "Size of organization [cont]"
// 	lab var size4 "Size of organization [4]"
// 	lab def size4 1 "<20" 2 "20-199" 3 "200-1999" 4 "2000+"  	///
// 				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
// 				-1 "-1 MV general" -2 "-2 Item non-response" 	///
// 				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val size4 size4
// 
 
* 
recode jbmwpsz (1 2=1) (3 4 =2) (5=3) (6 7=4) (8=5) (9 10 -4=-1) (-10 -1=-3), gen(size5b1)
recode jbmwps  (1=0) (2 3=1) (4 5 =2) (6=3) (7 8=4) (9=5) (10 11 -4=-1) (-10 -1=-3), gen(size5b2)

	gen size5b=size5b1
	replace size5b=size5b2 if size5b==.
	drop size5b1 size5b2

	lab var size5b "Size of organization [5b]"
	lab def size5b 1 "<10" 2 "10-49" 3 "50-99" 4 "100-499" 5 "500+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5b size5b
	
// 	lab var size5 "Size of organization [5]"
// 	lab def size5 1 "<10" 2 "10-49" 3 "50-99" 4 "100-999" 5 "1000+"  	///
// 				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
// 				-1 "-1 MV general" -2 "-2 Item non-response" 	///
// 				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val size5 size5



**--------------------------------------  
** hours conracted NA
**--------------------------------------
* wh_ctr
// 	lab var whweek_ctr "Work hours per week: conracted"


**--------------------------------------
** hours worked
**--------------------------------------
* wh_real wh_year

recode jbhruc (-10 -1=-3) (-6 -4 -3=-1), gen(whweek)
gen whmonth=whweek*4.3
replace whmonth=whweek if whweek<0

// recode e11101 (-1=-3) (-3=-1), gen(whyear)

// 	lab var whday "Work hours per day: worked"
	lab var whweek "Work hours per week: worked"
	lab var whmonth "Work hours per month: worked"
// 	lab var whyear "Work hours per year: worked"
 
 

**--------------------------------------
** full/part time
**--------------------------------------
* fptime_r fptime_h

recode esdtl (3/7=3)(-10=-3), gen(fptime_r)


*
gen fptime_h=.
replace fptime_h=1 if whweek>=35 & whweek<.
replace fptime_h=2 if whweek<35 & whweek>0
replace fptime_h=3 if whweek==0
replace fptime_h=3 if emplst5>1 & emplst5<.
 
	lab var fptime_r "Employment Level (self-report)"
	lab var fptime_h "Employment Level (based on hours)"
	
	lab def fptime 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other"
	lab val fptime_r  fptime_h fptime
	
**--------------------------------------
** overtime working NA
**--------------------------------------
 
**--------------------------------------
** Supervisor 	
**--------------------------------------
* supervis
recode jbmsvsr (2=0) (-10 -1=-3) (-4 -3=-1), gen(supervis)

	lab val supervis yesno
	lab var supervis "Supervisory position"
	
**--------------------------------------
** maternity leave  
**--------------------------------------
/* NOTE: 
- for 2011+
- v. low n - not useful  
*/	
 recode bncppl (-10 -1=-3), gen(mater)
   
	lab val mater yesno
	lab var mater "maternity leave "
	
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
** Unempl: reason   
**--------------------------------------
* pjljr pjotrea 

/*Notes: 
- create set of categories if harmon possible
*/
 

**--------------------------------------
** Unempl: actively looking for work 
**--------------------------------------
* un_act
recode esbrd (2=1) (1 3=0) (-10=-3), gen(un_act)

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

recode esbrd (1/3=0) (-10=-3), gen(selfemp) 
replace selfemp=1 if esempst==2|esempst==3
 
	lab val   selfemp   yesno
// 	lab var selfemp_v1 "Self-employed 1: all without Family Business"
	lab var selfemp "Self-employed 2: all with Family Business"
// 	lab var selfemp_v3 "Self-employed 3: based on income from self-empl"
	
 
**--------------------------------------
** Entrepreneur 
**--------------------------------------
* entrep
recode esbrd (1/3=0) (-10=-3), gen(entrep2) 
replace entrep2=1 if (esempst==2|esempst==3) & (jbmwps>1 & jbmwps<.) & wave>=5
replace entrep2=-8 if wave<5

// For waves 1-4 the question about no of employees does not distinguish "none" or "1"
// If waves 1-4 are neede, two approximations are possible:
// replace entrep2=1 if (esempst==2|esempst==3) &  wave<5 & (jbmwpsz>1 & jbmwpsz<.) // >=5 employees
// replace entrep2=1 if (esempst==2|esempst==3) &  wave<5   // includes self-employed


//   	lab val entrep yesno
//   	lab var entrep  "Entrepreneur (not farmer; has employees)"

	lab val entrep2 yesno
	lab var entrep2 "Entrepreneur (incl. farmers; has employees)"


**--------------------------------------
** Number of employees 
**--------------------------------------
recode jbmwps  (-4=-2)(-10 -1=-3)(-3=-1) (1/3 10=1) (4/9 11=2), gen(nempl)
recode jbmwpsz  (-4=-2)(-10 -1=-3)(1/2 9=1) (3/8 10=2), gen(temp_nempl)
replace nempl=temp_nempl if wave<5
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
/* retf - Criteria:
- Not working  
- Self-rep retired completely/never in workforce & age 50+
- Receives old-age pension & age 50+
- Age 65+ & not active 
*/
gen 	retf=0 if esbrd==1 | esbrd==2 | esbrd==3
replace retf=1 if  								///
			 (										///
			 (nlmact==1 | rtcomp==1 | rtcompn==1) 	/// Self-rep retired completely 
			 | (rtcomp==3 | rtcompn==3)				/// Self-rep never in workforce
			 )										///
			 & hgage>=50							/// age 50+
			 & esbrd==3								//  Not active 

replace retf=1 if (bncap==1 | bnfap==1) & esbrd==3	& hgage>=50 // Receives Age Pension & age 50+
replace retf=1 if 	(bncsrv==1 | bnfsrv==1) & hgage>=50	& esbrd==3	// Receives service pension
replace retf=1 if (hgage>=65 & esbrd==3)		  	// age>65 & not active 

	lab var retf "Retired fully (self-rep, NW, old-age pens, 50+)"
	lab val retf yesno 
	

// Another appraoch: retf
// gen 	retf=0 if esbrd==1 | esbrd==2 | esbrd==3
// replace retf=1 if 									///
// 			 (nlmact==1 | rtcomp==1 | rtcompn==1) 	/// self-rep retired completely 
// 			 & hgage>=45							/// age 45+
// 			 & (bncap==1 | bnfap==1)				///  Receives Age Pension
// 			 & esbrd==3								//  Not active 
//					  

	
/* Another appraoch: retf2 - Criteria:
- retf
- Receives service pension (years of service) & age 50+ & NW
- Disabled OR receives diability pension & age 50+ & NW  
 */	
//
// gen retf2=retf
// replace retf2=1 if 	(bncsrv==1 | bnfsrv==1) & hgage>=50	& esbrd==3	// Receives service pension
//
// replace retf2=1 if  (nlmact==4)											///	self-rep disabled 
// 					& (bncdsp==1 | bnfdsp==1 | bncdva==1 | bnfdva==1 )	/// pension disab
// 					& hgage>=50							  				///  age 50+
// 					& esbrd==3											//  Not active 

//	old version:				
// gen 	retf2=0 if esbrd==1 | esbrd==2 | esbrd==3
// replace retf2=1 if 									 		///
// 			 (												///
// 				((nlmact==1 | rtcomp==1 | rtcompn==1) 		/// self-rep retired completely 
// 				  & (bncap==1 | bnfap==1 					/// Receives Age Pension
// 				  | bncsrv==1 | bnfsrv==1))					/// Receives service pension 
// 				| (nlmact==4 								///	self-rep disabled 
// 				  & (bncdsp==1 | bnfdsp==1 | bncdva==1 | bnfdva==1 ))	/// pension disab
// 			 ) 												///
// 			 & hgage>=45							  		///  age 45+
// 			 & esbrd==3										//  Not active 
			  				

// 	lab var retf2 "Retired (broad: any pens(old-age, disab, service))"
// 	lab val retf2 yesno 
	
	
	
	
	
	
**-------------------------------------- 
** Age of retirement  
**--------------------------------------					  
*    
/*Note: 
- many low ages - redefine for analysis 
*/	
// gen aret=rtyr-hgyob if rtyr>0 & rtyr<.
// replace aret=rtyrn-hgyob if rtyr==. & rtyrn>0 & rtyrn<.

 		  

**--------------------------------------
** Planed ret age 						 
**--------------------------------------	
* rtiage1


**-------------------------------------- 
** Early/regular retirement 
**--------------------------------------					  
* based on aret
		  

**-------------------------------------- 
** Receiving old-age pension   
**--------------------------------------					  
*  oldpens 
/*Note: 
-  
*/								  
gen oldpens=0 if esbrd==1 | esbrd==2 | esbrd==3
replace oldpens=1 if bncap==1 | bnfap==1

	lab var oldpens "Receiving old-age pension"
	lab val oldpens yesno 
	


**-------------------------------------- 
** Receiving disability pension   
**--------------------------------------		
* disabpens
gen disabpens=0 if esbrd==1 | esbrd==2 | esbrd==3
replace disabpens=1 if (bncdsp==1 | bnfdsp==1 | bncdva==1 | bnfdva==1 )

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
recode ehtjb (-10 -1=-3) (-7 -6 -4 -3=-1), gen(exp)
	lab var exp "Labor market experience"

**--------------------------------------
**   Experience in current occupation
**--------------------------------------
* expocc
// recode jbocct (-10 -1=-3) (-6 -4 -3=-1), gen(expocc)
// 	lab var expocc "Experience in current occupation (years)"


**--------------------------------------
**   Experience in org
**--------------------------------------
* exporg
recode 	jbempt (-10 -1=-3) (-6 -4 -3=-1), gen(exporg)
	lab var exporg "Experience in organisation"
	
**--------------------------------------
**   Never worked
**--------------------------------------	
*neverw
gen 	neverw=0 if esbrd==1 | esbrd==2 | esbrd==3
replace neverw=1 if (rtcomp==3 | rtcompn==3)				// Self-rep never in workforce

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
// tifefp tifeftp // gross 
// tifditp // disposable 
gen inctot_yn=tifditp
gen inctot_mn=tifditp/12
	lab var inctot_yn "Individual Income (All types, year, net)"
	lab var inctot_mn "Individual Income (All types, month, net)"


	
* all jobs 
// clonevar incjobs_yg=i11110 // wsfei


// 	lab var incjobs_yn "Individual Labor Earnings (All jobs, year, net)"
// 	lab var incjobs_yg "Individual Labor Earnings (All jobs, year, gross)"
// 	lab var incjobs_mn "Individual Labor Earnings (All jobs, month, net)"

* main job
gen incjob1_mg=wscmei*4.2
 
// 	lab var incjob1_yg  "Salary from main job (year, gross)"
// 	lab var incjob1_yn  "Salary from main job (year, net)"
	lab var incjob1_mg "Salary from main job (month, gross)"
// 	lab var incjob1_mn "Salary from main job (month, net)"
	

*
**--------------------------------------
*   HH wealth
**-------------------------------------- 
* cnef
	
**--------------------------------------
**   Income - subjective NA
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
// from cnef aslo m11126 

recode gh1  (-1=-3) (-3 -8 -5 -4=-1) , gen(srh5)

	lab var srh5 "Self-rated health"
	lab def srh5 5 "Very bad" 4 "Bad" 3 "Satisfactory" 2 "Good" 1 "Very good"
	lab val srh5 srh5

 

**--------------------------------------
**  Disability 
**--------------------------------------
* disab

gen disab=0 if hgni==0
replace disab=1 if helth==1 & (helthwk==3 | (helthwk==1 & helthdg>=1))

	lab var disab	"Disability (any)"
// 	lab var disab2c "Disability (min. category 2 or >30%)"
	lab val disab   yesno
	
	
**--------------------------------------
**  Chronic diseases/condition 
**--------------------------------------
* chron
/* NOTE: 
	- define "chronic" before using. Choose specific chronic conditions which 
	  should be included (var 'temp') 
*/
gen chron=0 if hgni==0
	egen temp=anymatch(																///
		hespnc hehear hespch hebflc heslu heluaf hedgt helufl henec hecrpa hedisf 	///
		hemirh hesbdb hecrp hehibd hemed heoth ), v(1)
replace chron=1 if helth==1 & temp==1
drop temp

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
// jbmswrk jbmsall //work
// jbmspay // pay
// losatfs // fin sit
// losatyh //healt
// losat // life

	lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" 	///
				 4  "4 Mostly sat" 5 "5 Completely sat"						///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 		///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
 

	lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"

 * Recode   10-point into 5-point versions 
 tokenize " losatfs jbmspay jbmsall losatyh losat" 
	 foreach var in  satfinhh satinc satwork sathlth satlife {
		 recode  `1' (0 1=1)(2 3 4=2)(5=3)(6 7 8=4)(9 10=5)(-10 -2 -1=-3)(-4 -3=-2), gen(`var'5)
		 recode  `1' (-10 -2 -1=-3)(-4 -3=-2), 	 gen(`var'10)
			 lab val `var'5  sat5
			 lab val `var'10 sat10
	 macro shift 1  
 }

* Recode   10-point into 5-point versions 
//  tokenize "m11125 p11101" 
// 	 foreach var in sat_hlth sat_life {
// 		 recode  `1' (0 1=1)(2 3 4=2)(5=3)(6 7 8=4)(9 10=5)(-3 -2=-2)(-1=-3), gen(`var'5)
// 		 recode  `1' (-3 -2=-2) (-1=-3), 	 gen(`var'10)
// 			 lab val `var'5  sat5
// 			 lab val `var'10 sat10
// 	 macro shift 1  
//  }
 
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

 
*################################
*#								#
*#	Other						#
*#								#
*################################
**--------------------------------------  
**   Training
**--------------------------------------
* train train2
// tatrwrk  //2003-06 (DV: jbtremp + ujtrwrk)
// jttrwrk  //2007+

recode tatrwrk (2=0) (-10 -1=-3) (-4 -3=-2), gen(temp1)
recode jttrwrk (2=0) (-10 -1=-3) (-4 -3=-2), gen(temp2)
gen train = temp1
replace train = temp2 if wavey>=2007
	drop temp*
	
	lab val train yesno
	lab var train "Training (previous year)"

	
**--------------------------------------
**   work-edu link  NA
**--------------------------------------
* eduwork

// 	lab var eduwork "Work-education skill fit"
// 	lab def eduwork 0 "0 Poor" 1 "1 Good" ///
// 					-1 "-1 MV general" -2 "-2 Item non-response" ///
// 					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val eduwork eduwork


**--------------------------------------
**   Qualifications for job NA
**--------------------------------------
* wqualif
// recode  (=1) (=2) (=3), gen(wqualif)
//
// 	lab var wqualif "Qualifications for job"
// 	lab def wqualif 1 "1 Underqualified/Not qualified" 2 "2 Qualified (fit)" 3 "3 Overqualified" ///
// 					-1 "-1 MV general" -2 "-2 Item non-response" ///
// 					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val wqualif wqualif
	
	
**--------------------------------------
**   Volunteering NA
**--------------------------------------
* volunt

// 	lab val volunt yesno
// 	lab var volunt "Volunteering"
	
	
**--------------------------------------
**   Job security
**--------------------------------------
/* NOTE:
- define according to the goal of a research using variables below
- compare definition between countries 
- below is an example of combination
*/  
* used to create jsecu2
// jbmploj // Percent chance of losing job
// jomsf 	// secure future in my job
*Alternatives:
// jbmssec // job sec satisf
// jomwf 	// I worry about the future of my job

recode jbmploj (0/14=0) (15/100=1) (-10 -1 999=-3) (-4 -3=-2), gen(jsecu)
recode jbmploj (0/14=0) (15/100=1) (-10 -1 999=-3) (-4 -3=-2), gen(jsecu2_a)
recode jomsf (1/3=1) (4=2) (5/7=0) (-10 -1 -8=-3) (-4 -6 -5=-2), gen(jsecu2_c)

// recode jbmssec (0/4=1) (5=2) (6/10=0)(-10 -1 -2=-3) (-4=-2) (-3=2), gen(jsecu2_b)
// recode jomwf (1/3=0) (4=2) (5/7=1) (-10 -1 -8=-3) (-4 -6 -5=-2), gen(jsecu2_d)

	
gen jsecu2=jsecu2_a
replace jsecu2=2 if (jsecu2_a==0 & jsecu2_c==1) |	///
					(jsecu2_a==1 & jsecu2_c==0) |	///
					(jsecu2_c==2)  
drop jsecu2_a jsecu2_c					
					
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

*################################
*#								#
*#	SES Indices					#
*#								#
*################################

**--------------------------------------
**   Occupational status (ISEI)
**--------------------------------------
* isei 
gen temp_isco4=isco_2*100
iscogen isei08 = isei(temp_isco4)

	lab var isei08 "ISEI-08: International Socio-Economic Index of occupational status"

iscogen isei88 = isei(temp_isco4), from(isco88)
	lab var isei88 "ISEI-88: International Socio-Economic Index of occupational status"
	
* Australia-specific scale provided by HILDA 
clonevar osi_aus	= jbmo6s
	lab var osi_aus "Australia: occupational status scale AUSEI06"
	
	
**--------------------------------------
**   Treiman's international prestige scale (SIOPS) 
**--------------------------------------
iscogen siops08 = siops(temp_isco4)
	lab var siops08 "SIOPS-0: Treiman's international prestige scale" 

iscogen siops88 = siops(temp_isco4) , from(isco88)
	lab var siops88 "SIOPS-88: Treiman's international prestige scale" 	
	
**--------------------------------------
*** MPS (German Magnitude Prestige Scale; Christoph 2005)
**--------------------------------------	
iscogen mps88 = mps(temp_isco4) , from(isco88)
	lab var mps88 "MPS: German Magnitude Prestige Scale" 

	
**--------------------------------------
**   EGP / ESEC
**--------------------------------------	
	
// 	iscogen egp = egp11(temp_isco4 selfemp  ), from(isco88)

	// iscogen egpH = egp(temp_isco4 selfemp  ), from(isco88)
	
	
// 	oesch
// 	iscogen oesch = oesch(temp_isco4 selfemp  ), from(isco08)

	 	drop temp_isco4	

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
recode fmfsch (1/3=1) (4 5=2) (-10=-3)(-7=-1)(-4 -3=-2), gen(fedu3)
replace fedu3=3 if fmfhlq>0 & fmfhlq<5

	lab val fedu3 edu3
	lab var fedu3 "Father's education: 3 levels"

	
* edu4
recode fmfsch (1/2=1) (3=2) (4 5=3) (-10=-3)(-7=-1)(-4 -3=-2), gen(fedu4)
replace fedu4=4 if fmfhlq>0 & fmfhlq<5

	lab val fedu4 edu4
	lab var fedu4 "Father's education: 4 levels"
	

*** Mother 
*edu3
recode fmmsch (1/3=1) (4 5=2) (-10=-3)(-7=-1)(-4 -3=-2), gen(medu3)
replace medu3=3 if fmmhlq>0 & fmmhlq<5

	lab val medu3 edu3
	lab var medu3 "Mother's education: 3 levels"

	
* edu4
recode fmmsch (1/2=1) (3=2) (4 5=3) (-10=-3)(-7=-1)(-4 -3=-2), gen(medu4)
replace medu4=4 if fmmhlq>0 & fmmhlq<5

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

// fmfo61 fmfocc1
// fmf682o fmf682 
// and few other
// check overlap and best source 
	 
*** Mother  
// several
// check overlap and best source 

**--------------------------------------  
**   Parents' SES
**--------------------------------------
*** Father 
//  fmfo6os fmfocos fmfoccs fmfo6s

*** Mother  

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
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

gen migr=. 
replace migr=0 if ancob==1101 //native-born
replace migr=1 if (ancob>0 & ancob!=1101) //foreign-born
replace migr=1 if ancob<=0 & (ancitiz==2 | ancitiz==3) // foreign-born but country of birth missing, only small group

*specify some missing values
replace migr=-2 if migr==. & ancob==-1
replace migr=-1 if migr==. & ancob==-4 //refusal/not stated

*temp decode mv
mvdecode migr, mv(-2=.b\-1=.a)

*fill MV
	bysort pid: egen temp_migr=mode(migr), maxmode // identify most common response
	replace migr=temp_migr if (migr==. | migr==.a | migr==.b) & temp_migr>=0 & temp_migr<.
	replace migr=temp_migr if migr!=temp_migr // correct a few inconsistent cases
	
mvencode migr, mv(.b=-2\.a=-1)

lab val migr migr


**--------------------------------------
**   COB respondent, father and mother
**--------------------------------------	

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


***note: because cob labels are based on australian classification scheme, coding is fairly straightforward and countries are grouped based on the larger global region (first-digit)

foreach var in ancob fmfcobn fmmcobn {
	gen cob_`var'=. // temp working var
	replace cob_`var'=0 if `var'==1101
	replace cob_`var'=1 if inrange(`var', 1102, 1999)
	replace cob_`var'=2 if inrange(`var', 2000, 2999)
	replace cob_`var'=3 if inrange(`var', 3000, 3999)
	replace cob_`var'=4 if inrange(`var', 4000, 4999)
	replace cob_`var'=5 if inrange(`var', 5000, 5999)
	replace cob_`var'=6 if inrange(`var', 6000, 6999)
	replace cob_`var'=7 if inrange(`var', 7000, 7999)
	replace cob_`var'=8 if inrange(`var', 8000, 8999)
	replace cob_`var'=9 if inrange(`var', 9000, 9999)
	*other
	replace cob_`var'=10 if `var'==912 // Former USSR (multiple regions)
	replace cob_`var'=3 if `var'==913 // Former Yugoslavia (all countries in same region)
	replace cob_`var'=-1 if `var'<=0
}

replace cob_ancob=10 if (ancob<=0 | ancob==.) & migr==1 // fill few missing cases where cob is missing but respondent is foreign-born

rename cob_ancob cob_rt
rename cob_fmfcobn cob_ft
rename cob_fmmcobn cob_mt // temp working vars

//MV
*** Identify valid COB and fill across waves  
sort pid wave 

*** Generate valid stage 1 - mode across the waves (values 1-10)
	// It takes the value of the most common valid answer between 1 and 10 
	// If there is an equal number of 2 or more answers, it returns "." - filled in next steps
	
	foreach var in cob_rt cob_mt cob_ft {
	bysort pid: egen mode_`var'=mode(`var') if ///
		inrange(`var', 0, 9)
	}
	
*** Generate valid stage 2 - first valid answer provided (values 0-9)
	// It takes the value of the first recorded answer between 1 and 9 (so ignores 10 "other")
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
	replace `var' = first_`var't if `var'==10 & inrange(first_`var't, 1,9) // stage 2 - based on the first for 10'other'
	drop `var't
	*
	label values `var' COB
	}
	
*Fill MV based on migr
	replace cob_r=10 if (cob_r==. | cob_r<0) & migr==1
	replace cob_r=-1 if cob_r==. & migr==-1
	
rename cob_r cob


**--------------------------------------
**   Migration Background (parents foreign-born)
**--------------------------------------	

gen migr_f=.
replace migr_f=0 if fmfcob==1101 //Australian-born
replace migr_f=1 if (fmfcob>0 & fmfcob!=1101) //foreign-born

gen migr_m=.
replace migr_m=0 if fmmcob==1101 //Australian-born
replace migr_m=1 if (fmmcob>0 & fmmcob!=1101) //foreign-born

*fill MV
	bysort pid: egen temp_migr_f=mode(migr_f), maxmode // identify most common response
	replace migr_f=temp_migr_f if migr_f==. & temp_migr_f>=0 & temp_migr_f<.
	replace migr_f=temp_migr_f if migr_f!=temp_migr_f // correct a few inconsistent cases

	bysort pid: egen temp_migr_m=mode(migr_m), maxmode // identify most common response
	replace migr_m=temp_migr_m if migr_m==. & temp_migr_m>=0 & temp_migr_m<.
	replace migr_m=temp_migr_m if migr_m!=temp_migr_m // correct a few inconsistent cases

	drop temp*
	
*fill MV cob based on migr
	foreach p in f m {
		replace cob_`p'=10 if (cob_`p'==. | cob_`p'<0) & migr_`p'==1
		replace cob_`p'=0 if (cob_`p'==. | cob_`p'<0) & migr_`p'==0
	}

	lab val migr_f migr_m migr

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
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

gen langchild=.
replace langchild=0 if anengf==1 //English first language
replace langchild=1 if anengf==2 //English not first
replace langchild=-2 if anengf==-10 // non-responding person
replace langchild=-1 if anengf==-4 // refused
replace langchild=-1 if anengf==-3 // DK
replace langchild=-8 if anengf==-1 //Not asked

lab val langchild langchild
	
*fill MV
gen langchild_t=langchild
	bysort pid: egen temp_lc=mode(langchild), maxmode // identify most common response
	replace langchild=temp_lc if langchild==. & temp_lc>=0 & temp_lc<.
	replace langchild=temp_lc if langchild!=temp_lc // correct a few inconsistent cases
	
	drop temp_lc langchild_t
*/

*################################
*#								#
*#	    Religion			 	#
*#								#
*################################

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

recode religb (7000/7999=0) (1000/6000=1) (8000/9000=1) (-1=-8) (-2=-3) (-10=-2) (-9/-3=-1) (0=-1) (else=.), gen(relig)

*specify for years when not asked
replace relig=-8 if ! inlist(wavey,2004, 2007, 2010, 2014, 2018)

lab val relig relig

**--------------------------------------  
** Religion - Attendance
**--------------------------------------
lab def attendance ///
1 "Never or practically never" ///
2 "Less than once a month" ///
3 "At least once a month" ///
4 "Once a week or more" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey" ///


recode relat (1=1) (2/4=2) (5/6=3) (7/9=4) (-1=-8) (-2=-3) (-10=-2) (-9/-3=-1) (0=-1) (else=.), gen(relig_att)

*specify for years when not asked
replace relig_att=-8 if !inlist(wavey, 2004, 2007, 2010, 2014, 2018)

lab val relig_att attendance

	 
*################################
*#								#
*#	Weights						#
*#								#
*################################	 
**--------------------------------------
**   Cross-sectional sample weight
**--------------------------------------	

gen wtcs=hhwtrps 
 
  
**--------------------------------------
**   Cross-sectional population weight
**--------------------------------------	

gen wtcp=hhwtrp
 
**--------------------------------------
**   Longitudinal Weight
**--------------------------------------		 

// gen wtl=lnwtrp
	 
**|===============================fv==========================================|
**|  KEEP
**|=========================================================================|
keep													///
hhwtes hhwtrp hhwtrps hhwtsc hhwtscs lnwte lnwtrp 	 	///
wave wavey wave1st pid yborn intyear intmonth country age	respstat		///
place edu*  	///	
marstat* parstat* mlstat* livpart nvmarr				///
kids*  	///
emplst* public size* wh* fptime* supervis mater	///
un_* selfemp* entrep* retf*  oldpens disab*		///
exp* inc*   chron* sat*  						///
train jsecu*			///
edhigh1	 ///
hhda10 hhad10 hhec10 hhed10 hhsad10 hhsec10 hhsed10 /// indexes
jbmo6s jbmoccs hgint hgivw ///
isco* isei* osi_aus siops*  srh5 wtcs wtcp mps* nempl	///
widow divor separ fedu* medu* neverw ///
cob* migr*   relig relig_att

sort pid wave 
order pid wave intyear  age  wavey
order hhw* lnw*, last

 
**|=========================================================================|
**|  SAVE
**|=========================================================================|
 
	 
save "${hilda_out}\au_02b_waves.dta", replace  	

	 
*____________________________________________________________________________
*--->	END	OF FILE <---








