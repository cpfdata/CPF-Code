*
**|=============================================|
**|	    ####	CPF	v1.5	####				|
**|		>>>	SOEP						 		|
**|		>>	New Vars for the merged dataset		|
**|---------------------------------------------|
**|		Konrad Turek 	| 	2023				|
**|=============================================|
*


**--------------------------------------
** Open merged dataset
**-------------------------------------- 
* 
use "${soep_out}\ge_01.dta", clear  	


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

gen intyear=piyear
replace intyear=syear if intyear<0
gen intmonth=pgmonth
recode intmonth (-5=-1)

egen wave = group(syear)
gen wavey=syear

gen country=6

sort pid wave


*  erstbefr hid netto nett1 todjahr phrf parid partner piyear hnetto hpop hbleib hhrf 

* Responded in the survey
recode x11105 (0=3), gen(respstat)
	lab def respstat 	1 "Interviewed" 					///
						2 "Not interviewed (has values)" 	///
						3 "Not interviewed (no values)"
	lab val respstat respstat

*
	bysort pid: egen wave1st = min(cond(respstat == 1, wave, .))
	
	
*################################
*#								#
*#	Socio-demographic basic 	#
*#								#
*################################
**--------------------------------------
** Demographic
**--------------------------------------
* age
gen age=piyear - gebjahr if gebjahr>100 & piyear>100
recode age (.=-1)
/* Compare with pequiv var
sum age d11101 if d11101>=0 & age >=0
bro pid syear piyear gebjahr d11101 age 
*/

* Birth year
clonevar yborn=gebjahr
	lab var yborn "Birth year" 

* Gender
recode sex (1=0) (2=1) (else=.), gen(female)
	lab def female 0 "Male" 1 "Female" 
	lab val female female 
	lab var female "Gender" 
	

// **--------------------------------------
// ** Place of living (e.g. size/rural) NA
// **--------------------------------------
// * place
//
//  	lab var place "Place of living"
// 	lab def place 1 "city" 2 "rural area"
// 	lab val place place 

*################################
*#								#
*#	Education					#
*#								#
*################################
**--------------------------------------
** Years 
**--------------------------------------
* d11109 - years ok 
gen eduy=d11109		

recode eduy (.=-1) (-2=-1)
lab var eduy "Education: years"


 *** edu3
 
/*Note:
- differences in coding between isced97 11 and casmin
- d11109 also gives different results 
*/


recode pgisced11 (0/2=1) (3 4=2) (5/8=3) , gen(edu3a)
recode pgisced97 (0/2=1) (3 4=2) (5/6=3) , gen(edu3b)
replace edu3b = 2 if intyear <2010 & pgisced97>=5 & pgcasmin==3 & d11109<12 & d11109>0
gen edu3=edu3a
replace edu3=edu3b if intyear <2010
replace edu3=edu3b if intyear >=2010 & (edu3<0|edu3==.)

	drop edu3a edu3b
	
	lab def edu3  1 "[0-2] Low" 2 "[3-4] Medium" 3 "[5-8] High" // 2 incl Vocational
	lab val edu3 edu3
	lab var edu3 "Education: 3 levels"

	
*** edu4
recode pgisced11 (0 1=1) (2=2) (3 4=3) (5/8=4) , gen(edu4a)
recode pgisced97 (0 1=1) (2=2) (3 4=3) (5 6=4) , gen(edu4b)
replace edu4b = 3 if intyear <2010 & pgisced97>=5 & pgcasmin==3 & d11109<12 & d11109>0
gen edu4=edu4a
replace edu4=edu4b if intyear <2010
replace edu4=edu4b if intyear >=2010 & (edu4<0|edu4==.)

	drop edu4a edu4b
		
	lab def edu4  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" 4 "[5-8] Tertiary" 
	lab val edu4 edu4
	lab var edu4 "Education: 4 levels"
	
*** edu5
recode pgisced11 (0 1=1) (2=2) (3 4=3) (5 6=4) (7 8=5) , gen(edu5a)
recode pgisced97 (0 1=1) (2=2) (3 4=3) (5=4) (6=5) , gen(edu5b)
replace edu5b = 3 if intyear <2010 & pgisced97>=5 & pgcasmin==3 & d11109<12 & d11109>0
replace edu5b = 4  if intyear <2010 & pgisced97==6 & pgcasmin==8   
replace edu5b = 5  if intyear <2010 & pgisced97==6 & pgcasmin==9   
gen edu5=edu5a
replace edu5=edu5b if intyear <2010
replace edu5=edu5b if intyear >=2010 & (edu5<0|edu5==.)

	drop edu5a edu5b
		
	lab def edu5  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" ///
				  4 "[5-6] Tertiary lower(bachelore)"  ///
				  5 "[7-8] Tertiary upper (master/doctoral)"
				  
	lab val edu5 edu5
	lab var edu5 "Education: 5 levels"

* Alternative version:
/*NOTE:
- only for 2010+ 
*/	
recode pgisced11 (0 1=1) (2=2) (3 4=3) (5 6 7=4) (8=5) if intyear >=2010, gen(edu5v2)

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
** Primary partnership status  (from CNEF) 	 
**--------------------------------------
* Approach based on CNEF 
* Equal to CNEF's d11104  
* NOTE: 
* - categories of 'single' and 'living with partner' not fully precise and can be contradictory to other variables 
* - country differences in inclusion of having/living with partner
* - country differences in definition of ‘single’ 


recode pgfamstd (1 7=1)(2 6 8=5)(3=2)(4=4)(5=3)	///
				(-1=-2) (-3=-1) (-5 -8=-8), gen(marstat5)

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

recode pgfamstd (1 7=1)(2 6 8=5)(3=2)(4=4)(5=3)	///
				(-1=-2) (-3=-1) (-5 -8=-8), gen(mlstat5)

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
** Partnership living-status 	 
**--------------------------------------
* Includes inforamtion on marital status and whether living with partner in HH 

				
gen parstat6=-3 if partner<.				
replace parstat6=6 if (pgfamstd==2|pgfamstd==6|pgfamstd==8) & partner==0 
replace parstat6=5 if pgfamstd==4 & partner==0 
replace parstat6=4 if pgfamstd==5 & partner==0 
replace parstat6=3 if pgfamstd==3 & partner==0
replace parstat6=2 if (pgfamstd!=1 & pgfamstd!=7) & (partner>=1 & partner<=4) 
replace parstat6=1 if (pgfamstd==1|pgfamstd==7)	// pgfamstd is cleaned, so it has a priority over partner info 

		recode  pgfamstd (1 7=1)(2 6 8=6)(3=3)(4=5)(5=4)	///
						 (-1=-2) (-3=-1) (-5 -8=-8), gen(temp_parstat6)
		replace parstat6=temp_parstat6 if parstat6==-3 & temp_parstat6>0 & temp_parstat6<.


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
** Children , people in HH
**--------------------------------------
*  
clonevar kidsn_all= sumkids
clonevar kidsn_hh17= d11107

