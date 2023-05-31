*
**|=====================================|
**|	    ####	CPF	v1.5	####		|
**|		>>>	SOEP						|
**|		>>	Prepare data + Merge		|
**|-------------------------------------|
**|		Konrad Turek 	| 	2023		|
**|=====================================|
*




*############################
*#							#
*#	Master - ppathl.dta		#
*#							#
*############################
*
use "${soep_in}\ppathl.dta", clear

keep 					///
pid hid syear piyear	///
netto nett1 			/// values 10-19 (netto) -> realized interviews
phrf 					/// weighting variable
sex gebjahr todjahr 	///
erstbefr				/// first year interviewed 
parid partner 			/// partner id and status 
psample					/// Sample Member 
germborn                /// born in germany (migr1)
corigin                 /// COB respondent
*
sort  pid syear
*
save "${soep_out_work}\gppathl_1.dta", replace  	


*############################
*#							#
*#		hpathl.dta			#
*#							#
*############################
use hid syear hnetto hpop hbleib hhrf using ///
	"${soep_in}\hpathl.dta", clear
*
sort  hid syear
* 
save "${soep_out_work}\ghpathl_1.dta", replace  	

*############################
*#							#
*#		pgen.dta			#
*#							#
*############################

use "${soep_in}\pgen.dta", clear

keep	pid hid syear	///
/// incomes 
pglabgro  pglabnet 		/// incomes # pgimpgro pgimpnet pgimpsnd	pgsndjob
/// work - general  
pgstib  pglfs 	pgemplst		/// empl. status # 
pgisco08 pgisco88		/// isco 
/// work - details  
pgerwzeit				/// Duration of company membership
pgexpft	pgexppt			/// Labor market experience (full/part)
pgtatzeit 				/// Actual working time per week
pgvebzeit 				/// Contracted working time per week
pguebstd    			/// Overtime per week
pgoeffd   				/// Public sector 
pgnace2					/// Sector: NACE rev2
pgallbet   				/// Company size / pgbetr
/// Unempl  
pgexpue    				/// Job market experience unemployed
/// other
pgisced11 pgisced97 pgcasmin  	/// Educ
/// *** Extra - to consider 
pgisei88 pgmps92 pgsiops88 pgegp88	///SES indices ?
pgerljob 				/// Activity in the learned profession
pgmonth   pgpartnr	/// pgpartz less accurate that partner from ppath
pgfamstd

 

*
sort  pid syear
*
save "${soep_out_work}\gpgen_1.dta", replace  	

*############################
*#							#
*#		health.dta			#
*#							#
*############################
* NOTE: 2002 + only 
*Starting in 2002 the SOEP health module in the individual questionnaire has *been revised and put into a two year replication period. 

use "${soep_in}\health.dta", clear
*

*@remove hhnr
keep	///
pid syear 	///
mcs pcs 			/// PCA scales - chck descr
gh_nbs mh_nbs bmi	//	Z-socre - chck descr
*

*@ pid already in file
*rename persnr pid
*rename hhnr hid
*
sort  pid syear
*
save "${soep_out_work}\ghealth_1.dta", replace  


*############################
*#							#
*#		pequiv.dta			#
*#							#
*############################

use "${soep_in}\pequiv.dta", clear
*
keep	pid hid syear	///
d11104 		d11109		/// 	 to chck
x11103 x11105			///
d11106 d11107			///
e11101 e11102 e11103 e11104 e11105*	///
e11106 e11107			///
i11101 i11102 i11110	///
w11101 w11102 w11103 w11105 w11107 w11108 w11109 w11110 w11111	/// weights
ijob1 ijob2 iself ioldy ieret iprvp igrv1	///
m11124 m11125 m11126	 

*p11101	 
*d11108 				// edu & hi sch (maybe useful)

*
sort  pid syear
*

save "${soep_out_work}\gpequiv_1.dta", replace  
	
*############################
*#							#
*#		pl.dta				#
*#							#
*############################
use "${soep_in}\pl.dta", clear
*
keep	pid hid syear			///
/// SAT
plh0182 plh0173 plh0180 plh0175 plh0176 plh0171 /// 
/// WORK
plb0209 plb0210					/// day w 
plb0193 plb0196_h plb0197 		/// hours over w
plb0022_h 						/// emp stat
plb0018							/// worked last 7 days
p_nace p_nace2 					/// nace
plb0040							/// public
plb0036_h 						/// org exper
plb0057_h*	plb0057_v9			/// self-empl (plb0586>plb0057_v9)
plb0058  plb0064_v1 plb0064_v2 	plb0064_v4 /// work type inclv4
plb0284_h						/// Type Of Job Change (harmonized)
plb0057_v9					/// no of employees (self-empl)	(was plb0570_v8	 )
plh0353_v*   plh0354_h 			/// pay by hour (not precise) 
plb0211							/// flexible arrangements
plh0042							/// job security
/// UNEMPL 	
plb0021 plb0424_v1 plb0424_v2 plb0304_h	///
/// RETIREMENT
plb0282_h    plc0236_h 	/// also plb0304_h(added above)
/// HEALTH
ple0040 ple0041  				/// disabilit
/// OTHER
		/// trainingplg0269_v1 plg0269_v2	
