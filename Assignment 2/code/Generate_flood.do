
clear all
set mem 500m
set more off
capture log close
log using log_flood.log, replace

tempfile farmval900 farmval910 farmval920 farmval925 farmval930 farmval935 farmval940 farmval945 farmval950 farmval954 farmval959 icpsr1900 1900 icpsr1910 1910 icpsr1920 1920 1925 1930 1935 icpsr1940 1940 1945 icpsr1950 ag1950 1950 ag1954 1954 icpsr1960 icpsr1960_2 ag1959 1960 ag1964 1964 icpsr1970 ag1969 1970 redcross haines1930 haines1930_1 haines1925 haines1925_new haines1935 haines1935_new haines1940 haines1940_new distance_1900 flood1910_1900 flood1920_1900 flood1925_1900 flood1930_1900 flood1935_1900 flood1940_1900 flood1945_1900 flood1950_1900 flood1954_1900 flood1960_1900 flood1964_1900 flood1970_1900 tractors1925 flood_1900 ms_distance ruggedness_1900 brannenplantcounties_1900 new_deal_data river_1900 crop_suitability

*Value of farmland and buildings in 1900-1959
foreach i of numlist 900 910 920 925 930 935 940 945 950 954 959 {
use "../data/farmval.dta", clear
keep if level==1
keep state county name fips faval`i'
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
rename faval`i' farmval
gen year = 1`i'
sort fips
save `farmval`i'', replace 
}
clear
use `farmval959'
replace year = 1960
save `farmval959', replace
clear

***
*1900
***

*ICPSR data for 1900
use "../data/02896-0020-Data.dta",clear
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips state county name area totpop nbwmnp nbwfnp nbwmfp nbwffp fbwmtot fbwftot negmtot negftot farms farmwh farmcol acfarm farmwhow farmwhct farmcoow farmcoct farmcost farmwhst farmbui farmequi farmout farmlab livstock mfgestab mfgwages mfgavear 
drop if fips==.
rename area county_squaremiles
rename totpop population
gen population_race_white = nbwmnp + nbwmfp + fbwmtot + nbwfnp + nbwffp + fbwftot
gen population_race_black = negmtot + negftot
gen population_race_other = population - population_race_white - population_race_black
rename farmwh farms_white
rename farmcol farms_nonwhite
gen farms_owner = farmwhow + farmcoow
gen farms_tenant = farmwhct + farmcoct + farmwhst + farmcost
gen farms_nonwhite_tenant = farmcoct + farmcost
gen farms_tenant_cash = farmwhct + farmcoct
rename acfarm farmland
rename farmbui value_buildings
rename farmequi value_equipment
gen year = 1900
order fips state county name county_squaremiles population population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland value_buildings value_equipment mfgestab mfgwages mfgavear 
keep fips state county name county_squaremiles population population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland value_buildings value_equipment mfgestab mfgwages mfgavear 
sort fips
save `icpsr1900', replace
clear

*Agricultural data for 1900
use "../data/ag900co.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips cornac oatsac wheatac cottonac riceac scaneac colts0 colts1_2 horses2_ mules0 mules1_2 mules2_ corn oats wheat cotbale1 rice csugarwt
rename cornac corn_a
rename oatsac oats_a
rename wheatac wheat_a
rename cottonac cotton_a
rename riceac rice_a
rename scaneac scane_a
rename corn corn_y
rename oats oats_y
rename wheat wheat_y
rename cotbale1 cotton_y
rename rice rice_y
rename csugarwt scane_y
gen horses = colts0 + colts1_2 + horses2_
gen mules = mules0 + mules1_2 + mules2_
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a {
replace `var' = 0 if `var'==.
}
order fips corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y horses mules
keep fips corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y horses mules
sort fips
merge fips using `icpsr1900'
keep if _merge==3
drop _merge
sort fips
merge fips using `farmval900'
keep if _merge==3
drop _merge
gen value_landbuildings = farmval*farmland
gen value_land = value_landbuildings-value_buildings
drop farmval
order fips year state county name county_squaremiles population population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y mfgestab mfgwages mfgavear
keep fips year state county name county_squaremiles population population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y mfgestab mfgwages mfgavear
sort fips
save `1900', replace
clear

***
*1910
***

*ICPSR data for 1910
use "../data/02896-0022-Data.dta", clear
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips state county name area totpop wmtot wftot negmtot negftot farms farmnw farmfbw farmneg farmown farmten fownneg farmnegt farmcten acresown acresten acresman cropval rur1910
rename area county_squaremiles
rename totpop population
gen population_race_white = wmtot + wftot
gen population_race_black = negmtot + negftot
gen population_race_other = population - population_race_white - population_race_black
gen farms_white = farmnw + farmfbw
rename farmneg farms_nonwhite
rename farmown farms_owner
rename farmten farms_tenant
rename farmcten farms_tenant_cash
gen farmland = acresown + acresten + acresman
gen farms_nonwhite_tenant = farmnegt
rename acresown farmland_owner
rename acresten farmland_tenant
rename rur1910 population_rural
gen year = 1910
order fips state county name county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant cropval 
keep fips state county name county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant cropval 
sort fips
save `icpsr1910', replace
clear

*Agricultural data for 1910
use "../data/ag910co.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips farmbui farmequi livstock fawages farebord cornac oatsac wheatac cottonac riceac csugarac horses mules corn oats wheat cotton rice csugar
rename farmbui value_buildings
rename farmequi value_equipment
rename livstock value_livestock
rename fawages value_labor_wages
rename farebord value_labor_board
rename cornac corn_a
rename oatsac oats_a
rename wheatac wheat_a
rename cottonac cotton_a
rename riceac rice_a
rename csugarac scane_a
rename corn corn_y
rename oats oats_y
rename wheat wheat_y
rename cotton cotton_y
rename rice rice_y
rename csugar scane_y
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a {
replace `var' = 0 if `var'==.
}
order fips value_buildings value_equipment value_livestock value_labor_wages value_labor_board corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y horses mules
keep fips value_buildings value_equipment value_livestock value_labor_wages value_labor_board corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y horses mules
sort fips
merge fips using `icpsr1910'
keep if _merge==3
drop _merge
sort fips
merge fips using `farmval910'
keep if _merge==3
drop _merge
gen value_landbuildings = farmval*farmland
gen value_land = value_landbuildings-value_buildings
drop farmval
order fips county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval
keep fips county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval
sort fips
save `1910', replace
clear

***
*1920
***

*ICPSR data for 1920
use "../data/02896-0024-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips state county name area areaac totpop urb920 nwmtot nwftot fbwmtot fbwftot negmtot negftot farms farmnw farmfbw farmcol farmcolt farmown farmten farmcten acresown acresten acresman farmbui farmequi livstock cropval mfgwages mfgestab mfgavear
rename area county_squaremiles
rename areaac county_acres
rename totpop population
gen population_race_white = nwmtot + fbwmtot + nwftot + fbwftot
gen population_race_black = negmtot + negftot
gen population_race_other = population - population_race_white - population_race_black
gen farms_white = farmnw + farmfbw
rename farmcol farms_nonwhite
rename farmown farms_owner
rename farmten farms_tenant
rename farmcten farms_tenant_cash
gen farmland = acresown + acresten + acresman
rename acresown farmland_owner
rename acresten farmland_tenant
rename farmbui value_buildings
rename farmequi value_equipment
rename livstock value_livestock
rename farmcolt farms_nonwhite_tenant
gen population_rural = population - urb920
gen year = 1920
order fips state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_buildings value_equipment value_livestock cropval mfgwages mfgestab mfgavear 
keep fips state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_buildings value_equipment value_livestock cropval mfgwages mfgestab mfgavear 
sort fips
save `icpsr1920', replace
clear

*Agricultural data for 1920
use "../data/ag920co.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep state county name fips var147 var149 var151 var165 var216 var221 var56 var63 var148 var150 var152 var166 var217 var222 var308 var309 var310
rename var147 corn_a
rename var149 oats_a
rename var151 wheat_a
rename var165 rice_a
rename var216 cotton_a
rename var221 scane_a
rename var56 horses
rename var63 mules
rename var148 corn_y
rename var150 oats_y
destring oats_y, replace
rename var152 wheat_y
rename var166 rice_y
rename var217 cotton_y
rename var222 scane_y
rename var308 value_labor
rename var309 value_labor_wages
rename var310 value_labor_board
gen year = 1920
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a {
replace `var' = 0 if `var'==.
}
sort fips
merge fips using `icpsr1920'
keep if _merge==3
drop _merge
sort fips
merge fips using `farmval920'
keep if _merge==3
drop _merge
gen value_landbuildings = farmval*farmland
gen value_land = value_landbuildings-value_buildings
drop farmval
sort fips
merge fips using "../data/out_migrant_counts.dta"
drop if _merge==2
drop _merge
order fips county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y people samecounty samestate samearea sameregion people_white samecounty_white samestate_white samearea_white sameregion_white people_black samecounty_black samestate_black samearea_black sameregion_black cropval mfgwages mfgestab mfgavear farms_nonwhite_tenant
keep fips county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y people samecounty samestate samearea sameregion people_white samecounty_white samestate_white samearea_white sameregion_white people_black samecounty_black samestate_black samearea_black sameregion_black cropval mfgwages mfgestab mfgavear farms_nonwhite_tenant 
sort fips
save `1920', replace
clear

***
*1925
***

*Data from Haines
insheet using "../data/Haines_1925.txt"
rename var2 farms
rename var42 farmland
rename var99 value_equipment
rename var169 horses
rename var173 mules
sort state county
merge state county using "../data/icpsr_fips.dta"
keep if _merge==3
drop name var* _merge
sort fips
save `haines1925', replace
clear

*New Data from Haines
insheet using "../data/Haines_1925_new.txt"
sort state county
drop if state==0|state==.|state>73
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
sort state county
merge state county using "../data/icpsr_fips.dta"
keep if _merge==3
drop _merge
sort fips
save `haines1925_new', replace
clear

*Suresh Updated Tractor Data
use "../data/tractors1925.dta",clear
rename tractors1925 tractors
keep fips tractors
sort fips
save `tractors1925', replace

clear
use `farmval925'
keep fips farmval
sort fips
merge fips using `haines1925'
tab _merge
keep if _merge==3
drop _merge
sort fips
merge fips using `haines1925_new'
tab _merge
keep if _merge==3
drop _merge
sort fips
merge fips using `tractors1925'
drop if _merge==2
drop _merge
gen value_landbuildings = farmval*farmland
drop farmval
order fips state county farms farmland value_landbuildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y tractors
keep fips state county farms farmland value_landbuildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y tractors 
sort fips
save `1925', replace
clear

***
*1930
***

*Data from Haines
insheet using "../data/Haines_1930.txt"
keep state county horses mules tractors
sort state county
save `haines1930_1', replace
clear

*New Data from Haines
insheet using "../data/Haines_1930_new.txt"
sort state county
drop if state==0|state==.|state>73
destring cotton_a, replace force
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
sort state county
merge state county using `haines1930_1'
tab _merge
keep if _merge==3
drop _merge
sort state county
merge state county using "../data/icpsr_fips.dta"
keep if _merge==3
drop _merge
sort fips
save `haines1930', replace
clear

*Data from Rhode
insheet using "../data/redcross_new.txt"
order fips state_redcross county_redcross pop1930 flooded_acres pop_affected agricultural_flooded_acres
keep fips state_redcross county_redcross pop1930 flooded_acres pop_affected agricultural_flooded_acres
foreach var of varlist flooded_acres pop_affected agricultural_flooded_acres {
replace `var' = 0 if `var'==.
}
sort fips
save `redcross', replace
clear

*ICPSR data for 1930
use "../data/02896-0026-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips state county name area areaac totpop urban30 nwmtot nwftot fbwmtot fbwftot negmtot negftot farms farmwh farmcol acres acfown acpown acten farmfown farmpown farmten farmcten farmbui farmequi cropval mfgwages mfgestab mfgavear
rename area county_squaremiles
rename areaac county_acres
rename totpop population
gen population_race_white = nwmtot + fbwmtot + nwftot + fbwftot
gen population_race_black = negmtot + negftot
gen population_race_other = population - population_race_white - population_race_black
gen farms_white = farmwh
rename farmcol farms_nonwhite
gen farms_owner = farmfown+farmpown
rename farmten farms_tenant
rename farmcten farms_tenant_cash
rename acres farmland
gen farmland_owner = acfown + acpown
gen farmland_tenant = acten
rename farmbui value_buildings
rename farmequi value_equipment
gen population_rural = population - urban30
order fips state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_buildings value_equipment cropval mfgwages mfgestab mfgavear
keep fips state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_buildings value_equipment cropval mfgwages mfgestab mfgavear
gen year = 1930
sort fips
merge fips using `farmval930'
keep if _merge==3
drop _merge
sort fips
merge fips using "../data/in_migrant_counts.dta"
tab _merge
drop if _merge==2
drop _merge
sort fips
merge fips using `haines1930'
tab _merge
keep if _merge==3
drop _merge
sort fips
merge fips using `redcross'
drop if _merge==2
drop state_redcross county_redcross pop1930
drop _merge
sort fips
gen value_landbuildings = farmval*farmland
gen value_land = value_landbuildings-value_buildings
drop farmval
order fips county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y horses mules tractors flooded_acres pop_affected agricultural_flooded_acres in_people in_samecounty in_samestate in_samearea in_sameregion in_people_white in_samecounty_white in_samestate_white in_samearea_white in_sameregion_white in_people_black in_samecounty_black in_samestate_black in_samearea_black in_sameregion_black cropval mfgwages mfgestab mfgavear
keep fips county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y horses mules tractors flooded_acres pop_affected agricultural_flooded_acres in_people in_samecounty in_samestate in_samearea in_sameregion in_people_white in_samecounty_white in_samestate_white in_samearea_white in_sameregion_white in_people_black in_samecounty_black in_samestate_black in_samearea_black in_sameregion_black cropval mfgwages mfgestab mfgavear
sort fips
save `1930', replace
clear


***
*1935
***

*Data from Haines
insheet using "../data/Haines_1935.txt"
rename var2 farms
rename var12 farmland
rename var95 horses
rename var100 mules
sort state county
merge state county using "../data/icpsr_fips.dta"
keep if _merge==3
drop name var* _merge
sort fips
save `haines1935', replace
clear

*New Data from Haines
insheet using "../data/Haines_1935_new.txt"
sort state county
drop if state==0|state==.|state>73
gen wheat_a = wheat1_a+wheat2_a
gen wheat_y = wheat1_y+wheat2_y
drop wheat1* wheat2*
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
sort state county
merge state county using "../data/icpsr_fips.dta"
keep if _merge==3
drop _merge
sort fips
save `haines1935_new', replace
clear

use `farmval935'
keep fips farmval
sort fips
merge fips using `haines1935'
tab _merge
keep if _merge==3
drop _merge
sort fips
merge fips using `haines1935_new'
tab _merge
keep if _merge==3
drop _merge
gen value_landbuildings = farmval*farmland
drop farmval
order fips state county farms farmland value_landbuildings horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y
keep fips state county farms farmland value_landbuildings horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y
sort fips
save `1935', replace
clear

***
*1940
***

*New Data from Haines
insheet using "../data/Haines_1940_new.txt"
sort state county
drop if state==0|state==.|state>73
destring oats_y, replace
destring wheat_y, replace
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
sort state county
merge state county using "../data/icpsr_fips.dta"
keep if _merge==3
drop _merge
sort fips
save `haines1940', replace
clear

*ICPSR data for 1940
use "../data/02896-0032-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips state county name area areaac totpop urb940 nwtot fbwtot negtot farms farmwh farmnonw acfarms acfown acpown acten accten acsten farmfown farmpown farmcten farmten buildval equipval cropval mfgwages mfgestab mfgavear
rename area county_squaremiles
rename areaac county_acres
rename totpop population
gen population_race_white = nwtot + fbwtot
gen population_race_black = negtot
gen population_race_other = population - population_race_white - population_race_black
gen farms_white = farmwh
rename farmnonw farms_nonwhite
gen farms_owner = farmfown+farmpown
rename farmten farms_tenant
rename farmcten farms_tenant_cash
rename acfarms farmland
gen farmland_owner = acfown + acpown
gen farmland_tenant = acten
rename buildval value_buildings
rename equipval value_equipment
gen population_rural = population - urb940
order fips state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_buildings value_equipment cropval mfgwages mfgestab mfgavear
keep fips state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_buildings value_equipment cropval mfgwages mfgestab mfgavear
gen year = 1940
sort fips
save `icpsr1940', replace
clear

use "../data/02896-0070-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips var57 var56
rename var57 tractors
rename var56 mules_horses
sort fips
merge fips using `icpsr1940'
keep if _merge==3
drop _merge
sort fips
merge fips using `farmval940'
keep if _merge==3
drop _merge
sort fips
merge fips using `haines1940'
keep if _merge==3
drop _merge
gen value_landbuildings = farmval*farmland
gen value_land = value_landbuildings-value_buildings
drop farmval
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
order fips county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval mfgwages mfgestab mfgavear
keep fips county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval mfgwages mfgestab mfgavear
sort fips
save `1940', replace
clear


***
*1945
***

use "../data/02896-0071-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips var69 var71 var82
rename var69 farms
rename var71 farmland
replace farmland = farmland*1000
rename var82 tractors
sort fips
merge fips using `farmval945'
keep if _merge==3
drop _merge
gen value_landbuildings = farmval*farmland
order fips farms farmland value_landbuildings tractors
keep fips farms farmland value_landbuildings tractors
sort fips
save `1945', replace
clear

***
*1950
***

*ICPSR data for 1950
use "../data/02896-0035-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips state county name area areaac totpop urb950 nwmtot nwftot fbwmtot fbwftot negmtot negftot farms farmwh farmnonw acres acfown acpown acten farmfown farmpown farmcten farmten cropval 
rename area county_squaremiles
rename areaac county_acres
rename totpop population
gen population_race_white = nwmtot + nwftot + fbwmtot + fbwftot
gen population_race_black = negmtot + negftot
gen population_race_other = population - population_race_white - population_race_black
gen farms_white = farmwh
rename farmnonw farms_nonwhite
gen farms_owner = farmfown+farmpown
rename farmten farms_tenant
rename farmcten farms_tenant_cash
rename acres farmland
gen farmland_owner = acfown + acpown
gen farmland_tenant = acten
gen population_rural = population - urb950
order fips state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant cropval
keep fips state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant cropval
gen year = 1950
sort fips
save `icpsr1950', replace
clear

*Agricultural data for 1950
use "../data/usag1949.cos.crops.dta"
keep fips item742 item744
rename item742 horses
rename item744 mules_horses
sort fips
save `ag1950', replace
clear

use "../data/usag1949.work.dta"
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep state county fips var2 var3 var13 var14 var23 var24 var27 var28 var72 var73 var80 var82
rename var2 corn_a
rename var3 corn_y
rename var13 wheat_a
rename var14 wheat_y
rename var23 oats_a
rename var24 oats_y
rename var27 rice_a
rename var28 rice_y
rename var72 cotton_a
rename var73 cotton_y
rename var80 scane_a
rename var82 scane_y
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
gen year = 1950
sort fips
merge fips using `icpsr1950'
keep if _merge==3
drop _merge
sort fips
merge fips using `ag1950'
keep if _merge==3
drop _merge
sort fips
merge fips using `farmval950'
keep if _merge==3
drop _merge
gen value_landbuildings = farmval*farmland
drop farmval
order fips county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval
keep fips county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval
sort fips
save `1950', replace
clear


***
*1954
***

use "../data/usag1954.cos.crops.dta"
keep fips item101 item119 item122 item113 item175 item187 item742 item744 item401 item419 item422 item413 item475 item487
rename item101 corn_a
rename item119 oats_a
rename item122 rice_a
rename item113 wheat_a
rename item175 cotton_a
rename item187 scane_a
rename item742 horses
rename item744 mules_horses
rename item401 corn_y
rename item413 wheat_y
rename item419 oats_y
rename item422 rice_y
rename item475 cotton_y
rename item487 scane_y
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
sort fips
save `ag1954', replace
clear

use "../data/02896-0073-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips var100 var101 var112 var113 var126
rename var100 farms
rename var101 farmland
replace farmland = farmland*1000
rename var112 value_perfarm
rename var113 value_peracre
gen value_landbuildings_perfarm = value_perfarm*farms
gen value_landbuildings_peracre = value_peracre*farmland
rename var126 tractors
keep fips farmland farms value_landbuildings_perfarm value_landbuildings_peracre tractors
order fips farmland farms value_landbuildings_perfarm value_landbuildings_peracre tractors
sort fips
merge fips using `ag1954'
keep if _merge==3
drop _merge
sort fips
merge fips using `farmval954'
gen value_landbuildings = farmval*farmland
drop farmval
keep if _merge==3
drop _merge
order fips farms farmland value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y
keep fips farms farmland value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y 
sort fips
save `1954', replace
clear

***
*1960
***

*ICPSR data for 1960
use "../data/02896-0038-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips state county name totpop wmtot wftot negmtot negftot 
rename totpop population
gen population_race_white = wmtot + wftot
gen population_race_black = negmtot + negftot
gen population_race_other = population - population_race_white - population_race_black
order fips state county name population population_race_white population_race_black population_race_other 
keep fips state county name population population_race_white population_race_black population_race_other 
gen year = 1960
sort fips
save `icpsr1960', replace
clear

use "../data/02896-0074-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips var146 var147 var149 var6
rename var146 value_perfarm
rename var147 value_peracre
rename var149 cropval
rename var6 percent_urban
sort fips
save `icpsr1960_2', replace
clear

use "../data/usag1959.cos.crops.dta"
keep fips item101 item119 item122 item113 item175 item187 item742 item744 item401 item419 item422 item413 item475 item487
rename item101 corn_a
rename item119 oats_a
rename item122 rice_a
rename item113 wheat_a
rename item175 cotton_a
rename item187 scane_a
rename item742 horses
rename item744 mules_horses
rename item401 corn_y
rename item413 wheat_y
rename item419 oats_y
rename item422 rice_y
rename item475 cotton_y
rename item487 scane_y
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
sort fips
save `ag1959', replace
clear

*Agricultural data for 1960 (documentation starting page 85)
use "../data/usag1959.work.dta",clear
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep state county counname fips var250 var254 var276 var277 var279 var282 var283 var287 var334
rename counname name
rename var250 farms
rename var254 farmland
rename var276 farmfown
rename var277 farmpown
gen farms_owner = farmfown + farmpown
rename var279 farms_tenant
rename var282 acfown
rename var283 acpown
rename var287 acten
gen farmland_owner = acfown + acpown
gen farmland_tenant = acten
rename var334 value_labor
gen year = 1960
sort fips
merge fips using `icpsr1960'
keep if _merge==3
drop _merge
sort fips
merge fips using `icpsr1960_2'
keep if _merge==3
drop _merge
sort fips
merge fips using `ag1959'
keep if _merge==3
drop _merge
sort fips
merge fips using `farmval959'
keep if _merge==3
drop _merge
gen value_landbuildings = farmval*farmland
gen value_landbuildings_peracre = value_peracre*farmland
gen value_landbuildings_perfarm = value_perfarm*farms
gen population_rural = population * (1 - (percent_urban / 100))
drop farmval
order fips population population_rural population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval
keep fips population population_rural population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval
sort fips
save `1960', replace
clear


***
*1964
***

use "../data/usag1964.cos.crops.dta"
keep fips item101 item119 item122 item113 item175 item187 item742 item744 item401 item419 item422 item413 item475 item487
rename item101 corn_a
rename item119 oats_a
rename item122 rice_a
rename item113 wheat_a
rename item175 cotton_a
rename item187 scane_a
rename item742 horses
rename item744 mules_horses
rename item401 corn_y
rename item413 wheat_y
rename item419 oats_y
rename item422 rice_y
rename item475 cotton_y
rename item487 scane_y
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
sort fips
save `ag1964', replace
clear

use "../data/02896-0075-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips var124 var126 var128 var129
rename var124 farms
rename var126 farmland
replace farmland = farmland*1000
rename var129 value_perfarm
replace value_perfarm = value_perfarm*1000
rename var128 value_peracre
gen value_landbuildings_perfarm = value_perfarm*farms
gen value_landbuildings_peracre = value_peracre*farmland
sort fips
merge fips using `ag1964'
keep if _merge==3
drop _merge
order fips farms farmland value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y
keep fips farms farmland value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y
sort fips
save `1964', replace
clear
***
*1969
***

use "../data/02896-0076-Data.dta"
keep if level==1
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips var3 var9 var10 var173 var175 var178 var179 var121 var124 var128
rename var3 population
rename var9 population_race_white
rename var10 population_race_black
gen population_race_other = population-population_race_white-population_race_black
rename var173 farms
rename var175 farmland
replace farmland = farmland*1000
rename var178 value_perfarm
replace value_perfarm = value_perfarm*1000
rename var179 value_peracre
rename var121 mfgestab
rename var124 mfgavear
rename var128 mfgwages
replace mfgwages=mfgwages*1000000
replace mfgavear=mfgavear*100
gen value_landbuildings_perfarm = value_perfarm*farms
gen value_landbuildings_peracre = value_peracre*farmland
gen year = 1970
sort fips
save `icpsr1970', replace
clear

use "../data/usag1969.cos.crops.dta", clear
rename stateicp state
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips item101 item119 item122 item113 item175 item187 item742 item744 item401 item419 item422 item413 item475 item487
rename item101 corn_a
rename item119 oats_a
rename item122 rice_a
rename item113 wheat_a
rename item175 cotton_a
rename item187 scane_a
rename item742 horses
rename item744 mules_horses
rename item401 corn_y
rename item413 wheat_y
rename item419 oats_y
rename item422 rice_y
rename item475 cotton_y
rename item487 scane_y
foreach var of varlist corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = 0 if `var'==.
}
sort fips
save `ag1969', replace

use "../data/usag74.1969.allfarms.work.dta", clear
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
keep fips item06002 item06019 item06022 item01001 item02004 item02007 item02010 item02005 item02008 item02011
rename item01001 farms
rename item06002 farmequi
replace farmequi = farmequi*1000
rename farmequi value_equipment
rename item06019 tractors_wheel
rename item06022 tractors_crawler
gen farms_owner = item02004 + item02007
gen farms_tenant = item02010
gen farmland_owner = item02005 + item02008
gen farmland_tenant = item02011
sort fips
merge fips using `ag1969'
keep if _merge==3
drop _merge
sort fips
merge fips using `icpsr1970'
keep if _merge==3
drop _merge
order fips population population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings_peracre value_landbuildings_perfarm value_equipment horses mules_horses tractors_wheel tractors_crawler corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y
keep fips population population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings_peracre value_landbuildings_perfarm value_equipment horses mules_horses tractors_wheel tractors_crawler corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y
sort fips
save `1970', replace
clear


