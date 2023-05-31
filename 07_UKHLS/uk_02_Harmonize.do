*
**|=============================================|
**|	    ####	CPF v1.5	####				|
**|		>>>	UK							 		|
**|		>>	Select vars , create new vars 		|
**|---------------------------------------------|
**|		Konrad Turek 	| 	2023				|
**|=============================================|
* https://www.understandingsociety.ac.uk/documentation/mainstage/dataset-documentation

**--------------------------------------
** Open merged dataset
**-------------------------------------- 
/*
clear
set maxvar 10000
*/

use "${ukhls_out}\uk_01.dta", clear
*
qui tab wave
display _newline(1) "   Total ->> Vars: " c(k) "; N: " _N "; Waves: " r(r)  


**--------------------------------------
** Common labels 
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

// rename   pid
// rename   wave
clonevar intyear=istrtdaty  
replace intyear=intdaty_dv if intdaty_dv>0 & intdaty_dv<.  
replace intyear=1991 if intyear==. & wave==1
	lab var intyear "Interview: year"

clonevar intmonth=istrtdatm	
replace intmonth=intdatm_dv if intdatm_dv>0 & intdatm_dv<.  
recode intmonth (-9=-1)
	lab var intmonth "Interview: month"
*
rename country country_resid
gen country=7
sort pid wave
	
*** wavey 
* NOTE:
* - multi-year waves in UK, better to use wave and intyear
* - for multi-year waves wavey indicates the 1st year of data collection

bysort wave: egen wavey=min(intyear)

*** Repsondent status 
recode ivfio (1=1) (2 3=2), gen(respstat)
	lab def respstat 	1 "Interviewed" 					///
						2 "Not interviewed (has values)" 	///
						3 "Not interviewed (no values)"
	lab val respstat respstat
	
*** First wave (DECIDE: define 1st interv | 1st enter sample (proxy included)) 
// bysort pid: egen wave1st = min(cond(ivfio == 1, wave, .))
// bysort pid: egen wave1stB = min(cond((ivfio==1|ivfio==2), wave, .))
	
	
*################################
*#								#
*#	Socio-demographic basic 	#
*#								#
*################################
**--------------------------------------
** Demographic
**--------------------------------------
sort pid wave

* age
//recode age_dv (-9=-1), gen(age)

capture gen age=age_dv
replace age=age_dv if wave!=1 //exception made for wave 1 because birthy and age_dv variable not available
replace age=-1 if age_dv==-9  

	lab var age "Age" 

* Birth year
recode birthy (-9/-1=-1), gen(yborn)
replace yborn=doby_dv if (birthy==. | birthy<0) & doby_dv!=.
	lab var yborn "Birth year" 

		
	* Fill yborn if missing	(cross-filling)
		replace yborn=intyear-age if (yborn<0|yborn==.) & age>0 & age<.
		
	* Correct yborn if not consistent values of yborn across weaves
		bysort pid: egen temp_min=min(yborn)
		bysort pid: egen temp_max=max(yborn)
		gen temp_check=temp_max-temp_min if temp_max>0 & temp_max<. & temp_min>0 & temp_min<.
		replace temp_check=999 if temp_min==-1 & temp_max>0 
		// 			bro pid intyear age yborn  temp_min temp_max temp_check if temp_check>0 & temp_check<.
		bysort pid: egen temp_yborn=mode(yborn) if temp_check>0 & temp_check<., maxmode
		bysort pid: egen temp_yborn_max=max(yborn) if temp_check>0 & temp_check<. 
		replace temp_yborn=temp_yborn_max if temp_yborn==-1 & temp_yborn_max>0 & temp_yborn_max<.
		// 			bro pid intyear age yborn temp_yborn temp_min temp_max temp_check if  temp_check>0 & temp_check<.
				
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
	

/***** Identify resp with repeated age - however, it's possible in the survey design 

	bysort pid (wave): gen temp_mark1a=1 if age>=age[_n+1] & age[_n+1]<.
	bysort pid (wave): gen temp_mark1b=1 if age<=age[_n-1] & age[_n-1]<.

	bysort pid: egen temp_mark2a=max(temp_mark1a)
	bysort pid: egen temp_mark2b=max(temp_mark1b)
	gen temp_mark2=temp_mark2a
	replace temp_mark2=temp_mark2b if temp_mark2a==. & temp_mark2b==1
	
			bro pid intyear     age  	 yborn    temp_mark1* temp_mark2 if temp_mark2>0 & temp_mark2<.

	gen temp_age=age		
	replace temp_age = intyear-yborn  if	temp_mark2==1
				bro pid intyear     age temp_age	 yborn    temp_mark1 temp_mark2 if temp_mark2>0 & temp_mark2<.

	drop temp*
*/

	
		
* Gender
recode sex (-9/-1=-1) (1=0) (2=1), gen(female)
replace female=0 if sex<0 & hgsex==1
replace female=1 if sex<0 & hgsex==2

	* Gender is treated as time-constant, thus inconsisten entries are corrected
	bys pid: egen temp=sd(female) if pid>=0 & pid<. // searching gender within-changes
	bys pid: egen temp2=mode(female) if temp>0 & temp<., missing maxmode // take within-mode
	replace female=temp2 if temp2==0 | temp2==1	// correct 
		drop temp*
		
	lab def female 0 "Male" 1 "Female" 
	lab val female female 
	lab var female "Gender" 
	
	
**--------------------------------------
** Place of living (e.g. size/rural)
**--------------------------------------
* place
recode urban_dv (-9=-1), gen(place)
 	lab var place "Place of living"
	lab def place 1 "city" 2 "rural area"
	lab val place place 

*################################
*#								#
*#	Education					#
*#								#
*################################
**--------------------------------------  
** Education  
**--------------------------------------
* eduy NA

// lab var eduy "Education: years"

*** edu3
// ====
// isced // main 1-18
// qfhigh_dv // main for 19+ 
// ====
// qfhighoth (isced11_dv) // special samples  w 24, 27 (outside UK)
// ====
// other:
// isced   casmin // 1-18
// edasp  feend scend school // 1-27 other  
// edtype // every 2nd (now attending) 
//
// qfedhi //1-18
 

	
recode isced (1 2 =1) (3 4=2) (5/7=3) (0 -7=-1) , gen(edu3a) // for waves 1-18
recode qfhigh_dv (14 15 96=1) (7/13 16=2) (1/6=3) (-9=-1) (-8=-3), gen(edu3b) // for waves 19+ 
recode qfhighoth (10 96=1) (5/9=2) (1/4=3), gen(edu3c) // special sample w 24, 27
 
gen edu3=edu3a
replace edu3=edu3b if wave>=19
replace edu3=edu3c if  (edu3<0 | edu3==.) & edu3c>0 & edu3c<.

	drop edu3a edu3b edu3c

	lab def edu3  1 "[0-2] Low" 2 "[3-4] Medium" 3 "[5-8] High" // 2 incl Vocational
	lab val edu3 edu3
	lab var edu3 "Education: 3 levels"



*** edu4
recode isced (1=1) (2=2) (3 4=3) (5/7=4)  (0 -7=-1), gen(edu4a) // for waves 1-18
recode qfhigh_dv (15 96=1) (14=2) (7/13 16=3) (1/6=4) (-9=-1) (-8=-3), gen(edu4b) // for waves 19+ 
recode qfhighoth (10 96=1)   (5/9=3) (1/4=4), gen(edu4c) // special sample w 24, 27

gen edu4=edu4a
replace edu4=edu4b if wave>=19
replace edu4=edu4c if  (edu4<0 | edu4==.) & edu4c>0 & edu4c<.

	drop edu4a edu4b edu4c

	lab def edu4  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" 4 "[5-8] Tertiary" 
	lab val edu4 edu4
	lab var edu4 "Education: 4 levels"
	
*** edu5
recode isced (1=1) (2=2) (3 4=3) (5 6=4) (7=5) (0 -7=-1), gen(edu5a) // for waves 1-18
recode qfhigh_dv (15 96=1) (14=2) (7/13 16=3) (4/6=4) (1 2=5) (-9=-1) (-8=-3), gen(edu5b) // for waves 19+ 
recode qfhighoth (10 96=1)   (5/9=3) (3 4=4) (1 2=5), gen(edu5c) // special sample w 24, 27

gen edu5=edu5a
replace edu5=edu5b if wave>=19
replace edu5=edu5c if  (edu5<0 | edu5==.) & edu5c>0 & edu5c<.

	drop edu5a edu5b edu5c
	
	lab def edu5  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				  3 "[3-4] Secondary upper" ///
				  4 "[5-6] Tertiary lower(bachelore)"  ///
				  5 "[7-8] Tertiary upper (master/doctoral)"
				  
	lab val edu5 edu5
	lab var edu5 "Education: 5 levels"




