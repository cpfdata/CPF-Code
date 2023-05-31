*
**|=============================================|
**|	    ####	CPF v1.5		####			|
**|		>>>	PSID						 		|
**|		>>	03_ Sample selection		 		|
**|---------------------------------------------|
**|		Konrad Turek 	| 	2023				|			
**|=============================================|



**--------------------------------------
** Data
**--------------------------------------
use "${psid_out}\us_02_CPF.dta" , clear


*############################
*#							#
*#	Criteria				#
*#							#
*############################
**--------------------------------------
** Intreview status
**--------------------------------------
// keep if  ==1  // Interviewed  



	**--------------------------------------
	** Keep selected obs
	**-------------------------------------- 
	* See e.g. https://www.youtube.com/watch?v=BIiD3eRWNUU

	*** Keep 1: ind with info:
	// drop if intyear>1968 & (xsqnr==0 | xsqnr>=80)

	*** Keep 2: spouses & partners: 
	keep if (href==1|href==2) & 							///
				( (intyear>1968 & (xsqnr>0 & xsqnr<=20))	///
				| (intyear==1968)							///
				)	
			
			
	*** Keep 3: only respondents !!! TO CORRECT !!!: 
	// keep if (intyear>1968 & isresp==1) 					///
	// 		& (intyear>1968 & (xsqnr>0 & xsqnr<=20))

	

**--------------------------------------
** Age criteria
**--------------------------------------

keep if age>=18 //  



**--------------------------------------
** MV in age and gender
**--------------------------------------

keep if female~=.
keep if age~=.



*############################
*#							#
*#	Save					#
*#							#
*############################
save "${psid_out}\us_03_CPF.dta" , replace
