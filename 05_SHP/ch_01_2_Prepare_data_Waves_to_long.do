*
**|=====================================|
**|	    ####	CPF	v1.5	####		|
**|		>>>	SHP							|
**|		>>	02 Waves to long			|
**|-------------------------------------|
**|		Konrad Turek 	| 	2023		|
**|=====================================|
*

/*NOTES:

1. Adding new variables
- 	there are 3-4 places you have to put a name of a new variable from the wave-specific
	files you want to add
-	these places are indicated as below:
		*>>>
		*>>> NEW VARS [x*x; y*] 1/3:  
		*>>>
-	you must adjust formating of the name in each case 
-	x*x - variables with year inside of the name, e.g. p17e50 (3 places to add)
-	y*  - variables with year at the end of the name, e.g. educat17 (4 places to add)
-	please, verifiy if the resuls are correct, there are a few rules which help
	to check it

*/



***
// clear
// set more off
// clear matrix
// set maxvar 32767

*** NOTE: Must istall svmat2 (STB-56 dm79):
* net install  http://www.stata.com/stb/stb56/dm79



**--------------------------------------
** Generate strings of waves' numbers  
**--------------------------------------
local waves `" "00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "' 
local n=10
local last=${shp_w}
while `n'<= `last' {
    local i="`n'"
    local waves = `" `waves'"' + `" "`i'" "' 
	local ++n
}
global waves= `"`waves'"'
di $waves

*
local waves2 `" "00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "' 
local n=10
local last=${shp_w}-2
while `n'<= `last' {
    local i="`n'"
    local waves2 = `" `waves2'"' + `" "`i'" "' 
	local ++n
}
global waves2= `"`waves2'"'
di $waves2

*
global years =   "99"  + `" `waves2'"' 
di $years
 
*
local n=1
local last=${shp_w}
while `n'<= `last' {
    local i="`n'"
    local wavesn = `" `wavesn'"' + `" "`i'" "' 
	local ++n
}
global wavesn= `"`wavesn'"'
di $wavesn


*############################
*#							#
*#	Data - All vars			#
*#							#
*############################
**--------------------------------------
** Get a wide file with all variables 
**--------------------------------------

use "${shp_in}\SHP-Data-WA-STATA\shp_mp.dta", clear
merge 1:1 idpers using "${shp_in}\SHP-Data-W1-W${shp_w}-STATA\W1_1999\shp99_p_user", nogen keep(1 3) 
gen wave99=1999
local m=2  // local macro for a loop
foreach y in $waves2 {
	merge 1:1 idpers using "${shp_in}\SHP-Data-W1-W${shp_w}-STATA\W`m'_20`y'\shp`y'_p_user", nogen keep(1 3) 
	gen wave`y'=20`y'
	local m = `m' + 1
}
save "${shp_out_work}\shp_allw_wide.dta", replace



/**--------------------------------------
** Option: Rename single vars to get a long file 
**--------------------------------------
**** to adjust 2
global data "E:\2019_20 CRITEVENTS\02_Cntry_Data_Orgin\05_SHP\Data STATA\SHP-Data-W1-W19-STATA\_w1-w19 p" 

foreach year in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 {
 use idpers p`year'c44 p`year'd29 sex`year' using "$data\shp`year'_p_user", clear
 gen lifesat=p`year'c44 if p`year'c44>-1
 gen partner=p`year'd29==1 | p`year'd29==2 if p`year'd29>0
 drop p`year'c44 p`year'd29
 keep if lifesat<. & partner<.
 save "E:\2019_20 CRITEVENTS\temp\temp`year'", replace
}
 
* Create a long file
use "E:\2019_20 CRITEVENTS\temp\temp00", clear
foreach year in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 {
 append using "E:\2019_20 CRITEVENTS\temp\temp`year'"
}
*/
 

**--------------------------------------
** Open merged dataset
**-------------------------------------- 

*** Work on waves:
use "${shp_out_work}\shp_allw_wide.dta", clear


disp "vars: " c(k) "   N: " _N


*############################
*#							#
*#	KEEP selected vars		#
*#							#
*############################

	*>>>
	*>>> NEW VARS [x*x; y*] 1/3: add variable here under the "keep" command (with * instead of year)
	*>>> e.g. P17E18 --> p*e18; IS3MAJ17 --> is3maj*
	*>>>

