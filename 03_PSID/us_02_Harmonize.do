*
**|=========================================|
**|	    ####	CPF	v1.5 ####				|
**|		>>>	PSID						 	|
**|		>>	02 Harmonize variables 			|
**|-----------------------------------------|
**|		Konrad Turek 	| 	2023		    |			
**|=========================================|
/* NOTE:
- for this do-file, use item-blocks created in us_01_3_Get_vars.do
- check variables at 
https://simba.isr.umich.edu/default.aspx
*/

**--------------------------------------
** Open merged dataset
**-------------------------------------- 
*** Combined 
use "${psid_out}\us_01.dta", clear


**--------------------------------------
** href
**-------------------------------------- 
rename  wave intyear

* Create hh head refernce 
gen href=0
replace href=1 if								///
		(refer==10 & intyear>=1983) |			///
		(refer==1 & intyear<1983) 
replace href=2 if									///			
		((refer==20|refer==22) & intyear>=1983) |	///
		(refer==2 & intyear<1983) 
lab def href 0 "Other fam memb" 1 "Head" 2 "Spouse/partner"
lab val href href 

**--------------------------------------
** Keep selected obs
**-------------------------------------- 

*** Keep 1: ind with info:
// drop if intyear>1968 & (xsqnr==0 | xsqnr>=80)

*** Keep 2: heads & partners: 
keep if (href==1|href==2) & 							///
			( (intyear>1968 & (xsqnr>0 & xsqnr<=20))	///
			| (intyear==1968)							///
			)	
	// 	N=458,192
		
*** Keep 3: 1-2 sequence (heads & partners): 
// keep if  	( (intyear>1968 & (xsqnr==1 | xsqnr==2))	///
// 			| (intyear==1968)							///
// 			)	
	// 	N=589,474		
	

*** Keep 4: 1-20 sequence: 
// keep if  	( (intyear>1968 & (xsqnr>0 & xsqnr<=20))	///
// 			| (intyear==1968)							///
// 			)		
	// 	N=901,963
	

		
			
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

// rename  x11101LL pid
// rename  x11102 hid

*** wavey 
* NOTE:
* - multi-year waves, better to use wave and intyear
* - for multi-year waves wavey indicates the 1st year of data collection
gen wavey=intyear
*
egen wave = group(intyear)

* Modify intyear for multi-year waves with the real interview date (waves<30 are ok)
replace intyear=intyB if wave>=30 & intyB<. & intyB>0

*
gen country=3
*
sort pid wave

*** wave1st
* NOTE: in US wave1st indicates 1st appearance in the dataset (also as a non-responding person)
bysort pid: egen wave1st = min(wave)


*** intmonth
/*intyA
The first two digits represent the month that the interview was taken 
(03=March, 04=April, etc). The last two digits represent the day of the month 
that the interview was taken.*/

gen intmonth=intyA	if intyA<13
replace	intmonth = cond((intyA >=100), int(intyA/100), intmonth)
replace intmonth=-1 if intyA==9999|intyA==0
replace	intmonth = intyB2 if intmonth==.
    
	
// *** Repsondent status 	
* NOTE: no data for 85-98 based on these variables 
// recode isresp (1=1) (. 0 9=-1) (5=2), gen(respstat)
// 	lab def respstat 	1 "Interviewed" 					///
// 						2 "Not interviewed (has values)" 	///
// 						3 "Not interviewed (no values)"
// 	lab val respstat respstat
	
	
******* to check
// rename  age age_c
// rename  eduy eduy_c
// rename intyear intyear_c
// merge 1:1 pid wave using "${psid_out}\us_Merg_03cnef.dta", keep(1 2 3)   
*******



*################################
*#								#
*#	Socio-demographic basic 	#
*#								#
*################################
**--------------------------------------
** Demographic
**--------------------------------------
* age
recode age (120/max=-1) (0=.)
// rename age age
 	lab var age "Age" 


* Birth year
	//Fill MV based on other waves or age
	bysort pid: egen temp_yborn=mode(yborn),  minmode
	gen temp_yborn2 = intyear-age if age>0 & age<.
	bysort pid: egen temp_yborn3=mode(temp_yborn2),  minmode

	replace yborn=temp_yborn if yborn==.
	replace yborn=temp_yborn3 if yborn==.  
	drop temp_y*

	// Correct inconsistent pid
	bysort pid: egen temp_yborn4=sd(yborn) 
	bysort pid: egen temp_yborn5=mode(yborn),  minmode
	replace yborn=temp_yborn5 if temp_yborn4>0


	lab var yborn "Birth year" 

* Fill age and yborn if missing	
	replace yborn=intyear-age if yborn==9999 & age>0 & age<.
	replace age=intyear-yborn  if yborn<9999 & (age<0 | age==.)
	recode yborn (9999=-1)
	
	
	* Correct yborn if not consistent values of yborn across weaves
		bysort pid: egen temp_min=min(yborn)
		bysort pid: egen temp_max=max(yborn)
		gen temp_check=temp_max-temp_min if temp_max>0 & temp_max<. & temp_min>0 & temp_min<.
		replace temp_check=999 if temp_min==-1 & temp_max>0 
// 					bro pid intyear age yborn  temp_min temp_max temp_check if temp_check>0 & temp_check<.
		bysort pid: egen temp_yborn=mode(yborn) if temp_check>0 & temp_check<., maxmode
		bysort pid: egen temp_yborn_max=max(yborn) if temp_check>0 & temp_check<. 
		replace temp_yborn=temp_yborn_max if temp_yborn==-1 & temp_yborn_max>0 & temp_yborn_max<.
// 					bro pid intyear age yborn temp_yborn temp_min temp_max temp_check if  temp_check>0 & temp_check<.
				
		replace yborn=temp_yborn if temp_yborn<. & temp_yborn>0
		
		// 		bysort pid: egen temp_sd=sd(yborn)
		// 		tab temp_sd
		
	* Correct age based on corrected yborn
		replace age=intyear-yborn  if temp_yborn>0 & temp_yborn<.  
	* Fill age based on yborn if missing
		replace age=intyear-yborn  if yborn>0 & yborn<. & (age<0 | age==.)
		
		
	* Correct age if values inconsistent with yborn (only if difference more than +/-1)
		gen temp_age_yborn=intyear-yborn if yborn>1000 & yborn<. 
		gen temp_age_err=age-temp_age_yborn if temp_age_yborn>0 & temp_age_yborn<120 & age>0 & age<120
// 		bysort pid: egen temp_difmax=max(abs(temp_age_err))
		replace age=temp_age_yborn if (temp_age_err>1 | temp_age_err<-1) & temp_age_err!=.

			


		drop temp*

		
	
* Gender
recode gender (1=0) (2=1), gen(female)
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

*################################
*#								#
*#	Education				 	#
*#								#
*################################

**--------------------------------------  
** Education  
**--------------------------------------
/*NOTE:
- there are 2 items (eduy_f, eduyBH) which  differ - read desription for variables 
- eduy_f is for resp., eduyBH for HEAD
- we fill MV within individuals with information form other waves 
  (the procedure can be modified) 
- it is recommended to clear the final variable (e.g. jumping values within individual)
*/


*
// gen eduy_org=eduy_f
 * Fill MV within individuals (eduy_family)
foreach var in eduy_f eduyBH  {
// clonevar `var'_org=`var' 
bysort pid (intyear): replace `var'=`var'[_n-1] ///
	if (`var'==0 | `var'>20) & `var'[_n-1]>0 & `var'[_n-1]<20
bysort pid : egen temp_`var'min2=min(`var') if `var'>0
bysort pid : egen temp_`var'min=min(temp_`var'min2)
bysort pid (intyear): replace `var'=temp_`var'min ///
	if (`var'==0 | `var'>20) & temp_`var'min<20 & age>=18
drop temp*
// tab `var'_org `var'
// drop `var'_org
}
 
*
gen eduy=eduy_f
	lab var eduy "Education: years"
recode eduy (99=-2)
	
* edu3
recode eduy (1/11=1)(12/15=2)(16/17=3)(98 99 .=-1)(0=-3), gen(edu3)

 	lab def edu3  1 "[0-2] Low" 2 "[3-4] Medium" 3 "[5-8] High" // 2 incl Vocational
	lab val edu3 edu3
	lab var edu3 "Education: 3 levels"

	
*** edu4
recode  eduy (1/8=1)(9/11=2)(12/15=3)(16/17=4)(98 99 .=-1)(0=-3),  gen(edu4)

	lab def edu4  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" 4 "[5-8] Tertiary" 
	lab val edu4 edu4
	lab var edu4 "Education: 4 levels"
	
*** edu5
recode  eduy (1/8=1)(9/11=2)(12/15=3)(16=4)(17=5)(98 99 .=-1)(0=-3),  gen(edu5)

	lab def edu5  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" ///
				  4 "[5-6] Tertiary lower(bachelore)"  ///
				  5 "[7-8] Tertiary upper (master/doctoral)"
				  
	lab val edu5 edu5
	lab var edu5 "Education: 5 levels"

 


*################################
*#								#
*#	Family and relationships	#
*#								#
*################################
**--------------------------------------  
** Primary Marital status  (from CNEF) 	 
**--------------------------------------
* Approach based on CNEF 
* NOTE: 
* - categories of 'single' and 'living with partner' not fully precise and can be contradictory to other variables 
* - country differences in inclusion of having/living with partner
* - country differences in definition of ‘single’ 

recode marstat (1=1) (2=2) (3=3) (4=4) (5 8=5) (9=-1) ///
		if (href==1|href==2), gen(marstat5)

	lab var marstat5 "Marital status [5]"
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
* Only formal marital status included, no info on having/living with partner
* Never married include singles  
// NOTE: 
// - US 1968-1976 no distinction between legally married and cohabiting (combined into cat "1")
// - this is partly corrected for Heads in years 77+ 
// - Partners of cohabiting Heads remain in "1", because there is no better category for them

