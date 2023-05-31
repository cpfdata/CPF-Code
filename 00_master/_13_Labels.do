*
**|=========================================|
**|	    ####	CPF	v1.5		####		|							
**|		>>>	_13_ labels unifies 			|
**|-----------------------------------------|
**|		Konrad Turek 	| 	2023			|									
**|=========================================|




**--------------------------------------
** Data
**--------------------------------------  
// use "${CPF_out}\CPFv${cpfv}.dta", clear  	

**--------------------------------------
** Remove Val Lables
**--------------------------------------  
// foreach var of varlist _all {
// 	label var `var' ""
// }


*
*############################
*#							#
*#	Var Lables				#
*#							#
*############################
/*
+++++++++++++
- Workflow D: Add here new or modified variables 
+++++++++++++
*/

lab var country "Country"
lab var orgpid "Personal id from original dataset"
lab var pid "CPF personal id number"
lab var wave "Wave nr"
lab var wavey "Wave - main year of data collection"
// lab var wave1st "First wave person included in CPF dataset"
// lab var place "Place of living"
lab var intyear "Year of interview"
lab var intmonth "Month of interview"
lab var female "Gender (female)"
lab var age "Age"
lab var yborn "Birth year"
lab var edu3 "Education: 3 levels"
lab var edu4 "Education: 4 levels"
lab var edu5 "Education: 5 levels"
lab var edu5v2 "Education: 5 levels (v2)"
lab var eduy "Education: years"
lab var marstat5 "Primary partnership status"
lab var mlstat5 "Formal marital status"
lab var livpart "Living together with partner"
lab var parstat6 "Partnership living-status"
// lab var haspart "Has a partner"
lab var nvmarr "Never married"
lab var kidsn_hh17 "Number Of Children in HH aged 0-17"
lab var kidsn_hh15 "Number Of Children in HH aged 0-15"
lab var kidsn_all "Number Of Children Ever Had"
lab var kids_any "Has own children"
lab var mater "Currently on maternity leave"
lab var nphh "Number of People in HH"
lab var work_py "Working: last year (based on hours)"
lab var work_d "Working: currently (based on selfrep)"
lab var emplst5 "Employment status [5]"
lab var emplst6 "Employment status [6]"
lab var isco_1 "Occupation: ISCO 1 digit"
lab var isco_2 "Occupation: ISCO 2 digits"
lab var isco08_4 "Occupation: ISCO-08 4 digits"
lab var isco88_4 "Occupation: ISCO-88 4 digits"
lab var isco88_3 "Occupation: ISCO-88 3 digits"
lab var indust1 "Industry (major groups)"
lab var indust2 "Industry (submajor groups/1 dig)"
lab var indust3 "Industry (minor groups)"
lab var public "Public sector"
lab var size "Size of organization [number of employees]"
lab var size4 "Size of organization [4]"
lab var size5b "Size of organization [5 ver b]"
lab var size5 "Size of organization [5]"
lab var whyear "Work hours per year: worked"
lab var whweek "Work hours per week: worked"
lab var whmonth "Work hours per month: worked"
lab var whweek_ctr "Work hours per week: contracted"
lab var whday "Work hours per day: worked"
lab var fptime_h "Employment Level (</>=35 h/week)"
lab var fptime_r "Employment Level (self-reported)"
lab var supervis "Supervisory position"

lab var inctot_yn "Individual Income (All types, year, net)"
lab var inctot_mn "Individual Income (All types, month, net)"

lab var incjobs_yg "Individual Labor Earnings (All jobs, year, gross)"
lab var incjobs_yn "Individual Labor Earnings (All jobs, year, net)"
lab var incjobs_mn "Individual Labor Earnings (All jobs, month, net)"
lab var incjobs_mg "Individual Labor Earnings (All jobs, month, gross)"

lab var incjob1_yg 	"Salary from main job (year, gross)"
lab var incjob1_yn 	"Salary from main job (year, net)"
lab var incjob1_mg 	"Salary from main job (month, gross) [local currency]"
lab var incjob1_mn 	"Salary from main job (month, net)"

lab var incjob1_hg "Salary from main job (per hour, gross)"