*** Fill MV in edu* 
* Fill MV if info avaliable in previous waves (if age>30)
sort pid wave
foreach n in 3 4 5 {
	gen temp_edu`n'=edu`n'
	gen temp1=1 if edu`n'==-3
	by pid: egen temp2=min(temp1)
			// 	bro pid wave age edu3 qfhigh_dv   if temp2==1
	bysort pid (wave): replace  temp_edu`n'=temp_edu`n'[_n-1] if temp_edu`n'==-3 /// fill only when -3 
					& temp_edu`n'[_n-1]>0 & temp_edu`n'[_n-1]<. 				/// if has values
					& age>30 & age[_n-1]>=30				// only for individuals who have most likely finished education  		
	gen imp_edu`n'=1 if temp_edu`n'!=edu`n'
	by pid: egen temp4=max(imp_edu`n')
	// bro pid wave age qfhigh_dv edu3 temp_ed1 temp3 temp4 if temp4==1
	replace edu`n'=temp_edu`n' if temp_edu`n'!=edu`n' & temp_edu`n'>0
	lab var imp_edu`n' "Edu imputed based on previous waves"
	drop temp*
}
drop imp_edu4 imp_edu5
rename imp_edu3 imp_edu
	
	
	
*################################
*#								#
*#	Family and relationships	#
*#								#
*################################	

		
		
**--------------------------------------
** Formal marital status 	 
**--------------------------------------
* Formal marital status
* Only formal marital status included, no info on having/living with partner
* Never married include singles  

// mastat mlstat_bh //1-18
// marstat marstat_dv mastat_dv // 19+ --> CNEF: mastat_dv 
// mlstat // all 
	
recode mlstat 	(1=2)(2 3=1)(4 8=5)(6 9=3)(5 7=4) ///
				(-8=-3) (-9 -2 -1 -7=-1), gen(mlstat5)

	* Fill MV using other vars
	recode marstat  (1=2) (2 3=1) (4 7=5)(5 8=4)(6 9=3) (-8=-3)(-9 -2 -1 -7=-1), gen(mlstat_a)
	recode marstat_dv (1=1) (2=2) (6=2)(3=3)(4=4)(5=5) (0=-3)(-9=-1), gen(mlstat_a2)
		replace mlstat_a=mlstat_a2 if mlstat_a<0
		replace mlstat_a=mlstat_a2 if mlstat_a==2 & mlstat_a2==1
		replace mlstat_a=mlstat_a2 if mlstat_a==5 & mlstat_a2==1
		replace mlstat_a=mlstat_a2 if mlstat_a==4 & mlstat_a2==1
		replace mlstat_a=mlstat_a2 if mlstat_a==3 & mlstat_a2==1
	
	recode mlstat_bh (1=1)(2=5)(3=4) (4=3)(5=2) (-8=-3)(-9 -2 -1 6 7=-1), gen(mlstat_b)
	recode mastat (1=1) (2=2) (6=2)(3=3)(4=4)(5=5) (0=-3)(-9 -2 -1 7/10=-1), gen(mlstat_b2)
		replace mlstat_b=mlstat_b2 if mlstat_b<0
		replace mlstat_b=mlstat_b2 if mlstat_b==2 & (mlstat_b2==1|(mlstat_b2>3 & mlstat_b2<.))

	gen mlstat_fill=mlstat_b
	replace mlstat_fill=mlstat_a if wave>=19
	replace mlstat5=mlstat_fill if (mlstat5<=0|mlstat5==.) & (mlstat_fill>0 & mlstat_fill<.)
		drop mlstat_a mlstat_a2 mlstat_b mlstat_b2 mlstat_fill
	
	*!!! NOTE: some values corrected with marstat5 -> see below and run it also 
	
	
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
* Approach based on CNEF 
* Equal to CNEF's d11104  
* NOTE: 
* - categories of 'single' and 'living with partner' not fully precise and can be contradictory to other variables 
* - country differences in inclusion of having/living with partner
* - country differences in definition of ‘single’ 
*
// mastat mlstat_bh //1-18
// marstat marstat_dv mastat_dv // 19+ --> CNEF: mastat_dv 
// mlstat // all
	
* marstat5
recode marstat_dv (1 2=1)   (6=2) (3=3) (4=4) (5=5) (0=-3) (-9=-1), gen(marstat5a)
recode mastat (1 2 7=1)   (6=2) (3 10=3) (4 8=4) (5 9=5) (0=-3) (-9 -2 -1 7/10=-1), gen(marstat5b)
gen marstat5=marstat5b
replace marstat5=marstat5a if wave>=19
	drop marstat5a marstat5b
	
	* Replace MV with mlstat5 values 
	replace marstat5=1 if marstat5<0 & mlstat5==1
	replace marstat5=2 if marstat5<0 & mlstat5==2
	replace marstat5=3 if marstat5<0 & mlstat5==3
	replace marstat5=4 if marstat5<0 & mlstat5==4
	replace marstat5=5 if marstat5<0 & mlstat5==5
	

	
	
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
	
	*!!! NOTE: some values corrected with parstat -> see below and run it also 

		*!!! Correct inconsistencies in mlstat5 with marstat5
		replace mlstat5=1 if mlstat5==3 & marstat5==1
		replace mlstat5=1 if mlstat5==4 & marstat5==1
		replace mlstat5=1 if mlstat5==5 & marstat5==1
		
		replace mlstat5=3 if  marstat5==3
		replace mlstat5=4 if  marstat5==4
		replace mlstat5=5 if  marstat5==5		
		
		
**--------------------------------------
** Partnership status (yes/no)
**--------------------------------------

		
*** Partner
* livpart
recode marstat_dv (1 2=1)  (3/6=0)  (0=-3) (-9=-1), gen(livpartA)
recode mastat (1 2 7=1)  (3/6=0) (8/10=0) (0=-3) (-9 -2 -1=-1), gen(livpartB)
gen livpart=livpartB
replace livpart=livpartA if wave>=19
	drop livpartA livpartB
		
	* Correct based on additional q 
	replace livpart=1 if spinhh==1 // spouse or partner  w1-18 
	replace livpart=0 if spinhh==2
	replace livpart=1 if livesp==1 // spouse w19+
	replace livpart=0 if livesp==2
	replace livpart=1 if livewith==1|livewith==3 // couple in household w19+
	replace livpart=0 if livewith==2
	
* haspart
* NOTE: not reliable, especially for waves 1-20
recode marstat_dv (1 2=1)  (3/6=0)  (0=-3) (-9=-1), gen(haspartA)
recode mastat (1 2 7=1)  (3/6=0) (8/10=0) (0=-3) (-9 -2 -1 7/10=-1), gen(haspartB)
gen haspart=haspartB
replace haspart=haspartA if wave>=19
	drop haspartA haspartB
	
	* Correct based on additional q 
	replace haspart=1 if nrpart==1 // steady relationship  w8 13 18
	replace haspart=1 if ncrr1==1 // non co-resident relationship  w21+
	replace haspart=1 if ncrr13==1 // non co-resident relationship  w24+ (extra)
	replace haspart=1 if livpart==1 
	
	
		lab var haspart "Has a partner"
		lab var livpart "Living together with partner"
		lab val haspart livpart  yesno
		
		

**--------------------------------------
** Partnership living-status 	 
**--------------------------------------
* Includes inforamtion on marital status and whether living with partner in HH 
// mastat mlstat_bh //1-18
// marstat marstat_dv mastat_dv // 19+ --> CNEF: mastat_dv 
// mlstat // all


recode  mlstat5 (1/5=0), gen(parstat6)
replace parstat6=3 if mlstat5!=1 & livpart==0
replace parstat6=5 if mlstat5==4 & livpart==0
replace parstat6=4 if mlstat5==3 & livpart==0
replace parstat6=6 if mlstat5==5 & livpart==0
replace parstat6=6 if mlstat5==1 & livpart==0
replace parstat6=2 if mlstat5!=1 & livpart==1
replace parstat6=1 if mlstat5==1 & livpart==1

	* Fill MV
	replace parstat6=3 if (parstat6<=0|parstat6==.) & mlstat5==2
	replace parstat6=5 if (parstat6<=0|parstat6==.) & mlstat5==4
	replace parstat6=4 if (parstat6<=0|parstat6==.) & mlstat5==3
	replace parstat6=6 if (parstat6<=0|parstat6==.) & mlstat5==5
	replace parstat6=1 if (parstat6<=0|parstat6==.) & mlstat5==1
	
	* Correct inconsistent with marstat5
	replace parstat6=1 if parstat6==3 & marstat5==1
	replace parstat6=1 if parstat6==3 & marstat5==1

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
	

		*!!! Correct inconsistencies in parstat6 with marstat5
		replace marstat5=2 if parstat6==3 & marstat5<0
		replace marstat5=1 if parstat6==2 & marstat5<0

**--------------------------------------
** Binary specific current partnership status (yes/no) 
**--------------------------------------



				
				
*** Never married 
recode  mlstat5 (2=1) (1 3/5=0), gen(nvmarr)

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
** Year married	 AVALIABLE
**--------------------------------------
* ymarr 

//  	lab var ymarr "Year married	"
	
	

	

	
**--------------------------------------
** Children 
**--------------------------------------
/* NOTES
- taken from HH dataset
- ALSO availible: lprnt lnprnt hhch16 nchund18resp nnatch nadoptch nchunder16 ndepchl_dv nchild
*/

* kidsn_15
// recode nchild_dv (-9=-1), gen(kidsn_15) // Number of own children in the household. Includes natural children, adopted children and step children, under age of 16.


* kidsn_hh15

	*supporting var based on age ranges 
	mvdecode nch02_dv nch34_dv nch511_dv nch1215_dv, mv(-9 =.a)
		egen kidsn_15 = rowtotal(nch02_dv nch34_dv nch511_dv nch1215_dv) // any, not only biological 
	mvencode nch02_dv nch34_dv nch511_dv nch1215_dv, mv(.a=-9)
			// 	Number of children aged X-X in the household. 
			// 	Households containing one or more children with unknown age are coded as missing [-9]. 
			
recode nkids_dv (-9=-1), gen(kidsn_hh15) // the total number of children aged 15 or under in the household (any, not only biological)
	* replace MV with kidsn_15
	replace kidsn_hh15=kidsn_15 if (kidsn_hh15==.|kidsn_hh15<0) & kidsn_15<. & kidsn_15>=0


*kidsn_all - BAD becouse lnprnt & lnadopt not asked to all 
// 		nnatch>0 //number of biological children in household
// 		lnprnt 	//Number of biological children ever had/fathered
// 		lnadopt	// Number of step/adopted child(ren)
		
// 	recode nnatch (-7=-3), gen(kidsn_all)
// 	replace kidsn_all=lnprnt if lnprnt>0 & lnprnt<. & lnprnt>kidsn_all
// 	replace kidsn_all=kidsn_all+lnadopt if lnadopt>0 & lnadopt<.
// 	recode kidsn_all (50/max=-1)
		
	
	
*kids_any
// 		nnatch>0 //number of biological children in household
// 		lprnt	// Ever had/fathered children   
// 		ladopt	// Ever had step/adopted child(ren)
	
	*UKHLS
	recode nnatch (1/max=1), gen(kids_any)
	replace kids_any=1 if lprnt==1
	replace kids_any=1 if ladopt==1
	
	*BHPS
		replace kids_any=1 if lprnt_bh==1
		replace kids_any=0 if lprnt_bh==2
		replace kids_any=-1 if lprnt_bh==-9
		replace kids_any=-1 if (lprnt_bh==. & wave<19)

 	
	* Forward filling 1
	sort pid wave
	bysort pid (wave): replace  kids_any=1 if 				///
							(kids_any==. | kids_any<=0)	&	/// MV or <0
							kids_any[_n-1]==1   			//  has values 1
							
	* Forward filling 0
	sort pid wave
	bysort pid (wave): replace  kids_any=0 if 				///
							(kids_any==. | kids_any<0)	&	/// MV or <0
							kids_any[_n-1]==0   			//  has values 0						
							
	recode 	kids_any	(-7 =-1)			
							 
	
	lab var kids_any  "Has children"
	lab val kids_any   yesno
// 	lab var kidsn_all  "Number Of Children" 
// 	lab var kidsn_15   "Number Of Children <15 y.o." 
//  	lab var kidsn_hh18   "Number of Children in HH<18" 
 	lab var kidsn_hh15   "Number of Children in HH<15" 


	 
**--------------------------------------
** People in HH  
**--------------------------------------
/* NOTES:
- from HH data
*/
clonevar nphh=hhsize

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

recode jbhas (2=0) (-9 -2 -1=-1) (-8  =-3), gen(work_d)
replace work_d=1 if jbhas==2 & ((wave<19 & jboff==1 & jboffy_bh!=1) | (wave>=19 & jboff==1 & jboffy!=1))
	// add 'not work last week but has job' (excluding maternity leave) 

// 	lab var work_py "Working: last year (based on hours)"	
	lab var work_d "Working: currently (based on selfrep)" //last week
	lab val work_d yesno
	
**--------------------------------------  
** Employment Status  
**--------------------------------------
// jbstat //all

* emplst5

recode jbstat 	(1 2 5 10 11 12 13=1) (3=2) (4 8=3) (6=4) (7 9=5) ///
				(-9 -2 -1=-1) (-8 -7=-3) , gen(emplst5)
replace emplst5=1 if emplst5==97 & (jbhas==1 | jboff==1)
replace emplst5=2 if emplst5==97 & jboff==3
replace emplst5=4 if emplst5==97 & jbhas==2
replace emplst5=-1 if emplst5==97 
replace emplst5=2 if emplst5<0 & julk4wk==1

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
recode jbstat 	(1 2 10 11=1) (3=2) (4 8=3) (6=4) (7 9=5) (5 12 13=6) ///
				(  -9 -2 -1  =-1) (-8 -7=-3) , gen(emplst6)
replace emplst6=1 if emplst6==97 & jbhas==1 
replace emplst6=6 if emplst6==97 & jboff==1
replace emplst6=2 if emplst6==97 & jboff==3
replace emplst6=4 if emplst6==97 & jbhas==2
replace emplst6=-1 if emplst6==97   
replace emplst6=2 if emplst6<0 & julk4wk==1
				
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
// bro emplst5 jbisco_cc jbisco88_cc mrjisco88_cc mrjsoc mrjnssec_dv mrjnssec8_dv jbsoc90_cc jbseg_dv

* jbisco88_cc - collected only for respondents for which w_jbhas==1 | w_jboff==1

recode  jbisco88_cc (-1 -9=-1)(-8=-3), gen(isco88_3)

* Add labels using iscogen ado
iscolbl isco88com isco88_3,  minor


  

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
generate isco_1 = cond(isco88_3 >=100, int(isco88_3/100), isco88_3)
replace isco_1=0 if isco88_3==10 | isco88_3==11

generate isco_2 = cond(isco88_3 >100, int(isco88_3/10), isco88_3)
replace isco_2=0 if isco88_3==10 | isco88_3==11
 
 
	lab val isco_1 isco_1
	lab var isco_1 "Occupation: ISCO-1digit"

	lab val isco_2 isco_2
	lab var isco_2 "Occupation: ISCO-2digit"

	
	
**--------------------------------------    
** Industry 
**--------------------------------------
// jbsic - to w11 SIC 1980 (3 digit) 
// jbsic92 - w12-w15 SIC 1992 (3 digit) 
// jbsic07_cc - w19+ SIC 2007 (2 digit) 
// Also avaliable: mrjsic, mrjsic9, jlsic92 
// Also avaliable: jbiindb_dv w19+ CNEF --> differnt categorisation 


*** Recode  jbsic & jbsic92 into 2-digit categories
* Any case with 3 digits is missing a leading zero. This means that "100" should be read as 0100 or 01.00 .
* Single digit in indust (e.g. 5) is missing leading 0 (it is therefore meant as 05)
* jbsic<100 --> MV (n=7) 
* jbsic92<100 --> MV (n=1) 

local n=1
foreach var in jbsic jbsic92   {
local w1 = cond("`var'" =="jbsic", 1, 12)
local w2 = cond("`var'" =="jbsic", 12, 19)
	generate temp_ind`n'_1 = cond(`var' >=1000, int(`var'/100), .) if wave>=`w1' & wave<`w2'
	generate temp_ind`n'_2 = cond(`var' >=100 & `var' <1000, int(`var'/100), .) if wave>=`w1' & wave<`w2'
		gen indust2d`n'=.
		replace indust2d`n'=temp_ind`n'_1 if `var' >=1000 & wave>=`w1' & wave<`w2'
		replace indust2d`n'=temp_ind`n'_2 if `var' >=100 & `var' <1000 & wave>=`w1' & wave<`w2'
		drop temp*
		local ++n
	}	
	
	replace indust2d1=-3 if jbsic==-8
	replace indust2d1=-1 if jbsic==-9 | jbsic==-7 | jbsic==-1

	replace indust2d2=-3 if jbsic92==-8
	replace indust2d2=-1 if jbsic92==-9 | jbsic92==-7