plg0072							/// comleted edu
plg0012_v1	plg0013_v1 plg0013_v3 plg0014_*  	/// in education now addv1
plg0269_v1 plg0269_v2 /// training
pld0133							/// partner in HH 
ple0036							/// chronic
plh0258_h pli0098_h		// Religion



*plb0072						// work-edu link
*plb0022_h						// part-time (already in)
*ple0008							// srh 1-5


*
sort  pid syear
*
 
save "${soep_out_work}\gpl_1.dta", replace  


*############################
*#							#
*#		pkal.dta			#
*#							#
*############################
use "${soep_in}\pkal.dta", clear

keep 					///	INFO abour last year
pid hid syear 			///
kal1e01 kal1e02 		/// employment status as retiree
kal2d01 kal2d02			/// receipt of pension / retirement income in the previous year
kal1d01 kal1d02			/// unemployed registered
kal1a01 kal1a02			/// full-time work
kal1b01 kal1b02			/// part-time work 
kal1c01 kal1c02			//  educ, training 
*
sort  pid syear
*
save "${soep_out_work}\gpkal_1.dta", replace  




*############################
*#							#
*#		biobirth.dta		#
*#		 					#
*############################
use "${soep_in}\biobirth.dta", clear

keep 				///
pid 	/// @changed
sumkids		//

*
sort  pid
* 
save "${soep_out_work}\gbiobirth_1.dta", replace  


*############################
*#							#
*#		biol.dta	     	#
*#		 					#
*############################
use "${soep_in}\biol.dta", clear

keep 				///
pid hid syear	/// 
lb0084_h lb0085_h lr2076		/// parents info & mother tongue

*
sort  pid
* 
save "${soep_out_work}\gbiol_1.dta", replace  



/*############################
*#							#
*#		biocouplm.dta		#
*#		biocouply.dta		#
*#		 					#
*############################
* SPELL Data - NOT USEUFL 
use "${soep_in}\biocouplm.dta", clear
keep hhnr pid cid spelltyp
*
use "${soep_in}\biocouply.dta", clear
 keep hhnr spelltyp pid cid*/

 
 
*############################
*#							#
*#		bioparen.dta		#
*#		 					#
*############################
use "${soep_in}\bioparen.dta", clear

keep 				///
pid 		/// @changed
fsedu msedu fprofedu mprofedu 		///
fisco88 misco88 fisei* misei* fmps* mmps* fsiops* msiops* fegp* megp* 	///
fprofstat mprofstat ///
forigin morigin /// COB parents

// fprofclas* mprofclas*

*
sort  pid
* 
save "${soep_out_work}\gbioparen_1.dta", replace  

**|=========================================================================|

*############################
*#							#
*#		MERGING				#
*#							#
*############################
 

***** HH + P
use "${soep_out_work}\gppathl_1.dta", clear

merge m:1 hid syear using "${soep_out_work}\ghpathl_1.dta" , keep(1 3) nogen	

**** 
merge 1:1 pid syear using "${soep_out_work}\gpgen_1.dta" 	, keep(1 3) nogen	
*
merge 1:1 pid syear using "${soep_out_work}\ghealth_1.dta" , keep(1 3) nogen	
*
merge 1:1 pid syear using "${soep_out_work}\gpequiv_1.dta" , keep(1 3) nogen	
	
merge 1:1 pid syear using "${soep_out_work}\gpl_1.dta" 	, keep(1 3) nogen	
	
merge 1:1 pid syear using "${soep_out_work}\gpkal_1.dta" 	, keep(1 3) nogen	
	
merge m:1 pid  		using "${soep_out_work}\gbiobirth_1.dta" , keep(1 3) nogen	

merge m:1 pid syear		using "${soep_out_work}\gbiol_1.dta" , keep(1 3) nogen	

merge m:1 pid  		using "${soep_out_work}\gbioparen_1.dta" , keep(1 3) nogen

****	
disp "vars: " c(k) "   N: " _N	

*   ---> 	
save "${soep_out}\ge_01.dta", replace  	
	
	
	
*** Delete temp files
!del "${soep_out_work}\*.dta"

*____________________________________________________________________________
*--->	END
