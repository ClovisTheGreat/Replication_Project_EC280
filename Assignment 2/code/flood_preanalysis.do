
clear all
set mem 200m
set matsize 800
set more off
capture log close
log using flood_preanalysis.log, replace

*Import data
use flood_base1900.dta

*ID variables
gen statefips=floor(fips/1000)
keep if statefips==5|statefips==22|statefips==28|statefips==47|statefips==1|statefips==13|statefips==37|statefips==45|statefips==12
tab statefips, gen(d_s_)
gen double state_year = statefips*10000+year
tab state_year, gen(d_sy_)
tab year, gen(d_year_)

*Generate county weight
gen county_1920 = county_acres if year==1920
sort fips
by fips: egen county_w = max(county_1920)
drop county_1920

*Outcome variables
rename population_race_black population_black
rename population_race_white population_white
rename value_landbuildings value_lb

gen lnpopulation_black = ln(population_black)
gen lnpopulation = ln(population)
gen frac_black = (population_black)/(population_white+population_black)
gen lnfrac_black = ln(frac_black)
gen fracfarms_nonwhite =farms_nonwhite/farms
gen lnfracfarms_nonwhite =log(farms_nonwhite/farms)

gen lnvalue_equipment = ln(value_equipment)
gen avfarmsize = (farmland/farms)
gen lnavfarmsize = ln(avfarmsize)
gen lnlandbuildingvalue = ln(value_lb)
gen lnlandbuildingvaluef = ln(value_lb/farmland)
gen lnlandvaluef = ln(value_land/farmland)
gen lnlandvalue = ln(value_land)
gen lnfarmland = ln(farmland)
gen lnfarms_nonwhite_t = ln(farms_nonwhite_tenant/farms_tenant)

gen lnmules_horses = ln(mules_horses)
gen lntractors = ln(tractors)
gen tractorsperfarm = tractors/farms
gen lntractorsperfarm = log(tractors/farms)
gen cropland = corn_a + wheat_a + oats_a + rice_a + cotton_a + scane_a
gen cotton_cc = cotton_a / (cotton_a + corn_a)
gen lncotton_yield = ln(cotton_y/cotton_a)
gen lncorn_yield = ln(corn_y/corn_a)

gen lncropval_p = ln(cropval/population)
gen lncropval_rp = ln(cropval/population_rural)

gen mfgavewages= mfgwages/mfgavear
gen lnmfgestab = log(mfgestab)
gen lnmfgavewages= log(mfgavewages)
gen lnmfgavear= log(mfgavear)


foreach var of varlist population population_black tractorsperfarm value_equipment farmland value_lb tractors mules_horses mfgwages mfgavewages mfgestab {
gen ln`var'_a = ln(`var'/county_w)
}
foreach var of varlist population population_black value_equipment value_lb tractors mules_horses farmland cropland cotton_a corn_a rice_a scane_a oats_a wheat_a {
gen `var'_a = (`var'*100)/county_w
}
foreach var of varlist avfarmsize {
gen `var'_a = `var'/county_w
}
foreach var of varlist value_lb {
gen `var'_f = (`var'*100)/farmland
gen ln`var'_f = ln(`var'/farmland)
}

*Balance panel
gen drop = 0
replace drop = 1 if lnpopulation==.&(year==1900|year==1910|year==1920|year==1930|year==1940|year==1950|year==1960|year==1970)
replace drop = 1 if lnpopulation_black==.&(year==1900|year==1910|year==1920|year==1930|year==1940|year==1950|year==1960|year==1970)
replace drop = 1 if lnvalue_lb_a==.&(year==1900|year==1910|year==1920|year==1925|year==1930|year==1935|year==1940|year==1945|year==1950|year==1954|year==1960|year==1964|year==1970)
replace drop = 1 if lnvalue_equipment==.&(year==1900|year==1910|year==1920|year==1925|year==1930|year==1940|year==1970)
replace drop = 1 if cropland==.&(year==1900|year==1910|year==1920|year==1925|year==1930|year==1935|year==1940|year==1950|year==1954|year==1960|year==1964|year==1970)
sort fips year
by fips: egen drop_county = max(drop)
drop if drop_county==1
drop drop_county
sort fips year
by fips: gen number = [_N]
drop if number<13&(state == 42 | state==45 | state==46 | state==54)
drop if number<12
drop number

gen drop_tractors = 0
replace drop_tractors = 1 if lntractors==.&year==1925
sort fips year
by fips: egen balance_tractors = max(drop_tractors)
replace lntractors_a = . if balance_tractors==1
replace lntractors = . if balance_tractors==1
replace tractors_a = . if balance_tractors==1
replace tractors = . if balance_tractors==1

*Minimal matching variables
gen cotton_c = cotton_a/cropland if year==1920

*restrict sample
drop if frac_black < 0.10 & year==1920
drop if cotton_c < 0.15 & year==1920
drop cotton_c
sort fips year
by fips: gen number = [_N]
keep if number==13
drop number
drop if fips == 47149|fips==47071|fips==22023