*Adjust for country border changes

insheet using "../data/Export1910_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1910'
keep if _merge==3
drop _merge
foreach var of varlist county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval{
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval, by(id_1)
foreach var of varlist county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval {
replace `var' = . if `var' < 0
}
gen year=1910
save `flood1910_1900', replace
clear

insheet using "../data/Export1920_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1920'
keep if _merge==3
drop _merge
foreach var of varlist county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval people samecounty samestate samearea sameregion people_white samecounty_white samestate_white samearea_white sameregion_white people_black samecounty_black samestate_black samearea_black sameregion_black mfgwages mfgestab mfgavear{
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval people samecounty samestate samearea sameregion people_white samecounty_white samestate_white samearea_white sameregion_white people_black samecounty_black samestate_black samearea_black sameregion_black mfgwages mfgestab mfgavear, by(id_1)
foreach var of varlist county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval people samecounty samestate samearea sameregion people_white samecounty_white samestate_white samearea_white sameregion_white people_black samecounty_black samestate_black samearea_black sameregion_black mfgwages mfgestab mfgavear{
replace `var' = . if `var' < 0
}
gen year=1920
save `flood1920_1900', replace
clear

insheet using "../data/Export1930_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1930'
keep if _merge==3
drop _merge
foreach var of varlist county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y horses mules tractors flooded_acres pop_affected agricultural_flooded_acres in_people in_samecounty in_samestate in_samearea in_sameregion in_people_white in_samecounty_white in_samestate_white in_samearea_white in_sameregion_white in_people_black in_samecounty_black in_samestate_black in_samearea_black in_sameregion_black cropval mfgwages mfgestab mfgavear{
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y horses mules tractors flooded_acres pop_affected agricultural_flooded_acres in_people in_samecounty in_samestate in_samearea in_sameregion in_people_white in_samecounty_white in_samestate_white in_samearea_white in_sameregion_white in_people_black in_samecounty_black in_samestate_black in_samearea_black in_sameregion_black cropval mfgwages mfgestab mfgavear, by(id_1)
foreach var of varlist county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y horses mules tractors flooded_acres pop_affected agricultural_flooded_acres in_people in_samecounty in_samestate in_samearea in_sameregion in_people_white in_samecounty_white in_samestate_white in_samearea_white in_sameregion_white in_people_black in_samecounty_black in_samestate_black in_samearea_black in_sameregion_black cropval mfgwages mfgestab mfgavear{
replace `var' = . if `var' < 0
}
gen year=1930
save `flood1930_1900', replace
clear

insheet using "../data/Export1940_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1940'
keep if _merge==3
drop _merge
foreach var of varlist county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval{
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval, by(id_1)
foreach var of varlist county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_land value_buildings value_equipment mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval{
replace `var' = . if `var' < 0
}
gen year=1940
save `flood1940_1900', replace
clear

insheet using "../data/Export1950_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1950'
keep if _merge==3
drop _merge
foreach var of varlist county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval{
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval, by(id_1)
foreach var of varlist county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval {
replace `var' = . if `var' < 0
}
gen year=1950
save `flood1950_1900', replace
clear

insheet using "../data/Export1960_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1960'
keep if _merge==3
drop _merge
foreach var of varlist population population_rural population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval{
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) population population_rural population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval, by(id_1)
foreach var of varlist population population_rural population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y cropval{
replace `var' = . if `var' < 0
}
gen year=1960
save `flood1960_1900', replace
clear


insheet using "../data/Export1970_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1970'
keep if _merge==3
drop _merge
foreach var of varlist population population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings_peracre value_landbuildings_perfarm value_equipment horses mules_horses tractors_wheel tractors_crawler corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y{
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) population population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings_peracre value_landbuildings_perfarm value_equipment horses mules_horses tractors_wheel tractors_crawler corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y, by(id_1)
foreach var of varlist population population_race_white population_race_black population_race_other farms farms_owner farms_tenant farmland farmland_owner farmland_tenant value_landbuildings_peracre value_landbuildings_perfarm value_equipment horses mules_horses tractors_wheel tractors_crawler corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y{
replace `var' = . if `var' < 0
}
gen year=1970
save `flood1970_1900', replace
clear

*1925 border adjustment
insheet using "../data/Export1920_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1925'
keep if _merge==3
drop _merge
foreach var of varlist farms farmland value_landbuildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y tractors{
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) farms farmland value_landbuildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y tractors, by(id_1)
foreach var of varlist farms farmland value_landbuildings value_equipment horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y tractors{
replace `var' = . if `var' < 0
}
gen year = 1925
save `flood1925_1900', replace
clear

*1935 border adjustment
insheet using "../data/Export1930_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1935'
keep if _merge==3
drop _merge
foreach var of varlist farms farmland value_landbuildings horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) farms farmland value_landbuildings horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y, by(id_1)
foreach var of varlist farms farmland value_landbuildings horses mules corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = . if `var' < 0
}
gen year = 1935
save `flood1935_1900', replace
clear

*1945 border adjustment
insheet using "../data/Export1940_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1945'
keep if _merge==3
drop _merge
foreach var of varlist farms farmland value_landbuildings tractors {
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) farms farmland value_landbuildings tractors, by(id_1)
foreach var of varlist farms farmland value_landbuildings tractors {
replace `var' = . if `var' < 0
}
gen year = 1945
save `flood1945_1900', replace
clear

*1954 border adjustment
insheet using "../data/Export1950_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1954'
keep if _merge==3
drop _merge
foreach var of varlist farms farmland value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) farms farmland value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y, by(id_1)
foreach var of varlist farms farmland value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses tractors corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = . if `var' < 0
}
gen year = 1954
save `flood1954_1900', replace
clear

*1964 border adjustment
insheet using "../data/Export1960_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using `1964'
keep if _merge==3
drop _merge
foreach var of varlist farms farmland value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) farms farmland value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y, by(id_1)
foreach var of varlist farms farmland value_landbuildings_peracre value_landbuildings_perfarm horses mules_horses corn_a oats_a wheat_a cotton_a rice_a scane_a corn_y oats_y wheat_y cotton_y rice_y scane_y {
replace `var' = . if `var' < 0
}
gen year = 1964
save `flood1964_1900', replace
clear

*Prepare flooded share
insheet using "../data/flooded_1900.txt", tab
collapse (sum) new_area (mean) area, by(fips)
gen flooded_share = new_area/area
sort fips
save `flood_1900', replace
clear

