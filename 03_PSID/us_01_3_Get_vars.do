*
**|=========================================|
**|	    ####	CPF			####			|
**|		>>>	PSID						 	|
**|		>>	Use with 'psidtools'			|
**|-----------------------------------------|
**|		Konrad Turek 	| 	2023			|			
**|=========================================|
* 
// https://simba.isr.umich.edu/default.aspx



*** Create pid in psid_org if not created before 
// use "${psid_org}", clear 
// gen pid=(ER30001*1000)+ER30002	
// save "${psid_org}", replace 



**|=========================================================================|
**|  Step 1: Define program to be used in this syntax						|
**|=========================================================================|
*** program combvars: 
/* Use "combvars" to:
- combine vars across waves, 
- reshape to long (using psidtools)
- save as a separate file
- add name to global macro for further use (merging)
*/

capture program drop combvars

program define combvars
	syntax namelist, list(string)
		global vars $vars `namelist'
		psid use ///
			|| `namelist' `list' ///
			using "${psidtools_in}", clear keepnotes  design(any)
		sort x11101ll
		psid long
// 		reshape long  x11102_ xsqnr_ `namelist'  , i(x11101ll) j(year)
		save "${psid_out_work}\temp_`namelist'.dta", replace 
end
	
	
**** MUST USE!!!!
global vars ""



**|=========================================================================|
**|  Step 2: Run combvars to combine vars across waves
**|=========================================================================|

	
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
combvars age, list("[68]ER30004 [69]ER30023 [70]ER30046 [71]ER30070 [72]ER30094 [73]ER30120 [74]ER30141 [75]ER30163 [76]ER30191 [77]ER30220 [78]ER30249 [79]ER30286 [80]ER30316 [81]ER30346 [82]ER30376 [83]ER30402 [84]ER30432 [85]ER30466 [86]ER30501 [87]ER30538 [88]ER30573 [89]ER30609 [90]ER30645 [91]ER30692 [92]ER30736 [93]ER30809 [94]ER33104 [95]ER33204 [96]ER33304 [97]ER33404 [99]ER33504 [01]ER33604 [03]ER33704 [05]ER33804 [07]ER33904 [09]ER34004 [11]ER34104 [13]ER34204 [15]ER34305 [17]ER34504 [19]ER34704")



* Birth year
// - For <83 get rom age
// - Fill MV across waves 
combvars yborn, list("[83]ER30404 [84]ER30434 [85]ER30468 [86]ER30503 [87]ER30540 [88]ER30575 [89]ER30611 [90]ER30647 [91]ER30694 [92]ER30738 [93]ER30811 [94]ER33106 [95]ER33206 [96]ER33306 [97]ER33406 [99]ER33506 [01]ER33606 [03]ER33706 [05]ER33806 [07]ER33906 [09]ER34006 [11]ER34106 [13]ER34206 [15]ER34307 [17]ER34506 [19]ER34706")



**--------------------------------------
** Place of living (e.g. size/rural) NA
**-------------------------------------- 
* place
// place - filled with 0 in public releas:
// global place "[85]V12382 [86]V13634 [87]V14681 [88]V16155 [89]V17541 [90]V18892 [91]V20192 [92]V21498 [93]V23330 [94]ER4157A [95]ER6997A [96]ER9248A [97]ER12221A [99]ER16431 [01]ER20377 [03]ER24144 [05]ER28043 [07]ER41033 [09]ER46975 [11]ER52399 [13]ER58217 [15]ER65453 [17]ER71532"
//
// place2only 94-03:
// global place2 [94]ER4157F [95]ER6997F [96]ER9248F [97]ER12221F [99]ER16431C [01]ER20377C [03]ER24144A [05]ER28043A [07]ER41033A [09]ER46975A [11]ER52399A [13]ER58216"



**-------------------------------------- 
** Education 
**--------------------------------------
* eduy

combvars eduy_f , list("[68]ER30010 [70]ER30052 [71]ER30076 [72]ER30100 [73]ER30126 [74]ER30147 [75]ER30169 [76]ER30197 [77]ER30226 [78]ER30255 [79]ER30296 [80]ER30326 [81]ER30356 [82]ER30384 [83]ER30413 [84]ER30443 [85]ER30478 [86]ER30513 [87]ER30549 [88]ER30584 [89]ER30620 [90]ER30657 [91]ER30703 [92]ER30748 [93]ER30820 [94]ER33115 [95]ER33215 [96]ER33315 [97]ER33415 [99]ER33516 [01]ER33616 [03]ER33716 [05]ER33817 [07]ER33917 [09]ER34020 [11]ER34119 [13]ER34230 [15]ER34349 [17]ER34548 [19]ER34752")
// What is the highest grade or year of school that (you/he/she) has completed?
// This variable contains values for Reference Persons/Spouses/Partners and OFUMs aged 16 years or older who were in the Family Unit in the prior year.
//
// The values for this variable represent the actual grade of school completed; e.g., a value of 08 indicates that this individual completed the eighth grade by the time of the 2017 interview.
//
// The values for 2017 Reference Persons/Spouses/Partners are pulled from 2017 family-level data. Beginning in the 2013 Wave, we asked for an education update for our returning Reference Persons/Spouses/Partners. If additional educational attainment was reported, we updated their education variables in the background section and reported the year of the education update on the Family file (see variables "Year Highest Education Updated", ER70753, for Spouses/Partners, and ER70891, for Reference Persons).
//
// The values for 2017 OFUMs are derived as follows: for new Reference Persons/Spouses/Partners/eligible OFUMS: uses variables that correspond to the main education series (KL43/G88a - KL61b/G88m); for returning Reference Persons/Spouses/Partners/eligible OFUMs: uses variables that correspond to the updated education series (KL74/G88n - KL83b/G88bb). These data are parallel as of the 2015 Wave.
//
// This variable differs from the family-level variables ER71538 (Reference Person) and ER71539 (Spouse/Partner) in the treatment of Reference Persons and Spouses/Partners who received a GED but did not attend college. The value for the family-level variable is the grade completed; for this individual-level variable, the value is 12. Similarly, for OFUMs, this variable differs from G88c1 (ER34522) in the treatment of OFUMs who received a GED (G88b1=2) but the value derived from G88c1 is less than 12 years; that is, G88c1 retains the grade completed but the value for this variable is coded as 12.

// A code value of 17 indicates that the person completed at least some postgraduate education

combvars eduyBH , list("[75]V4093 [76]V4684 [77]V5608 [78]V6157 [79]V6754 [80]V7387 [81]V8039 [82]V8663 [83]V9349 [84]V10996 [91]V20198 [92]V21504 [93]V23333 [94]ER4158 [95]ER6998 [96]ER9249 [97]ER12222 [99]ER16516 [01]ER20457 [03]ER24148 [05]ER28047 [07]ER41037 [09]ER46981 [11]ER52405 [13]ER58223 [15]ER65459 [17]ER71538 [19]ER77599")
//  Reference Person's Completed Education Level

/*
Values in the range 1-16 represent the actual grade of school completed; e.g., a value of 8 indicates that the Reference Person completed the eighth grade.


Values were computed as follows: If it is not known whether Reference Person attended college (ER70904=8 or 9) or the number of years of college is unknown (ER70907=8 or 9), then the value is 99. Otherwise, if Reference Person attended college (ER70904=1), then the value is 12 plus the number of years of college attended (ER70907). Otherwise, if Reference Person did not attend college, (ER70904=5), the values are as follows:

(a) if Reference Person is a high school graduate (ER70893=1), the value is 12;

(b) if Reference Person received a GED (ER70893=2), the value is the last grade finished (ER70896);

(c) if Reference Person neither graduated from high school nor got a GED (ER70893=3), the value is the last grade finished (ER70901);

(d) if it is not known whether Reference Person graduated from high school, got a GED, or neither (ER70893=8 or 9), then the value is 99.

Education is asked only when the FU acquires a new Reference Person/Spouse/Partner. In cases where the Reference Person has retained the same designation of Reference Person/Spouse/Partner from the previous interview (ER70841=5), this variable has been carried forward from previous years' data. If Reference Person/Spouse/Partner reports updated education and it is higher than previously reported, then this variable is updated. Education was reasked of all Reference Persons in 1985 and 2009 and, as of 2015, all returning Reference Persons/Spouses/Partners are asked for an updated education report every wave. Please refer to variable Year Highest Education was Updated-Reference Person (ER70891) for recency of updated education information.

This variable differs from the individual level variableER34349 in the treatment of Reference Persons who received a GED but did not attend college. The family-level variable value for such Reference Persons is the grade completed; for the individual-level variable, the value is 12.


*/



**--------------------------------------
** Marital status 	   
**--------------------------------------

combvars marstat , list("[68]V239 [69]V607 [70]V1365 [71]V2072 [72]V2670 [73]V3181 [74]V3598 [75]V4053 [76]V4603 [77]V5650 [78]V6197 [79]V6790 [80]V7435 [81]V8087 [82]V8711 [83]V9419 [84]V11065 [85]V12426 [86]V13665 [87]V14712 [88]V16187 [89]V17565 [90]V18916 [91]V20216 [92]V21522 [93]V23336 [94]ER4159A [95]ER6999A [96]ER9250A [97]ER12223A [99]ER16423 [01]ER20369 [03]ER24150 [05]ER28049 [07]ER41039 [09]ER46983 [11]ER52407 [13]ER58225 [15]ER65461 [17]ER71540 [19]ER77601")
// Marital Status of 2017 Reference Person
/*
1	Married
2	Single
3	Widowed
4	Divorced
5	Separated
8 	Married, spouse absent
9	NA
---
1	Married or permanently cohabiting; spouse, partner is present in the FU
2	Single, never legally married and no spouse, partner is present in the FU
3	Widowed and no spouse, partner is present in the FU
4	Divorced and no spouse, partner is present in the FU
5	Separated; legally married but no spouse, partner is present in the FU (the spouse may be in an institution)
*/

combvars marstatH2 , list("[77]V5502 [78]V6034 [79]V6659 [80]V7261 [81]V7952 [82]V8603 [83]V9276 [84]V10426 [85]V11612 [86]V13017 [87]V14120 [88]V15136 [89]V16637 [90]V18055 [91]V19355 [92]V20657 [93]V22412 [94]ER2014 [95]ER5013 [96]ER7013 [97]ER10016 [99]ER13021 [01]ER17024 [03]ER21023 [05]ER25023 [07]ER36023 [09]ER42023 [11]ER47323 [13]ER53023 [15]ER60024 [17]ER66024 [19]ER72024")
// 	HEAD MARITAL STATUS
// 1	Married
// 2	Never married
// 3	Widowed
// 4	Divorced, annulled
// 5	Separated
// 8	DK
// 9	NA; refused


**--------------------------------------
** Never marr 	! NA, can calculate
**--------------------------------------
* nvmarr

**--------------------------------------
** Year married	 ! Probably can retreive 
**--------------------------------------
* ymarr 

		
**--------------------------------------
** Children 
**--------------------------------------
*  
combvars  kidshh , list("[68]V398 [69]V550 [70]V1242 [71]V1945 [72]V2545 [73]V3098 [74]V3511 [75]V3924 [76]V4439 [77]V5353 [78]V5853 [79]V6465 [80]V7070 [81]V7661 [82]V8355 [83]V8964 [84]V10422 [85]V11609 [86]V13014 [87]V14117 [88]V15133 [89]V16634 [90]V18052 [91]V19352 [92]V20654 [93]V22409 [94]ER2010 [95]ER5009 [96]ER7009 [97]ER10012 [99]ER13013 [01]ER17016 [03]ER21020 [05]ER25020 [07]ER36020 [09]ER42020 [11]ER47320 [13]ER53020 [15]ER60021 [17]ER66021 [19]ER72021")
 
// Number of Children Under 18 Living with Family

**--------------------------------------
** People in HH F14
**--------------------------------------

combvars  nphh , list("[68]V115 [69]V549 [70]V1238 [71]V1941 [72]V2541 [73]V3094 [74]V3507 [75]V3920 [76]V4435 [77]V5349 [78]V5849 [79]V6461 [80]V7066 [81]V7657 [82]V8351 [83]V8960 [84]V10418 [85]V11605 [86]V13010 [87]V14113 [88]V15129 [89]V16630 [90]V18048 [91]V19348 [92]V20650 [93]V22405 [94]ER2006 [95]ER5005 [96]ER7005 [97]ER10008 [99]ER13009 [01]ER17012 [03]ER21016 [05]ER25016 [07]ER36016 [09]ER42016 [11]ER47316 [13]ER53016 [15]ER60016 [17]ER66016 [19]ER72016")
 
//  Number of people (children plus adults) in this FAMILY UNIT (living here) (from listing box)


**--------------------------------------
** Living together with partner  
**--------------------------------------
* livpart

	
	
*################################
*#								#
*#	Labour market situation		#
*#								#
*################################
 
**--------------------------------------
** Currently working 
**--------------------------------------
* work_py  work_d

	
	
**--------------------------------------
** Employment Status 
**--------------------------------------
* Till 1975 only for HEAD

combvars  emplst_IND , list("[79]ER30293 [80]ER30323 [81]ER30353 [82]ER30382 [83]ER30411 [84]ER30441 [85]ER30474 [86]ER30509 [87]ER30545 [88]ER30580 [89]ER30616 [90]ER30653 [91]ER30699 [92]ER30744 [93]ER30816 [94]ER33111 [95]ER33211 [96]ER33311 [97]ER33411 [99]ER33512 [01]ER33612 [03]ER33712 [05]ER33813 [07]ER33913 [09]ER34016 [11]ER34116 [13]ER34216 [15]ER34317 [17]ER34516 [19]ER34716")
 
// 1	Working now
// 2	Only temporarily laid off
// 3	Looking for work, unemployed
// 4	Retired
// 5	Permanently disabled
// 6	Keeping house
// 7	Student
// 8	Other
// 9	DK; NA; refused
// 0	Inap

combvars  emplst_H , list("[68]V196 [69]V639 [70]V1278 [71]V1983 [72]V2581 [73]V3114 [74]V3528 [75]V3967 [76]V4458 [77]V5373 [78]V5872 [79]V6492 [80]V7095 [81]V7706 [82]V8374 [83]V9005 [84]V10453 [85]V11637 [86]V13046 [87]V14146 [88]V15154 [89]V16655 [90]V18093 [91]V19393 [92]V20693 [93]V22448 [94]ER2068 [95]ER5067 [96]ER7163")
// NOTE: WARNING correct only for HEAD 
// 1968-75
// 1	Working now, or laid off only temporarily
// 2	Unemployed
// 3	Retired, permanently disabled
// 4	Housewife
// 5	Student
// 6	Other

// 1976+ 
// 1	Working now
// 2	Only temporarily laid off
// 3	Looking for work, unemployed
// 4	Retired
// 5	Permanently disabled
// 6	Housewife/Keeping house
// 7	Student
// 8	Other



combvars  emplst_S , list("[76]V4841 [79]V6591 [80]V7193 [81]V7879 [82]V8538 [83]V9188 [84]V10671 [85]V12000 [86]V13225 [87]V14321 [88]V15456 [89]V16974 [90]V18395 [91]V19695 [92]V20995 [93]V22801 [94]ER2562 [95]ER5561 [96]ER7657")
// D1. We would like to know about what you do--are you (WIFE) working now, looking for work, retired, a student, a housewife, or what?
// 1	Working now
// 2	Only temporarily laid off
// 3	Looking for work, unemployed
// 4	Retired
// 5	Permanently disabled
// 6	Housewife/Keeping house
// 7	Student



// combvars  w_now , list("[76]V4776 [77]V5525 [78]V6053 [79]V6654 [80]V7256 [81]V7947 [82]V8598 [83]V9271 [84]V10672 [85]V12002 [86]V13227 [87]V14323 [88]V15458 [89]V16976 [90]V18397 [91]V19697 [92]V20997 [93]V22803 [94]ER2567 [95]ER5566 [96]ER7662 [97]ER10567 [99]ER13721 [01]ER17790 [05]ER25366 [07]ER36371 [09]ER42396 [11]ER47709 [13]ER53415 [15]ER60430 [17]ER66443")
// NOTE! For spouse! 
// doing any work for money now
// 1	Yes
// 5	No
// 8	DK
// 9	NA