recode marstat (1 8=1) (2=2) (3=3) (4=4) (5=5) (9=-1) ///
		if (href==1|href==2), gen(mlstat5)
	
	* For years 77+ there is additional var for Heads can help to remove cohabitation from cat "1"
	replace mlstat5=2 if marstat==1 & marstatH2==2 & href==1
	replace mlstat5=marstatH2 	if marstat==1 & (marstatH2==3|marstatH2==4|marstatH2==5) & href==1
	
					
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
recode marstat5 (1=1) (2/8=0) (9=-1) ///
		if (href==1|href==2), gen(livpart)


// 		lab var haspart "Has a partner"
		lab var livpart "Living together with partner"
		lab val livpart    yesno
		
**--------------------------------------
** Partnership living-status 	 
**--------------------------------------
* Includes information on marital status and whether living with partner in HH 

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
/*
Based on information on marital status:
1	Married
2	Single
3	Widowed
4	Divorced
5	Separated
8 	Married, spouse absent
9	NA
It includes singles considered as never legally married with no partner present in the HH. However, some contradictory results can occur when cross-tabulating different variables about the marital status included in the PSID. Note, that PSID does not separate precisely between cohabiting and married couples. Therefore permanently cohabiting couples with partners present in the HH can be considered as marred (not single) in some cases. The problem should not apply to Reference Persons (Heads). For details, see PSID documentation. 
*/

recode marstat (2=1) (1 3/8=0) (9=-1) ///
		if (href==1|href==2), gen(nvmarr)
		
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
// ER32036 from psid_org
//  	lab var ymarr "Year married	"
	
	


		
**--------------------------------------
** Children 
**--------------------------------------
*  
//	kids_birth 	// # LIVE BIRTHS TO THIS INDIVIDUAL  (no useful - constatn, only latest reported wave)

gen kidsn_hh17=kidshh // Number of Children Under 18 Living with Family
	
// 	lab var kids_any  "Has children"
// 	lab val kids_any   yesno
// 	lab var kidsn_all  "Number Of Children" 
//  	lab var kidsn_18   "Number Of Children <18 y.o." 
// 	lab var kidsn_15   "Number Of Children <15 y.o." 
 	lab var kidsn_hh17   "Number of Children in HH aged 0-17"
	
**--------------------------------------  
** People in HH  
**--------------------------------------
 
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

// e11102 (work_py)
// If individual had positive wages in the previous year and worked at least 52 hours 
// then the individual was employed. Otherwise, the individual was not employed.
// the code below only for HEAD 


// gen work_py=1 if (href==1) 					/// For head/ref.person 
// 				 & incj_yH>0 & incj_yH<. 	/// Total income from work (incj_yHB is only from salaries)
// 				 & (whyearHEAD>=52 & whyearHEAD<9000) //
//				 
// recode work_py (.=0)



// e11104 (work_d)		
// This variable is based on the individual’s self-reported primary activity at the 
// time of the interview.
// If the individual reported that he or she is working then the individual is considered 
// to be working now. If the individual reported that he or she is temporarily laid off, 
// looking for work, unemployed, retired, permanently disabled, keeping house, or is a 
// student then the individual is considered to be not working now.

recode emplst_IND (1=1)(2/8=0)(9=-1)(0=-3), gen(work_d)
recode emplst_H (1=1)(2/6=0)(9=-1)(0=-3) if intyear<1976 & href==1	, gen(tempHa)
recode emplst_H (1=1)(2/8=0)(9=-1)(0=-3) if intyear>=1976 & intyear<1979 & href==1	, gen(tempHb)
recode emplst_S (1=1)(2/8=0)(9=-1)(0=-3) if intyear>=1976 & intyear<1979 & href==2	, gen(tempS)

	replace work_d=tempHa if intyear<1976 & href==1
	replace work_d=tempHb if intyear>=1976 & intyear<1979 & href==1		
	replace work_d=tempS  if intyear<1979 & href==2		
	replace work_d=-3  	  if intyear<1976 & href==2	

		drop temp*

// 	lab var work_py "Working: last year (based on hours)"	
	lab var work_d "Working: currently (based on selfrep)" // last week
	lab val   work_d yesno
	
	
**--------------------------------------
** Employment Status 
**--------------------------------------  
* emplst5

recode emplst_IND (1 2=1)(3=2)(4 5=3)(6 8=4)(7=5)(9=-1)(0=-3), gen(emplst5)
recode emplst_H (1=1)(2=2)(3=3)(4 6=4)(5=5)(9=-1)(0=-3) if intyear<1976 & href==1	, gen(tempHa)
recode emplst_H (1 2=1)(3=2)(4 5=3)(6 8=4)(7=5)(9=-1)(0=-3) if intyear>=1976 & href==1, gen(tempHb)
recode emplst_S (1 2=1)(3=2)(4 5=3)(6 8=4)(7=5)(9=-1)(0=-3) if intyear>=1976 & href==2	, gen(tempS)

	replace emplst5=tempHa if intyear<1976 & href==1
	replace emplst5=tempHb if intyear>=1976 & intyear<1979 & href==1		
	replace emplst5=tempS  if intyear<1979 & href==2		
	replace emplst5=-3     if intyear<1976 & href==2	
	replace emplst5=tempHb if intyear>=1976 & href==1 & emplst5==-3 & tempHb<. & tempHb>=-1
	replace emplst5=tempS  if intyear>=1976 & href==2 & emplst5==-3 & tempS<. & tempS>=-1

		drop temp*
		
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
* NOTE: correct only for waves 1976+ 

recode emplst_IND (1=1)(3=2)(4 5=3)(6 8=4)(7=5)(2=6)(9=-1)(0=-3), gen(emplst6)
recode emplst_H (1 2=1)(3=2)(4 5=3)(6 8=4)(7=5)(2=6)(9=-1)(0=-3) if intyear>=1976 & intyear<1979 & href==1, gen(tempHb)
recode emplst_S (1 2=1)(3=2)(4 5=3)(6 8=4)(7=5)(2=6)(9=-1)(0=-3) if intyear>=1976 & intyear<1979 & href==2	, gen(tempS)

	replace emplst6=tempHb if intyear>=1976 & intyear<1979 & href==1		
	replace emplst6=tempS  if intyear<1979 & href==2		
	replace emplst6=-3     if intyear<1976  	
			drop temp*

	
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
** Occupation ISCO 
**--------------------------------------  
* isco1 isco2

/* Overview:
HEAD
occupB // to 80, corrected, 3d Census 1970
occupC // 81-01 (+1974), 3d Census 1970
occupD // 03+, 3/4d  Census 2010 

SPOUSE
occupBS // to 80, corrected, 3d Census 1970
occupCS // 81-01, 3d Census 1970
occupDS // 03+, 3/4d Census 2010 
*/

/*** General approach: 
Census 2010 --croswalk excel '2010-occ-codes-with-crosswalk-from-2002-2011.xls'--> SOC 2010 
			--> SOC 2010 --ISCO_SOC_Crosswalk.xls--> isco-08

[Census 1970 --'OCCBLS_paper.pdf p.17' by hand --> isco_2 / census 2010
OR]

Census 1970 --ACS 2010'KT_ver1.xlsx'-->	
			ACS 2010--'nem-occcode-acs-crosswalk.xlsx'-->SOC 2010
			--> SOC 2010 --ISCO_SOC_Crosswalk.xls--> isco-08
*/

/***NOTE:
- The procedure included below refers to external do-file with a long recoding code
- The crosswalk from PSID-codes to ISCO-codes was developed based on information from 
  several sources and in a few steps. 
- Main Sources: 
	- U.S. BUREAU OF LABOR STATISTICS (https://www.bls.gov/emp/documentation/crosswalks.htm)
	- U.S. CENSUS BUREAU (https://www.census.gov/topics/employment/industry-occupation/guidance/code-lists.html)
	- IPUMS USA (https://usa.ipums.org/usa/volii/occ1970.shtml)
- Some adjustments to recoding schemes were necessary 
	- Note that at 4-digit level the recoding was very imprecise due to differences in classification schemes
	- In case when there was no direct crosswalk between codes, the closest or more general category was applied	
	- 1- or 2-digit level is recommended for practical use 
- General approach: 
	- Census 1970 --> ACS 2010 --> SOC 2010 --> ISCO-08
	- Census 2010 ---------------> SOC 2010 --> ISCO-08
*/


**** Croswalks' codes are very long, so they were stored extrnally. 
**** They can be called by the functions below 
	*** Census 1970 --> isco-08 
		*step 1: census 70--> ASC 2010
			do "${psid_syntax}\us_02add_isco_A_step1.do"
		*step 2: ASC 2010 --> SOC 2010
			do "${psid_syntax}\us_02add_isco_A_step2.do"
		*step 3: SOC 2010 --> isco-08
			do "${psid_syntax}\us_02add_isco_A_step3.do"
	*** Census 2010 --> isco-08  										 
		*step 1: census 2010 --> SOC 2010
			do "${psid_syntax}\us_02add_isco_B_step1.do"
		*step 2: SOC 2010 --> isco-08
			do "${psid_syntax}\us_02add_isco_B_step2.do"



*** Create single isco-4 variable 
gen isco08_4=.
	replace isco08_4=occupB_isco08  if intyear<1981 & href==1
	replace isco08_4=occupBS_isco08 if intyear<1981 & href==2

	replace isco08_4=occupC_isco08 	if intyear>=1981 & intyear<2001 & href==1
	replace isco08_4=occupCS_isco08 if intyear>=1981 & intyear<2001 & href==2

	replace isco08_4=occupD_isco08  if intyear>2001 & href==1
	replace isco08_4=occupDS_isco08 if intyear>2001 & href==2

	recode isco08_4 (-3 -1=.)

// ssc install iscogen


*** Recode  
iscogen isco88_4= isco88(isco08_4) ,  from(isco08)
iscogen isco08_4bis= isco08(isco88_4) ,  from(isco88)

iscolbl isco08 isco08_4

replace isco88_4=110 if isco08_4==9800
replace isco08_4bis=300 if isco08_4==9800
recode  isco08_4 (9800=300)