*Prepare distance to flooded area data
insheet using "../data/distance_1900.txt", tab
sort fips
save `distance_1900', replace
clear all

*Prepare distance to MS data
insheet using "../data/ms_distance.txt", tab
sort fips distance_ms
by fips: gen n = [_n]
drop if n==2
drop n
save `ms_distance', replace
clear

*Prepare ruggedness
use "../data/1900_strm_distance_gaez.dta"
keep fips altitude_std_meters altitude_range_meters
drop if fips==0
sort fips
save `ruggedness_1900', replace
clear

*Prepare plantation
insheet using "../data/Export1910_1900.txt", tab
keep if state==state_1
gen percent = new_area/area
rename id fips
sort fips
merge fips using "../data/brannenplantcounties_1910.dta"
keep if _merge==3
drop _merge
foreach var of varlist Brannen_Plantation{
replace `var' = `var'*percent
replace `var' = -100000000000000000000000 if `var'==.&percent>0.01
}
collapse (sum) Brannen_Plantation, by(id_1)
foreach var of varlist Brannen_Plantation{
replace `var' = . if `var' < 0
}
rename id_1 fips
keep fips Brannen_Plantation
sort fips
save `brannenplantcounties_1900',replace
clear

*Prepare New Deal Data
use "../data/new_deal_spending.dta", clear
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
drop if mod(county,1000)==0
sort state county
merge state county using "../data/icpsr_fips.dta"
keep if _merge==3
keep fips pc*
sort fips
save `new_deal_data', replace