*** jbsic07_cc remains the same 
clonevar indust2d3=jbsic07_cc	
recode indust2d3 (-9 -2=-1) (-8=-3)

*** Labels for 2 digits 
* SIC 1980
	lab def indust2d1 ///
		1 "[1] Agriculture & horticulture" ///
		2 "[2] Forestry" ///
		3 "[3] Fishing" ///
		11 "[11] Coal extraction & manufacture of solid fuels" ///
		12 "[12] Coke ovens" ///
		13 "[13] Extraction of mineral oil & natural gas" ///
		14 "[14] Mineral oil processing" ///
		15 "[15] Nuclear fuel production" ///
		16 "[16] Production & distribution of electricity, gas & other forms of energy" ///
		17 "[17] Water supply industry" ///
		21 "[21] Extraction & preparation of metalliferous ores" ///
		22 "[22] Metal manufacturing" ///
		23 "[23] Extraction of minerals not elsewhere specified" ///
		24 "[24] Manufacture of non-metallic mineral products" ///
		25 "[25] Chemical industry" ///
		26 "[26] Production of man-made fibres" ///
		31 "[31] Manufacture of metal goods not elsewhere specified" ///
		32 "[32] Mechanical engineering" ///
		33 "[33] Manufacture of office machinery & data processing equipment" ///
		34 "[34] Electrical & electronic engineering" ///
		35 "[35] Manufacture of motor vehicles & parts thereof" ///
		36 "[36] Manufacture of other transport equipment" ///
		37 "[37] Instrument engineering" ///
		41 "[41] Food, drink & tobacco manufacturing industries" ///
		42 "[42] Food, drink & tobacco manufacturing industries" ///
		43 "[43] Textile industry" ///
		44 "[44] Manufacture of leather & leather goods" ///
		45 "[45] Footwear & clothing industries" ///
		46 "[46] Timber & wooden furniture industries" ///
		47 "[47] Manufacture of paper & paper products; printing & publishing" ///
		48 "[48] Processing of rubber & plastics" ///
		49 "[49] Other manufacturing industries" ///
		50 "[50] Construction" ///
		61 "[61] Wholesale distribution (except dealing in scrap & waste materials)" ///
		62 "[62] Dealing in scrap & waste materials" ///
		63 "[63] Commission agents" ///
		64 "[64] Retail distribution" ///
		65 "[65] Retail distribution" ///
		66 "[66] Hotels & catering" ///
		67 "[67] Repair of consumer goods & vehicles" ///
		71 "[71] Railways" ///
		72 "[72] Other inland transport" ///
		74 "[74] Sea transport" ///
		75 "[75] Air transport" ///
		76 "[76] Supporting services to transport" ///
		77 "[77] Miscellaneous transport services & storage nec" ///
		79 "[79] Postal services & telecommunications" ///
		81 "[81] Banking & finance" ///
		82 "[82] Insurance, except for compulsory social security" ///
		83 "[83] Business services" ///
		84 "[84] Renting of movables" ///
		85 "[85] Owning & dealing in real estate" ///
		91 "[91] Public administration, national defence & compulsory social security" ///
		92 "[92] Sanitary services" ///
		93 "[93] Education" ///
		94 "[94] Research & development" /// 
		95 "[95] Medical,health services" /// 
		96 "[96] Other public services" /// 
		97 "[97] Recreational etc services" /// 
		98 "[98] Personal services" /// 
		99 "[99] Domestic services" 
	
	lab val indust2d1 indust2d1
	lab var indust2d1 "Industry (2 dig): SIC 80, w1-12"