*** isco_1 isco_2
generate isco_1 = cond(isco08_4> 1000, int(isco08_4/1000), .)
replace isco_1=0 if isco08_4<1000 & isco08_4>0

generate isco_2 = cond(isco08_4> 1000, int(isco08_4/100), isco08_4)
recode isco_2 (110=1)(210 211=2)(300=0)(310 315=3)
 

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
/*Notes: 
*/

/* Overview:
HEAD:
	industA  // to 80, corrected, 3d Census 1970
	industC  // 81-01, 3d Census 1970
	industD  // 03-15, 3d  Census 2010 
	industD  // 17,    4d  Census 2012 
SPOUSE:
	industAS  // to 80, corrected, 3d Census 1970
	industCS  // 81-01, 3d Census 1970
	industDS  // 03-15, 3d  Census 2010 
	industDS  // 17,    4d  Census 2012  
*/

***	Recode into 3 versions of classification 
*** A C (1968-2001: 3 digit census 1970) 
foreach var in  industA industAS industC industCS {
	recode `var' (17/28 47/57 67/77 107/398=1)										 ///
			 (407/479 507/698 707/718 727/759 769/798 806/809 849 888/897 503 =2)	 ///
			 (907/937 828/848 857/887=3)											 ///
			 (998 999 957/961=-1)(0=-3), gen(temp_`var'_1)
	recode `var' (17/28=1)(467/479=2)(47/57=3)(107/369 377/398=4)	///
			 (67/77=5)(507/698 503 =6)(407/449=7)					///
			 (707/718=8)											///
			 (727/759 769/798 806/809 828/897 907/937=9)			///
			 (998 999 957/961=-1)(0=-3), gen(temp_`var'_2)
	recode `var' (17/27=1)									///
			 (28=2)											///
			 (47/57=3)										///
			 (107/398=4)									///
			 (467/479=5)									///
			 (67/77=6)										///
			 (507/668 677/698 728 749/759 503 =7)			///
			 (777/778 669=8) 								///
			 (407/449=9)									///
			 (707/717=10)									///
			 (718 727 729/748 888/897=11)					///
			 (907/937 =12)									///
			 (857/868=13)									///
			 (828/848 878/879=14)							///
			 (769 779/798 806/809 849 869/877 887=15)		///
			 (998 999 957/961=-1)(0=-3), gen(temp_`var'_3)
}
*

***	D (2003-2015: 3 dig Census 2010, 2017: 4 digit Census 2012) 	  
foreach var in  industD industDS {
	recode `var' (17/399=1)							///
			 (407/779 856/929 =2) 					///
			 (786/789 797/848 937/987=3)			///
			 (999=-1)(0=-3)							///
			 if wave>=33 & wave<40, gen(temp_`var'_1a)
			 
	recode `var' (17/29=1)							///
			 (57/69=2)								///   
			 (37/49=3)								///
			 (107/399=4)							///
			 (77=5)									///
			 (407/459 467/579=6)					///
			 (607/639=7)							///
			 (687/699=8)							///
			 (647/679 707/719 727/749 757/987=9)	///
			 (999=-1)(0=-3)							///
			 if wave>=33 & wave<40, gen(temp_`var'_2a)
			 
	recode `var' (17/27 29=1)						///
			 (28=2)									///
			 (37/49=3)								///
			 (107/399=4)							///
			 (57/69=5)								///
			 (77=6)									///
			 (407/459 467/579=7)					///
			 (866/869=8)							///
			 (607/639 647/679=9)					///
			 (687/699=10)							///
			 (707/719 727/749 757/779=11)			///
			 (937/987=12)							///
			 (786/789=13)							///
			 (797/848=14)							///
			 (856/859 875/929=15)					///
			 (999=-1)(0=-3)							///
			 if wave>=33 & wave<40, gen(temp_`var'_3a)
	* 2017:		 			
	recode `var' (170/3990=1)							///
			 (4070/7790 8560/9290 =2) 					///
			 (7860/7890 7970/8480 9370/9870=3)			///
			 (9999=-1)(0=-3)							///
			 if wave>=40, gen(temp_`var'_1b)
			 
	recode `var' (170/290=1)							///
			 (570/690=2)								///   
			 (370/490=3)								///
			 (1070/3990=4)								///
			 (770=5)									///
			 (4070/4590 4670/5790=6)					///
			 (6070/6390=7)								///
			 (6870/6990=8)								///
			 (6470/6790 7070/7190 7270/7490 7570/9870=9)	///
			 (9999=-1)(0=-3)							///
			 if wave>=40, gen(temp_`var'_2b)
			 
	recode `var' (170/270 290=1)						///
			 (280=2)									///
			 (370/490=3)								///
			 (1070/3990=4)								///
			 (570/690=5)								///
			 (770=6)									///
			 (4070/4590 4670/5790=7)					///
			 (8660/8690=8)								///
			 (6070/6390 6470/6790=9)					///
			 (6870/6990=10)								///
			 (7070/7190 7270/7490 7570/7790=11)			///
			 (9370/9870=12)								///
			 (7860/7890=13)								///
			 (7970/8480=14)								///
			 (8560/8590 8770/9290=15)					///
			 (9999=-1)(0=-3)							///
			 if wave>=40, gen(temp_`var'_3b)
}
*

*** Generate single variables 
foreach n in 1 2 3 {
gen indust`n'=.
 	replace indust`n'=temp_industA_`n'   if intyear<1981 & href==1
	replace indust`n'=temp_industAS_`n'  if intyear<1981 & href==2

	replace indust`n'=temp_industC_`n'   if intyear>=1981 & intyear<2001 & href==1
	replace indust`n'=temp_industCS_`n'  if intyear>=1981 & intyear<2001 & href==2

	replace indust`n'=temp_industD_`n'a  if wave>=33 & wave<40 & href==1
	replace indust`n'=temp_industDS_`n'a if wave>=33 & wave<40 & href==2

	replace indust`n'=temp_industD_`n'b  if wave>=40 & href==1
	replace indust`n'=temp_industDS_`n'b if wave>=40 & href==2
}

*** Labels 		  
* Major groups 
lab def indust1											///
           1 "[1] Production, Construction, Heavy Ind"	///
           2 "[2] Trade and Services"					///
		   3 "[3] Public services"						///
		  -1 "[-1] MV general"							///
		  -3 "[-3] Does not apply"	    
	lab val indust1 indust1		  
	lab var indust1 "Industry (major groups)" 
	
* Submajor groups 
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
*		  
drop temp*		  
 
**--------------------------------------
** Public sector
**--------------------------------------  

recode publicA publicAS (1=1)(5=0)(8 9=-1)(0=-3) ///
	   if intyear>=1975 & intyear<=1982, gen(temp_publicA1 temp_publicAS1)
recode publicA publicAS (1/3=1)(4 7=0)(8 9=-1)(0=-3) ///
	   if intyear>=1983 & intyear<=2001, gen(temp_publicA2 temp_publicAS2)
recode publicB1_ publicB2_ (1/3=1)(4 7=0)(8 9=-1)(0=-3) ///
	   , gen(temp_publicB1_ temp_publicB2_)
*	   
gen public=.
 	replace public=temp_publicA1   if intyear>=1975 & intyear<=1982 & href==1
	replace public=temp_publicAS1  if intyear>=1975 & intyear<=1982 & href==2
 	
	replace public=temp_publicA2   if intyear>=1983 & intyear<=2001 & href==1
	replace public=temp_publicAS2  if intyear>=1983 & intyear<=2001 & href==2

	replace public=temp_publicB1_  if intyear>=2003 & href==1
	replace public=temp_publicB2_  if intyear>=2003 & href==2


		lab val public yesno
		lab var public "Public sector"
*		
drop temp*	

**--------------------------------------
** Size of organization	
**--------------------------------------
  
gen size=.
	replace size=sizeBMJ   if  href==1
	replace size=sizeA   if  href==2
recode size (9999999/max=-1)(0=-3)
	
recode size (1/19=1)(20/199=2)(200/1999=3)(2000/max=4)		, gen(size4)
recode size (1/9=1)(10/49=2)(50/99=3)(100/999=4)(1000/max=5), gen(size5)
recode size (1/9=1)(10/49=2)(50/99=3)(100/499=4)(500/max=5)	, gen(size5b)
	 
 
 	lab def size4 1 "<20" 2 "20-199" 3 "200-1999" 4 "2000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab def size5 1 "<10" 2 "10-49" 3 "50-99" 4 "100-999" 5 "1000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab def size5b 1 "<10" 2 "10-49" 3 "50-99" 4 "100-499" 5 "500+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	
	lab var size  "Size of organization [cont]"
	lab var size4 "Size of organization [4]"
	lab var size5 "Size of organization [5]"
	lab var size5b "Size of organization [5b]"
	lab val size4 size4
	lab val size5 size5
	lab val size5b size5b
	
 
**--------------------------------------
** hours conracted
**--------------------------------------
* wh_ctr
// 	lab var whweek_ctr "Work hours per week: conracted"

**--------------------------------------
** hours worked
**--------------------------------------  
gen whyear=.
	replace whyear=whyearHEAD   if  href==1
	replace whyear=whyearWIFE   if  href==2
recode whyear (9999=-3)

*
gen whweek=whyear/52
replace whweek=whyear if whyear<0
*
gen whmonth=whyear/12
replace whmonth=whyear if whyear<0

// 	lab var whday "Work hours per day: worked"
	lab var whweek "Work hours per week: worked"
	lab var whmonth "Work hours per month: worked"
	lab var whyear "Work hours per year: worked"
 
 

**--------------------------------------
** full/part time
**-------------------------------------- 
* fptime_r fptime_h


recode whyear (1/1819=2)(1820/9000=1)(0=3), gen(fptime_h)  


// 	lab var fptime_r "Employment Level (self-report)"
	lab var fptime_h "Employment Level (based on hours)"
	
	lab def fptime 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other"
	lab val fptime_h fptime
	