lab var hhinc_pre "HH income(month, pre)"
lab var hhinc_post "HH income(month, post)"


lab var neverw "Never worked"
lab var un_act "Unemployed: actively looking for work"
// lab var un_reg "Unemployed: registered"
// lab var selfemp_v1 "Self-employed 1: all without Family Business"
lab var selfemp "Self-employed 2: all with Family Business"
// lab var selfemp_v3 "Self-employed 3: based on income from self-empl"
lab var entrep2 "Entrepreneur (incl. farmers; has employees)"
lab var entrep "Entrepreneur (not farmer; has employees)"
// lab var nempl	"Number of employees (entrepreneurs)"
lab var retf "Retired fully"
// lab var retf2 "Retired (NW, any pens, 45+)"
lab var oldpens "Receiving old-age pension"
lab var exp "Labor market experience"
// lab var expocc "Experience in occupation"
lab var exporg "Experience in organisation"
lab var expft "Labor market experience: full time"
lab var exppt "Labor market experience: part time"
lab var srh5 "Self-rated health"
lab var disabpens "Receiving disability pension"
lab var disab "Disability (any)"
lab var disab2c "Disability (min. category 2 or >30%)"
lab var chron "Chronic diseases"
lab var sathlth5 "Satisfaction: health [5]"
lab var sathlth10 "Satisfaction: health [10]"
lab var satlife5 "Satisfaction: life [5]"
lab var satlife10 "Satisfaction: life [10]"
lab var satfinhh5 "Satisfaction: financial situation of HH [5]"
lab var satfinhh10 "Satisfaction: financial situation of HH [10]"
lab var satinc5 "Satisfaction: individual income [5]"
lab var satinc10 "Satisfaction: individual income [10]"
lab var satwork5 "Satisfaction: work [5]"
lab var satwork10 "Satisfaction: work [10]"
lab var satfam5 "Satisfaction: family relationship [5]"
lab var satfam10 "Satisfaction: family relationship [10]"
lab var train "Training (previous year)"
lab var eduwork "Work-education skill fit"
lab var respstat "Respondent status"
lab var jsecu "Job insecurity [2]"
lab var jsecu2  "Job insecurity [3]"
lab var wqualif "Qualifications for job"

lab var isei08 "ISEI-08: International Socio-Economic Index of occupational status"
lab var isei88 "ISEI-88: International Socio-Economic Index of occupational status"	
lab var siops08 "SIOPS: Treiman's international prestige scale" 
lab var siops88 "SIOPS-88: Treiman's international prestige scale" 
lab var mps88 "MPS (German Magnitude Prestige Scale)"
	
lab var fedu3 "Father's education: 3 levels"
lab var fedu4 "Father's education: 4 levels"
lab var medu3 "Mother's education: 3 levels"
lab var medu4 "Mother's education: 4 levels"

lab var ethn "Ethnicity"
lab var ethn_hisp "Hispanicity (US only)"
lab var cob "Country of birth (global region)"
lab var grewup_US "Grew up in US y/n (US only)"
lab var cob_f "Father's country of birth (global region)"
lab var cob_m "Mother's country of birth (global region)"

lab var migr "Migration background: foreign-born yes/no"
lab var migr_f "Father's migration background"
lab var migr_m "Mother's migration background"
lab var migr_gen "Migrant generation"
//lab var langchild "Language spoken as a child"

lab var relig "Religiosity"
lab var relig_att "Attendence of religious services"
lab var relig_KOR "Religious participation (KOR only)"


// lab var wtcs "Cross-sectional sample weight"
// lab var wtcp "Cross-sectional population weight"

// lab var volunt "Volunteering"

*############################
*#							#
*#	Val Labels				#
*#							#
*############################
/*
+++++++++++++
- Workflow D: Add here new or modified variables 
+++++++++++++
*/


**--------------------------------------
** Val Lables Define
**--------------------------------------   

lab def yesno 0 "[0] No" 1 "[1] Yes" ///
	-1 "[-1] MV gen" -2 "[-2] Item nresp" ///
	-3 "[-3] Not apply" -8 "[-8] Not asked ", replace
	