* SIC 1992

	lab def indust2d2 ///
		1 "[1] Agriculture And Related Activities" ///
		2 "[2] Forestry, Logging And Related Activities" ///
		5 "[5] Fishing" ///
		10 "[10] Mining Of Coal And Coal Extraction" ///
		11 "[11] Extraction Of Crude Petroleum And Natural Gas; Service Activities Incidental To Oil And Gas Extraction" ///
		12 "[12] Mining Of Uranium And Thorium Ores" ///
		13 "[13] Mining Of Metal Ores" ///
		14 "[14] Other Mining And Quarrying" ///
		15 "[15] Manufacturing Of Food Products And Beverages" ///
		16 "[16] Manufacture Of Tobacco Products" ///
		17 "[17] Manufacture Of Textiles" ///
		18 "[18] Manufacture Of Wearing Apparel" ///
		19 "[19] Manufacture Of Leather, Leather Products And Footwear Of Any Material" ///
		20 "[20] Manufacture Of Wood And Wood Products, Except Furniture" ///
		21 "[21] Manufacture Of Pulp, Paper And Paper Products" ///
		22 "[22] Publishing, Printing And Reproduction Of Recorded Media" ///
		23 "[23] Manufacture Of Coke, Refined Petroleum Products And Nuclear Fuel" ///
		24 "[24] Manufacture Of Chemicals And Chemical Products" ///
		25 "[25] Manufacture Of Rubber And Plastic Products" ///
		26 "[26] Manufacture Of Other Non-Metallic Mineral Products" ///
		27 "[27] Manufacture Of Basic Metals" ///
		28 "[28] Manufacture Of Fabricated Metal Products, Except Machinery And Equipment" ///
		29 "[29] Manufacture Of Machinery And Equipment Not Elsewhere Classified" ///
		30 "[30] Manufacture And Assembly Of Office Machinery And Computers" ///
		31 "[31] Manufacture Of Electrical Machinery And Apparatus Not Elsewhere Classified" ///
		32 "[32] Manufacture Of Radio, Television And Communication Equipment And Apparatus" ///
		33 "[33] Manufacture Of Medical, Precision And Optical Instruments, Watches And Clocks" ///
		34 "[34] Manufacture Of Motor Vehicles, Trailers And Semi-Trailers" ///
		35 "[35] Manufacture Of Other Transport Equipment" ///
		36 "[36] Manufacture Of Furniture; Manufacturing Not Elsewhere Classified" ///
		37 "[37] Recycling" ///
		40 "[40] Electricity, Gas, Steam And Hot Water Supply" ///
		41 "[41] Collection, Purification And Distribution Of Water (Excluding Sewage Treatment)" ///
		45 "[45] Construction" ///
		50 "[50] Sale, Maintenance And Repair Of Motor Vehicles And Motorcycles; Retail Sale Of Automotive Fuel" ///
		51 "[51] Wholesale Trade And Commission Trade, Except Of Motor Vehicles And Motorcycles" ///
		52 "[52] Retail Trade, Except Of Motor Vehicles And Motorcycles; Repair Of Personal And Household Goods" ///
		55 "[55] Hotels And Restaurants" ///
		60 "[60] Land Transport; Transport Via Pipelines" ///
		61 "[61] Water Transport" ///
		62 "[62] Air Transport" ///
		63 "[63] Supporting And Auxiliary Transport Activities; Activities Of Travel Agencies" ///
		64 "[64] Post And Courier Activities And Telecommunications" ///
		65 "[65] Financial Activities, Except Insurance And Pension Funding" ///
		66 "[66] Insurance And Pension Funding, Except Social Security" ///
		67 "[67] Activities Auxiliary To Financial Management" ///
		70 "[70] Property Development" ///
		71 "[71] Renting Of Machinery And Equipment Without Operator And Of Personal And Household Goods" ///
		72 "[72] Computer And Related Activities" ///
		73 "[73] Research And Development Activities" ///
		74 "[74] Other Business Activities" ///
		75 "[75] Public Administration And Defence; Social Security" ///
		80 "[80] Education" ///
		85 "[85] Health And Social Work" ///
		90 "[90] Sewage And Refuse Disposal, Sanitation And Similar Activities" ///
		91 "[91] Activities Of Membership Organisations Not Elsewhere Classified" ///
		92 "[92] Recreational, Cultural And Sporting Activities" ///
		93 "[93] Other Service Activities" ///
		95 "[95] Private Households With Employed Persons" ///
		99 "[99] International Organisations And Bodies"  

	lab val indust2d2 indust2d2
	lab var indust2d2 "Industry (2 dig): SIC 92, w13-18"

*
	lab var indust2d3 "Industry (2 dig): SIC 07, w19+"

	
* Major groups 
 
recode  indust2d1 (1/10 11/14 23 15/18 20/22 24/49 50/59 =1) ///
				  (60/65 66/69 80/83 84/86 70/79 94 97/99=2) ///
				  (90/93 95 96 =3)	///
				   , gen(indust1a)
				   
recode  indust2d2 (1/49=1)(50/74 90/96=2)(75/86 89 99=3) ///
				   , gen(indust1b)				   
				   
recode  indust2d3 (1/43=1)(45/82 87 90 92/98=2)(84/86 88 91 99=3) ///
				   , gen(indust1c)						   

gen indust1=.
foreach var in indust1a indust1b indust1c {
replace indust1=`var' if `var'>0 & `var'<.
}
				   
lab def indust1											///
           1 "[1] Production, Construction, Heavy Ind"	///
           2 "[2] Trade and Services"					///
		   3 "[3] Public services"						///
		  -1 "[-1] MV general"							///
		  -3 "[-3] Does not apply"	  
		  
	lab val indust1 indust1		  
	lab var indust1 "Industry (major groups)" 
	
* Submajor groups 
recode  indust2d1 (1/10=1)(11/14 23=3)(15/18=2)(20/22 24/49=4)  ///
				  (50/59=5)(60/65=6) (66/69 84/86 90/99=9)(70/79=7) ///
				  (80/83=8)	///
				   , gen(indust2a)
				   
recode  indust2d2 (1/8=1)(10/14=3)(40/41=2)(15/37=4)  ///
				  (45/48=5)(50/53=6) (55 56 58 70/94=9)(60/64=7) ///
				  (65/67=8) (95/99=10)	///
				   , gen(indust2b)
				   
recode  indust2d3 (1/3=1)(5/9=3)(35=2)(10/33=4)  ///
				  (41/43=5)(45/47 56=6) (36/39 55 58/63 68 70/96=9)(49/53=7) ///
				  (64/66 69=8)(97/99=10)	///
				   , gen(indust2c)
gen indust2=.
foreach var in indust2a indust2b indust2c {
replace indust2=`var' if `var'>0 & `var'<.
}
						   
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
recode  indust2d1 (1/2=1)(3/9=2)(11/15 23=3)(16/18=5)(20/22 24/49=4) ///
				  (50/59=6)(60/65 67/69=7)(66=8)(70/79=9)(80/83=10)	///
				  (84/86 94=11)(90/91=12)(92 96/99=15)(93=13)(95=14)	///
				  , gen(indust3a)

recode  indust2d2 (1 2=1)(5 8=2)(10/14=3)(15/37=4)(40/41=5) ///
				  (45/48=6)(50/53=7)(55 56 58=8)(60/64=9)(65/67=10)	///
				  (70/74=11)(75/77=12)(90/94=15)(80/84=13)(85/89=14)	///
				  (95 96=16)(99=17) ///
				  , gen(indust3b)

recode  indust2d3 (1/3=1)(4=2)(5/9=3)(10/33=4)(35/37=5) ///
				  (41/43=6)(45/47 58/59 70/71 79/82 90 92 95 98=7)(55/56=8)(49/53 60/61 63=9)(69=10)	///
				  (62 64/68 72/75 77=11)(84=12)(38 39 78 91 93 94 96=15)(85=13)(75 86/88=14)	///
				  (97=16)(99=17) ///
				   , gen(indust3c)
gen indust3=.
foreach var in indust3a indust3b indust3c {
replace indust3=`var' if `var'>0 & `var'<.
}

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
drop indust1a indust1b indust1c indust2a indust2b indust2c indust3a indust3b indust3c
		  
		  
		  