**--------------------------------------
** overtime working !!!!
**--------------------------------------
 
//  whweekOVERTMJ whweekOVERTJ2_ whweekOVERTJ3_ whweekOVERTJ4_
//  whweekOVERTMJS whweekOVERTJ2S_ whweekOVERTJ3S_ whweekOVERTJ4S_
 
**--------------------------------------
** Supervisor 	
**--------------------------------------
* supervis
	
// 	lab val supervis yesno
// 	lab var supervis "Supervisory position"
	
**--------------------------------------
** maternity leave  
**--------------------------------------
 
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
* un_reg

// 	lab val un_reg yesno
// 	lab var un_reg "Unemployed: registered"

**--------------------------------------
** Unempl: reason  !! Harmon
**--------------------------------------
* 
/*Notes: 
- create set of categories if harmon possible
*/
 

**--------------------------------------
** Unempl: actively looking for work 
**--------------------------------------
* un_act

recode emplst5 (-3 1/6=0) (-1=.) if intyear>=1976 ,gen(un_act)

 	replace un_act=1 if href==1 & emplst5==2 & un_act1_==1 & intyear>=1976 & intyear<1985
	replace un_act=1 if href==1 & emplst5==2 & un_act2_==1 & intyear>=1985 & intyear<2003
 	replace un_act=1 if href==1 & emplst5==2 & un_act3_==1 & intyear>=2003

	replace un_act=1 if href==2 & emplst5==2 & un_actS1_==1 & intyear>=1976 & intyear<1985
	replace un_act=1 if href==2 & emplst5==2 & un_actS2_==1 & intyear>=2003
	

		lab val un_act yesno
		lab var un_act "Unemployed: actively looking for work "

*################################
*#								#
*#	Self-empl / Entrepreneur	#
*#								#
*################################
**--------------------------------------	
** Self-imployed	!! Harmon
**--------------------------------------
* selfemp v1-v3 

/* NOTE: 
- refers only to the main job 
- only "Self-employed only"
- possible to include other jobs (blocks for selfemp) or farmers ('farmer')
*/

recode emplst5 (-3 1/6=0) (-1=.)   ,gen(selfemp)
replace selfemp=. if href==2 & intyear<1976

 	replace selfemp=1 if href==1 & (selfempA==3)    & intyear< 2003
	replace selfemp=1 if href==1 & (selfempBMJ==3)  & intyear>=2003

	replace selfemp=1 if href==2 & (selfempAS==3)   & intyear>=1976 & intyear<2003
	replace selfemp=1 if href==2 & (selfempBMJS==3) & intyear>=2003

 
	lab val   selfemp   yesno
// 	lab var selfemp_v1 "Self-employed 1: all without Family Business"
	lab var selfemp "Self-employed 2: all with Family Business"
// 	lab var selfemp_v3 "Self-employed 3: based on income from self-empl"

**--------------------------------------
** Entrepreneur 
**--------------------------------------	
/* NOTE:
- combines info about selfemp with size of company (only for the main job) 
- Infor about farmers in 'farmer' or ISCO (but not precise) 
*/

recode selfemp (0 1=0), gen(entrep2)
replace entrep2=1 if selfemp==1 & size>1 & size<.

//   	lab val entrep yesno
//   	lab var entrep  "Entrepreneur (not farmer; has employees)"

	lab val entrep2 yesno
	lab var entrep2 "Entrepreneur (incl. farmers; has employees)"

	

**--------------------------------------
** Number of employees 
**--------------------------------------
recode entrep2 (0 1=-1), gen(nempl)
replace nempl=1 if entrep2==1 & size>=2 & size <=9
replace nempl=2 if entrep2==1 & size>=10 & size <.

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
/*
PROBLEM for years 93-03: NO DATA. 
PSID Team email: 
	Unfortunately, we do not have the component values of the Social Security variables 
	you asked about. We have the data, and so were able to make the imputed total values 
	for 1993-2003, but they are not in a releasable format at the time. This task in on 
	our Data Production team's to-do list but we have no estimate for when it will happen. 

	We do have the data for G33 in a  supplemental social security file.  It is located 
	on the "Auxiliary File" data page:
	https://simba.isr.umich.edu/Zips/AuxiliaryFiles.aspx 

	A word of caution, though. There is some missingness. 
*/

*   
/*Note: 
- from 1984 (missing for 1993-2003!)
*/								  

// ret_pensA // 94-17 H, other retirement pay, pensions
// ret_pensB // 13-17 H, other retirement pay, pensions
// ret_pensC // 84-09 IND, social sec - retirement 
// ret_pensD // 11+   IND, social sec - retirement 

// 84-09 IND
// ret_pensC
// 	G31. ==1 (anyone)	// included in ret_pensC
// 		G32.== (who recives? HEAD=? / SPOUSE=?) // included in ret_pensC
// 			G.33 ==2 (ret) 		//ret_pensC==2
// 			G.33 ==1 (disab)	//ret_pensC==1	
// 			G.33 ==3 (surv)		//ret_pensC==3	
// 			G.33 ==1/2/3 (mixed)	//ret_pensC==3
// // 11+ IND
// ret_pensD==1
// disab_pensB==1 //
// surv_pensD==1

// 1993-2003
// ret_pensA // HEAD Retirement Pay or Pensions 
// SPOUSE  Retirement Pay or Pensions - PROBLEM! no precise info 


*** oldpens !!!! PROBLEM 93-03  
// recode href (1 2=0) if intyear>=1984, gen(oldpens)
// 	replace oldpens=1 if (ret_pensC==2|ret_pensC==4) & intyear>=1984 & intyear<2011
// 	replace oldpens=1 if ret_pensD==1 & intyear>=2011
// 	replace oldpens=1 if ret_pensA==1  & intyear>=1994 & intyear<2005 & href==1 
// 	replace oldpens=1 if ret_pensAS==1 & intyear>=1994 & intyear<2005 & href==2

	
// 		lab var oldpens "Receiving old-age pension"
// 		lab val oldpens yesno 

*** Any pension !!!!	PROBLEM 93-03  
// recode href (1 2=0) if intyear>=1984, gen(any_pens)
// 	replace any_pens=1 if (ret_pensC>=1 & ret_pensC<=4) & intyear>=1984 & intyear<2011
// 	replace any_pens=1 if (ret_pensD==1|disab_pensB==1|surv_pensD==1) & intyear>=2011
//				  
// 		lab var any_pens "Receiving any pension: retirement, disability or survivor's"
// 		lab val any_pens yesno 
	


**--------------------------------------
** Receiving disability pension   
**--------------------------------------	 
// - from 1984 (missing for 1993-2003!)

* disabpens  !!!!	PROBLEM 93-03  
// recode href (1 2=0) if intyear>=1984, gen(disabpens)
// 	replace disabpens=1 if (ret_pensC==1|ret_pensC==4) & intyear>=1984 & intyear<2011
// 	replace disabpens=1 if disab_pensB==1 & intyear>=2011
//				  
// 		lab var disabpens "Receiving disability pension"
// 		lab val disabpens yesno 
		
		
**-------------------------------------- 
** Fully retired - identification
**-------------------------------------- 
// PROBLEM: no pensio info 93-03

/* retf - Criteria if oldpens avaliable:
- Not working (only retired (for <=1975 head only))
- Receives pension (old-age)
- Age 
*/

// recode href (1 2=0), gen(retf)
// replace retf=1 if emplst_IND==4 & intyear>=1979 & href==1 & age>=45 & oldpens==1
// replace retf=1 if emplst_H==3   & intyear<1976  & href==1 & age>=45 & oldpens==1	// ret+disab
// replace retf=1 if emplst_H==4   & intyear>=1976 & intyear<1979 & href==1 & age>=45 & oldpens==1
// replace retf=1 if emplst_S==4   & intyear>=1976 & intyear<1979 & href==2 & age>=45 & oldpens==1	 
 
  

/* retf - Criteria:
- Not working 
- Self-identification as retired & age 50+ 
- Age 60+ & NW
*/	
recode href (1 2=0), gen(retf)
replace retf=1 if emplst_IND==4 & intyear>=1979 & href==1 & age>=50  
replace retf=1 if emplst_H==3   & intyear<1976  & href==1 & age>=50	// ret+disab
replace retf=1 if emplst_H==4   & intyear>=1976 & intyear<1979 & href==1 & age>=50
replace retf=1 if emplst_S==4   & intyear>=1976 & intyear<1979 & href==2 & age>=50

replace retf=1 if  emplst5>1 & age>=65

	lab var retf "Retired fully"
	lab val retf yesno 

 
**--------------------------------------
** Age of retirement  
**--------------------------------------  
*   
/*Note: 
	if intyear<93 - age
	if intyear>=93 - year 
*/			  

// recode href (1 2=0), gen(aret)
// 	replace aret=yret  if intyear>=1978 & href==1
// 	replace aret=yretS if intyear>=1979 & href==2
// 	recode aret (9990/max=-1) (200/1800=-1)
// 	//recode year into age
// 	replace aret = aret-yborn if intyear>=93 & aret>1800 & aret<3000 & aret>=yborn
// 	recode aret (200/max=-1)  

	

*################################ 
*#								#
*#	Work history 				#
*#								#
*################################

**--------------------------------------
**   Labor market experience full time
**--------------------------------------
* expft

recode href (1 2=0), gen(expft)
	replace expft=expftH if intyear>=1974 & href==1
	replace expft=expftS if intyear>=1974 & href==2
	
	recode expft (95=1) if intyear>=2015
	replace expft=age-18 if expft==96 & intyear>=2011
	recode expft (98 99=-1) 
	
	lab var expft "Labor market experience: full time"

	
**--------------------------------------
**   Labor market experience part time 
**--------------------------------------
* exppt

// 	lab var exppt "Labor market experience: part time"
	
**--------------------------------------
**   Total Labor market experience (full+part time) !!!
**--------------------------------------
* exp	
rename exp expH