*Prepare distance to major river
use "../data/1900_strm_distance.dta"
keep fips Distance_Major_River_Meters
gen fips_state = floor(fips/1000)
keep if fips_state==5|fips_state==22|fips_state==28|fips_state==47|fips_state==1|fips_state==13|fips_state==37|fips_state==45|fips_state==12
gen distance_river = Distance_Major_River_Meters/1000
order fips distance_river
keep fips distance_river
sort fips
save `river_1900', replace
clear

*Prepare crop suitability
use "../data/1900_strm_distance_gaez.dta"
keep fips cottongaezprod_mean maizegaezprod_mean wheatgaezprod_mean ricegaezprod_mean oatgaezprod_mean sugargaezprod_mean
drop if fips==0
rename cottongaezprod_mean cotton_suitability
rename maizegaezprod_mean corn_suitability
rename wheatgaezprod_mean wheat_suitability
rename ricegaezprod_mean rice_suitability
rename oatgaezprod_mean oats_suitability
rename sugargaezprod_mean scane_suitability
sort fips
save `crop_suitability', replace
clear

*Append all files
use `1900', clear
rename fips id_1
append using `flood1910_1900'
append using `flood1920_1900'
append using `flood1925_1900'
append using `flood1930_1900'
append using `flood1935_1900'
append using `flood1940_1900'
append using `flood1945_1900'
append using `flood1950_1900'
append using `flood1954_1900'
append using `flood1960_1900'
append using `flood1964_1900'
append using `flood1970_1900'
rename id_1 fips
sort fips
merge fips using `flood_1900'
drop if _merge==2
drop _merge
sort fips
merge fips using `distance_1900'
drop _merge
sort fips year
by fips: replace state = sum(state)
by fips: replace county = sum(county)
by fips: replace name = name[_n-1] if name[_n-1]!=""
by fips: replace x_centroid = x_centroid[_n-1] if x_centroid[_n-1]!=.
by fips: replace y_centroid = y_centroid[_n-1] if y_centroid[_n-1]!=.
keep if state==32|state==34|state==40|state==41|state==42|state==43|state==44|state==45|state==46|state==47|state==48|state==49|state==51|state==52|state==53|state==54
sort fips year
order fips year state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm value_land value_buildings value_equipment cropval horses mules mules_horses tractors tractors_wheel tractors_crawler cotton_a corn_a oats_a wheat_a rice_a scane_a cotton_y corn_y oats_y wheat_y rice_y scane_y flooded_share distance x_centroid y_centroid flooded_acres pop_affected agricultural_flooded_acres people samecounty samestate samearea sameregion people_white samecounty_white samestate_white samearea_white sameregion_white people_black samecounty_black samestate_black samearea_black sameregion_black in_people in_samecounty in_samestate in_samearea in_sameregion in_people_white in_samecounty_white in_samestate_white in_samearea_white in_sameregion_white in_people_black in_samecounty_black in_samestate_black in_samearea_black in_sameregion_black mfgwages mfgestab mfgavear
keep fips year state county name county_acres county_squaremiles population population_rural population_race_white population_race_black population_race_other farms farms_white farms_nonwhite farms_nonwhite_tenant farms_owner farms_tenant farms_tenant_cash farmland farmland_owner farmland_tenant value_landbuildings value_landbuildings_peracre value_landbuildings_perfarm value_land value_buildings value_equipment cropval horses mules mules_horses tractors tractors_wheel tractors_crawler cotton_a corn_a oats_a wheat_a rice_a scane_a cotton_y corn_y oats_y wheat_y rice_y scane_y flooded_share distance x_centroid y_centroid flooded_acres pop_affected agricultural_flooded_acres people samecounty samestate samearea sameregion people_white samecounty_white samestate_white samearea_white sameregion_white people_black samecounty_black samestate_black samearea_black sameregion_black in_people in_samecounty in_samestate in_samearea in_sameregion in_people_white in_samecounty_white in_samestate_white in_samearea_white in_sameregion_white in_people_black in_samecounty_black in_samestate_black in_samearea_black in_sameregion_black mfgwages mfgestab mfgavear

replace value_landbuildings = (value_landbuildings_peracre + value_landbuildings_perfarm) / 2 if value_landbuildings_peracre!=.&value_landbuildings_perfarm!=.
drop value_landbuildings_peracre value_landbuildings_perfarm
replace mules_horses = horses+mules if horses!=.&mules!=.&mules_horses==.
replace tractors = tractors_wheel if tractors_wheel!=.
drop tractors_wheel tractors_crawler

sort fips year
merge fips using `crop_suitability'
tab _merge
drop if _merge==2
drop _merge
sort fips year
merge fips using `ms_distance'
drop _merge
sort fips year
merge fips using `ruggedness_1900'
drop if _merge==2
drop _merge
sort fips year
merge fips using `river_1900'
drop if _merge==2
drop _merge
sort fips year
merge fips using `brannenplantcounties_1900'
drop if _merge==2
drop _merge
sort fips
merge fips using `new_deal_data'
sort fips year
compress
save flood_base1900.dta, replace 

log close