lab def country 1 "[1] Australia" 2 "[2] Korea" 3 "[3] USA" 4 "[4] Russia" ///
				5 "[5] Switzerland" 6 "[6] Germany" 7 "[7] UK" , replace

lab def respstat 	1 "Interviewed" 					///
					2 "Not interviewed (has values)" 	///
					3 "Not interviewed (no values)", replace
					
lab def female 0 "Male" 1 "Female" , replace
// lab def place 1 "city" 2 "rural area", replace

lab def edu3  	1 "[0-2] Low" 2 "[3-4] Medium" 3 "[5-8] High"  , replace
lab def edu4  	1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				3 "[3-4] Secondary upper" 4 "[5-8] Tertiary" , replace
lab def edu5  	1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				3 "[3-4] Secondary upper" ///
				4 "[5-6] Tertiary lower(bachelor)"  ///
				5 "[7-8] Tertiary upper (master/doctoral)", replace
lab def edu5v2  1 "[0-1] Primary" 2 "[2] Secondary lower" ///
				3 "[3-4] Secondary upper" ///
				4 "[5-7] Tertiary first(bachelor/master)"  ///
				5 "[8] Tertiary second (doctoral)", replace
lab def mlstat5				///
				1	"Married/registered"	///
				2	"Never married" 		///
				3	"Widowed" 				///
				4	"Divorced" 				///
				5	"Separated" 			///
				-1 "[-1] MV gen" -2 "[-2] Item nresp" ///
				-3 "[-3] Not apply" -8 "[-8] Not asked ", replace
lab def marstat5				///
				1	"Married or Living with partner"	///
				2	"Single" 				///
				3	"Widowed" 				///
				4	"Divorced" 				///
				5	"Separated" 			///
				-1 "[-1] MV gen" -2 "[-2] Item nresp" ///
				-3 "[-3] Not apply" -8 "[-8] Not asked "	, replace			
lab def parstat6				///
				1	"Married/registered, with P"	///
				2	"Cohabiting (Not married, Living with P)"				///
				3	"Single, No P" 				///
				4	"Widowed, No P" 				///
				5	"Divorced, No P" 			///
				6	"Separated, No P" 			///
				-1 "[-1] MV gen" -2 "[-2] Item nresp" ///
				-3 "[-3] Not apply" -8 "[-8] Not asked ", replace
				
lab def emplst5	///
			1 "Employed" 			/// including leaves
			2 "Unemployed (active)"	///					@@@@@@ maybe delete 'active'? 
			3 "Retired, disabled"	///
			4 "Not active/home"		///  
			5 "In education"		///
			-1 "MV", replace
lab def emplst6	///
			1 "Employed" 			///  
			2 "Unemployed (active)"	///
			3 "Retired, disabled"	///
			4 "Not active/home"		///  
			5 "In education"		///
			6 "On leave (employed)" ///
			-1 "MV", replace

 			
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
		  -2 "[-2] Item nresp"				 							///	
		  -3 "[-3] Does not apply", replace
		  
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
		-2 "[-2] Item nresp"				 							///	
		-3 "[-3] Does not apply", replace	  
		
lab def indust1											///
           1 "[1] Production, Construction, Heavy Ind"	///
           2 "[2] Trade and Services"					///
		   3 "[3] Public services"						///
		  -1 "[-1] MV general"							///
		  -2 "[-2] Item nresp"				 			///	
  		  -3 "[-3] Does not apply", replace	  

lab def indust2						///
           1 "[1] Agriculture"		///
           2 "[2] Energy"			///
           3 "[3] Mining"			///
           4 "[4] Manufacturing"	///
           5 "[5] Construction"		///
           6 "[6] Trade"			///
           7 "[7] Transport"		///
           8 "[8] Bank, Insurance"	///
           9 "[9] Services"			///
          10 "[10] Other"			///
		  -1 "[-1] MV general"		///
		  -2 "[-2] Item nresp"		///	
		  -3 "[-3] Does not apply", replace	  
