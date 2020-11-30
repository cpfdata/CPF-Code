**|=========================================================================|
**|	    ####	CPF	####													|
**|		>>>	PSID - create ISCO			 									|
**|=========================================================================|

*** Census 2010 --> isco-08 
*step 1: ASC 2010 --> SOC 2010

*** Waves 2003-2015 have 3-digit coding

foreach var in occupD occupDS  {
gen  `var'_soc=" "
	replace `var'_soc="11-1011" if(`var'==001) & wave>=33 & wave<40
	replace `var'_soc="11-1021" if(`var'==002) & wave>=33 & wave<40
	replace `var'_soc="11-1031" if(`var'==003) & wave>=33 & wave<40
	replace `var'_soc="11-2011" if(`var'==004) & wave>=33 & wave<40
	replace `var'_soc="11-2020" if(`var'==005) & wave>=33 & wave<40
	replace `var'_soc="11-2031" if(`var'==006) & wave>=33 & wave<40
	replace `var'_soc="11-3011" if(`var'==010) & wave>=33 & wave<40
	replace `var'_soc="11-3021" if(`var'==011) & wave>=33 & wave<40
	replace `var'_soc="11-3031" if(`var'==012) & wave>=33 & wave<40
	replace `var'_soc="11-3111" if(`var'==013) & wave>=33 & wave<40
	replace `var'_soc="11-3121" if(`var'==013) & wave>=33 & wave<40
	replace `var'_soc="11-3131" if(`var'==013) & wave>=33 & wave<40
	replace `var'_soc="11-3051" if(`var'==014) & wave>=33 & wave<40
	replace `var'_soc="11-3061" if(`var'==015) & wave>=33 & wave<40
	replace `var'_soc="11-3071" if(`var'==016) & wave>=33 & wave<40
	replace `var'_soc="11-9013" if(`var'==020) & wave>=33 & wave<40
	replace `var'_soc="11-9021" if(`var'==022) & wave>=33 & wave<40
	replace `var'_soc="11-9030" if(`var'==023) & wave>=33 & wave<40
	replace `var'_soc="11-9041" if(`var'==030) & wave>=33 & wave<40
	replace `var'_soc="11-9051" if(`var'==031) & wave>=33 & wave<40
	replace `var'_soc="11-9061" if(`var'==032) & wave>=33 & wave<40
	replace `var'_soc="11-9071" if(`var'==033) & wave>=33 & wave<40
	replace `var'_soc="11-9081" if(`var'==034) & wave>=33 & wave<40
	replace `var'_soc="11-9111" if(`var'==035) & wave>=33 & wave<40
	replace `var'_soc="11-9121" if(`var'==036) & wave>=33 & wave<40
	replace `var'_soc="11-9131" if(`var'==040) & wave>=33 & wave<40
	replace `var'_soc="11-9141" if(`var'==041) & wave>=33 & wave<40
	replace `var'_soc="11-9151" if(`var'==042) & wave>=33 & wave<40
	replace `var'_soc="11-9161" if(`var'==042) & wave>=33 & wave<40
	replace `var'_soc="11-9199" if(`var'==043) & wave>=33 & wave<40
	replace `var'_soc="13-1011" if(`var'==050) & wave>=33 & wave<40
	replace `var'_soc="13-1021" if(`var'==051) & wave>=33 & wave<40
	replace `var'_soc="13-1022" if(`var'==052) & wave>=33 & wave<40
	replace `var'_soc="13-1023" if(`var'==053) & wave>=33 & wave<40
	replace `var'_soc="13-1030" if(`var'==054) & wave>=33 & wave<40
	replace `var'_soc="13-1041" if(`var'==056) & wave>=33 & wave<40
	replace `var'_soc="13-1051" if(`var'==060) & wave>=33 & wave<40
	replace `var'_soc="13-1070" if(`var'==063) & wave>=33 & wave<40
	replace `var'_soc="13-1141" if(`var'==064) & wave>=33 & wave<40
	replace `var'_soc="13-1151" if(`var'==065) & wave>=33 & wave<40
	replace `var'_soc="13-1081" if(`var'==070) & wave>=33 & wave<40
	replace `var'_soc="13-1111" if(`var'==071) & wave>=33 & wave<40
	replace `var'_soc="13-1121" if(`var'==072) & wave>=33 & wave<40
	replace `var'_soc="13-1131" if(`var'==072) & wave>=33 & wave<40
	replace `var'_soc="13-1161" if(`var'==073) & wave>=33 & wave<40
	replace `var'_soc="13-1199" if(`var'==074) & wave>=33 & wave<40
	replace `var'_soc="13-2011" if(`var'==080) & wave>=33 & wave<40
	replace `var'_soc="13-2021" if(`var'==081) & wave>=33 & wave<40
	replace `var'_soc="13-2031" if(`var'==082) & wave>=33 & wave<40
	replace `var'_soc="13-2041" if(`var'==083) & wave>=33 & wave<40
	replace `var'_soc="13-2051" if(`var'==084) & wave>=33 & wave<40
	replace `var'_soc="13-2052" if(`var'==085) & wave>=33 & wave<40
	replace `var'_soc="13-2053" if(`var'==086) & wave>=33 & wave<40
	replace `var'_soc="13-2061" if(`var'==090) & wave>=33 & wave<40
	replace `var'_soc="13-2070" if(`var'==091) & wave>=33 & wave<40
	replace `var'_soc="13-2081" if(`var'==093) & wave>=33 & wave<40
	replace `var'_soc="13-2082" if(`var'==094) & wave>=33 & wave<40
	replace `var'_soc="13-2099" if(`var'==095) & wave>=33 & wave<40
	replace `var'_soc="15-1111" if(`var'==100) & wave>=33 & wave<40
	replace `var'_soc="15-1121" if(`var'==100) & wave>=33 & wave<40
	replace `var'_soc="15-1122" if(`var'==100) & wave>=33 & wave<40
	replace `var'_soc="15-1131" if(`var'==101) & wave>=33 & wave<40
	replace `var'_soc="15-1130" if(`var'==102) & wave>=33 & wave<40
	replace `var'_soc="15-1134" if(`var'==103) & wave>=33 & wave<40
	replace `var'_soc="15-1150" if(`var'==105) & wave>=33 & wave<40
	replace `var'_soc="15-1141" if(`var'==106) & wave>=33 & wave<40
	replace `var'_soc="15-1142" if(`var'==110) & wave>=33 & wave<40
	replace `var'_soc="15-1143" if(`var'==110) & wave>=33 & wave<40
	replace `var'_soc="15-1199" if(`var'==110) & wave>=33 & wave<40
	replace `var'_soc="15-2011" if(`var'==120) & wave>=33 & wave<40
	replace `var'_soc="15-2021" if(`var'==121) & wave>=33 & wave<40
	replace `var'_soc="15-2031" if(`var'==122) & wave>=33 & wave<40
	replace `var'_soc="15-2041" if(`var'==123) & wave>=33 & wave<40
	replace `var'_soc="15-2090" if(`var'==124) & wave>=33 & wave<40
	replace `var'_soc="17-1010" if(`var'==130) & wave>=33 & wave<40
	replace `var'_soc="17-1020" if(`var'==131) & wave>=33 & wave<40
	replace `var'_soc="17-2011" if(`var'==132) & wave>=33 & wave<40
	replace `var'_soc="17-2021" if(`var'==133) & wave>=33 & wave<40
	replace `var'_soc="17-2031" if(`var'==134) & wave>=33 & wave<40
	replace `var'_soc="17-2041" if(`var'==135) & wave>=33 & wave<40
	replace `var'_soc="17-2051" if(`var'==136) & wave>=33 & wave<40
	replace `var'_soc="17-2061" if(`var'==140) & wave>=33 & wave<40
	replace `var'_soc="17-2070" if(`var'==141) & wave>=33 & wave<40
	replace `var'_soc="17-2081" if(`var'==142) & wave>=33 & wave<40
	replace `var'_soc="17-2110" if(`var'==143) & wave>=33 & wave<40
	replace `var'_soc="17-2121" if(`var'==144) & wave>=33 & wave<40
	replace `var'_soc="17-2131" if(`var'==145) & wave>=33 & wave<40
	replace `var'_soc="17-2141" if(`var'==146) & wave>=33 & wave<40
	replace `var'_soc="17-2151" if(`var'==150) & wave>=33 & wave<40
	replace `var'_soc="17-2161" if(`var'==151) & wave>=33 & wave<40
	replace `var'_soc="17-2171" if(`var'==152) & wave>=33 & wave<40
	replace `var'_soc="17-2199" if(`var'==153) & wave>=33 & wave<40
	replace `var'_soc="17-3010" if(`var'==154) & wave>=33 & wave<40
	replace `var'_soc="17-3020" if(`var'==155) & wave>=33 & wave<40
	replace `var'_soc="17-3031" if(`var'==156) & wave>=33 & wave<40
	replace `var'_soc="19-1010" if(`var'==160) & wave>=33 & wave<40
	replace `var'_soc="19-1020" if(`var'==161) & wave>=33 & wave<40
	replace `var'_soc="19-1030" if(`var'==164) & wave>=33 & wave<40
	replace `var'_soc="19-1040" if(`var'==165) & wave>=33 & wave<40
	replace `var'_soc="19-1099" if(`var'==166) & wave>=33 & wave<40
	replace `var'_soc="19-2010" if(`var'==170) & wave>=33 & wave<40
	replace `var'_soc="19-2021" if(`var'==171) & wave>=33 & wave<40
	replace `var'_soc="19-2030" if(`var'==172) & wave>=33 & wave<40
	replace `var'_soc="19-2040" if(`var'==174) & wave>=33 & wave<40
	replace `var'_soc="19-2099" if(`var'==176) & wave>=33 & wave<40
	replace `var'_soc="19-3011" if(`var'==180) & wave>=33 & wave<40
	replace `var'_soc="19-3022" if(`var'==181) & wave>=33 & wave<40
	replace `var'_soc="19-3030" if(`var'==182) & wave>=33 & wave<40
	replace `var'_soc="19-3041" if(`var'==183) & wave>=33 & wave<40
	replace `var'_soc="19-3051" if(`var'==184) & wave>=33 & wave<40
	replace `var'_soc="19-3090" if(`var'==186) & wave>=33 & wave<40
	replace `var'_soc="19-4011" if(`var'==190) & wave>=33 & wave<40
	replace `var'_soc="19-4021" if(`var'==191) & wave>=33 & wave<40
	replace `var'_soc="19-4031" if(`var'==192) & wave>=33 & wave<40
	replace `var'_soc="19-4041" if(`var'==193) & wave>=33 & wave<40
	replace `var'_soc="19-4051" if(`var'==194) & wave>=33 & wave<40
	replace `var'_soc="19-4061" if(`var'==195) & wave>=33 & wave<40
	replace `var'_soc="19-4090" if(`var'==196) & wave>=33 & wave<40
	replace `var'_soc="21-1010" if(`var'==200) & wave>=33 & wave<40
	replace `var'_soc="21-1020" if(`var'==201) & wave>=33 & wave<40
	replace `var'_soc="21-1092" if(`var'==201) & wave>=33 & wave<40
	replace `var'_soc="21-1093" if(`var'==201) & wave>=33 & wave<40
	replace `var'_soc="21-1090" if(`var'==202) & wave>=33 & wave<40
	replace `var'_soc="21-2011" if(`var'==204) & wave>=33 & wave<40
	replace `var'_soc="21-2021" if(`var'==205) & wave>=33 & wave<40
	replace `var'_soc="21-2099" if(`var'==206) & wave>=33 & wave<40
	replace `var'_soc="23-1011" if(`var'==210) & wave>=33 & wave<40
	replace `var'_soc="23-1012" if(`var'==210) & wave>=33 & wave<40
	replace `var'_soc="23-1020" if(`var'==211) & wave>=33 & wave<40
	replace `var'_soc="23-2011" if(`var'==214) & wave>=33 & wave<40
	replace `var'_soc="23-2090" if(`var'==216) & wave>=33 & wave<40
	replace `var'_soc="25-1000" if(`var'==220) & wave>=33 & wave<40
	replace `var'_soc="25-2010" if(`var'==230) & wave>=33 & wave<40
	replace `var'_soc="25-2020" if(`var'==231) & wave>=33 & wave<40
	replace `var'_soc="25-2030" if(`var'==232) & wave>=33 & wave<40
	replace `var'_soc="25-2050" if(`var'==233) & wave>=33 & wave<40
	replace `var'_soc="25-3000" if(`var'==234) & wave>=33 & wave<40
	replace `var'_soc="25-4010" if(`var'==240) & wave>=33 & wave<40
	replace `var'_soc="25-4021" if(`var'==243) & wave>=33 & wave<40
	replace `var'_soc="25-4031" if(`var'==244) & wave>=33 & wave<40
	replace `var'_soc="25-9041" if(`var'==254) & wave>=33 & wave<40
	replace `var'_soc="25-9000" if(`var'==255) & wave>=33 & wave<40
	replace `var'_soc="27-1010" if(`var'==260) & wave>=33 & wave<40
	replace `var'_soc="27-1020" if(`var'==263) & wave>=33 & wave<40
	replace `var'_soc="27-2011" if(`var'==270) & wave>=33 & wave<40
	replace `var'_soc="27-2012" if(`var'==271) & wave>=33 & wave<40
	replace `var'_soc="27-2020" if(`var'==272) & wave>=33 & wave<40
	replace `var'_soc="27-2030" if(`var'==274) & wave>=33 & wave<40
	replace `var'_soc="27-2040" if(`var'==275) & wave>=33 & wave<40
	replace `var'_soc="27-2099" if(`var'==276) & wave>=33 & wave<40
	replace `var'_soc="27-3010" if(`var'==280) & wave>=33 & wave<40
	replace `var'_soc="27-3020" if(`var'==281) & wave>=33 & wave<40
	replace `var'_soc="27-3031" if(`var'==282) & wave>=33 & wave<40
	replace `var'_soc="27-3041" if(`var'==283) & wave>=33 & wave<40
	replace `var'_soc="27-3042" if(`var'==284) & wave>=33 & wave<40
	replace `var'_soc="27-3043" if(`var'==285) & wave>=33 & wave<40
	replace `var'_soc="27-3090" if(`var'==286) & wave>=33 & wave<40
	replace `var'_soc="27-4010" if(`var'==290) & wave>=33 & wave<40
	replace `var'_soc="27-4021" if(`var'==291) & wave>=33 & wave<40
	replace `var'_soc="27-4030" if(`var'==292) & wave>=33 & wave<40
	replace `var'_soc="27-4099" if(`var'==296) & wave>=33 & wave<40
	replace `var'_soc="29-1011" if(`var'==300) & wave>=33 & wave<40
	replace `var'_soc="29-1020" if(`var'==301) & wave>=33 & wave<40
	replace `var'_soc="29-1031" if(`var'==303) & wave>=33 & wave<40
	replace `var'_soc="29-1041" if(`var'==304) & wave>=33 & wave<40
	replace `var'_soc="29-1051" if(`var'==305) & wave>=33 & wave<40
	replace `var'_soc="29-1060" if(`var'==306) & wave>=33 & wave<40
	replace `var'_soc="29-1071" if(`var'==311) & wave>=33 & wave<40
	replace `var'_soc="29-1081" if(`var'==312) & wave>=33 & wave<40
	replace `var'_soc="29-1181" if(`var'==314) & wave>=33 & wave<40
	replace `var'_soc="29-1122" if(`var'==315) & wave>=33 & wave<40
	replace `var'_soc="29-1123" if(`var'==316) & wave>=33 & wave<40
	replace `var'_soc="29-1124" if(`var'==320) & wave>=33 & wave<40
	replace `var'_soc="29-1125" if(`var'==321) & wave>=33 & wave<40
	replace `var'_soc="29-1126" if(`var'==322) & wave>=33 & wave<40
	replace `var'_soc="29-1127" if(`var'==323) & wave>=33 & wave<40
	replace `var'_soc="29-1128" if(`var'==323) & wave>=33 & wave<40
	replace `var'_soc="29-1129" if(`var'==324) & wave>=33 & wave<40
	replace `var'_soc="29-1131" if(`var'==325) & wave>=33 & wave<40
	replace `var'_soc="29-1141" if(`var'==325) & wave>=33 & wave<40
	replace `var'_soc="29-1151" if(`var'==325) & wave>=33 & wave<40
	replace `var'_soc="29-1161" if(`var'==325) & wave>=33 & wave<40
	replace `var'_soc="29-1171" if(`var'==325) & wave>=33 & wave<40
	replace `var'_soc="29-1199" if(`var'==326) & wave>=33 & wave<40
	replace `var'_soc="29-2010" if(`var'==330) & wave>=33 & wave<40
	replace `var'_soc="29-2021" if(`var'==331) & wave>=33 & wave<40
	replace `var'_soc="29-2030" if(`var'==332) & wave>=33 & wave<40
	replace `var'_soc="29-2041" if(`var'==340) & wave>=33 & wave<40
	replace `var'_soc="29-2050" if(`var'==342) & wave>=33 & wave<40
	replace `var'_soc="29-2061" if(`var'==350) & wave>=33 & wave<40
	replace `var'_soc="29-2071" if(`var'==351) & wave>=33 & wave<40
	replace `var'_soc="29-2081" if(`var'==352) & wave>=33 & wave<40
	replace `var'_soc="29-2090" if(`var'==353) & wave>=33 & wave<40
	replace `var'_soc="29-9000" if(`var'==354) & wave>=33 & wave<40
	replace `var'_soc="31-1010" if(`var'==360) & wave>=33 & wave<40
	replace `var'_soc="31-2010" if(`var'==361) & wave>=33 & wave<40
	replace `var'_soc="31-2020" if(`var'==362) & wave>=33 & wave<40
	replace `var'_soc="31-9011" if(`var'==363) & wave>=33 & wave<40
	replace `var'_soc="31-9091" if(`var'==364) & wave>=33 & wave<40
	replace `var'_soc="31-9092" if(`var'==364) & wave>=33 & wave<40
	replace `var'_soc="31-9094" if(`var'==364) & wave>=33 & wave<40
	replace `var'_soc="31-9095" if(`var'==364) & wave>=33 & wave<40
	replace `var'_soc="31-9096" if(`var'==364) & wave>=33 & wave<40
	replace `var'_soc="31-9097" if(`var'==364) & wave>=33 & wave<40
	replace `var'_soc="31-9090" if(`var'==365) & wave>=33 & wave<40
	replace `var'_soc="33-1011" if(`var'==370) & wave>=33 & wave<40
	replace `var'_soc="33-1012" if(`var'==371) & wave>=33 & wave<40
	replace `var'_soc="33-1021" if(`var'==372) & wave>=33 & wave<40
	replace `var'_soc="33-1099" if(`var'==373) & wave>=33 & wave<40
	replace `var'_soc="33-2011" if(`var'==374) & wave>=33 & wave<40
	replace `var'_soc="33-2020" if(`var'==375) & wave>=33 & wave<40
	replace `var'_soc="33-3010" if(`var'==380) & wave>=33 & wave<40
	replace `var'_soc="33-3021" if(`var'==382) & wave>=33 & wave<40
	replace `var'_soc="33-3031" if(`var'==383) & wave>=33 & wave<40
	replace `var'_soc="33-3041" if(`var'==384) & wave>=33 & wave<40
	replace `var'_soc="33-3051" if(`var'==385) & wave>=33 & wave<40
	replace `var'_soc="33-3052" if(`var'==386) & wave>=33 & wave<40
	replace `var'_soc="33-9011" if(`var'==390) & wave>=33 & wave<40
	replace `var'_soc="33-9021" if(`var'==391) & wave>=33 & wave<40
	replace `var'_soc="33-9030" if(`var'==393) & wave>=33 & wave<40
	replace `var'_soc="33-9091" if(`var'==394) & wave>=33 & wave<40
	replace `var'_soc="33-9093" if(`var'==394) & wave>=33 & wave<40
	replace `var'_soc="33-9090" if(`var'==395) & wave>=33 & wave<40
	replace `var'_soc="35-1011" if(`var'==400) & wave>=33 & wave<40
	replace `var'_soc="35-1012" if(`var'==401) & wave>=33 & wave<40
	replace `var'_soc="35-2010" if(`var'==402) & wave>=33 & wave<40
	replace `var'_soc="35-2021" if(`var'==403) & wave>=33 & wave<40
	replace `var'_soc="35-3011" if(`var'==404) & wave>=33 & wave<40
	replace `var'_soc="35-3021" if(`var'==405) & wave>=33 & wave<40
	replace `var'_soc="35-3022" if(`var'==406) & wave>=33 & wave<40
	replace `var'_soc="35-3031" if(`var'==411) & wave>=33 & wave<40
	replace `var'_soc="35-3041" if(`var'==412) & wave>=33 & wave<40
	replace `var'_soc="35-9011" if(`var'==413) & wave>=33 & wave<40
	replace `var'_soc="35-9021" if(`var'==414) & wave>=33 & wave<40
	replace `var'_soc="35-9031" if(`var'==415) & wave>=33 & wave<40
	replace `var'_soc="35-9099" if(`var'==416) & wave>=33 & wave<40
	replace `var'_soc="37-1011" if(`var'==420) & wave>=33 & wave<40
	replace `var'_soc="37-1012" if(`var'==421) & wave>=33 & wave<40
	replace `var'_soc="37-2010" if(`var'==422) & wave>=33 & wave<40
	replace `var'_soc="37-2012" if(`var'==423) & wave>=33 & wave<40
	replace `var'_soc="37-2021" if(`var'==424) & wave>=33 & wave<40
	replace `var'_soc="37-3010" if(`var'==425) & wave>=33 & wave<40
	replace `var'_soc="39-1010" if(`var'==430) & wave>=33 & wave<40
	replace `var'_soc="39-1021" if(`var'==432) & wave>=33 & wave<40
	replace `var'_soc="39-2011" if(`var'==434) & wave>=33 & wave<40
	replace `var'_soc="39-2021" if(`var'==435) & wave>=33 & wave<40
	replace `var'_soc="39-3010" if(`var'==440) & wave>=33 & wave<40
	replace `var'_soc="39-3021" if(`var'==441) & wave>=33 & wave<40
	replace `var'_soc="39-3031" if(`var'==442) & wave>=33 & wave<40
	replace `var'_soc="39-3090" if(`var'==443) & wave>=33 & wave<40
	replace `var'_soc="39-4000" if(`var'==446) & wave>=33 & wave<40
	replace `var'_soc="39-4031" if(`var'==446) & wave>=33 & wave<40
	replace `var'_soc="39-5011" if(`var'==450) & wave>=33 & wave<40
	replace `var'_soc="39-5012" if(`var'==451) & wave>=33 & wave<40
	replace `var'_soc="39-5090" if(`var'==452) & wave>=33 & wave<40
	replace `var'_soc="39-6010" if(`var'==453) & wave>=33 & wave<40
	replace `var'_soc="39-7010" if(`var'==454) & wave>=33 & wave<40
	replace `var'_soc="39-9011" if(`var'==460) & wave>=33 & wave<40
	replace `var'_soc="39-9021" if(`var'==461) & wave>=33 & wave<40
	replace `var'_soc="39-9030" if(`var'==462) & wave>=33 & wave<40
	replace `var'_soc="39-9041" if(`var'==464) & wave>=33 & wave<40
	replace `var'_soc="39-9099" if(`var'==465) & wave>=33 & wave<40
	replace `var'_soc="41-1011" if(`var'==470) & wave>=33 & wave<40
	replace `var'_soc="41-1012" if(`var'==471) & wave>=33 & wave<40
	replace `var'_soc="41-2010" if(`var'==472) & wave>=33 & wave<40
	replace `var'_soc="41-2021" if(`var'==474) & wave>=33 & wave<40
	replace `var'_soc="41-2022" if(`var'==475) & wave>=33 & wave<40
	replace `var'_soc="41-2031" if(`var'==476) & wave>=33 & wave<40
	replace `var'_soc="41-3011" if(`var'==480) & wave>=33 & wave<40
	replace `var'_soc="41-3021" if(`var'==481) & wave>=33 & wave<40
	replace `var'_soc="41-3031" if(`var'==482) & wave>=33 & wave<40
	replace `var'_soc="41-3041" if(`var'==483) & wave>=33 & wave<40
	replace `var'_soc="41-3099" if(`var'==484) & wave>=33 & wave<40
	replace `var'_soc="41-4010" if(`var'==485) & wave>=33 & wave<40
	replace `var'_soc="41-9010" if(`var'==490) & wave>=33 & wave<40
	replace `var'_soc="41-9020" if(`var'==492) & wave>=33 & wave<40
	replace `var'_soc="41-9031" if(`var'==493) & wave>=33 & wave<40
	replace `var'_soc="41-9041" if(`var'==494) & wave>=33 & wave<40
	replace `var'_soc="41-9091" if(`var'==495) & wave>=33 & wave<40
	replace `var'_soc="41-9099" if(`var'==496) & wave>=33 & wave<40
	replace `var'_soc="43-1011" if(`var'==500) & wave>=33 & wave<40
	replace `var'_soc="43-2011" if(`var'==501) & wave>=33 & wave<40
	replace `var'_soc="43-2021" if(`var'==502) & wave>=33 & wave<40
	replace `var'_soc="43-2099" if(`var'==503) & wave>=33 & wave<40
	replace `var'_soc="43-3011" if(`var'==510) & wave>=33 & wave<40
	replace `var'_soc="43-3021" if(`var'==511) & wave>=33 & wave<40
	replace `var'_soc="43-3031" if(`var'==512) & wave>=33 & wave<40
	replace `var'_soc="43-3041" if(`var'==513) & wave>=33 & wave<40
	replace `var'_soc="43-3051" if(`var'==514) & wave>=33 & wave<40
	replace `var'_soc="43-3061" if(`var'==515) & wave>=33 & wave<40
	replace `var'_soc="43-3071" if(`var'==516) & wave>=33 & wave<40
	replace `var'_soc="43-3099" if(`var'==516) & wave>=33 & wave<40
	replace `var'_soc="43-4011" if(`var'==520) & wave>=33 & wave<40
	replace `var'_soc="43-4021" if(`var'==521) & wave>=33 & wave<40
	replace `var'_soc="43-4031" if(`var'==522) & wave>=33 & wave<40
	replace `var'_soc="43-4041" if(`var'==523) & wave>=33 & wave<40
	replace `var'_soc="43-4051" if(`var'==524) & wave>=33 & wave<40
	replace `var'_soc="43-4061" if(`var'==525) & wave>=33 & wave<40
	replace `var'_soc="43-4071" if(`var'==526) & wave>=33 & wave<40
	replace `var'_soc="43-4081" if(`var'==530) & wave>=33 & wave<40
	replace `var'_soc="43-4111" if(`var'==531) & wave>=33 & wave<40
	replace `var'_soc="43-4121" if(`var'==532) & wave>=33 & wave<40
	replace `var'_soc="43-4131" if(`var'==533) & wave>=33 & wave<40
	replace `var'_soc="43-4141" if(`var'==534) & wave>=33 & wave<40
	replace `var'_soc="43-4151" if(`var'==535) & wave>=33 & wave<40
	replace `var'_soc="43-4161" if(`var'==536) & wave>=33 & wave<40
	replace `var'_soc="43-4171" if(`var'==540) & wave>=33 & wave<40
	replace `var'_soc="43-4181" if(`var'==541) & wave>=33 & wave<40
	replace `var'_soc="43-4199" if(`var'==542) & wave>=33 & wave<40
	replace `var'_soc="43-5011" if(`var'==550) & wave>=33 & wave<40
	replace `var'_soc="43-5021" if(`var'==551) & wave>=33 & wave<40
	replace `var'_soc="43-5030" if(`var'==552) & wave>=33 & wave<40
	replace `var'_soc="43-5041" if(`var'==553) & wave>=33 & wave<40
	replace `var'_soc="43-5051" if(`var'==554) & wave>=33 & wave<40
	replace `var'_soc="43-5052" if(`var'==555) & wave>=33 & wave<40
	replace `var'_soc="43-5053" if(`var'==556) & wave>=33 & wave<40
	replace `var'_soc="43-5061" if(`var'==560) & wave>=33 & wave<40
	replace `var'_soc="43-5071" if(`var'==561) & wave>=33 & wave<40
	replace `var'_soc="43-5081" if(`var'==562) & wave>=33 & wave<40
	replace `var'_soc="43-5111" if(`var'==563) & wave>=33 & wave<40
	replace `var'_soc="43-6010" if(`var'==570) & wave>=33 & wave<40
	replace `var'_soc="43-9011" if(`var'==580) & wave>=33 & wave<40
	replace `var'_soc="43-9021" if(`var'==581) & wave>=33 & wave<40
	replace `var'_soc="43-9022" if(`var'==582) & wave>=33 & wave<40
	replace `var'_soc="43-9031" if(`var'==583) & wave>=33 & wave<40
	replace `var'_soc="43-9041" if(`var'==584) & wave>=33 & wave<40
	replace `var'_soc="43-9051" if(`var'==585) & wave>=33 & wave<40
	replace `var'_soc="43-9061" if(`var'==586) & wave>=33 & wave<40
	replace `var'_soc="43-9071" if(`var'==590) & wave>=33 & wave<40
	replace `var'_soc="43-9081" if(`var'==591) & wave>=33 & wave<40
	replace `var'_soc="43-9111" if(`var'==592) & wave>=33 & wave<40
	replace `var'_soc="43-9199" if(`var'==594) & wave>=33 & wave<40
	replace `var'_soc="45-1011" if(`var'==600) & wave>=33 & wave<40
	replace `var'_soc="45-2011" if(`var'==601) & wave>=33 & wave<40
	replace `var'_soc="45-2021" if(`var'==602) & wave>=33 & wave<40
	replace `var'_soc="45-2041" if(`var'==604) & wave>=33 & wave<40
	replace `var'_soc="45-2090" if(`var'==605) & wave>=33 & wave<40
	replace `var'_soc="45-3011" if(`var'==610) & wave>=33 & wave<40
	replace `var'_soc="45-3021" if(`var'==611) & wave>=33 & wave<40
	replace `var'_soc="45-4011" if(`var'==612) & wave>=33 & wave<40
	replace `var'_soc="45-4020" if(`var'==613) & wave>=33 & wave<40
	replace `var'_soc="47-1011" if(`var'==620) & wave>=33 & wave<40
	replace `var'_soc="47-2011" if(`var'==621) & wave>=33 & wave<40
	replace `var'_soc="47-2020" if(`var'==622) & wave>=33 & wave<40
	replace `var'_soc="47-2031" if(`var'==623) & wave>=33 & wave<40
	replace `var'_soc="47-2040" if(`var'==624) & wave>=33 & wave<40
	replace `var'_soc="47-2050" if(`var'==625) & wave>=33 & wave<40
	replace `var'_soc="47-2061" if(`var'==626) & wave>=33 & wave<40
	replace `var'_soc="47-2071" if(`var'==630) & wave>=33 & wave<40
	replace `var'_soc="47-2072" if(`var'==631) & wave>=33 & wave<40
	replace `var'_soc="47-2073" if(`var'==632) & wave>=33 & wave<40
	replace `var'_soc="47-2080" if(`var'==633) & wave>=33 & wave<40
	replace `var'_soc="47-2111" if(`var'==635) & wave>=33 & wave<40
	replace `var'_soc="47-2121" if(`var'==636) & wave>=33 & wave<40
	replace `var'_soc="47-2130" if(`var'==640) & wave>=33 & wave<40
	replace `var'_soc="47-2141" if(`var'==642) & wave>=33 & wave<40
	replace `var'_soc="47-2142" if(`var'==643) & wave>=33 & wave<40
	replace `var'_soc="47-2150" if(`var'==644) & wave>=33 & wave<40
	replace `var'_soc="47-2161" if(`var'==646) & wave>=33 & wave<40
	replace `var'_soc="47-2171" if(`var'==650) & wave>=33 & wave<40
	replace `var'_soc="47-2181" if(`var'==651) & wave>=33 & wave<40
	replace `var'_soc="47-2211" if(`var'==652) & wave>=33 & wave<40
	replace `var'_soc="47-2221" if(`var'==653) & wave>=33 & wave<40
	replace `var'_soc="47-2231" if(`var'==654) & wave>=33 & wave<40
	replace `var'_soc="47-3010" if(`var'==660) & wave>=33 & wave<40
	replace `var'_soc="47-4011" if(`var'==666) & wave>=33 & wave<40
	replace `var'_soc="47-4021" if(`var'==670) & wave>=33 & wave<40
	replace `var'_soc="47-4031" if(`var'==671) & wave>=33 & wave<40
	replace `var'_soc="47-4041" if(`var'==672) & wave>=33 & wave<40
	replace `var'_soc="47-4051" if(`var'==673) & wave>=33 & wave<40
	replace `var'_soc="47-4061" if(`var'==674) & wave>=33 & wave<40
	replace `var'_soc="47-4071" if(`var'==675) & wave>=33 & wave<40
	replace `var'_soc="47-4090" if(`var'==676) & wave>=33 & wave<40
	replace `var'_soc="47-5010" if(`var'==680) & wave>=33 & wave<40
	replace `var'_soc="47-5021" if(`var'==682) & wave>=33 & wave<40
	replace `var'_soc="47-5031" if(`var'==683) & wave>=33 & wave<40
	replace `var'_soc="47-5040" if(`var'==684) & wave>=33 & wave<40
	replace `var'_soc="47-5061" if(`var'==691) & wave>=33 & wave<40
	replace `var'_soc="47-5071" if(`var'==692) & wave>=33 & wave<40
	replace `var'_soc="47-5081" if(`var'==693) & wave>=33 & wave<40
	replace `var'_soc="47-5000" if(`var'==694) & wave>=33 & wave<40
	replace `var'_soc="49-1011" if(`var'==700) & wave>=33 & wave<40
	replace `var'_soc="49-2011" if(`var'==701) & wave>=33 & wave<40
	replace `var'_soc="49-2020" if(`var'==702) & wave>=33 & wave<40
	replace `var'_soc="49-2091" if(`var'==703) & wave>=33 & wave<40
	replace `var'_soc="49-2092" if(`var'==704) & wave>=33 & wave<40
	replace `var'_soc="49-2093" if(`var'==705) & wave>=33 & wave<40
	replace `var'_soc="49-2090" if(`var'==710) & wave>=33 & wave<40
	replace `var'_soc="49-2096" if(`var'==711) & wave>=33 & wave<40
	replace `var'_soc="49-2097" if(`var'==712) & wave>=33 & wave<40
	replace `var'_soc="49-2098" if(`var'==713) & wave>=33 & wave<40
	replace `var'_soc="49-3011" if(`var'==714) & wave>=33 & wave<40
	replace `var'_soc="49-3021" if(`var'==715) & wave>=33 & wave<40
	replace `var'_soc="49-3022" if(`var'==716) & wave>=33 & wave<40
	replace `var'_soc="49-3023" if(`var'==720) & wave>=33 & wave<40
	replace `var'_soc="49-3031" if(`var'==721) & wave>=33 & wave<40
	replace `var'_soc="49-3040" if(`var'==722) & wave>=33 & wave<40
	replace `var'_soc="49-3050" if(`var'==724) & wave>=33 & wave<40
	replace `var'_soc="49-3090" if(`var'==726) & wave>=33 & wave<40
	replace `var'_soc="49-9010" if(`var'==730) & wave>=33 & wave<40
	replace `var'_soc="49-9021" if(`var'==731) & wave>=33 & wave<40
	replace `var'_soc="49-9031" if(`var'==732) & wave>=33 & wave<40
	replace `var'_soc="49-9040" if(`var'==733) & wave>=33 & wave<40
	replace `var'_soc="49-9071" if(`var'==734) & wave>=33 & wave<40
	replace `var'_soc="49-9043" if(`var'==735) & wave>=33 & wave<40
	replace `var'_soc="49-9044" if(`var'==736) & wave>=33 & wave<40
	replace `var'_soc="49-9051" if(`var'==741) & wave>=33 & wave<40
	replace `var'_soc="49-9052" if(`var'==742) & wave>=33 & wave<40
	replace `var'_soc="49-9060" if(`var'==743) & wave>=33 & wave<40
	replace `var'_soc="49-9081" if(`var'==744) & wave>=33 & wave<40
	replace `var'_soc="49-9091" if(`var'==751) & wave>=33 & wave<40
	replace `var'_soc="49-9092" if(`var'==752) & wave>=33 & wave<40
	replace `var'_soc="49-9094" if(`var'==754) & wave>=33 & wave<40
	replace `var'_soc="49-9095" if(`var'==755) & wave>=33 & wave<40
	replace `var'_soc="49-9096" if(`var'==756) & wave>=33 & wave<40
	replace `var'_soc="49-9097" if(`var'==760) & wave>=33 & wave<40
	replace `var'_soc="49-9098" if(`var'==761) & wave>=33 & wave<40
	replace `var'_soc="49-9090" if(`var'==763) & wave>=33 & wave<40
	replace `var'_soc="51-1011" if(`var'==770) & wave>=33 & wave<40
	replace `var'_soc="51-2011" if(`var'==771) & wave>=33 & wave<40
	replace `var'_soc="51-2020" if(`var'==772) & wave>=33 & wave<40
	replace `var'_soc="51-2031" if(`var'==773) & wave>=33 & wave<40
	replace `var'_soc="51-2041" if(`var'==774) & wave>=33 & wave<40
	replace `var'_soc="51-2090" if(`var'==775) & wave>=33 & wave<40
	replace `var'_soc="51-3011" if(`var'==780) & wave>=33 & wave<40
	replace `var'_soc="51-3020" if(`var'==781) & wave>=33 & wave<40
	replace `var'_soc="51-3091" if(`var'==783) & wave>=33 & wave<40
	replace `var'_soc="51-3092" if(`var'==784) & wave>=33 & wave<40
	replace `var'_soc="51-3093" if(`var'==785) & wave>=33 & wave<40
	replace `var'_soc="51-3099" if(`var'==785) & wave>=33 & wave<40
	replace `var'_soc="51-4010" if(`var'==790) & wave>=33 & wave<40
	replace `var'_soc="51-4021" if(`var'==792) & wave>=33 & wave<40
	replace `var'_soc="51-4022" if(`var'==793) & wave>=33 & wave<40
	replace `var'_soc="51-4023" if(`var'==794) & wave>=33 & wave<40
	replace `var'_soc="51-4031" if(`var'==795) & wave>=33 & wave<40
	replace `var'_soc="51-4032" if(`var'==796) & wave>=33 & wave<40
	replace `var'_soc="51-4033" if(`var'==800) & wave>=33 & wave<40
	replace `var'_soc="51-4034" if(`var'==801) & wave>=33 & wave<40
	replace `var'_soc="51-4035" if(`var'==802) & wave>=33 & wave<40
	replace `var'_soc="51-4041" if(`var'==803) & wave>=33 & wave<40
	replace `var'_soc="51-4050" if(`var'==804) & wave>=33 & wave<40
	replace `var'_soc="51-4060" if(`var'==806) & wave>=33 & wave<40
	replace `var'_soc="51-4070" if(`var'==810) & wave>=33 & wave<40
	replace `var'_soc="51-4081" if(`var'==812) & wave>=33 & wave<40
	replace `var'_soc="51-4111" if(`var'==813) & wave>=33 & wave<40
	replace `var'_soc="51-4120" if(`var'==814) & wave>=33 & wave<40
	replace `var'_soc="51-4191" if(`var'==815) & wave>=33 & wave<40
	replace `var'_soc="51-4192" if(`var'==816) & wave>=33 & wave<40
	replace `var'_soc="51-4193" if(`var'==820) & wave>=33 & wave<40
	replace `var'_soc="51-4194" if(`var'==821) & wave>=33 & wave<40
	replace `var'_soc="51-4199" if(`var'==822) & wave>=33 & wave<40
	replace `var'_soc="51-5111" if(`var'==825) & wave>=33 & wave<40
	replace `var'_soc="51-5112" if(`var'==825) & wave>=33 & wave<40
	replace `var'_soc="51-5113" if(`var'==825) & wave>=33 & wave<40
	replace `var'_soc="51-6011" if(`var'==830) & wave>=33 & wave<40
	replace `var'_soc="51-6021" if(`var'==831) & wave>=33 & wave<40
	replace `var'_soc="51-6031" if(`var'==832) & wave>=33 & wave<40
	replace `var'_soc="51-6041" if(`var'==833) & wave>=33 & wave<40
	replace `var'_soc="51-6042" if(`var'==834) & wave>=33 & wave<40
	replace `var'_soc="51-6050" if(`var'==835) & wave>=33 & wave<40
	replace `var'_soc="51-6061" if(`var'==836) & wave>=33 & wave<40
	replace `var'_soc="51-6062" if(`var'==840) & wave>=33 & wave<40
	replace `var'_soc="51-6063" if(`var'==841) & wave>=33 & wave<40
	replace `var'_soc="51-6064" if(`var'==842) & wave>=33 & wave<40
	replace `var'_soc="51-6091" if(`var'==843) & wave>=33 & wave<40
	replace `var'_soc="51-6092" if(`var'==844) & wave>=33 & wave<40
	replace `var'_soc="51-6093" if(`var'==845) & wave>=33 & wave<40
	replace `var'_soc="51-6099" if(`var'==846) & wave>=33 & wave<40
	replace `var'_soc="51-7011" if(`var'==850) & wave>=33 & wave<40
	replace `var'_soc="51-7021" if(`var'==851) & wave>=33 & wave<40
	replace `var'_soc="51-7030" if(`var'==852) & wave>=33 & wave<40
	replace `var'_soc="51-7041" if(`var'==853) & wave>=33 & wave<40
	replace `var'_soc="51-7042" if(`var'==854) & wave>=33 & wave<40
	replace `var'_soc="51-7099" if(`var'==855) & wave>=33 & wave<40
	replace `var'_soc="51-8010" if(`var'==860) & wave>=33 & wave<40
	replace `var'_soc="51-8021" if(`var'==861) & wave>=33 & wave<40
	replace `var'_soc="51-8031" if(`var'==862) & wave>=33 & wave<40
	replace `var'_soc="51-8090" if(`var'==863) & wave>=33 & wave<40
	replace `var'_soc="51-9010" if(`var'==864) & wave>=33 & wave<40
	replace `var'_soc="51-9020" if(`var'==865) & wave>=33 & wave<40
	replace `var'_soc="51-9030" if(`var'==871) & wave>=33 & wave<40
	replace `var'_soc="51-9041" if(`var'==872) & wave>=33 & wave<40
	replace `var'_soc="51-9051" if(`var'==873) & wave>=33 & wave<40
	replace `var'_soc="51-9061" if(`var'==874) & wave>=33 & wave<40
	replace `var'_soc="51-9071" if(`var'==875) & wave>=33 & wave<40
	replace `var'_soc="51-9080" if(`var'==876) & wave>=33 & wave<40
	replace `var'_soc="51-9111" if(`var'==880) & wave>=33 & wave<40
	replace `var'_soc="51-9120" if(`var'==881) & wave>=33 & wave<40
	replace `var'_soc="51-9151" if(`var'==883) & wave>=33 & wave<40
	replace `var'_soc="51-9141" if(`var'==884) & wave>=33 & wave<40
	replace `var'_soc="51-9191" if(`var'==885) & wave>=33 & wave<40
	replace `var'_soc="51-9192" if(`var'==886) & wave>=33 & wave<40
	replace `var'_soc="51-9193" if(`var'==890) & wave>=33 & wave<40
	replace `var'_soc="51-9194" if(`var'==891) & wave>=33 & wave<40
	replace `var'_soc="51-9195" if(`var'==892) & wave>=33 & wave<40
	replace `var'_soc="51-9196" if(`var'==893) & wave>=33 & wave<40
	replace `var'_soc="51-9197" if(`var'==894) & wave>=33 & wave<40
	replace `var'_soc="51-9198" if(`var'==895) & wave>=33 & wave<40
	replace `var'_soc="51-9199" if(`var'==896) & wave>=33 & wave<40
	replace `var'_soc="53-1000" if(`var'==900) & wave>=33 & wave<40
	replace `var'_soc="53-2010" if(`var'==903) & wave>=33 & wave<40
	replace `var'_soc="53-2020" if(`var'==904) & wave>=33 & wave<40
	replace `var'_soc="53-2031" if(`var'==905) & wave>=33 & wave<40
	replace `var'_soc="53-3011" if(`var'==911) & wave>=33 & wave<40
	replace `var'_soc="53-3020" if(`var'==912) & wave>=33 & wave<40
	replace `var'_soc="53-3030" if(`var'==913) & wave>=33 & wave<40
	replace `var'_soc="53-3041" if(`var'==914) & wave>=33 & wave<40
	replace `var'_soc="53-3099" if(`var'==915) & wave>=33 & wave<40
	replace `var'_soc="53-4010" if(`var'==920) & wave>=33 & wave<40
	replace `var'_soc="53-4021" if(`var'==923) & wave>=33 & wave<40
	replace `var'_soc="53-4031" if(`var'==924) & wave>=33 & wave<40
	replace `var'_soc="53-4000" if(`var'==926) & wave>=33 & wave<40
	replace `var'_soc="53-5011" if(`var'==930) & wave>=33 & wave<40
	replace `var'_soc="53-5020" if(`var'==931) & wave>=33 & wave<40
	replace `var'_soc="53-5031" if(`var'==933) & wave>=33 & wave<40
	replace `var'_soc="53-6011" if(`var'==934) & wave>=33 & wave<40
	replace `var'_soc="53-6021" if(`var'==935) & wave>=33 & wave<40
	replace `var'_soc="53-6031" if(`var'==936) & wave>=33 & wave<40
	replace `var'_soc="53-6051" if(`var'==941) & wave>=33 & wave<40
	replace `var'_soc="53-6061" if(`var'==941) & wave>=33 & wave<40
	replace `var'_soc="53-6000" if(`var'==942) & wave>=33 & wave<40
	replace `var'_soc="53-7011" if(`var'==950) & wave>=33 & wave<40
	replace `var'_soc="53-7021" if(`var'==951) & wave>=33 & wave<40
	replace `var'_soc="53-7030" if(`var'==952) & wave>=33 & wave<40
	replace `var'_soc="53-7041" if(`var'==956) & wave>=33 & wave<40
	replace `var'_soc="53-7051" if(`var'==960) & wave>=33 & wave<40
	replace `var'_soc="53-7061" if(`var'==961) & wave>=33 & wave<40
	replace `var'_soc="53-7062" if(`var'==962) & wave>=33 & wave<40
	replace `var'_soc="53-7063" if(`var'==963) & wave>=33 & wave<40
	replace `var'_soc="53-7064" if(`var'==964) & wave>=33 & wave<40
	replace `var'_soc="53-7070" if(`var'==965) & wave>=33 & wave<40
	replace `var'_soc="53-7081" if(`var'==972) & wave>=33 & wave<40
	replace `var'_soc="53-7111" if(`var'==973) & wave>=33 & wave<40
	replace `var'_soc="53-7121" if(`var'==974) & wave>=33 & wave<40
	replace `var'_soc="53-7199" if(`var'==975) & wave>=33 & wave<40
	replace `var'_soc="55-1010" if(`var'==980) & wave>=33 & wave<40
	replace `var'_soc="55-2010" if(`var'==981) & wave>=33 & wave<40
	replace `var'_soc="55-3010" if(`var'==982) & wave>=33 & wave<40
	replace `var'_soc="55-0000" if(`var'==983) & wave>=33 & wave<40 // added (Armed Forces) & wave>=33 & wave<40
	replace `var'_soc="-1"		if(`var'==999) & wave>=33 & wave<40 // added
	replace `var'_soc="-3"		if(`var'==0)   & wave>=33 & wave<40 	// added
	*replace `var'_soc="11-0000"	if(`var'>0 & `var'<10) 	// added
	replace `var'_soc="11-0000" if(`var'==021) & wave>=33 & wave<40
	replace `var'_soc="11-0000" if(`var'==025) & wave>=33 & wave<40
	replace `var'_soc="11-0000" if(`var'==029) & wave>=33 & wave<40
	replace `var'_soc="13-0000" if(`var'==062) & wave>=33 & wave<40
	replace `var'_soc="15-0000" if(`var'==104) & wave>=33 & wave<40
	replace `var'_soc="15-0000" if(`var'==111) & wave>=33 & wave<40
	replace `var'_soc="23-0000" if(`var'==215) & wave>=33 & wave<40
	replace `var'_soc="25-0000" if(`var'==245) & wave>=33 & wave<40
	replace `var'_soc="29-0000" if(`var'==310) & wave>=33 & wave<40
	replace `var'_soc="29-0000" if(`var'==313) & wave>=33 & wave<40
	replace `var'_soc="29-0000" if(`var'==341) & wave>=33 & wave<40
	replace `var'_soc="33-0000" if(`var'==392) & wave>=33 & wave<40
	replace `var'_soc="39-0000" if(`var'==455) & wave>=33 & wave<40
	replace `var'_soc="43-0000" if(`var'==545) & wave>=33 & wave<40
	replace `var'_soc="43-0000" if(`var'==593) & wave>=33 & wave<40
	replace `var'_soc="45-0000" if(`var'==615) & wave>=33 & wave<40
	replace `var'_soc="47-0000" if(`var'==690) & wave>=33 & wave<40
	replace `var'_soc="49-0000" if(`var'==753) & wave>=33 & wave<40
	replace `var'_soc="49-0000" if(`var'==762) & wave>=33 & wave<40
	replace `var'_soc="51-0000" if(`var'==787) & wave>=33 & wave<40
	replace `var'_soc="51-0000" if(`var'==823) & wave>=33 & wave<40
	replace `var'_soc="51-0000" if(`var'==824) & wave>=33 & wave<40
	replace `var'_soc="51-0000" if(`var'==826) & wave>=33 & wave<40
	replace `var'_soc="53-0000" if(`var'==902) & wave>=33 & wave<40
	replace `var'_soc="53-0000" if(`var'==944) & wave>=33 & wave<40

}