**--------------------------------------
** Public sector
**--------------------------------------
recode jbsect (1 2=0) (-9 -2 -1=-1) (-8 -7=-3) , gen(public)
replace public=1 if jbsectpub>=3 & jbsectpub<=6 

	lab val public yesno
	lab var public "Public sector"

**--------------------------------------
** Size of organization	
**--------------------------------------
*size 

recode jbsize (1 2=1) (3 4 10=2) (5 11=3) (6/8=4) (9=5) ///
			(-9 -2 -1=-1) (-8 -7=-3), gen(size5)
recode jbsize (1 2=1) (3 4 10=2) (5 11=3) (6 7=4) (8 9=5) ///
			(-9 -2 -1=-1) (-8 -7=-3), gen(size5b)
 
//  	lab var size  "Size of organization [cont]"
// 	lab var size4 "Size of organization [4]"
// 	lab def size4 1 "<20" 2 "20-199" 3 "200-1999" 4 "2000+"  	///
// 				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
// 				-1 "-1 MV general" -2 "-2 Item non-response" 	///
// 				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val size4 size4
	
	lab var size5 "Size of organization [5]"
	lab def size5 1 "<10" 2 "10-49" 3 "50-99" 4 "100-999" 5 "1000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "-1 MV general" -2 "-2 Item non-response" 	///
				-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
	lab val size5 size5
	
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
recode jbhrs (-9 -2 -1=-1) (-8 0=-3), gen(whweek_ctr)
replace whweek_ctr=jshrs if jshrs>0 & jshrs<.

	lab var whweek_ctr "Work hours per week: conracted"



**--------------------------------------
** hours worked
**--------------------------------------
* wh_real wh_year
gen whweek=whweek_ctr
replace whweek=whweek+jbot if jbot>0 & jbot<. &  whweek>0
	gen temp=j2hrs/4.3
replace whweek=whweek+temp if temp>0 & temp<. &  whweek>0
	drop temp

gen whmonth=whweek*4.3
replace whmonth=whweek if whweek<0

// gen whyear=whweek*52    
// replace whyear=whweek if whweek<0


// 	lab var whday "Work hours per day: worked"
	lab var whweek "Work hours per week: worked"
	lab var whmonth "Work hours per month: worked"
// 	lab var whyear "Work hours per year: worked"
 
 

**--------------------------------------  
** full/part time 
**--------------------------------------
* fptime_r fptime_h
* NOTE:
// jbft_dv - Employed full time (i.e. greater than 30 hours per week). This measure is based 
// on total hours, i.e. including both normal and overtime hours. It is computed for 
// both employees and the self employed. Inapplicable to proxy respondents due to 
// missing information on overtime, and respondents who do not have a paid job.

// recode jbstat (1/97=0) (-9 -2 -1=-1) (-8 -7=-3) , gen(fptime_h)
// replace fptime_h=jbft_dv if jbft_dv==1|jbft_dv==2
// replace fptime_h=-1 if jbft_dv<0|jbft_dv==.

recode jbft_dv (-9 =-1) (-8 -7 =-3) , gen(fptime_r)
replace fptime_r=3 if jbhas==2 & jboff==2  

*
gen fptime_h=.
replace fptime_h=1 if whweek>=35 & whweek<.
replace fptime_h=2 if whweek<35 & whweek>0
replace fptime_h=3 if whweek==0
replace fptime_h=3 if emplst5>1 & emplst5<.
replace fptime_h=whweek if whweek<0 & fptime_h==.

	lab def fptime 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other"
	lab val fptime_h fptime_r fptime

	lab var fptime_r "Employment Level (self-report)"
	lab var fptime_h "Employment Level (based on hours)"

**--------------------------------------
** overtime working 
**--------------------------------------
//  jbot
 
 
**--------------------------------------
** Supervisor 	
**--------------------------------------
* supervis
	
recode jbmngr (1 2=1) (3=0) (-9 -2 -1=-1) (-8 =-3) , gen(supervis)

	
	lab val supervis yesno
	lab var supervis "Supervisory position"
	
**--------------------------------------
** maternity leave  
**--------------------------------------
* mater
recode jbstat (5=1) (1/4 6/97=0) (-9 -2 -1=-1) (-8 -7=-3) , gen(mater)

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
* 
// stendreas  jbendreas nxtendreas reasend // from 20+ or 23+

**--------------------------------------
** Unempl: actively looking for work 
**--------------------------------------
* un_act
			
recode jbhas (1 2=0) ( -9 -2 -1 =-1) (-8 =-3),  gen(un_act)
replace un_act=1 if jbhas==2 & julk4wk==1
replace un_act=0 if emplst5 ==1
replace un_act=0 if un_act<0 & emplst5>=3 & emplst5<.
replace un_act=1 if un_act<0 & emplst5==2  
				
	lab val un_act yesno
	lab var un_act "Unemployed: actively looking for work "

*################################  
*#								#
*#	Self-empl / Entrepreneur	#
*#								#
*################################

**--------------------------------------
** Self-employed	
**--------------------------------------
// jstypeb // 7+
// jbes2000 //19+

recode  jbsemp (1=0) (2=1) ( -9 -2 -1 =-1) (-8 =-3), gen(selfemp)
replace selfemp=0 if selfemp==-3 & emplst5>1 & emplst5<.

* selfemp v1-v3 

	lab val   selfemp   yesno
// 	lab var selfemp_v1 "Self-employed 1: all without Family Business"
	lab var selfemp "Self-employed 2: all with Family Business"
// 	lab var selfemp_v3 "Self-employed 3: based on income from self-empl"

**--------------------------------------
** Entrepreneur 
**--------------------------------------
* entrep
// jstypeb // 7+
// jbes2000 //19+
recode  jbsemp (1 2=0) ( -9 -2 -1 =-1) (-8 =-3), gen(entrep2)
replace entrep2=1 if jsboss==1

	
//   	lab val entrep yesno
//   	lab var entrep  "Entrepreneur (not farmer; has employees)"
 
	lab val entrep2 yesno
	lab var entrep2 "Entrepreneur (incl. farmers; has employees)"

**--------------------------------------
** Number of employees 
**--------------------------------------
recode jssize  (-9 -2=-2)(-8=-3)(-1=-1) (1 2=1) (3/11=2), gen(temp_nempl)
recode entrep2 (0 1=-1), gen(nempl)
replace nempl=1 if entrep2==1 & temp_nempl==1
replace nempl=2 if entrep2==1 & temp_nempl==2
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
* age ret 
//  ageret //11 16 20+
//  retdatey // 19
// * pension
// nipens//13-18
// benpen1 pbnft1 //19+ 


/* retf - Critetia:
- Not working  
- Self-categorisation as retired & age 50+
- Receives old-age pension & age 50+
- Age 50+
- Age 65+ & not active 
*/

recode jbhas (1 2=0) (-9 -2 -1=-1) (-8  =-3), gen(retf)
replace retf=0 if jbstat >0 & jbstat<.
replace retf=1 if jbhas==2 & jboff==2 ///&	jbstat!=1 & jbstat!=2 	/// not working 
				  & age_dv >=50 									/// age
				  & jbstat==4										// self-categorisation as retired 
				  
replace retf=1 if (nipens==1 | benpen1==1 | pbnft1==1) 				/// Receiving old-age pension (waves 13+ only)
				  & jbhas==2 & jboff==2 & age_dv >=50
				  
replace retf=1 if age_dv>=65 & jbhas==2 & jboff==2 					/// age>65 & not active 
				& jbstat !=1 & jbstat !=2  	

replace retf=0 if emplst5==1		// delete employed 

	lab var retf "Retired fully (self-rep, NW, old-age pens, 50+)"
	lab val retf yesno 


	

**--------------------------------------
** Age of retirement 
**--------------------------------------					  
*   
 //  retdatey // 19


	  

**--------------------------------------
** Receiving old-age pension   
**--------------------------------------					  
* oldpens  

recode jbhas (1 2=0) (-9 /-1=.), gen(oldpens)
replace oldpens=0 if jbstat >0 & jbstat<.							  
replace oldpens=1 if (nipens==1 | benpen1==1 | pbnft1==1)
replace oldpens=. if wave<13
					  
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
// Check doc for Never had a job
// j1none_bh j1none j1none_mhis
// mrjnssec8_dv// 1-18
// j1none

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


* whole income (jobs, benefits)
// fimngrs_dv

// 	lab var inctot_yn "Individual Income (All types, year, net)"
// 	lab var inctot_mn "Individual Income (All types, month, net)"


	
* all jobs 
// fiyr fimngrs_dv 
recode fimnlabgrs_dv (min/-0.0001=.) , gen(incjobs_mg)
gen incjobs_yg=incjobs_mg*12
 

// 	lab var incjobs_yn "Individual Labor Earnings (All jobs, year, net)"
	lab var incjobs_yg "Individual Labor Earnings (All jobs, year, gross)"
// 	lab var incjobs_mn "Individual Labor Earnings (All jobs, month, net)"
	lab var incjobs_mg "Individual Labor Earnings (All jobs, month, gross)"


* main job

