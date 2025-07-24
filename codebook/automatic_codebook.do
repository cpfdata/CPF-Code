*
**|=========================================================================|
**|	    ####	CPF	ver 2.0		####										|
**|		>>>	Automatic codebook						 						|
**|		>>	Exports codebook tables and text to Word docx					|
**|-------------------------------------------------------------------------|
**|		Stata 16		| 	2025											|	
**|		Konrad Turek 	|	k.l.turek@tilburguniversity.edu					|
**|=========================================================================|
* 
/* INFO:
---
Programs for codebook tables are defined in "prog_cpfbook_codebook.do".
Note, it is replacing previous docx files.
---
*/

**------------------------------------------------------------------------------
**	1. FILL-IN: Your local directory	
**------------------------------------------------------------------------------
// Inster the main directory for storing original datasets and all the CPF files 
	

global your_dir "/Users/..."  // <--inster your directory 

* temp:
global disk "C:/Users/klturek/OneDrive - Tilburg University"
global your_dir "${disk}/_KT_work/_CPF/__CPF_2.0draft/11_CPF_in_syntax"  



**------------------------------------------------------------------------------
** Define programs
**------------------------------------------------------------------------------
*** Programs "cpfbook" defined in external do-files
do "${your_dir}/codebook/prog_cpfbook_codebook.do"

*** Program for printing var and val labels 
cap program drop pr1
program define pr1
syntax varlist [, cat]
	local lab: variable label `varlist'
	putdocx paragraph, shading("", lightsteelblue, solid)
	putdocx text ("`varlist'"), bold  font("", 13)
	putdocx paragraph,  font("", "", steelblue) //indent(left, 20pt) 
	putdocx text ("`lab'"), linebreak 
	
		* Option for displaying categories 
		if ("`cat'" != "") {
		qui levelsof `varlist', local(levels)
		local valname: value label `varlist'
		foreach n of local levels {
			   if  `n'>=0    {
			   local lval: label `valname' `n' 
			   putdocx text (  "   (`n'):   `lval'") , linebreak
			   }
			}
		}
end


********************************************
* 
*	GENERATE CODEBOOK	 
*
********************************************


**------------------------------------------------------------------------------
** Begin 
**------------------------------------------------------------------------------
putdocx clear
putdocx begin, font(calibri, 11)


*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Respondent identifiers"), bold font("", 15)
*==============================================================================


**------------------------------------------------------------------------------
local var wave
pr1 `var'
* Category labels
	putdocx text ("<number>") 

putdocx paragraph
* Description
putdocx text ( "Country-specific wave number (counting from 1). It can be used for panel analysis." )
*
cpfbookA `var'
putdocx pagebreak
	
	
**------------------------------------------------------------------------------
local var wavey
pr1 `var'
* Category labels
	putdocx text ("<year>") 
 * Description
putdocx textblock begin
In case of single-year data collection, it equals intyear. In case of multi-year data collection, 
e.g. in UKHLS or PSID, wavey refers to the main (initial) year of data collection and thus can differ from intyear. It can be used for panel analysis. 
putdocx textblock end
*
cpfbookA `var'
putdocx pagebreak



**------------------------------------------------------------------------------
local var intyear 
pr1 `var'
* Category labels
	putdocx text ("<year>") 

putdocx paragraph
* Description
putdocx textblock begin
In case of single-year data collection, it equals wavey. In case of multi-year data collection, e.g. 
in UKHLS or PSID, intyear indicates the year of data collection and thus can differ from wavey. 
It can be used for panel analysis. 
putdocx textblock end
*
cpfbookA `var'
putdocx pagebreak



**------------------------------------------------------------------------------
local var intmonth 
pr1 `var'
* Category labels
	putdocx text ("<Months 1-12>") 

putdocx paragraph
* Description
putdocx text ( 	"Indicates the month of data interview.")
*
cpfbookA `var'
putdocx pagebreak



**------------------------------------------------------------------------------
local var  respstat 
pr1 `var', cat
putdocx paragraph
* Description
putdocx text ( ///
	"Status of respondent in relation to a type of interview. Category '2. Not interviewed (has values)' refers to individuals who are not interviewed but they have information available through a proxy questionnaire. Not available for US (information is missing for some waves). " ///
)
*
cpfbookA `var'
putdocx pagebreak



*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Gender, age"), bold font("", 15)
*==============================================================================

**------------------------------------------------------------------------------
local var female 
pr1 `var'
* Category labels
	putdocx text ("  (0): No (respondent is male)") , linebreak
	putdocx text ("  (1): Yes (respondent is female)") 
putdocx paragraph
* Description
putdocx text ( 	"Gender of the respondent" )
*
cpfbookA `var'
putdocx pagebreak