keep 			///
idpers* wave*  age*  idhous* birthy isced* educat* occupa*	pdate*	///
p*d110a p*d110b ownkid* civsta* p*c44 p*c01 p*c02 p*c19a		///
p*e03 p*e04 p*e05 p*e30		///
p*e14 p*e15a p*e15b p*e15 		///
wstat* p*w01 p*w03 p*w04 p*w05 p*w06 p*w613 p*w12 p*w13 p*w14		///
p*w610 p*w29 p*w291 p*w292 p*w293 p*w31 p*w32 p*w34a		///
p*w39 p*w42 p*w46 p*w85 p*w71a p*w74 p*w77 		///
p*w86a p*w87 p*w90 		///
p*w92 p*w93 p*w94 p*w229 p*w230 p*w615 p*w616 p*w228 p*w95 p*w96		///
p*w100 p*w101		///
is1maj* is2maj* is3maj* is4maj*		///
cspmaj* gldmaj* esecmj* tr1maj* caimaj* wr3maj*		///
noga2m* p*w608 p*w609		///
p*i01		///
p*i70 p*i80  p*i90 p*e18	 		 										///
i*ptotn i*ptotg i*empyn i*empyg i*indyn i*indyg i*wyg 		///
i*wyn i*empmg i*empmn i*indmg i*indmn		///
p*ql04 p*n35		///
x*c15 x*c16 x*c05 x*i04 x*w01 xis1ma* xis2ma* xis3ma* xis4ma* x*w02 x*w03 x*w04	 ///
p*d29 status* rnpx* ///
p*e16 nat_1_* reg_1_* p*d160 /// migration set indiv
p*r01 p*r04 //religion

*
save "${shp_out_work}\01_selected_w.dta", replace


/*
*Activities calendar detailed
p02w350 p02w351 p02w352 p02w353 p02w354 p02w355 p02w356 p02w357 p02w358 p02w359 p02w360 p02w361 p02w362 
p02w363 p02w364 p02w365 p02w366 p02w367 p02w368 p02w369 p02w370 p02w371 p03w362 p03w363 p03w364 p03w365 
p03w366 p03w367 p03w368 p03w369 p03w370 p03w371 p03w372 p03w373 p03w374 p03w375 p03w376 p03w377 p03w378 
p03w379 p03w380 p03w381 p03w382 p03w383 p04w374 p04w375 p04w376 p04w377 p04w378 p04w379 p04w380 p04w381 
p04w382 p04w383 p04w384 p04w385 p04w386 p04w387 p04w388 p04w389 p04w390 p04w391 p04w392 p04w393 p05w386 
p05w387 p05w388 p05w389 p05w390 p05w391 p05w392 p05w393 p05w394 p05w395 p05w396 p05w397 p05w398 p05w399 
p05w400 p05w401 p05w402 p05w403 p06w398 p06w399 p06w400 p06w401 p06w402 p06w403 p06w404 p06w405 p06w406 
p06w407 p06w408 p06w409 p06w410 p06w411 p06w412 p06w413 p06w414 p06w415 p07w410 p07w411 p07w412 p07w413 
p07w414 p07w415 p07w416 p07w417 p07w418 p07w419 p07w420 p07w421 p07w422 p07w423 p07w424 p07w425 p07w426 
p07w427 p08w422 p08w423 p08w424 p08w425 p08w426 p08w427 p08w428 p08w429 p08w430 p08w431 p08w432 p08w433 
p08w434 p08w435 p08w436 p08w437 p08w438 p08w439 p08w440 p09w434 p09w435 p09w436 p09w437 p09w438 p09w439 
p09w440 p09w441 p09w442 p09w443 p09w444 p09w445 p09w446 p09w447 p09w448 p09w449 p09w450 p09w451 p09w452 
p10w446 p10w447 p10w448 p10w449 p10w450 p10w451 p10w452 p10w453 p10w454 p10w455 p10w456 p10w457 p10w458 
p10w459 p10w460 p10w461 p10w462 p10w463 p10w464 p11w458 p11w459 p11w460 p11w461 p11w462 p11w463 p11w464 
p11w465 p11w466 p11w467 p11w468 p11w469 p11w470 p11w471 p11w472 p11w473 p11w474 p11w475 p11w476 p12w470 
p12w471 p12w472 p12w473 p12w474 p12w475 p12w476 p12w477 p12w478 p12w479 p12w480 p12w481 p12w482 p12w483 
p12w484 p12w485 p12w486 p12w487 p12w488 p13w482 p13w483 p13w484 p13w485 p13w486 p13w487 p13w488 p13w489 
p13w490 p13w491 p13w492 p13w493 p13w494 p13w495 p13w496 p13w497 p13w498 p13w499 p13w501 p14w494 p14w495 
p14w496 p14w497 p14w498 p14w499 p14w501 p14w502 p14w503 p14w504 p14w505 p14w506 p14w507 p14w508 p14w509 
p14w510 p14w511 p14w512 p14w513 p15w507 p15w508 p15w509 p15w510 p15w511 p15w512 p15w513 p15w514 p15w515 
p15w516 p15w517 p15w518 p15w519 p15w520 p15w521 p15w522 p15w523 p15w524 p15w525 p16w519 p16w520 p16w521 
p16w522 p16w523 p16w524 p16w525 p16w526 p16w527 p16w528 p16w529 p16w530 p16w531 p16w532 p16w533 p16w534 
p16w535 p16w536 p16w537 p17w531 p17w532 p17w533 p17w534 p17w535 p17w536 p17w537 p17w538 p17w539 p17w540 
p17w541 p17w542 p17w543 p17w544 p17w545 p17w546 p17w547 p17w548 p17w549

*/