combvars  w_since1_ , list("[03]ER21127 [05]ER25109 [07]ER36114 [09]ER42145 [11]ER47453 [13]ER53153 [15]ER60168 [17]ER66169 [19]ER72169")
// BC3a. (Have you/Has Reference Person) done any work for money since January 1, 2015? Please include any type of work, no matter how small.
combvars  w_since2_ , list("[03]ER21377 [05]ER25367 [07]ER36372 [09]ER42397 [11]ER47710 [13]ER53416 [15]ER60431 [17]ER66444 [19]ER72446")
// DE3A. (Have you/Has [Spouse/Partner]) done any work for money since January 1, 2015? Please include any type of work, no matter how small.
// 1	Yes
// 5	No
// 8	DK
// 9	NA
// 0 	Inap.: working now or only temporarily laid off


**--------------------------------------
** Occupation ISCO 							
**--------------------------------------

combvars  occupA , list("[68]V197 [69]V640 [70]V1279 [71]V1984 [72]V2582 [73]V3115 [74]V3530 [75]V3968")
// F2. What is your main occupation?
// G1. What do you do when you work? (What is your occupation?)
// H2. What kind of work did you do when you worked? (What was your occupation?)
// 1	Professional, technical and kindred workers
// 2	Managers, officials and proprietors
// 3	Self-employed businessmen
// 4	Clerical and sales workers
// 5	Craftsmen, foremen, and kindred workers
// 6	Operatives and kindred workers
// 7	Laborers and service workers, farm laborers
// 8	Farmers and farm managers
// 9	Miscellaneous (armed services, protective workers, unemployed last year but looking for work, NA)
// 0	Inap.: not in labor force at all in 1967, retired (includes students and housewives who did no work last year and are not working). Permanently disabled or not in labor force and did no work last year


combvars  occupB , list("[68]V197_A [69]V640_A [70]V1279_A [71]V1984_A [72]V2582_A [73]V3115_A [74]V3530_A [75]V3968_A [76]V4459_A [77]V5374_A [78]V5873_A [79]V6497_A [80]V7100_A")
// F2. What is your main occupation? (What sort of work do you do?)
// F3. Tell me a little more about what you do.
// G1. What do you do when you work? (What is your occupation?)
// H2. What kind of work did you do when you worked? (What was your occupation?)
// This version of occupation was coded retroactively using original PSID reports and the three-digit 1970 Census occupation codes for a selected sample of PSID Heads and Wives/"Wives":
//
// (a) Original sample Heads and Wives/"Wives still living by
// 1992 who reported main jobs in at least three waves
// during the period 1968-1992, with at least one of those
// reports prior to 1980.
//
// (b) Additionally, original sample Heads and Wives/"Wives" who
// had reported at least one main job between 1968 and 1980
// but were known to have died by 1992.
//
// The selection criteria did not include all Heads and Wives/"Wives"
// who had worked between 1968 and 1980. Those who were still living
// but had reported only one or two jobs during the period of interest
// were excluded, as were all nonsample Heads and Wives/"Wives".
// Therefore not every Head or Wife/"Wife" has data for this variable. For detailed information about the Retrospective Coding Project please see the document, 'A Panel Study of Income Dynamics: 1968-1980 Retrospective Occupation-Industry Files Documentation', on our website.
//
// The 3-digit occupation code from 1970 Census of Population; Alphabetical Index of Industries and Occupations issued June 1971 by the U.S. Department of Commerce and the Bureau of the Census was used for this variable. Please refer to Appendix V2, Wave XIV documentation, for complete listings.
// Note that code 600 was added by PSID staff - the code description is 'Current members of the Armed Forces'
//
// 1 - 195	Professional, Technical, and Kindred Workers
// 201 - 245	Managers and Administrators, Except Farm
// 260 - 285	Sales Workers
// 301 - 395	Clerical and Kindred Workers
// 401 - 600	Craftsmen and Kindred Workers
// 601 - 695	Operatives, Except Transport
// 701 - 715	Transport Equipment Operatives
// 740 - 785	Laborers, Except Farm
// 801 - 802	Farmers and Farm Managers
// 821 - 824	Farm Laborers and Farm Foremen
// 901 - 965	Service Workers, Except Private Household
// 980 - 984	Private Household Workers
// 999	NA; DK
// 0	Inap.: not eligible for retroactive coding


combvars  occupC , list("[74]V3529 [81]V7712 [82]V8380 [83]V9011 [84]V10460 [85]V11651 [86]V13054 [87]V14154 [88]V15162 [89]V16663 [90]V18101 [91]V19401 [92]V20701 [93]V22456 [94]ER4017 [95]ER6857 [96]ER9108 [97]ER12085 [99]ER13215 [01]ER17226")
// B9. What is your main occupation? What sort of work do you do?
// B9a. What are your most important activities or duties?
// The 3-digit occupation code from 1970 Census of Population; Alphabetical Index of Industries and Occupations issued June 1971 by the U.S. Department of Commerce and the Bureau of Census was used for this variable. Please refer to Appendix V2, Wave XIV (1981) documentation, for complete listings.
// 1 - 195	Professional, Technical, and Kindred Workers
// 201 - 245	Managers and Administrators, except Farm
// 260 - 285	Sales Workers
// 301 - 395	Clerical and Kindred Workers
// 401 - 600	Craftsman and Kindred Workers
// 601 - 695	Operatives, except Transport
// 701 - 715	Transport Equipment Operatives
// 740 - 785	Laborers, except Farm
// 801 - 802	Farmers and Farm Managers
// 821 - 824	Farm Laborers and Farm Foremen
// 901 - 965	Service Workers, except Private Household
// 980 - 984	Private Household Workers
// 810	Wild code
// 999	DK; NA; refused
// 0	Inap.: not working for money now



combvars  occupD , list("[03]ER21145 [05]ER25127 [07]ER36132 [09]ER42167 [11]ER47479 [13]ER53179 [15]ER60194 [17]ER66195 [19]ER72195")

// In (your/his/her) work for (EMPNAME) (BEGMO/BEGYR)-(ENDMO/ENDYR) what (is/was) (your/Reference Person's) occupation? What sort of work (do/does/did) (you/he/she) do? What (are/were) (your/his/her) most important activities or duties?--CURRENT OR MOST RECENT MAIN JOB

// !! 2003 - 2015:
// The 3-digit occupation code from 2000 CENSUS OF POPULATION AND HOUSING: ALPHABETICAL INDEX OF INDUSTRIES AND OCCUPATIONS 
// issued by the U.S. Department of Commerce and the Bureau of the Census was used for this variable. 
// Please refer to www.census.gov/hhes/www/ioindex/ioindex.html for complete listings.
// Jan-43	Management Occupations
// 50 - 73	Business Operations Specialists
// 80 - 95	Financial Specialists
// 100 - 124	Computer and Mathematical Occupations
// 130 - 156	Architecture and Engineering Occupations
// 160 - 196	Life, Physical, and Social Science Occupations
// 200 - 206	Community and Social Services Occupations
// 210 - 215	Legal Occupations
// 220 - 255	Education, Training, and Library Occupations
// 260 - 296	Arts, Design, Entertainment, Sports, and Media Occupations
// 300 - 354	Healthcare Practitioners and Technical Occupations
// 360 - 365	Healthcare Support Occupations
// 370 - 395	Protective Service Occupations
// 400 - 416	Food Preparation and Serving Occupations
// 420 - 425	Building and Grounds Cleaning and Maintenance Occupations
// 430 - 465	Personal Care and Service Occupations
// 470 - 496	Sales Occupations
// 500 - 593	Office and Administrative Support Occupations
// 600 - 613	Farming, Fishing, and Forestry Occupations
// 620 - 676	Construction Trades
// 680 - 694	Extraction Workers
// 700 - 762	Installation, Maintenance, and Repair Workers
// 770 - 896	Production Occupations
// 900 - 975	Transportation and Material Moving Occupations
// 980 - 983	Military Specific Occupations
// 615	Wild code
// 999	DK; NA; refused
// 0	Inap.: did not work for money in 2002 or has not worked for money since January 1, 2001 (ER21127=5, 8, or 9)


// !! 2017:
// The 4-digit 2010 Census Occupation Codes with Crosswalk issued by the U.S. Department of Commerce and the Bureau of the Census was used for this variable.
// Please refer to https://www.census.gov/topics/employment/industry-occupation/guidance/code-lists.html
// 2010 Census Occupation Codes with Crosswalk
// 10 - 430	Management Occupations
// 500 - 950	Business and Financial Operations Occupations
// 1,000 - 1,240	Computer and Mathematical Occupations
// 1,300 - 1,560	Architecture and Engineering Occupations
// 1,600 - 1,965	Life, Physical, and Social Science Occupations
// 2,000 - 2,060	Community and Social Services Occupations
// 2,100 - 2,160	Legal Occupations
// 2,200 - 2,550	Education, Training, and Library Occupations
// 2,600 - 2,960	Arts, Design, Entertainment, Sports, and Media Occupations
// 3,000 - 3,540	Healthcare Practitioners and Technical Occupations
// 3,600 - 3,655	Healthcare Support Occupations
// 3,700 - 3,955	Protective Service Occupations
// 4,000 - 4,160	Food Preparation and Serving Related Occupations
// 4,200 - 4,250	Building and Grounds Cleaning and Maintenance Occupations
// 4,300 - 4,650	Personal Care and Service Occupations
// 4,700 - 4,965	Sales and Related Occupations
// 5,000 - 5,940	Office and Administrative Support Occupations
// 6,005 - 6,130	Farming, Fishing, and Forestry Occupations
// 6,200 - 6,940	Construction and Extraction Occupations
// 7,000 - 7,630	Installation, Maintenance, and Repair Occupations
// 7,700 - 8,965	Production Occupations
// 9,000 - 9,750	Transportation and Material Moving Occupations
// 9,800 - 9,830	Military Specific Occupations
// 9,999	DK; NA; refused
// 0	Inap.: did not work for money in 2016; has not worked for money since January 1, 2015 (ER66169=5); DK, NA, or RF whether worked for money since January 1, 2015 (ER66169=8 or 9)

combvars  occupBS , list("[68]V243_A [69]V609_A [70]V1367_A [71]V2074_A [72]V2672_A [73]V3183_A [74]V3601_A [75]V4055_A [76]V4605_A [77]V5507_A [78]V6039_A [79]V6596_A [80]V7198_A")
combvars  occupCS , list("[81]V7885 [82]V8544 [83]V9194 [84]V10678 [85]V12014 [86]V13233 [87]V14329 [88]V15464 [89]V16982 [90]V18403 [91]V19703 [92]V21003 [93]V22809 [94]ER4048 [95]ER6888 [96]ER9139 [97]ER12116 [99]ER13727 [01]ER17796")
combvars  occupDS , list("[03]ER21395 [05]ER25385 [07]ER36390 [09]ER42419 [11]ER47736 [13]ER53442 [15]ER60457 [17]ER66470 [19]ER72472")



**--------------------------------------
** Industry 
**--------------------------------------

combvars  industA , list("[68]V197_B [69]V640_B [70]V1279_B [71]V1985_A [72]V2583_A [73]V3116_A [74]V3531_A [75]V3969_A [76]V4460_A [77]V5375_A [78]V5874_A [79]V6498_A [80]V7101_A")
//The 3-digit industry code from 1970 Census of Population; Alphabetical Index of Industries and Occupations issued June 1971 by the U.S. Department of Commerce and the Bureau of the Census was used for this variable. Please refer to Appendix V2, Wave XIV documentation, for complete listings.
// 17 - 28	Agriculture, Forestry, and Fisheries
// 47 - 57	Mining
// 67 - 77	Construction
// 107 - 398	Manufacturing
// 407 - 479	Transportation, Communications, and Other Public Utilities
// 507 - 698	Wholesale and Retail Trade
// 707 - 718	Finance, Insurance, and Real Estate
// 727 - 759	Business and Repair Services
// 769 - 798	Personal Services
// 807 - 809	Entertainment and Recreation Services
// 828 - 897	Professional and Related Services
// 907 - 937	Public Administration
// 999	NA; DK
// 0	Inap.: not eligible for retroactive coding

combvars  industB , list("[71]V1985 [72]V2583 [73]V3116 [74]V3531 [75]V3969 [76]V4460 [77]V5375 [78]V5874 [79]V6498 [80]V7101")
// 11	Agriculture, Forestry, and Fishing (A,017-028)
// 21	Mining and Extraction (047-057)
// 30	Metal industries (139-169)
// 31	Machinery, including electrical (177-209)
// 32	Motor vehicles and other transportation equipment (219-238)
// 33	Other durables (107-138,239-259)
// 34	Durables, NA what
// 40	Food and kindred products (268-298)
// 41	Tobacco manufacturing (299)
// 42	Textile mill products, apparel and other fabricated textile products, shoes (307-327,389)
// 43	Paper and allied products (328-337)
// 44	Chemical and allied products, petroleum and coal products, rubber and miscellaneous plastic products (347-387)
// 45	Other nondurables (388,397)
// 46	Nondurables, NA what
// 49	Manufacturing, NA whether durable or nondurable
// 51	Construction (067-077,B)
// 55	Transportation (D,407-429)
// 56	Communication (447-449)
// 57	Other Public Utilities (467-479)
// 61	Retail Trade (607-698)
// 62	Wholesale Trade (507-588)
// 69	Trade, NA whether wholesale or rental
// 71	Finance, Insurance, and Real Estate (707-718)
// 81	Repair Service (757-759)
// 82	Business Services (727-749)
// 83	Personal Services (H,769-798)
// 84	Amusement, Recreation, and Related Services (807-809)
// 85	Printing, Publishing, and Allied Services (338-389)
// 86	Medical and Dental and Health Services, whether public or private (828-848)
// 87	Educational Services, whether public or private (K,857-868)
// 88	Professional and Related Services other than medical or educational (849,869-897)
// 91	Armed Services [L(917)]
// 92	Government, other than medical or educational services; NA whether other [907,L(917),927,M(930)]
// 99	NA; DK
// 0	Inap.: unemployed; retired, permanently disabled, housewife, student; V7094=3-8


combvars  industC , list("[81]V7713 [82]V8381 [83]V9012 [84]V10461 [85]V11652 [86]V13055 [87]V14155 [88]V15163 [89]V16664 [90]V18102 [91]V19402 [92]V20702 [93]V22457 [94]ER4018 [95]ER6858 [96]ER9109 [97]ER12086 [99]ER13216 [01]ER17227")
// 17 - 28	Agriculture, Forestry, and Fisheries
// 47 - 57	Mining
// 67 - 77	Construction
// 107 - 398	Manufacturing
// 407 - 479	Transportation, Communications, and Other Public Utilities
// 507 - 698	Wholesale and Retail Trade
// 707 - 718	Finance, Insurance, and Real Estate
// 727 - 759	Business and Repair Services
// 769 - 798	Personal Services
// 807 - 809	Entertainment and Recreation Services
// 828 - 897	Professional and Related Services
// 907 - 937	Public Administration
// 999	NA; DK
// 0	Inap.: unemployed; retired, permanently disabled, housewife, student; V7706=3-8

combvars  industD , list("[03]ER21146 [05]ER25128 [07]ER36133 [09]ER42168 [11]ER47480 [13]ER53180 [15]ER60195 [17]ER66196 [19]ER72196")
// BC21. What kind of business or industry (is/was) that in?--CURRENT OR MOST RECENT MAIN JOB
// 17 - 29	Agriculture, Forestry, Fishing, and Hunting
// 37 - 49	Mining
// 57 - 69	Utilities
// 77	Construction
// 107 - 399	Manufacturing
// 407 - 459	Wholesale Trade
// 467 - 579	Retail Trade
// 607 - 639	Transportation and Warehousing
// 647 - 679	Information
// 687 - 699	Finance and Insurance
// 707 - 719	Real Estate and Rental and Leasing
// 727 - 749	Professional, Scientific, and Technical Services
// 757 - 779	Management, Administrative and Support, and Waste Management Services
// 786 - 789	Educational Services
// 797 - 847	Health Care and Social Assistance
// 856 - 859	Arts, Entertainment, and Recreation
// 866 - 869	Accommodations and Food Services
// 877 - 929	Other Services (Except Public Administration)
// 937 - 987	Public Administration and Active Duty Military
// 848	Wild code
// 999	DK; NA; refused
// 0	Inap.: did not work for money in 2002 or has not worked for money since January 1, 2001 (ER21127=5, 8, or 9)