lab def indust3											///
           1 "[1] Agriculture, hunting, forestry"	///
           2 "[2] Fishing and fish farming"	///
           3 "[3] Mining and quarrying"	///
           4 "[4] Manufacturing"	///
           5 "[5] Electricity, gas and water supply"	///
           6 "[6] Construction"	///
           7 "[7] Wholesale, retail; repair; other services"	///
           8 "[8] Hotels and restaurants"	///
           9 "[9] Transport, storage and communication"	///
          10 "[10] Financial intermediation; insurance"	///
          11 "[11] Real estate; renting; computer; research"	///
          12 "[12] Public admin, national defense; compulsory social security"	///
          13 "[13] Education"	///
          14 "[14] Health and social work"	///
          15 "[15] Other community, social and personal service activities"	///
          16 "[16] Private households with employed persons"	///
          17 "[17] Extra-territorial organizations and bodies"	///
		  -1 "[-1] MV general"							///
		  -2 "[-2] Item nresp"				 			///	
		  -3 "[-3] Does not apply", replace	  
		  
lab def size4 1 "<20" 2 "20-199" 3 "200-1999" 4 "2000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "[-1] MV gen" -2 "[-2] Item nresp" 	///
				-3 "[-3] Not apply" -8 "[-8] Not asked " , replace
lab def size5 1 "<10" 2 "10-49" 3 "50-99" 4 "100-999" 5 "1000+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "[-1] MV gen" -2 "[-2] Item nresp" 	///
				-3 "[-3] Not apply" -8 "[-8] Not asked " , replace
lab def size5b 1 "<10" 2 "10-49" 3 "50-99" 4 "100-499" 5 "500+"  	///
				 0	"Self-empl, no coworkers"	/// not clear in some datasets 
				-1 "[-1] MV gen" -2 "[-2] Item nresp" 	///
				-3 "[-3] Not apply" -8 "[-8] Not asked ", replace 

lab def fptime 1 "Full-time" 2 "Part-time/irregular" 3 "Not empl/other", replace
lab def srh5 5 "Very bad" 4 "Bad" 3 "Satisfactory" 2 "Good" 1 "Very good", replace

lab def sat5 1 "1 Completely dissat" 2 "2 Mostly dissat" 3 "3 Neutral" 	///
				 4  "4 Mostly sat" 5 "5 Completely sat"						///
				 -1 "[-1] MV gen" -2 "[-2] Item nresp" 		 		///
				 -3 "[-3] Not apply" -8 "[-8] Not asked ", replace
	 

lab def sat10 0 "0 Completely dissat" 5 "5 Neutral" 10 "10 Completely sat" ///
				 -1 "[-1] MV gen" -2 "[-2] Item nresp" 		 ///
				 -3 "[-3] Not apply" -8 "[-8] Not asked ", replace
 
lab def eduwork 0 "0 Poor" 1 "1 Good" ///
					-1 "[-1] MV gen" -2 "[-2] Item nresp" ///
					-3 "[-3] Not apply" -8 "[-8] Not asked " , replace
					
lab def wqualif 1 "1 Underqualified/Not qualified" 2 "2 Qualified (fit)" 3 "3 Overqualified" ///
					-1 "[-1] MV gen" -2 "[-2] Item nresp" ///
					-3 "[-3] Not apply" -8 "[-8] Not asked " , replace
lab def jsecu 	 1 "Insecure" 0 "Secure"  ///
					-1 "[-1] MV gen" -2 "[-2] Item nresp" ///
					-3 "[-3] Not apply" -8 "[-8] Not asked ", replace 
					
lab def jsecu2 	 1 "Insecure" 0 "Secure" 2 "Hard to say" ///
					-1 "[-1] MV gen" -2 "[-2] Item nresp" ///
					-3 "[-3] Not apply" -8 "[-8] Not asked ", replace 
					
label define ethnicity ///
				1 "Black" 	2 "White" ///
				3 "Asian" 	4 "Mixed (UK only)" ///
				5 "American Indian (US only)" 	6 "Other" ///
				-1 "MV General" -2 "Item non-response" ///
				-3 "Does not apply" -8 "Question not asked in survey", ///
replace

lab def migr ///
				0 "Native-born" 	1 "Foreign-born" ///
				-1 "MV General" -2 "Item non-response" ///
				-3 "Does not apply" -8 "Question not asked in survey" .a "[.a] missing: grewup_US available", ///