**------------------------------------------------------------------------------
local var yborn 
pr1 `var'
* Category labels
	putdocx text ("<year>") 

* Description
putdocx textblock begin, paramode
Year of birth. It could have been updated during the panel if at a subsequent wave a more accurate date of birth was obtained. Corresponds to 'age'.

Variable was corrected for US, UK, and RUS:

-	missing values were filled based on age if available

-	to be consistent across waves: if inconsistent values, then the mode year was selected

putdocx textblock end
*
putdocx text ("XXX ADD TABEL MANUALLY XXX"), font ("", "", red)
cpfbookAc `var'
putdocx pagebreak

**------------------------------------------------------------------------------
local var age  
pr1 `var'
* Category labels
	putdocx text ("<number>") 

putdocx paragraph
* Description
putdocx text ( 	"Number of full years at the date of interview. Corresponds to yborn." ), linebreak 
putdocx text ("XXX ADD DESRIPTION MANUALLY XXX"), font ("", "", red)

*
putdocx text ("XXX ADD TABEL MANUALLY XXX"), font ("", "", red)

cpfbookAc `var'
putdocx pagebreak

*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Education level"), bold font("", 15)
*==============================================================================

putdocx paragraph
putdocx text ("XXX ADD DESRIPTION AND TABEL MANUALLY XXX"), font ("", "", red)