*



*** Waves 2017+ have 4-digit coding

foreach var in occupD occupDS  {
	replace `var'_soc="11-1011" if(`var'==0010) & wave>=40
	replace `var'_soc="11-1021" if(`var'==0020) & wave>=40
	replace `var'_soc="11-1031" if(`var'==0030) & wave>=40
	replace `var'_soc="11-2011" if(`var'==0040) & wave>=40
	replace `var'_soc="11-2020" if(`var'==0050) & wave>=40
	replace `var'_soc="11-2031" if(`var'==0060) & wave>=40
	replace `var'_soc="11-3011" if(`var'==0100) & wave>=40
	replace `var'_soc="11-3021" if(`var'==0110) & wave>=40
	replace `var'_soc="11-3031" if(`var'==0120) & wave>=40
	replace `var'_soc="11-3111" if(`var'==0135) & wave>=40
	replace `var'_soc="11-3121" if(`var'==0136) & wave>=40
	replace `var'_soc="11-3131" if(`var'==0137) & wave>=40
	replace `var'_soc="11-3051" if(`var'==0140) & wave>=40
	replace `var'_soc="11-3061" if(`var'==0150) & wave>=40
	replace `var'_soc="11-3071" if(`var'==0160) & wave>=40
	replace `var'_soc="11-9013" if(`var'==0205) & wave>=40
	replace `var'_soc="11-9021" if(`var'==0220) & wave>=40
	replace `var'_soc="11-9030" if(`var'==0230) & wave>=40
	replace `var'_soc="11-9041" if(`var'==0300) & wave>=40
	replace `var'_soc="11-9051" if(`var'==0310) & wave>=40
	replace `var'_soc="11-9061" if(`var'==0325) & wave>=40
	replace `var'_soc="11-9071" if(`var'==0330) & wave>=40
	replace `var'_soc="11-9081" if(`var'==0340) & wave>=40
	replace `var'_soc="11-9111" if(`var'==0350) & wave>=40
	replace `var'_soc="11-9121" if(`var'==0360) & wave>=40
	replace `var'_soc="11-9131" if(`var'==0400) & wave>=40
	replace `var'_soc="11-9141" if(`var'==0410) & wave>=40
	replace `var'_soc="11-9151" if(`var'==0420) & wave>=40
	replace `var'_soc="11-9161" if(`var'==0425) & wave>=40
	replace `var'_soc="11-9199" if(`var'==0430) & wave>=40
	replace `var'_soc="13-1011" if(`var'==0500) & wave>=40
	replace `var'_soc="13-1021" if(`var'==0510) & wave>=40
	replace `var'_soc="13-1022" if(`var'==0520) & wave>=40
	replace `var'_soc="13-1023" if(`var'==0530) & wave>=40
	replace `var'_soc="13-1030" if(`var'==0540) & wave>=40
	replace `var'_soc="13-1041" if(`var'==0565) & wave>=40
	replace `var'_soc="13-1051" if(`var'==0600) & wave>=40
	replace `var'_soc="13-1070" if(`var'==0630) & wave>=40
	replace `var'_soc="13-1141" if(`var'==0640) & wave>=40
	replace `var'_soc="13-1151" if(`var'==0650) & wave>=40
	replace `var'_soc="13-1081" if(`var'==0700) & wave>=40
	replace `var'_soc="13-1111" if(`var'==0710) & wave>=40
	replace `var'_soc="13-1121" if(`var'==0725) & wave>=40
	replace `var'_soc="13-1131" if(`var'==0726) & wave>=40
	replace `var'_soc="13-1161" if(`var'==0735) & wave>=40
	replace `var'_soc="13-1199" if(`var'==0740) & wave>=40
	replace `var'_soc="13-2011" if(`var'==0800) & wave>=40
	replace `var'_soc="13-2021" if(`var'==0810) & wave>=40
	replace `var'_soc="13-2031" if(`var'==0820) & wave>=40
	replace `var'_soc="13-2041" if(`var'==0830) & wave>=40
	replace `var'_soc="13-2051" if(`var'==0840) & wave>=40
	replace `var'_soc="13-2052" if(`var'==0850) & wave>=40
	replace `var'_soc="13-2053" if(`var'==0860) & wave>=40
	replace `var'_soc="13-2061" if(`var'==0900) & wave>=40
	replace `var'_soc="13-2070" if(`var'==0910) & wave>=40
	replace `var'_soc="13-2081" if(`var'==0930) & wave>=40
	replace `var'_soc="13-2082" if(`var'==0940) & wave>=40
	replace `var'_soc="13-2099" if(`var'==0950) & wave>=40
	replace `var'_soc="15-1111" if(`var'==1005) & wave>=40
	replace `var'_soc="15-1121" if(`var'==1006) & wave>=40
	replace `var'_soc="15-1122" if(`var'==1007) & wave>=40
	replace `var'_soc="15-1131" if(`var'==1010) & wave>=40
	replace `var'_soc="15-1130" if(`var'==1020) & wave>=40
	replace `var'_soc="15-1134" if(`var'==1030) & wave>=40
	replace `var'_soc="15-1150" if(`var'==1050) & wave>=40
	replace `var'_soc="15-1141" if(`var'==1060) & wave>=40
	replace `var'_soc="15-1142" if(`var'==1105) & wave>=40
	replace `var'_soc="15-1143" if(`var'==1106) & wave>=40
	replace `var'_soc="15-1199" if(`var'==1107) & wave>=40
	replace `var'_soc="15-2011" if(`var'==1200) & wave>=40
	replace `var'_soc="15-2021" if(`var'==1210) & wave>=40
	replace `var'_soc="15-2031" if(`var'==1220) & wave>=40
	replace `var'_soc="15-2041" if(`var'==1230) & wave>=40
	replace `var'_soc="15-2090" if(`var'==1240) & wave>=40
	replace `var'_soc="17-1010" if(`var'==1300) & wave>=40
	replace `var'_soc="17-1020" if(`var'==1310) & wave>=40
	replace `var'_soc="17-2011" if(`var'==1320) & wave>=40
	replace `var'_soc="17-2021" if(`var'==1330) & wave>=40
	replace `var'_soc="17-2031" if(`var'==1340) & wave>=40
	replace `var'_soc="17-2041" if(`var'==1350) & wave>=40
	replace `var'_soc="17-2051" if(`var'==1360) & wave>=40
	replace `var'_soc="17-2061" if(`var'==1400) & wave>=40
	replace `var'_soc="17-2070" if(`var'==1410) & wave>=40
	replace `var'_soc="17-2081" if(`var'==1420) & wave>=40
	replace `var'_soc="17-2110" if(`var'==1430) & wave>=40
	replace `var'_soc="17-2121" if(`var'==1440) & wave>=40
	replace `var'_soc="17-2131" if(`var'==1450) & wave>=40
	replace `var'_soc="17-2141" if(`var'==1460) & wave>=40
	replace `var'_soc="17-2151" if(`var'==1500) & wave>=40
	replace `var'_soc="17-2161" if(`var'==1510) & wave>=40
	replace `var'_soc="17-2171" if(`var'==1520) & wave>=40
	replace `var'_soc="17-2199" if(`var'==1530) & wave>=40
	replace `var'_soc="17-3010" if(`var'==1540) & wave>=40
	replace `var'_soc="17-3020" if(`var'==1550) & wave>=40
	replace `var'_soc="17-3031" if(`var'==1560) & wave>=40
	replace `var'_soc="19-1010" if(`var'==1600) & wave>=40
	replace `var'_soc="19-1020" if(`var'==1610) & wave>=40
	replace `var'_soc="19-1030" if(`var'==1640) & wave>=40
	replace `var'_soc="19-1040" if(`var'==1650) & wave>=40
	replace `var'_soc="19-1099" if(`var'==1660) & wave>=40
	replace `var'_soc="19-2010" if(`var'==1700) & wave>=40
	replace `var'_soc="19-2021" if(`var'==1710) & wave>=40
	replace `var'_soc="19-2030" if(`var'==1720) & wave>=40
	replace `var'_soc="19-2040" if(`var'==1740) & wave>=40
	replace `var'_soc="19-2099" if(`var'==1760) & wave>=40
	replace `var'_soc="19-3011" if(`var'==1800) & wave>=40
	replace `var'_soc="19-3022" if(`var'==1815) & wave>=40
	replace `var'_soc="19-3030" if(`var'==1820) & wave>=40
	replace `var'_soc="19-3041" if(`var'==1830) & wave>=40
	replace `var'_soc="19-3051" if(`var'==1840) & wave>=40
	replace `var'_soc="19-3090" if(`var'==1860) & wave>=40
	replace `var'_soc="19-4011" if(`var'==1900) & wave>=40
	replace `var'_soc="19-4021" if(`var'==1910) & wave>=40
	replace `var'_soc="19-4031" if(`var'==1920) & wave>=40
	replace `var'_soc="19-4041" if(`var'==1930) & wave>=40
	replace `var'_soc="19-4051" if(`var'==1940) & wave>=40
	replace `var'_soc="19-4061" if(`var'==1950) & wave>=40
	replace `var'_soc="19-4090" if(`var'==1965) & wave>=40
	replace `var'_soc="21-1010" if(`var'==2000) & wave>=40
	replace `var'_soc="21-1020" if(`var'==2010) & wave>=40
	replace `var'_soc="21-1092" if(`var'==2015) & wave>=40
	replace `var'_soc="21-1093" if(`var'==2016) & wave>=40
	replace `var'_soc="21-1090" if(`var'==2025) & wave>=40
	replace `var'_soc="21-2011" if(`var'==2040) & wave>=40
	replace `var'_soc="21-2021" if(`var'==2050) & wave>=40
	replace `var'_soc="21-2099" if(`var'==2060) & wave>=40
	replace `var'_soc="23-1011" if(`var'==2100) & wave>=40
	replace `var'_soc="23-1012" if(`var'==2105) & wave>=40
	replace `var'_soc="23-1020" if(`var'==2110) & wave>=40
	replace `var'_soc="23-2011" if(`var'==2145) & wave>=40
	replace `var'_soc="23-2090" if(`var'==2160) & wave>=40
	replace `var'_soc="25-1000" if(`var'==2200) & wave>=40
	replace `var'_soc="25-2010" if(`var'==2300) & wave>=40
	replace `var'_soc="25-2020" if(`var'==2310) & wave>=40
	replace `var'_soc="25-2030" if(`var'==2320) & wave>=40
	replace `var'_soc="25-2050" if(`var'==2330) & wave>=40
	replace `var'_soc="25-3000" if(`var'==2340) & wave>=40
	replace `var'_soc="25-4010" if(`var'==2400) & wave>=40
	replace `var'_soc="25-4021" if(`var'==2430) & wave>=40
	replace `var'_soc="25-4031" if(`var'==2440) & wave>=40
	replace `var'_soc="25-9041" if(`var'==2540) & wave>=40
	replace `var'_soc="25-9000" if(`var'==2550) & wave>=40
	replace `var'_soc="27-1010" if(`var'==2600) & wave>=40
	replace `var'_soc="27-1020" if(`var'==2630) & wave>=40
	replace `var'_soc="27-2011" if(`var'==2700) & wave>=40
	replace `var'_soc="27-2012" if(`var'==2710) & wave>=40
	replace `var'_soc="27-2020" if(`var'==2720) & wave>=40
	replace `var'_soc="27-2030" if(`var'==2740) & wave>=40
	replace `var'_soc="27-2040" if(`var'==2750) & wave>=40
	replace `var'_soc="27-2099" if(`var'==2760) & wave>=40
	replace `var'_soc="27-3010" if(`var'==2800) & wave>=40
	replace `var'_soc="27-3020" if(`var'==2810) & wave>=40
	replace `var'_soc="27-3031" if(`var'==2825) & wave>=40
	replace `var'_soc="27-3041" if(`var'==2830) & wave>=40
	replace `var'_soc="27-3042" if(`var'==2840) & wave>=40
	replace `var'_soc="27-3043" if(`var'==2850) & wave>=40
	replace `var'_soc="27-3090" if(`var'==2860) & wave>=40
	replace `var'_soc="27-4010" if(`var'==2900) & wave>=40
	replace `var'_soc="27-4021" if(`var'==2910) & wave>=40
	replace `var'_soc="27-4030" if(`var'==2920) & wave>=40
	replace `var'_soc="27-4099" if(`var'==2960) & wave>=40
	replace `var'_soc="29-1011" if(`var'==3000) & wave>=40
	replace `var'_soc="29-1020" if(`var'==3010) & wave>=40
	replace `var'_soc="29-1031" if(`var'==3030) & wave>=40
	replace `var'_soc="29-1041" if(`var'==3040) & wave>=40
	replace `var'_soc="29-1051" if(`var'==3050) & wave>=40
	replace `var'_soc="29-1060" if(`var'==3060) & wave>=40
	replace `var'_soc="29-1071" if(`var'==3110) & wave>=40
	replace `var'_soc="29-1081" if(`var'==3120) & wave>=40
	replace `var'_soc="29-1181" if(`var'==3140) & wave>=40
	replace `var'_soc="29-1122" if(`var'==3150) & wave>=40
	replace `var'_soc="29-1123" if(`var'==3160) & wave>=40
	replace `var'_soc="29-1124" if(`var'==3200) & wave>=40
	replace `var'_soc="29-1125" if(`var'==3210) & wave>=40
	replace `var'_soc="29-1126" if(`var'==3220) & wave>=40
	replace `var'_soc="29-1127" if(`var'==3230) & wave>=40
	replace `var'_soc="29-1128" if(`var'==3235) & wave>=40
	replace `var'_soc="29-1129" if(`var'==3245) & wave>=40
	replace `var'_soc="29-1131" if(`var'==3250) & wave>=40
	replace `var'_soc="29-1141" if(`var'==3255) & wave>=40
	replace `var'_soc="29-1151" if(`var'==3256) & wave>=40
	replace `var'_soc="29-1161" if(`var'==3257) & wave>=40
	replace `var'_soc="29-1171" if(`var'==3258) & wave>=40
	replace `var'_soc="29-1199" if(`var'==3260) & wave>=40
	replace `var'_soc="29-2010" if(`var'==3300) & wave>=40
	replace `var'_soc="29-2021" if(`var'==3310) & wave>=40
	replace `var'_soc="29-2030" if(`var'==3320) & wave>=40
	replace `var'_soc="29-2041" if(`var'==3400) & wave>=40
	replace `var'_soc="29-2050" if(`var'==3420) & wave>=40
	replace `var'_soc="29-2061" if(`var'==3500) & wave>=40
	replace `var'_soc="29-2071" if(`var'==3510) & wave>=40
	replace `var'_soc="29-2081" if(`var'==3520) & wave>=40
	replace `var'_soc="29-2090" if(`var'==3535) & wave>=40
	replace `var'_soc="29-9000" if(`var'==3540) & wave>=40
	replace `var'_soc="31-1010" if(`var'==3600) & wave>=40
	replace `var'_soc="31-2010" if(`var'==3610) & wave>=40
	replace `var'_soc="31-2020" if(`var'==3620) & wave>=40
	replace `var'_soc="31-9011" if(`var'==3630) & wave>=40
	replace `var'_soc="31-9091" if(`var'==3640) & wave>=40
	replace `var'_soc="31-9092" if(`var'==3645) & wave>=40
	replace `var'_soc="31-9094" if(`var'==3646) & wave>=40
	replace `var'_soc="31-9095" if(`var'==3647) & wave>=40
	replace `var'_soc="31-9096" if(`var'==3648) & wave>=40
	replace `var'_soc="31-9097" if(`var'==3649) & wave>=40
	replace `var'_soc="31-9090" if(`var'==3655) & wave>=40
	replace `var'_soc="33-1011" if(`var'==3700) & wave>=40
	replace `var'_soc="33-1012" if(`var'==3710) & wave>=40
	replace `var'_soc="33-1021" if(`var'==3720) & wave>=40
	replace `var'_soc="33-1099" if(`var'==3730) & wave>=40
	replace `var'_soc="33-2011" if(`var'==3740) & wave>=40
	replace `var'_soc="33-2020" if(`var'==3750) & wave>=40
	replace `var'_soc="33-3010" if(`var'==3800) & wave>=40
	replace `var'_soc="33-3021" if(`var'==3820) & wave>=40
	replace `var'_soc="33-3031" if(`var'==3830) & wave>=40
	replace `var'_soc="33-3041" if(`var'==3840) & wave>=40
	replace `var'_soc="33-3051" if(`var'==3850) & wave>=40
	replace `var'_soc="33-3052" if(`var'==3860) & wave>=40
	replace `var'_soc="33-9011" if(`var'==3900) & wave>=40
	replace `var'_soc="33-9021" if(`var'==3910) & wave>=40
	replace `var'_soc="33-9030" if(`var'==3930) & wave>=40
	replace `var'_soc="33-9091" if(`var'==3940) & wave>=40
	replace `var'_soc="33-9093" if(`var'==3945) & wave>=40
	replace `var'_soc="33-9090" if(`var'==3955) & wave>=40
	replace `var'_soc="35-1011" if(`var'==4000) & wave>=40
	replace `var'_soc="35-1012" if(`var'==4010) & wave>=40
	replace `var'_soc="35-2010" if(`var'==4020) & wave>=40
	replace `var'_soc="35-2021" if(`var'==4030) & wave>=40
	replace `var'_soc="35-3011" if(`var'==4040) & wave>=40
	replace `var'_soc="35-3021" if(`var'==4050) & wave>=40
	replace `var'_soc="35-3022" if(`var'==4060) & wave>=40
	replace `var'_soc="35-3031" if(`var'==4110) & wave>=40
	replace `var'_soc="35-3041" if(`var'==4120) & wave>=40
	replace `var'_soc="35-9011" if(`var'==4130) & wave>=40
	replace `var'_soc="35-9021" if(`var'==4140) & wave>=40
	replace `var'_soc="35-9031" if(`var'==4150) & wave>=40
	replace `var'_soc="35-9099" if(`var'==4160) & wave>=40
	replace `var'_soc="37-1011" if(`var'==4200) & wave>=40
	replace `var'_soc="37-1012" if(`var'==4210) & wave>=40
	replace `var'_soc="37-2010" if(`var'==4220) & wave>=40
	replace `var'_soc="37-2012" if(`var'==4230) & wave>=40
	replace `var'_soc="37-2021" if(`var'==4240) & wave>=40
	replace `var'_soc="37-3010" if(`var'==4250) & wave>=40
	replace `var'_soc="39-1010" if(`var'==4300) & wave>=40
	replace `var'_soc="39-1021" if(`var'==4320) & wave>=40
	replace `var'_soc="39-2011" if(`var'==4340) & wave>=40
	replace `var'_soc="39-2021" if(`var'==4350) & wave>=40
	replace `var'_soc="39-3010" if(`var'==4400) & wave>=40
	replace `var'_soc="39-3021" if(`var'==4410) & wave>=40
	replace `var'_soc="39-3031" if(`var'==4420) & wave>=40
	replace `var'_soc="39-3090" if(`var'==4430) & wave>=40
	replace `var'_soc="39-4000" if(`var'==4460) & wave>=40
	replace `var'_soc="39-4031" if(`var'==4465) & wave>=40
	replace `var'_soc="39-5011" if(`var'==4500) & wave>=40
	replace `var'_soc="39-5012" if(`var'==4510) & wave>=40
	replace `var'_soc="39-5090" if(`var'==4520) & wave>=40
	replace `var'_soc="39-6010" if(`var'==4530) & wave>=40
	replace `var'_soc="39-7010" if(`var'==4540) & wave>=40
	replace `var'_soc="39-9011" if(`var'==4600) & wave>=40
	replace `var'_soc="39-9021" if(`var'==4610) & wave>=40
	replace `var'_soc="39-9030" if(`var'==4620) & wave>=40
	replace `var'_soc="39-9041" if(`var'==4640) & wave>=40
	replace `var'_soc="39-9099" if(`var'==4650) & wave>=40
	replace `var'_soc="41-1011" if(`var'==4700) & wave>=40
	replace `var'_soc="41-1012" if(`var'==4710) & wave>=40
	replace `var'_soc="41-2010" if(`var'==4720) & wave>=40
	replace `var'_soc="41-2021" if(`var'==4740) & wave>=40
	replace `var'_soc="41-2022" if(`var'==4750) & wave>=40
	replace `var'_soc="41-2031" if(`var'==4760) & wave>=40
	replace `var'_soc="41-3011" if(`var'==4800) & wave>=40
	replace `var'_soc="41-3021" if(`var'==4810) & wave>=40
	replace `var'_soc="41-3031" if(`var'==4820) & wave>=40
	replace `var'_soc="41-3041" if(`var'==4830) & wave>=40
	replace `var'_soc="41-3099" if(`var'==4840) & wave>=40
	replace `var'_soc="41-4010" if(`var'==4850) & wave>=40
	replace `var'_soc="41-9010" if(`var'==4900) & wave>=40
	replace `var'_soc="41-9020" if(`var'==4920) & wave>=40
	replace `var'_soc="41-9031" if(`var'==4930) & wave>=40
	replace `var'_soc="41-9041" if(`var'==4940) & wave>=40
	replace `var'_soc="41-9091" if(`var'==4950) & wave>=40
	replace `var'_soc="41-9099" if(`var'==4965) & wave>=40
	replace `var'_soc="43-1011" if(`var'==5000) & wave>=40
	replace `var'_soc="43-2011" if(`var'==5010) & wave>=40
	replace `var'_soc="43-2021" if(`var'==5020) & wave>=40
	replace `var'_soc="43-2099" if(`var'==5030) & wave>=40
	replace `var'_soc="43-3011" if(`var'==5100) & wave>=40
	replace `var'_soc="43-3021" if(`var'==5110) & wave>=40
	replace `var'_soc="43-3031" if(`var'==5120) & wave>=40
	replace `var'_soc="43-3041" if(`var'==5130) & wave>=40
	replace `var'_soc="43-3051" if(`var'==5140) & wave>=40
	replace `var'_soc="43-3061" if(`var'==5150) & wave>=40
	replace `var'_soc="43-3071" if(`var'==5160) & wave>=40
	replace `var'_soc="43-3099" if(`var'==5165) & wave>=40
	replace `var'_soc="43-4011" if(`var'==5200) & wave>=40
	replace `var'_soc="43-4021" if(`var'==5210) & wave>=40
	replace `var'_soc="43-4031" if(`var'==5220) & wave>=40
	replace `var'_soc="43-4041" if(`var'==5230) & wave>=40
	replace `var'_soc="43-4051" if(`var'==5240) & wave>=40
	replace `var'_soc="43-4061" if(`var'==5250) & wave>=40
	replace `var'_soc="43-4071" if(`var'==5260) & wave>=40
	replace `var'_soc="43-4081" if(`var'==5300) & wave>=40
	replace `var'_soc="43-4111" if(`var'==5310) & wave>=40
	replace `var'_soc="43-4121" if(`var'==5320) & wave>=40
	replace `var'_soc="43-4131" if(`var'==5330) & wave>=40
	replace `var'_soc="43-4141" if(`var'==5340) & wave>=40
	replace `var'_soc="43-4151" if(`var'==5350) & wave>=40
	replace `var'_soc="43-4161" if(`var'==5360) & wave>=40
	replace `var'_soc="43-4171" if(`var'==5400) & wave>=40
	replace `var'_soc="43-4181" if(`var'==5410) & wave>=40
	replace `var'_soc="43-4199" if(`var'==5420) & wave>=40
	replace `var'_soc="43-5011" if(`var'==5500) & wave>=40
	replace `var'_soc="43-5021" if(`var'==5510) & wave>=40
	replace `var'_soc="43-5030" if(`var'==5520) & wave>=40
	replace `var'_soc="43-5041" if(`var'==5530) & wave>=40
	replace `var'_soc="43-5051" if(`var'==5540) & wave>=40
	replace `var'_soc="43-5052" if(`var'==5550) & wave>=40
	replace `var'_soc="43-5053" if(`var'==5560) & wave>=40
	replace `var'_soc="43-5061" if(`var'==5600) & wave>=40
	replace `var'_soc="43-5071" if(`var'==5610) & wave>=40
	replace `var'_soc="43-5081" if(`var'==5620) & wave>=40
	replace `var'_soc="43-5111" if(`var'==5630) & wave>=40
	replace `var'_soc="43-6010" if(`var'==5700) & wave>=40
	replace `var'_soc="43-9011" if(`var'==5800) & wave>=40
	replace `var'_soc="43-9021" if(`var'==5810) & wave>=40
	replace `var'_soc="43-9022" if(`var'==5820) & wave>=40
	replace `var'_soc="43-9031" if(`var'==5830) & wave>=40
	replace `var'_soc="43-9041" if(`var'==5840) & wave>=40
	replace `var'_soc="43-9051" if(`var'==5850) & wave>=40
	replace `var'_soc="43-9061" if(`var'==5860) & wave>=40
	replace `var'_soc="43-9071" if(`var'==5900) & wave>=40
	replace `var'_soc="43-9081" if(`var'==5910) & wave>=40
	replace `var'_soc="43-9111" if(`var'==5920) & wave>=40
	replace `var'_soc="43-9199" if(`var'==5940) & wave>=40
	replace `var'_soc="45-1011" if(`var'==6005) & wave>=40
	replace `var'_soc="45-2011" if(`var'==6010) & wave>=40
	replace `var'_soc="45-2021" if(`var'==6020) & wave>=40
	replace `var'_soc="45-2041" if(`var'==6040) & wave>=40
	replace `var'_soc="45-2090" if(`var'==6050) & wave>=40
	replace `var'_soc="45-3011" if(`var'==6100) & wave>=40
	replace `var'_soc="45-3021" if(`var'==6110) & wave>=40
	replace `var'_soc="45-4011" if(`var'==6120) & wave>=40
	replace `var'_soc="45-4020" if(`var'==6130) & wave>=40
	replace `var'_soc="47-1011" if(`var'==6200) & wave>=40
	replace `var'_soc="47-2011" if(`var'==6210) & wave>=40
	replace `var'_soc="47-2020" if(`var'==6220) & wave>=40
	replace `var'_soc="47-2031" if(`var'==6230) & wave>=40
	replace `var'_soc="47-2040" if(`var'==6240) & wave>=40
	replace `var'_soc="47-2050" if(`var'==6250) & wave>=40
	replace `var'_soc="47-2061" if(`var'==6260) & wave>=40
	replace `var'_soc="47-2071" if(`var'==6300) & wave>=40
	replace `var'_soc="47-2072" if(`var'==6310) & wave>=40
	replace `var'_soc="47-2073" if(`var'==6320) & wave>=40
	replace `var'_soc="47-2080" if(`var'==6330) & wave>=40
	replace `var'_soc="47-2111" if(`var'==6355) & wave>=40
	replace `var'_soc="47-2121" if(`var'==6360) & wave>=40
	replace `var'_soc="47-2130" if(`var'==6400) & wave>=40
	replace `var'_soc="47-2141" if(`var'==6420) & wave>=40
	replace `var'_soc="47-2142" if(`var'==6430) & wave>=40
	replace `var'_soc="47-2150" if(`var'==6440) & wave>=40
	replace `var'_soc="47-2161" if(`var'==6460) & wave>=40
	replace `var'_soc="47-2171" if(`var'==6500) & wave>=40
	replace `var'_soc="47-2181" if(`var'==6515) & wave>=40
	replace `var'_soc="47-2211" if(`var'==6520) & wave>=40
	replace `var'_soc="47-2221" if(`var'==6530) & wave>=40
	replace `var'_soc="47-2231" if(`var'==6540) & wave>=40
	replace `var'_soc="47-3010" if(`var'==6600) & wave>=40
	replace `var'_soc="47-4011" if(`var'==6660) & wave>=40
	replace `var'_soc="47-4021" if(`var'==6700) & wave>=40
	replace `var'_soc="47-4031" if(`var'==6710) & wave>=40
	replace `var'_soc="47-4041" if(`var'==6720) & wave>=40
	replace `var'_soc="47-4051" if(`var'==6730) & wave>=40
	replace `var'_soc="47-4061" if(`var'==6740) & wave>=40
	replace `var'_soc="47-4071" if(`var'==6750) & wave>=40
	replace `var'_soc="47-4090" if(`var'==6765) & wave>=40
	replace `var'_soc="47-5010" if(`var'==6800) & wave>=40
	replace `var'_soc="47-5021" if(`var'==6820) & wave>=40
	replace `var'_soc="47-5031" if(`var'==6830) & wave>=40
	replace `var'_soc="47-5040" if(`var'==6840) & wave>=40
	replace `var'_soc="47-5061" if(`var'==6910) & wave>=40
	replace `var'_soc="47-5071" if(`var'==6920) & wave>=40
	replace `var'_soc="47-5081" if(`var'==6930) & wave>=40
	replace `var'_soc="47-5000" if(`var'==6940) & wave>=40
	replace `var'_soc="49-1011" if(`var'==7000) & wave>=40
	replace `var'_soc="49-2011" if(`var'==7010) & wave>=40
	replace `var'_soc="49-2020" if(`var'==7020) & wave>=40
	replace `var'_soc="49-2091" if(`var'==7030) & wave>=40
	replace `var'_soc="49-2092" if(`var'==7040) & wave>=40
	replace `var'_soc="49-2093" if(`var'==7050) & wave>=40
	replace `var'_soc="49-2090" if(`var'==7100) & wave>=40
	replace `var'_soc="49-2096" if(`var'==7110) & wave>=40
	replace `var'_soc="49-2097" if(`var'==7120) & wave>=40
	replace `var'_soc="49-2098" if(`var'==7130) & wave>=40
	replace `var'_soc="49-3011" if(`var'==7140) & wave>=40
	replace `var'_soc="49-3021" if(`var'==7150) & wave>=40
	replace `var'_soc="49-3022" if(`var'==7160) & wave>=40
	replace `var'_soc="49-3023" if(`var'==7200) & wave>=40
	replace `var'_soc="49-3031" if(`var'==7210) & wave>=40
	replace `var'_soc="49-3040" if(`var'==7220) & wave>=40
	replace `var'_soc="49-3050" if(`var'==7240) & wave>=40
	replace `var'_soc="49-3090" if(`var'==7260) & wave>=40
	replace `var'_soc="49-9010" if(`var'==7300) & wave>=40
	replace `var'_soc="49-9021" if(`var'==7315) & wave>=40
	replace `var'_soc="49-9031" if(`var'==7320) & wave>=40
	replace `var'_soc="49-9040" if(`var'==7330) & wave>=40
	replace `var'_soc="49-9071" if(`var'==7340) & wave>=40
	replace `var'_soc="49-9043" if(`var'==7350) & wave>=40
	replace `var'_soc="49-9044" if(`var'==7360) & wave>=40
	replace `var'_soc="49-9051" if(`var'==7410) & wave>=40
	replace `var'_soc="49-9052" if(`var'==7420) & wave>=40
	replace `var'_soc="49-9060" if(`var'==7430) & wave>=40
	replace `var'_soc="49-9081" if(`var'==7440) & wave>=40
	replace `var'_soc="49-9091" if(`var'==7510) & wave>=40
	replace `var'_soc="49-9092" if(`var'==7520) & wave>=40
	replace `var'_soc="49-9094" if(`var'==7540) & wave>=40
	replace `var'_soc="49-9095" if(`var'==7550) & wave>=40
	replace `var'_soc="49-9096" if(`var'==7560) & wave>=40
	replace `var'_soc="49-9097" if(`var'==7600) & wave>=40
	replace `var'_soc="49-9098" if(`var'==7610) & wave>=40
	replace `var'_soc="49-9090" if(`var'==7630) & wave>=40
	replace `var'_soc="51-1011" if(`var'==7700) & wave>=40
	replace `var'_soc="51-2011" if(`var'==7710) & wave>=40
	replace `var'_soc="51-2020" if(`var'==7720) & wave>=40
	replace `var'_soc="51-2031" if(`var'==7730) & wave>=40
	replace `var'_soc="51-2041" if(`var'==7740) & wave>=40
	replace `var'_soc="51-2090" if(`var'==7750) & wave>=40
	replace `var'_soc="51-3011" if(`var'==7800) & wave>=40
	replace `var'_soc="51-3020" if(`var'==7810) & wave>=40
	replace `var'_soc="51-3091" if(`var'==7830) & wave>=40
	replace `var'_soc="51-3092" if(`var'==7840) & wave>=40
	replace `var'_soc="51-3093" if(`var'==7850) & wave>=40
	replace `var'_soc="51-3099" if(`var'==7855) & wave>=40
	replace `var'_soc="51-4010" if(`var'==7900) & wave>=40
	replace `var'_soc="51-4021" if(`var'==7920) & wave>=40
	replace `var'_soc="51-4022" if(`var'==7930) & wave>=40
	replace `var'_soc="51-4023" if(`var'==7940) & wave>=40
	replace `var'_soc="51-4031" if(`var'==7950) & wave>=40
	replace `var'_soc="51-4032" if(`var'==7960) & wave>=40
	replace `var'_soc="51-4033" if(`var'==8000) & wave>=40
	replace `var'_soc="51-4034" if(`var'==8010) & wave>=40
	replace `var'_soc="51-4035" if(`var'==8020) & wave>=40
	replace `var'_soc="51-4041" if(`var'==8030) & wave>=40
	replace `var'_soc="51-4050" if(`var'==8040) & wave>=40
	replace `var'_soc="51-4060" if(`var'==8060) & wave>=40
	replace `var'_soc="51-4070" if(`var'==8100) & wave>=40
	replace `var'_soc="51-4081" if(`var'==8120) & wave>=40
	replace `var'_soc="51-4111" if(`var'==8130) & wave>=40
	replace `var'_soc="51-4120" if(`var'==8140) & wave>=40
	replace `var'_soc="51-4191" if(`var'==8150) & wave>=40
	replace `var'_soc="51-4192" if(`var'==8160) & wave>=40
	replace `var'_soc="51-4193" if(`var'==8200) & wave>=40
	replace `var'_soc="51-4194" if(`var'==8210) & wave>=40
	replace `var'_soc="51-4199" if(`var'==8220) & wave>=40
	replace `var'_soc="51-5111" if(`var'==8250) & wave>=40
	replace `var'_soc="51-5112" if(`var'==8255) & wave>=40
	replace `var'_soc="51-5113" if(`var'==8256) & wave>=40
	replace `var'_soc="51-6011" if(`var'==8300) & wave>=40
	replace `var'_soc="51-6021" if(`var'==8310) & wave>=40
	replace `var'_soc="51-6031" if(`var'==8320) & wave>=40
	replace `var'_soc="51-6041" if(`var'==8330) & wave>=40
	replace `var'_soc="51-6042" if(`var'==8340) & wave>=40
	replace `var'_soc="51-6050" if(`var'==8350) & wave>=40
	replace `var'_soc="51-6061" if(`var'==8360) & wave>=40
	replace `var'_soc="51-6062" if(`var'==8400) & wave>=40
	replace `var'_soc="51-6063" if(`var'==8410) & wave>=40
	replace `var'_soc="51-6064" if(`var'==8420) & wave>=40
	replace `var'_soc="51-6091" if(`var'==8430) & wave>=40
	replace `var'_soc="51-6092" if(`var'==8440) & wave>=40
	replace `var'_soc="51-6093" if(`var'==8450) & wave>=40
	replace `var'_soc="51-6099" if(`var'==8460) & wave>=40
	replace `var'_soc="51-7011" if(`var'==8500) & wave>=40
	replace `var'_soc="51-7021" if(`var'==8510) & wave>=40
	replace `var'_soc="51-7030" if(`var'==8520) & wave>=40
	replace `var'_soc="51-7041" if(`var'==8530) & wave>=40
	replace `var'_soc="51-7042" if(`var'==8540) & wave>=40
	replace `var'_soc="51-7099" if(`var'==8550) & wave>=40
	replace `var'_soc="51-8010" if(`var'==8600) & wave>=40
	replace `var'_soc="51-8021" if(`var'==8610) & wave>=40
	replace `var'_soc="51-8031" if(`var'==8620) & wave>=40
	replace `var'_soc="51-8090" if(`var'==8630) & wave>=40
	replace `var'_soc="51-9010" if(`var'==8640) & wave>=40
	replace `var'_soc="51-9020" if(`var'==8650) & wave>=40
	replace `var'_soc="51-9030" if(`var'==8710) & wave>=40
	replace `var'_soc="51-9041" if(`var'==8720) & wave>=40
	replace `var'_soc="51-9051" if(`var'==8730) & wave>=40
	replace `var'_soc="51-9061" if(`var'==8740) & wave>=40
	replace `var'_soc="51-9071" if(`var'==8750) & wave>=40
	replace `var'_soc="51-9080" if(`var'==8760) & wave>=40
	replace `var'_soc="51-9111" if(`var'==8800) & wave>=40
	replace `var'_soc="51-9120" if(`var'==8810) & wave>=40
	replace `var'_soc="51-9151" if(`var'==8830) & wave>=40
	replace `var'_soc="51-9141" if(`var'==8840) & wave>=40
	replace `var'_soc="51-9191" if(`var'==8850) & wave>=40
	replace `var'_soc="51-9192" if(`var'==8860) & wave>=40
	replace `var'_soc="51-9193" if(`var'==8900) & wave>=40
	replace `var'_soc="51-9194" if(`var'==8910) & wave>=40
	replace `var'_soc="51-9195" if(`var'==8920) & wave>=40
	replace `var'_soc="51-9196" if(`var'==8930) & wave>=40
	replace `var'_soc="51-9197" if(`var'==8940) & wave>=40
	replace `var'_soc="51-9198" if(`var'==8950) & wave>=40
	replace `var'_soc="51-9199" if(`var'==8965) & wave>=40
	replace `var'_soc="53-1000" if(`var'==9000) & wave>=40
	replace `var'_soc="53-2010" if(`var'==9030) & wave>=40
	replace `var'_soc="53-2020" if(`var'==9040) & wave>=40
	replace `var'_soc="53-2031" if(`var'==9050) & wave>=40
	replace `var'_soc="53-3011" if(`var'==9110) & wave>=40
	replace `var'_soc="53-3020" if(`var'==9120) & wave>=40
	replace `var'_soc="53-3030" if(`var'==9130) & wave>=40
	replace `var'_soc="53-3041" if(`var'==9140) & wave>=40
	replace `var'_soc="53-3099" if(`var'==9150) & wave>=40
	replace `var'_soc="53-4010" if(`var'==9200) & wave>=40
	replace `var'_soc="53-4021" if(`var'==9230) & wave>=40
	replace `var'_soc="53-4031" if(`var'==9240) & wave>=40
	replace `var'_soc="53-4000" if(`var'==9260) & wave>=40
	replace `var'_soc="53-5011" if(`var'==9300) & wave>=40
	replace `var'_soc="53-5020" if(`var'==9310) & wave>=40
	replace `var'_soc="53-5031" if(`var'==9330) & wave>=40
	replace `var'_soc="53-6011" if(`var'==9340) & wave>=40
	replace `var'_soc="53-6021" if(`var'==9350) & wave>=40
	replace `var'_soc="53-6031" if(`var'==9360) & wave>=40
	replace `var'_soc="53-6051" if(`var'==9410) & wave>=40
	replace `var'_soc="53-6061" if(`var'==9415) & wave>=40
	replace `var'_soc="53-6000" if(`var'==9420) & wave>=40
	replace `var'_soc="53-7011" if(`var'==9500) & wave>=40
	replace `var'_soc="53-7021" if(`var'==9510) & wave>=40
	replace `var'_soc="53-7030" if(`var'==9520) & wave>=40
	replace `var'_soc="53-7041" if(`var'==9560) & wave>=40
	replace `var'_soc="53-7051" if(`var'==9600) & wave>=40
	replace `var'_soc="53-7061" if(`var'==9610) & wave>=40
	replace `var'_soc="53-7062" if(`var'==9620) & wave>=40
	replace `var'_soc="53-7063" if(`var'==9630) & wave>=40
	replace `var'_soc="53-7064" if(`var'==9640) & wave>=40
	replace `var'_soc="53-7070" if(`var'==9650) & wave>=40
	replace `var'_soc="53-7081" if(`var'==9720) & wave>=40
	replace `var'_soc="53-7111" if(`var'==9730) & wave>=40
	replace `var'_soc="53-7121" if(`var'==9740) & wave>=40
	replace `var'_soc="53-7199" if(`var'==9750) & wave>=40
	replace `var'_soc="55-1010" if(`var'==9800) & wave>=40
	replace `var'_soc="55-2010" if(`var'==9810) & wave>=40
	replace `var'_soc="55-3010" if(`var'==9820) & wave>=40
	replace `var'_soc="55-0000" if(`var'==9830) & wave>=40 // added (Armed Forces) & wave>=40
	replace `var'_soc="-1"		if(`var'==9999) & wave>=40 // added
	replace `var'_soc="-3"		if(`var'==0) 	& wave>=40 	// added
	*replace `var'_soc="11-0000"	if(`var'>0 & `var'<10) 	// added

}
*


qui di "FINISHED: Step 1 (Census 2010 --> SOC 2010)" 



 