*Flood variables
rename flooded_share percent_flood
replace percent_flood = 0 if percent_flood==.
gen flood = (percent_flood>0)
sum percent_flood if flood==1&year==1930
gen flood_intensity = (percent_flood)*flood
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen f_int_`i' = 0
replace f_int_`i' = flood_intensity if year==`i'
}

*Red cross flood variables
gen redcross_flooded_acres = flooded_acres/county_w if year==1930
replace redcross_flooded_acres = 0 if redcross_flooded_acres==.&year==1930
regress flood_intensity redcross_flooded_acres

gen redcross_flooded_people = pop_affected/population if year==1930
replace redcross_flooded_people = 0 if redcross_flooded_people==.&year==1930
regress flood_intensity redcross_flooded_people

gen redcross_flooded_acres_ag = agricultural_flooded_acres/farmland if year==1930
replace redcross_flooded_acres_ag = 0 if redcross_flooded_acres_ag==.&year==1930
regress flood_intensity redcross_flooded_acres_ag

sort fips year
by fips: egen flood_intensity_2 = max(redcross_flooded_acres)
by fips: egen flood_intensity_3 = max(redcross_flooded_people)
by fips: egen flood_intensity_4 = max(redcross_flooded_acres_ag)
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen f2_int_`i' = 0
replace f2_int_`i' = flood_intensity_2 if year==`i'
}
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen f3_int_`i' = 0
replace f3_int_`i' = flood_intensity_3 if year==`i'
}
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen f4_int_`i' = 0
replace f4_int_`i' = flood_intensity_4 if year==`i'
}

*Distance to MS river
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen ld_`i' = 0
replace ld_`i' = distance_ms if year==`i'
}

*Crop suitability
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
foreach j in cotton corn wheat oats rice scane {
gen `j'_s_`i' = 0
replace `j'_s_`i' = `j'_suitability if year==`i'
}
}

*Longitude and latitude
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen dx_`i' = 0
replace dx_`i' = x_centroid/1000 if year==`i'
gen dy_`i' = 0
replace dy_`i' = y_centroid/1000 if year==`i'
}

*Ruggedness
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen rug_`i' = 0
replace rug_`i' = altitude_std_meters if year==`i'
gen rug2_`i' = 0
replace rug2_`i' = altitude_range_meters if year==`i'
}

*Plantation
gen plantation = 0
replace plantation = 1 if Brannen_Plantation > 0.5
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen plantation_`i' = 0
replace plantation_`i' = plantation if year==`i'
}

*New Deal spending
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
foreach var of varlist pcpubwor pcaaa pcrelief pcndloan pcndins {
gen ln`var'_`i' = 0
replace ln`var'_`i' = ln(`var') if year==`i'
}
}

*Create county-level controls for lagged values of variables
/*lags for variables that exist in 1930, 1920 and 1910*/
sort fips year
foreach var of varlist lnpopulation lnpopulation_black lnfrac_black lnfarms_nonwhite_t lnfracfarms_nonwhite lnlandvalue lnlandvaluef {
by fips: gen c2_`var' = `var'[_n-2]
by fips: gen c3_`var' = `var'[_n-3]
by fips: gen c4_`var' = `var'[_n-4]
replace c2_`var' = . if year!=1930
replace c3_`var' = . if year!=1930
replace c4_`var' = . if year!=1930
by fips: egen lc1920_`var' = max(c2_`var')
by fips: egen lc1910_`var' = max(c3_`var')
by fips: egen lc1900_`var' = max(c4_`var')
drop c2_`var' c3_`var' c4_`var'
}
foreach i of numlist 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
foreach var of varlist lnpopulation lnpopulation_black lnfrac_black lnfarms_nonwhite_t lnfracfarms_nonwhite lnlandvalue lnlandvaluef{
gen lag2_`var'_`i' = 0
gen lag3_`var'_`i' = 0
gen lag4_`var'_`i' = 0
replace lag2_`var'_`i' = lc1920_`var' if year==`i'
replace lag3_`var'_`i' = lc1910_`var' if year==`i'
replace lag4_`var'_`i' = lc1900_`var' if year==`i'
}
}

/*lags for variables that exist only in 1920 and 1910*/

sort fips year
foreach var of varlist lncropval_p lncropval_rp {
by fips: gen c2_`var' = `var'[_n-2]
by fips: gen c3_`var' = `var'[_n-3]
replace c2_`var' = . if year!=1930
replace c3_`var' = . if year!=1930
by fips: egen lc1920_`var' = max(c2_`var')
by fips: egen lc1910_`var' = max(c3_`var')
drop c2_`var' c3_`var'
}
foreach i of numlist 1930 1940 1950 1960 {
foreach var of varlist lncropval_p lncropval_rp {
gen lag2_`var'_`i' = 0
gen lag3_`var'_`i' = 0
replace lag2_`var'_`i' = lc1920_`var' if year==`i'
replace lag3_`var'_`i' = lc1910_`var' if year==`i'
}
}