recode kidsn_all (1/50=1) (0=0), gen(kids_any)
 	
	lab var kids_any  "Has any children"
	lab val kids_any   yesno
	lab var kidsn_all  "Number Of Children Ever Had" 
//  	lab var kidsn_18   "Number Of Children <18 y.o." 
// 	lab var kidsn_15   "Number Of Children <15 y.o." 
 	lab var kidsn_hh17   "Number of Children in HH aged 0-17"
	
**--------------------------------------
** People in HH F14
**--------------------------------------
clonevar nphh= d11106
	
	lab var nphh   "Number of People in HH" 
	
**--------------------------------------
** Binary specific current partnership status (yes/no)
**--------------------------------------
*** Specific current marital statuses (probably the same as Formal marital status)
* No mater if currently living with a partner
*  Probably overlap with marstat5. If strong overlap in all countries, we can delete them. 

// 		lab var cmarr   "Currently: married"
// 		lab var cwidow 	"Currently: widowed (no mater partner)"
// 		lab var cdivor  "Currently: divorced (no mater partner)"
// 		lab var csepar  "Currently: separated (no mater partner)"
// 		lab val cmarr cwidow cdivor csepar yesno
		
*** Partner
	// pld0133 - filtered

	recode partner (0 5=0) (1/4=1), gen(livpart)
// 		lab var haspart "Has a partner"
		lab var livpart "Living together with partner"
		lab val   livpart  yesno


*** Single
// 		lab var csing "Single: not married and no partner"
// 		lab val csing yesno
								
*** Never married 
recode pgfamstd (3=1)(1 2 4/8=0)	///
				(-1=-2) (-3=-1) (-5 -8=-8), gen(nvmarr)

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

								
*################################
*#								#
*#	Labour market situation		#
*#								#
*################################
 
**--------------------------------------
** Currently working 
**--------------------------------------
/*Notes: 
- e11104 - currently
- e11102 - last year 
*/
	
clonevar work_py=e11102
recode e11104 (-2=-3) (2=0), gen(work_d)
	
	lab var work_py "Working: last year (based on hours)"	
	lab var work_d 	"Working: currently (based on selfrep)"
	lab val work_py work_d yesno
	
**--------------------------------------
** Employment Status  
**--------------------------------------	
*--> moved after 'Retirement' section -->


**--------------------------------------
** Occupation ISCO  
**--------------------------------------
*  e11105
/*Notes: 
- e11105 - isco 88 (based on pgisco88) 
- pgisco08 & pgisco88 sometimes differ in coding - reasons unknown 
*/

// ssc install iscogen

*** isco88_4
clonevar isco88_4 = e11105_v1 // if wavey<=2017
clonevar isco08_4 = e11105_v2 // if wavey>=2018
recode isco88_4 (-2 -8=-3) (0=-1) 
recode isco08_4 (-2 -8=-3) (0=-1) 

capture lab copy e11105_v1 isco88_4
capture lab def isco88_4 -1 "[-1] MV general"					///
				-3 "[-3] Does not apply"	 , modify
capture lab val isco88_4 isco88_4

capture lab copy e11105_v2 isco08_4
capture lab def isco08_4 -1 "[-1] MV general"					///
				-3 "[-3] Does not apply"	 , modify
capture lab val isco08_4 isco08_4

*** Recode isco88 into 08 (4 digits) 
iscogen isco08_4a= isco08(isco88_4) ,  from(isco88)
iscogen isco88_4a= isco88(isco08_4) ,  from(isco08)
replace isco08_4=isco08_4a if wavey<=2017
replace isco88_4=isco88_4a if wavey>=2018
drop isco08_4a isco88_4a

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
*  p_nace p_nace2 e11106 e11107

/*Notes: 
- use e11106 (maybe e11107) as base
- e11106 is based on p_nace
- some small inconsisitencies between e11106 and e11107
*/


* Major groups 
recode e11107 (0 -2=-3)(1/15=1)(16/26 32=2)(27/31 33=3) (99=-1), gen(indust1)
replace indust1=1 if e11107==26 & e11106==4
*TEMPIV: 99=not attributable to -1
 		
lab def indust1											///
           1 "[1] Production, Construction, Heavy Ind"	///
           2 "[2] Trade and Services"					///
		   3 "[3] Public services"						///
		  -1 "[-1] MV general"							///
		  -3 "[-3] Does not apply"	  

		  
	lab val indust1 indust1		  
	lab var indust1 "Industry (major groups)" 
	
* Submajor groups 
recode e11106 (0 -2=-3), gen(indust2)

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
recode e11107 (0 -2 99=-3)(3=5)(4 =3)(5 6 7 8 11 12 13=4)(9 10 14 15=6) ///
			  (16/18=7)(20 21=9)(22 23=10)(24=8)(25 26=7)	///
			  (27=13)(28=14)(29 30 31=15)(32=16)(33=12), gen(indust3)
			  

replace indust3=4 if (e11107==9 | e11107==10) & e11106==4
replace indust3=4 if e11107==26 & e11106==4
 		
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
*pgoeffd plb0040
/*Notes: 
- pgoeffd has better coverage 
*/
recode pgoeffd (1=1) (2=0) (-1=-1) (-2=-1), gen(public)
replace public=0 if plb0040==2 & public==-1
replace public=1 if plb0040==1 & public==-1
	lab val public yesno

	lab var public "Public sector"

**--------------------------------------
** Size of organization	 
**--------------------------------------
*  pgallbet (also pgbetr)
/*Notes: 
- pgbetr is more detailed, but not much flexibility in recoding
- recoding of pgallbet is the only possible
- can't get thesholds of 10 and 50 (only 20 and 200)
*/  
*


recode pgallbet (5=0) (-2=-3) (-1=-2), gen(size4)

	lab var size4 "Size of organization [4]"
	lab def size4 1 "<20" 2 "20-199" 3 "200-1999" 4 "2000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size4 size4
 
 
