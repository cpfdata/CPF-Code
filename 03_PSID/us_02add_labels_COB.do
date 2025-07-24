*#######################
*# COB country labels  #
*#######################

label define COB ///
0 "Born in Survey-Country" ///
1 "Oceania and Antarctica" ///
2 "North-West Europe" ///
3 "Southern and Eastern Europe" ///
4 "North Africa and the Middle East" ///
5 "South-East Asia" ///
6 "North-East Asia" ///
7 "Southern and Central Asia" ///
8 "Americas" ///
9 "Sub-Saharan Africa" ///
10 "Other" ///
-1 "MV general" ///
-2 "DK/refusal" ///
-3 "NA" ///
-8 "Not asked in survey" ///
-9 "Not asked in wave" ///
.a "[.a] missing: grewup_US available"


foreach var in temp_cob {
	gen cob_`var'=.
		replace cob_`var'=4 if `var'==105 //colony of aden (yemen)
		replace cob_`var'=7 if `var'==110 //Afghanistan
		replace cob_`var'=3 if `var'==120 //Albania
		replace cob_`var'=4 if `var'==125 //Algeria
		replace cob_`var'=9 if `var'==145 //Angola
		replace cob_`var'=8 if `var'==149 //antigua
		replace cob_`var'=8 if `var'==150 //Argentina
		replace cob_`var'=7 if `var'==155 //Armenia
		replace cob_`var'=1 if `var'==160 //Australia (includes External Territories)
		replace cob_`var'=2 if `var'==165 //Austria
		replace cob_`var'=10 if `var'==175 //azores
		replace cob_`var'=8 if `var'==180 //Bahamas
		replace cob_`var'=4 if `var'==181 //Bahrain
		replace cob_`var'=7 if `var'==182 //Bangladesh
		replace cob_`var'=8 if `var'==184 //barbados
		replace cob_`var'=3 if `var'==188 //Belarus
		replace cob_`var'=3 if `var'==190 //Belgium
		replace cob_`var'=8 if `var'==191 //Belize
		replace cob_`var'=8 if `var'==195 //bermuda
		replace cob_`var'=8 if `var'==205 //Bolivia
		replace cob_`var'=3 if `var'==210 //Bosnia and Herzegovina
		replace cob_`var'=8 if `var'==220 //Brazil
		replace cob_`var'=8 if `var'==230 //british honduras (belize)
		replace cob_`var'=5 if `var'==232 //brunei
		replace cob_`var'=3 if `var'==245 //Bulgaria
		replace cob_`var'=9 if `var'==248 //Burkina Faso
		replace cob_`var'=5 if `var'==250 //birma
		replace cob_`var'=9 if `var'==252 //burundi
		replace cob_`var'=5 if `var'==255 //Cambodia
		replace cob_`var'=9 if `var'==257 //Cameroon
		replace cob_`var'=8 if `var'==260 //Canada
		replace cob_`var'=4 if `var'==261 //canary islands
		replace cob_`var'=8 if `var'==265 //canal zone (panama)
		replace cob_`var'=9 if `var'==268 //central african republic
		replace cob_`var'=7 if `var'==270 //Sri Lanka
		replace cob_`var'=8 if `var'==275 //Chile
		replace cob_`var'=6 if `var'==280 //China
		replace cob_`var'=8 if `var'==285 //Colombia
		replace cob_`var'=9 if `var'==290 //Congo
		replace cob_`var'=8 if `var'==295 //Costa Rica
		replace cob_`var'=3 if `var'==299 //Croatia
		replace cob_`var'=8 if `var'==300 //Cuba
		replace cob_`var'=3 if `var'==305 //Cyprus
		replace cob_`var'=3 if `var'==307 //Czech Republic
		replace cob_`var'=3 if `var'==310 //chechoslovakia
		replace cob_`var'=9 if `var'==311 //dahomey (benin)
		replace cob_`var'=2 if `var'==315 //Denmark
		replace cob_`var'=8 if `var'==319 //dominicana
		replace cob_`var'=8 if `var'==320 //dominican republic
		replace cob_`var'=8 if `var'==325 //Ecuador
		replace cob_`var'=8 if `var'==330 //El Salvador
		replace cob_`var'=9 if `var'==331 //Eritrea
		replace cob_`var'=4 if `var'==333 //Egypt
		replace cob_`var'=3 if `var'==334 //estonia
		replace cob_`var'=9 if `var'==335 //Ethiopia
		replace cob_`var'=1 if `var'==338 //Fiji
		replace cob_`var'=2 if `var'==340 //Finland
		replace cob_`var'=2 if `var'==350 //France
		replace cob_`var'=8 if `var'==360 //Guiana
		replace cob_`var'=2 if `var'==390 //Germany
		replace cob_`var'=9 if `var'==391 //Ghana
		replace cob_`var'=3 if `var'==400 //Greece
		replace cob_`var'=2 if `var'==405 //greenland
		replace cob_`var'=8 if `var'==406 //Grenada
		replace cob_`var'=8 if `var'==407 //guadelupe
		replace cob_`var'=1 if `var'==410 //guam
		replace cob_`var'=8 if `var'==415 //Guatemala
		replace cob_`var'=9 if `var'==417 //Guinea
		replace cob_`var'=8 if `var'==418 //guyana
		replace cob_`var'=8 if `var'==420 //Haiti
		replace cob_`var'=8 if `var'==430 //Honduras
		replace cob_`var'=6 if `var'==435 //Hong Kong
		replace cob_`var'=3 if `var'==445 //Hungary
		replace cob_`var'=2 if `var'==450 //Iceland
		replace cob_`var'=7 if `var'==455 //India
		replace cob_`var'=5 if `var'==458 //Indonesia
		replace cob_`var'=4 if `var'==460 //Iran
		replace cob_`var'=4 if `var'==465 //Iraq
		replace cob_`var'=2 if `var'==470 //Ireland
		replace cob_`var'=4 if `var'==475 //Israel
		replace cob_`var'=3 if `var'==480 //Italy
		replace cob_`var'=9 if `var'==485 //Côte d'Ivoire
		replace cob_`var'=8 if `var'==487 //Jamaica
		replace cob_`var'=6 if `var'==490 //Japan
		replace cob_`var'=4 if `var'==500 //Jordan
		replace cob_`var'=9 if `var'==505 //Kenya
		replace cob_`var'=6 if `var'==515 //Korea
		replace cob_`var'=4 if `var'==520 //Kuwait
		replace cob_`var'=5 if `var'==530 //Laos
		replace cob_`var'=3 if `var'==535 //Latvia
		replace cob_`var'=4 if `var'==540 //Lebanon
		replace cob_`var'=9 if `var'==545 //Liberia
		replace cob_`var'=4 if `var'==550 //Lybia
		replace cob_`var'=3 if `var'==560 //Lithuania
		replace cob_`var'=3 if `var'==570 //Luxembourg
		replace cob_`var'=6 if `var'==573 //Macao
		replace cob_`var'=9 if `var'==575 //Madagascar
		replace cob_`var'=9 if `var'==577 //Malawi
		replace cob_`var'=5 if `var'==580 //Malaysia
		replace cob_`var'=9 if `var'==585 //Mali
		replace cob_`var'=3 if `var'==590 //Malta
		replace cob_`var'=9 if `var'==593 //Mauritius
		replace cob_`var'=8 if `var'==595 //Mexico
		replace cob_`var'=2 if `var'==607 //Monaco
		replace cob_`var'=4 if `var'==610 //Morocco
		replace cob_`var'=9 if `var'==615 //Mozambique
		replace cob_`var'=7 if `var'==617 //Karabakh
		replace cob_`var'=1 if `var'==618 //Nampo Shoto
		replace cob_`var'=7 if `var'==619 //Kyrgyzstan
		replace cob_`var'=8 if `var'==620 //Nevassa
		replace cob_`var'=7 if `var'==625 //Nepal
		replace cob_`var'=3 if `var'==630 //The Netherlands
		replace cob_`var'=8 if `var'==640 //Netherlands Antilles
		replace cob_`var'=1 if `var'==645 //New Caledonia
		replace cob_`var'=1 if `var'==650 //New Guinea
		replace cob_`var'=1 if `var'==660 //New Zealand
		replace cob_`var'=8 if `var'==665 //Nicaragua
		replace cob_`var'=9 if `var'==667 //Niger
		replace cob_`var'=9 if `var'==670 //Nigeria
		replace cob_`var'=2 if `var'==685 //Norway
		replace cob_`var'=4 if `var'==698 //Oman
		replace cob_`var'=7 if `var'==700 //Pakistan
		replace cob_`var'=4 if `var'==705 //Palestine
		replace cob_`var'=8 if `var'==710 //Panama
		replace cob_`var'=8 if `var'==715 //Paraguay
		replace cob_`var'=8 if `var'==720 //Peru
		replace cob_`var'=5 if `var'==725 //Philippines
		replace cob_`var'=3 if `var'==730 //Poland
		replace cob_`var'=3 if `var'==735 //Portugal
		replace cob_`var'=8 if `var'==745 //Puerto Rico
		replace cob_`var'=4 if `var'==748 //Qatar
		replace cob_`var'=3 if `var'==755 //Romania
		replace cob_`var'=3 if `var'==757 //Russia
		replace cob_`var'=9 if `var'==758 //Rwanda
		replace cob_`var'=6 if `var'==760 //Ryukyu Islands
		replace cob_`var'=9 if `var'==765 //Saint Helena Colony
		replace cob_`var'=8 if `var'==768 //Saint Kitts & Nevis
		replace cob_`var'=8 if `var'==770 //St Lucia
		replace cob_`var'=8 if `var'==773 //Saint Martin
		replace cob_`var'=8 if `var'==775 //Saint Vincent
		replace cob_`var'=4 if `var'==785 //Saudi Arabia
		replace cob_`var'=9 if `var'==787 //Senegal
		replace cob_`var'=9 if `var'==788 //Seychelles
		replace cob_`var'=3 if `var'==789 //Serbia
		replace cob_`var'=9 if `var'==790 //Sierra Leone
		replace cob_`var'=5 if `var'==795 //Singapore
		replace cob_`var'=3 if `var'==797 //Slovakia
		replace cob_`var'=3 if `var'==798 //Slovenia
		replace cob_`var'=9 if `var'==800 //Somalia
		replace cob_`var'=9 if `var'==801 //South Africa
		replace cob_`var'=9 if `var'==803 //Southern Rhodesia
		replace cob_`var'=3 if `var'==805 //Soviet Union
		replace cob_`var'=3 if `var'==805 //USSR
		replace cob_`var'=3 if `var'==830 //Spain
		replace cob_`var'=4 if `var'==835 //Sudan
		replace cob_`var'=8 if `var'==840 //Surinam
		replace cob_`var'=8 if `var'==845 //Swan Island
		replace cob_`var'=9 if `var'==847 //Swaziland
		replace cob_`var'=2 if `var'==850 //Sweden
		replace cob_`var'=2 if `var'==855 //Switzerland
		replace cob_`var'=4 if `var'==858 //Syria
		replace cob_`var'=6 if `var'==862 //Taiwan
		replace cob_`var'=9 if `var'==865 //Tanzania
		replace cob_`var'=5 if `var'==875 //Thailand
		replace cob_`var'=9 if `var'==885 //Togo
		replace cob_`var'=8 if `var'==887 //Trinidad and Tobago
		replace cob_`var'=8 if `var'==888 //Tobago
		replace cob_`var'=8 if `var'==889 //Trinidad
		replace cob_`var'=4 if `var'==890 //Tunisia
		replace cob_`var'=1 if `var'==900 //Trust Territory of Pacific Islands
		replace cob_`var'=4 if `var'==905 //Turkey
		replace cob_`var'=9 if `var'==910 //Uganda
		replace cob_`var'=3 if `var'==915 //Ukraine
		replace cob_`var'=4 if `var'==921 //United Arab Emirates
		replace cob_`var'=4 if `var'==922 //United Arab Republic
		replace cob_`var'=2 if `var'==925 //UK
		replace cob_`var'=9 if `var'==927 //Upper Volta (Burkina Faso)
		replace cob_`var'=8 if `var'==930 //Uruguay
		replace cob_`var'=7 if `var'==937 //Uzbekistan
		replace cob_`var'=8 if `var'==940 //Venezuela
		replace cob_`var'=5 if `var'==945 //Vietnam
		replace cob_`var'=8 if `var'==950 //Virgin Islands
		replace cob_`var'=1 if `var'==960 //Wake Island
		replace cob_`var'=9 if `var'==961 //West Africa
		replace cob_`var'=2 if `var'==963 //Western Samoa
		replace cob_`var'=4 if `var'==965 //Yemen
		replace cob_`var'=3 if `var'==970 //Former Yugoslavia
		replace cob_`var'=9 if `var'==990 //Zambia
		replace cob_`var'=9 if `var'==995 //Zimbabwe
		replace cob_`var'=10 if `var'==999 //Foreign country non-specified
		replace cob_`var'=.a if `var'==.a //Question not asked and no info cob
		replace cob_`var'=10 if `var'==.b //Foreign-born but no country specified
		replace cob_`var'=10 if ((`var'==. | `var'==.b | `var'==.a) & migr==1) // Foreign-born but cob info missing
		replace cob_`var'=0 if migr==0 // USA
					}

rename cob_temp_cob cob_rt
