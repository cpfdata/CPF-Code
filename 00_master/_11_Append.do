/*
===============================================================================
>> CPF Version 2.0 
File: "_12_ Append.do"
Purpose: 
- This is a lower-level code to run automatically from 2_CPF_Main__Fill_and_run.do
- Append all country-specific CPF files prepared with sytnaxes 01-03 withn countires 
  (files: country_03_CPF.dta)
Input:  Country-specific CPF files `country'_03_CPF.dta
Output: CPFvX.dta (all surveys selected in the 01 do file)
===============================================================================
Author:  Konrad Turek
Date:    07.2025
===============================================================================
*/


*################################################################################
*#
*#	Append country-specific CPF files					
*#							
*################################################################################

*
clear
local data= "$surveys"	// hilda klips psid shp soep ukhls liss
foreach data in  `data' {
	append 	using "${`data'_out}//${`data'2}_03_CPF.dta"	 
}


*################################################################################
*#
*#	Keep variables					
*#							
*################################################################################
/*
+++++++++++++
- Workflow D: Add here new variable names
+++++++++++++
*/
* Install isvar by Nicholas J. Cox, Durham University, U.K., n.j.cox@durham.ac.uk

cap which isvar
if _rc ssc install isvar

isvar  	///		
    pid wave intyear country age 				///
    eduy edu3 edu4 edu5 edu5v2 				///
    female nphh livpart work_py work_d 			///
    isco_1 isco_2 								///
    indust1 indust2 indust3 whyear fptime_h 	///
    hhinc_pypre hhinc_pypost hhinc_pypost_eq*	///
    srh5 sathlth5 sathlth10 					///
    satlife5 satlife10 						///
    wavey intmonth respstat yborn 				///
    marstat5 mlstat5 parstat6 nvmarr 			///
    kidsn_hh17 kidsn_hh15 kidsn_all kids_any 	///
    emplst5 emplst6 public size5b 				///
    whweek whmonth fptime_r supervis mater un_act ///
    selfemp entrep2 retf* oldpens disabpens 	///
    exp exporg inctot* disab chron 				///
    satfinhh5 satfinhh10 						///
    satinc5 satinc10 							///
    satwork5 satwork10 train 					///
    jsecu jsecu2 size5 whweek_ctr incjob* 		///
    satfam5 satfam10 eduwork wqualif 			///
    isco08_4 isco88_4 							///
    size size4 expft neverw disab2c whday 		///
    entrep isco88_3 exppt 						///
    isei* siops* mps* 							///
    widow divor separ fedu* medu* 				///
    ethn* migr* cob* grewup_US relig* 			///
    sampid* 									///
    kidsn_hh_02 kidsn_hh_34 kidsn_hh_04 		///
    kidsn_hh_510 kidsn_hh_511 					///
    kids_hh_04 youngest_hh oldern_hh70 			///
    oldern_hh80 kidsown_04
		
keep `r(varlist)'		



**--------------------------------------
** Adds pid-prefix by country
**-------------------------------------- 			

rename pid orgpid

*
tostring orgpid, gen(pid_temp)
generate str pid = ""

tokenize "10 20 30 50 60 70 80" 
	foreach c of num 1 2 3  5 6 7 8	{
		replace pid="`1'"+pid_temp if country==`c'
	macro shift 1  
	}
destring pid, replace
format pid  %14.0g
*
* check if no overlap between countries 
// bysort pid: egen temp=sd(country)
// 	tab temp
// drop temp
drop pid_temp   

* check if no repeated observations 
// sort pid wave
// quietly by pid wave: gen dup = cond(_N==1,0,_n)
// 	tab dup



*################################################################################
*#
*#	Additional variables					
*#							
*################################################################################

*** Country with no gaps (used in codebook)
recode country (5=4) (6=5) (7=6) (8=7), gen(country2)


*################################################################################
*#
*#	ORDER			
*#							
*################################################################################

/*
+++++++++++++
- Workflow D: Add here new variable names (not required)
+++++++++++++
*/