// 2017:
// 170 - 290	Agriculture, Forestry, Fishing, and Hunting
// 370 - 490	Mining, Quarrying, and Oil and Gas Extraction
// 570 - 690	Utilities
// 770	Construction
// 1,070 - 3,990	Manufacturing
// 4,070 - 4,590	Wholesale Trade
// 4,670 - 5,790	Retail Trade
// 6,070 - 6,390	Transportation and Warehousing
// 6,470 - 6,780	Information
// 6,870 - 6,990	Finance and Insurance
// 7,070 - 7,190	Real Estate and Rental and Leasing
// 7,270 - 7,490	Professional, Scientific, and Technical Services
// 7,570 - 7,790	Management, Administrative and Support, and Waste Management Services
// 7,860 - 7,890	Educational Services
// 7,970 - 8,470	Health Care and Social Assistance
// 8,560 - 8,590	Arts, Entertainment, and Recreation
// 8,660 - 8,690	Accommodations and Food Services
// 8,770 - 9,290	Other Services (Except Public Administration)
// 9,370 - 9,870	Public Administration and Active Duty Military
// 9,999	DK; NA; refused
// 0	Inap.


combvars  industAS , list("[68]V243_B [69]V609_B [70]V1367_B [71]V2075_A [72]V2673_A [73]V3184_A [74]V3602_A [75]V4056_A [76]V4606_A [77]V5508_A [78]V6040_A [79]V6597_A [80]V7199_A")
combvars  industCS , list("[81]V7886 [82]V8545 [83]V9195 [84]V10679 [85]V12015 [86]V13234 [87]V14330 [88]V15465 [89]V16983 [90]V18404 [91]V19704 [92]V21004 [93]V22810 [94]ER4049 [95]ER6889 [96]ER9140 [97]ER12117 [99]ER13728 [01]ER17797")
combvars  industDS , list("[03]ER21396 [05]ER25386 [07]ER36391 [09]ER42420 [11]ER47737 [13]ER53443 [15]ER60458 [17]ER66471 [19]ER72473")

**--------------------------------------
** Public sector
**--------------------------------------

combvars  publicA , list("[75]V3971 [76]V4462 [77]V5377 [78]V5876 [79]V6494 [80]V7097 [81]V7708 [82]V8376 [83]V9007 [84]V10457 [85]V11648 [86]V13051 [87]V14151 [88]V15159 [89]V16660 [90]V18098 [91]V19398 [92]V20698 [93]V22453 [94]ER2078 [95]ER5077 [96]ER7173 [97]ER10088 [99]ER13212 [01]ER17223")
combvars  publicAS , list("[76]V4845 [79]V6593 [80]V7195 [81]V7881 [82]V8540 [83]V9190 [84]V10675 [85]V12011 [86]V13230 [87]V14326 [88]V15461 [89]V16979 [90]V18400 [91]V19700 [92]V21000 [93]V22806 [94]ER2572 [95]ER5571 [96]ER7667 [97]ER10570 [99]ER13724 [01]ER17793")
// D6. Do you work for the Federal, state or local government?
// [75]-[82]
// 1	Yes
// 5	No
// 8	DK
// 9	NA
// 0 	Inap.: working now or only temporarily laid off
// [83]+:
// 1	Federal government
// 2	State government
// 3	Local government; public school system
// 4	Private company; non-government
// 7	Other
// 9	NA; DK
// 0	Inap.: not working for money now (V15156=5); works for self only or also employed by someone else (V15157=2, 3 or 9)

combvars  publicB1_ , list("[03]ER21149 [05]ER25131 [07]ER36136 [09]ER42171 [11]ER47484 [13]ER53184 [15]ER60199 [17]ER66200 [19]ER72200")
combvars  publicB2_ , list("[03]ER21399 [05]ER25389 [07]ER36394 [09]ER42423 [11]ER47741 [13]ER53447 [15]ER60462 [17]ER66475 [19]ER72477")
// DE24. ([Do/Did] you/[Does/Did] [Spouse/Partner]) work for the federal, state, or local government, a private company, or what?--CURRENT OR MOST RECENT MAIN JOB
// 1	Federal government
// 2	State government
// 3	Local government; public school system
// 4	Private company; nongovernment
// 7	Other
// 8	DK
// 9	NA; refused
// 0	Inap.: has not worked for money since January 1, 2015 (ER66444=5); DK, NA, or RF whether worked for money since January 1, 2015 (ER66444=8 or 9); has not worked for money since January 1, 2016 (ER66453=3); works/worked for both someone else and self or self-employed only (ER66473=2 or 3); DK, NA, or RF whether is/was employed by someone else only, both someone else and self, or self-employed only (ER66473=8 or 9); no Spouse/Partner in FU (ER67399=5)

 
**--------------------------------------  
** Size of organization	 
**--------------------------------------

// SPOSE:
combvars  sizeA , list("[99]ER15303 [05]ER25390 [07]ER36395 [09]ER42424 [11]ER47742 [13]ER53448 [15]ER60463 [17]ER66476 [19]ER72478")
// Including (yourself/Spouse/Partner), about how many people are employed by [NAME OF SPOUSE'S/PARTNER'S EMPLOYER] at the location where (you work/[Spouse/Partner] works)?

// HEAD:
combvars  sizeBMJ , list("[99]ER15157 [05]ER25132 [07]ER36137 [09]ER42172 [11]ER47485 [13]ER53185 [15]ER60200 [17]ER66201 [19]ER72201")
// BC25a. Including (yourself/Reference Person), about how many people are employed by [NAME OF REFERENCE PERSON'S EMPLOYER] at the location where (you work/Reference Person works)?


// 1 - 999,999,997	Actual number
// 999,999,998	DK
// 999,999,999	NA; refused


**--------------------------------------  
** hours conracted
**--------------------------------------
* wh_ctr
// 	lab var whweek_ctr "Work hours per week: conracted"

**--------------------------------------
** hours worked
**--------------------------------------


// Combine with e11101 :
// Until 1993 and again starting in 2005 this variable is provided in the PSID. 
// For 1994-1997, 1999, 2001, and 2003 the annual hours are constructed by CNEF staff. 
// For the head and partner, this variable is the sum of annual hours worked on the 
// main job, annual hours worked on extra jobs, and annual hours of overtime in 
// the previous year. For all other family members, this variable was created by 
// multiplying the number of weeks worked in the previous year by the number of hours 
// usually worked per week. Hours for other family unit members was created at 
// Cornell using internal data provided by PSID. Contact us for details and the program.

combvars  whyearA , list("[68]ER30013 [69]ER30034 [70]ER30058 [71]ER30082 [72]ER30107 [73]ER30131 [74]ER30153 [75]ER30177 [76]ER30204 [77]ER30233 [78]ER30270 [79]ER30300 [80]ER30330 [81]ER30360 [82]ER30388 [83]ER30417 [84]ER30447 [85]ER30482 [86]ER30517 [87]ER30553 [88]ER30588 [89]ER30624 [90]ER30661 [91]ER30709 [92]ER30754 [93]ER30823")
// J23. How many weeks did (he/she) work last year?
// J24. About how many hours a week was that?
// J25. (IF NOT CLEAR) Did (he/she) work more than half time?
// 1 - 5,840	Actual hours worked
// 9,999	NA; DK
// 0	Inap.: did not work; born or moved in after the 1968 interview or individual from Immigrant or Latino samples (ER30003=0); under 14 years old in 1968 (ER30004=1-13)


combvars  whyearHEAD , list("[68]V47 [69]V465 [70]V1138 [71]V1839 [72]V2439 [73]V3027 [74]V3423 [75]V3823 [76]V4332 [77]V5232 [78]V5731 [79]V6336 [80]V6934 [81]V7530 [82]V8228 [83]V8830 [84]V10037 [85]V11146 [86]V12545 [87]V13745 [88]V14835 [89]V16335 [90]V17744 [91]V19044 [92]V20344 [93]V21634 [94]ER4096 [95]ER6936 [96]ER9187 [97]ER12174 [99]ER16471 [01]ER20399 [03]ER24080 [05]ER27886 [07]ER40876 [09]ER46767 [11]ER52175 [13]ER57976 [15]ER65156 [17]ER71233 [19]ER77255")
// Head's annual hours working for money
combvars  whyearWIFE , list("[68]V53 [69]V475 [70]V1148 [71]V1849 [72]V2449 [73]V3035 [74]V3431 [75]V3831 [76]V4344 [77]V5244 [78]V5743 [79]V6348 [80]V6946 [81]V7540 [82]V8238 [83]V8840 [84]V10131 [85]V11258 [86]V12657 [87]V13809 [88]V14865 [89]V16365 [90]V17774 [91]V19074 [92]V20374 [93]V21670 [94]ER4107 [95]ER6947 [96]ER9198 [97]ER12185 [99]ER16482 [01]ER20410 [03]ER24091 [05]ER27897 [07]ER40887 [09]ER46788 [11]ER52196 [13]ER57997 [15]ER65177 [17]ER71254 [19]ER77276")
// Wife's annual hours working for money
// 0	None; did not work
// 1 - 9,998	Actual number of hours
// 9,999	9,999 or more hours

combvars  whweekA , list("[68]V225 [69]V659 [70]V1293 [71]V1999 [72]V2597 [73]V3130 [74]V3545 [75]V3999 [76]V4508 [77]V5418 [78]V5905 [79]V6516 [80]V7119 [81]V7742 [82]V8404 [83]V9035 [84]V10562 [85]V11706 [86]V13106 [87]V14204 [88]V15258 [89]V16759 [90]V18197 [91]V19497 [92]V20797 [93]V22577 [94]ER2225 [95]ER5224 [96]ER7320 [97]ER10232 [99]ER13363 [01]ER17393")
// F38, F41. How many hours a week is that? On the average, how many hours a week did you work on your main job last year?
// G4. About how many hours a week did you work (when you worked)?
// H4. About how many hours a week did you work (when you worked)?
// 1	1 - 19 hours a week
// 2	20 - 34
// 3	35 - 39
// 4	40
// 5	41 - 47
// 6	48
// 7	49 - 59
// 8	60 or more
// 9	NA
// 0	Inap.: did not work at all last year


combvars  whweekB , list("[99]ER33536Q [01]ER33627Q [03]ER33727Q [05]ER33827U [07]ER33927C") 
// R29/R36/R44. During the months that you worked, about how many hours did you usually work per week?
// 1 - 112	Actual number of hours worked per week in 1997
// 999	DK; NA; refused
// 0	Inap.

combvars  whweekC , list("[09]ER42148 [11]ER47456 [13]ER53156 [15]ER60171 [17]ER66172 [19]ER72172")
// BC14bb. On average, how many hours a week did (you/he/she) work on (all of) (your/his/her) (job/jobs) during 2016?
// 1 - 112	Actual hours worked
// 998	DK
// 999	NA; refused
// 0	Inap.: did not work for money in 2016


combvars  whweekDMJ , list("[03]ER21176 [05]ER25165 [07]ER36170 [09]ER42203 [11]ER47516 [13]ER53216 [15]ER60231 [17]ER66234 [19]ER72234")
// BC43. ((And) the job with [EMPLOYER] [START MONTH /YEAR] to [END MONTH /YEAR],) On average, how many hours a week did (you/he/she) work on this job in 2016?--CURRENT OR MOST RECENT MAIN JOB
combvars  whweekDJ2_ , list("[03]ER21208 [05]ER25197 [07]ER36202 [09]ER42233 [11]ER47546 [13]ER53246 [15]ER60261 [17]ER66264 [19]ER72264")
combvars  whweekDJ3_ , list("[03]ER21240 [05]ER25229 [07]ER36234 [09]ER42263 [11]ER47576 [13]ER53276 [15]ER60291 [17]ER66294 [19]ER72294")
combvars  whweekDJ4_ , list("[03]ER21272 [05]ER25261 [07]ER36266 [09]ER42293 [11]ER47606 [13]ER53306 [15]ER60321 [17]ER66324 [19]ER72324")


combvars  whweekOVERTMJ , list("[03]ER21179 [05]ER25168 [07]ER36173 [09]ER42206 [11]ER47519 [13]ER53219 [15]ER60234 [17]ER66237 [19]ER72237") 
// BC45. How many hours did that overtime amount to in (that period during) 2016?--HOURS FOR CURRENT OR MOST RECENT MAIN JOB
combvars  whweekOVERTJ2_ , list("[03]ER21211 [05]ER25200 [07]ER36205 [09]ER42236 [11]ER47549 [13]ER53249 [15]ER60264 [17]ER66267 [19]ER72267") 
combvars  whweekOVERTJ3_ , list("[03]ER21243 [05]ER25232 [07]ER36237 [09]ER42266 [11]ER47579 [13]ER53279 [15]ER60294 [17]ER66297 [19]ER72297") 
combvars  whweekOVERTJ4_ , list("[03]ER21275 [05]ER25264 [07]ER36269 [09]ER42296 [11]ER47609 [13]ER53309 [15]ER60324 [17]ER66327 [19]ER72327") 

combvars  whweekOVERTMJS , list("[03]ER21429 [05]ER25426 [07]ER36431 [09]ER42458 [11]ER47776 [13]ER53482 [15]ER60497 [17]ER66512 [19]ER72514") 
combvars  whweekOVERTJ2S_ , list("[03]ER21461 [05]ER25458 [07]ER36463 [09]ER42488 [11]ER47806 [13]ER53512 [15]ER60527 [17]ER66542 [19]ER72544") 
combvars  whweekOVERTJ3S_ , list("[03]ER21493 [05]ER25490 [07]ER36495 [09]ER42518 [11]ER47836 [13]ER53542 [15]ER60557 [17]ER66572 [19]ER72574") 
combvars  whweekOVERTJ4S_ , list("[03]ER21525 [05]ER25522 [07]ER36527 [09]ER42548 [11]ER47866 [13]ER53572 [15]ER60587 [17]ER66602 [19]ER72604") 


combvars  whweekE , list("[09]ER42400 [11]ER47713 [13]ER53419 [15]ER60434 [17]ER66447 [19]ER72449")
// DE14bb. On average, how many hours a week did (you/he/she) work on (all of) (your/his/her) (job/jobs) during 2016?

combvars  whweekF , list("[17]ER66230 [19]ER72230")
// BC39a. On average, how many hours a week (do you/does Reference Person) currently work on this job?--CURRENT MAIN JOB

**--------------------------------------
** full/part time
**--------------------------------------
*  

//  e11103:
// If the individual had positive wages and worked at least 1,820 hours last year 
// (35 hours per week on average), then the individual was employed full-time. 
// If the individual had positive wages and worked at least 52 hours but less than 
// 1,820 hours last year, then the individual was employed part-time. Otherwise, 
// the individual was not working.
	
	
	
	
**--------------------------------------
** overtime working  
**--------------------------------------
// SEE: whweekOVERT

**--------------------------------------
** Supervisor 	NA
**--------------------------------------
//  only for: [75]V3979 [76]V4463 [77]V5379 [85]V11644
	
**--------------------------------------
** Matternity leave  NA
**--------------------------------------

	
*################################
*#								#
*#	Currently unemployed 		#
*#								#
*################################

**--------------------------------------  
** Unempl: registered  NA
**--------------------------------------


**--------------------------------------
** Unempl: reason   
**--------------------------------------

// [68]V201 [69]V643 [70]V1282 [71]V1988 [72]V2586 [73]V3119 [74]V3534 [75]V3986 [76]V4490 [77]V5399 [78]V5890 [79]V6501 [80]V7104 [81]V7727 [82]V8391 [83]V9022 [84]V10539 [85]V11679 [86]V13079 [87]V14177
// D7. What happened to the job you had before -- did the company fold, were you laid off, or what?

// [69]V651 [70]V1332 [71]V2038 [72]V2638 [73]V3155 [74]V3571 [75]V4026 [76]V4556 [77]V5458 [78]V5986 [79]V6559 [80]V7161 [81]V7809 [82]V8470 [83]V9107 [84]V10609 [85]V11764 [86]V13160 [87]V14256 [88]V15328 [89]V16843 [90]V18267 [91]V19567 [92]V20867 [93]V22655 [94]ER4034 [95]ER6874 [96]ER9125 [97]ER12102 [99]ER13498 [01]ER17538 [03]ER21184 [05]ER25173 [07]ER36178 [09]ER42211 [11]ER47524 [13]ER53224 [15]ER60239 [17]ER66242
// BC51. Why did (you/he/she) stop working for (NAME OF EMPLOYER)?--Did the company go out of business, were you laid off, did you quit, or what?--MOST RECENT MAIN JOB
// 1	Company folded/changed hands/moved out of town; employer died/went out of business
// 2	Strike; lockout
// 3	Laid off; fired
// 4	Quit; resigned; retired; pregnant; needed more money; just wanted a change
// 7	Other; transfer; any mention of armed services
// 8	Job was completed; seasonal work; was a temporary job
// 9	DK; NA; refused
// 0	Inap.: still working for this employer; did not work for money in 2016; has not worked for money since January 1, 2015 (ER66169=5); DK, NA, or RF whether worked for money since January 1, 2015 (ER66169=8 or 9)