recode href (1 2=0), gen(exp)
	replace exp=expH if intyear>=1974 & href==1
	replace exp=expS if intyear>=1974 & href==2
	
	recode exp (95=1) if intyear>=2015
	replace exp=age-18 if exp==96 & intyear>=2011
	recode exp (98 99=-1) 
	
	lab var exp "Labor market experience"

**--------------------------------------
**   Experience in org
**--------------------------------------
* exporg
	
// 	exporgA  
// 		68-categoreis
// 		76+ - months 
// 			(999=-1)
// 	exporgBX = exporgB + exporgBm + exporgBw
// 	exporgBSX = exporgBS + exporgBSm + exporgBSw
// 		exporgB - years
// 			(98 99=-1)
// 		exporgBm - months
// 			(98 99=-1)
// 			exporgBm/12
// 		exporgBw
// 			(98 99=-1)
// 			exporgBw/52
	
	gen exporgAy=exporgA/12 if intyear>=1976 & intyear<1994 & exporgA<999
	gen exporgBX=exporgB if exporgB<98 & exporgB>=0
		replace exporgBX=exporgBX+(exporgBm/12) if exporgBm>0 & exporgBm<98
		replace exporgBX=exporgBX+(exporgBw/52) if exporgBw>0 & exporgBw<98
	gen exporgASy=exporgAS/12 if intyear>=1978 & intyear<1994 & exporgAS<999
	gen exporgBXS=exporgBS if exporgBS<98 & exporgBS>=0
		replace exporgBXS=exporgBXS+(exporgBSm/12) if exporgBSm>0 & exporgBSm<98
		replace exporgBXS=exporgBXS+(exporgBSw/52) if exporgBSw>0 & exporgBSw<98
		
recode href (1 2=0), gen(exporg)
	replace exporg=exporgAy if intyear>=1976 & intyear<1994 & href==1
	replace exporg=exporgBX if intyear>=1994 & href==1
	
	replace exporg=exporgASy if intyear>=1978 & intyear<1994 & href==2
	replace exporg=exporgBXS if intyear>=1994 & href==2
	
	lab var exporg "Experience in organisation"
	
**--------------------------------------
**   Never worked
**--------------------------------------	 
*neverw

rename neverw neverwH

recode href (1 2=0), gen(neverw)
	replace neverw=1 if neverwH==5 & intyear>=1976 & href==1
	replace neverw=1 if neverwS==5 & intyear>=1976 & href==2
	replace neverw=0 if neverw==1 & emplst5==1 

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

// 	lab var inctot_yn "Individual Income (All types, year, net)"
// 	lab var inctot_mn "Individual Income (All types, month, net)"


	
* all jobs  
  
	gen 	incjobs_yg=.
	replace incjobs_yg=incj_yH  	if href==1
	replace incjobs_yg=incj_yS1_ 	if href==2 & intyear<1993
	replace incjobs_yg=incj_yS2_	if href==2 & intyear>=1993
	
	recode incjobs_yg (9999999=.)
	
// 	lab var incjobs_yn "Individual Labor Earnings (All jobs, year, net)"
	lab var incjobs_yg "Individual Labor Earnings (All jobs, year, gross)"
// 	lab var incjobs_mn "Individual Labor Earnings (All jobs, month, net)"


* main job
/* NOTE:
Although some data cleaning is done below, some more exploration and cleanign is advised before using
The main reason is different time-scales used as reference after 1993 (and change of coding in 94-95)
*/
gen smHA=salary_mjHA*40*4.2  
gen smHB=.
	replace smHB = salary_mjHB/12 	if salary_mjHBper==1 & (intyear==1994|intyear==1995)
	replace smHB = salary_mjHB 		if salary_mjHBper==2 & (intyear==1994|intyear==1995)
	replace smHB = salary_mjHB*2.1 	if salary_mjHBper==3 & (intyear==1994|intyear==1995)
	replace smHB = salary_mjHB*4.2 	if salary_mjHBper==4 & (intyear==1994|intyear==1995)
	
	replace smHB = salary_mjHB*40*4.2  	if salary_mjHBper==1 & (intyear!=1994 & intyear!=1995)
	replace smHB = salary_mjHB*30.5  	if salary_mjHBper==2 & (intyear!=1994 & intyear!=1995)
	replace smHB = salary_mjHB*4.2 		if salary_mjHBper==3 & (intyear!=1994 & intyear!=1995)
	replace smHB = salary_mjHB*2.1 		if salary_mjHBper==4 & (intyear!=1994 & intyear!=1995)
	replace smHB = salary_mjHB	 		if salary_mjHBper==5 & (intyear!=1994 & intyear!=1995)
	replace smHB = salary_mjHB/12		if salary_mjHBper==6 & (intyear!=1994 & intyear!=1995)

	replace smHB = -1 if salary_mjHB==999998|salary_mjHB==999999|salary_mjHB==9999996|salary_mjHB==9999998|salary_mjHB==9999999
	
gen smSA=salary_mjSA*40*4.2  
gen smSB=.
	replace smSB = salary_mjSB/12 	if salary_mjSBper==1 & (intyear==1994|intyear==1995)
	replace smSB = salary_mjSB 		if salary_mjSBper==2 & (intyear==1994|intyear==1995)
	replace smSB = salary_mjSB*2.1 	if salary_mjSBper==3 & (intyear==1994|intyear==1995)
	replace smSB = salary_mjSB*4.2 	if salary_mjSBper==4 & (intyear==1994|intyear==1995)
	
	replace smSB = salary_mjSB*40*4.2  	if salary_mjSBper==1 & (intyear!=1994 & intyear!=1995)
	replace smSB = salary_mjSB*30.5  	if salary_mjSBper==2 & (intyear!=1994 & intyear!=1995)
	replace smSB = salary_mjSB*4.2 		if salary_mjSBper==3 & (intyear!=1994 & intyear!=1995)
	replace smSB = salary_mjSB*2.1 		if salary_mjSBper==4 & (intyear!=1994 & intyear!=1995)
	replace smSB = salary_mjSB	 		if salary_mjSBper==5 & (intyear!=1994 & intyear!=1995)
	replace smSB = salary_mjSB/12		if salary_mjSBper==6 & (intyear!=1994 & intyear!=1995)

	replace smSB = -1 if salary_mjSB==999998|salary_mjSB==999999|salary_mjSB==9999996|salary_mjSB==9999998|salary_mjSB==9999999|salary_mjSB==9.12e+07
	
gen 	incjob1_mg=.
	replace incjob1_mg=smHA  if href==1 & intyear>=1976 & intyear<1993
	replace incjob1_mg=smHB  if href==1 & intyear>=1993

	replace incjob1_mg=smSA  	if href==2 & intyear>=1976 &intyear<1993
	replace incjob1_mg=smSB 	if href==2 & intyear>=1993
	
	
// 	lab var incjob1_yg  "Salary from main job (year, gross)"
// 	lab var incjob1_yn  "Salary from main job (year, net)"
	lab var incjob1_mg "Salary from main job (month, gross)"
// 	lab var incjob1_mn "Salary from main job (month, net)"



* main job - per hour 
* NOTE: not data for 1993 (you can adjust incjob1_mg)

gen 	incjob1_hg=.
	replace incjob1_hg=incjob1_hH  if href==1  
	replace incjob1_hg=incjob1_hS  if href==2 
	recode incjob1_hg (99.99=-1)  
	recode incjob1_hg ( 9998/ 9999.999=-1)
	
	lab var incjob1_hg "Salary from main job (per hour, gross)"

	

*
**--------------------------------------
*   HH wealth
**--------------------------------------	
* hhinc_pre
* hhinc_post - //better indicator
/* NOTE: 
	- PSID provides values below zero (from 1994) - consider before using
*/

gen hhinc_post=hhinc_preALL
recode hhinc_post (9999998 9999999=-1)

 

//  	lab var hhinc_pre "HH income(month, pre)"	
	
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
 
 
recode srhR srhS  (8 9 0=-1), gen (srhRrev srhSrev)

gen srh5=.
	replace srh5=srhRrev  if  href==1
	replace srh5=srhSrev  if  href==2
	
	
	lab var srh5 "Self-rated health"
	lab def srh5 5 "Very bad" 4 "Bad" 3 "Satisfactory" 2 "Good" 1 "Very good"
	lab val srh5 srh5
	
**--------------------------------------
**  Disability 
**--------------------------------------
* disab
/*
H2. any physical or nervous condition that limits the type of work or the amount of work
	1. Yes 	
	5. No → GO TO H5A
 
	H3 . Does this condition keep   from doing some types of work?
		1. Yes 
		5. No 
		7. Can do nothing -> GO TO H5A  
 
		H4 . how much does it limit the amount of work 
			1. A lot 3. Somewhat 5. Just a little 7. Not at all (IF VOL)
H: 
- 68: 	 3a
- 72-76: 1+3a
- 77-85: 1+3b
- 86+:	 1+2+3b
S:
- 76: 	 1+3a
- 81-85: 1+3b
- 86+:	 1+2+3b


* General scheme: 
[H:68; S: NA] 1a
			disab3a  
			(1 2 3=1) 
			(4 5 7=0)

[H:72-76; S:76] 1+3a 
	disab1 
	1 go to disab3a	
	5 disab=0	
			disab3a  
			(1 2 3=1)
			(4 5 7=0)
			
[H:77-85; S:81-85] 1+3b 
	disab1 
	1 go to disab3b	
	5 disab=0		
			disab3b  
			(1 3 5=1) 
			(7=0)

[H/S:86+] 1+2+3b		
	disab1 
	1 go to disab2	
	5 disab=0
		disab2 [86+]
		1 go to disab3	
		5 go to disab3	
		7 disab=1			
			disab3  
			(1 3 5=1) 
			(7=0)
*/