//  	lab var size5 "Size of organization [5]"
// 	lab def size5 1 "<10" 2 "10-49" 3 "50-99" 4 "100-999" 5 "1000+"  	///
// 				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
// 				-1 "-1 MV general" -2 "-2 Item non-response" 	///
// 				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val size5 size5

//  	lab var size5b "Size of organization [5b]"
// 	lab def size5b 1 "<10" 2 "10-49" 3 "50-99" 4 "100-499" 5 "500+"  	///
// 				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
// 				-1 "-1 MV general" -2 "-2 Item non-response" 	///
// 				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val size5b size5b	

**--------------------------------------
** hours conracted
**--------------------------------------
*pgvebzeit
clonevar whweek_ctr=pgvebzeit
	lab var whweek_ctr "Work hours per week: conracted"

**--------------------------------------
** hours worked 
**--------------------------------------
*pgtatzeit	 plb0186_v1 plb0186_v2 e11101
/*Notes: 
- pgtatzeit is harmonized and corrected 
- e11101 is imputed (pequiv)
*/

clonevar whweek=pgtatzeit 
clonevar whyear=e11101  

gen whmonth=whweek*4.3
replace whmonth=whweek if whweek <0
 
//  lab var whday "Work hours per day: worked"
	lab var whweek "Work hours per week: worked"
	lab var whmonth "Work hours per month: worked"
	lab var whyear "Work hours per year: worked"
 
* Fill MV based on whyear (imputed by CNEF)

replace whmonth=whyear/12 if (whmonth==.|whmonth<0) & whyear>0 & whyear<.
replace whweek=whyear/(12*4.3) if (whweek==.|whweek<0) & whyear>0 & whyear<. 
 
 
**--------------------------------------
** full/part time
**--------------------------------------
*  --> moved after emplst5


**--------------------------------------
** overtime working  
**--------------------------------------
* pguebstd plb0193 plb0196_h plb0197

 
**--------------------------------------
** Supervisor 	NA
**--------------------------------------
* supervis
	
**--------------------------------------
** maternity leave   
**--------------------------------------
recode  pglfs (4=1)(1/3 5/13=0) (-2=-3) , gen(mater)
 
// 	lab val mater yesno
// 	lab var mater "maternity leave "	
	
*################################
*#								#
*#	Currently unemployed 		#
*#								#
*################################


**--------------------------------------
** Unempl: registered  
**--------------------------------------
* plb0021
recode plb0021 (1=1) (2=0)	///
		(-1 -3=-2) (-8 -5=-1), gen(un_reg)
lab val un_reg yesno
lab var un_reg "Unemployed: registered"
 
**--------------------------------------
** Unempl: reason   
**--------------------------------------
* plb0304_h
/*Notes: 
- create set of categories if harmon possible
*/
 

**--------------------------------------
** Unempl: actively looking for work 
**--------------------------------------
* plb0424_v1 plb0424_v2
/*Notes: 
- 3 months (1994-1998); 4 weeks(1999+)
- before 1994 unemployed in general (not necessarily active - no info)
*/
gen un_act=plb0424_v1
replace un_act=plb0424_v2 if syear>=1999

recode un_act (1=1) (2=0)	///
		(-1 -3=-2) (-8 -5 -2=-3)

replace un_act=1 if (pgstib==12 | pglfs==6) & syear<1994 // before 1994 unemployed in general 

lab val un_act yesno
lab var un_act "Unemployed: actively looking for work "

*################################
*#								#
*#	Self-empl / Entrepreneur	#
*#								#
*################################
**--------------------------------------
** Self-employed	!! Harmon
**--------------------------------------
* plb0057_h plb0057_v9
/*Notes: 
- decide about Help in Family Business
- could include info about income 
- decide on def for harmonization 
*/

*** v1 - all without Family Business
*@change to h1
gen 	selfemp_v1=1 	if plb0057_h1>0 	 & plb0057_h1<6 		& syear< 2014
replace selfemp_v1=0 	if plb0057_h1==-2 | plb0057_h1==6 	& syear< 2014
replace selfemp_v1=-2 	if plb0057_h1==-1 | plb0057_h1==-3 	& syear< 2014
replace selfemp_v1=-8 	if plb0057_h1==-8 | plb0057_h1==-5 	& syear< 2014
replace selfemp_v1=1 	if plb0057_v9>0 	 & plb0057_v9<=3 		& syear>=2014
replace selfemp_v1=0 	if plb0057_v9==-2 	 | plb0057_v9==4 		& syear>=2014
replace selfemp_v1=-2 	if plb0057_v9==-1 	 			 		& syear>=2014
replace selfemp_v1=-8 	if plb0057_v9==-8 	 			 		& syear>=2014

*** v2 - with Family Business
gen 	selfemp=1 	if plb0057_h1>0 	 & plb0057_h1<=6		& syear< 2014
replace selfemp=0 	if plb0057_h1==-2 				 	& syear< 2014
replace selfemp=-2 	if plb0057_h1==-1 | plb0057_h1==-3 	& syear< 2014
replace selfemp=-8 	if plb0057_h1==-8 | plb0057_h1==-5 	& syear< 2014
replace selfemp=1 	if plb0057_v9>0 	 & plb0057_v9<=4 		& syear>=2014
replace selfemp=0 	if plb0057_v9==-2 	  			 		& syear>=2014
replace selfemp=-2 	if plb0057_v9==-1 	 			 		& syear>=2014
replace selfemp=-8 	if plb0057_v9==-8 	 			 		& syear>=2014

*** v3 - based on income from self-empl
gen 	selfemp_v3=1 if iself>100
replace selfemp_v3=0 if iself==0

***
	lab val selfemp_v1 selfemp selfemp_v3 yesno
	lab var selfemp_v1 "Self-employed 1: all without Family Business"
	lab var selfemp "Self-employed 2: all with Family Business"
	lab var selfemp_v3 "Self-employed 3: based on income from self-empl"

**--------------------------------------
** Entrepreneur 
**--------------------------------------
*** v1 - Not farmer; including info about employees 
/*Note: 
to harmonize across waves, we ignored Freie Berufe & Selbst. Landwirte
which have employees (recognized for w>=2014)
*/

clonevar entrep=selfemp_v1
replace  entrep=0 	if plb0057_h1>=1	& plb0057_h1<4		& syear< 2014
replace  entrep=0	if plb0057_v9<3						& syear>=2014
replace  entrep=0	if plb0057_v9==3 	& plb0057_v9<2 		& syear>=2014
	
	lab val entrep yesno
	lab var entrep "Entrepreneur (not farmer; has employees)"