*############################
*#							#
*#	Rename					#
*#							#
*############################

use "${shp_out_work}\01_selected_w.dta", clear

***
disp "vars: " c(k) "   N: " _N


**--------------------------------------
** Rename vars with 'year' inside of the name
**--------------------------------------

*** Check no of variables to rename 

	*>>>
	*>>> NEW VARS [x*x] 2/3 : the same format as in step 1 
	*>>> e.g. P17E18 --> p*e18
	*>>>
		
unab all:    ///
	p*d110a p*d110b p*c44 p*c01 p*c02 p*c19a		///
	p9*e05 p9*e14 p9*e15 					/// to distinghuish from pdate*
	p0*e03 p0*e04 p0*e05 	p0*e14 p0*e15 	/// to distinghuish from pdate*
	p1*e03 p1*e04 p1*e05 	p1*e14 p1*e15 	/// to distinghuish from pdate*
	p*e15a p*e15b p*e30		///
	p*w01 p*w03 p*w04 p*w05 p*w06 p*w613 p*w12 p*w13 p*w14		///
	p*w610 p*w29 p*w291 p*w292 p*w293 p*w31 p*w32 p*w34a		///
	p*w39 p*w42 p*w46 p*w85 p*w71a p*w74 p*w77 		///
	p*w86a p*w87 p*w90 		///
	p*w92 p*w93 p*w94 p*w229 p*w230 p*w615 p*w616 p*w228 p*w95 p*w96		///
	p*w100 p*w101		///
	p*w608 p*w609		///
	p*i01		///
	p*ql04 p*n35		///
	p*i70 p*i80  p*i90 	p*e18			///
	i*ptotn i*ptotg i*empyn i*empyg i*indyn i*indyg i*wyg 		///
	i*wyn i*empmg i*empmn i*indmg i*indmn		///
	x*c15 x*c16 x*c05 x*i04 x*w01  x*w02 x*w03 x*w04 ///
	p*d29 ///
	p*e16 p*d160 /// migration indiv
	p*r01 p*r04 //religion

	
local allcount : word count `all'
disp `allcount'