// bro payg_dv payn_dv paygu_dv paynu_dv incjobs_mg incjobs_yg
recode paygu_dv (min/-0.0001=.) , gen(incjob1_mg)
recode paynu_dv (min/-0.0001=.) , gen(incjob1_mn)
gen incjob1_yg=incjob1_mg*12
gen incjob1_yn=incjob1_mn*12

	lab var incjob1_yg  "Salary from main job (year, gross)"
	lab var incjob1_yn  "Salary from main job (year, net)"
	lab var incjob1_mg "Salary from main job (month, gross)"
	lab var incjob1_mn "salary from main job (month, net)"

*
**--------------------------------------
*   HH wealth
**--------------------------------------
* hhinc_pre
* hhinc_post - //better indicator

recode fihhmngrs_dv (-9=.), gen(hhinc_post)

//  	lab var hhinc_pre "HH income(month, pre)"	
	 	lab var hhinc_post "HH income(month, post)"	
	
**--------------------------------------
**   Income - subjective 
**--------------------------------------
* incsubj9

// 	lab var incsubj9 "Income: subjective rank [9]"
// 	lab def incsubj9 1 "Lo step" 9 "Hi step" 
// 	lab val incsubj9 incsubj9
//

*################################
*#								#
*#	Health status				#
*#								#
*################################
**-------------------------------------- 
**  Self-rated health 
**--------------------------------------
* srh5
// scsf1 // main 20+
// sf1 // 19, proxy
// hlsf1 // 9 14 
// hlstat // 1-18

foreach var in hlstat sf1 scsf1 {
recode `var' (-9 -7 -2 -1=-1) (-8=-3), gen(temp_`var')
}
gen srh5=temp_hlstat if temp_hlstat!=.
replace srh5=temp_sf1 if wave==19
replace srh5=temp_scsf1 if wave>=20
drop temp_*

	lab var srh5 "Self-rated health"
	lab def srh5 5 "Very bad" 4 "Bad" 3 "Satisfactory" 2 "Good" 1 "Very good"
	lab val srh5 srh5
	
**-------------------------------------- 
**  Disability 
**--------------------------------------
* disab
/* NOTE:
- limited no of waves 
- there are alternative questions in BHPS - please inspect them and use 
  according to a research problem 
*/

egen disab= anymatch(disdif1-disdif12), val(1)
replace disab=. if wave<19
 
gen disab2c=0 if health>0 & health<. & wave>=25
foreach var of varlist dissev1 -dissev12 {
replace disab2c=1 if `var'==2 | `var'==3
}
 
	lab var disab	"Disability (any)"
	lab var disab2c "Disability (min. category 2 or >30%)"
	lab val disab disab2c yesno
	
	
**--------------------------------------
**  Chronic diseases
**--------------------------------------
* chron
/* NOTE:
- define chronic more precisely based on hcondn* items
*/
recode health (2=0) (-9 -2 -1=-1) (-8=-3), gen(chron)
 
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

/*NOTE:
- for sat5, we use recoding
- for sat10, we rescale 
- 1-7 scale can be also rescaled into 1-5 as follows:
1.00
1.67
2.33
3.00
3.67
4.33
5.00
*/

* sat_life
recode lfsato (1=1)(2 3 =2)(4=3)(5 6=4)(7=5)(-9 -2 -1=-1)(-8 -7=-3), gen(temp_a)
recode sclfsato (1=1)(2 3 =2)(4=3)(5 6=4)(7=5)(-10 -9 -2 -1=-1)(-8 -7=-3), gen(temp_b)
recode lfsato (1=0)(2=1.67)(3=3.33)(4=5)(5=6.67)(6=8.33)(7=10) ///
				(-9 -2 -1=-1)(-8 -7=-3), gen(temp_a10)
recode sclfsato (1=0)(2=1.67)(3=3.33)(4=5)(5=6.67)(6=8.33)(7=10) ///
				(-10 -9 -2 -1=-1)(-8 -7=-3), gen(temp_b10)
	gen satlife5=temp_a 
	replace satlife5=temp_b if wave>=19
	gen satlife10=temp_a10 
	replace satlife10=temp_b10 if wave>=19
	drop temp_*
 
 * satwork 
recode jbsat_bh (1=1)(2 3 =2)(4=3)(5 6=4)(7=5)(-9 -2 -1=-1)(-8 -7=-3), gen(temp_a)
recode jbsat (1=1)(2 3 =2)(4=3)(5 6=4)(7=5)(-10 -9 -2 -1=-1)(-8 -7=-3), gen(temp_b)
recode jbsat_bh (1=0)(2=1.67)(3=3.33)(4=5)(5=6.67)(6=8.33)(7=10) ///
				(-9 -2 -1=-1)(-8 -7=-3), gen(temp_a10)
recode jbsat (1=0)(2=1.67)(3=3.33)(4=5)(5=6.67)(6=8.33)(7=10) ///
				(-10 -9 -2 -1=-1)(-8 -7=-3), gen(temp_b10)
	gen satwork5=temp_a 
	replace satwork5=temp_b if wave>=19
	gen satwork10=temp_a10 
	replace satwork10=temp_b10 if wave>=19
	drop temp_*
	
* satfinhh
recode lfsat2 (1=1)(2 3 =2)(4=3)(5 6=4)(7=5)(-9 -2 -1=-1)(-8 -7=-3), gen(temp_a)
recode sclfsat2 (1=1)(2 3 =2)(4=3)(5 6=4)(7=5)(-10 -9 -2 -1=-1)(-8 -7=-3), gen(temp_b)
recode lfsat2 (1=0)(2=1.67)(3=3.33)(4=5)(5=6.67)(6=8.33)(7=10) ///
				(-9 -2 -1=-1)(-8 -7=-3), gen(temp_a10)
recode sclfsat2 (1=0)(2=1.67)(3=3.33)(4=5)(5=6.67)(6=8.33)(7=10) ///
				(-10 -9 -2 -1=-1)(-8 -7=-3), gen(temp_b10)
	gen satfinhh5=temp_a 
	replace satfinhh5=temp_b if wave>=19
	gen satfinhh10=temp_a10
	replace satfinhh10=temp_b10 if wave>=19
		drop temp_*

* sathlth
recode lfsat1 (1=1)(2 3 =2)(4=3)(5 6=4)(7=5)(-9 -2 -1=-1)(-8 -7=-3), gen(temp_a)
recode sclfsat1 (1=1)(2 3 =2)(4=3)(5 6=4)(7=5)(-10 -9 -2 -1=-1)(-8 -7=-3), gen(temp_b)
recode lfsat1 (1=0)(2=1.67)(3=3.33)(4=5)(5=6.67)(6=8.33)(7=10) ///
				(-10 -9 -2 -1=-1)(-8 -7=-3), gen(temp_a10)
recode sclfsat1 (1=0)(2=1.67)(3=3.33)(4=5)(5=6.67)(6=8.33)(7=10) ///
				(-10 -9 -2 -1=-1)(-8 -7=-3), gen(temp_b10)
	gen sathlth5=temp_a 
	replace sathlth5=temp_b if wave>=19
	gen sathlth10=temp_a10
	replace sathlth10=temp_b10 if wave>=19
		drop temp_*

	lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" 	///
				 4  "4 Mostly sat" 5 "5 Completely sat"						///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 		///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
	 

	lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
				 -1 "-1 MV general" -2 "-2 Item non-response" 		 ///
				 -3 "-3 Does not apply" -8 "-8 Question not asked in survey"
 
    lab val satlife5 satwork5 satfinhh5 sathlth5 sat5
	lab val satlife10 satwork10 satfinhh10 sathlth10 sat10
		
*################################
*#								#
*#	Other						#
*#								#
*################################
**--------------------------------------  
**   Training
**--------------------------------------
* train train2
// ednew //1-7 all
// jbed //1-7 W
// train //8-18
// trainany // 20+

rename train train_org
foreach var in ednew jbed train_org trainany {
recode `var' (2=0) (-9 -2 -1 -10=-1)(-8 -7=-3), gen(temp_`var')
}
gen train=temp_ednew
replace train=temp_jbed if (train==. | train<0) & temp_jbed>=0 & temp_jbed<.
replace train=temp_train_org if (train==. | train<0) & temp_train_org!=.
replace train=temp_trainany if (train==. | train<0) & temp_trainany!=.
	drop temp_*
	
	lab val train yesno
	lab var train "Training (previous year)"

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

// 	lab var wqualif "Qualifications for job"
// 	lab def wqualif 1 "1 Underqualified/Not qualified" 2 "2 Qualified (fit)" 3 "3 Overqualified" ///
// 					-1 "-1 MV general" -2 "-2 Item non-response" ///
// 					-3 "-3 Does not apply" -8 "-8 Question not asked in survey" 
// 	lab val wqualif wqualif
	
	
**--------------------------------------
**   Volunteering
**--------------------------------------
* volunt
// volun and some other - but selected waves 

// 	lab val volunt yesno
// 	lab var volunt "Volunteering"
	
	
**--------------------------------------
**   Job security
**--------------------------------------
*  
// jbsat4 //1-18
// jssat2 //1-18 s-empl
// jbsec //20 22 24 26 - how likely losin job next 12 months


recode jbsat4 (1/3=1) (4=2) (5/7=0) (-9 -2 -1=-1) (-8 -7=-3), gen(jsecu2a)
recode jssat2 (1/3=1) (4=2) (5/7=0) (-9 -2 -1=-1) (-8 -7=-3), gen(jsecu2b)
	gen jsecu2=jsecu2a
	replace jsecu2=jsecu2b if (jsecu2==.|jsecu2<0) & (jsecu2b>=0 & jsecu2b<.)