/*lags for variables that exist in 1925*/
sort fips year
foreach var of varlist lnvalue_equipment lntractors tractorsperfarm lntractorsperfarm lnmules_horses lnavfarmsize lnlandbuildingvalue lnlandbuildingvaluef lnfarmland_a cotton_a_a corn_a_a cotton_cc rice_a_a scane_a_a oats_a_a wheat_a_a lncotton_yield lncorn_yield {
by fips: gen c1_`var' = `var'[_n-1]
by fips: gen c2_`var' = `var'[_n-2]
by fips: gen c3_`var' = `var'[_n-3]
by fips: gen c4_`var' = `var'[_n-4]
replace c1_`var' = . if year!=1930
replace c2_`var' = . if year!=1930
replace c3_`var' = . if year!=1930
replace c4_`var' = . if year!=1930
by fips: egen lc1925_`var' = max(c1_`var')
by fips: egen lc1920_`var' = max(c2_`var')
by fips: egen lc1910_`var' = max(c3_`var')
by fips: egen lc1900_`var' = max(c4_`var')
drop c1_`var' c2_`var' c3_`var' c4_`var'
}
foreach i of numlist 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
foreach var of varlist lnvalue_equipment lntractors tractorsperfarm lntractorsperfarm lnmules_horses lnavfarmsize lnlandbuildingvalue lnlandbuildingvaluef lnfarmland_a cotton_a_a corn_a_a cotton_cc rice_a_a scane_a_a oats_a_a wheat_a_a lncotton_yield lncorn_yield {
gen lag1_`var'_`i' = 0
gen lag2_`var'_`i' = 0
gen lag3_`var'_`i' = 0
gen lag4_`var'_`i' = 0
replace lag1_`var'_`i' = lc1925_`var' if year==`i'
replace lag2_`var'_`i' = lc1920_`var' if year==`i'
replace lag3_`var'_`i' = lc1910_`var' if year==`i'
replace lag4_`var'_`i' = lc1900_`var' if year==`i'
}
}

sort fips year
foreach var of varlist lnmfgestab lnmfgavewages lnmfgavear {
by fips: gen c2_`var' = `var'[_n-2]
by fips: gen c4_`var' = `var'[_n-4]
replace c2_`var' = . if year!=1930
replace c4_`var' = . if year!=1930
by fips: egen lc1920_`var' = max(c2_`var')
by fips: egen lc1900_`var' = max(c4_`var')
*drop c2_`var' c4_`var'
}
foreach i of numlist 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
foreach var of varlist lnmfgestab lnmfgavewages lnmfgavear {
gen lag2_`var'_`i' = 0
gen lag4_`var'_`i' = 0
replace lag2_`var'_`i' = lc1920_`var' if year==`i'
replace lag4_`var'_`i' = lc1900_`var' if year==`i'
}
}

foreach var of varlist frac_black population_black_a population_a fracfarms_nonwhite {
by fips: gen ln`var'_d = ln`var'[_n]-ln`var'[_n-1] if year==1920
}

foreach var of varlist value_equipment_a mules_horses_a avfarmsize farmland_a value_lb_f value_lb_a {
by fips: gen ln`var'_d = ln`var'[_n]-ln`var'[_n-1] if year==1925

}

*Sample with counties within 150km of a major river
gen main_sample = 0
replace main_sample = 1 if (state == 42 | state==45 | state==46 | state==54)
gen riverclose_elsewhere = (distance_river < 50 & main_sample==0)
gen riverfar_elsewhere = (distance_river > 50 & distance_river < 150 & main_sample==0)
keep if main_sample==1|riverclose_elsewhere==1|riverfar_elsewhere==1
save preanalysis_south_rivers.dta, replace

*Main sample
keep if main_sample==1

*Generate propensity score
xi:probit flood lc*_lnfrac_black lc*_cotton_cc  if year ==1920
predict prop_plant_1920
egen prop_plant_flstate = mean(prop_plant_1920), by(fips)
drop prop_plant_1920
sum prop_plant_flstate if flood==1
gen com_support_flstate = (prop_plant_flstate>`r(min)' & prop_plant_flstate<`r(max)')  if flood==0
sum prop_plant_flstate if flood==0
replace com_support_flstate = (prop_plant_flstate>`r(min)' & prop_plant_flstate<`r(max)') if flood==1
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen prop_plant_flstate_`i' = 0
replace prop_plant_flstate_`i' = prop_plant_flstate if year==`i' & prop_plant_flstate >0 & prop_plant_flstate<1
}
save preanalysis.dta, replace

*Generate post-1930 sample
drop if year <1920
/*set all 1920 values equal to missing if 1925 values nonmissing*/
foreach var of varlist value_equipment mules_horses avfarmsize farmland avfarmsize farmland_a value_lb_f value_lb_a fracfarms_nonwhite {
	replace ln`var' =. if year ==1920 & ln`var'[_n+1] !=.
}
foreach var of varlist lnlandbuildingvalue lnlandbuildingvaluef lncropval_rp lncropval_p lnlandvalue lnlandvaluef lncotton_yield lncorn_yield{
	replace `var' =. if year ==1920 & `var'[_n+1] !=.
}
save preanalysis_post1930.dta, replace


log close