**------------------------------------------------------------------------------
foreach V in edu3 edu4 edu5 edu5v2 {
	local var `V' 
	pr1 `var', cat
	 putdocx paragraph
	* Description
	putdocx text ( 	"Numbers in brackets indicate ISCED-11 levels." )
	*
	cpfbookA `var'
		 putdocx paragraph
		 putdocx text (""), linebreak
}

**------------------------------------------------------------------------------
local var eduy
pr1 `var'
* Category labels
	putdocx text ("<number>") 
putdocx paragraph
* Description
putdocx text ( 	"Completed years of education." )
*
cpfbookAc `var'

putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Marital and relationship status"), bold font("", 15)
*==============================================================================

putdocx paragraph
putdocx text ("XXX ADD DESRIPTION AND TABEL MANUALLY XXX"), font ("", "", red)


**------------------------------------------------------------------------------
local var mlstat5  
pr1 `var', cat
putdocx paragraph
* Description
putdocx textblock begin, paramode
Only formal marital status included, no information on having/living with partner. “Never married” includes singles.

For PSID: 

-	US 1968-1976 no distinction between legally married and cohabiting (treated as married – cat "1")

-	this is partly corrected for Heads in years 77+ 

-	Partners of cohabiting Heads remain in "1", because there is no better category for them

putdocx textblock end

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var parstat6   
pr1 `var', cat
putdocx paragraph
* Description
putdocx textblock begin, paramode
Includes information on marital status (<<dd_docx_display italic: "mlstat5">>) 
and whether living with partner (P) in household (<<dd_docx_display italic: "livpart">>).
US 1968-1976 no distinction between legally married and cohabiting – they are treated as married. 

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var marstat5    
pr1 `var', cat
putdocx paragraph
* Description
putdocx textblock begin, paramode
This variable is equivalent to the one used in CNEF (and as such corresponding to a respective variable in CNEF files for datasets which provide them). However, the variable has some limitations: 

-	categories of 'single' and 'living with partner' not fully precise and can be contradictory to other variables 

-	country differences in inclusion of having/living with partner

-	country differences in definition of ‘single’ 

-	Living with a partner has a priority over divorced/widowed/separated

Therefore, it is recommended to use <<dd_docx_display italic: "mlstat5">> 
or <<dd_docx_display italic: "parstat6">> for analyzing CPF data. 

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var livpart     
pr1 `var', cat
putdocx paragraph
* Description
putdocx textblock begin, paramode
Whether living with partner in the household.

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var nvmarr     
pr1 `var', cat
putdocx paragraph
* Description
putdocx textblock begin, paramode
Responded has not been formally married until the interview time.

putdocx textblock end

putdocx text ("XXX ADD DESCRIPTION XXX"), font ("", "", red)

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------

foreach V in widow divor separ {
local var `V'     
pr1 `var', cat
putdocx paragraph
* Description
putdocx text ("Based on mlstat5.")

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak
}

putdocx pagebreak

*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Children and household composition"), bold font("", 15)
*==============================================================================

putdocx textblock begin,  
Due to differences in questionnaires, it is not possible to fully harmonize information of respondent’s children. Therefore, CPF includes several versions of children-related variables:
putdocx textblock end

cpfbookAavlb kidsn_hh17 kidsn_hh15 kidsn_all kids_any kidsn_hh_02 kidsn_hh_34 kidsn_hh_04 kidsn_hh_510 kidsn_hh_511 kids_hh_04 kidsown_04

putdocx textblock begin, paramode
The basic recommended variable is <<dd_docx_display italic: "kidsn_hh17">>, however, it is not available for UK. For UK use <<dd_docx_display italic: "kidsn_hh15">> as a separate variable or – if it suits the research goal – combine both variables. Note that for Russia, <<dd_docx_display italic: "kidsn_hh17">> refers to own children only.

Survey differed in criteria of children to which the questions referred to:

- definition of children, e.g. own-born, adopted, of other family members, any children 

- indication of the situation of children, e.g. living currently in household, living elsewhere, children ever had 

- age of children, e.g. any age, below 18 or 15 years old 

For precise information, please refer to original questions and definitions provided below. 

Additional notes: 

Australia

	- there are small and unexplained differences between CNEF’s d11107 and a variable based on the raw data – raw data were preferred 

	- there are alternative input variables for counting children, e.g. any children or dependent children 

	- Alternative: Number Of Dependent Children aged 0-14 yo (includes partner's children) based on hhd0_4, hhd5_9, hhd1014 

Korea 

	- complex information on own children – they are included in HH questionnaire and refer to the head / respondent 

	- number of HH members below 15/18 y.o. (existence of children in high school or younger) is not useful for counting own children since it covers the whole household (including e.g. respondent or grandchildren)

Russia

	- Note that kidsn_hh17 refers to Number Of Own Children

	- Information available from 2004

UK

	- no threshold for 18 y.o., only children aged 0-15 (plus detailed age ranges), and people 16+ 

	- additionally: Number of own children in the household, which includes natural children, adopted children and step children, under age of 16.

putdocx textblock end


**------------------------------------------------------------------------------
local var kidsn_hh17      
pr1 `var', 
putdocx paragraph
* Description
putdocx textblock begin, paramode
Number of persons in the household under the age of 18 (any children: own-born, adopted, of other family members).

putdocx textblock end
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var kidsn_hh15     
pr1 `var', 
putdocx paragraph
* Description
putdocx textblock begin, paramode
Number of persons in the household aged 15 or under (any children: own-born, adopted, of other family members).

putdocx textblock end
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var kidsn_all    
pr1 `var', 
putdocx paragraph
* Description
putdocx textblock begin, paramode
Number of children that respondent ever had (also not living in HH, older, in some counties also adopted and deceased. 

putdocx textblock end
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var kids_any   
pr1 `var',  cat
putdocx paragraph
* Description
putdocx textblock begin, paramode
Has currently any own children (also children ever born).

putdocx textblock end
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak




**------------------------------------------------------------------------------
local var kidsn_hh_02   
pr1 `var',  
putdocx paragraph
* Description
putdocx textblock begin, paramode
Number of Children in HH aged 0-2.

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var kidsn_hh_34   
pr1 `var',  
putdocx paragraph
* Description
putdocx textblock begin, paramode
Number of Children in HH aged 3-4.

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var kidsn_hh_04   
pr1 `var',  
putdocx paragraph
* Description
putdocx textblock begin, paramode
Number of Children in HH aged 0-4.

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var kidsn_hh_510   
pr1 `var',  
putdocx paragraph
* Description
putdocx textblock begin, paramode
Number of Children in HH aged 5-10.

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var kids_hh_04   
pr1 `var',  cat
putdocx paragraph
* Description
putdocx textblock begin, paramode
Any children in HH aged 0-4?

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var kidsown_04   
pr1 `var',  cat
putdocx paragraph
* Description
putdocx textblock begin, paramode
Any own children aged 0-4?

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

       


**------------------------------------------------------------------------------
local var nphh   
pr1 `var', 
putdocx paragraph
* Description
putdocx textblock begin, paramode
Total number of people living in the household at the time of the interveiw.

putdocx textblock end
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak



**------------------------------------------------------------------------------
local var oldern_hh70    
pr1 `var', 
putdocx paragraph
* Description

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak



**------------------------------------------------------------------------------
local var oldern_hh70    
pr1 `var', 
putdocx paragraph
* Description

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak



putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Labour market situation"), bold font("", 15)
*==============================================================================

putdocx textblock begin, paramode
The goal of CPF is to offer a comprehensive view on the labor market situation of individuals. 
The main variable is employment status, which is presented in two versions. 
The 5-categorical variable (<<dd_docx_display italic: "emplst5">>) is harmonized for all countries. The 6-categorical variable (<<dd_docx_display italic: "emplst6">>) includes additionally a category “on leave”, but it is not available for Australia and partly for US (before 1976). 

<<dd_docx_display italic: "Empls*">> include following categories:

•	Employed – currently employed 

•	Unemployed (active) – not working and actively looking for work 

•	Retired, disabled – not working and left the labour market (retired or disabled) 

•	Not active/home – not active economically (not working, not searching for work), additionally not retired and not in education

•	In education – currently in formal education 

•	On leave (employed) – employed but temporarily on paid leave 

Employment status is based on multiple input variables. Prioritization of statuses is applied, so that, for example, being employed is prioritized over being in education. The priority is following:

1.	Employed

2.	Unemployed

3.	In education

4.	Retired, disabled

5.	Not active/home

<<dd_docx_display italic: "Emplst*">> do not always correspond to other binary indicators related to labor market situation, e.g. current working status or retirement status. For a more precise classification of unemployed and retired, see respective binary variables.

Two binary indicators of working status (<<dd_docx_display italic: "work_d, work_py">>) refer to the approach used in CNEF and are constructed in a different way than the employment status. 

Classification can differ from other specific variables (e.g. unemployed <<dd_docx_display italic: "un_act">>, retired <<dd_docx_display italic: "retf">>), due to prioritization of statuses and differences in classification rules. For example, in emplst5 retirement is classified primarily based on self-categorization, whereas in <<dd_docx_display italic: "retf">> it includes a more complex and precise set of criteria; additionally, in emplst5 the status can be updated by statuses with a higher priority (e.g. in education or unemployed). 

putdocx textblock end

cpfbookAavlb emplst5 emplst6 work_d work_py mater neverw


**------------------------------------------------------------------------------
local var emplst5    
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Primary employment status.

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var emplst6 
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Primary employment status. 
This version includes an additional category of “on leave”, but it is not available for Australia. 

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var work_d 
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Current working status (<<dd_docx_display italic: "work_d">>) 
is based individual’s self-reported primary activity 
at the time of the interview. It does not always correspond to the employment status. 
In some questionnaires, next to a series of detailed questions about the employment 
situation, respondent were asked a simple separate question, such as 
“Are you currently working”. This variable is equivalent to the CNEF’s variable E11104. 
It may not be the same as employment in <<dd_docx_display italic: "emplst5">>, or other work-related variables.

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var work_py
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Working status in the previous year based on reported working hours in the previous year. 
Individual with positive wages in the previous year who worked at least 52 hours were 
classified as working (1). The rest receive 0. It is equivalent to the CNEF’s variable E11102. 

This variable is available only for datasets which provided separate CNEF files. 
For other countries, users can adopt the same approach and create the variable based on 
estimation of yearly hours (however, this may be misguiding, therefore CPF does not provide this variable). 

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var mater  
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Respondent reports being on maternity leave.

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var neverw  
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Individual who report to have never been employed or working for money. 

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var un_act   
pr1 `var', cat
* Description
putdocx textblock begin, paramode
It combines information on:

	-	being currently not employed

	-	looking for a new work

	-	actively looking for a new work in the previous 4 weeks (note, there are some differences between countries in these criteria, e.g. in SOEP it is 3 months for waves 1994-1998 and 4 weeks for 1999+)

For Germany information on active unemployment available only from 1994. Before 1994 1 refers to unemployed in general (not necessarily active)

putdocx textblock end

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Self-employment and entrepreneurship"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode
Self-employment and entrepreneurship refers to the main job.

Alternative specification of self-employment is possible (see lower-level syntax): self-employed v1 (all without Family Business) - only SOEP; self-employed v3 (based on income from self-empl) - e.g. in SHP and SOEP. 

For HILDA, classification of self-employed is based on definition by the Australian Bureau of Statistics (ABS), which includes 

	•	"Employee of own business" - people who work for their business which is incorporated 

	•	"Employer/ Self-employed /own account worker" refers to people who work in their own business which is not incorporated
	
Entrepreneurship combines information about self-employment with size of company (only for the main job). Entrep2 is fully harmonized and recommended. 

In most of the case, as entrepreneurs we consider people selfemployed (selfempl=1) who employ at least 1 person other than respondent (no of own employees>1 or size of company>1). 

Additional notes:

putdocx textblock end

putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION ENTREP Additional notes: XXX"), font ("", "", red)

cpfbookAavlb selfemp entrep entrep2

**------------------------------------------------------------------------------
local var selfemp    
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Self-employed including those working in Family Businesses
putdocx textblock end

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var entrep    
pr1 `var', cat
* Description
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var entrep2    
pr1 `var', cat
* Description
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var retf    
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Individuals are classified as retired when no working and meet any of the following criteria:

	o	Self-categorisation as retired & age 50+  

	o	Receives old-age pension & age 50+

	o	Age 65+  

There are various ways to define the retirement status. In CPF, we offer a combination of several approaches based on the available data. The input variables include working status, self-identification as retired, receiving retirement pension or other type of old-age benefit, and age. Depending on the institutional context, a definition of retirement can be related more to formal status, benefits, or working status. 

There are some differences between <<dd_docx_display italic: "retf">> and <<dd_docx_display italic: "emplst*">> due to different criteria and priorities in recoding. E.g. for <<dd_docx_display italic: "retf">>, we do not consider educational activity or active unemployment; <<dd_docx_display italic: "emplst*">> combines retired and disabled into 1 category. 


putdocx textblock end

putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION ENTREP Additional notes: XXX"), font ("", "", red)

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var oldpens     
pr1 `var', cat
* Description
putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION ENTREP Additional notes: XXX"), font ("", "", red)

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Employment: level"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode
Due to differences in questionnaires, there are several possible variables indicating employment level and number of working hours. CPF provides all of them so that users can choose and transform them for their purposes. Besides, however, CPF provides harmonized and unified generated variables ready to use: <<dd_docx_display italic: "fptime_h, wheek and whmonth">> .
putdocx textblock end

cpfbookAavlb fptime_h fptime_r whyear whweek whmonth whweek_ctr

putdocx textblock begin, paramode
<<dd_docx_display italic: "Whweek">> and <<dd_docx_display italic: "whmonth">> are available or estimated for all countries. 

<<dd_docx_display italic: "Whyear">> is for 5 countries (KOR & RUS missing). Values for the missing two countries can be calculated based on per week/month data. However, CPF does not include it by default because this estimate might be misguiding – it does not reflect the actual working hours per year for respondent who have worked less than 12 full months. 

Additionally, the contracted number of hours is provided if available (<<dd_docx_display italic: "whweek_ctr">>).

putdocx textblock end


**------------------------------------------------------------------------------
local var fptime_h  
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Full time indicates individuals who worked at least 35 hours per week on average (1,820 hours per year). Those working below 35 per week were assigned as part-time workers. Individuals not employed were included in category 3.
It is based on hours worked per week (not contracted).

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var fptime_r  
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Individual who report to have never been employed or working for money. 

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var whyear   
pr1 `var', 
* Description
putdocx textblock begin, paramode
Only for US, the values represent the original question. Additionally, the variable corresponds to CNEF e11101 – if it was available, we included it in CPF. For other countries, it can be estimated based on hours per week. (e.g. whweek*52) or month, however, we do not recommend it if it should reflect the actual working hours per year (in this case, number of months in which respondent was employed should be taken into account). 

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak



**------------------------------------------------------------------------------
local var whweek    
pr1 `var', 
* Description
 putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var whmonth     
pr1 `var', 
* Description
putdocx paragraph
putdocx text ("XXX ADD DESCRIPTION MANUALLY XXX"), font ("", "", red)
*
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var whweek_ctr      
pr1 `var', 
* Description
*
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak


putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Employment: Occupation (ISCO) and position"), bold font("", 15)
*==============================================================================

putdocx paragraph
putdocx text ("XXX ADD DESRIPTION AND TABEL MANUALLY XXX"), font ("", "", red)

**------------------------------------------------------------------------------
local var isco_1     
pr1 `var', cat
* Description
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak
**------------------------------------------------------------------------------
local var isco_2     
pr1 `var', 
* Description
	putdocx text ("<see table for categories>") , linebreak

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak
**------------------------------------------------------------------------------
foreach V in isco08_4 isco88_4 {
local var `V'       
pr1 `var', 
* Description
	putdocx text ("<500+ categories>") , linebreak
*
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak
}
**------------------------------------------------------------------------------
local var isco88_3     
pr1 `var', 
* Description
	putdocx text ("<100+ categories>") , linebreak
*
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var supervis     
pr1 `var', cat
* Description
	putdocx text ("Respondent has supervisory/menagerial responsibilities at the job.") , linebreak
	putdocx text ("XXX ADD DESRIPTION AND TABEL MANUALLY XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Employment: Industry and sector of organization"), bold font("", 15)
*==============================================================================

putdocx paragraph
putdocx text ("XXX ADD DESRIPTION AND TABEL MANUALLY XXX"), font ("", "", red)


**------------------------------------------------------------------------------
foreach V in indust1 indust2 indust3 {
local var `V'     
pr1 `var', cat
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak
}
**------------------------------------------------------------------------------
local var public      
pr1 `var', cat
* Description
putdocx textblock begin
Respondent works for public sector employer / government. Note that for some countries, it was not possible to separate governmental organizations and other public sector organizations. Thus we advise adjustments in the variable depending on the research goal.
putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Employment: size of organization"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode
Because of differences in questionnaires, the size of respondent’s organization could not be fully harmonized. CPF offers then several alternative classifications which were available for at least a few countries. <<dd_docx_display italic: "Size5b">> is available for all countries except Germany (for which only <<dd_docx_display italic: "size4">> is available). 

For full harmonization, users may consider constructing categories of small, medium and large companies based on <<dd_docx_display italic: "size5b">> and roughly adjusting Germany based on <<dd_docx_display italic: "size4">> (e.g. by combining e.g. <10 with <20 as small). 
A raw number of employees (<<dd_docx_display italic: "size">>) is provided if available.

Additionally, surveys refer to either local workplace/location or the whole company (including branches). This may have important consequences for interpretation – in this case, separate “whole” and “local” approaches based on information provided below. 

putdocx textblock end

cpfbookAavlb size size4 size5 size5b


putdocx paragraph
putdocx text ("XXX ADD DESRIPTION AND TABEL MANUALLY XXX"), font ("", "", red)

**------------------------------------------------------------------------------
local var size      
pr1 `var', 
* Description
	putdocx text ("<100+ categories>") , linebreak
*
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
foreach V in size4 size5 size5b {
local var `V'     
pr1 `var', cat
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak
}

putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Individual income"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode
Depending on the original data, information on individual income is included in several variables based on:

-	source of income: 
	
	o	total income from jobs and benefits (<<dd_docx_display italic: "inctot*">>)
	
	o	from all jobs (<<dd_docx_display italic: "incjobs*">>)
	
	o	from main job (<<dd_docx_display italic: "incjob1*">>)

-	type of income: 
	
	o	gross (<<dd_docx_display italic: "*g*">>, e.g. <<dd_docx_display italic: "incjobs_yg">>)
	
	o	net (<<dd_docx_display italic: "*n*">>, e.g. <<dd_docx_display italic: "incjobs_yn">>)
	
-	reference period for <<dd_docx_display italic: "">>income 

	o	year (<<dd_docx_display italic: "*y*">>, e.g. <<dd_docx_display italic: "incjob1_yn">>)
	
	o	month (<<dd_docx_display italic: "*m*">>, e.g. <<dd_docx_display italic: "incjob1_mn">>)
	
	o	per hour (<<dd_docx_display italic: "*h*">>, e.g. <<dd_docx_display italic: "incjob1_hn">>)

This approach results in multiple variables but provides clear definitions. For analytical purposes, users can combine particular variables using the nominal values or relative values (e.g. percentiles). <<dd_docx_display italic: "Incjobs_yg">> is available for all countries except Russia. 

For some countries, the income variables are taken from the CNEF files: Australia, Switzerland and Germany.
CPF provides values as they are included in the source data, without any additional cleaning, imputation, conversion or inflation-adjustments. Values are in local currency. For details, please refer to survey documentation

putdocx textblock end



cpfbookAavlb inctot_yn inctot_mn incjobs_pyg incjobs_pyn incjobs_cyg incjobs_mn ///
       incjobs_mg incjob1_pyg incjob1_cyn incjob1_cyg incjob1_mg incjob1_mn incjob1_hg 

**------------------------------------------------------------------------------
foreach V in inctot_yn inctot_mn incjobs_pyg incjobs_pyn incjobs_cyg incjobs_mn incjobs_mg incjob1_pyg incjob1_cyn incjob1_cyg incjob1_mg incjob1_mn incjob1_hg {
local var `V'     
pr1 `var',  
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak
}
putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Household income"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode

Depending on the type of monthly household income in the original data, information is provided in two versions: 
	
	o	Gross - all the income earned prior to any withholding for taxes or other deductions (<<dd_docx_display italic: "hhinc_pre*">>)
	
	o	Net - net adjusted disposable income after taxes and transfers (<<dd_docx_display italic: "hhinc_post*">>)

For some countries, the income variables are taken from the CNEF files: Australia, Switzerland and Germany.
Please take into account differences in coding of the missing values between countries. Some datasets (PSID since 1994, HILDA, UK) provide a negative household income indicating a loss or debit, but they also code MV with negative. In other datasets, values below zero indicate MV. 

All values are in local currencies. 

putdocx textblock end


cpfbookAavlb hhinc_pypre hhinc_pypost hhinc_pypost_eq

**------------------------------------------------------------------------------
foreach V in hhinc_pypre hhinc_pypost hhinc_pypost_eq {
local var `V'     
pr1 `var',  
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak
}
putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Labor market experience"), bold font("", 15)
*==============================================================================

putdocx textblock begin, paramode
Labor market experience measured as years of employment/work. 

It is not available for KLIPS and UKHLS. Other surveys have different approaches to this question, asking either about the total experience at work, organization or in occupation. Additionally, SOEP asks about full-time and part-time experience separately. CPF provides therefore several variables. <<dd_docx_display italic: "Exp">> is recommended , however for SOEP the value was estimated based on <<dd_docx_display italic: "expft">> and <<dd_docx_display italic: "exppt">> (exploration and cleaning is recommended). 

putdocx textblock end

cpfbookAavlb exp exporg expft exppt

putdocx paragraph
putdocx text ("XXX ADD DESRIPTION AND TABEL MANUALLY XXX"), font ("", "", red)

**------------------------------------------------------------------------------
local var exp    
pr1 `var',  
	putdocx text ("<years>") 
putdocx paragraph,
	putdocx text ("Total Labour market experience (full+part time)") , linebreak
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var exporg     
pr1 `var',  
	putdocx text ("<years>") 
putdocx paragraph,
	putdocx text ("Tenure with current employer (years)") , linebreak
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var expft      
pr1 `var',  
	putdocx text ("<years>") 
putdocx paragraph,
	putdocx text ("Only for Germany and US") , linebreak
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var exppt      
pr1 `var',  
	putdocx text ("<years>") 
putdocx paragraph,
	putdocx text ("Only for Germany") , linebreak
cpfbookAc `var'
putdocx paragraph
putdocx text (""), linebreak

putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Health"), bold font("", 15)
*==============================================================================

**------------------------------------------------------------------------------
local var srh5       
pr1 `var', cat
* Description
putdocx textblock begin, paramode
It indicates person’s self-rated health status.
All surveys use 5-point reversed scales (with different labels, e.g. a label “fair” can be 3 or 4; see dessription below). 

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var disabpens        
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Receives any type of disability pension. 

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var disab       
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Persons has any type disability (physical, mental or nervous condition) that affects her/him everyday activities or work.

putdocx textblock end

*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


**------------------------------------------------------------------------------
local var disab2c         
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Persons has a more sever type of disability (physical, mental or nervous condition) that restricts her/him in everyday activities or at work. As a more sever we consider an equivalent of category 2 disability or >30% limitation of functioning. 

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var chron          
pr1 `var', cat
* Description
putdocx textblock begin, paramode
The version of <<dd_docx_display italic: "chron">> currently available in CPF is not ready to use. This is a working variable and is not fully harmonized. Most of all, it requires conceptual framework and users have to define chronic conditions they want to include. Some surveys offer an extensive list of chronic conditions, while other are limited a simple yes-no question. Nevertheless, we provided a partial syntax which can be helpful. 

Note:

	-	the list of conditions included in surveys have been often changing with waves

	-	in some surveys the question was asked only in selected waves 


putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Satisfaction"), bold font("", 15)
*==============================================================================

putdocx paragraph
putdocx text ("XXX ADD General description XXX"), font ("", "", red)

cpfbookAavlb satfinhh5	///
satfinhh10	///
satinc5		///
satinc10	///
satwork5	///
satwork10	///
sathlth5	///
sathlth10	///
satlife5	///
satlife10	///	
satfam5		///
satfam10

**------------------------------------------------------------------------------
pr1 sathlth5 
pr1 sathlth10    
* Description
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookAc sathlth5
putdocx paragraph
putdocx text (""), linebreak
cpfbookAc sathlth10
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
pr1 satlife5  
pr1 satlife10     
* Description
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookAc satlife5 
putdocx paragraph
putdocx text (""), linebreak
cpfbookAc satlife10
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
pr1 satfinhh5   
pr1 satfinhh10      
* Description
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookAc satfinhh5  
putdocx paragraph
putdocx text (""), linebreak
cpfbookAc satfinhh10 
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
pr1 satinc5    
pr1 satinc10       
* Description
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookAc satinc5   
putdocx paragraph
putdocx text (""), linebreak
cpfbookAc satinc10  
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
pr1 satwork5     
pr1 satwork10        
* Description
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookAc satwork5    
putdocx paragraph
putdocx text (""), linebreak
cpfbookAc satwork10   
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
pr1 satfam5      
pr1 satfam10         
* Description
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookAc satfam5     
putdocx paragraph
putdocx text (""), linebreak
cpfbookAc satfam10    
putdocx paragraph
putdocx text (""), linebreak


putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Training and qualifications "), bold font("", 15)
*==============================================================================

cpfbookAavlb train eduwork wqualif


**------------------------------------------------------------------------------
local var train        
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Taken part in work-related training in the past 12 months. It does not include formal education at school. 

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var eduwork         
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Self-assesment of the match between respondent's formal education and current job. 
It refers primarily to the level of formal education (not skills). 

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

**------------------------------------------------------------------------------
local var wqualif          
pr1 `var', cat
* Description
putdocx textblock begin, paramode
How does the respondent estimate her/his qualifications with regard to the current job.
It refers to skills (not formal education level)

putdocx textblock end
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak


putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Job security"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode
We recommend to adjust the design according to the research goal, and compare definition and distributions between countries.

putdocx textblock end

cpfbookAavlb jsecu jsecu2
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)


**------------------------------------------------------------------------------
local var jsecu          
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Respondent is worried about job security (stability of employment / keeping job). Only for employed. 

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak
**------------------------------------------------------------------------------
local var jsecu2          
pr1 `var', cat
* Description
putdocx textblock begin, paramode
Respondent is worried about job security (stability of employment / keeping job). Only for employed. 

<<dd_docx_display italic: "Jsecu2">> has an additional category “Hard to say”, which – if available in the original question – was included in “secure” in <<dd_docx_display italic: "jsecu">>. 

putdocx textblock end
*
cpfbookA `var'
putdocx paragraph
putdocx text (""), linebreak

putdocx pagebreak
*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Socio-economic position scales"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode
CPF contains a range of socio-economic position scales or indexes based on respondents’ work status and occupation. Some surveys provided them in their datasets, for the rest they were calculated. 

If not available in original dataset, variables werecreated according to Ganzeboom (2010) algorithms with the help of iscogen STATA ado (Jann, 2019). See Ganzeboom (2010):  

http://www.harryganzeboom.nl/isco08/isco08_with_isei.pdf

The procedure should be based on ISCO level 4. However, if not available, the scale was based on ISCO level 2 codes converted to level 4 (multiplied by 100). In such cases, it is less precise. For comparative purposes, further categorization can be considered to obtain similar distributions across countries. 


putdocx textblock end

cpfbookAavlb   isei08	///
isei88		///
isei88soep	///
siops08		///
siops88		///
siops88soep	///
mps88		///
mps92soep


**------------------------------------------------------------------------------
pr1 isei08
	putdocx text ("<number>") , linebreak
pr1 isei88
	putdocx text ("<number>") , linebreak
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
foreach V in isei08 isei88 isei88soep {
cpfbookAc `V'
}
 
**------------------------------------------------------------------------------
pr1 siops08
	putdocx text ("<number>") , linebreak
pr1 siops88
	putdocx text ("<number>") , linebreak
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
foreach V in siops08 siops88 siops88soep {
cpfbookAc `V'
}

**------------------------------------------------------------------------------
pr1 mps88
	putdocx text ("<number>") , linebreak
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)
*
foreach V in mps88 mps92soep {
cpfbookAc `V'
}


*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Parents education"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode
Information on parents’ education is coded in 3- and 4-categorical variables similarly to edu3 and edu4. For many surveys, the information is less precise than in the case of respondent’s education (mostly not categorized into ISCED). 

MV filled based on other waves. 

putdocx textblock end

cpfbookAavlb fedu3 fedu4 medu3 medu4

putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)