recode jbsec (1 2=1) (3 4=0) (-10 -9 -2 -1=-1) (-8 -7=-3), gen(jsecu)

recode jbsat4 (1/3=1) (4/7=0) (-9 -2 -1=-1) (-8 -7=-3), gen(jsecu_a)
recode jssat2 (1/3=1) (4/7=0) (-9 -2 -1=-1) (-8 -7=-3), gen(jsecu_b)
	replace jsecu=jsecu_a if (jsecu==.|jsecu<0) & (jsecu_a<.) & wave<=18 & jbsat4!=-3
	replace jsecu=jsecu_b if (jsecu==.|jsecu<0) & (jsecu_b<.) & wave<=18 & jbsat2!=-3


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
gen temp_isco88_4=isco88_3*10
iscogen temp_isco08_4=isco08(temp_isco88_4), from(isco88)  
iscogen isei08 = isei(temp_isco08_4), from(isco08)

	lab var isei08 "ISEI-08: International Socio-Economic Index of occupational status"

iscogen isei88 = isei(temp_isco88_4), from(isco88)
	lab var isei88 "ISEI-88: International Socio-Economic Index of occupational status"	
	
*  -specific scale provided by  
// p__6615 - current perceived economic status
 
	
	
**--------------------------------------
**   Treiman's international prestige scale (SIOPS) 
**--------------------------------------
iscogen siops08 = siops(temp_isco08_4) , from(isco08)
	lab var siops08 "SIOPS-08: Treiman's international prestige scale" 
	
iscogen siops88 = siops(temp_isco88_4) , from(isco88)
	lab var siops88 "SIOPS-88: Treiman's international prestige scale" 
	
**--------------------------------------
*** MPS (German Magnitude Prestige Scale; Christoph 2005)
**--------------------------------------	
iscogen mps88 = mps(temp_isco88_4), from(isco88)


**--------------------------------------
**   EGP / ESEC
**--------------------------------------	
// 	iscogen EGP = egp11(job selfemp nemployees), from(isco88)
//
// 	 oesch
	 
	 
**--------------------------------------
**  Indexes already availible in UK 
**--------------------------------------	

 
 
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
recode paedqf (1 2 3=1)(4=2)(5=3) (-11 -8 -7=-3)(-9 97=-1)(-2=-2), gen(fedu3)

	lab val fedu3 edu3
	lab var fedu3 "Father's education: 3 levels"

	
* edu4
recode paedqf (1 2=1)(3=2)(4=3)(5=4) (-11 -8 -7=-3)(-9 97=-1)(-2=-2), gen(fedu4)

	lab val fedu4 edu4
	lab var fedu4 "Father's education: 4 levels"
	

*** Mother 
*edu3
recode maedqf (1 2 3=1)(4=2)(5=3) (-11 -8 -7=-3)(-9 97=-1)(-2=-2), gen(medu3)
	lab val medu3 edu3
	lab var medu3 "Mother's education: 3 levels"

	
* edu4
recode maedqf (1 2=1)(3=2)(4=3)(5=4) (-11 -8 -7=-3)(-9 97=-1)(-2=-2), gen(medu4)

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
*#	    Ethnicity 				#
*#								#
*################################	
//self-reported ethnicity, mixed race UK moved to separate category
// uses racel_dv: a derived variable incorporating all waves, codings, modes and bhps

label define ethnicity ///
1 "Black" ///
2 "White" ///
3 "Asian" ///
4 "Mixed (UK only)" ///
5 "American Indian (US only)" ///
6 "Other" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

gen ethn=.
replace ethn=1 if inrange(racel_dv, 14, 16) //Black
replace ethn=2 if inrange(racel_dv, 1, 4) //White
replace ethn=3 if inrange(racel_dv, 9, 13) //Asian
replace ethn=4 if inrange(racel_dv, 5, 8) //Mixed (UK only)
replace ethn=6 if (racel_dv==17 | racel_dv==97) //Other
replace ethn=-3 if racel_dv==-8 //Inapplicable
replace ethn=-2 if racel_dv==-2 //Non-response
replace ethn=-1 if (racel_dv==-1 | racel_dv==-7 | racel_dv==-9) //DK, missing non-specified

lab val ethn ethnicity

*fill MV

*first fill for missing in UKHLS using "racel" -  especially relevant to specify missing
replace ethn=1 if (ethn==. | ethn<0) & ///
	inrange(racel, 14, 16) //Black
replace ethn=2 if (ethn==. | ethn<0) & ///
	inrange(racel, 1, 4) // White
replace ethn=3 if (ethn==. | ethn<0) & ///
	inrange(racel, 9, 13) //Asian
replace ethn=4 if (ethn==. | ethn<0) & ///
	inrange(racel, 5, 8) //Mixed
replace ethn=6 if (ethn==. | ethn<0) & ///
	(racel==17 | racel==97) //Other
replace ethn=-3 if (ethn==. | ethn<0) & ///
	racel==-8 //Inapplicable
replace ethn=-2 if (ethn==. | ethn<0) & ///
	racel==-2 //Non-response
replace ethn=-1 if (ethn==. | ethn<0) & ///
	(racel==-1 | racel==-7 | racel==-9) //DK, missing non-specified

*fill missing
	bysort pid: egen temp_ethn=mode(ethn), maxmode // identify most common response
	replace ethn=temp_ethn if ethn==. & temp_ethn>=0 & temp_ethn<.
	replace ethn=temp_ethn if ethn!=temp_ethn // correct a few inconsistent cases

	
*################################
*#								#
*#	Migration					#
*#								#
*################################	
	
**-------------------------
**   Migration Background
**-------------------------	

*** migr - specifies if respondent foreign-born or not.
lab def migr ///
0 "Native-born" ///
1 "Foreign-born" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

//Primarily uses bornuk_dv: a derived variable. Only for missing values filled with item ukborn for new respondents in UKHLS.

recode bornuk_dv (1=0) (2=1) (-9=-1) (else=.), gen(migr) // based on BHPS

*fill missing from UKHLS
replace migr=0 if inrange(ukborn, 1, 4) & (bornuk_dv==. | bornuk_dv==-9) // fill missing from UKHLS
replace migr=1 if ukborn==5 & (bornuk_dv==. | bornuk_dv==-9) //Fill missing from UKHLS

*specify missing
replace migr=-1 if migr==. & (ukborn==-9 | ukborn==-2 | ukborn==-1) //missing unspecified/DK/Refusal
replace migr=-3 if migr==. & ukborn==-8 //inapplicable

//fill missing based on specific country of birth (plbornc)
replace migr=1 if inrange(plbornc, 5, 97) & (migr==. | migr<0)

*fill MV
mvdecode migr, mv(-9=.a \ -8=.b \ -3=.c \ -1=.d) //temporarily decode missing value specifications

	bysort pid: egen temp_migr=mode(migr), maxmode // identify most common response
	replace migr=temp_migr if (migr==. | migr==.a/.d) & temp_migr>=0 & temp_migr<.
	replace migr=temp_migr if migr!=temp_migr  // correct inconsistent cases
	
mvencode migr, mv(.a=-9 \.b=-8 \.c=-3 \.d=-1) //restore mv

lab val migr migr

 
**--------------------------------------
**   COB respondent, father and mother
**--------------------------------------	
/// NOTE: with addition new waves, check if new countries are added to codebook UKHLS

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
 
foreach var in plbornc pacob macob {
	gen cob_`var'=.
		replace cob_`var'=0 if `var'==1 //england
		replace cob_`var'=0 if `var'==2 //scotland
		replace cob_`var'=0 if `var'==3 //wales
		replace cob_`var'=0 if `var'==4 //Northern Ireland
		replace cob_`var'=2 if `var'==5 //Ireland
		replace cob_`var'=2 if `var'==6 //France
		replace cob_`var'=2 if `var'==7 //Germany
		replace cob_`var'=2 if `var'==8 //Italy
		replace cob_`var'=3 if `var'==9 //Spain
		replace cob_`var'=3 if `var'==10 //Poland
		replace cob_`var'=3 if `var'==11 //Cyprus
		replace cob_`var'=4 if `var'==12 //Turkey
		replace cob_`var'=1 if `var'==13 //Australia
		replace cob_`var'=1 if `var'==14 //New Zealand
		replace cob_`var'=8 if `var'==15 //Canada
		replace cob_`var'=8 if `var'==16 //USA
		replace cob_`var'=6 if `var'==17 //ChinaHK
		replace cob_`var'=7 if `var'==18 //India
		replace cob_`var'=7 if `var'==19 //Pakistan
		replace cob_`var'=7 if `var'==20 //Bangladesh
		replace cob_`var'=7 if `var'==21 //Sri Lanka
		replace cob_`var'=9 if `var'==22 //Kenya
		replace cob_`var'=9 if `var'==23 //Ghana
		replace cob_`var'=9 if `var'==24 //Nigeria
		replace cob_`var'=9 if `var'==25 //Uganda
		replace cob_`var'=9 if `var'==26 //South Africa
		replace cob_`var'=8 if `var'==27 //Jamaica
		replace cob_`var'=3 if `var'==28 //Portugal
		replace cob_`var'=8 if `var'==29 //Brazil
		replace cob_`var'=10 if `var'==97 //Other
 }


rename cob_plbornc cob_rt // Working variables COB 
rename cob_pacob cob_ft
rename cob_macob cob_mt

