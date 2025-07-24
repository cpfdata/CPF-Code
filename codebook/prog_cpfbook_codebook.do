*
**|=========================================================================|
**|	    ####	CPF	ver 2.0		####										|
**|		>>>	cpfbook(c/a)									 				|
**|		>>	formats and exports codebook table to Word docx					|
**|-------------------------------------------------------------------------|
**|		Stata 16		| 	2025											|	
**|		Konrad Turek 	|	k.l.turek@tilburguniversity.edu					|
**|=========================================================================|
* 
/* INFO:
---
There are separate codes for:
- categorical variables (cpfbookA) 
- continous variables (cpfbookAc) 
- availibility by country (cpfbookAavlb)

Note, it is replacing previous docx files.
---
>> Acknowledgements <<
Code for the codebook output is partly based on a code "ajicbook" created by 
Troy Payne (Associate Director, Alaska Justice Information Center (AJiC); 
tpayne9@alaska.edu, August 8, 2018) and published at:
https://www.statalist.org/forums/forum/general-stata-discussion/general/1453894-icpsr-style-codebook-creation-in-a-word-doc 

*/


**------------------------------------------------------------------------------
**	cpfbook
**------------------------------------------------------------------------------
 

version 18
cap program drop cpfbookA
program define cpfbookA
syntax varlist   

	
	foreach varname of varlist `varlist' {
			local vartype: type `varname'
		
		// numeric vars
			if "`vartype'" == "byte" | "`vartype'" ==  "int" | "`vartype'" ==  "long" | "`vartype'" == "float" | "`vartype'" == "float" | "`vartype'" == "double" {
				
			// get number of unique values
				marksample touse, strok novarlist
				tempvar uniq
				quietly bysort `varname': gen byte `uniq' = (`touse' & _n==_N)
				quietly su `uniq', meanonly
				local uniquevals = `r(sum)'
				quietly su `varname', meanonly
				local numissing =  _N - `r(N)'
				local varmin `r(min)'
				local varmax `r(max)'
			
			// get nuber of MV (. and <0)
				quietly count if `varname'<0 | `varname'==.
				local nmv = `r(N)'
				
			// when number of uniques 25 or less, show all values.
					quietly tabulate `varname' , matcell(freqs) matrow(values) missing
			
				// get number of frequencies
					local nfreqs: rowsof freqs
					
					
				// get variable label 
					local varlab: variable label `varname'
				
			
				// get number of values
					local nvalues: rowsof values
	
				// get value label name
					local vallab: value label `varname'
			// get number of rows needed  for output table
					local ntablerows = `nfreqs'+3	// KT HERE: change rows

			

			// get total freqs
					mata : st_matrix("sumfreqs", colsum(st_matrix("freqs")))


				// table creation and headers 
						quietly su `varname',det

						putdocx table a = (`ntablerows',6), border(all, nil) layout(autofitwindow) 
												
						putdocx table a(1,1) = ("	Name: "),  bold font(consolas, 9)
						putdocx table a(1,1) = ("`varname'"), append linebreak font(consolas, 9)
						putdocx table a(1,1) = ("	Label: "), append bold font(consolas, 9)
						putdocx table a(1,1) = ("`varlab'"), append linebreak font(consolas, 9)
// 						putdocx table a(1,1) = ("Type: `vartype'"), append linebreak
						putdocx table a(1,1) = ("	Unique values: "), append bold font(consolas, 9)
						putdocx table a(1,1) = ("`uniquevals'"), append linebreak font(consolas, 9)
						putdocx table a(1,1) = ("	Missing values: "), append bold font(consolas, 9)  
						putdocx table a(1,1) = ("`nmv'"), append linebreak font(consolas, 9) nformat(%-15.0fc)
						putdocx table a(1,1) = ("	Range: "), append bold font(consolas, 9)
						putdocx table a(1,1) = ("[`varmin'; `varmax']"), append linebreak font(consolas, 9)  
						
						putdocx table a(1,1) = ("	Mean: ") , append bold  font(consolas, 9)
						putdocx table a(1,1) = ("`r(mean)'"), append nformat(%-15.2fc) linebreak  font(consolas, 9)
						putdocx table a(1,1) = ("	SD: "), append  bold  font(consolas, 9)
						putdocx table a(1,1) = ("`r(sd)'"), append  linebreak  nformat(%-15.2fc) font(consolas, 9)
						
						
						putdocx table a(1,1), colspan(6)  
						
 							putdocx table a(2,2) = ("Value"), border(bottom, single) border(top, single) bold font(consolas, 9) halign(right)
							putdocx table a(2,3) = ("Label"), border(bottom, single) border(top, single) bold font(consolas, 9)
							putdocx table a(2,4) = ("Freq."), border(bottom, single) border(top, single) halign(right) bold font(consolas, 9)
							putdocx table a(2,5) = ("Percent"), border(bottom, single) border(top, single) halign(right) bold font(consolas, 9)
 

					// table rows
						forval i = 1/`nfreqs' {
							// add allowance for header rows
								local row = `i'+2
								

							// put value	
								putdocx table a(`row',2) = (values[`i',1]), border(bottom, single, lightgray) border(left,nil) font(consolas, 8) halign(right)
							
							
							
								// put value label
								local value = values[`i',1]
								if "`vallab'" != "" local rowvallab: label `vallab' `value', strict
								putdocx table a(`row',3) = ("`rowvallab'"), border(bottom, single, lightgray) font(consolas, 8)
								
								// put value frequency
									putdocx table a(`row',4) = (freqs[`i',1]), border(bottom, single, lightgray) halign(right) font(consolas, 8) nformat(%10.0gc)
								// put value percent
									putdocx table a(`row',5) = (freqs[`i',1]/sumfreqs[1,1]*100), border(bottom, single, lightgray)nformat(%9.1f) halign(right) font(consolas, 8)
								

							}
					
					// totals 
						
							local row = `row'+1
							putdocx table a(`row',3) = ("Total:") , font(consolas, 8)
							putdocx table a(`row',4) = (sumfreqs[1,1]), halign(right) font(consolas, 8) nformat(%12.0gc)
							putdocx table a(`row',2) , border(top, single) border(bottom, single)
							putdocx table a(`row',3) , border(top, single) border(bottom, single)
							putdocx table a(`row',4) , border(top, single) border(bottom, single)
							putdocx table a(`row',5) , border(top, single) border(bottom, single)
						
					
// 2-way table by country
qui tabulate `varlist' country2, matcell(matcell) matrow(matrow) missing
	matrix mb = (matrow, matcell)
	matrix colnames mb = "category" "[1] AUS" "[2] KOR"    "[3] USA"   "[5] SWT"  "[6] GER"     "[7] UK"  "[8] NL"

// 	mata : st_matrix("coltot", colsum(st_matrix("matcell"))) // totals
	
	
	matrix coltotal = J(1, rowsof(matcell), 1) * matcell
 
 
putdocx table b = matrix(mb), colnames border(all, nil) layout( autofitwindow)  border(insideH, single, lightgray)
	putdocx table b(.,.), font(consolas, 8) nformat(%12.0gc) halign(right)
	putdocx table b(1,.) , border(top, single) border(bottom, single) font(consolas, 9) bold
	

	// Add category names 
		qui levelsof `varlist' , local(levels1) missing	//local levels1 = r(levels)
		local vallab1 : value label `varlist'
		local currentrow=2
		foreach val1 in `levels1' {
			if "`vallab1'"!="" {
				local value1 : label `vallab1' `val1'			
			}
			else {
				local value1 `val1'
			}
					
			putdocx table b(`currentrow',1) = (`"`val1'"'), halign(right)  font(consolas, 8)   // change val1 to value1 if you want labels 
			local currentrow=`currentrow'+1
		}
		
		local currentrow= rowsof(mb)+1
		local totals= rowsof(mb)+2

		putdocx table b(`currentrow',.), addrows(1, after)
		
		foreach cnt of numlist 1/7 {
			local n=`cnt'+1
			putdocx table b(`totals',`n') = (coltotal[1,`cnt']) , halign(right)  font(consolas, 8) nformat(%12.0gc) trim
			}
		putdocx table b(`totals',.) ,   border(bottom, single) border(top, single)
		putdocx table b(`totals',1) = ("Total"), halign(right)  font(consolas, 8) bold 
		putdocx table b(1,1) = (" "),   font(consolas, 8)  

		
					}
	
			
			}
		
		
end




**------------------------------------------------------------------------------
**	cpfbookc - for continous 
**------------------------------------------------------------------------------
 

version 18
cap program drop cpfbookAc
program define cpfbookAc
syntax varlist   


	foreach varname of varlist `varlist' {
		// get variable type
			local vartype: type `varname'
		
		// numeric vars
			if "`vartype'" == "byte" | "`vartype'" ==  "int" | "`vartype'" ==  "long" | "`vartype'" == "float" | "`vartype'" == "float" | "`vartype'" == "double" {
				
			// get number of unique values
				marksample touse, strok novarlist
				tempvar uniq
				quietly bysort `varname': gen byte `uniq' = (`touse' & _n==_N)
				quietly su `uniq', meanonly
				local uniquevals = `r(sum)'
				quietly su `varname', meanonly
				local numissing =  _N - `r(N)'
				local varmin `r(min)'
				local varmax `r(max)'
			
			// get nuber of MV (. and <0)
				quietly count if `varname'<0 | `varname'==.
				local nmv = `r(N)'
				
				// get number of frequencies
// 					local nfreqs: rowsof freqs
						
				// get variable label 
					local varlab: variable label `varname'		
			
				// get number of values
// 					local nvalues: rowsof values
	
				// get value label name
					local vallab: value label `varname'
			// get number of rows needed  for output table
					local ntablerows = `nfreqs'+3	// KT HERE: change rows

				// table creation and headers 
						quietly su `varname',det

						putdocx table a = (1,1), border(all, nil) layout(autofitwindow) 
												
						putdocx table a(1,1) = ("	Name: "),  bold font(consolas, 9)
						putdocx table a(1,1) = ("`varname'"), append linebreak font(consolas, 9)
						putdocx table a(1,1) = ("	Label: "), append bold font(consolas, 9)
						putdocx table a(1,1) = ("`varlab'"), append linebreak font(consolas, 9)
// 						putdocx table a(1,1) = ("Type: `vartype'"), append linebreak
						putdocx table a(1,1) = ("	Unique values: "), append bold font(consolas, 9)
						putdocx table a(1,1) = ("`uniquevals'"), append linebreak font(consolas, 9)
						putdocx table a(1,1) = ("	Missing values: "), append bold font(consolas, 9)  
						putdocx table a(1,1) = ("`nmv'"), append linebreak font(consolas, 9) nformat(%-15.0fc)
						putdocx table a(1,1) = ("	Range: "), append bold font(consolas, 9)
						putdocx table a(1,1) = ("[`varmin'; `varmax']"), append linebreak font(consolas, 9)
						
						putdocx table a(1,1) = ("	Mean: ") , append bold  font(consolas, 9)
						putdocx table a(1,1) = ("`r(mean)'"), append nformat(%-15.2fc) linebreak  font(consolas, 9)
						putdocx table a(1,1) = ("	SD: "), append  bold  font(consolas, 9)
						putdocx table a(1,1) = ("`r(sd)'"), append    nformat(%-15.2fc) font(consolas, 9)
						
		
// sum by country
qui tabstat `varlist' , s(min max mean p50 p25 p75 sd) by(country2)  save

matrix    mb =  r(Stat1)' \  r(Stat2)' \  r(Stat3)' \  r(Stat4)' \  r(Stat5)' \  r(Stat6)' \  r(Stat7)' \ r(StatTotal)'
matrix rownames mb = "[1] AUS" "[2] KOR"    "[3] USA"   "[5] SWT"  "[6] GER"  "[7] UK"  "[8] NL" "Total"
 


putdocx table b = matrix(mb), rownames colnames border(all, nil) layout(autofitwindow) // border(insideH, single, lightgray)
	putdocx table b(.,.), font(consolas, 8) nformat(%10.1fc) halign(right)
	putdocx table b(1,.) , border(top, single) border(bottom, single)    
	putdocx table b(9,.) , border(top, single) border(bottom, single)  
 

		

					}

			
			}
		
	
end



**------------------------------------------------------------------------------
**	cpfbooka	- availibility by country 
**------------------------------------------------------------------------------
 

version 18
cap program drop cpfbookAavlb
program define cpfbookAavlb  
syntax [varlist]  

preserve
 	 collapse  (max) `varlist', by(country2) 
		 // 1 for availible, . for missing 
		 qui recode _all  (0/max=1) (min/-1 .=.)
			 foreach n of num 1/7 {
			 qui replace country2=`n' if _n==`n'
			 }
	 // create matrix 
	 mkmat `varlist', matrix(temp) rownames(country2)
	 matrix mb=temp'
	 matrix colnames mb = "[1] AUS" "[2] KOR"  "[3] USA"   "[5] SWT"  "[6] GER"  "[7] UK"  "[8] NL"
	 mat list mb
	local rows = rowsof(mb)+1 
	
restore	 

		// create tabel in docx
// 		putdocx clear
// 		putdocx begin
		putdocx paragraph, font(consolas, 9) halign(center)
			putdocx text ("Availability by country (1=available)") , italic 
		
		putdocx table b = matrix(mb), rownames colnames border(all, nil) layout(autofitcontent) border(insideH, single, lightgray, .2) halign(center)
			putdocx table b(.,.), font(consolas, 8) nformat(%1.0f) halign(center)
			putdocx table b(1,.) , border(top, single) border(bottom, single)   
			putdocx table b(.,1) , halign(left)   
 			putdocx table b(`rows',.) ,  border(bottom, single)  
// 		putdocx save "temp.docx" , replace
	
end
	
 


 	
//eof