clonevar entrep2=selfemp_v1
replace  entrep2=0 	if plb0057_h1>=2	& plb0057_h1<4		& syear< 2014
replace  entrep2=0	if plb0057_v9>=2 	& plb0057_v9<3			& syear>=2014
replace  entrep2=0	if plb0057_v9==3 	& plb0057_v9<2 		& syear>=2014

	lab val entrep2 yesno
	lab var entrep2 "Entrepreneur (incl. farmers; has employees)"
	
**--------------------------------------
** Number of employees 
**--------------------------------------
recode entrep2 (0 1=-1), gen(nempl)
replace nempl=1 if entrep2==1 & plb0057_v9==2
replace nempl=2 if entrep2==1 & plb0057_v9==3


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
*   

* create zeros (obs with any type of information)
recode  plb0022_h (1/11=0) (-5/-1=-1), gen (retf)
replace retf=0 if pgstib>=10 & pgstib<.
replace retf=0 if pglfs>=1 & pglfs<.
* create MV(-1) with no information 
replace retf=-1 if   (plb0022_h<0 | plb0022_h==.) & (pgstib<=0 | pgstib==.) & (pglfs<0 | pglfs==.)

* Fill MV
		* Code below fills information for individuals who left due to retirement
		* for years after the event
		sort pid syear
		bysort pid: gen  temp_order= _n
		bysort pid: gen  temp_yret=syear if plb0304_h==6
		bysort pid: egen temp_yret2=max(temp_yret)
		bysort pid: gen  temp_ret=1 if syear>=temp_yret2
		
* Criteria for 1
replace retf=1  if (plb0022_h==9 | plb0022_h==7 | plb0022_h==5) &		/// NW or Voluntary Services (FSJ / FOEJ / BFD) or Near Retirement, Zero Working Hours
					 pglfs!=11 &								/// NW
					 temp_ret==1 & age>=50						// left job becouse of retirement (plb0304_h)
		* Can drop the temporary files 	
		drop temp_*
	
replace retf=1  if (plb0022_h==9 | plb0022_h==7 | plb0022_h==5) & pglfs!=11 & age>=65	// age>65

replace retf=1  if (plb0022_h==9 | plb0022_h==7 | plb0022_h==5) &	 pglfs!=11 &	/// 
					  (kal1e01==1 | kal2d01==1)  &		/// received pension (maybe early)
					  age>=50						//  age 
	
	lab var retf "Retired fully (NW, old-age pens, 45+)"
	lab val retf yesno 	
	
	
	
**--------------------------------------
** Employment Status moved here to use retf and un_act 
**--------------------------------------
/*Notes: 
- to do based on Retirement and Unemployed
- pglfs - not sure how created 
- pglfs pgstib
- plb0022_h	 pgemplst - more less the same (pgemplst  simplified)
*/

* emplst5
* create zeros (obs with any type of information)
recode  plb0022_h (1/11=0) (-5/-1=-1), gen (emplst5)
replace emplst5=0 if pgstib>=10 & pgstib<.
replace emplst5=0 if pglfs>=1 & pglfs<.
* create MV(-1) with no information 
replace emplst5=-1 if   (plb0022_h<0 | plb0022_h==.) & (pgstib<=0 | pgstib==.) & (pglfs<0 | pglfs==.)

* Categories 
replace emplst5=4 if  plb0022_h==5 | plb0022_h==6| plb0022_h==7 | plb0022_h==9 | plb0022_h==11 
replace emplst5=4 if  (pglfs>=1 & pglfs<=10)
replace emplst5=4 if pgstib>=10 & pgstib<=13

replace emplst5=3 if retf==1
replace emplst5=3 if pgstib==13 | pglfs ==2 // Pensioner or NW-age 65 and older

replace emplst5=5 if pgstib==11 | pglfs==3

replace emplst5=2 if pgstib==12 | pglfs==6 
replace emplst5=2 if un_act==1 // only from 1994+ 

replace emplst5=1 if (plb0022_h>=1 & plb0022_h<=4) | plb0022_h==8 | plb0022_h==10
replace emplst5=1 if pglfs==11 | (pglfs==12 & pgstib!=13)
// replace emplst5=1 if pgstib>100 & pgstib<. // less reliable (more contradictory results)


	lab def emplst5	///
			1 "Employed" 			/// including leaves
			2 "Unemployed (active)"	///
			3 "Retired, disabled"	///
			4 "Not active/home"		///   
			5 "In education"		///
			-1 "MV"
	lab val emplst5 emplst5
	lab var emplst5 "Employment status [5]"
	
* emplst6
gen emplst6=emplst5
replace emplst6=6 if (pglfs==4 | pglfs==12) & /// NW-maternity leave or NW-work but past 7 days
			pgstib>13 & pgstib<.	//

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


**--------------------------------------
** full/part time
**--------------------------------------
*  plb0022_h e11103
/*Notes: 
*/
recode plb0022_h (1=1) (2 4=2) (3 5/12=3) (-5 .=-1), gen(fptime_r)

*
gen fptime_h=.
replace fptime_h=1 if whweek>=35 & whweek<.
replace fptime_h=2 if whweek<35 & whweek>0
replace fptime_h=3 if whweek==0
replace fptime_h=3 if emplst5>1 & emplst5<.
replace fptime_h=whweek if whweek<0 & fptime_h==.


lab def fptime_r 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other"
lab val fptime_r fptime_h fptime

lab var fptime_r "Employment Level (self-report)"
lab var fptime_h "Employment Level (based on hours)"
	
		  

**--------------------------------------
** Receiving old-age pension  
**--------------------------------------					  
*   
/*Note: 
- if kal1e01==1 | kal2d01==1
- do it only if possible to harmonize 
*/								  
recode kal1e01 (1=1) (2=0) (-5 -1=-1), gen (oldpens)
replace oldpens=1 if kal2d01==1
replace oldpens=0 if kal2d01==2 & oldpens!=1
replace oldpens=-1 if kal2d01<0 & oldpens!=1 & oldpens!=2

					  
	lab var oldpens "Receiving old-age pension"
	lab val oldpens yesno 
	

**--------------------------------------
** Receiving disability pension   
**--------------------------------------		
* disabpens

// 	lab var disabpens "Receiving disability pension"
// 	lab val disabpens yesno 

*################################
*#								#
*#	Work history 				#
*#								#
*################################