**--------------------------------------
** Unempl: actively looking for work 
**--------------------------------------
* un_act

* Currenlty working:
// combvars  un_actA , list("[70]V1318 [71]V2024 [72]V2622 [79]V6542 [80]V7145 [81]V7794 [82]V8456 [83]V9090 [84]V10590 [85]V11667 [86]V13067 [87]V14165 [88]V15172 [89]V16673 [90]V18111 [91]V19411 [92]V20711 [93]V22480 [94]ER2094 [95]ER5093 [96]ER7189 [97]ER10108 [99]ER13234 [01]ER17245")
// combvars  un_actAS, list("[85]V12030 [88]V15474 [89]V16992 [90]V18413 [91]V19713 [92]V21013 [93]V22833 [94]ER2588 [95]ER5587 [96]ER7683 [97]ER10590 [99]ER13746 [01]ER17815")

* Not working:
combvars  un_act1_ , list("[76]V4546 [77]V5444 [78]V5961 [79]V6548 [80]V7151 [81]V7802 [82]V8463 [83]V9100 [84]V10600")
combvars  un_act2_ , list("[85]V11743 [86]V13139 [87]V14237 [88]V15308 [89]V16823 [90]V18247 [91]V19547 [92]V20847 [93]V22634 [94]ER2317 [95]ER5316 [96]ER7412 [97]ER10325 [99]ER13464 [01]ER17503")
combvars  un_actS1_, list("[76]V4930 [79]V6625 [80]V7227 [81]V7916 [82]V8571 [83]V9230 [84]V10801 [85]V12106 [86]V13309 [87]V14403 [88]V15610 [89]V17142 [90]V18549 [91]V19849 [92]V21149 [93]V22987 [94]ER2811 [95]ER5810 [96]ER7906 [97]ER10807 [99]ER13976 [01]ER18074")

// B20. Have you (HEAD) been looking for another job during the past four weeks?
combvars  un_act3_ , list("[03]ER21360 [05]ER25349 [07]ER36354 [09]ER42379 [11]ER47692 [13]ER53392 [15]ER60407 [17]ER66416 [19]ER72416") //ok
// BC64. (Have you/Has Reference Person) been looking for (another job/work) during the past four weeks?
combvars  un_actS2_ , list("[03]ER21610 [05]ER25607 [07]ER36612 [09]ER42631 [11]ER47949 [13]ER53655 [15]ER60670 [17]ER66691 [19]ER72693")
// SPOUSE: DE64. (Have you/Has [Spouse/Partner]) been looking for (another job/work) during the past four weeks?

// 1	Yes
// 5	No
// 8	DK
// 9	NA; refused
// 0	Inap.


**-------------------------------------- !!!! Check other surveys - can be useful for ART !!!!! 
** Unempl: how long looking for work
**--------------------------------------

// BC67. How long (have you/has [he/she]) been looking for work?-
// YEARS
combvars  un_timeY , list("[94]ER2321 [95]ER5320 [96]ER7416 [97]ER10334 [99]ER13473 [01]ER17512 [03]ER21369 [05]ER25358 [07]ER36363 [09]ER42388 [11]ER47701 [13]ER53407 [15]ER60422 [17]ER66435 [19]ER72435")
// MONTHS
combvars  un_timeM , list("[94]ER2322 [95]ER5321 [96]ER7417 [97]ER10335 [99]ER13474 [01]ER17513 [03]ER21370 [05]ER25359 [07]ER36364 [09]ER42389 [11]ER47702 [13]ER53408 [15]ER60423 [17]ER66436 [19]ER72436")
// WEEKS:
combvars  un_timeW , list("[94]ER2323 [95]ER5322 [96]ER7418 [97]ER10336 [99]ER13475 [01]ER17514 [03]ER21371 [05]ER25360 [07]ER36365 [09]ER42390 [11]ER47703 [13]ER53409 [15]ER60424 [17]ER66437 [19]ER72437")


*################################
*#								#
*#	Self-empl / Entrepreneur	#
*#								#
*################################
**--------------------------------------
** Self-imployed	!! Harmon
**--------------------------------------

combvars  selfempA , list("[68]V198 [69]V641 [70]V1280 [71]V1986 [72]V2584 [73]V3117 [74]V3532 [75]V3970 [76]V4461 [77]V5376 [78]V5875 [79]V6493 [80]V7096 [81]V7707 [82]V8375 [83]V9006 [84]V10456 [85]V11640 [86]V13049 [87]V14149 [88]V15157 [89]V16658 [90]V18096 [91]V19396 [92]V20696 [93]V22451 [94]ER2074 [95]ER5073 [96]ER7169 [97]ER10086 [99]ER13210 [01]ER17221")
// F4. Do you work for someone else, yourself or what?
// 1	Someone else
// 2	Both someone else and self
// 3	Self only
// 9	NA
// 0	Inap.: unemployed; retired

combvars  selfempBMJ , list("[03]ER21147 [05]ER25129 [07]ER36134 [09]ER42169 [11]ER47482 [13]ER53182 [15]ER60197 [17]ER66198 [19]ER72198")
// BC22. ([Are/Were] you/[Is/Was] Reference Person) self-employed, ([are/were] you/[is/was] [he/she]) employed by someone else, or what?--CURRENT OR MOST RECENT MAIN JOB
// 1	Someone else only
// 2	Both someone else and self
// 3	Self-employed only
// 8	DK
// 9	NA; refused
// 0	Inap.: did not work for money in 2016; has not worked for money since January 1, 2015 (ER66169=5); DK, NA, or RF whether worked for money since January 1, 2015 (ER66169=8 or 9)
combvars  selfempBJ2_ , list("[03]ER21203 [05]ER25192 [07]ER36197 [09]ER42230 [11]ER47543 [13]ER53243 [15]ER60258 [17]ER66261 [19]ER72261")
combvars  selfempBJ3_ , list("[03]ER21235 [05]ER25224 [07]ER36229 [09]ER42260 [11]ER47573 [13]ER53273 [15]ER60288 [17]ER66291 [19]ER72291")
combvars  selfempBJ4_ , list("[03]ER21267 [05]ER25256 [07]ER36261 [09]ER42290 [11]ER47603 [13]ER53303 [15]ER60318 [17]ER66321 [19]ER72321")


combvars  selfempAS , list("[76]V4844 [79]V6592 [80]V7194 [81]V7880 [82]V8539 [83]V9189 [84]V10674 [85]V12003 [86]V13228 [87]V14324 [88]V15459 [89]V16977 [90]V18398 [91]V19698 [92]V20998 [93]V22804 [94]ER2568 [95]ER5567 [96]ER7663 [97]ER10568 [99]ER13722 [01]ER17791")
combvars  selfempBMJS , list("[03]ER21397 [05]ER25387 [07]ER36392 [09]ER42421 [11]ER47739 [13]ER53445 [15]ER60460 [17]ER66473 [19]ER72475")
combvars  selfempBJ2S_ , list("[03]ER21453 [05]ER25450 [07]ER36455 [09]ER42482 [11]ER47800 [13]ER53506 [15]ER60521 [17]ER66536 [19]ER72538")
combvars  selfempBJ3S_ , list("[03]ER21485 [05]ER25482 [07]ER36487 [09]ER42512 [11]ER47830 [13]ER53536 [15]ER60551 [17]ER66566 [19]ER72568")
combvars  selfempBJ4S_ , list("[03]ER21517 [05]ER25514 [07]ER36519 [09]ER42542 [11]ER47860 [13]ER53566 [15]ER60581 [17]ER66596 [19]ER72598")


**--------------------------------------
** Entrepreneur 
**--------------------------------------
// combine selfempBMJ with sizeBMJ (only for main job) 

combvars  farmer , list("[79]V6678 [80]V7275 [81]V7967 [82]V8606 [83]V9286 [84]V10870 [85]V11886 [86]V13397 [87]V14494 [88]V15762 [89]V17297 [90]V18701 [91]V20001 [92]V21301 [93]V23160 [94]ER3092 [95]ER6092 [96]ER8189 [97]ER11084 [99]ER14345 [01]ER18484 [03]ER21852 [05]ER25833 [07]ER36851 [09]ER42842 [11]ER48164 [13]ER53858 [15]ER60917 [17]ER66969 [19]ER72992")
// WHETHER HEAD FARMER
// 1	Head is a farmer or rancher
// 5	Head is not a farmer or rancher

// 2015+: 
// Whether Reference Person or Spouse/Partner is a farmer or rancher on current main job
// 1	Reference Person only is a farmer or rancher on CMJ
// 2	Spouse/Partner only is a farmer or rancher on CMJ
// 3	Both Reference Person and Spouse/Partner are farmers or ranchers on CMJs
// 5	Neither Reference Person nor Spouse/Partner is a farmer or rancher on CMJs



*################################
*#								#
*#	Retired						#
*#								#
*################################

**--------------------------------------
** Fully retired - identification
**--------------------------------------
/* retf - Critetia:
- Not working (J1)
- Receives pension (old-age)
- Age 45+
*/
					  
// use emplst2 + pens + age


 

**--------------------------------------
** Age at retirement 
**--------------------------------------					  
*   
combvars  yret , list("[78]V6003 [79]V6576 [80]V7178 [81]V7864 [82]V8524 [83]V9174 [84]V10657 [85]V11638 [86]V13047 [87]V14147 [88]V15155 [89]V16656 [90]V18094 [91]V19394 [92]V20694 [93]V22449 [94]ER2072 [95]ER5071 [96]ER7167 [97]ER10084 [99]ER13208 [01]ER17219 [03]ER21126 [05]ER25107 [07]ER36112 [09]ER42143 [11]ER47451 [13]ER53151 [15]ER60166 [17]ER66167 [19]ER72167")
// BC2. In what year did (you/Reference Person) (last) retire?
combvars  yretS , list("[79]V6648 [80]V7250 [81]V7941 [82]V8592 [83]V9265 [84]V10854 [85]V12001 [86]V13226 [87]V14322 [88]V15457 [89]V16975 [90]V18396 [91]V19696 [92]V20996 [93]V22802 [94]ER2566 [95]ER5565 [96]ER7661 [97]ER10566 [99]ER13720 [01]ER17789 [03]ER21376 [05]ER25365 [07]ER36370 [09]ER42395 [11]ER47708 [13]ER53414 [15]ER60429 [17]ER66442 [19]ER72444")
// DE2. In what year did (you/Spouse/Partner) (last) retire?


combvars  aret_plan , list("[99]ER15210 [01]ER19378 [03]ER22773 [05]ER26754 [07]ER37798 [09]ER43771 [11]ER49105 [13]ER54858 [15]ER61979 [17]ER68033 [19]ER74055")
// Now I want to ask about (your/HEAD) plans for retirement. At what age (do/does) (you/he/she) plan to stop working?

**--------------------------------------
** Early/regular retirement NA
**--------------------------------------					  
		  

**--------------------------------------
** Receiving old-age pension  
**--------------------------------------					  
combvars  ret_pensA , list("[94]ER3324 [95]ER6325 [96]ER8442 [97]ER11336 [99]ER14602 [01]ER18765 [03]ER22135 [05]ER26116 [07]ER37134 [09]ER43125 [11]ER48450 [13]ER54128 [15]ER61170 [17]ER67222 [19]ER73245")
// G40a. Did (you/Reference Person) receive any income in 2016 from other retirement pay, pensions, I.R.A.s (Individual Retirement Account), or annuities?--RETIREMENT PAY OR PENSIONS


combvars  ret_pensAS , list("[94]ER3643 [95]ER6645 [96]ER8762 [97]ER11644 [99]ER14910 [01]ER19094 [03]ER22467 [05]ER26448 [07]ER37466 [09]ER43457 [11]ER48782")


// combvars  ret_pensB , list("[13]ER54176 [15]ER61218 [17]ER67270")
// G40d. Did (you/Reference Person) receive any income in 2016 from other retirement pay, pensions, I.R.A.s (Individual Retirement Account), or annuities?--I.R.A.s (INDIVIDUAL RETIREMENT ACCOUNT)
// 1	Yes
// 5	No

combvars  ret_pensC , list("[84]ER30450 [85]ER30485 [86]ER30520 [87]ER30556 [88]ER30591 [89]ER30627 [90]ER30664 [91]ER30712 [92]ER30757 [05]ER33837A [07]ER33925A [09]ER34030")
// G31. Did you (HEAD) (or anyone else in the family there) receive any income from Social Security, such as disability, retirement or survivor's benefits?
// G33. Was that disability, retirement, survivor's benefits, or what?
// 1	Disability
// 2	Retirement
// 3	Survivor benefits; dependent of deceased recipient
// 4	Any combination of codes 1-3 and 5-7
// 5	Dependent of disabled recipient
// 6	Dependent of retired recipient
// 7	Other
// 8	DK
// 9	NA
// 0	Inap.: 

combvars  ret_pensD , list("[11]ER34138 [13]ER34245 [15]ER34395 [17]ER34604 [19]ER34813")
// G33a. (First/Next) let me ask about (your/[his/her]) Social Security. Was that disability, retirement, survivor's benefits, or what?--RETIREMENT
// 1	Social Security type was retirement
// 5	Social Security type was not retirement

combvars  surv_pensD , list("[11]ER34139 [13]ER34246 [15]ER34396 [17]ER34605 [19]ER34814")

// [05]ER33837M [07]ER33925M [09]ER34029J [11]ER34136J [13]ER34243J [15]ER34393J [17]ER34620
// // G84f. Did (you/he/she) have any (other) income, such as pensions, welfare, interest, gifts, or anything else, last year 2016?--How much was from veterans benefits?
// [05]ER33837O [07]ER33925O [09]ER34029L [11]ER34136L [13]ER34243L [15]ER34393L [17]ER34622
// // How much was from pensions or annuities?


**--------------------------------------
** Partial retirement  NA
**--------------------------------------					  


**--------------------------------------
** Receiving disability pension   
**--------------------------------------		
* disabpens

// 	lab var disabpens "Receiving disability pension"
// 	lab val disabpens yesno 

combvars  disab_pensA , list("[84]ER30450 [85]ER30485 [86]ER30520 [87]ER30556 [88]ER30591 [89]ER30627 [90]ER30664 [91]ER30712 [92]ER30757 [05]ER33837A [07]ER33925A [09]ER34030")
// G31. Did you (HEAD) (or anyone else in the family there) receive any income from Social Security, such as disability, retirement or survivor's benefits?
// G33. Was that disability, retirement, survivor's benefits, or what?
// 1	Disability
// 2	Retirement
// 3	Survivor benefits; dependent of deceased recipient
// 4	Any combination of codes 1-3 and 5-7
// 5	Dependent of disabled recipient
// 6	Dependent of retired recipient
// 7	Other
// 8	DK
// 9	NA
// 0	Inap.: 

combvars  disab_pensB , list("[11]ER34137 [13]ER34244 [15]ER34394 [17]ER34603 [19]ER34812")
// G33a. (First/Next) let me ask about (your/[his/her]) Social Security. Was that disability, retirement, survivor's benefits, or what?--DISABILITY
// 1	Social Security type was disability
// 5	Social Security type was not disability


*################################
*#								#
*#	Work history 				#
*#								#
*################################

**--------------------------------------
**   Labor market experience full time  
**--------------------------------------
combvars  expftH	, list("[74]V3621 [75]V4142 [76]V4631 [77]V5605 [78]V6154 [79]V6751 [80]V7384 [81]V8036 [82]V8660 [83]V9346 [84]V10993 [85]V11740 [86]V13606 [87]V14653 [88]V16127 [89]V17524 [90]V18855 [91]V20155 [92]V21461 [93]V23317 [94]ER3986 [95]ER6856 [96]ER9102 [97]ER11898 [99]ER15980 [01]ER20041 [03]ER23477 [05]ER27445 [07]ER40617 [09]ER46595 [11]ER51956 [13]ER57712 [15]ER64872 [17]ER70944 [19]ER76962")
combvars  expftS	, list("[74]V3611 [75]V4111 [76]V4990 [77]V5575 [78]V6124 [79]V6721 [80]V7354 [81]V8006 [82]V8630 [83]V9316 [84]V10963 [85]V12103 [86]V13532 [87]V14579 [88]V16053 [89]V17450 [90]V18781 [91]V20081 [92]V21387 [93]V23244 [94]ER3916 [95]ER6786 [96]ER9032 [97]ER11810 [99]ER15887 [01]ER19948 [03]ER23385 [05]ER27349 [07]ER40524 [09]ER46501 [11]ER51862 [13]ER57602 [15]ER64733 [17]ER70806 [19]ER76817")