***COB not specified if respondent uk-born: using migr to fill
replace cob_rt=0 if migr==0
//fill if cob missing but foreign-born 
replace cob_rt=10 if cob_rt==. & migr==1 //foreign but unspecified >> other

//MV
*** Identify valid COB and fill across waves  
sort pid wave 

*** Generate valid stage 1 - mode across the waves (values 1-10)
	// It takes the value of the most common valid answer between 1 and 10 
	// If there is an equal number of 2 or more answers, it returns "." - filled in next steps
	
	foreach var in cob_rt cob_mt cob_ft {
	bysort pid: egen mode_`var'=mode(`var')
	}
	
*** Generate valid stage 2 - first valid answer provided (values 1-9)
	// It takes the value of the first recorded answer between 1 and 9 (so ignors 10 "other")
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
	gen `var' = mode_`var't // stage 1 - based on mode
	replace `var' = first_`var't if (`var'==. | `var'<0) & inrange(first_`var't, 0,10) // stage 2 - based on the first for MV
	replace `var' = first_`var't if `var'==10 & inrange(first_`var't, 1,9) // stage 2 - based on the first for 10'other'
	drop `var't
	*
	label values `var' COB
	}

rename cob_r cob

*specify some missing values
replace cob=-8 if cob==. & migr==-8
replace cob=-3 if cob==. & migr==-3
replace cob=-2 if cob==. & migr==-2
replace cob=-1 if cob==. & migr==-1

*fill some MV for parents
replace cob_f=-1 if cob_f==. & (pacob==-1 | pacob==-9 | pacob==-1) // MV general
replace cob_f=-2 if cob_f==. & pacob==-2 //refusal
replace cob_m=-1 if cob_m==. & (macob==-1 | macob==-9 | macob==-1) // MV general
replace cob_m=-2 if cob_m==. & macob==-2 //refusal

**--------------------------------------
**   Migration Background (parents)
**--------------------------------------	

//if father/mother foreign-born
foreach p in f m {
		gen migr_`p'=cob_`p'
		replace migr_`p'=1 if inrange(cob_`p', 1, 10)
}

lab val migr migr_f migr_m migr

**--------------------------------------
**   Migrant Generation (respondent)
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
	 ((migr_f==0 & (migr_m==. | migr_m<0)) | ((migr_f==. | migr_f<0) & migr_m==0)) // respondent native-born, one parent native other unknown
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
	((migr_f==1 & migr_m==.) | (migr_m==1 & migr_f==.)) // native-born, one parent foreign-born other missing

*3 "2.5th generation"
replace migr_gen=3 if migr==0 & ///
	((migr_f==1 & migr_m==0) | (migr_m==1 & migr_f==0)) // native-born, one parent foreign-born other native-born	
	 
* Incomplete information parents
replace migr_gen=4 if migr==0 & (migr_f==. |migr_f<0) & (migr_m==. | migr_m<0) // respondent native-born, both parents unknown
replace migr_gen=4 if migr==1 & ((migr_f==. | migr_f<0) & (migr_m==. | migr_m<0)) // respondent foreign-born, both parents unknown
replace migr_gen=0 if migr==1 & ///
	 ((migr_f==0 & (migr_m==.|migr_m<0)) | ((migr_f==.|migr_f<0) & migr_m==0)) // respondent native-born, one parent native other unknown

  
	label values migr_gen migr_gen

**--------------------------------------------
**   Mother tongue / language spoken as child
**--------------------------------------------	
/* Not indluded in the current version due to too many MV

lab def langchild ///
0 "Same as country of residence" ///
1 "Other language" ///
-1 "MV general" ///
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

//first based on englang (english is first language)
gen langchild=.
replace langchild=0 if englang==1 //English
replace langchild=1 if englang==2
replace langchild=-2 if englang==-2
replace langchild=-1 if englang==-1
replace langchild=-3 if (englang==-8 | englang==-7)

//fill based on kidlang (What language was spoken in your home when you were a child?) >> less specific phrasing
replace langchild=0 if kidlang==1 & (englang==. | englang<0)
replace langchild=1 if inrange(kidlang, 2, 97) & (englang==. |englang<0)

lab val langchild langchild
	

*fill MV
gen langchild_t=langchild
	bysort pid: egen temp_lc=mode(langchild), maxmode // identify most common response
	replace langchild=temp_lc if langchild==. & temp_lc>=0 & temp_lc<.
	replace langchild=temp_lc if langchild!=temp_lc // correct a few inconsistent cases
	
	drop temp_lc langchild_t
	
*specify when question not asked and data cannot be filled
replace langchild=-8 if langchild==. & migr==0 & wavey!=2010 // not asked if uk-born, except in wave 2 UKHLS
replace langchild=-8 if langchild==. & englang==. & !inlist(wavey, 2009, 2013, 2014, 2018) // years when englang not asked
replace langchild=-8 if langchild==. & kidlang==. & !inlist(wavey, 2010, 2014, 2016) // years when kidlang not asked

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

recode oprlg (1=1) (2=0) (-2=-2) (-1 -9=-1) (-7=-8), gen(relig)

lab val relig relig

*specify if question not asked
replace relig=-8 if relig==. & inlist(wavey, 1992, 1993, 1994, 1995, 1996, 1998, 2000, 2002, 2006, 2007) // not available for some BHPS waves (2-6; 8; 10; 12; 16-17)

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

recode oprlg2 (1=4) (2=3) (3=2) (4/5=1) (-2=-2) (-1 -9=-1) (-7=-8) , gen(relig_att)

lab val relig_att attendance

*specify if question not asked
replace relig_att=-8 if relig_att==. & inlist(wavey, 1992, 1993, 1994, 1995, 1996, 1998, 2000, 2002, 2003, 2005, 2006, 2007, /// not available for some BHPS waves (2-6; 8; 10; 12; 16-17)
	2010, 2011, 2013, 2014, 2015, 2017, 2018, 2019) //rotating module in UKHLS
		 
	 
*################################
*#								#
*#	Weights						#
*#								#
*################################	 
**--------------------------------------
**   Cross-sectional sample weight
**--------------------------------------	
/*

gen wtcs= 

wtcs=indinus_xw  if wave==19 
wtcs=indinus_xw  if wave>=20


  
*/
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

clonevar sampid_ukhls1  =   memorig
clonevar sampid_ukhls2  =   sampst

lab var sampid_ukhls1  "Sample identifier: UKHLS - origin"
lab var sampid_ukhls2  "Sample identifier: UKHLS - status"
 


**|=========================================================================|
**|  KEEP
**|=========================================================================|
keep    					///
wave pid country intyear   age yborn female					///
place  edu3 edu4 edu5 imp_edu			///
mlstat5 marstat5 livpart haspart parstat6 nvmarr		///
respstat  					///
kidsn_hh15 kids_any nphh livpart 					///
work_d emplst5 emplst6	isco* indust*				///
public size5 size5b whweek* whmonth  fptime*					///
supervis mater	un_act	selfemp* entrep2	retf oldpens					///	 
incjobs* incjob1* hhinc_* srh5 disab disab2c chron 				///
satlife5 satwork5 satfinhh5 sathlth5 	///
satlife10 satwork10 satfinhh10 sathlth10 	///
train					///
isced qfhigh_dv  /// edu
jbisco88_cc jbsic ///
jbseg_dv jbrgsc_dv jlseg_dv jlrgsc_dv jbnssec_dv					///
jbnssec8_dv mrjnssec_dv jlnssec_dv mrjnssec8_dv pensioner_dv hhtype_dv 	///
jbiindb_dv jbnssec5_dv jbnssec3_dv jliindb_dv jlnssec5_dv jlnssec3_dv 	///
sf12pcs_dv sf12mcs_dv swemwbs_dv nunmpsp_dv nmpsp_dv nnmpsp_dv 	///isced11_dv
ivfio	/// interview statust 
xrwght xrwghte  indinus_lw 	/// weights xewght lrwght lewght xewghte
indinub_xw indinub_lw indpxui_xw indinui_xw indpxui_lw indinui_lw indscui_lw	///weights
intmonth   jsecu jsecu2	///
wavey	///
divor separ widow	///
migr* ethn* cob*   relig* ///
nempl isei* siops* mps* fedu* medu* sampid_*


order	///
isced qfhigh_dv  /// edu
jbisco88_cc jbsic ///
jbseg_dv jbrgsc_dv jlseg_dv jlrgsc_dv jbnssec_dv					///
jbnssec8_dv mrjnssec_dv jlnssec_dv mrjnssec8_dv pensioner_dv hhtype_dv 	///
jbiindb_dv jbnssec5_dv jbnssec3_dv jliindb_dv jlnssec5_dv jlnssec3_dv 	///
sf12pcs_dv sf12mcs_dv swemwbs_dv nunmpsp_dv nmpsp_dv nnmpsp_dv 	/// isced11_dv
xrwght  indinus_lw 	/// weights lrwght lewght xrwghte xewghte xewght
indinub_xw indinub_lw indpxui_xw indinui_xw indpxui_lw indinui_lw indscui_lw	///weights
ivfio sampid_*	/// interview statust 
, last

**|=========================================================================|
**|  SAVE
**|=========================================================================|
 
label data "CPF_UK v1.5"	 	 
save "${ukhls_out}\uk_02_CPF.dta", replace  	

	 
*____________________________________________________________________________
*--->	END	 <---


