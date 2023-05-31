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
-2 "Item non-response" ///
-3 "Does not apply" ///
-8 "Question not asked in survey"

// If you want to add cob_f & cob_m, change the line below to"
// "foreach var in corigin forigin morigin {" 

foreach var in corigin   {
	gen cob_`var'=.
			replace cob_`var'=1 if `var'==41 //Australia (includes External Territories)
		replace cob_`var'=1 if `var'==56 //New Zealand
		replace cob_`var'=1 if `var'==129 //Samoa
		replace cob_`var'=1 if `var'==137 //Micronesia
		replace cob_`var'=1 if `var'==182 //Fiji
		replace cob_`var'=2 if `var'==14 //UK
		replace cob_`var'=0 if `var'==1 //Germany
		replace cob_`var'=2 if `var'==10 //Austria
		replace cob_`var'=2 if `var'==11 //France
		replace cob_`var'=2 if `var'==13 //Denmark
		replace cob_`var'=2 if `var'==15 //Sweden
		replace cob_`var'=2 if `var'==16 //Norway
		replace cob_`var'=2 if `var'==17 //Finland
		replace cob_`var'=2 if `var'==19 //Switzerland
		replace cob_`var'=2 if `var'==70 //Iceland
		replace cob_`var'=2 if `var'==71 //Ireland
		replace cob_`var'=2 if `var'==12 //Benelux
		replace cob_`var'=2 if `var'==69 //Liechtenstein
		replace cob_`var'=2 if `var'==62 //Monaco
		replace cob_`var'=2 if `var'==7 //Former DDR
		replace cob_`var'=3 if `var'==4 //Greece
		replace cob_`var'=3 if `var'==5 //Italy
		replace cob_`var'=3 if `var'==6 //Spain
		replace cob_`var'=3 if `var'==21 //Romania
		replace cob_`var'=3 if `var'==22 //Poland
		replace cob_`var'=3 if `var'==26 //Hungary
		replace cob_`var'=3 if `var'==28 //Portugal
		replace cob_`var'=3 if `var'==29 //Bulgaria
		replace cob_`var'=3 if `var'==31 //Czech Republic
		replace cob_`var'=3 if `var'==101 //Estland
		replace cob_`var'=3 if `var'==146 //Lithuania
		replace cob_`var'=3 if `var'==140 //Kosovo-Albaner
		replace cob_`var'=3 if `var'==106 //Montenegro
		replace cob_`var'=3 if `var'==32 //Russia
		replace cob_`var'=3 if `var'==117 //Belgium
		replace cob_`var'=3 if `var'==118 //The Netherlands
		replace cob_`var'=3 if `var'==116 //Luxembourg
		replace cob_`var'=3 if `var'==73 //Moldova
		replace cob_`var'=3 if `var'==75 //Albania
		replace cob_`var'=3 if `var'==78 //Ukraine
		replace cob_`var'=3 if `var'==168 //Montenegro
		replace cob_`var'=3 if `var'==165 //Serbia
		replace cob_`var'=3 if `var'==103 //Latvia
		replace cob_`var'=3 if `var'==120 //Bosnia and Herzegovina
		replace cob_`var'=3 if `var'==122 //Slovenia
		replace cob_`var'=3 if `var'==123 //Slovakia
		replace cob_`var'=3 if `var'==121 //North Macedonia
		replace cob_`var'=3 if `var'==222 //Eastern Europe
		replace cob_`var'=3 if `var'==119 //Croatia
		replace cob_`var'=3 if `var'==112 //Malta
		replace cob_`var'=3 if `var'==3 //Former Yugoslavia
		replace cob_`var'=3 if `var'==58 //Cyprus
		replace cob_`var'=3 if `var'==153 //Free City of Danzig (now Poland)
		replace cob_`var'=3 if `var'==196 //Kosovo
		replace cob_`var'=3 if `var'==132 //Belarus
		replace cob_`var'=3 if `var'==180 //Bessarabia (Moldova)
		replace cob_`var'=3 if `var'==188 //Chechnya
		replace cob_`var'=4 if `var'==2 //Turkey
		replace cob_`var'=4 if `var'==30 //Syria
		replace cob_`var'=4 if `var'==81 //Egypt
		replace cob_`var'=4 if `var'==111 //Lybia
		replace cob_`var'=4 if `var'==67 //Marocco
		replace cob_`var'=4 if `var'==142 //Sudan
		replace cob_`var'=4 if `var'==52 //Tunisia
		replace cob_`var'=4 if `var'==161 //Bahrain
		replace cob_`var'=4 if `var'==24 //Iran
		replace cob_`var'=4 if `var'==60 //Iraq
		replace cob_`var'=4 if `var'==39 //Israel
		replace cob_`var'=4 if `var'==90 //Jordan
		replace cob_`var'=4 if `var'==126 //Kuwait
		replace cob_`var'=4 if `var'==76 //Lebanon
		replace cob_`var'=4 if `var'==136 //Oman
		replace cob_`var'=4 if `var'==46 //Saudi Arabia
		replace cob_`var'=4 if `var'==87 //United Arab Emirates
		replace cob_`var'=4 if `var'==151 //Yemen
		replace cob_`var'=4 if `var'==79 //Algeria
		replace cob_`var'=4 if `var'==193 //Qatar
		replace cob_`var'=4 if `var'==33 //Kurdistan (added)
		replace cob_`var'=4 if `var'==152 //Palestine
		replace cob_`var'=5 if `var'==181 //Myanmar
		replace cob_`var'=5 if `var'==169 //Cambodia
		replace cob_`var'=5 if `var'==100 //Laos
		replace cob_`var'=5 if `var'==44 //Thailand
		replace cob_`var'=5 if `var'==83 //Vietnam
		replace cob_`var'=5 if `var'==25 //Indonesia
		replace cob_`var'=5 if `var'==104 //Malaysia
		replace cob_`var'=5 if `var'==38 //Philippines
		replace cob_`var'=5 if `var'==93 //Singapore
		replace cob_`var'=5 if `var'==160 //Timor-Leste
		replace cob_`var'=5 if `var'==128 //Malaysia
		replace cob_`var'=6 if `var'==23 //Korea
		replace cob_`var'=6 if `var'==40 //Japan
		replace cob_`var'=6 if `var'==68 //China
		replace cob_`var'=6 if `var'==63 //Hong Kong
		replace cob_`var'=6 if `var'==145 //Mongolia
		replace cob_`var'=6 if `var'==154 //Taiwan
		replace cob_`var'=7 if `var'==50 //Bangladesh
		replace cob_`var'=7 if `var'==74 //Kazakhstan
		replace cob_`var'=7 if `var'==82 //Tajikistan
		replace cob_`var'=7 if `var'==85 //Pakistan
		replace cob_`var'=7 if `var'==97 //Uzbekistan
		replace cob_`var'=7 if `var'==43 //Afghanistan
		replace cob_`var'=7 if `var'==66 //Nepal
		replace cob_`var'=7 if `var'==65 //Sri Lanka
		replace cob_`var'=7 if `var'==163 //Maldives
		replace cob_`var'=7 if `var'==155 //Turkmenistan
		replace cob_`var'=7 if `var'==91 //Turkmenistan-UdSSR
		replace cob_`var'=7 if `var'==148 //Armenia
		replace cob_`var'=7 if `var'==141 //Georgia
		replace cob_`var'=7 if `var'==77 //Kyrgyzstan
		replace cob_`var'=7 if `var'==42 //India
		replace cob_`var'=7 if `var'==177 //Bhutan
		replace cob_`var'=7 if `var'==130 //Azerbaijan
		replace cob_`var'=8 if `var'==18 //USA
		replace cob_`var'=8 if `var'==55 //Canada
		replace cob_`var'=8 if `var'==35 //Argentina
		replace cob_`var'=8 if `var'==48 //Colombia
		replace cob_`var'=8 if `var'==61 //Brazil
		replace cob_`var'=8 if `var'==64 //Peru
		replace cob_`var'=8 if `var'==96 //Ecuador
		replace cob_`var'=8 if `var'==99 //Puerto Rico
		replace cob_`var'=8 if `var'==115 //Trinidad and Tobago
		replace cob_`var'=8 if `var'==124 //Paraguay
		replace cob_`var'=8 if `var'==133 //Uruguay
		replace cob_`var'=8 if `var'==159 //Panama
		replace cob_`var'=8 if `var'==157 //Guatemala
		replace cob_`var'=8 if `var'==167 //Honduras
		replace cob_`var'=8 if `var'==88 //El Salvador
		replace cob_`var'=8 if `var'==92 //Costa Rica
		replace cob_`var'=8 if `var'==109 //Nicaragua
		replace cob_`var'=8 if `var'==134 //Bahamas
		replace cob_`var'=8 if `var'==27 //Bolivia
		replace cob_`var'=8 if `var'==34 //Mexico
		replace cob_`var'=8 if `var'==59 //Cuba
		replace cob_`var'=8 if `var'==72 //St Lucia
		replace cob_`var'=8 if `var'==170 //Surinam
		replace cob_`var'=8 if `var'==107 //Belize
		replace cob_`var'=8 if `var'==171 //Guiana
		replace cob_`var'=8 if `var'==108 //Dominican Republic
		replace cob_`var'=8 if `var'==45 //Jamaica
		replace cob_`var'=8 if `var'==51 //Venezuela
		replace cob_`var'=8 if `var'==20 //Chile
		replace cob_`var'=8 if `var'==175 //Grenada
		replace cob_`var'=8 if `var'==114 //Haiti
		replace cob_`var'=8 if `var'==164 //Hawaii (political specification)
		replace cob_`var'=9 if `var'==102 //Angola
		replace cob_`var'=9 if `var'==110 //Kenya
		replace cob_`var'=9 if `var'==113 //Botswana
		replace cob_`var'=9 if `var'==47 //Ethiopia
		replace cob_`var'=9 if `var'==89 //Eritrea
		replace cob_`var'=9 if `var'==84 //Somalia
		replace cob_`var'=9 if `var'==86 //South Africa
		replace cob_`var'=9 if `var'==37 //Benin
		replace cob_`var'=9 if `var'==49 //Ghana
		replace cob_`var'=9 if `var'==53 //Mauritius
		replace cob_`var'=9 if `var'==54 //Nigeria
		replace cob_`var'=9 if `var'==57 //Tanzania
		replace cob_`var'=9 if `var'==125 //Guinea
		replace cob_`var'=9 if `var'==105 //Namibia
		replace cob_`var'=9 if `var'==94 //Burkina Faso
		replace cob_`var'=9 if `var'==80 //Mozambique
		replace cob_`var'=9 if `var'==158 //Sierra Leone
		replace cob_`var'=9 if `var'==36 //Cabo Verde
		replace cob_`var'=9 if `var'==135 //Uganda
		replace cob_`var'=9 if `var'==174 //Madagascar
		replace cob_`var'=9 if `var'==173 //Zimbabwe
		replace cob_`var'=9 if `var'==166 //Gambia
		replace cob_`var'=9 if `var'==162 //Senegal
		replace cob_`var'=9 if `var'==138 //Mali
		replace cob_`var'=9 if `var'==139 //Cameroon
		replace cob_`var'=9 if `var'==150 //Liberia
		replace cob_`var'=9 if `var'==95 //Zambia
		replace cob_`var'=9 if `var'==143 //Congo
		replace cob_`var'=9 if `var'==144 //Togo
		replace cob_`var'=9 if `var'==176 //Lesotho
		replace cob_`var'=9 if `var'==178 //Rwanda
		replace cob_`var'=9 if `var'==183 //Niger
		replace cob_`var'=9 if `var'==190 //Djibouti
		replace cob_`var'=9 if `var'==179 //Malawi
		replace cob_`var'=9 if `var'==127 //Côte d'Ivoire
		replace cob_`var'=9 if `var'==147 //Chad
		replace cob_`var'=9 if `var'==131 //Seychelles
		replace cob_`var'=10 if `var'==333 //unspecified
		replace cob_`var'=10 if `var'==444 //unspecified EU
		replace cob_`var'=10 if `var'==999 //Ethnic Minority
		replace cob_`var'=10 if `var'==172 //Caucasus
		replace cob_`var'=10 if `var'==156 //Africa (unspecified)
		replace cob_`var'=10 if `var'==149 //Kurdistan
		replace cob_`var'=10 if `var'==98 //Stateless
	lab val cob_`var' COB
}

rename cob_corigin cob_r
//rename cob_forigin cob_f
//rename cob_morigin cob_m

*fill if german born (respondent)
replace cob_r=0 if germborn==1
replace cob_r=10 if cob_r==. & germborn==2

rename lb0084_h germborn_f
rename lb0085_h germborn_m

/*fill if german-born (parents)
foreach p in f m {
		replace cob_`p'=0 if germborn_`p'==1 //Germany
		replace cob_`p'=10 if cob_`p'==. & germborn_`p'==2 // no cob specified but not born in germany	
}
*/