**--------------------------------------
**   Labor market experience part time NA
**--------------------------------------

	
**--------------------------------------
**   Total Labor market experience (full+part time) 
**--------------------------------------
combvars  exp	, list("[74]V3620 [75]V4141 [76]V4630 [77]V5604 [78]V6153 [79]V6750 [80]V7383 [81]V8035 [82]V8659 [83]V9345 [84]V10992 [85]V11739 [86]V13605 [87]V14652 [88]V16126 [89]V17523 [90]V18854 [91]V20154 [92]V21460 [93]V23316 [94]ER3985 [95]ER6855 [96]ER9101 [97]ER11897 [99]ER15979 [01]ER20040 [03]ER23476 [05]ER27444 [07]ER40616 [09]ER46594 [11]ER51955 [13]ER57711 [15]ER64871 [17]ER70943 [19]ER76961")
// How many years altogether (have you/has [he/she]) worked for money since (you were/[he/she] was) 18?
// 1	One year or less for those 19 years or older
// 2 - 94	Actual number of years
// 95	Less than one yer for those 18 or younger
// 96	All years since 18
// 99	DK; NA; refused
// 0	Inap.: Reference Person was under age 18 when this question was asked; never worked

combvars  expS, list("[74]V3610 [75]V4110 [76]V4989 [77]V5574 [78]V6123 [79]V6720 [80]V7353 [81]V8005 [82]V8629 [83]V9315 [84]V10962 [85]V12102 [86]V13531 [87]V14578 [88]V16052 [89]V17449 [90]V18780 [91]V20080 [92]V21386 [93]V23243 [94]ER3915 [95]ER6785 [96]ER9031 [97]ER11809 [99]ER15886 [01]ER19947 [03]ER23384 [05]ER27348 [07]ER40523 [09]ER46500 [11]ER51861 [13]ER57601 [15]ER64732 [17]ER70805 [19]ER76816")

**--------------------------------------
**   Experience in org
**--------------------------------------
* exporg
 	
combvars  exporgA , list("[68]V200 [76]V4480 [77]V5384 [78]V5941 [81]V7711 [82]V8379 [83]V9010 [84]V10519 [85]V11668 [86]V13068 [87]V14166 [88]V15181 [89]V16682 [90]V18120 [91]V19420 [92]V20720 [93]V22489")
// F6. How long have you been working for your present employer?
// 1	Less than half a year; 0 - 6 months
// 2	1 year; 7 - 18 months
// 3	2 - 3 years; 19 months - 42 months
// 4	4 - 9 years
// 5	10 - 19 years
// 6	20 years or more
// 9	NA
// 0	Inap.: 

// All three vars--B23 YRS; B23 MOS and B23 WKS must be added together to calculate total experience
combvars  exporgB , list("[94]ER2098 [95]ER5097 [96]ER7193 [97]ER10117 [99]ER13243 [01]ER17254 [03]ER21171 [05]ER25160 [07]ER36165 [09]ER42200 [11]ER47513 [13]ER53213 [15]ER60228 [17]ER66231 [19]ER72231")
// BC41. How many years' experience (do you/does Reference Person) have altogether with (your/his/her) present employer?--YEARS FOR CURRENT MAIN JOB
// 1 - 65	Actual number of years
combvars  exporgBm , list("[94]ER2099 [95]ER5098 [96]ER7194 [97]ER10118 [99]ER13244 [01]ER17255 [03]ER21172 [05]ER25161 [07]ER36166 [09]ER42201 [11]ER47514 [13]ER53214 [15]ER60229 [17]ER66232 [19]ER72232")

combvars  exporgBw , list("[94]ER2100 [95]ER5099 [96]ER7195 [97]ER10119 [99]ER13245 [01]ER17256 [03]ER21173 [05]ER25162 [07]ER36167 [09]ER42202 [11]ER47515 [13]ER53215 [15]ER60230 [17]ER66233 [19]ER72233")

combvars  exporgAS , list("[76]V4863 [78]V6057 [81]V7884 [82]V8543 [83]V9193 [84]V10733 [85]V12031 [86]V13245 [87]V14339 [88]V15483 [89]V17001 [90]V18422 [91]V19722 [92]V21022 [93]V22842")
combvars  exporgBS , list("[94]ER2592 [95]ER5591 [96]ER7687 [97]ER10599 [99]ER13755 [01]ER17824 [03]ER21421 [05]ER25418 [07]ER36423 [09]ER42452 [11]ER47770 [13]ER53476 [15]ER60491 [17]ER66506 [19]ER72508")
combvars  exporgBSm , list("[94]ER2593 [95]ER5592 [96]ER7688 [97]ER10600 [99]ER13756 [01]ER17825 [03]ER21422 [05]ER25419 [07]ER36424 [09]ER42453 [11]ER47771 [13]ER53477 [15]ER60492 [17]ER66507 [19]ER72509")
combvars  exporgBSw , list("[94]ER2594 [95]ER5593 [96]ER7689 [97]ER10601 [99]ER13757 [01]ER17826 [03]ER21423 [05]ER25420 [07]ER36425 [09]ER42454 [11]ER47772 [13]ER53478 [15]ER60493 [17]ER66508 [19]ER72510")

**--------------------------------------
**   Never worked
**--------------------------------------	
combvars  neverw , list("[76]V4552 [77]V5454 [78]V5971 [79]V6556 [80]V7158 [81]V7806 [82]V8467 [83]V9104 [84]V10604 [85]V11751 [86]V13147 [87]V14245 [88]V15318 [89]V16833 [90]V18257 [91]V19557 [92]V20857 [93]V22644 [94]ER2324 [95]ER5323 [96]ER7419 [97]ER10337 [99]ER13476 [01]ER17515 [03]ER21357 [05]ER25346 [07]ER36351 [09]ER42376 [11]ER47689 [13]ER53389 [15]ER60404 [17]ER66413 [19]ER72413")
// C9. Have you (HEAD) ever done any work for money?
// 1	Yes
// 5	No
// 9	NA; DK
// 0	Inap
combvars  neverwS , list("[76]V4936 [79]V6628 [80]V7230 [81]V7919 [82]V8574 [83]V9233 [84]V10804 [85]V12114 [86]V13315 [87]V14409 [88]V15620 [89]V17152 [90]V18559 [91]V19859 [92]V21159 [93]V22997 [94]ER2818 [95]ER5817 [96]ER7913 [97]ER10819 [99]ER13988 [01]ER18086 [03]ER21607 [05]ER25604 [07]ER36609 [09]ER42628 [11]ER47946 [13]ER53652 [15]ER60667 [17]ER66688 [19]ER72690")
	
*################################
*#								#
*#	Income and wealth			#
*#								#
*################################

**-------------------------------------- 
**   Work Income - detailed
**--------------------------------------


* whole income (jobs, benefits)

	
* all jobs 

combvars  incj_yH , list("[68]V74 [69]V514 [70]V1196 [71]V1897 [72]V2498 [73]V3051 [74]V3463 [75]V3863 [76]V5031 [77]V5627 [78]V6174 [79]V6767 [80]V7413 [81]V8066 [82]V8690 [83]V9376 [84]V11023 [85]V12372 [86]V13624 [87]V14671 [88]V16145 [89]V17534 [90]V18878 [91]V20178 [92]V21484 [93]V23323 [94]ER4140 [95]ER6980 [96]ER9231 [97]ER12080 [99]ER16463 [01]ER20443 [03]ER24116 [05]ER27931 [07]ER40921 [09]ER46829 [11]ER52237 [13]ER58038 [15]ER65216 [17]ER71293 [19]ER77315")
// Head's money income from labor
// Reference Person's 2016 Labor Income, Excluding Farm and Unincorporated Business Income
// NOTE: should be equal or higher than incj_yHB

combvars  incj_yHB , list("[68]V251 [69]V699 [70]V1191 [71]V1892 [72]V2493 [73]V3046 [74]V3458 [75]V3858 [76]V4373 [77]V5283 [78]V5782 [79]V6391 [80]V6981 [81]V7573 [82]V8265 [83]V8873 [84]V10256 [85]V11397 [86]V12796 [87]V13898 [88]V14913 [89]V16413 [90]V17829 [91]V19129 [92]V20429 [93]V21739 [94]ER4122 [95]ER6962 [96]ER9213 [97]ER12196 [99]ER16493 [01]ER20425 [03]ER24117 [05]ER27913 [07]ER40903 [09]ER46811 [11]ER52219 [13]ER58020 [15]ER65200 [17]ER71277 [19]ER77299")
// Reference Person's Income from Wages and Salaries  
// 1 - 9,999,997	Actual amount
 
combvars  incj_yS1_ , list("[68]V75 [69]V516 [70]V1198 [71]V1899 [72]V2500 [73]V3053 [74]V3465 [75]V3865 [76]V4379 [77]V5289 [78]V5788 [79]V6398 [80]V6988 [81]V7580 [82]V8273 [83]V8881 [84]V10263 [85]V11404 [86]V12803 [87]V13905 [88]V14920 [89]V16420 [90]V17836 [91]V19136 [92]V20436 [93]V23324")
// Wife's money income from work
combvars  incj_yS2_ , list("[93]V21807 [94]ER4144 [95]ER6984 [96]ER9235 [97]ER12082 [99]ER16465 [01]ER20447 [03]ER24135 [05]ER27943 [07]ER40933 [09]ER46841 [11]ER52249 [13]ER58050 [15]ER65244 [17]ER71321 [19]ER77343")
// Spouse's/Partner's 2016 Labor Income, Excluding Farm and Unincorporated Business Income
combvars  incj_ySBSN , list("[93]V21806 [94]ER4141 [95]ER6981 [96]ER9232 [97]ER12214 [99]ER16511 [01]ER20444 [03]ER24111 [05]ER27940 [07]ER40930 [09]ER46838 [11]ER52246 [13]ER58047 [15]ER65225 [17]ER71302 [19]ER77324")
// Wife/"Wife"'s Labor Part of Business Income in ....


combvars  incj_yBSN , list("[70]V1190 [71]V1891 [72]V2492 [73]V3045 [74]V3457 [75]V3857 [76]V4372 [77]V5282 [78]V5781 [79]V6390 [80]V6980 [81]V7572 [82]V8264 [83]V8872 [84]V10255 [85]V11396 [86]V12795 [87]V13897 [88]V14912 [89]V16412 [90]V17828 [91]V19128 [92]V20428 [93]V21738 [94]ER4119 [95]ER6959 [96]ER9210 [97]ER12193 [99]ER16490 [01]ER20422 [03]ER24109 [05]ER27910 [07]ER40900 [09]ER46808 [11]ER52216 [13]ER58017 [15]ER65197 [17]ER71274 [19]ER77296")
// Reference Person's Labor Part of Business Income from Unincorporated Businesses in 2016
// If total farm or business income represents a loss (i.e., a negative number), 
// then the labor portion equals 0 and the loss is coded in the asset portion.
// ---
// The income reported here is the labor part of Reference Person's business income 
// in 2016. Total business income of the Reference Person is equally split between 
// labor and asset income when the Reference Person put in actual work hours in any 
// unincorporated businesses. Information on who owns the business(es) and whether 
// Reference Person put in any work hours is collected in G9a-G9d. All missing data 
// were assigned.

combvars  incj_yFARM , list("[70]V1189 [71]V1890 [72]V2491 [73]V3044 [74]V3456 [75]V3856 [76]V4371 [77]V5281 [78]V5780 [79]V6389 [80]V6979 [81]V7571 [82]V8263 [83]V8871 [84]V10254 [85]V11395 [86]V12794 [87]V13896 [88]V14911 [89]V16411 [90]V17827 [91]V19127 [92]V20427 [93]V21733")
// Head's Labor Part of Farm Income

 


* main job
* HEAD Per hour
combvars  salary_mjHA , list("[76]V4510 [77]V5421 [78]V5908 [79]V6519 [80]V7122 [81]V7715 [82]V8383 [83]V9014 [84]V10463 [85]V11654 [86]V13057 [87]V14157 [88]V15165 [89]V16666 [90]V18104 [91]V19404 [92]V20704")
// B13. How much is your salary?
// The values for this variable represent dollars and cents per hour; 
// if salary is given as an annual figure, it is divided by 2000 hours per year; if weekly, by 40 hours per week.
// .01 - 99.97	Actual amount
// 99.98	$99.98 or more per hour
// 99.99	NA; DK
// .00	Inap.

* HEAD Per different measures
combvars  salary_mjHB , list("[93]V22464 [94]ER2082 [95]ER5081 [96]ER7177 [97]ER10092 [99]ER13218 [01]ER17229 [03]ER21153 [05]ER25142 [07]ER36147 [09]ER42182 [11]ER47495 [13]ER53195 [15]ER60210 [17]ER66211 [19]ER72211")
// BC30. How much is your salary?--AMOUNT FOR CURRENT MAIN JOB
// .01 - 9,999,996.99	Actual amount
// 9,999,997.00	$9,999,997 or more
// 9,999,998.00	DK
// 9,999,999.00	NA; refused
// .00	Inap.

* HEAD Per what?
combvars  salary_mjHBper , list("[93]V22465 [94]ER2083 [95]ER5082 [96]ER7178 [97]ER10093 [99]ER13219 [01]ER17230 [03]ER21154 [05]ER25143 [07]ER36148 [09]ER42183 [11]ER47496 [13]ER53196 [15]ER60211 [17]ER66212 [19]ER72212")
// 93 96+
// 1	Hour
// 2	Day
// 3	Week
// 4	Two weeks
// 5	Month
// 6	Year
// 7	Other
// 8	DK
// 9	NA; refused
// 0	Inap.

// 94-95
// 1	Year
// 2	Month
// 3	Two weeks
// 4	Week
// 8	DK
// 9	NA; refused
// 0	Inap.

combvars  salary_mjHC , list("[03]ER21182 [05]ER25171 [07]ER36176 [09]ER42209 [11]ER47522 [13]ER53222 [15]ER60237 [17]ER66240 [19]ER72240")
// BC46. About how much did you make at this job in (that period during) 2002?--AMOUNT FOR CURRENT OR MOST RECENT MAIN JOB
// -999,997.00	Loss of $999,997 or more
// -999,996.99 - -.01	Actual loss
// .01 - 9,999,996.99	Actual amount
// 9,999,997.00	$9,999,997 or more
// -999,999.00	Loss, NA, DK how much
// 9,999,998.00	DK
// 9,999,999.00	NA; refused
// 0	Inap.


* SPOUSE Per hour
combvars  salary_mjSA , list("[76]V4893 [79]V6615 [80]V7217 [81]V7888 [82]V8547 [83]V9197 [84]V10681 [85]V12017 [86]V13236 [87]V14332 [88]V15467 [89]V16985 [90]V18406 [91]V19706 [92]V21006")
* SPOUSE Per different measures
combvars  salary_mjSB , list("[93]V22817 [94]ER2576 [95]ER5575 [96]ER7671 [97]ER10574 [99]ER13730 [01]ER17799 [03]ER21403 [05]ER25400 [07]ER36405 [09]ER42434 [11]ER47752 [13]ER53458 [15]ER60473 [17]ER66486 [19]ER72488")
combvars  salary_mjSBper , list("[93]V22818 [94]ER2577 [95]ER5576 [96]ER7672 [97]ER10575 [99]ER13731 [01]ER17800 [03]ER21404 [05]ER25401 [07]ER36406 [09]ER42435 [11]ER47753 [13]ER53459 [15]ER60474 [17]ER66487 [19]ER72489")



**--------------------------------------
**   Income - HOURLY EARN
**--------------------------------------