**--------------------------------------
**   Labor market experience full time
**--------------------------------------
*   
/*Note: 
- Can clean: if started work<14
*/
clonevar expft=pgexpft
	/* Cleaning
	gen temp_agestart=age-pgexpft
	  bro age expft temp_exp d11109 d11108 if temp_agestart<14 & temp_agestart>0
	replace expft=-1 if temp_exp<14 //8 cases
	drop temp_agestart 
	*/ 
	lab var expft "Labor market experience: full time"
**--------------------------------------
**   Labor market experience part time 
**--------------------------------------
*   
/*Note: 
- Can clean: if started work<14
*/
clonevar  exppt=pgexppt
	/* Cleaning
	gen temp_agestart=age-pgexppt
	  bro age temp_exp expft exppt if temp_agestart<14  & temp_agestart>0
	replace exppt=-1 if temp_exp<14 & temp_exp>0 //3 cases
	drop temp_agestart 
	*/ 
	lab var exppt "Labor market experience: part time"
	
**--------------------------------------
**   Total Labor market experience (full+part time)  
**--------------------------------------
*   
/*Note: 
- Must clean, e.g if started work<14
- We can expect some inproper values (ft and pt overlap possible) - 
  but there is no information in SOEP documentation. 
*/

gen exp=expft
replace exp=exp + exppt if exppt>0 & exppt<.

	*Cleaning 
	gen temp_agestart=age-exp
// 	bro age expft exppt exp temp_agestart if temp_agestart<14
	replace exp=expft if temp_agestart<14 & expft>0
	drop temp_agestart
// 	gen temp_agestart2=age-exp
	* Further cleaning adviced 	

	lab var exp "Labor market experience"	

**--------------------------------------
**   Experience in org
**--------------------------------------
*   
/*Note: 
- pgerwzeit is already cleaned, based on plb0036_h
*/
clonevar exporg= pgerwzeit
	
	* Cleaning
		sort pid syear
		by pid: replace exporg= pgerwzeit[_n-1] + 1 if pgerwzeit>1000 & pgerwzeit<. ///	
										& pgerwzeit[_n-1]>0 & pgerwzeit[_n-1]<1000
		replace exporg=syear-plb0036_h if exporg>100 & exporg<.
 	
	lab var exporg "Experience in organisation"

**--------------------------------------
**   Never worked   
**--------------------------------------	
*neverw

// 	lab var neverw "Never worked"
// 	lab val neverw yesno
	
*################################
*#								#
*#	Income and wealth			#  
*#								#
*################################

**--------------------------------------
**   Work Income - detailed
**--------------------------------------
* CNEF: i11110  ijob1 ijob2
/*Note: 
- more variables in Pequiv file
*/


* whole income (jobs, benefits)

	
	*lab var inctot_yn "Individual Income (All types, year, net)"
	*lab var inctot_mn "Individual Income (All types, month, net)"

	
* all jobs 
clonevar incjobs_yg=i11110

	*lab var incjobs_yn "Individual Labor Earnings (All jobs, year, net)"
	lab var incjobs_yg "Individual Labor Earnings (All jobs, year, gross)"
	*lab var incjobs_mn "Individual Labor Earnings (All jobs, month, net)"

* main job
clonevar incjob1_yg=ijob1
clonevar incjob1_mg=pglabgro 
clonevar incjob1_mn=pglabnet

	lab var incjob1_yg  "Salary from main job (year, gross)"
	*lab var incjob1_yn  "Salary from main job (year, net)"
	lab var incjob1_mg "Salary from main job (month, gross)"
	lab var incjob1_mn "Salary from main job (month, net)"	
	
	
	
**--------------------------------------
*   HH wealth
**--------------------------------------
/*Note: 
 
*/
clonevar hhinc_pre=i11101 
clonevar hhinc_post=i11102 //better indicator

 	lab var hhinc_pre 	 "HH income(month, pre)"	
	lab var hhinc_post 	 "HH income(month, post)"	


*################################
*#								#
*#	Health status				#
*#								#
*################################
**--------------------------------------
**  Self-rated health 
**--------------------------------------
*      m11126    
 /*Note: 
- ple0008 has more data but better to use m11126 which was cleaned 
- m11126 - see Pequiv manual
- 1984-1991, 1993: Data not available in SOEP
- data for 1992 and since 1994
*/

recode m11126  (-2=-3) (-1=-2) , gen(srh5)

	lab var srh5 "Self-rated health"
	lab def srh5 5 "Very bad" 4 "Bad" 3 "Satisfactory" 2 "Good" 1 "Very good"
	lab val srh5 srh5

**--------------------------------------
**  Disability 
**--------------------------------------
*   ple0040 ple0041 m11124
/*Note: 
- m11124=1 if >30% disability 
- check if ple0041 possible to harmonize
*/
recode ple0040 (1=1) (2=0) (-5 -8=-8) (-2=-3) (-1=-2), gen(disab)
recode m11124 (1=1) (-5=-8) (-2=-3) (-1=-2), gen(disab2c)

	lab var disab	"Disability (any)"
	lab var disab2c "Disability (min. category 2 or >30%)"
	lab val disab disab2c yesno

