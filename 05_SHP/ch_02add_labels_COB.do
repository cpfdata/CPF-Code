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

foreach var in nat_1_ p__o20 p__o37 {
	gen cob_`var'=.
		replace cob_`var'=0 if `var'==8100 //Switzerland
		replace cob_`var'=3 if `var'==8201 //Albania
		replace cob_`var'=3 if `var'==8202 //Andorra
		replace cob_`var'=2 if `var'==8204 //Belgium
		replace cob_`var'=3 if `var'==8205 //Bulgaria
		replace cob_`var'=2 if `var'==8206 //Denmark and territories
		replace cob_`var'=2 if `var'==8207 //Germany
		replace cob_`var'=2 if `var'==8211 //Finland
		replace cob_`var'=3 if `var'==8212 //France and territories
		replace cob_`var'=3 if `var'==8214 //Greece
		replace cob_`var'=2 if `var'==8215 //United Kingdom and territories
		replace cob_`var'=2 if `var'==8216 //Ireland
		replace cob_`var'=2 if `var'==8217 //Iceland
		replace cob_`var'=3 if `var'==8218 //Italy
		replace cob_`var'=3 if `var'==8220 //Yugoslavia
		replace cob_`var'=2 if `var'==8222 //Liechtenstein
		replace cob_`var'=2 if `var'==8223 //Luxembourg
		replace cob_`var'=3 if `var'==8224 //Malta
		replace cob_`var'=2 if `var'==8226 //Monaco
		replace cob_`var'=2 if `var'==8227 //Netherlands and territories
		replace cob_`var'=2 if `var'==8228 //Norway and territories
		replace cob_`var'=2 if `var'==8229 //Austria
		replace cob_`var'=3 if `var'==8230 //Poland
		replace cob_`var'=3 if `var'==8231 //Portugal
		replace cob_`var'=3 if `var'==8232 //Romania
		replace cob_`var'=3 if `var'==8233 //San Marino
		replace cob_`var'=2 if `var'==8234 //Sweden
		replace cob_`var'=3 if `var'==8236 //Spain and territories
		replace cob_`var'=4 if `var'==8239 //Turkey
		replace cob_`var'=3 if `var'==8240 //Hungary
		replace cob_`var'=3 if `var'==8241 //Vatican City
		replace cob_`var'=3 if `var'==8242 //Cyprus
		replace cob_`var'=3 if `var'==8243 //Slovakia
		replace cob_`var'=3 if `var'==8244 //Czech Republic
		replace cob_`var'=3 if `var'==8248 //Serbia
		replace cob_`var'=3 if `var'==8249 //Serbia and Montenegro
		replace cob_`var'=3 if `var'==8250 //Croatia
		replace cob_`var'=3 if `var'==8251 //Slovenia
		replace cob_`var'=3 if `var'==8252 //Bosnia and Herzegovina
		replace cob_`var'=3 if `var'==8254 //Montenegro
		replace cob_`var'=3 if `var'==8255 //Macedonia (Ex-Republic of Yugoslavia)
		replace cob_`var'=3 if `var'==8256 //Kosovo
		replace cob_`var'=3 if `var'==8260 //Estonia
		replace cob_`var'=3 if `var'==8261 //Latvia
		replace cob_`var'=3 if `var'==8262 //Lithuania
		replace cob_`var'=3 if `var'==8263 //Moldova
		replace cob_`var'=3 if `var'==8264 //Russia
		replace cob_`var'=3 if `var'==8265 //Ukraine
		replace cob_`var'=3 if `var'==8266 //Belarus
		replace cob_`var'=9 if `var'==8301 //Equatorial Guinea
		replace cob_`var'=9 if `var'==8302 //Ethiopia
		replace cob_`var'=9 if `var'==8303 //Djibouti
		replace cob_`var'=4 if `var'==8304 //Algeria
		replace cob_`var'=9 if `var'==8305 //Angola
		replace cob_`var'=9 if `var'==8307 //Botswana
		replace cob_`var'=9 if `var'==8308 //Burundi
		replace cob_`var'=9 if `var'==8309 //Benin
		replace cob_`var'=9 if `var'==8310 //Ivory Coast
		replace cob_`var'=9 if `var'==8311 //Gabon
		replace cob_`var'=9 if `var'==8312 //Gambia
		replace cob_`var'=9 if `var'==8313 //Ghana
		replace cob_`var'=9 if `var'==8314 //Guinea-Bissau
		replace cob_`var'=9 if `var'==8315 //Guinea
		replace cob_`var'=9 if `var'==8317 //Cameroon
		replace cob_`var'=9 if `var'==8319 //Cape Verde
		replace cob_`var'=9 if `var'==8320 //Kenya
		replace cob_`var'=9 if `var'==8321 //Comoros
		replace cob_`var'=9 if `var'==8322 //Congo (Brazzaville)
		replace cob_`var'=9 if `var'==8323 //Democratic Republic of the Congo
		replace cob_`var'=9 if `var'==8324 //Lesotho
		replace cob_`var'=9 if `var'==8325 //Liberia
		replace cob_`var'=4 if `var'==8326 //Libya
		replace cob_`var'=9 if `var'==8327 //Madagascar
		replace cob_`var'=9 if `var'==8329 //Malawi
		replace cob_`var'=9 if `var'==8330 //Mali
		replace cob_`var'=4 if `var'==8331 //Morocco
		replace cob_`var'=9 if `var'==8332 //Mauritania
		replace cob_`var'=9 if `var'==8333 //Mauritius
		replace cob_`var'=9 if `var'==8334 //Mozambique
		replace cob_`var'=9 if `var'==8335 //Niger
		replace cob_`var'=9 if `var'==8336 //Nigeria
		replace cob_`var'=9 if `var'==8337 //Burkina Faso
		replace cob_`var'=9 if `var'==8340 //Zimbabwe
		replace cob_`var'=9 if `var'==8341 //Rwanda
		replace cob_`var'=9 if `var'==8343 //Zambia
		replace cob_`var'=9 if `var'==8344 //São Tomé and Príncipe
		replace cob_`var'=9 if `var'==8345 //Senegal
		replace cob_`var'=9 if `var'==8346 //Seychelles
		replace cob_`var'=9 if `var'==8347 //Sierra Leone
		replace cob_`var'=9 if `var'==8348 //Somalia
		replace cob_`var'=9 if `var'==8349 //South Africa
		replace cob_`var'=4 if `var'==8350 //Sudan
		replace cob_`var'=9 if `var'==8351 //Namibia
		replace cob_`var'=9 if `var'==8352 //Swaziland
		replace cob_`var'=9 if `var'==8353 //Tanzania
		replace cob_`var'=9 if `var'==8354 //Togo
		replace cob_`var'=9 if `var'==8356 //Chad
		replace cob_`var'=4 if `var'==8357 //Tunisia
		replace cob_`var'=9 if `var'==8358 //Uganda
		replace cob_`var'=4 if `var'==8359 //Egypt
		replace cob_`var'=9 if `var'==8360 //Central African Republic
		replace cob_`var'=9 if `var'==8362 //Eritrea
		replace cob_`var'=4 if `var'==8372 //Western Sahara
		replace cob_`var'=8 if `var'==8401 //Argentina
		replace cob_`var'=8 if `var'==8402 //Bahamas
		replace cob_`var'=8 if `var'==8403 //Barbados
		replace cob_`var'=8 if `var'==8405 //Bolivia
		replace cob_`var'=8 if `var'==8406 //Brazil
		replace cob_`var'=8 if `var'==8407 //Chile
		replace cob_`var'=8 if `var'==8408 //Costa Rica
		replace cob_`var'=8 if `var'==8409 //Dominican Republic
		replace cob_`var'=8 if `var'==8410 //Ecuador
		replace cob_`var'=8 if `var'==8411 //El Salvador
		replace cob_`var'=8 if `var'==8415 //Guatemala
		replace cob_`var'=8 if `var'==8417 //Guyana
		replace cob_`var'=8 if `var'==8418 //Haiti
		replace cob_`var'=8 if `var'==8419 //Belize
		replace cob_`var'=8 if `var'==8420 //Honduras
		replace cob_`var'=8 if `var'==8421 //Jamaica
		replace cob_`var'=8 if `var'==8423 //Canada
		replace cob_`var'=8 if `var'==8424 //Columbia
		replace cob_`var'=8 if `var'==8425 //Cuba
		replace cob_`var'=8 if `var'==8427 //Mexico
		replace cob_`var'=8 if `var'==8429 //Nicaragua
		replace cob_`var'=8 if `var'==8430 //Panama
		replace cob_`var'=8 if `var'==8431 //Paraguay
		replace cob_`var'=8 if `var'==8432 //Peru
		replace cob_`var'=8 if `var'==8435 //Suriname
		replace cob_`var'=8 if `var'==8436 //Trinidad and Tobago
		replace cob_`var'=8 if `var'==8437 //Uruguay
		replace cob_`var'=8 if `var'==8438 //Venezuela
		replace cob_`var'=8 if `var'==8439 //United States and territories
		replace cob_`var'=8 if `var'==8440 //Dominica
		replace cob_`var'=8 if `var'==8441 //Grenada
		replace cob_`var'=8 if `var'==8442 //Antigua and Barbuda
		replace cob_`var'=8 if `var'==8443 //Santa Lucia
		replace cob_`var'=8 if `var'==8444 //Saint Vincent and The Grenadines
		replace cob_`var'=8 if `var'==8445 //St. Kitts and Nevis
		replace cob_`var'=8 if `var'==8472 //US Virgin Islands
		replace cob_`var'=7 if `var'==8501 //Afghanistan
		replace cob_`var'=4 if `var'==8502 //Bahrain
		replace cob_`var'=7 if `var'==8503 //Bhutan
		replace cob_`var'=5 if `var'==8504 //Brunei
		replace cob_`var'=5 if `var'==8505 //Myanmar (Burma)
		replace cob_`var'=7 if `var'==8506 //Sri Lanka
		replace cob_`var'=6 if `var'==8507 //Taiwan
		replace cob_`var'=6 if `var'==8508 //China
		replace cob_`var'=6 if `var'==8509 //Hong Kong
		replace cob_`var'=7 if `var'==8510 //India
		replace cob_`var'=5 if `var'==8511 //Indonesia
		replace cob_`var'=4 if `var'==8512 //Iraq
		replace cob_`var'=4 if `var'==8513 //Iran
		replace cob_`var'=4 if `var'==8514 //Israel
		replace cob_`var'=6 if `var'==8515 //Japan
		replace cob_`var'=4 if `var'==8516 //Yemen
		replace cob_`var'=4 if `var'==8517 //Jordan
		replace cob_`var'=5 if `var'==8518 //Cambodia
		replace cob_`var'=4 if `var'==8519 //Qatar
		replace cob_`var'=4 if `var'==8521 //Kuwait
		replace cob_`var'=5 if `var'==8522 //Laos
		replace cob_`var'=4 if `var'==8523 //Lebanon
		replace cob_`var'=5 if `var'==8525 //Malaysia
		replace cob_`var'=7 if `var'==8526 //Maldives
		replace cob_`var'=4 if `var'==8527 //Oman
		replace cob_`var'=6 if `var'==8528 //Mongolia
		replace cob_`var'=7 if `var'==8529 //Nepal
		replace cob_`var'=6 if `var'==8530 //Korea (North)
		replace cob_`var'=4 if `var'==8532 //United Arab Emirates
		replace cob_`var'=7 if `var'==8533 //Pakistan
		replace cob_`var'=5 if `var'==8534 //Philippines
		replace cob_`var'=4 if `var'==8535 //Saudi Arabia
		replace cob_`var'=5 if `var'==8537 //Singapore
		replace cob_`var'=6 if `var'==8539 //Korea (South) (Republic of Korea)
		replace cob_`var'=4 if `var'==8541 //Syria
		replace cob_`var'=5 if `var'==8542 //Thailand
		replace cob_`var'=6 if `var'==8543 //Tibet
		replace cob_`var'=5 if `var'==8545 //Vietnam
		replace cob_`var'=7 if `var'==8546 //Bangladesh
		replace cob_`var'=4 if `var'==8550 //Palestine
		replace cob_`var'=7 if `var'==8560 //Armenia
		replace cob_`var'=7 if `var'==8561 //Azerbaijan
		replace cob_`var'=7 if `var'==8562 //Georgia
		replace cob_`var'=7 if `var'==8563 //Kazakhstan
		replace cob_`var'=7 if `var'==8564 //Kyrgyzstan
		replace cob_`var'=7 if `var'==8565 //Tajikistan
		replace cob_`var'=7 if `var'==8566 //Turkmenistan
		replace cob_`var'=7 if `var'==8567 //Uzbekistan
		replace cob_`var'=1 if `var'==8601 //Australia and territories
		replace cob_`var'=1 if `var'==8602 //Fiji
		replace cob_`var'=1 if `var'==8604 //Nauru
		replace cob_`var'=1 if `var'==8605 //Vanuatu
		replace cob_`var'=1 if `var'==8607 //New Zealand and territories
		replace cob_`var'=1 if `var'==8608 //Papua New Guinea
		replace cob_`var'=1 if `var'==8610 //Tonga
		replace cob_`var'=1 if `var'==8612 //Samoa
		replace cob_`var'=1 if `var'==8614 //Solomon Islands
		replace cob_`var'=1 if `var'==8615 //Tuvalu
		replace cob_`var'=1 if `var'==8616 //Kiribati
		replace cob_`var'=1 if `var'==8617 //Marshall Islands
		replace cob_`var'=1 if `var'==8618 //Micronesia
		replace cob_`var'=1 if `var'==8621 //American Samoa
		replace cob_`var'=10 if `var'==8998 //with no nationality
	lab val cob_`var' COB
}

// multiple nationalities possible: first mention used
// for cob_r, additional item "birth in Switzerland" can be used as a double check

tab cob_nat_1_ if (cob_nat_1_!=0 & p_d160==1) // identify Swiss-born with non-Swiss first nationality
replace cob_nat_1_=0 if p_d160==1
replace cob_nat_1_=0 if migr==0
replace cob_nat_1_=10 if (cob_nat_1_==. | cob_nat_1_==0) & migr==1

rename cob_nat_1_ cob_rt
rename cob_p__o20 cob_ft
rename cob_p__o37 cob_mt