combvars  incjob1_hH , list("[68]V337 [69]V871 [70]V1567 [71]V2279 [72]V2906 [73]V3275 [74]V3695 [75]V4174 [76]V5050 [77]V5631 [78]V6178 [79]V6771 [80]V7417 [81]V8069 [82]V8693 [83]V9379 [84]V11026 [85]V12377 [86]V13629 [87]V14676 [88]V16150 [89]V17536 [90]V18887 [91]V20187 [92]V21493 [94]ER4148 [95]ER6988 [96]ER9239 [97]ER12217 [99]ER16514 [01]ER20451 [03]ER24137 [05]ER28003 [07]ER40993 [09]ER46901 [11]ER52309 [13]ER58118 [15]ER65315 [17]ER71392 [19]ER77414")
//  Hourly Earnings - HEAD
combvars  incjob1_hS , list("[68]V338 [69]V873 [70]V1569 [71]V2281 [72]V2908 [73]V3277 [74]V3697 [75]V4176 [76]V5052 [77]V5632 [78]V6179 [79]V6772 [80]V7418 [81]V8070 [82]V8694 [83]V9380 [84]V11027 [85]V12378 [86]V13630 [87]V14677 [88]V16151 [89]V17537 [90]V18888 [91]V20188 [92]V21494 [94]ER4149 [95]ER6989 [96]ER9240 [97]ER12218 [99]ER16515 [01]ER20452 [03]ER24138 [05]ER28004 [07]ER40994 [09]ER46902 [11]ER52310 [13]ER58119 [15]ER65316 [17]ER71393 [19]ER77415")
//  Hourly Earnings - WIFE

// "[68]V355 [69]V872 [70]V1568 [71]V2280 [72]V2907 [73]V3276 [74]V3696 [75]V4175 [76]V5051"
// (Bkt. )  Average Hourly Earnings - Head


**--------------------------------------
*   HH wealth
**--------------------------------------
* hhinc_pre
* hhinc_post - //better indicator


combvars  hhinc_preHDSP , list("[68]V76 [69]V518 [70]V1205 [71]V1906 [72]V2507 [73]V3060 [74]V3472 [75]V3872 [76]V4386 [77]V5297 [78]V5796 [79]V6408 [80]V6998 [81]V7590 [82]V8283 [83]V8891 [84]V10277 [85]V11419 [86]V12818 [87]V13920 [88]V14935 [89]V16435 [90]V17851 [91]V19151 [92]V20451 [93]V21959 [94]ER4146 [95]ER6986 [96]ER9237 [97]ER12069 [99]ER16452 [01]ER20449 [03]ER24100 [05]ER27953 [07]ER40943 [09]ER46851 [11]ER52259 [13]ER58060 [15]ER65253 [17]ER71330 [19]ER77352")
// Reference Person's and Spouse's/Partner's Total Taxable Income in 2016
combvars  hhinc_preOFUM , list("[68]V79 [69]V521 [70]V1222 [71]V1924 [72]V2525 [73]V3078 [74]V3490 [75]V3891 [76]V4406 [77]V5318 [78]V5817 [79]V6428 [80]V7033 [81]V7625 [82]V8318 [83]V8926 [84]V10382 [85]V11561 [86]V12968 [87]V14070 [88]V15085 [89]V16585 [90]V18001 [91]V19301 [92]V20601 [93]V22373 [94]ER4150 [95]ER6990 [96]ER9241 [97]ER12073 [99]ER16456 [01]ER20453 [03]ER24102 [05]ER28009 [07]ER40999 [09]ER46907 [11]ER52315 [13]ER58124 [15]ER65321 [17]ER71398 [19]ER77420")
// Total Taxable Income of All Other FU Members in FU during 2016--NOT PRORATED
// -999,997 - -1	Actual loss
// 1 - 9,999,997	Actual amount
// 0	Inap.

combvars  hhinc_preALL , list("[68]V81 [69]V529 [70]V1514 [71]V2226 [72]V2852 [73]V3256 [74]V3676 [75]V4154 [76]V5029 [77]V5626 [78]V6173 [79]V6766 [80]V7412 [81]V8065 [82]V8689 [83]V9375 [84]V11022 [85]V12371 [86]V13623 [87]V14670 [88]V16144 [89]V17533 [90]V18875 [91]V20175 [92]V21481 [93]V23322 [94]ER4153 [95]ER6993 [96]ER9244 [97]ER12079 [99]ER16462 [01]ER20456 [03]ER24099 [05]ER28037 [07]ER41027 [09]ER46935 [11]ER52343 [13]ER58152 [15]ER65349 [17]ER71426 [19]ER77448")
// Total 2016 Family Money Income
//
// The income reported here was collected in 2017 about tax year 2016. Please note that this variable can contain negative values. Negative values indicate a net loss, which in waves prior to 1994 were bottom-coded at $1, as were zero amounts.
// These losses occur as a result of business or farm losses.
//
// This variable is the sum of these seven variables:
//
// ER71330 Reference Person and Spouse/Partner Taxable Income-2016
// ER71391 Reference Person and Spouse/Partner Transfer Income-2016
// ER71398 Taxable Income of Other FU Members-2016
// ER71419 Transfer Income of OFUMS-2016
// ER71420 Reference Person Social Security Income-2016
// ER71422 Spouse/Partner Social Security Income-2016
// ER71424 OFUM Social Security Income-2016	



**--------------------------------------
**   Income - subjective 
**--------------------------------------
* incsubj9



*################################
*#								#
*#	Health status				#
*#								#
*################################
**--------------------------------------
**  Self-rated health 
**--------------------------------------

combvars  srhR , list("[84]V10877 [85]V11991 [86]V13417 [87]V14513 [88]V15993 [89]V17390 [90]V18721 [91]V20021 [92]V21321 [93]V23180 [94]ER3853 [95]ER6723 [96]ER8969 [97]ER11723 [99]ER15447 [01]ER19612 [03]ER23009 [05]ER26990 [07]ER38202 [09]ER44175 [11]ER49494 [13]ER55244 [15]ER62366 [17]ER68420 [19]ER74428")
combvars  srhS , list("[84]V10884 [85]V12344 [86]V13452 [87]V14524 [88]V15999 [89]V17396 [90]V18727 [91]V20027 [92]V21328 [93]V23187 [94]ER3858 [95]ER6728 [96]ER8974 [97]ER11727 [99]ER15555 [01]ER19720 [03]ER23136 [05]ER27113 [07]ER39299 [09]ER45272 [11]ER50612 [13]ER56360 [15]ER63482 [17]ER69547 [19]ER75555")
// 1	Excellent
// 2	Very good
// 3	Good
// 4	Fair
// 5	Poor
// 8	DK
// 9	NA; refused




// local item  srhIND "[86]ER30527 [88]ER30598 [89]ER30634 [90]ER30671 [91]ER30719 [92]ER30764 [93]ER30827 [94]ER33117 [95]ER33217 [96]ER33317 [97]ER33417 [99]ER33517 [01]ER33617 [03]ER33717 [05]ER33818 [07]ER33918 [09]ER34021 [11]ER34120 [13]ER34231 [15]ER34381 [17]ER34580")
// H15. Now I have a few questions about your health, including any serious limitations you might have. Would you (HEAD) say your health in general is excellent, very good, good, fair, or poor?
// H37. Now I have a few questions about (your Wife's/"WIFE's") health. Would you say her health in general is excellent, very good, good, fair, or poor?
// H69e. Would you say (INDIVIDUAL's) health in general is excellent, very good, good, fair, or poor?
// 1	Yes, is in poor health
// 5	No, is not in poor health
// NOTE: ER30527 has 1-5 cat, later only 1 or 5. Strange Q - asked about other members. Does not corresond to srhR

	
**--------------------------------------
**  Disability 
**--------------------------------------
* disab
// H2. any physical or nervous condition that limits the type of work or the amount of work
// 	1. Yes 	
// 	5. No → GO TO H5A
// 
// 	H3 . Does this condition keep   from doing some types of work?
// 		1. Yes 
// 		5. No 
// 		7. Can do nothing -> GO TO H5A  
// 
// 		H4 . how much does it limit the amount of work 
// 			1. A lot 3. Somewhat 5. Just a little 7. Not at all (IF VOL)

combvars  disab1H , list("[72]V2718 [73]V3244 [74]V3666 [75]V4145 [76]V4625 [77]V5560 [78]V6102 [79]V6710 [80]V7343 [81]V7974 [82]V8616 [83]V9290 [84]V10879 [85]V11993 [86]V13427 [87]V14515 [88]V15994 [89]V17391 [90]V18722 [91]V20022 [92]V21322 [93]V23181 [94]ER3854 [95]ER6724 [96]ER8970 [97]ER11724 [99]ER15449 [01]ER19614 [03]ER23014 [05]ER26995 [07]ER38206 [09]ER44179 [11]ER49498 [13]ER55248 [15]ER62370 [17]ER68424 [19]ER74432")
combvars  disab1S , list("[76]V4766 [81]V7982 [82]V8619 [83]V9295 [84]V10886 [85]V12346 [86]V13462 [87]V14526 [88]V16000 [89]V17397 [90]V18728 [91]V20028 [92]V21329 [93]V23188 [94]ER3859 [95]ER6729 [96]ER8975 [97]ER11728 [99]ER15557 [01]ER19722 [03]ER23141 [05]ER27118 [07]ER39303 [09]ER45276 [11]ER50616 [13]ER56364 [15]ER63486 [17]ER69551 [19]ER75559")
// H2. (Do/Does) (you/HEAD) have any physical or nervous condition that limits the type of work or the amount of work (you/he/she) can do?
// 1	Yes
// 5	No

combvars  disab2H , list("[86]V13428 [87]V14516 [88]V15995 [89]V17392 [90]V18723 [91]V20023 [92]V21323 [93]V23182 [94]ER3855 [95]ER6725 [96]ER8971 [97]ER11725 [99]ER15450 [01]ER19615 [03]ER23015 [05]ER26996 [07]ER38207 [09]ER44180 [11]ER49499 [13]ER55249 [15]ER62371 [17]ER68425 [19]ER74433")
combvars  disab2S , list("[86]V13463 [87]V14527 [88]V16001 [89]V17398 [90]V18729 [91]V20029 [92]V21330 [93]V23189 [94]ER3860 [95]ER6730 [96]ER8976 [97]ER11729 [99]ER15558 [01]ER19723 [03]ER23142 [05]ER27119 [07]ER39304 [09]ER45277 [11]ER50617 [13]ER56365 [15]ER63487 [17]ER69552 [19]ER75560")
// H3. Does this condition keep (you/HEAD) from doing some types of work?
// 1	Yes
// 5	No
// 7	Can do nothing


combvars  disab3H , list("[68]V216 [72]V2719 [73]V3245 [74]V3667 [75]V4146 [76]V4626 [77]V5561 [78]V6103 [79]V6711 [80]V7344 [81]V7975 [82]V8617 [83]V9291 [84]V10880 [85]V11994 [86]V13429 [87]V14517 [88]V15996 [89]V17393 [90]V18724 [91]V20024 [92]V21324 [93]V23183 [94]ER3856 [95]ER6726 [96]ER8972 [97]ER11726 [99]ER15451 [01]ER19616 [03]ER23016 [05]ER26997 [07]ER38208 [09]ER44181 [11]ER49500 [13]ER55250 [15]ER62372 [17]ER68426 [19]ER74434")
combvars  disab3S , list("[76]V4767 [81]V7983 [82]V8620 [83]V9296 [84]V10887 [85]V12347 [86]V13464 [87]V14528 [88]V16002 [89]V17399 [90]V18730 [91]V20030 [92]V21331 [93]V23190 [94]ER3861 [95]ER6731 [96]ER8977 [97]ER11730 [99]ER15559 [01]ER19724 [03]ER23143 [05]ER27120 [07]ER39305 [09]ER45278 [11]ER50618 [13]ER56366 [15]ER63488 [17]ER69553 [19]ER75561")

// 68-76
// 1	Yes, complete limitation; can't work at all
// 2	Yes, severe limitation on work
// 3	Yes, some limitation on work (must rest, mentions part-time work, occasional limit on work, can't lift heavy objects, reports periods of pain, sickness, etc.)
// 4	Yes, but no limitation on work
// 5	No
// 7	Yes, NA limitation on work
// 9	NA

// 77+
// 1	A lot
// 3	Somewhat
// 5	Just a little
// 7	Not at all
// 8	DK
// 9	NA; refused
// 0	Inap

**--------------------------------------  
**  Chronic diseases
**--------------------------------------
* chron

combvars  phys_nervM , list("[72]V2718 [73]V3244 [74]V3666 [75]V4145 [76]V4625 [77]V5560 [78]V6102 [79]V6710 [80]V7343 [81]V7974 [82]V8616 [83]V9290 [84]V10879 [85]V11993 [86]V13427 [87]V14515 [88]V15994 [89]V17391 [90]V18722 [91]V20022 [92]V21322 [93]V23181 [94]ER3854 [95]ER6724 [96]ER8970 [97]ER11724 [99]ER15449 [01]ER19614 [03]ER23014 [05]ER26995 [07]ER38206 [09]ER44179 [11]ER49498 [13]ER55248 [15]ER62370 [17]ER68424 [19]ER74432")
// H2. (Do you/Does Reference Person) have any physical or nervous condition that limits the type of work or the amount of work (you/he/she) can do?
// 1	Yes
// 5	No
combvars  phys_nervF1_ , list("[86]V13428 [87]V14516 [88]V15995 [89]V17392 [90]V18723 [91]V20023 [92]V21323 [93]V23182 [94]ER3855 [95]ER6725 [96]ER8971 [97]ER11725 [99]ER15450 [01]ER19615 [03]ER23015 [05]ER26996 [07]ER38207 [09]ER44180 [11]ER49499 [13]ER55249 [15]ER62371 [17]ER68425 [19]ER74433")
// H3. Does this condition keep (you/Reference Person) from doing some types of work?
// 1	Yes
// 5	No
// 7	Can do nothing
combvars  phys_nervF2_ , list("[68]V216 [72]V2719 [73]V3245 [74]V3667 [75]V4146 [76]V4626 [77]V5561 [78]V6103 [79]V6711 [80]V7344 [81]V7975 [82]V8617 [83]V9291 [84]V10880 [85]V11994 [86]V13429 [87]V14517 [88]V15996 [89]V17393 [90]V18724 [91]V20024 [92]V21324 [93]V23183 [94]ER3856 [95]ER6726 [96]ER8972 [97]ER11726 [99]ER15451 [01]ER19616 [03]ER23016 [05]ER26997 [07]ER38208 [09]ER44181 [11]ER49500 [13]ER55250 [15]ER62372 [17]ER68426 [19]ER74434")
// H4. For work (you/Reference Person) can do, how much does it limit the amount of work (you/Reference Person) can do--a lot, somewhat, or just a little?
// 1	A lot
// 3	Somewhat
// 5	Just a little
// 7	Not at all
// 8	DK
// 9	NA; refused
// 0	Inap


// There is a list of diseases to pick from in H5 (2017 quest) - please specify 
// depending on research questions 

	
*################################
*#								#
*#	Subjective wellbeing		#
*#								#
*################################
**--------------------------------------
**   Satisfaction with  
**--------------------------------------
* sat_life sat_work sat_fam sat_finhh sat_finind sat_hlth
 
combvars  sat_life , list("[09]ER42024 [11]ER47324 [13]ER53024 [15]ER60025 [17]ER66025 [19]ER72025")
// A3. Please think about your life as a whole. How satisfied are you with it? Are you completely satisfied, very satisfied, somewhat satisfied, not very satisfied, or not at all satisfied?
// 1	Completely satisfied
// 5	Not at all satisfied


 
*################################
*#								#
*#	Other						#
*#								#
*################################
**--------------------------------------
**   Training
**--------------------------------------
* train train2

combvars  edu_tr_y1_ , list("[85]V11970 [86]V13593 [87]V14640 [88]V16114 [89]V17511 [90]V18842 [91]V20142 [92]V21448 [93]V23304 [94]ER3977 [95]ER6847 [96]ER9087 [97]ER11881 [99]ER15963 [01]ER20024 [03]ER23460 [05]ER27428 [07]ER40600 [09]ER46578 [11]ER51939 [13]ER57695 [15]ER64855 [17]ER70927 [19]ER76946")
combvars  edu_tr_y2_ , list("[85]V11975 [86]V13598 [87]V14645 [88]V16119 [89]V17516 [90]V18847 [91]V20147 [92]V21453 [93]V23309 [94]ER3978 [95]ER6848 [96]ER9092 [97]ER11887 [99]ER15969 [01]ER20030 [03]ER23466 [05]ER27434 [07]ER40606 [09]ER46584 [11]ER51945 [13]ER57701 [15]ER64861 [17]ER70933 [19]ER76952") 
combvars  edu_tr_y3_ , list("[85]V11980 [86]V13603 [87]V14650 [88]V16124 [89]V17521 [90]V18852 [91]V20152 [92]V21458 [93]V23314 [94]ER3979 [95]ER6849 [96]ER9097 [97]ER11893 [99]ER15975 [01]ER20036 [03]ER23472 [05]ER27440 [07]ER40612 [09]ER46590 [11]ER51951 [13]ER57707 [15]ER64867 [17]ER70939 [19]ER76958")
// In what month and year did [you / she / he] receive that degree or certificate? [year]