**--------------------------------------
**  Chronic diseases
**--------------------------------------
* chron
* NOTE: only selected years 
recode ple0036 (1=1)(2=0) (-1=-2)(-2=-3)(-8 -5=-8), gen(chron)

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
/*Note: 
- 1-10 all
- use lab from m11125
*/
*** Life
*** Work 
*** Family relationships
*** Financial sit
*** Health
	lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" 	///
				 4  "4 Mostly sat" 5 "5 Completely sat"						///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 		///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	 

	lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
 

 * Recode   10-point into 5-point versions 
 tokenize "plh0182 plh0173 plh0180 plh0175 plh0176 m11125 "
	 foreach var in satlife satwork satfam satfinhh satinc sathlth {
		 recode  `1' (0 1=1)(2 3 4=2)(5=3)(6 7 8=4)(9 10=5)(-5=-8)(-2=-3)(-1=-2), gen(`var'5)
		 recode  `1' (-5=-8)(-2=-3)(-1=-2), 	 gen(`var'10)
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
* plg0269
*Note: 
*- only from 2014
*@temp removed

recode plg0269_v1 plg0269_v2 (1=1) (2 3=0) 			///
		(-1 -3 -4=-2) (-8 -5=-8), gen(temp_train1 temp_train2)
gen train=temp_train1
replace train=temp_train2 if wavey>=2016		
		
lab val train yesno

	lab var train "Training (previous year)"
*/
**--------------------------------------
**   work-edu link
**--------------------------------------
*   plb0072 pgerljob 
/*Note: 
- Does this job correspond to the occupation for which you were trained?
- pgerljob - seems cleared and extended 
*/
recode pgerljob (1=1) (2 4=0) ///
		(-1  =-2) (-2 3 =-3), gen(eduwork)

	lab var eduwork "Work-education skill fit"
	lab def eduwork 0 "0 Poor" 1 "1 Good" ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val eduwork eduwork	

**--------------------------------------
**   Volunteering NA
**--------------------------------------

// 	lab val volunt yesno
// 	lab var volunt "Volunteering"
	
	
**--------------------------------------
**   Job security
**--------------------------------------
*  

recode plh0042 (1=1)(2 3=0)(-1=-2)(-2=-3)(-6 -5=-8), gen(jsecu)

	lab def jsecu 	 1 "Insecure" 0 "Secure"  ///
					-1 "-1 MV general" -2 "-2 Item non-response" ///
					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab def jsecu2 	 1 "Insecure" 0 "Secure" 2 "Hard to say" ///
// 					-1 "-1 MV general" -2 "-2 Item non-response" ///
// 					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab var jsecu "Job insecurity [2]"
// 	lab var jsecu2  "Job insecurity [3]"

	lab val jsecu jsecu

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
	lab var siops08 "SIOPS: Treiman's international prestige scale" 
	
iscogen siops88 = siops(isco88_4) , from(isco88)
	lab var siops88 "SIOPS-88: Treiman's international prestige scale" 
	
**--------------------------------------
*** MPS (German Magnitude Prestige Scale)
**--------------------------------------	
iscogen mps88 = mps(isco88_4), from(isco88)



	
**--------------------------------------
**   EGP / ESEC
**--------------------------------------	
// 	iscogen egp = egp11(isco88_4 selfemp  ), from(isco88)

	 
	 
**--------------------------------------
**  Indexes already availible in SOEP 
**--------------------------------------	

* isei88
clonevar isei88soep=pgisei88 
/*
Original from SOEP: 
- contains more information 
- in general, for MV in isco, it forward-leads the information from previous known isco status 
- however, there are unexplaied rules:
	- sometimes it copies info from an older-wave isco 
	- sometimes copies MV 
*/

* siops88
clonevar siops88soep=pgsiops88
/*
Original from SOEP: 
- equals: iscogen siops2 = siops(isco88_4) , from(isco88)
- contains more information 
- in general, for MV in isco, it forward-leads the information from previous known isco status 
- however, there are unexplaied rules:
	- sometimes it copies info from an older-wave isco 
	- sometimes copies MV 
*/	 
	 
* mps
clonevar mps92soep=pgmps92
/*
This variable gives the occupational prestige score developed by Wegener (1988) for all employed
persons. Like the SIOPS prestige sore, Wegener’s prestige scala measures a person’s
occupational prestige and was developed especially for use in the Federal Republic of Germany.
MPS is assigned based on the German Federal Statistical Office’s occupational classification
of 1992 (PGKLDB92). The procedure has been documented in Frietsch and Wirth
(2001).
*/


* EGP
// clonevar egp88soep=pgegp88 
/*
Last Reached Egp Value (Erikson, Goldthorpe, Portocarero)
This variable gives the occupational class for all employed persons. PGEGP88 is derived
from the ISCO-88 classification using Hendrickx‘s (2002) Stata ado. In addition, it is based
on information on self-emlpoyment and number of employees (supervisory status). The EGP
Index was documented by Ganzeboom/Treiman in 1996 and revised in 2003.
Information about supervisory status (number of employees of self-employed persons) is
available from wave Q (2000) on. (This could lead to some minor longitudinal inconsistencies.)
Based on the new classification developed by Ganzeboom/Treiman (2003), several ISCO
values were recoded in PGEGP88 as follows:
• ISCO 2470 becomes EGP=1.
• ISCO 2500 becomes EGP=2.
• ISCO 4300, 4400, 4500 become EGP=4.
• ISCO 7900 becomes EGP=7.
• ISCO 9910-9990 become EGP=9.
Please also see occupational status (PGISEI88) and occupational prestige scores (PGSIOPS88,
PGMPS92).
John Hendrickx, 2002. “ISKO: Stata module to recode 4 digit ISCO-88 occupational codes,” Statistical
Software Components S425802, Boston College Department of Economics, revised 20 Oct
2004. https://ideas.repec.org/c/boc/bocode/s425802.html
Ganzeboom, Harry B.G.; Treiman, Donald J., “International Stratification and Mobility File:
Conversion Tools.” Amsterdam: Department of Social Research Methodology, http://www.harryganzeboom.
nl/isco88/.
*/

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
recode fsedu (1/2 6/8=1)(3 9=2)(4 5=2) (-5=-8)(-2=-3) (0=-1), gen(fedu3)
recode fprofedu (26/27 30/32=3) (20 28=2) (20 23 50 51=1)	///
				(-5/0=-10) (else=-9),  gen(temp_fedu3)

replace fedu3=temp_fedu3 if (fedu3==. | fedu3<0) & (temp_fedu3>0 & temp_fedu3<.) 
replace fedu3=temp_fedu3 if temp_fedu3>fedu3 & (temp_fedu3>0 & temp_fedu3<.) 


	lab val fedu3 edu3
	lab var fedu3 "Father's education: 3 levels"

	
* edu4
recode fsedu (6/8=1)(1/2=2) (3 9=3)(4 5=3) (-5=-8)(-2=-3) (0=-1), gen(fedu4)
recode fprofedu (26/27 30/32=4) (20 28=3) (50 51=1) (20 23=2)	///
				(-5/0=-10) (else=-9),  gen(temp_fedu4)

replace fedu4=temp_fedu4 if (fedu4==. | fedu4<0) & (temp_fedu4>0 & temp_fedu4<.) 
replace fedu4=temp_fedu4 if temp_fedu4>fedu4 & (temp_fedu4>0 & temp_fedu4<.) 

	lab val fedu4 edu4
	lab var fedu4 "Father's education: 4 levels"
	
drop temp_fedu*

*** Mother 
*edu3
recode msedu (1/2 6/8=1)(3 9=2)(4 5=2) (-5=-8)(-2=-3) (0=-1), gen(medu3)
recode mprofedu (26/27 30/32=3) (20 28=2) (20 23 50 51=1)	///
				(-5/0=-10) (else=-9),  gen(temp_medu3)

replace medu3=temp_medu3 if (medu3==. | medu3<0) & (temp_medu3>0 & temp_medu3<.) 
replace medu3=temp_medu3 if temp_medu3>medu3 & (temp_medu3>0 & temp_medu3<.) 

	lab val medu3 edu3
	lab var medu3 "Mother's education: 3 levels"

	
* edu4
recode msedu (6/8=1)(1/2=2) (3 9=3)(4 5=3) (-5=-8)(-2=-3) (0=-1), gen(medu4)
recode mprofedu (26/27 30/32=4) (20 28=3) (50 51=1) (20 23=2)	///
				(-5/0=-10) (else=-9),  gen(temp_medu4)

replace medu4=temp_medu4 if (medu4==. | medu4<0) & (temp_medu4>0 & temp_medu4<.) 
replace medu4=temp_medu4 if temp_medu4>medu4 & (temp_medu4>0 & temp_medu4<.) 

	lab val medu4 edu4
	lab var medu4 "Mother's education: 4 levels"
	
drop temp_medu*
	
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
*#	    Ethnicity				#
*#								#
*################################	 
//Not available for SOEP


*################################
*#								#
*#	Migration					#
*#								#
*################################	 

**--------------------------------------
**   COB respondent, father and mother
**--------------------------------------	
// NOTE:because of the extensive list of countries, a separate do-file generates the variables for the country of birth of the respondent and their parents categories by region. (see additional do-file for details)

do "${Grd_syntax}\06_SOEP\ge_02add_labels_COB.do" 

*** Identify valid COB and fill across waves  
sort pid wave 


*** Generate working variables
	gen cob_rt=cob_r
 

*** Generate valid stage 1 - mode across the waves (values 1-10)
	// It takes the value of the most common valid answer between 1 and 10 
	// If there is an equal number of 2 or more answers, it returns "." - filled in next steps
	bysort pid: egen mode_cob_rt=mode(cob_rt)
	
	
*** Generate valid stage 2 - first valid answer provided (values 0-9)
	// It takes the value of the first recorded answer between 0 and 9 (so ignores 10 "other")
	// These are used to fill COB in cases: 
	//	(a) equal number of 2 or more answers (remaining MV)
	//	(b) there is a valid answer other than 10 but the mode (stage 1) returns 10
	
	by pid (wave), sort: gen temp_first_cob_rt=cob_rt if ///
			sum(inrange(cob_rt, 0,9)) == 1 &      ///
			sum(inrange(cob_rt[_n - 1],0,9)) == 0 // identify 1st valid answer in range 1-9
	bysort pid: egen first_cob_rt=max(temp_first_cob_rt) // copy across waves within pid
	drop  temp_first_cob_rt

	
*** Fill the valid COB across waves
 	replace cob_r = mode_cob_rt // stage 1 - based on mode
	replace cob_r = first_cob_rt if cob_r==. & inrange(first_cob_rt, 0,9) // stage 2 - based on the first for MV
	replace cob_r = first_cob_rt if cob_r==10 & inrange(first_cob_rt, 1,9) // stage 2 - based on the first for 10'other'
	drop cob_rt
	 
		
rename cob_r cob
	
*specify some missing
replace cob=-2 if cob==. & corigin==-1 // non response


lab val cob  COB


/* Alternative version of the code that includes cob_m and cob_f. It is not used 
in this version due to many MV. 

*** Generate working variables
	foreach var in cob_r cob_m cob_f {
	gen `var't=`var'
	}

*** Generate valid stage 1 - mode across the waves (values 1-10)
	// It takes the value of the most common valid answer between 1 and 10 
	// If there is an equal number of 2 or more answers, it returns "." - filled in next steps
	
	foreach var in cob_rt cob_mt cob_ft {
	bysort pid: egen mode_`var'=mode(`var')
	}
	
*** Generate valid stage 2 - first valid answer provided (values 0-9)
	// It takes the value of the first recorded answer between 0 and 9 (so ignores 10 "other")
	// These are used to fill COB in cases: 
	//	(a) equal number of 2 or more answers (remaining MV)
	//	(b) there is a valid answer other than 10 but the mode (stage 1) returns 10
	
	foreach var in cob_rt cob_mt cob_ft {
	by pid (wave), sort: gen temp_first_`var'=`var' if ///
			sum(inrange(`var', 0,9)) == 1 &      ///
			sum(inrange(`var'[_n - 1],0,9)) == 0 // identify 1st valid answer in range 1-9
	bysort pid: egen first_`var'=max(temp_first_`var') // copy across waves within pid
	drop  temp_first_`var'
	}
	
*** Fill the valid COB across waves
	foreach var in cob_r cob_m cob_f {
	replace `var' = mode_`var't // stage 1 - based on mode
	replace `var' = first_`var't if `var'==. & inrange(first_`var't, 0,9) // stage 2 - based on the first for MV
	replace `var' = first_`var't if `var'==10 & inrange(first_`var't, 1,9) // stage 2 - based on the first for 10'other'
	drop `var't
		}
		
rename cob_r cob
	
*specify some missing
replace cob=-2 if cob==. & corigin==-1 // non response

	foreach p in f m {
	replace cob_`p'=-2 if cob_`p'==. & germborn_`p'==-1
	replace cob_`p'=-3 if cob_`p'==. & germborn_`p'==-2 //not apply
	replace cob_`p'=-8 if cob_`p'==. & germborn_`p'==-5 //not asked
	replace cob_`p'=-1 if cob_`p'==. & germborn_`p'==-8 //MV not specified
	}

	foreach p in f m  			{    
	replace cob_`p'=-2 if cob_`p'==. & `p'origin==-1 //nonresponse
	replace cob_`p'=-3 if cob_`p'==. & `p'origin==-2 //not apply
	replace cob_`p'=-8 if cob_`p'==. & `p'origin==-5 //not asked
	replace cob_`p'=-1 if cob_`p'==. & `p'origin==-8 //MV not specified
	}
	
	foreach p in f m {
		replace cob_`p'=-8 if (cob_`p'==. | cob_`p'<0) & (`p'origin==. | `p'origin==-2) & wavey<2006
	} // before 2006 germborn not asked in main survey

	
lab val cob cob_f cob_m COB
*/

**-------------------------------------------------
**   Migration Background (respondent)
**-------------------------------------------------

*migr - specifies if respondent foreign-born or not.
lab def migr ///
0 "Native-born" ///
1 "Foreign-born" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

recode cob (0=0) (1/10=1) (-1=-1) (-2=-2) (-3=-3) (-8=-8), gen(migr)

/**--------------------------------------
**   Migration Background (parents)
**--------------------------------------	

foreach p in f m {
	recode cob_`p' (0=0) (1/10=1) (-1=-1) (-2=-2) (-3=-3) (-8=-8), gen(migr_`p')
}	

lab val migr_f migr_m migr
*/

**--------------------------------------
**   Migrant Generation
**--------------------------------------	
/* Due to many MV on parents' migration background (cob_m & cob_f) in GER, migr_gen is 
not included in this version of the code. However, the appropriate code is provided below. 
*/

//NOTE: migr_gen - migrant generation of the respondent - is a derived variable (from migr, migr_f and migr_m)

/*
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
	 ((migr_f==0 & (migr_m==. | migr_m<0)) | ((migr_f==. | migr_f<0) & migr_m==0)) // respondent native-born, one parent native other unknown
replace migr_gen=0 if migr==1 & (migr_f==0 & migr_m==0) // respondent foreign-born but both parents native

* 1 "1st generation"
replace migr_gen=1 if migr==1 & (migr_f==1 & migr_m==1) // respondent and both parents foreign-born
replace migr_gen=1 if migr==1 & ///
	((migr_f==1 & (migr_m==. | migr_m<0)) | (migr_m==1 & (migr_f==.| migr_f<0))) // respondent, one parent foreign-born other  unknown
replace migr_gen=1 if migr==1 & ///
	((migr_f==1 & migr_m==0) | (migr_m==1 & migr_f==0)) // respondent and one parent foreign-born, other native born

*2 "2st generation"
replace migr_gen=2 if migr==0 & (migr_f==1 & migr_m==1) // native-born, both parents foreign born
replace migr_gen=2 if migr==0 & ///
	((migr_f==1 & (migr_m==. | migr_m<0)) | (migr_m==1 & (migr_f==. | migr_f<0))) // native-born, one parent foreign-born other missing

*3 "2.5th generation"
replace migr_gen=3 if migr==0 & ///
	((migr_f==1 & migr_m==0) | (migr_m==1 & migr_f==0)) // native-born, one parent foreign-born other native-born	
	 
* Incomplete information parents
replace migr_gen=4 if migr==0 & (migr_f==. | migr_f<0) & (migr_m==. | migr_m<0) // respondent native-born, both parents unknown
replace migr_gen=4 if migr==1 & ((migr_f==. | migr_f<0) & (migr_m==.| migr_m<0)) // respondent foreign-born, both parents unknown
replace migr_gen=4 if migr==1 & ///
	 ((migr_f==0 & (migr_m==. | migr_m<0)) | ((migr_f==. | migr_f<0) & migr_m==0)) // respondent native-born, one parent native other unknown

  
	label values migr_gen migr_gen

*/


**--------------------------------------------
**   Mother tongue / language spoken as child
**--------------------------------------------	
// Not indluded in the current version due to too many MV
/*
***NOTE: very limited availability: question only asked of migrant subsample since 2017

lab def langchild ///
0 "same as country of residence" ///
1 "other" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

recode lr2076 (min/-5=-8) (-3=-1) (1/max=1) (else=.), gen(langchild)

lab val langchild langchild

*fill MV / correct inconsistent responses
	bysort pid: egen temp_langchild=mode(langchild), maxmode // identify most common response
	replace langchild=temp_langchild if langchild==. & temp_langchild>=0 & temp_langchild<.
	replace langchild=temp_langchild if langchild!=temp_langchild // correct a few inconsistent cases

*specify when question not asked
replace langchild=-8 if langchild==. & migr==0 // not asked if german-born
replace langchild=-8 if langchild==. & wave<2017 // not asked before 2017
*/
	
*################################
*#								#
*#	    Religion			 	#
*#								#
*################################

**--------------------------------------  
** Religiosity
**--------------------------------------
//NOTE: because we do not want to assume religious affiliation to be time-constant, missing values are not filled automatically across waves. 

lab def relig ///
0 "Not religious/Atheist/Agnostic" ///
1 "Religious" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

recode plh0258 (1/5=1) (6=0) (7/11=1) (-8 -5=-8), gen(relig)

lab val relig relig

*specify if question not asked
replace relig=-8 if relig==. & !inlist(wavey, 1990, 1991, 1997, 2003, 2007, 2011, 2015, 2019)

**--------------------------------------  
** Attendance
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

recode pli0098_h (1/2=4) (3=3) (4=2) (5=1) (-1=-2) (-2 -3 -4=-1) (-8 -5=-8) , gen(relig_att)

lab val relig_att attendance

*specify if question not asked
replace relig_att=-8 if relig_att==. & wavey<1990
replace relig_att=-8 if relig_att==. & inlist(wavey, 1991, 1993, 2000, 2002, 2004, 2006, 2010, 2012, 2014, 2016, 2020)

		
*################################
*#								#
*#	Weights						#
*#								#
*################################	 
**--------------------------------------
**   Cross-sectional sample weight
**--------------------------------------	
// gen wtcs= 
 
  
**--------------------------------------
**   Cross-sectional population weight
**--------------------------------------	
// NOTE: there are more weights availible, read SOEP or SOEP-CNEF documentation 
gen wtcp= w11105
 

**--------------------------------------
**   Longitudinal Weight
**--------------------------------------	
// Can be computed using Staying Probability -  read SOEP or SOEP-CNEF documentation 
 
**--------------------------------------
**   Longitudinal Weight
**--------------------------------------	
rename psample sampid_soep
lab var sampid_soep "Sample Identifier: SOEP"

**|=========================================================================|
**|  KEEP
**|=========================================================================|	
	
keep			///
wave pid country  intyear    age   marst* isco*  		///
edu* indust* inc* wavey	fpt* 						///
sat* size* inc*   exp*  entrep* train* selfemp*			///
kids* yborn female nphh work_* empls* public 			///
wh* mater un_*   retf*   	///
  hhinc* srh* disab*  						///train
nett* hid w11*    hnetto	nett*			///
wave1st intmonth mlstat* livpart nvmarr					///
respstat parstat*  jsecu chron	///
 isei* siops* mps*   wtcp	///nempl
widow divor separ fedu* medu* oldpens	///
cob* migr*   relig* /// migration and religion
sampid*
	 
	

**|=========================================================================|
**|  SAVE
**|=========================================================================|
 
label data "CPF_Germany v1.5"	 
save "${soep_out}\ge_02_CPF.dta", replace  	

	 
*____________________________________________________________________________
*--->	END	 <---