replace
					
label define COB ///
				0 "Born in Survey-Country" 	1 "Oceania and Antarctica" ///
				2 "North-West Europe" 	3 "Southern and Eastern Europe" ///
				4 "North Africa and the Middle East" 	5 "South-East Asia" ///
				6 "North-East Asia" 	7 "Southern and Central Asia" ///
				8 "Americas" 	9 "Sub-Saharan Africa" ///
				10 "Other" 	///
				-1 "MV general" -2 "Item non-response" ///
				-3 "Does not apply" -8 "Question not asked in survey" .a "[.a] missing: grewup_US available", ///
replace

lab def migr_gen ///
				0 "No migration background" 	1 "1st generation" ///
				2 "2st generation" 	3 "2.5th generation" ///
				4 "Incomplete information parents", ///
replace

lab def langchild ///
				0 "Same as country of residence" 	1 "Other language" ///
				-1 "MV general" -2 "Item non-response" ///
				-3 "Does not apply" -8 "Question not asked in survey", ///
replace

lab def relig ///
				0 "Not religious/Atheist/Agnostic" 1 "Religious" ///
				-1 "MV general" -2 "Item non-response" ///
				-3 "Does not apply" -8 "Question not asked in survey", ///
replace

lab def attendance ///
				1 "Never or practically never" 	2 "Less than once a month" ///
				3 "At least once a month" 	4 "Once a week or more" ///
				-1 "MV general" 	-2 "Item non-response" ///
				-3 "Does not apply" 	-8 "Question not asked in survey", ///
replace
					
**--------------------------------------
** Val Lables Apply
**--------------------------------------   	
/*
+++++++++++++
- Workflow D: Add here new or modified variables 
+++++++++++++
*/

			
lab val country country
// lab val place place
lab val female yesno
lab val edu3 fedu3 medu3 edu3
lab val edu4 fedu4 medu4 edu4
lab val edu5 edu5
lab val marstat5 marstat5
lab val mlstat5 mlstat5
lab val livpart yesno
lab val parstat6 parstat6
// lab val haspart yesno
lab val nvmarr yesno
lab val kids_any yesno
lab val mater yesno
lab val work_py yesno
lab val work_d yesno
lab val emplst5 emplst5
lab val emplst6 emplst6
lab val isco_1 isco_1
lab val isco_2 isco_2
lab val isco08_4 isco08_4
lab val isco88_4 isco88_4
lab val isco88_3 isco88_3
lab val indust1 indust1
lab val indust2 indust2
lab val indust3 indust3
lab val public yesno
lab val size4 size4
lab val size5b size5b
lab val size5 size5
lab val fptime_h fptime
lab val fptime_r fptime
lab val supervis yesno
lab val neverw yesno
lab val un_act yesno
// lab val un_reg yesno
// lab val selfemp_v1 yesno
lab val selfemp yesno
// lab val selfemp_v3 yesno
lab val entrep2 yesno
lab val entrep yesno
lab val retf yesno
// lab val retf2 yesno
// lab val retf_AUS yesno
lab val oldpens yesno
lab val srh5 srh5
lab val disabpens yesno
lab val disab yesno
lab val disab2c yesno
lab val chron yesno
lab val sathlth5 sathlth5
lab val sathlth10 sathlth10
lab val satlife5 satlife5
lab val satlife10 satlife10
lab val satfinhh5 satfinhh5
lab val satfinhh10 satfinhh10
lab val satinc5 satinc5
lab val satinc10 satinc10
lab val satwork5 satwork5
lab val satwork10 satwork10
lab val satfam5 satfam5
lab val satfam10 satfam10
lab val train yesno
lab val eduwork eduwork
lab val respstat respstat
lab val jsecu jsecu
lab val jsecu2 jsecu2
lab val wqualif wqualif
lab val cob cob_f cob_m COB
lab val migr migr_f migr_m migr
//lab val langchild langchild
lab val ethn ethnicity
lab val relig relig
lab val relig_att attendance
// lab val volunt yesno



*############################
*#							#
*#	Save					#
*#							#
*############################
save "${CPF_out}\CPFv${cpfv}.dta", replace  		