// edu_tr_m1 "[85]V11969 [86]V13592 [87]V14639 [88]V16113 [89]V17510 [90]V18841 [91]V20140 [92]V21447 [93]V23303 [94]ER3974 [95]ER6844 [96]ER9086 [97]ER11880 [99]ER15962 [01]ER20023 [03]ER23459 [05]ER27427 [07]ER40599 [09]ER46577 [11]ER51938 [13]ER57694 [15]ER64854 [17]ER70926")
// edu_tr_m2 "[85]V11974 [86]V13597 [87]V14644 [88]V16118 [89]V17515 [90]V18846 [91]V20146 [92]V21452 [93]V23308 [94]ER3975 [95]ER6845 [96]ER9091 [97]ER11886 [99]ER15968 [01]ER20029 [03]ER23465 [05]ER27433 [07]ER40605 [09]ER46583 [11]ER51944 [13]ER57700 [15]ER64860 [17]ER70932")
// edu_tr_m3 "[85]V11979 [86]V13602 [87]V14649 [88]V16123 [89]V17520 [90]V18851 [91]V20151 [92]V21457 [93]V23313 [94]ER3976 [95]ER6846 [96]ER9096 [97]ER11892 [99]ER15974 [01]ER20035 [03]ER23471 [05]ER27439 [07]ER40611 [09]ER46589 [11]ER51950 [13]ER57706 [15]ER64866 [17]ER70938")
// In what month and year did [you / she / he] receive that degree or certificate? [month]

combvars  edu_tr_ans1_ , list("[75]V4095 [76]V4686 [77]V5610 [78]V6159 [79]V6756 [80]V7389 [81]V8041 [82]V8665 [83]V9351 [84]V10998 [85]V11968 [86]V13591 [87]V14638 [88]V16112 [89]V17509 [90]V18840 [91]V20141 [92]V21446 [93]V23302 [94]ER3971 [95]ER6841 [96]ER9085 [97]ER11879 [99]ER15961 [01]ER20022 [03]ER23458 [05]ER27426 [07]ER40598 [09]ER46576 [11]ER51937 [13]ER57693 [15]ER64853 [17]ER70925 [19]ER76944")
combvars  edu_tr_ans2_ , list("[75]V4098 [76]V4689 [77]V5613 [78]V6162 [79]V6759 [80]V7392 [81]V8044 [82]V8668 [83]V9354 [84]V11001 [85]V11973 [86]V13596 [87]V14643 [88]V16117 [89]V17514 [90]V18845 [91]V20145 [92]V21451 [93]V23307 [94]ER3972 [95]ER6842 [96]ER9090 [97]ER11885 [99]ER15967 [01]ER20028 [03]ER23464 [05]ER27432 [07]ER40604 [09]ER46582 [11]ER51943 [13]ER57699 [15]ER64859 [17]ER70931  [19]ER76950")
combvars  edu_tr_ans3_ , list("[85]V11978 [86]V13601 [87]V14648 [88]V16122 [89]V17519 [90]V18850 [91]V20150 [92]V21456 [93]V23312 [94]ER3973 [95]ER6843 [96]ER9095 [97]ER11891 [99]ER15973 [01]ER20034 [03]ER23470 [05]ER27438 [07]ER40610 [09]ER46588 [11]ER51949 [13]ER57705 [15]ER64865 [17]ER70937 [19]ER76956")
// L65. From what type of institution or organization was that?--FIRST DEGREE OR CERTIFICATE
// 1	Vocational/trade school
// 2	Community college; junior college
// 3	Business school or financial institute; secretarial school
// 4	Armed forces
// 5	High school
// 6	Hospital/health care facility or school
// 7	Cosmetology/beauty/barber school
// 8	Police academy; firefighter training program
// 9	Job training through city/county/state/federal government, except code 8
// 10	Training by private employer
// 11	Religious institution; bible college/school
// 97	Other
// 99	DK; NA; refused
// 0	Inap.:


**--------------------------------------
**   work-edu link NA
**--------------------------------------
* eduwork



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


	
	
**--------------------------------------
**   Job security NA
**--------------------------------------



**--------------------------------------
** Parents' education   
**--------------------------------------

combvars  feduH , list("[68]V318 [69]V793 [70]V1484 [71]V2196 [72]V2822 [73]V3240 [74]V3662 [75]V4138 [76]V4681 [77]V5601 [78]V6150 [79]V6747 [80]V7380 [81]V8032 [82]V8656 [83]V9342 [84]V10989 [85]V11922 [86]V13549 [87]V14596 [88]V16070 [89]V17467 [90]V18798 [91]V20098 [92]V21404 [93]V23260 [94]ER3924 [95]ER6794 [96]ER9040 [97]ER11816 [99]ER15894 [01]ER19955 [03]ER23392 [05]ER27356 [07]ER40531 [09]ER46508 [11]ER51869 [13]ER57622 [15]ER64773 [17]ER70845 [19]ER76860")

combvars  feduS , list("[74]V3608 [75]V4108 [76]V4753 [77]V5572 [78]V6121 [79]V6718 [80]V7351 [81]V8003 [82]V8627 [83]V9313 [84]V10960 [85]V12277 [86]V13485 [87]V14532 [88]V16006 [89]V17403 [90]V18734 [91]V20034 [92]V21340 [93]V23197 [94]ER3864 [95]ER6734 [96]ER8980 [97]ER11735 [99]ER15809 [01]ER19870 [03]ER23307 [05]ER27267 [07]ER40442 [09]ER46414 [11]ER51775 [13]ER57512 [15]ER64634 [17]ER70707 [19]ER76715")

// How much education did (your/his/her) father complete



combvars  meduH , list("[74]V3634 [75]V4139 [76]V4682 [77]V5602 [78]V6151 [79]V6748 [80]V7381 [81]V8033 [82]V8657 [83]V9343 [84]V10990 [85]V11923 [86]V13550 [87]V14597 [88]V16071 [89]V17468 [90]V18799 [91]V20099 [92]V21405 [93]V23261 [94]ER3926 [95]ER6796 [96]ER9042 [97]ER11824 [99]ER15903 [01]ER19964 [03]ER23401 [05]ER27366 [07]ER40541 [09]ER46518 [11]ER51879 [13]ER57632 [15]ER64783 [17]ER70855 [19]ER76870")

combvars  meduS , list("[74]V3609 [75]V4109 [76]V4754 [77]V5573 [78]V6122 [79]V6719 [80]V7352 [81]V8004 [82]V8628 [83]V9314 [84]V10961 [85]V12278 [86]V13486 [87]V14533 [88]V16007 [89]V17404 [90]V18735 [91]V20035 [92]V21341 [93]V23198 [94]ER3866 [95]ER6736 [96]ER8982 [97]ER11743 [99]ER15818 [01]ER19879 [03]ER23316 [05]ER27277 [07]ER40452 [09]ER46424 [11]ER51785 [13]ER57522 [15]ER64644 [17]ER70717 [19]ER76725")

// How much education did (your/his/her) mother complete 

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
// 0	Inap.:

*################################

*#  Ethnicity                   #

*################################

// Note: only using mention 1

**--------------------------------------
** ethnicity 
**--------------------------------------
combvars race_H, list("[68]V181 [69]V801 [70]V1490 [71]V2202 [72]V2828 [73]V3300 [74]V3720 [75]V4204 [76]V5096 [77]V5662 [78]V6209 [79]V6802 [80]V7447 [81]V8099 [82]V8723 [83]V9408 [84]V11055 [85]V11938 [86]V13565 [87]V14612 [88]V16086 [89]V17483 [90]V18814 [91]V20114 [92]V21420 [93]V23276 [94]ER3944 [95]ER6814 [96]ER9060 [97]ER11848 [99]ER15928 [01]ER19989 [03]ER23426 [05]ER27393 [07]ER40565 [09]ER46543 [11]ER51904 [13]ER57659 [15]ER64810 [17]ER70882 [19]ER76897") //Head

combvars race_S, list("[85]V12293 [86]V13500 [87]V14547 [88]V16021 [89]V17418 [90]V18749 [91]V20049 [92]V21355 [93]V23212 [94]ER3883 [95]ER6753 [96]ER8999 [97]ER11760 [99]ER15836 [01]ER19897 [03]ER23334 [05]ER27297 [07]ER40472 [09]ER46449 [11]ER51810 [13]ER57549 [15]ER64671 [17]ER70744 [19]ER76752") //Spouse

/**
1	White
2	Black, African-American, or Negro
3	American Indian or Alaska Native
4	Asian
5	Native Hawaiian or Pacific Islander
7	Other
0	Wild code
9	NA; DK
*/

**--------------------------------------
** Ethnicity (Hispanic)  
**--------------------------------------
combvars hispanic_H, list("[85]V11937 [86]V13564 [87]V14611 [88]V16085 [89]V17482 [90]V18813 [91]V20113 [92]V21419 [93]V23275 [94]ER3941 [95]ER6811 [96]ER9057 [05]ER27392 [07]ER40564 [09]ER46542 [11]ER51903 [13]ER57658 [15]ER64809 [17]ER70881 [19]ER76896")

combvars hispanic_S, list("[85]V12292 [86]V13499 [87]V14546 [88]V16020 [89]V17417 [90]V18748 [91]V20048 [92]V21354 [93]V23211 [94]ER3880 [95]ER6750 [96]ER8996 [05]ER27296 [07]ER40471 [09]ER46448 [11]ER51809 [13]ER57548 [15]ER64670 [17]ER70743 [19]ER76751")

/*
G31/L39 'Are you Spanish, Hispanic, or Latino?--That is, Mexican, Mexican American, Chicano, Puerto Rican, Cuban, or other Spanish?'
1	Mexican
2	Mexican American
3	Chicano
4	Puerto Rican
5	Cuban
6	Combination; more than 1 mention
7	Other Spanish; Hispanic; Latino
9	DK/NA/Refusal
0	Inap:
*/

*################################

*#  Migration                   #

*################################

**-------------------------------------------
** Country of Birth (respondent and parents)  
**-------------------------------------------
combvars country_born, list("[97]ER33422" "[99]ER33525") //ind file --> if cob is not US. For coding see do-file "us_02add_labels_COB.do"

combvars state_born, list("[97]ER33421 [99]ER33524") // state info 97 and 99

combvars state_H, list("[13]ER57651" "[15]ER64802" "[17]ER70874" "[19]ER76889") //Head

combvars state_S, list("[13]ER57541" "[15]ER64663" "[17]ER70736" "[19]ER76744") //Spouse

/* 
L33: 'Where (were/was) (you/HEAD) born? (What State is that in?)'
1. - 56.	Actual State (FIPS code)
99			DK/NA/Refusal
0			Inap: US territory or foreign country
*/

***region growing up, only supplementary***
combvars grewup_H, list("[68]V362 [69]V877 [70]V1573 [71]V2285 [72]V2912 [73]V3280 [74]V3700 [75]V4179 [76]V5055 [77]V5634 [78]V6181 [79]V6774 [80]V7420 [81]V8072 [82]V8696 [83]V9382 [84]V11029 [85]V12383 [86]V13635 [87]V14682 [88]V16156 [89]V17542 [90]V18893 [91]V20193 [92]V21499 [93]V23331 [94]ER4157C [95]ER6997C [96]ER9248C [97]ER12221C [99]ER16431A [01]ER20377A [03]ER24146 [05]ER28045 [07]ER41035 [09]ER46977 [11]ER52401 [13]ER58219 [15]ER65455 [17]ER71534 [19]ER77595") // Region where head grew up

combvars grewup_S, list("[76]V5100 [85]V12387 [09]ER46979 [11]ER52403 [13]ER58221 [15]ER65457 [17]ER71536 [19]ER77597") //Spouse region


*parents born (state)
combvars cob_f_H, list("[97]ER11813" "[99]ER15891" "[01]ER19952" "[03]ER23389" "[05]ER27353" "[07]ER40528" "[09]ER46505" "[11]ER51866" "[13]ER57619" "[15]ER64770" "[17]ER70842" "[19]ER76857") 

combvars cob_m_H, list("[97]ER11821" "[99]ER15900" "[01]ER19961" "[03]ER23398" "[05]ER27363" "[07]ER40538" "[09]ER46515" "[11]ER51876" "[13]ER57629" "[15]ER64780" "[17]ER70852" "[19]ER76867")

combvars cob_f_S, list("[97]ER11732" "[99]ER15806" "[01]ER19867" "[03]ER23304" "[05]ER27264" "[07]ER40439" "[09]ER46411" "[11]ER51772" "[13]ER57509" "[15]ER64631" "[17]ER70704" "[19]ER76712")

combvars cob_m_S, list("[97]ER11740" "[99]ER15815" "[01]ER19876" "[03]ER23313" "[05]ER27274" "[07]ER40449" "[09]ER46421" "[11]ER51782" "[13]ER57519" "[15]ER64641" "[17]ER70714" "[19]ER76722")

/*coding
L2. 'Where was your father born? (FIPS code)'
1. - 56.	Actual State (FIPS code)
99			DK/NA/Refusal
0			Inap: US territory or foreign country
*/

**--------------------------------------
** Language spoken as child
**--------------------------------------
//Note: coding changed after 2000

combvars lcA_H, list("[97]ER11936" "[99]ER16023") // English first language
combvars lcB_H, list("[17]ER70983" "[19]ER77005") // first language open question

combvars lcA_S, list("[97]ER12018" "[99]ER16110") //English first language
combvars lcB_S, list("[17]ER71012" "[19]ER77034") // first language open question

/*
coding '97 & '99
M33. 'Was English the first lagnuage that you learned to speak when you were a child?'
1	yes
5	no
8	DK
9	NA/Refusal
0	Inap: 
*/

/*
coding '17 & '19
IMM3. 'What language did you speak at home with your parents when you were age 10?'  (first mention)
1. 		English
2.-17	Non-English languages
97		Other
98		DK
99		NA/Refusal
0		Inap: 
*/

*################################

*#    Religion                  #

*################################

**----------------------------------
**  Religiosity
**----------------------------------

combvars rel_pref_H1, list("[70]V1431 [71]V2187 [72]V2813 [73]V3231 [74]V3653 [75]V4129 [77]V5617 [79]V6763 [80]V7396 [81]V8048 [82]V8672 [83]V9358 [84]V11005")  //Protestantism

combvars rel_pref_H2, list("[76]V4693 [85]V11981 [86]V13604 [87]V14651 [88]V16125 [89]V17522 [90]V18853 [91]V20153 [92]V21459 [93]V23315 [94]ER3983 [95]ER6853 [96]ER9099 [97]ER11895 [99]ER15977 [01]ER20038 [03]ER23474 [05]ER27442 [07]ER40614 [09]ER46592 [11]ER51953 [13]ER57709 [15]ER64869 [17]ER70941 [19]ER76960") // religious preference head

combvars rel_pref_S, list("[76]V4765 [85]V12336 [86]V13530 [87]V14577 [88]V16051 [89]V17448 [90]V18779 [91]V20079 [92]V21385 [93]V23242 [94]ER3913 [95]ER6783 [96]ER9029 [97]ER11807 [99]ER15884 [01]ER19945 [03]ER23382 [05]ER27346 [07]ER40521 [09]ER46498 [11]ER51859 [13]ER57599 [15]ER64730 [17]ER70803 [19]ER76815") // religious preference spouse 

**----------------------------------
**  Religion - Attendance
**----------------------------------

combvars rel_att1, list("[68]V284 [69]V763 [70]V1430 [71]V2142 [72]V2783") // 68-72

combvars rel_att2_H, list("[03]ER23699 [05]ER27708 [11]ER52046 [17]ER71064 [19]ER77086") // Head after 2000

combvars rel_att2_S, list("[03]ER23701 [05]ER27710 [11]ER52064 [17]ER71066 [19]ER77088") // Spouse after 2000

*################################  
*#								#
*#	Technical					#
*#								#
*################################	
* weights