*** disab
recode disab3H disab3S (1 2=1) (3 4 5 7=0) (9 0=-1) if intyear<1977 , gen(disab3Ha disab3Sa)
// 1	Yes, complete limitation; can't work at all
// 2	Yes, severe limitation on work
// 3	Yes, some limitation on work (must rest, mentions part-time work, occasional limit on work, can't lift heavy objects, reports periods of pain, sickness, etc.)
// 4	Yes, but no limitation on work
// 5	No
recode disab3H disab3S (1 3=1) (5 7=0) (8 9 0=-1) if intyear>=1977, gen(disab3Hb disab3Sb)
// 1	A lot
// 3	Somewhat
// 5	Just a little
// 7	Not at all
*
gen disab=.
	*
	replace disab=disab3Ha if href==1 & intyear==1968  
	*
	replace disab=0 		if href==1 & intyear>=1972 & intyear<1977 & disab1H==5
	replace disab=disab3Ha 	if href==1 & intyear>=1972 & intyear<1977 & disab1H!=5
	replace disab=0 		if href==2 & intyear==1976 & disab1S==5	
	replace disab=disab3Sa 	if href==2 & intyear==1976 & disab1S!=5
	*
	replace disab=0 		if href==1 & intyear>=1977 & intyear<1986 & disab1H==5
	replace disab=disab3Hb 	if href==1 & intyear>=1977 & intyear<1986 & disab1H!=5 
	replace disab=0 		if href==2 & intyear==1981 & intyear<1986 & disab1S==5	
	replace disab=disab3Sb 	if href==2 & intyear==1981 & intyear<1986 & disab1S!=5	
	*
	replace disab=0 		if href==1 & intyear>=1986 & disab1H==5
	replace disab=1			if href==1 & intyear>=1986 & disab2H==7 
	replace disab=disab3Hb 	if href==1 & intyear>=1986 & disab1H!=5 & disab2H!=7  
	replace disab=0 		if href==2 & intyear>=1986 & disab1S==5
	replace disab=1			if href==2 & intyear>=1986 & disab2S==7 
	replace disab=disab3Sb 	if href==2 & intyear>=1986 & disab1S!=5 & disab2S!=7 	
	*
	
*** disab2c
recode disab3H disab3S (1=1) (3 5 7=0) (8 9 0=-1)   if intyear>=1977, gen(disab3Hb2 disab3Sb2)
*
gen disab2c=.
	*
	replace disab2c=disab3Ha if href==1 & intyear==1968  
	*
	replace disab2c=0 			if href==1 & intyear>=1972 & intyear<1977 & disab1H==5
	replace disab2c=disab3Ha 	if href==1 & intyear>=1972 & intyear<1977 & disab1H!=5
	replace disab2c=0 			if href==2 & intyear==1976 & disab1S==5	
	replace disab2c=disab3Sa 	if href==2 & intyear==1976 & disab1S!=5
	*
	replace disab2c=0 			if href==1 & intyear>=1977 & intyear<1986 & disab1H==5
	replace disab2c=disab3Hb2 	if href==1 & intyear>=1977 & intyear<1986 & disab1H!=5 
	replace disab2c=0 			if href==2 & intyear==1981 & intyear<1986 & disab1S==5	
	replace disab2c=disab3Sb2 	if href==2 & intyear==1981 & intyear<1986 & disab1S!=5	
	*
	replace disab2c=0 			if href==1 & intyear>=1986 & disab1H==5
	replace disab2c=1			if href==1 & intyear>=1986 & disab2H==7 
	replace disab2c=disab3Hb2 	if href==1 & intyear>=1986 & disab1H!=5 & disab2H!=7  
	replace disab2c=0 			if href==2 & intyear>=1986 & disab1S==5
	replace disab2c=1			if href==2 & intyear>=1986 & disab2S==7 
	replace disab2c=disab3Sb2 	if href==2 & intyear>=1986 & disab1S!=5 & disab2S!=7 	
	*
	

	lab var disab	"Disability (any)"
	lab var disab2c "Disability (min. category 2 or >30%)"
	lab val disab   yesno
	
**--------------------------------------
**  Chronic diseases
**--------------------------------------
* chron
// There is a list of diseases to pick from in H5 (2017 quest) - please specify 
// depending on research questions 


// 	lab var chron	"Chronic diseases"
// 	lab val chron   yesno
	
	
*################################
*#								#
*#	Subjective wellbeing		#
*#								#
*################################
**--------------------------------------  %%%%%% COMPARE m11125 p11101
**   Satisfaction with  
**--------------------------------------
* sat_life sat_work sat_fam sat_finhh sat_finind sat_hlth

//NOTE:  sat_life only from 2009+

rename sat_life sat_lifeR

	lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" 	///
				 4  "4 Mostly sat" 5 "5 Completely sat"						///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 		///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
 

	lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	 
 
