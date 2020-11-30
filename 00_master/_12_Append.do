*
**|=========================================================================|
**|	    ####	CPF	ver 1.0		####										
**|		>>>	_12_ Append
**|-------------------------------------------------------------------------|
**|		Konrad Turek 	| 	2020	|	turek@nidi.nl						|			
**|=========================================================================|


**

*############################
*#							#
*#	Append					#
*#							#
*############################
*** Append all surveys selected in the 01 do file 

*
clear
local data= "$surveys"	// hilda klips psid rlms shp soep ukhls
foreach data in  `data' {
	append 	using "${`data'_out}\\${`data'2}_03_CPF.dta"	 
}


*############################
*#							#
*#	KEEP 					#
*#							#
*############################
/*
+++++++++++++
- Workflow D: Add here new variable names
+++++++++++++
*/
* Install isvar by Nicholas J. Cox, Durham University, U.K., n.j.cox@durham.ac.uk

cap which isvar
if _rc ssc install isvar

isvar  	///		
pid wave intyear country age pid wave intyear country age eduy edu3 edu4 edu5 edu5v2 ///
female  nphh livpart work_py work_d isco_1 isco_2 ///
indust1 indust2 indust3 whyear fptime_h 	///
incjobs_yg hhinc_pre hhinc_post 	///
srh5 sathlth5 sathlth10 satlife5 satlife10 	///
wavey intmonth  respstat yborn place place2 	///
marstat5 mlstat5 parstat6 nvmarr 	///
kidsn_hh17 kidsn_hh15 kidsn_all kids_any emplst5 emplst6 public size5b 	///
whweek whmonth fptime_r supervis mater un_act 	///
 selfemp entrep2 retf*   oldpens disabpens 	///
exp  exporg inctot* disab chron 	///
satfinhh5 satfinhh10 satinc5 satinc10 satwork5 satwork10 train ///
jsecu jsecu2 hid size5 whweek_ctr incjob* ///
satfam5 satfam10 eduwork wqualif isco08_4 isco88_4 isco08_4bis ///
size size4  expft neverw incjob1_hg disab2c whday  ///
entrep incjobs_mn incsubj9    isco88_3 haspart ///
volunt exppt  ///
isei* siops* mps* 	///
widow divor separ fedu* medu* 	///
sampid*
		
keep `r(varlist)'		


capture drop hid isco08_4bis incsubj9 volunt place* haspart // they are not useful 


**--------------------------------------
** Adds pid-prefix by country
**-------------------------------------- 			

rename pid orgpid

*
tostring orgpid, gen(pid_temp)
generate str pid = ""

tokenize "10 20 30 40 50 60 70" 
	foreach c of num 1/7	{
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

**--------------------------------------
** ORDER 
**--------------------------------------
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
/// 3.	Place of living	 		///	
/// place		 		///
/// place2		 		///
/// 4.	Education level	 		///	
edu3		 		///
edu4		 		///
edu5		 		///
edu5v2		 		///
eduy		 		///
/// 5.	Marital and relationship status		 		///
mlstat5		 		///
parstat6		 		///
marstat5		 		///
livpart		 		///
/// haspart		 		///
nvmarr		 		///
widow divor separ	///
/// 6.	Kids and household composition		 		///
kidsn_hh17		 		///
kidsn_hh15		 		///
kidsn_all		 		///
kids_any		 		///
nphh		 		///
/// 7.	Labour market situation		 		///
emplst5		 		///
emplst6		 		///
work_d		 		///
work_py		 		///
mater		 		///
neverw		 		///
/// 8.	Employment: level		 		///
fptime_h		 		///
fptime_r		 		///
whyear		 		///
whday		 		///
whweek		 		///
whmonth		 		///
/// whmonth_dv		 		///
whweek_ctr		 		///
/// 9.	Employment: Occupation (ISCO) and position		 		///
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
incjobs_yg		 		///
incjobs_yn		 		///
incjobs_mn		 		///
incjobs_mg		 		///
incjob1_yn		 		///
incjob1_yg		 		///
incjob1_mg		 		///
incjob1_mn		 		///
incjob1_hg		 		///
/// 13.	Household income		 		///
hhinc_pre		 		///
hhinc_post		 		///
/// 14.	Unemployed		 		///
un_act		 		///
/// 15.	Self-employed		 		///
selfemp		 		///
/// 16.	Entrepreneurship		 		///
entrep		 		///
entrep2		 		///
/// 17.	Retiremen	 		///
retf		 		///
oldpens		 		///
/// 18.	Labor market experience		 		///
exp		 		///
exporg		 		///
expft		 		///
exppt		 		///
/// 19. Health		 		///
srh5		 		///
disabpens		 		///
disab		 		///
disab2c		 		///
chron		 		///
/// 20.	Satisfaction		 		///
sat*	 		///
/// 21.	Training and qualifications		 		///
train		 		///
eduwork		 		///
wqualif		 		///
/// 22.	Job security		 		///
jsecu		 		///
jsecu2		 	///
/// 23. SES indices ///
 isei* siops* mps*  ///
/// 24. Parents
fedu* medu* ///
/// 25. Weights, sampid ///
sampid*			///
, first		
		


**--------------------------------------
** SAVE 
**-------------------------------------- 	
label data "CPF v${cpfv}"	 	
save "${CPF_out}\CPFv${cpfv}.dta", replace  		