combvars  w_indAcore , list("[68]ER30019 [69]ER30042 [70]ER30066 [71]ER30090 [72]ER30116 [73]ER30137 [74]ER30159 [75]ER30187 [76]ER30216 [77]ER30245 [78]ER30282 [79]ER30312 [80]ER30342 [81]ER30372 [82]ER30398 [83]ER30428 [84]ER30462 [85]ER30497 [86]ER30534 [87]ER30569 [88]ER30605 [89]ER30641 [90]ER30686 [91]ER30730 [92]ER30803")
// Individual Weight.
// 1968:
// Weights are based on the family-level weight calculated originally in 1968. 
// Each person from the core sample with an original sample person number (ER30002) 
// in the range 1-26 received the family weight for this variable, including those 
// sample members who were erroneously not listed in the 1968 FU (ER30001=0001-2930, 
// 5001-6872 and ER30002=001-026 and ER30003=00). Refer to the 1968-1972 documentation 
// volume, Vol. I, pp. 9-23, for details.
// --
// 1992:
// This weight variable is to be used only for analysis of the core sample. If you wish 
// to analyze both the core and Latino samples, then see ER30732. If you wish to analyze 
// only the Latino sample, then see ER30804. This variable is nonzero only for sample 
// members associated with a 1992 core sample response family. Sample members born into 
// the family in 1992 receive either the average of the Head's and spouse's weights or, 
// in the event of a single Head, the child receives the Head's weight. For those sample 
// members either not yet part of the family in 1989 but present by 1992 or who were main 
// family nonresponse in 1989 and moved back into the panel in 1992, the most recent weight 
// is brought forward to these positions. Refer to Section I, Part 5, of the guide to the 
// 1993 family data, 93GUIDE.PDF, for details on the weights themselves.
// --
// I-l: Note that the weight variables are not comparable across waves. Three types of 
// weights (core only, Latino only and combined core-Latino) were created for 1990 through 
// 1995 because of the addition of the Latino sample. Beginning in 1993, weighting philosophy 
// for recontacts changed. See Section I, Part 5 of the 1993, the 1990 and the 1992 
// documentation or the User Guide for further information and details. Weights were 
// retroactively recalculated for all years in 1989.
 
combvars  w_indBcomb , list("[90]ER30688 [91]ER30732 [92]ER30805")
// Combined Core-Latino Weight
// This weight variable is to be used only for combined analysis of the core and Latino samples. 
// If you wish to analyze only the core sample, then see ER30686. If you wish to analyze only the 
// Latino sample, then see ER30687. This variable is nonzero only for sample members associated 
// with a 1990 core or Latino sample family. Refer to Section I, Part 5, of the guide to the 1993 
// family data, 93GUIDE.PDF, for details about the creation of the combined weight.

combvars  w_indCcore , list("[93]ER30864 [94]ER33119 [95]ER33275 [96]ER33318")
// Core Sample Individual Longitudinal Weight
combvars  w_indCcomb	, list("[93]ER30866 [94]ER33121 [95]ER33277")
// Combined Core-Latino Sample Longitudinal Weight

combvars  w_indDcomb , list("[97]ER33430 [99]ER33546 [01]ER33637 [03]ER33740 [05]ER33848 [07]ER33950 [09]ER34045 [11]ER34154 [13]ER34268 [15]ER34413 [17]ER34650 [19]ER34863")
// Combined Core-Immigrant Sample Individual Longitudinal Weight
// 1997 Combined Core-Immigrant Sample Individual Longitudinal Weight
// This individual weight was recalculated for Release 3. For details on the construction of this weight, go to the PSID website, psidonline.isr.umich.edu/: select 'Data & Documentation', then select 'Sample Weights', then 'PSID Longitudinal Weights', and 'PSID Revised Longitudinal Weights 1993-2005'.
// This weight variable enfolds the Immigrant sample begun in this wave. Values are nonzero for sample members associated with either a 1997 core or 1997 Immigrant response family. No weight variable exists for analysis of the core or the Immigrant samples separately.
// The range of possible values for this variable is .287-167.679

combvars  w_indDcross , list("[97]ER33438 [99]ER33547 [01]ER33639 [03]ER33742 [05]ER33849 [07]ER33951 [09]ER34046 [11]ER34155 [13]ER34269 [15]ER34414 [17]ER34651 [19]ER34864") 
// Core-Immigrant Individual Cross-sectional Weight

*** Interview date
combvars  intyA , list("[68]V99 [69]V553 [70]V1236 [71]V1939 [72]V2539 [73]V3092 [74]V3505 [75]V3918 [76]V4433 [77]V5347 [78]V5847 [79]V6459 [80]V7064 [81]V7655 [82]V8349 [83]V8958 [84]V10416 [85]V11600 [86]V13008 [87]V14111 [88]V15127 [89]V16628 [90]V18046 [91]V19346 [92]V20648 [93]V22403 [94]ER2005 [95]ER5004 [96]ER7004")
combvars  intyB , list("[97]ER10007 [99]ER13008 [01]ER17011 [03]ER21014 [05]ER25014 [07]ER36014 [09]ER42014 [11]ER47314 [13]ER53014 [15]ER60014 [17]ER66014 [19]ER72014")
combvars  intyB2, list("[97]ER10005 [99]ER13006 [01]ER17009 [03]ER21012 [05]ER25012 [07]ER36012 [09]ER42012 [11]ER47312 [13]ER53012 [15]ER60012 [17]ER66012 [19]ER72012")

*** Relationship to Reference Person
combvars  refer , list("[68]ER30003 [69]ER30022 [70]ER30045 [71]ER30069 [72]ER30093 [73]ER30119 [74]ER30140 [75]ER30162 [76]ER30190 [77]ER30219 [78]ER30248 [79]ER30285 [80]ER30315 [81]ER30345 [82]ER30375 [83]ER30401 [84]ER30431 [85]ER30465 [86]ER30500 [87]ER30537 [88]ER30572 [89]ER30608 [90]ER30644 [91]ER30691 [92]ER30735 [93]ER30808 [94]ER33103 [95]ER33203 [96]ER33303 [97]ER33403 [99]ER33503 [01]ER33603 [03]ER33703 [05]ER33803 [07]ER33903 [09]ER34003 [11]ER34103 [13]ER34203 [15]ER34303 [17]ER34503 [19]ER34703")
// Note that these relationships are those to the 2015 Reference Person for any individual whose 2017 
// sequence number (ER34502) is greater than 50; that is, individual has moved out of the FU. 
// Thus, for example, if the 2015 Reference Person is no longer present at the time of the 2017 
// interview, his or her relationship to Reference Person is coded 10; the new 2017 
// Reference Person also is coded 10. Therefore, to select current Reference Persons, 
// the user must select those coded 10 in this variable whose sequence numbers (ER34502) are coded 01.

// 1984+ codes:
// 10	Reference Person in 2017; 2015 Reference Person who was mover-out nonresponse by the time of the 2017 interview
// 20	Legal Spouse in 2017; 2015 Spouse who was mover-out nonresponse by the time of the 2017 interview
// 22	Partner--cohabitor who has lived with Reference Person for 12 months or more; 2015 Partner who was mover-out nonresponse by the time of the 2017 interview
// 30	Son or daughter of Reference Person (includes adopted children but not stepchildren)
// 33	Stepson or stepdaughter of Reference Person (children of legal Spouse [code 20] who are not children of Reference Person)
// 35	Son or daughter of Partner but not Reference Person (includes only those children of mothers whose relationship to Reference Person is 22 but who are not children of Reference Person)
// 37	Son-in-law or daughter-in-law of Reference Person (includes stepchildren-in-law)
// 38	Foster son or foster daughter, not legally adopted
// 40	Brother or sister of Reference Person (includes step and half sisters and brothers)
// 47	Brother-in-law or sister-in-law of Reference Person (i.e., brother or sister of legal Spouse; spouse of HD's brother or sister; spouse of legal Spouse's brother or sister)
// 48	Brother or sister of Reference Person's cohabitor (the cohabitor is coded 22 or 88)
// 50	Father or mother of Reference Person (includes stepparents)
// 57	Father-in-law or mother-in-law of Reference Person (includes parents of legal spouses [code 20] only)
// 58	Father or mother of Reference Person's cohabitor (the cohabitor is coded 22 or 88)
// 60	Grandson or granddaughter of Reference Person (includes grandchildren of legal Spouse [code 20] only; those of a cohabitor are coded 97)
// 65	Great-grandson or great-granddaughter of Reference Person (includes great-grandchildren of legal Spouse [code 20]; those of a cohabitor are coded 97)
// 66	Grandfather or grandmother of Reference Person (includes stepgrandparents)
// 67	Grandfather or grandmother of legal Spouse (code 20)
// 68	Great-grandfather or great-grandmother of Reference Person
// 69	Great-grandfather or great-grandmother of legal Spouse (code 20)
// 70	Nephew or niece of Reference Person
// 71	Nephew or niece of legal Spouse (code 20)
// 72	Uncle or Aunt of Reference Person
// 73	Uncle or Aunt of legal Spouse (code 20)
// 74	Cousin of Reference Person
// 75	Cousin of legal Spouse (code 20)
// 83	Children of first-year cohabitor but not of Reference Person (the parent of this child is coded 88)
// 88	First-year cohabitor of Reference Person
// 90	Uncooperative legal spouse of Reference Person (this individual is unable or unwilling to be designated as Reference Person or Spouse)
// 92	Uncooperative partner of Reference Person (this individual is unable or unwilling to be designated as Partner)
// 95	Other relative of Reference Person
// 96	Other relative of legal Spouse (code 20)
// 97	Other relative of cohabitor (the cohabitor is code 22 or 88)
// 98	Other nonrelatives (includes friends of children of the FU, boyfriend/girlfriend of son/daughter, et al.)
// 0	Inap.: from Latino sample (ER30001=7001-9308); main family nonresponse by 2017 or mover-out nonresponse by 2015 (ER34502=0)

// 1968-1983 codes:
// 1	Head
// 2	Wife/"Wife"
// 3	Son or daughter
// 4	Brother or sister
// 5	Father or mother
// 6	Grandchild, niece, nephew, other relatives under 18
// 7	Other, including in-laws, other adult relatives
// 8	Husband or Wife of Head who moved out or died in the year prior to the 1968 interview
// 9	NA
// 0	Individual from core sample who was born or moved in after the 1968 interview; individual from Immigrant or Latino samples (ER30001=3001-3511, 4001-4462,7001-9308)


// Interview Number (NOT WORKING with psidtools)
// combvars  id_ind , list("[68]ER30001 [69]ER30020 [70]ER30043 [71]ER30067 [72]ER30091 [73]ER30117 [74]ER30138 [75]ER30160 [76]ER30188 [77]ER30217 [78]ER30246 [79]ER30283 [80]ER30313 [81]ER30343 [82]ER30373 [83]ER30399 [84]ER30429 [85]ER30463 [86]ER30498 [87]ER30535 [88]ER30570 [89]ER30606 [90]ER30642 [91]ER30689 [92]ER30733 [93]ER30806 [94]ER33101 [95]ER33201 [96]ER33301 [97]ER33401 [99]ER33501 [01]ER33601 [03]ER33701 [05]ER33801 [07]ER33901 [09]ER34001 [11]ER34101 [13]ER34201 [15]ER34301 [17]ER34501")
// The values for this variable represent the 2017 interview number of the family 
// in which this individual was included in 2017. We interviewed 9,607 families in 2017.


// Interview Number (NOT WORKING with psidtools)
// combvars  id_fam , list("[68]V3 [69]V442 [70]V1102 [71]V1802 [72]V2402 [73]V3002 [74]V3402 [75]V3802 [76]V4302 [77]V5202 [78]V5702 [79]V6302 [80]V6902 [81]V7502 [82]V8202 [83]V8802 [84]V10002 [85]V11102 [86]V12502 [87]V13702 [88]V14802 [89]V16302 [90]V17702 [91]V19002 [92]V20302 [93]V21602 [94]ER2002 [95]ER5002 [96]ER7002 [97]ER10002 [99]ER13002 [01]ER17002 [03]ER21002 [05]ER25002 [07]ER36002 [09]ER42002 [11]ER47302 [13]ER53002 [15]ER60002 [17]ER66002")
// The values for this variable represent the 2017 interview number. The case count for 2017 is 9607 Values for this variable may not be contiguous.

// WHO WAS RESPONDENT
combvars  who_resp , list("[68]V180 [69]V800 [70]V1489 [71]V2201 [72]V2827 [73]V3248 [74]V3670 [75]V4149 [76]V4700 [77]V5618 [78]V6165 [79]V6764 [80]V7397 [81]V8049 [82]V8673 [83]V9359 [84]V11006 [85]V12354 [86]V13607 [87]V14654 [88]V16128 [89]V17525 [90]V18856 [91]V20156 [92]V21462 [93]V23318 [94]ER2013 [95]ER5012 [96]ER7012 [97]ER10015 [99]ER13016 [01]ER17019 [03]ER24073 [05]ER27879 [07]ER40869 [09]ER46697 [11]ER52097 [13]ER57901 [15]ER65081 [17]ER71164 [19]ER77186")
// 1	Current head
// 2	Wife or new wife
// 3	"Wife" or new "wife"
// 4	Other FU member
// 7	Proxy R; not a member of this FU

// RESPONDENT?
combvars  isresp , list("[69]ER30031 [70]ER30055 [71]ER30079 [72]ER30104 [73]ER30128 [74]ER30149 [75]ER30170 [76]ER30200 [77]ER30229 [78]ER30266 [79]ER30292 [80]ER30322 [81]ER30352 [82]ER30381 [83]ER30410 [84]ER30440 [99]ER33511 [01]ER33611 [03]ER33711 [05]ER33811 [07]ER33911 [09]ER34011 [11]ER34111 [13]ER34211 [15]ER34312 [17]ER34511 [19]ER34711")
// 1	This individual was respondent
// 5	This individual was not respondent;
// 9	NA; DK


**|=========================================================================|
**|  Step 3: Combine single-item long files together 
**|=========================================================================|

// di "${vars}"


tokenize "${vars}"
local n : word count ${vars}
// di `n'
use "${psid_out_work}\temp_`1'.dta", clear 
local i 2
while (`i'<=`n') {
	merge 1:1 x11101ll wave using "${psid_out_work}\temp_`2'.dta" , ///
		keep(1 2 3) nogen 
		macro shift 1  
		local ++i
}
*
rename x11101ll pid
disp "vars: " c(k) "   N: " _N
*
save "${psid_out}\us_01.dta", replace 


**|=========================================================================|
**|  Step 4: Add vars constant across all waves (get from long psid_crossy_ind.dta)
**|=========================================================================|

use "${psid_out}\us_01.dta", clear
*
merge m:1 pid using "${psid_org}" ,	///
	keepusing(				///
		ER30001				/// id (for samplid)
		ER32000   			/// Gender -constant for all waves 
		ER32022 			/// # LIVE BIRTHS TO THIS INDIVIDUAL
		ER30003				/// 1968 Relationship to Head 
		ER32049   			/// 	LAST KNOWN MARITAL STATUS
		ER32033				///
		ER31996 			/// 	SAMPLING ERROR STRATUM
		ER31997				///		SAMPLING ERROR CLUSTER
		) keep(1 2 3) nogen
rename ER32000 gender 
rename ER32022 kids_birth
rename ER30003 head68
*
disp "vars: " c(k) "   N: " _N
*
save "${psid_out}\us_01.dta", replace 


**|=========================================================================|
**|  Add new time-constant vars - only if necessary 
**|=========================================================================|
/*
use "${psid_out}\us_01.dta", clear
*
merge m:1 pid using "${psid_org}" ,	///
	keepusing(						///
	/**/  	/**/					/// Add itme-block name between /**/ _name_ /**/ 
		) keep(1 2 3) nogen
*
save "${psid_out}\us_01.dta", replace 
*/

   
**|=========================================================================|
**|  Add new files - only if neccessary 
**|=========================================================================|
/* NOTE:
- use if you added a new block of items using combvars (after creating us_01.dta)
*/
 

/*
local item_block /**/ 	  	/**/ 		// Add itme-block name between /**/ _name_ /**/ 
foreach file in `item_block' {
	use "${psid_out_work}\temp_`file'.dta", clear
	rename x11101ll pid 
	save "${psid_out_work}\temp_`file'.dta", replace
	}
	
use "${psid_out}\us_01.dta", clear
	foreach file in `item_block'  {
		merge 1:1 pid wave using "${psid_out_work}\temp_`file'.dta" , ///
				keep(1 2 3) nogen 
}
save "${psid_out}\us_01.dta", replace 
*/



**|=========================================================================|
**|  SAVE
**|=========================================================================|

save "${psid_out}\us_01.dta", replace 

!del "${psid_out_work}\*.dta"  	// remove files in the temp folder 
	
	


	 
*____________________________________________________________________________
*--->	END	 <---