* Recode   5-point into 10-point versions (and reverse)
 tokenize "sat_lifeR"
	 foreach var in satlife  {
		 recode  `1' (1=5) (2=4) (3=3) (4=2) (5=1) (8 9=-1) (0=-3), gen(`var'5)
		 recode  `1' (1=10) (2=7) (3=5) (4=3) (5=0)(8 9=-1) (0=-3), gen(`var'10)
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

// NOTE: poor indicators for last 12 months

// 	lab val train yesno
// 	lab var train "Training (previous year)"

**--------------------------------------
**   work-edu link NA
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
**   Job security NA
**--------------------------------------
*  

// 	lab def jsecu 	 0 "0 Insecure" 1 "1 Secure"  ///
// 					-1 "-1 MV general" -2 "-2 Item non-response" ///
// 					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab def jsecu2 	 0 "0 Insecure" 1 "1 Secure" 2 "Hard to say" ///
// 					-1 "-1 MV general" -2 "-2 Item non-response" ///
// 					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab var jsecu "Job security [2]"
// 	lab var jsecu2 "Job security [3]"
//
// 	lab val jsecu jsecu
// 	lab val jsecu2 jsecu2
	
**|=========================================================================|
**|  SES Indices
**|=========================================================================|	

**--------------------------------------
**   Occupational status (ISEI)
**--------------------------------------
* isei 
 iscogen isei08 = isei(isco08_4) , from(isco08)

	lab var isei08 "ISEI-08: International Socio-Economic Index of occupational status"

iscogen isei88 = isei(isco88_4), from(isco88)
	lab var isei88 "ISEI-88: International Socio-Economic Index of occupational status"
	
*  -specific scale provided by  
// p__6615 - current perceived economic status
 
	
	
**--------------------------------------
**   Treiman's international prestige scale (SIOPS) 
**--------------------------------------
iscogen siops08 = siops(isco08_4), from(isco08)
 	lab var siops08 "SIOPS-08: Treiman's international prestige scale" 
	
iscogen siops88 = siops(isco88_4) , from(isco88)
	lab var siops88 "SIOPS-88: Treiman's international prestige scale" 
**--------------------------------------
*** MPS (German Magnitude Prestige Scale; Christoph 2005)
**--------------------------------------	
iscogen mps88 = mps(isco88_4), from (isco88)
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

// 1	Completed 0-5 grades
// 2	Completed 6-8 grades; "grade school"; DK but mentions could read and write
// 3	Completed 9-11 grades (some high school); junior high

// 4	Completed 12 grades (completed high school); "high school"
// 5	Completed 12 grades plus nonacademic training; R.N. (no further elaboration)
// 6	Completed 13-14 years; Some college, no degree; Associate's degree

// 7	Completed 15-16 years; College BA and no advanced degree mentioned; normal school; R.N. with 3 years college; "college"
// 8	Completed 17 or more years; College, advanced or professional degree, some graduate work; close to receiving degree

// 9	NA; DK to both M20 and M21
// 99	DK; NA; refused
// 0	Inap.

*edu3
recode feduH feduS (1/3=1)(4/6=2)(7/8=3) (9 12 99=-1)(0=-3), gen(feduH3 feduS3)
gen fedu3=feduH3 if  href==1
replace fedu3=feduS3 if  href==2

	lab val fedu3 edu3
	lab var fedu3 "Father's education: 3 levels"


* edu4
recode feduH feduS (1/2=1)(3=2)(4/6=3)(7/8=4) (9 12 99=-1)(0=-3), gen(feduH4 feduS4)
gen fedu4=feduH4 if  href==1
replace fedu4=feduS4 if  href==2

	lab val fedu4 edu4
	lab var fedu4 "Father's education: 4 levels"
	

*** Mother 
*edu3
recode meduH meduS (1/3=1)(4/6=2)(7/8=3) (9 12 99=-1)(0=-3), gen(meduH3 meduS3)
gen medu3=meduH3 if  href==1
replace medu3=meduS3 if  href==2

	lab val medu3 edu3
	lab var medu3 "Mother's education: 3 levels"

	
* edu4
recode meduH meduS (1/3=1)(4/6=2)(7/8=3) (9 12 99=-1)(0=-3), gen(meduH4 meduS4)
gen medu4=meduH4 if  href==1
replace medu4=meduS4 if  href==2

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
*#	Ethnicity					#
*#								#
*################################	

**----------------------
**   ethnicity
**----------------------

label define ethnicity ///
1 "Black" ///
2 "white" ///
3 "Asian" ///
4 "Mixed (UK only)" ///
5 "American Indian (US only)" ///
6 "Other" ///
-1 "MV General"

gen temp_ethn=.
	replace temp_ethn=race_H if href==1
	replace temp_ethn=race_S if href==2
	
recode temp_ethn (1=2) /// White
				(2=1) ///Black
				(3=5) /// Native American
				(4=3) ///Asian, Pacific Islander
				(5=6) /// Latino origin (hispanic)
				(6=6) /// color besides black or white
				(7=6) /// Other
				(9=-1) /// NA/DK
				, gen(ethn)

drop temp*
label val ethn ethnicity

*fill MV
	bysort pid: egen temp_ethn=mode(ethn), maxmode // identify most common response
	replace ethn=temp_ethn if ethn==. & temp_ethn>=0 & temp_ethn<.
	replace ethn=temp_ethn if ethn!=temp_ethn // correct inconsistent cases

	
**--------------------------------
**   Hispanicity (US only)
**--------------------------------
label define ethn_hisp ///
0 "Not Hispanic" ///
1 "Hispanic" ///
-1 "MV general"

gen ethn_hisp=.
replace ethn_hisp=1 if inrange(hispanic_H, 1, 7) & href==1 //yes hispanic (head)
replace ethn_hisp=1 if inrange(hispanic_S, 1, 7) & href==2 //yes hispanic (spouse)
replace ethn_hisp=0 if hispanic_H==0 & href==1 //no (head)
replace ethn_hisp=0 if hispanic_S==0 & href==2 //no (spouse)
replace ethn_hisp=-1 if hispanic_H==9 & href==1 //DK/refusal (head)
replace ethn_hisp=-1 if hispanic_S==9 & href==2 // DK/refusal (spouse)

*fill MV based on country_born&subsample
//NOTE: assumption that all individuals from Latino subsample / born in countries defined as Hispanic are automatically of Hispanic descent
replace ethn_hisp=1 if (ethn_hisp==. | ethn_hisp==-1) & country_born==300 //Cuba
replace ethn_hisp=1 if (ethn_hisp==. | ethn_hisp==-1) & country_born==595 //Mexico
replace ethn_hisp=1 if (ethn_hisp==. | ethn_hisp==-1) & country_born==745 //Puerto Rico
replace ethn_hisp=1 if (ethn_hisp==. | ethn_hisp==-1) & country_born==830 //Spain
replace ethn_hisp=1 if (ethn_hisp==. | ethn_hisp==-1) & inrange(ER30001, 7001, 9308) // Latino subsample


*copy values across years for each respondent
	bysort pid: egen temp_hisp=mode(ethn_hisp), maxmode // identify most common response
	replace ethn_hisp=temp_hisp if ethn_hisp==. & temp_hisp>=0 & temp_hisp<.
	replace ethn_hisp=temp_hisp if ethn_hisp!=temp_hisp // correct a few inconsistent cases

label values ethn_hisp ethn_hisp
drop temp*




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
-8 "Question not asked in survey" ///
.a "[.a] missing: grewup_US available"

gen temp_migr=.
	replace temp_migr=state_H if href==1 // Head 2013 onwards
	replace temp_migr=state_S if href==2 //Spouse 2013 onwards
	replace temp_migr=state_born if temp_migr==. // Head/Spouse before 2000
	
	*redefine missing values, 0-value different for 97 and 99:
	replace temp_migr=-8 if temp_migr==0 & wavey<=2000 // if 0 before 2000 then question not asked

	
//because state born only asked consistently since 2013, first fill MV by pid
	mvdecode temp_migr, mv(-8=.a \ 99=.b)
	
	bysort pid: egen temp_state_MV=mode(temp_migr), maxmode // identify most common response
	replace temp_migr=temp_state_MV if temp_migr==. & temp_state_MV>=0 & temp_state_MV<.
	replace temp_migr=temp_state_MV if temp_migr!=temp_state_MV // correct inconsistent cases	
	
	mvencode temp_migr, mv(.a=-8 \ .b=99)


gen migr=.
	replace migr=0 if inrange(temp_migr, 1, 56) // born in US state
	replace migr=1 if temp_migr==0 // no state info because foreign-born (only after 2013)
	replace migr=-8 if temp_migr==-8 // not asked (before 2000)
	
	replace migr=1 if inrange(country_born, 100, 990) // born outside of US
	
	replace migr=-1 if migr==. & (temp_migr==99 & country_born==.)  // DK NA for state
	replace migr=-1 if migr==. & (country_born==999 & temp_migr==.) //DK NA for country
	replace migr=-8 if migr==. & (temp_migr==. & country_born==0) //State info missing, country not asked

*fill for subsamples
replace migr=1 if (migr==. | migr<0) & inrange(ER30001, 3001, 3511) // new immigrant sample 1997 & 1999
replace migr=1 if (migr==. | migr<0) & inrange(ER30001, 4001, 4851) // NIS 2017
replace migr=1 if (migr==. | migr<0) & inrange(ER30001, 7001, 9308) // Latino subsample


*fill MV 
	mvdecode migr, mv(-8=.a \ -1=.b)

	bysort pid: egen temp_migr_MV=mode(migr), maxmode // identify most common response
	replace migr=temp_migr_MV if migr==. & temp_migr_MV>=0 & temp_migr_MV<.
	replace migr=temp_migr_MV if migr!=temp_migr_MV & temp_migr_MV>=0 // correct a few inconsistent cases	
	
	mvencode migr, mv(.a=-8 \ .b=-1)
	
	replace migr=-8 if migr==. & wavey<1997 //Question not asked before 1997

//NOTE: some missing information corrected after specification cob (see below)

drop temp*
lab val migr migr

**-------------------
**   COB respondent
**-------------------	
/// NOTE: with addition new waves, check if new countries are added to codebook

// generate working var
gen temp_cob=.
	replace temp_cob=country_born // country specified only if foreign-born
	replace temp_cob=.a if country_born==0 // no country specified: question not asked (temporary placeholder)
	replace temp_cob=.b if ((temp_cob==. | temp_cob==.a) & migr==1) // no country specified but respondent foreign-born (temporary placeholder)
	
*fill MV
	bysort pid: egen mode_temp_cob=mode(temp_cob), maxmode // identify most common response
	replace temp_cob=mode_temp_cob if (temp_cob==. | temp_cob==.a | temp_cob==.b) & mode_temp_cob>=0 & mode_temp_cob<.
	replace temp_cob=mode_temp_cob if temp_cob!=mode_temp_cob // correct inconsistent cases

// COB labels in separate file	
do "${your_dir}\11_CPF_in_syntax\03_PSID\us_02add_labels_COB.do"

*** Identify valid COB and fill across waves  
sort pid wave 

*** Generate valid stage 1 - mode across the waves (values 1-10)
	// It takes the value of the most common valid answer between 1 and 10 
	// If there is an equal number of 2 or more answers, it returns "." - filled in next steps
	
		bysort pid: egen mode_cob_rt=mode(cob_rt)
	
*** Generate valid stage 2 - first valid answer provided (values 1-9)
	// It takes the value of the first recorded answer between 1 and 9 (so ignors 10 "other")
	// These are used to fill COB in cases: 
	//	(a) equal number of 2 or more answers (remaining MV)
	//	(b) there is a valid answer other than 10 but the mode (stage 1) returns 10
	
	by pid (wave), sort: gen temp_first_cob_rt=cob_rt if ///
			sum(inrange(cob_rt, 0,9)) == 1 &      ///
			sum(inrange(cob_rt[_n - 1],0,9)) == 0 // identidy 1st valid answer in range 1-9
	bysort pid: egen first_cob_rt=max(temp_first_cob_rt) // copy across waves within pid
	drop  temp_first_cob_rt
	
	
*** Fill the valid COB across waves
	gen cob_r = mode_cob_rt // stage 1 - based on mode
	replace cob_r = first_cob_rt if (cob_r==. | cob_r==.a | cob_r==.b) ///
		& inrange(first_cob_rt, 0,10) // stage 2 - based on the first for MV
	replace cob_r = first_cob_rt if cob_r==10 & inrange(first_cob_rt, 1,9) // stage 2 - based on the first for 10'other'
	drop cob_rt
	*
	
	mvencode cob_r, mv(.a=-8)
	label values cob_r COB
	rename cob_r cob
	

	
*** correct some migr-values now that cob is filled
replace migr=1 if inrange(cob, 1, 10) & (migr<0 | migr==.)

	*specify missings cob
	replace cob=-8 if cob==. & migr==-8
	replace cob=-1 if cob==. & migr==-1



//Note: detailed information COB father and mother not available

**----------------------------------------------
**   Region Grew Up (US-only)
**----------------------------------------------	
//NOTE: this variable is not used for harmonization. It specifies whether respondent grew up in the US or not. 
//The variable can be used  to fill the gaps where information on country of birth is incomplete (see codebook for further explanation). 

lab def grewup ///
0 "Grew up in US State" ///
1 "Grew up outside US" ///
-1 "MV general (DK/NA)" ///

gen temp_grewup=.
	replace temp_grewup=grewup_H if href==1 // Head/RP
	replace temp_grewup=grewup_S if href==2 // Spouse/partner

gen grewup_US=. 
replace grewup_US=0 if inrange(temp_grewup, 1, 5) // US region, including Alaska and Hawaii but excluding US territories
replace grewup_US=1 if temp_grewup==6 // foreign country
replace grewup_US=-1 if (temp_grewup==9 | temp_grewup==0) //NA

**CHECK
*fill MV
	bysort pid: egen temp_grewup_MV=mode(grewup_US), maxmode // identify most common response
	replace grewup_US=temp_grewup_MV if grewup_US==. & temp_grewup_MV>=0 & temp_grewup_MV<9
	replace grewup_US=temp_grewup_MV if grewup_US!=temp_grewup_MV // correct a few inconsistent cases	
	
lab val grewup_US grewup
	
drop temp*

replace cob=.a if cob==. & (grewup_US>=0)
replace migr=.a if migr==. & (grewup_US>=0)

	
**----------------------------------------------
**   Migration Background (parents foreign-born)
**----------------------------------------------	
//Note: no detailed information on country of birth parents available, only if foreign-born yes/no 

gen temp_migr_f=.
	replace temp_migr_f=cob_f_H if href==1 // father of head/ref
	replace temp_migr_f=cob_f_S if href==2 // father of spouse
gen temp_migr_m=.
	replace temp_migr_m=cob_m_H if href==1 // mother of head/ref
	replace temp_migr_m=cob_m_S if href==2 // mother of spouse

gen migr_f=.
	replace migr_f=0 if inrange(temp_migr_f, 1, 90) // born in US state
	replace migr_f=1 if temp_migr_f==0 // born in foreign country or US territory
	replace migr_f=-1 if temp_migr_f==99 // DK NA Refused

gen migr_m=.
	replace migr_m=0 if inrange(temp_migr_m, 1, 90) // born in US state
	replace migr_m=1 if temp_migr_m==0 // born in foreign country or US territory
	replace migr_m=-1 if temp_migr_m==99 // DK NA Refused


*fill MV
	bysort pid: egen migr_f_MV=mode(migr_f), maxmode // identify most common response
	replace migr_f=migr_f_MV if migr_f==. & migr_f_MV>=0 & migr_f_MV<.
	replace migr_f=migr_f_MV if migr_f!=migr_f_MV // correct a few inconsistent cases

	bysort pid: egen migr_m_MV=mode(migr_m), maxmode // identify most common response
	replace migr_m=migr_m_MV if migr_m==. & migr_m_MV>=0 & migr_m_MV<.
	replace migr_m=migr_m_MV if migr_m!=migr_m_MV // correct a few inconsistent cases
	
*question not asked before 97
	foreach var in migr_f migr_m {
		replace `var'=-8 if `var'==. & wavey<1997
	}

	drop temp* migr_m_MV migr_f_MV
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
	 ((migr_f==0 & (migr_m==. | migr_m<0)) | ((migr_f==.| migr_f<0) & migr_m==0)) // respondent native-born, one parent native other unknown
replace migr_gen=0 if migr==1 & (migr_f==0 & migr_m==0) // respondent foreign-born but both parents native

* 1 "1st generation"
replace migr_gen=1 if migr==1 & (migr_f==1 & migr_m==1) // respondent and both parents foreign-born
replace migr_gen=1 if migr==1 & ///
	((migr_f==1 & (migr_m==. | migr_m<0)) | (migr_m==1 & (migr_f==. | migr_f<0))) // respondent, one parent foreign-born other  unknown
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
replace migr_gen=4 if migr==0 & ((migr_f<0 | migr_f==.) & (migr_m<0 | migr_m==.)) // respondent native-born, both parents unknown
replace migr_gen=4 if migr==1 & ((migr_f<0 | migr_f==.) & (migr_m<0 | migr_m==.)) // respondent foreign-born, both parents unknown
replace migr_gen=4 if migr==1 & ///
	 ((migr_f==0 & (migr_m==. | migr_m<0)) | ((migr_f==. | migr_f<0) & migr_m==0)) // respondent native-born, one parent native other unknown

	label values migr_gen migr_gen

//NOTE: if respondent is foreign-born but no information is available for parents, migr_gen is coded as missing.

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


// recode var to account for change in coding

foreach var in lcB_H lcB_S {
    recode `var' (1=1) /// English
			(2/97=5) /// other non-English
			(98=8) ///DK
			(99=9) /// NA/Refusal
			(0=0), /// Inap.
	gen(re_`var')
}

//fill for head and spouse
gen temp_lc=.
	replace temp_lc=lcA_H if href==1 & intyear<=2000 // head before 2000
	replace temp_lc=re_lcB_H if href==1 & intyear>2000 // head after 2000
	replace temp_lc=lcA_S if href==2 & intyear<=2000 //spouse before 2000
	replace temp_lc=re_lcB_S if href==2 & intyear>2000


gen langchild =. // working variable for langchild
replace langchild=0 if temp_lc==1 //English
replace langchild=1 if temp_lc==5 //other
replace langchild=-1 if (temp_lc==8 | temp_lc==9)



*fill MV
	bysort pid: egen temp_lc_MV=mode(langchild), maxmode // identify most common response
	replace langchild=temp_lc_MV if langchild==. & temp_lc_MV>=0 & temp_lc_MV<.
	replace langchild=temp_lc_MV if langchild!=temp_lc_MV // correct a few inconsistent cases
	
*specify when question not asked and cannot be filled using data from other years:
replace langchild=-8 if langchild==. & !inlist(wavey, 1997, 1999, 2017, 2019)
*question not asked of core sample:
replace langchild=-8 if langchild==. & (inrange(ER30001, 1, 2930) | inrange(ER30001, 5001, 6872))
	
	drop temp*
	
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
//It is important to note however that information is sometimes brought forward from previous waves in the PSID data. For further information on this, please refer to the psid codebook.

lab def relig ///
0 "Not religious/Atheist/Agnostic" ///
1 "Religious" ///
-1 "MV general" ///
-8 "Question not asked in survey"

gen rel_pref=.
replace rel_pref=rel_pref_H1 if href==1 & (wavey<=1975 | inrange(wavey, 1977, 1984)) // Head, protestantism only
replace rel_pref=rel_pref_H2 if href==1 & (wavey==1976 | wavey>=1985) // Head
replace rel_pref=rel_pref_S if href==2 & (wavey==1976 | wavey>=1985) // Spouse

*coding 1976
recode rel_pref (0=0) (1/9=1) (else=.), gen(temp_rel_A)

*coding 1985-2019
recode rel_pref (0=0) (1/35=1) (97=1) (98/99=-1) (else=.), gen(temp_rel_B)

*coding 1970-1975 & 1977-1984
recode rel_pref (1/9=1) (else=.), gen(temp_rel_C)
//Note: for the years 1970-1975 and 1977-1985 information is only available for the head, and only considers those who belong to protestant denominations

gen relig=.
replace relig=temp_rel_A if wavey==1976
replace relig=temp_rel_B if wavey>=1985
replace relig=temp_rel_C if inrange(wavey, 1970, 1975)
replace relig=temp_rel_C if inrange(wavey, 1977, 1984)

*fill MV: 
*#1.question not asked before 1970
replace relig=-8 if wavey<1970

*#2 question not asked of spouse in all waves
replace relig=-8 if (inrange(wavey, 1970, 1975) | inrange(wavey, 1977, 1984)) & href==2

lab val relig relig
drop temp*

**--------------------------------------  
** Attendance
**--------------------------------------
lab def attendance ///
1 "never or practically never" ///
2 "less than once a month" ///
3 "at least once a month" ///
4 "once a week or more" ///
-1 "MV general" ///
-8 "question not asked in survey"

gen temp_att=.
replace temp_att=rel_att1 if inrange(wavey, 1968, 1972)
replace temp_att=rel_att2_H if wavey>=2000 & href==1 // Head after 2000
replace temp_att=rel_att2_S if wavey>=2000 & href==2 // Spouse after 2000

*coding 1968
recode temp_att (0=1) (1=2) (2/3=3) (4/5=4) (9=-1) (else=.), gen(att_A) //68

*coding 1969
recode temp_att (0/1=1) (2=2) (3=3) (4/5=4) (9=-1) (else=.), gen(att_B) //69

*coding 1970-1972
recode temp_att (0=1) (1=4) (2=3) (3=2) (9=-1) (else=.), gen(att_C) //70, 71, 72

*coding 2003<
//NOTE: from 2003 onwards, respondents are asked to estimate the total number of times they attended religious in the previous year
recode temp_att (0=1) (1/11=2) (12/51=3) (52/97=4) (98/99=-1) (else=.), gen(att_D) //2003 onwards

gen relig_att=.
replace relig_att=att_A if wavey==1968
replace relig_att=att_B if wavey==1969
replace relig_att=att_C if inrange(wavey, 1970, 1972)
replace relig_att=att_D if wavey>=2000

*fill when question not asked
replace relig_att=-8 if inrange(wavey, 1973, 2002)
replace relig_att=-8 if wavey==2007
replace relig_att=-8 if wavey==2009
replace relig_att=-8 if wavey==2013
replace relig_att=-8 if wavey==2015

lab val relig_att attendance
drop temp*


*################################
*#								#
*#	Weights						#
*#								#
*################################	 
**--------------------------------------
**   Cross-sectional sample weight
**--------------------------------------	
* NOTE: not c-s weight for 1996
gen wtcs1=w_indAcore  if wavey<=1992
gen wtcs2=w_indCcomb  if wavey>=1993 & wavey<=1995
// 1996?
gen wtcs3=w_indDcross if wavey>=1996
 
  gen wtcs=.
  replace wtcs=wtcs1 if wavey<=1992
  replace wtcs=wtcs2 if wavey>=1993 & wavey<=1995
  replace wtcs=wtcs3 if wavey>=1996
  
**--------------------------------------
**   Cross-sectional population weight
**--------------------------------------	

// gen wtcp=  					// c-s weight  

 

 

**--------------------------------------
**   Longitudinal Weight
**--------------------------------------		 
	
**--------------------------------------
**   Sample identifier 
**-------------------------------------- 

recode ER30001 (1/2930=1)(3001/3511=2)(4001/4851=3)(5001/6872=4)(7001/9308=5), gen(sampid_psid)

lab var sampid_psid "Sample identifier: PSID"

lab def sampid_psid	///
	1 "1968 SRC cross-section sample"	///
	2 "Immigrant sample 1997 and 1999"	///
	3 "Immigrant sample 2017 and 2019"	///
	4 "1968 Census sample"	///
	5 "Latino sample 1990 and 1992" 	 

 

lab val sampid_psid sampid_psid
 

**|=========================================================================|
**|  KEEP
**|=========================================================================|
keep	///
wave pid intyear  age yborn	///
refer who_resp intmonth isresp href ///
female eduy edu3 edu4 edu5  nphh	///
work_d emplst5 emplst6	///
isco* indust1 indust2 indust3	///
public size size4 size5 size5b	///
whyear whweek whmonth fptime_h un_act selfemp entrep2	///
retf*  expft exp exporg neverw	///
incjobs_yg incjob1_mg incjob1_hg hhinc_post	///
srh5 disab disab2c 	///
w_ind*   xsqnr	///
wavey country wave1st   marstat5 mlstat5 	///
livpart parstat6 nvmarr kidsn_hh17 satlife5 satlife10	///
divor separ widow	///
isei* siops* wtcs* mps* nempl fedu3 fedu4 medu3 medu4 sampid* ///
migr* ethn* cob grewup_US   relig*

order pid wave intyear   age female  , first
order isresp href who_resp refer xsqnr w_ind*  sampid*, last

 
**|=========================================================================|
**|  SAVE
**|=========================================================================|
label data "CPF_USA v1.5"

save "${psid_out}\us_02_CPF.dta", replace  	

	 
*____________________________________________________________________________
*--->	END	 <---