*** Rename 
** Short version adjusted to no of waves:
set matsize 2000
 foreach i in p i x   {
    local n=1
    foreach y in $years {
		rename (`i'`y'*) (`i'_*_`n'), r
		local ++n 
		}
}

/*
** Explicite version of rename - prints results in Stata ("dryrun" option), but requires to update sytax with new waves 
set matsize 2000
foreach i in p i x   {
rename (`i'99*  `i'00*  `i'01*  `i'02*  `i'03*  `i'04*  `i'05*  `i'06*  `i'07* `i'08*  `i'09*  `i'10*  `i'11*  `i'12*  `i'13*  `i'14*  `i'15*  `i'16*  `i'17* `i'18*   )   /// 
(`i'_*_1 `i'_*_2 `i'_*_3 `i'_*_4 `i'_*_5 `i'_*_6 `i'_*_7 `i'_*_8 `i'_*_9 `i'_*_10 `i'_*_11 `i'_*_12 `i'_*_13 `i'_*_14 `i'_*_15 `i'_*_16 `i'_*_17 `i'_*_18 `i'_*_19 `i'_*_20 ), dryrun 
rename (`i'99*  `i'00*  `i'01*  `i'02*  `i'03*  `i'04*  `i'05*  `i'06*  `i'07* `i'08*  `i'09*  `i'10*  `i'11*  `i'12*  `i'13*  `i'14*  `i'15*  `i'16*  `i'17* `i'18*   )   /// 
(`i'_*_1 `i'_*_2 `i'_*_3 `i'_*_4 `i'_*_5 `i'_*_6 `i'_*_7 `i'_*_8 `i'_*_9 `i'_*_10 `i'_*_11 `i'_*_12 `i'_*_13 `i'_*_14 `i'_*_15 `i'_*_16 `i'_*_17 `i'_*_18 `i'_*_19 `i'_*_20 ), r

	* If needed: saves results in matrix (2 new vars in dataset) and Excel file 
		local old=r(oldnames)
		local new=r(newnames)
		local count`i' : word count `old'
		mat old = J(`count`i'',1,0)
			matrix rowname old = `old'
			svmat2 old, rnames(old)  
			*mat list old
		mat new = J(`count`i'',1,0)
			matrix rowname new = `new'
			svmat2 new, rnames(new)  
			*mat list vars new
		drop old1 new1
		di  "`i': " `count`i''	// check no of variables renamed 
		local count=`count'+`count`i''
		*bro old new
		export excel old new using "${shp_out_work}\rename_report_`i'.xls" if old !="", firstrow(variables) replace
		drop old new
}
disp "Variables renamed >> p: " `countp' ";   i: " `counti' ";   x: " `countx' ";   ALL: "`count'
*
disp "Variables remaining: " c(k)-`count'
*/


 

 
**--------------------------------------
** Renaming vars with year at the end 
**--------------------------------------

*** Check no of variables to rename 

	*>>>
	*>>> NEW VARS [y*] 2a/3 : the same format as in step 1 
	*>>> e.g. IS3MAJ17 --> is3maj*
	*>>>

unab all:    ///
	idpers* wave*  age*  idhous*   isced* educat* occupa*	pdate* ownkid*	///
	civsta* wstat*  is1maj* is2maj* is3maj* is4maj*	cspmaj* gldmaj* esecmj* 	///
	tr1maj* caimaj* wr3maj*	noga2m*  xis1ma* xis2ma* xis3ma* xis4ma*		///
	status* rnpx* nat_1_* reg_1_* 

local allcount : word count `all'
disp `allcount'


	*>>>
	*>>> NEW VARS [y*] 2b/3 : remove year-suffix 
	*>>> e.g. IS3MAJ17 --> is3maj
	*>>>
rename statuscovid COVIDstatuscovid

local x=0
foreach name in  wave age idhous   isced educat occupa pdate ownkid ///
	civsta wstat is1maj is2maj is3maj is4maj cspmaj gldmaj esecmj 	///
	tr1maj caimaj wr3maj noga2m xis1ma xis2ma xis3ma xis4ma status rnpx nat_1_ reg_1_ ///
{
rename `name'* `name'#, renumber dryrun  // Reports results 
rename `name'* `name'_#, renumber r
unab namess: `name'*
local count : word count `namess'
local x=`x'+`count'
}
di "Renamed variables: " `x' "+ birthy & idpers"

 
***
save "${shp_out_work}\01_selected_w_v2.dta", replace


*############################
*#							#
*#	Reshape					#
*#							#
*############################

use "${shp_out_work}\01_selected_w_v2.dta", clear 

disp "vars: " c(k) "   N: " _N

**--------------------------------------
** Reshape
**--------------------------------------
* Variables to reshape 

	*>>>
	*>>> NEW VARS [x*x;y*] 3/3: substitute year by "_" and add suffix "_"  
	*>>> e.g. P17E18 --> p_e18_; IS3MAJ17 --> is3maj_
	*>>>

*only include time-changing variables:	
local vars1 	///
		age_ idhous_ isced_ educat_ occupa_ pdate_ ownkid_ 				///
		civsta_ wstat_ is1maj_ is2maj_ is3maj_ is4maj_ cspmaj_ gldmaj_ esecmj_ 	///
		tr1maj_ caimaj_ wr3maj_ noga2m_ xis1ma_ xis2ma_ xis3ma_ xis4ma_ 	///
		status_ rnpx_ nat_1__ reg_1__ 

local vars2 	///
		p_d110a_ p_d110b_ p_c44_ p_c01_ p_c02_ p_c19a_					///
		p_e05_ 	p_e03_ p_e04_  p_e14_ p_e15_ 							/// 
		p_e15a_ p_e15b_ p_e30_											///
		p_w01_ p_w03_ p_w04_ p_w05_ p_w06_ p_w613_ p_w12_ p_w13_ p_w14_	///
		p_w610_ p_w29_ p_w291_ p_w292_ p_w293_ p_w31_ p_w32_ p_w34a_	///
		p_w39_ p_w42_ p_w46_ p_w85_ p_w71a_ p_w74_ p_w77_ 				///
		p_w86a_ p_w87_ p_w90_ 											///
		p_w92_ p_w93_ p_w94_ p_w229_ p_w230_ p_w615_ p_w616_ p_w228_ p_w95_ p_w96_	///
		p_w100_ p_w101_													///
		p_w608_ p_w609_													///
		p_i01_															///
		p_ql04_ p_n35_													///
		p_i70_ p_i80_ p_i90_  p_e18_									///
		i_ptotn_ i_ptotg_ i_empyn_ i_empyg_ i_indyn_ i_indyg_ i_wyg_ 	///
		i_wyn_ i_empmg_ i_empmn_ i_indmg_ i_indmn_						///
		x_c15_ x_c16_ x_c05_ x_i04_ x_w01_  x_w02_ x_w03_ x_w04_ 		///
		p_d29_ p_e16_ p_d160_ 											
		
local vars3	///
		p_r01_ p_r04_ 	// religion

	

			
		 *Capture variable labels
			foreach n in `vars1' `vars2' {
				capture local `n'label: variable label `n'${shp_w} 
			}
			* for religion separate besouse of rotating panel
			foreach n in `vars3' {
				local `n'label: variable label `n'20
						}
			
local vars_all `vars1' `vars2' `vars3'


		* Reshape
		reshape long  "`vars_all'" ///
		, i(idpers) j(wave $wavesn)

		* Redefine labels
			foreach n in `vars1' `vars2' {
				label variable `n' "``n'label'"
			}
			* for religion separate besouse of rotating panel
			foreach n in `vars3' {
				label variable `n' "``n'label'"
			}
			lab val p_r01_ P18R01 //note: new labels can be added in future waves
			lab val p_r04_ P18R04 //
			*


***	
order wave_*, first
drop wave_1-wave_19


*** recode wave
local year=1999
local wavesn=`" ${wavesn} "'
foreach x in `wavesn' {
	recode wave  (`x'=`year')
	local ++year 
}
/* the above equals to: 
recode wave  (1=1999) (2=2000) (3=2001) (4=2002) (5=2003) (6=2004) (7=2005) ///
	(8=2006) (9=2007) (10=2008) (11=2009) (12=2010) (13=2011) (14=2012) ///
	(15=2013) (16=2014) (17=2015) (18=2016) (19=2017)  (20=2018)
*/

*
drop if pdate==. & age==.
*
rename *_ *
*
order idpers wave idhous pdate  birthy  age, first
***
disp "vars: " c(k) "   N: " _N

***
save "${shp_out_work}\01_selected_long.dta", replace




*############################
*#							
*#	Add vars from additional files
*#							
*############################

use "${shp_out_work}\01_selected_long.dta", clear 
disp "vars: " c(k) "   N: " _N

**--------------------------------------
** shp_so.dta - pid-constant vars about history and parents
**--------------------------------------
* parents education (p__o17) and other 
// rename pid idpers		  
merge m:1 idpers  using "${shp_in}\SHP-Data-WA-STATA\shp_so.dta" , ///
	keep(1 2 3) nogen  keepusing(	///
	p__o07 is1faj__ is4faj__ cspfaj__ gldfaj__ esecfa__ tr1faj__ caifaj__ wr3faj__ p__o17	p__o20 /// father
	p__o24 is1moj__ is4moj__ cspmoj__ gldmoj__ esecmo__ tr1moj__ caimoj__ wr3moj__ p__o34	p__o37 /// mother
	)
rename  idpers pid

*
disp "vars: " c(k) "   N: " _N



***
save "${shp_out}\ch_01_selected_long.dta", replace
	 
*____________________________________________________________________________
*--->	END	 <---