foreach V in fedu3 fedu4 medu3 medu4 {
	local var `V' 
	pr1 `var', cat
	putdocx paragraph
	cpfbookA `var'
	putdocx paragraph
	putdocx text (""), linebreak
}

putdocx pagebreak

*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Ethnicity, migration, and country of birth"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode
xxx

putdocx textblock end

cpfbookAavlb ethn ethn_hisp migr cob grewup_US migr_f migr_m cob_f cob_m migr_gen

putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)

foreach V in ethn ethn_hisp migr cob grewup_US migr_f migr_m cob_f cob_m migr_gen {
	local var `V' 
	pr1 `var', cat
	putdocx paragraph
	cpfbookA `var'
	putdocx paragraph
	putdocx text (""), linebreak
}

putdocx pagebreak


*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Religion"), bold font("", 15)
*==============================================================================
putdocx textblock begin, paramode
xxx

putdocx textblock end

cpfbookAavlb relig relig_att relig_KOR

putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)

foreach V in relig relig_att relig_KOR {
	local var `V' 
	pr1 `var', cat
	putdocx paragraph
	cpfbookA `var'
	putdocx paragraph
	putdocx text (""), linebreak
}

putdocx pagebreak

*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Weights"), bold font("", 15)
*==============================================================================

putdocx textblock begin, paramode
This version of CPF does not provide weights. Weights can be added from the original surveys, however, in most cases, there are several weights available and their design differs between surveys. Users who wish to apply weights have to carefully read survey documentation, consider included samples (populations) and decide on the approach for harmonization. 

putdocx textblock end


*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Sample identifiers"), bold font("", 15)
*==============================================================================
putdocx paragraph
putdocx text ("XXX ADD DESRIPTION XXX"), font ("", "", red)


*==============================================================================
* NEXT PART
putdocx paragraph, style(Heading1)
putdocx text ("Variable matrix by country"), bold font("", 15)
*==============================================================================
putdocx pagebreak
* Retrieve all variable names except "country"
ds
	local allvars `r(varlist)'
	local country   country 
	local country2  country2
	local allvars2: list allvars- `country'
	local allvars3: list allvars2- `country2'
	//di "`allvars3'"
	
* Get the big table for all countries by country 	
cpfbookAavlb `allvars3'




********************************************
* 
*	Save docx 
*
********************************************

putdocx save "${your_dir}/codebook/Auto_cbook.docx", replace


