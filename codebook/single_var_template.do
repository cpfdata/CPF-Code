local varname fedu4

marksample touse, strok novarlist
tempvar uniq				
bysort `varname': gen byte `uniq' = (`touse' & _n==_N)
su `uniq', meanonly
local uniquevals = `r(sum)'
 
su  `varname',  meanonly
local varmin `r(min)'
local varmax `r(max)'
quietly count if `varname'<0 | `varname'==.
local nmv = `r(N)'
su `varname',det

di "Unique values: " "`uniquevals'"
di "Missing values: " "`nmv'"
di "[`varmin'; `varmax']" 
di "Mean: " "`r(mean)'"
di "SD: " "`r(sd)'"

tab `varname', m
tab `varname' country, m


********************************************
* 
*	GENERATE CODEBOOK	 
*
********************************************

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



**------------------------------------------------------------------------------
** Begin 
**------------------------------------------------------------------------------
putdocx clear
putdocx begin, font(calibri, 11)



**------------------------------------------------------------------------------
** Var - cat   
**------------------------------------------------------------------------------

local var medu4   
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
** Var - cont   
**------------------------------------------------------------------------------local var nphh   
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
** Avalibility  
**------------------------------------------------------------------------------

* cpfbookAavlb `var'


********************************************
* 
*	Save docx 
*
********************************************

putdocx save "${your_dir}/codebook/Single_var.docx", replace