order 	///
/// 1.	Respondent identifiers		 		///
country	 		///
orgpid		 		///
pid		 		///
wave		 		///
wavey		 		///
intyear		 		///
intmonth		 		///
respstat		 		///
/// 2.	Gender, age		 		///
female	 		///	
age		 		///
yborn		 		///
/// .	Place of living	 		///	
/// place		 		///
/// place2		 		///
/// 3.	Education level	 		///	
edu3		 		///
edu4		 		///
edu5		 		///
edu5v2		 		///
eduy		 		///
/// 4.	Marital and relationship status		 		///
mlstat5		 		///
parstat6		 		///
marstat5		 		///
livpart		 		///
/// haspart		 		///
nvmarr		 		///
widow divor separ	///
/// 5.	Children and household composition		 		///
kidsn_hh17		 		///
kidsn_hh15		 		///
kidsn_all		 		///
kids_any		 		///
kidsn_hh_02 			///
kidsn_hh_34 			/// 			
kidsn_hh_04 			/// 
kidsn_hh_510			///
kidsn_hh_511			///
kids_hh_04  			///
kidsown_04			///
youngest_hh  			///
oldern_hh70  			///
oldern_hh80  			///
nphh		 		///
/// 6.	Labour market situation		 		///
emplst5		 		///
emplst6		 		///
work_d		 		///
work_py		 		///
mater		 		///
neverw		 		///
un_act				///
retf				///
oldpens				///
///7. Self-Employment and Entrepreneurship ///
selfemp	///
entrep	///
entrep2	///
/// 8.	Employment: level		 		///
fptime_h		 		///
fptime_r		 		///
whyear		 		///
whweek		 		///
whmonth		 		///
/// whmonth_dv		 		///
whweek_ctr		 		///
///9.	Employment: Occupation (ISCO) and position		 		///
isco_1		 		///
isco_2		 		///
isco08_4		 		///
isco88_4		 		///
isco88_3		 		///
supervis		 		///
/// 10.	Employment: Industry and sector of organization		 		///
indust1		 		///
indust2		 		///
indust3		 		///
public		 		///
/// 11.	Employment: size of organization		 		///
size		 		///
size4		 		///
size5		 		///
size5b		 		///
/// 12.	Individual income		 		///
inctot_yn		 		///
inctot_mn		 		///
incjobs_pyg		 		///
incjobs_pyn		 		///
incjobs_cyg		 		///
incjobs_mn		 		///
incjobs_mg		 		///
incjob1_pyg		 		///
incjob1_cyn		 		///
incjob1_cyg		 		///
incjob1_mg		 		///
incjob1_mn		 		///
incjob1_hg		 		///
/// 13.	Household income		 		///
hhinc_pypre		 		///
hhinc_pypost		 		///
hhinc_pypost_eq		/// + hhinc_pypost_eq_UK ?
/// 14.	Labor market experience		 		///
exp		 		///
exporg		 		///
expft		 		///
exppt		 		///
/// 15. Health		 		///
srh5		 		///
disabpens		 		///
disab		 		///
disab2c		 		///
chron		 		///
/// 16.	Satisfaction		 		///
sat*	 		///
/// 17.	Training and qualifications		 		///
train		 		///
eduwork		 		///
wqualif		 		///
/// 18.	Job security		 		///
jsecu		 		///
jsecu2		 	///
/// 19. SES indices ///
 isei* siops* mps*  ///
/// 20. Parents ///
fedu* medu* ///
/// 21. Ethnicity ///
ethn ///
ethn_hisp ///
/// 22. Migration ///
migr ///
cob ///
grewup_US ///
migr_f migr_m ///
cob_f cob_m ///
migr_gen ///
/// 23.Religion
relig ///
relig_att ///
relig_KOR ///
/// 24. Weights, 25.sampid ///
sampid*			///
, first		
		


*################################################################################
*#
*#	SAVE 
*#							
*################################################################################



label data "CPF v${cpfv}"	 	
save "${CPF_out}/CPFv${cpfv}.dta", replace  		

