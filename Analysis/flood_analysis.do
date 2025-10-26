clear all
set matsize 11000
set mem 1g
log using flood_analysis.log, replace


*Figure 2, aggregate changes
clear
use preanalysis.dta
foreach var of varlist lnpopulation lnpopulation_black lnvalue_equipment lnmules_horses lnavfarmsize lnlandbuildingvaluef {
reg `var' d_year_* [aweight = county_w], noc
}
collapse (mean) lnpopulation lnpopulation_black lnvalue_equipment lnmules_horses lnavfarmsize lnlandbuildingvaluef [aweight=county_w], by(year)

foreach var of varlist lnpopulation {
twoway (connected `var' year, ytitle("") ysize(4) xtitle(Year) xsize(5) xlabel(1900 1910 1920 1930 1940 1950 1960 1970) scheme(sj) graphregion(fcolor(white)) legend(off))
graph export Figures\\Figure2`var'_aggregate.tif, as(tif) replace
graph export Figures\\Figure2`var'_aggregate.eps, as(eps) replace
}

foreach var of varlist lnpopulation_black {
twoway (connected `var' year, ytitle("") ysize(4) xtitle(Year) xsize(5) ylabel(9 9.1 9.2 9.3 9.4) xlabel(1900 1910 1920 1930 1940 1950 1960 1970) scheme(sj) graphregion(fcolor(white)) legend(off))
graph export Figures\\Figure2`var'_aggregate.tif, as(tif) replace
graph export Figures\\Figure2`var'_aggregate.eps, as(eps) replace
}

foreach var of varlist lnvalue_equipment {
twoway (connected `var' year, ytitle("") ysize(4) xtitle(Year) xsize(5) xlabel(1900 1910 1920 1930 1940 1950 1960 1970) scheme(sj) graphregion(fcolor(white)) legend(off))
graph export Figures\\Figure2`var'_aggregate.tif, as(tif) replace
graph export Figures\\Figure2`var'_aggregate.eps, as(eps) replace
}

foreach var of varlist lnmules_horses {
twoway (connected `var' year, ytitle("") ysize(4) xtitle(Year) xsize(5) xlabel(1900 1910 1920 1930 1940 1950 1960 1970) scheme(sj) graphregion(fcolor(white)) legend(off))
graph export Figures\\Figure2`var'_aggregate.tif, as(tif) replace
graph export Figures\\Figure2`var'_aggregate.eps, as(eps) replace
}

foreach var of varlist lnavfarmsize {
twoway (connected `var' year, ytitle("") ysize(4) xtitle(Year) xsize(5) xlabel(1900 1910 1920 1930 1940 1950 1960 1970) scheme(sj) graphregion(fcolor(white)) legend(off))
graph export Figures\\Figure2`var'_aggregate.tif, as(tif) replace
graph export Figures\\Figure2`var'_aggregate.eps, as(eps) replace
}

foreach var of varlist lnlandbuildingvaluef {
twoway (connected `var' year, ytitle("") ysize(4) xtitle(Year) xsize(5) xlabel(1900 1910 1920 1930 1940 1950 1960 1970) scheme(sj) graphregion(fcolor(white)) legend(off))
graph export Figures\\Figure2`var'_aggregate.tif, as(tif) replace
graph export Figures\\Figure2`var'_aggregate.eps, as(eps) replace
}

*Figure 3 and 4 raw differences
clear 
set more off
use preanalysis.dta
tempfile tf1 tf2 
parmby  "areg lnfrac_black  f_int_1900  f_int_1910 f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  [aweight=county_w], absorb(fips) cluster(fips)", lab saving(`"`tf1'"',replace) idn(1) ids(Unadjusted)
parmby  "areg lnvalue_equipment  f_int_1900  f_int_1910 f_int_1920 f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  [aweight=county_w], absorb(fips) cluster(fips)", lab saving(`"`tf2'"',replace) idn(1) ids(Unadjusted)

clear all
set obs 1
gen year =1920
gen estimate = 0
gen parm ="f_int_1920"
gen min95 =0
gen max95 =0
append using `tf1'
keep if regexm(parm, "^f_int_*")
gen yearstr =substr(parm, -4,4)
destring yearstr, replace
sort yearstr
twoway (connected estimate  yearstr, msize(medium) mcolor(black)) (line min95  yearstr, lpattern(shortdash)) (line max95  yearstr, xsize(6) ysize(4) title("") xtitle(Year, size(medium)) ylabel(-0.4 -0.3 -0.2 -0.1 0 0.1 0.2, labsize(medium)) ytick(-0.4 -0.3 -0.2 -0.1 0 0.1 0.2, grid) xlabel(1900 1910 1920 1930 1940 1950 1960 1970, labsize(medium)) scheme(sj) graphregion(lcolor(black) fcolor(white)) legend(off) lpattern(shortdash))
graph export Figures\\Figure3_logblack_fraction_results.tiff, as(tif) replace
graph export Figures\\Figure3_logblack_fraction_results.eps, as(eps) replace

clear all
set obs 1
gen year =1925
gen estimate = 0
gen parm ="f_int_1925"
gen min95 =0
gen max95 =0
append using `tf2'
keep if regexm(parm, "^f_int_*")
gen yearstr =substr(parm, -4,4)
destring yearstr, replace
sort yearstr
twoway (connected estimate yearstr, msize(medium) mcolor(black)) (line min95 yearstr, lpattern(shortdash)) (line max95 yearstr, xsize(6) ysize(4) title("") xtitle(Year, size(medium)) ylabel(-0.3 0 0.3 0.6 0.9 1.2 1.5, labsize(medium)) ytick(-0.3 0 0.3 0.6 0.9 1.2 1.5, grid) xlabel(1900 1910 1920 1930 1940 1950 1960 1970, labsize(medium)) scheme(sj) graphregion(lcolor(black) fcolor(white)) legend(off) lpattern(shortdash))
graph export Figures\\Figure4_logcapital_results.tiff, as(tif) replace
graph export Figures\\Figure4_logcapital_results.eps, as(eps) replace


****************************

/***New Deal Controls will be used for all upcoming tables***/
global newdealcontrols lnpcpubwor_* lnpcaaa_* lnpcrelief_* lnpcndloan_* lnpcndins_*

*Table 1, pre-differences in 1920 and 1925
clear
set more off
use preanalysis.dta

eststo clear
foreach var of varlist frac_black population_black_a population_a fracfarms_nonwhite {
sum `var' if year==1920 [aweight=county_w]
reg ln`var' flood_intensity d_s_* if year==1920 [aweight=county_w], robust
sum `var' if year==1920 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
reg ln`var' flood_intensity d_s_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*    if year==1920 [aweight=county_w], robust
sum `var' if year==1920 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
reg ln`var'_d flood_intensity d_s_* if year==1920 [aweight=county_w], robust
sum `var' if year==1920 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
reg ln`var'_d flood_intensity d_s_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*   if year==1920 [aweight=county_w], robust
sum `var' if year==1920 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')

}

foreach var of varlist value_equipment_a mules_horses_a avfarmsize farmland_a value_lb_f value_lb_a {
reg ln`var' flood_intensity d_s_* if year==1925 [aweight=county_w], robust
sum `var' if year==1925 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
reg ln`var' flood_intensity d_s_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*    if year==1925 [aweight=county_w], robust
sum `var' if year==1925 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
reg ln`var'_d flood_intensity d_s_* if year==1925 [aweight=county_w], robust
sum `var' if year==1925 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
reg ln`var'_d flood_intensity d_s_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     if year==1925 [aweight=county_w], robust
sum `var' if year==1925 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
}

foreach var of varlist tractors_a {
reg ln`var' flood_intensity d_s_* if year==1925 [aweight=county_w], robust
sum `var' if year==1925 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
reg ln`var' flood_intensity d_s_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*   if year==1925 [aweight=county_w], robust
sum `var' if year==1925 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
}
esttab, keep(flood_intensity) stat(mean_ sd_ N) 
esttab using Tables\Table1.csv, stat(mean_ sd_ N) keep(flood_intensity) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace



*Table 2, Labor
clear
use preanalysis_post1930.dta
eststo clear
areg lnfrac_black f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag2_lnfrac_black_* lag3_lnfrac_black_* lag4_lnfrac_black_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnfrac_black f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag2_lnfrac_black_* lag3_lnfrac_black_* lag4_lnfrac_black_* $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation_black f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*    lag2_lnpopulation_black_* lag3_lnpopulation_black_* lag4_lnpopulation_black_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation_black f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*    lag2_lnpopulation_black_* lag3_lnpopulation_black_* lag4_lnpopulation_black_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag2_lnpopulation_1* lag3_lnpopulation_1* lag4_lnpopulation_1*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag2_lnpopulation_1* lag3_lnpopulation_1* lag4_lnpopulation_1* $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnfracfarms_nonwhite f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag2_lnfracfarms_nonwhite_1* lag3_lnfracfarms_nonwhite_1* lag4_lnfracfarms_nonwhite_1*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnfracfarms_nonwhite f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag2_lnfracfarms_nonwhite_1* lag3_lnfracfarms_nonwhite_1* lag4_lnfracfarms_nonwhite_1*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
esttab, keep( f_int_*)
esttab using Tables\Table2.csv, keep(f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01)  replace


*Migrant data
clear
global newdeal1930controls lnpcpubwor_1930 lnpcaaa_1930 lnpcrelief_1930 lnpcndloan_1930 lnpcndins_1930
global newdeal1920controls lnpcpubwor_1920 lnpcaaa_1920 lnpcrelief_1920 lnpcndloan_1920 lnpcndins_1920
use preanalysis.dta
/*gen total number of people in sample matched based on 1920 location*/
total  people people_black people_white
/*gen total number of people in sample matched based on 1930 location*/
total  in_people in_people_black in_people_white
eststo clear
foreach i in county state region { 
gen migrate_`i' = (people - same`i') / people
replace migrate_`i' = 0 if people==0
reg migrate_`i' f_int_1920   d_sy_* [aweight=people], robust
sum migrate_`i' [aweight=people] if f_int_1920 == 0
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
}
foreach j in black white {
foreach i in county state region { 
gen migrate_`i'_`j' = (people_`j' - same`i'_`j') / people_`j'
replace migrate_`i'_`j' = 0 if people_`j'==0
reg migrate_`i'_`j' f_int_1920    d_sy_* [aweight=people_`j'], robust
sum migrate_`i'_`j' if f_int_1920 == 0 [aweight=people_`j']
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
}
}
esttab, keep(f_int_1920)
esttab using Tables\Table3.csv, keep(f_int_1920) b(3) se(3) nogaps star(* 0.05 ** 0.01)  replace

*In migration data
clear
use preanalysis.dta
tsset fips year
replace people = L10.people if year ==1930 /*use 1920 population*/
foreach j in  white black{
	replace people_`j' = L10.people_`j' if year ==1930 /*use 1920 population*/
}
foreach i in county{ 
gen in_migrate_`i' = (in_people - in_same`i') / people
replace in_migrate_`i' = 0 if people==0
reg in_migrate_`i' f_int_1930   d_sy_* [aweight=people], robust
sum in_migrate_`i' [aweight=people] if f_int_1930 == 0
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
}

foreach j in white black {
foreach i in county { 
gen in_migrate_`i'_`j' = (in_people_`j' - in_same`i'_`j') /people_`j'
replace in_migrate_`i'_`j' = 0 if people_`j'==0
reg in_migrate_`i'_`j' f_int_1930 d_sy_* [aweight=people_`j'], robust
sum in_migrate_`i'_`j' [aweight=people_`j'] if f_int_1930 == 0
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
}
}
esttab, keep(f_int_1920 f_int_1930) stat(mean_ sd_ N)
esttab using Tables\Table3.csv, keep(f_int_1920 f_int_1930) b(3) se(3) nogaps star(* 0.05 ** 0.01) stat(mean_ sd_ N)  replace


*Table 4, Capital and Techniques
clear
use preanalysis_post1930.dta
eststo clear
areg lnavfarmsize f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lnavfarmsize_* lag2_lnavfarmsize_* lag3_lnavfarmsize_* lag4_lnavfarmsize_*   [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnavfarmsize f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lnavfarmsize_* lag2_lnavfarmsize_* lag3_lnavfarmsize_* lag4_lnavfarmsize_*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnvalue_equipment f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag1_lnvalue_equipment_* lag2_lnvalue_equipment_* lag3_lnvalue_equipment_* lag4_lnvalue_equipment_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo
areg lnvalue_equipment f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag1_lnvalue_equipment_* lag2_lnvalue_equipment_* lag3_lnvalue_equipment_* lag4_lnvalue_equipment_*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo
areg lntractors f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag1_lntractors_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lntractors f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag1_lntractors_*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnmules_horses f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lnmules_horses_* lag2_lnmules_horses_* lag3_lnmules_horses_* lag4_lnmules_horses_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo
areg lnmules_horses f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lnmules_horses_* lag2_lnmules_horses_* lag3_lnmules_horses_* lag4_lnmules_horses_*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo
esttab, keep(f_int_*)
esttab using Tables\Table4.csv, keep(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace


*Table 5, Farmland
clear
use preanalysis_post1930.dta
eststo clear
areg lnfarmland_a f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lnfarmland_a_* lag2_lnfarmland_a_* lag3_lnfarmland_a_* lag4_lnfarmland_a_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnfarmland_a f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lnfarmland_a_* lag2_lnfarmland_a_* lag3_lnfarmland_a_* lag4_lnfarmland_a_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvaluef f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lnlandbuildingvaluef_* lag2_lnlandbuildingvaluef_* lag3_lnlandbuildingvaluef_* lag4_lnlandbuildingvaluef_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvaluef f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lnlandbuildingvaluef_* lag2_lnlandbuildingvaluef_* lag3_lnlandbuildingvaluef_* lag4_lnlandbuildingvaluef_* $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvalue f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*   lag1_lnlandbuildingvalue_* lag2_lnlandbuildingvalue_* lag3_lnlandbuildingvalue_* lag4_lnlandbuildingvalue_*   [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvalue f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag1_lnlandbuildingvalue_* lag2_lnlandbuildingvalue_* lag3_lnlandbuildingvalue_* lag4_lnlandbuildingvalue_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
esttab, keep( f_int_*)
esttab using Tables\Table5.csv, keep(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace



*Extra tables: output/pop output/ruralpop landvalues landvalues/acre cotton_yields corn_yields
clear
use preanalysis_post1930.dta
eststo clear
areg lncotton_yield f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*    lag1_lncotton_yield_* lag2_lncotton_yield_* lag3_lncotton_yield_* lag4_lncotton_yield_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lncotton_yield f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lncotton_yield_* lag2_lncotton_yield_* lag3_lncotton_yield_* lag4_lncotton_yield_*   $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lncorn_yield f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*    lag1_lncorn_yield_* lag2_lncorn_yield_* lag3_lncorn_yield_* lag4_lncorn_yield_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lncorn_yield f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*     lag1_lncorn_yield_* lag2_lncorn_yield_* lag3_lncorn_yield_* lag4_lncorn_yield_*   $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lncropval_p f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag2_lncropval_p_* lag3_lncropval_p_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lncropval_p f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag2_lncropval_p_* lag3_lncropval_p_*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo
areg lncropval_rp f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag2_lncropval_rp_* lag3_lncropval_rp_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lncropval_rp f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag2_lncropval_rp_* lag3_lncropval_rp_*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo
areg lnlandvalue f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag2_lnlandvalue_* lag3_lnlandvalue_* lag4_lnlandvalue_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandvalue f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag2_lnlandvalue_* lag3_lnlandvalue_* lag4_lnlandvalue_*  $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandvaluef f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag2_lnlandvaluef_* lag3_lnlandvaluef_* lag4_lnlandvaluef_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandvaluef f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*      lag2_lnlandvaluef_* lag3_lnlandvaluef_* lag4_lnlandvaluef_*  $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
esttab, keep( f_int_*)
esttab using Tables\AdditionalTable.csv, keep(f_int_1930 f_int_1935 f_int_1940 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace


*Table 6, Compare riverclose to riverfar if main_sample==0 (standard specifications)
clear
use preanalysis_south_rivers.dta
keep if main_sample==0
sort fips year
drop if year <1920
foreach var of varlist value_equipment_a mules_horses_a avfarmsize farmland_a value_lb_f value_lb_a {
	replace ln`var' =. if year ==1920 &ln`var'[_n+1] !=.
}

foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen r_close_`i' = 0
replace r_close_`i' = riverclose_elsewhere if year==`i'
}
eststo clear
areg lnfrac_black r_close_1930 r_close_1940 r_close_1950 r_close_1960 r_close_1970 d_sy_* lag2_lnfrac_black_* lag3_lnfrac_black_* lag4_lnfrac_black_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation_black r_close_1930 r_close_1940 r_close_1950 r_close_1960 r_close_1970 d_sy_* lag2_lnpopulation_black_* lag3_lnpopulation_black_* lag4_lnpopulation_black_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation r_close_1930 r_close_1940 r_close_1950 r_close_1960 r_close_1970 d_sy_* lag2_lnpopulation_* lag3_lnpopulation_* lag4_lnpopulation_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
*eststo 
areg lnfracfarms_nonwhite r_close_1930 r_close_1940 r_close_1950 r_close_1960 r_close_1970 d_sy_*  lag2_lnfracfarms_nonwhite_1* lag3_lnfracfarms_nonwhite_1* lag4_lnfracfarms_nonwhite_1* [aweight=county_w], absorb(fips) cluster(fips)
eststo
areg lnvalue_equipment r_close_1930 r_close_1935 r_close_1940 r_close_1945 r_close_1950 r_close_1954 r_close_1960 r_close_1964 r_close_1970 d_sy_*  lag1_lnvalue_equipment_* lag2_lnvalue_equipment_* lag3_lnvalue_equipment_* lag4_lnvalue_equipment_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lntractors r_close_1930 r_close_1935 r_close_1940 r_close_1945 r_close_1950 r_close_1954 r_close_1960 r_close_1964 r_close_1970 d_sy_* lag1_lntractors_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
eststo
areg lnmules_horses r_close_1930 r_close_1935 r_close_1940 r_close_1945 r_close_1950 r_close_1954 r_close_1960 r_close_1964 r_close_1970 d_sy_* lag1_lnmules_horses_* lag2_lnmules_horses_* lag3_lnmules_horses_* lag4_lnmules_horses_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
*eststo
areg lnavfarmsize r_close_1930 r_close_1935 r_close_1940 r_close_1945 r_close_1950 r_close_1954 r_close_1960 r_close_1964 r_close_1970 d_sy_* lag1_lnavfarmsize_* lag2_lnavfarmsize_* lag3_lnavfarmsize_* lag4_lnavfarmsize_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnfarmland_a r_close_1930 r_close_1935 r_close_1940 r_close_1945 r_close_1950 r_close_1954 r_close_1960 r_close_1964 r_close_1970 d_sy_* lag1_lnfarmland_a_* lag2_lnfarmland_a_* lag3_lnfarmland_a_* lag4_lnfarmland_a_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvaluef r_close_1930 r_close_1935 r_close_1940 r_close_1945 r_close_1950 r_close_1954 r_close_1960 r_close_1964 r_close_1970 d_sy_* lag1_lnlandbuildingvaluef_* lag2_lnlandbuildingvaluef_* lag3_lnlandbuildingvaluef_* lag4_lnlandbuildingvaluef_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvalue r_close_1930 r_close_1935 r_close_1940 r_close_1945 r_close_1950 r_close_1954 r_close_1960 r_close_1964 r_close_1970 d_sy_* lag1_lnlandbuildingvalue_* lag2_lnlandbuildingvalue_* lag3_lnlandbuildingvalue_* lag4_lnlandbuildingvalue_* if main_sample==0 [aweight=county_w], absorb(fips) cluster(fips)
*eststo
esttab, keep( r_close_*)
esttab using Tables\Table6.csv, keep(r_close_1930 r_close_1935 r_close_1940 r_close_1945 r_close_1950 r_close_1954 r_close_1960 r_close_1964 r_close_1970) order(r_close_1930 r_close_1935 r_close_1940 r_close_1945 r_close_1950 r_close_1954 r_close_1960 r_close_1964 r_close_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace


*Auxillary to Table 6: pre-differences in riverclose vs river far
clear
set more off
use preanalysis_south_rivers.dta
keep if main_sample==0
sort fips year

eststo clear
foreach var of varlist frac_black population_black_a population_a fracfarms_nonwhite {
sum `var' if year==1920 [aweight=county_w]
reg ln`var' riverclose_elsewhere d_s_* if year==1920 [aweight=county_w], robust
sum `var' if year==1920 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
reg ln`var'_d riverclose_elsewhere d_s_* if year==1920 [aweight=county_w], robust
sum `var' if year==1920 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
}

foreach var of varlist value_equipment_a mules_horses_a avfarmsize farmland_a value_lb_f value_lb_a {
reg ln`var' riverclose_elsewhere d_s_* if year==1925 [aweight=county_w], robust
sum `var' if year==1925 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
reg ln`var'_d riverclose_elsewhere d_s_* if year==1925 [aweight=county_w], robust
sum `var' if year==1925 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
}

foreach var of varlist tractors_a {
reg ln`var' riverclose_elsewhere d_s_* if year==1925 [aweight=county_w], robust
sum `var' if year==1925 [aweight=county_w]
eststo, add(mean_ `r(mean)' sd_ -1*`r(sd)')
}
esttab, keep(riverclose_elsewhere) stat(mean_ sd_ N) 
esttab using Tables\Table6_predifferences.csv, stat(mean_ sd_ N) keep(riverclose_elsewhere) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace


* Table 7, Compare nearby non-flooded counties to further non-flooded counties
clear
use preanalysis.dta
keep if percent_flood==0
foreach i of numlist 1900 1910 1920 1925 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen f_dis_`i' = 0
replace f_dis_`i' = -1*(distance/100000) if year==`i'
}
eststo clear
areg lnfrac_black f_dis_1930 f_dis_1940 f_dis_1950 f_dis_1960 f_dis_1970 d_sy_* lag2_lnfrac_black_* lag3_lnfrac_black_* lag4_lnfrac_black_* [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation_black f_dis_1930 f_dis_1940 f_dis_1950 f_dis_1960 f_dis_1970 d_sy_* lag2_lnpopulation_black_* lag3_lnpopulation_black_* lag4_lnpopulation_black_* [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation f_dis_1930 f_dis_1940 f_dis_1950 f_dis_1960 f_dis_1970 d_sy_* lag2_lnpopulation_* lag3_lnpopulation_* lag4_lnpopulation_* [aweight=county_w], absorb(fips) cluster(fips)
*eststo 
areg lnfracfarms_nonwhite f_dis_1930 f_dis_1940 f_dis_1950 f_dis_1960 f_dis_1970 d_sy_*  lag2_lnfracfarms_nonwhite_1* lag3_lnfracfarms_nonwhite_1* lag4_lnfracfarms_nonwhite_1* [aweight=county_w], absorb(fips) cluster(fips)
eststo
areg lnvalue_equipment f_dis_1930 f_dis_1935 f_dis_1940 f_dis_1945 f_dis_1950 f_dis_1954 f_dis_1960 f_dis_1964 f_dis_1970 d_sy_*  lag1_lnvalue_equipment_* lag2_lnvalue_equipment_* lag3_lnvalue_equipment_* lag4_lnvalue_equipment_* [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lntractors f_dis_1930 f_dis_1935 f_dis_1940 f_dis_1945 f_dis_1950 f_dis_1954 f_dis_1960 f_dis_1964 f_dis_1970 d_sy_* lag1_lntractors_*  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnmules_horses f_dis_1930 f_dis_1935 f_dis_1940 f_dis_1945 f_dis_1950 f_dis_1954 f_dis_1960 f_dis_1964 f_dis_1970 d_sy_* lag1_lnmules_horses_* lag2_lnmules_horses_* lag3_lnmules_horses_* lag4_lnmules_horses_* [aweight=county_w], absorb(fips) cluster(fips)
*eststo
areg lnavfarmsize f_dis_1930 f_dis_1935 f_dis_1940 f_dis_1945 f_dis_1950 f_dis_1954 f_dis_1960 f_dis_1964 f_dis_1970 d_sy_* lag1_lnavfarmsize_* lag2_lnavfarmsize_* lag3_lnavfarmsize_* lag4_lnavfarmsize_* [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnfarmland_a f_dis_1930 f_dis_1935 f_dis_1940 f_dis_1945 f_dis_1950 f_dis_1954 f_dis_1960 f_dis_1964 f_dis_1970 d_sy_* lag1_lnfarmland_a_* lag2_lnfarmland_a_* lag3_lnfarmland_a_* lag4_lnfarmland_a_* [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvaluef f_dis_1930 f_dis_1935 f_dis_1940 f_dis_1945 f_dis_1950 f_dis_1954 f_dis_1960 f_dis_1964 f_dis_1970 d_sy_* lag1_lnlandbuildingvaluef_* lag2_lnlandbuildingvaluef_* lag3_lnlandbuildingvaluef_* lag4_lnlandbuildingvaluef_* [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvalue f_dis_1930 f_dis_1935 f_dis_1940 f_dis_1945 f_dis_1950 f_dis_1954 f_dis_1960 f_dis_1964 f_dis_1970 d_sy_* lag1_lnlandbuildingvalue_* lag2_lnlandbuildingvalue_* lag3_lnlandbuildingvalue_* lag4_lnlandbuildingvalue_* [aweight=county_w], absorb(fips) cluster(fips)
*eststo
esttab, keep( f_dis_*)
esttab using Tables\Table7.csv, keep(f_dis_1930 f_dis_1935 f_dis_1940 f_dis_1945 f_dis_1950 f_dis_1954 f_dis_1960 f_dis_1964 f_dis_1970) order(f_dis_1930 f_dis_1935 f_dis_1940 f_dis_1945 f_dis_1950 f_dis_1954 f_dis_1960 f_dis_1964 f_dis_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace






**********
*Robustness Tables 1 - 3
*Order of Specifications: lagged DV, + geography, +geograph+tenant+mfg, + newdeal+ geography, +newdeal + geography+ plantation, +newdeal+geography+tenant+mfg, +newdeal+geography+tenant+mfg + prop_score
**********
clear
use preanalysis.dta
eststo clear
foreach var of varlist lnfrac_black lnpopulation_black lnfracfarms_nonwhite lnpopulation{
	areg `var' f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_*  lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag*_lnmfgavewages_*   lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* $newdealcontrols cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* $newdealcontrols plantation_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag*_lnmfgavewages_*   lag2_`var'_1* lag3_`var'_1* lag4_`var'_1* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag*_lnmfgavewages_*   lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  prop_plant_flstate_1* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo

}
esttab using Tables\RefTable1.csv, keep(f_int_1930  f_int_1940 f_int_1950  f_int_1960  f_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace

eststo clear
foreach var of varlist lnavfarmsize lnvalue_equipment lnmules_horses{
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag1_`var'_* lag*_lnmfgavewages_*   lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* $newdealcontrols cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* $newdealcontrols plantation_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag1_`var'_* lag*_lnmfgavewages_*   lag2_`var'_1* lag3_`var'_1* lag4_`var'_1* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag1_`var'_* lag*_lnmfgavewages_*   lag2_`var'_1* lag3_`var'_1* lag4_`var'_1* prop_plant_flstate_1* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
esttab using Tables\RefTable2.csv, keep(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace

foreach var of varlist lntractors{
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag1_`var'_*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970  d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag*_lnmfgavewages_*  lag1_`var'_*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* $newdealcontrols cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* [aweight=county_w], absorb(fips) cluster(fips)
	eststo 
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* $newdealcontrols plantation_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* [aweight=county_w], absorb(fips) cluster(fips)
	eststo 
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag*_lnmfgavewages_*  lag1_`var'_*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag*_lnmfgavewages_*  lag1_`var'_*  prop_plant_flstate_1* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
esttab using Tables\RefTable2.csv, keep(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970) order(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970)  b(3) se(3) nogaps star(* 0.05 ** 0.01) replace

eststo clear
foreach var of varlist lnfarmland_a lnlandbuildingvaluef lnlandbuildingvalue{
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag1_`var'_* lag*_lnmfgavewages_*   lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* $newdealcontrols cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* $newdealcontrols plantation_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag1_`var'_* lag*_lnmfgavewages_*   lag2_`var'_1* lag3_`var'_1* lag4_`var'_1* $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag*_lnfarms_nonwhite_t_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag*_lnmfgestab_* lag1_`var'_* lag*_lnmfgavewages_*   lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  prop_plant_flstate_1* $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
esttab using Tables\RefTable3.csv, keep(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970) order(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace


/***Robustness to alternate measures*******/
eststo clear
foreach var of varlist lnfrac_black lnpopulation_black lnfracfarms_nonwhite lnpopulation{
	areg `var' f2_int_1930 f2_int_1940 f2_int_1950 f2_int_1960 f2_int_1970 d_sy_*  lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f2_int_1930 f2_int_1940 f2_int_1950 f2_int_1960 f2_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f2_int_1930 f2_int_1940 f2_int_1950 f2_int_1960 f2_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag2_`var'_1* lag3_`var'_1* lag4_`var'_1* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
esttab using Tables\RobustnessMeasures2Table1.csv, keep(f2_int_1930 f2_int_1940 f2_int_1950 f2_int_1960 f2_int_1970) order(f2_int_1930 f2_int_1940 f2_int_1950 f2_int_1960 f2_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace

eststo clear
foreach var of varlist lnfrac_black lnpopulation_black lnfracfarms_nonwhite lnpopulation{
	areg `var' f3_int_1930 f3_int_1940 f3_int_1950 f3_int_1960 f3_int_1970 d_sy_*  lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f3_int_1930 f3_int_1940 f3_int_1950 f3_int_1960 f3_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f3_int_1930 f3_int_1940 f3_int_1950 f3_int_1960 f3_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	}
esttab using Tables\RobustnessMeasures3Table1.csv, keep(f3_int_1930 f3_int_1940 f3_int_1950 f3_int_1960 f3_int_1970) order(f3_int_1930 f3_int_1940 f3_int_1950 f3_int_1960 f3_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace

eststo clear
foreach var of varlist lnavfarmsize lnvalue_equipment lnmules_horses{
	areg `var' f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970 d_sy_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
foreach var of varlist lntractors{
	areg `var' f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970 d_sy_* lag1_`var'_*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970  d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970  d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_*  $newdealcontrol [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
esttab using Tables\RobustnessMeasures2Table2.csv, keep(f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970) order(f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace

eststo clear
foreach var of varlist lnavfarmsize lnvalue_equipment lnmules_horses{
	areg `var' f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970 d_sy_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970 d_sy_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_*  lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
foreach var of varlist lntractors{
	areg `var' f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970 d_sy_* lag1_`var'_*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970  d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970  d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_*  $newdealcontrol [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}

esttab using Tables\RobustnessMeasures3Table2.csv, keep(f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970) order(f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace
eststo clear
foreach var of varlist lnfarmland_a lnlandbuildingvaluef lnlandbuildingvalue{
	areg `var' f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970 d_sy_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
esttab using Tables\RobustnessMeasures2Table3.csv, keep(f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970) order(f2_int_1930 f2_int_1935 f2_int_1940 f2_int_1945 f2_int_1950 f2_int_1954 f2_int_1960 f2_int_1964 f2_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace

eststo clear
foreach var of varlist lnfarmland_a lnlandbuildingvaluef lnlandbuildingvalue{
	areg `var' f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970 d_sy_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	areg `var' f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* lag2_`var'_1* lag3_`var'_1* lag4_`var'_1*  $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
esttab using Tables\RobustnessMeasures3Table3.csv, keep(f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970) order(f3_int_1930 f3_int_1935 f3_int_1940 f3_int_1945 f3_int_1950 f3_int_1954 f3_int_1960 f3_int_1964 f3_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace


/*interacted with plantation*/
clear
use preanalysis_post1930.dta
foreach i of numlist 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
gen f_int_`i'_p = f_int_`i' * plantation
replace f_int_`i' = f_int_`i' * (1-plantation)
}
eststo clear
areg lnfrac_black f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 f_int_1930_p f_int_1940_p f_int_1950_p f_int_1960_p f_int_1970_p d_sy_* plantation_* lag2_lnfrac_black_* lag3_lnfrac_black_* lag4_lnfrac_black_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation_black f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 f_int_1930_p f_int_1940_p f_int_1950_p f_int_1960_p f_int_1970_p d_sy_* plantation_* lag2_lnpopulation_black_* lag3_lnpopulation_black_* lag4_lnpopulation_black_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnfracfarms_nonwhite f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 f_int_1930_p f_int_1940_p f_int_1950_p f_int_1960_p f_int_1970_p d_sy_* plantation_* lag2_lnfracfarms_nonwhite_* lag3_lnfracfarms_nonwhite_* lag4_lnfracfarms_nonwhite_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnpopulation f_int_1930 f_int_1940 f_int_1950 f_int_1960 f_int_1970 f_int_1930_p f_int_1940_p f_int_1950_p f_int_1960_p f_int_1970_p d_sy_* plantation_* lag2_lnpopulation_* lag3_lnpopulation_* lag4_lnpopulation_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnavfarmsize f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 f_int_1930_p f_int_1935_p f_int_1940_p f_int_1945_p f_int_1950_p f_int_1954_p f_int_1960_p f_int_1964_p f_int_1970_p d_sy_* plantation_* lag1_lnavfarmsize_* lag2_lnavfarmsize_* lag3_lnavfarmsize_* lag4_lnavfarmsize_*   cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnvalue_equipment f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 f_int_1930_p f_int_1935_p f_int_1940_p f_int_1945_p f_int_1950_p f_int_1954_p f_int_1960_p f_int_1964_p f_int_1970_p d_sy_* plantation_* lag1_lnvalue_equipment_* lag2_lnvalue_equipment_* lag3_lnvalue_equipment_* lag4_lnvalue_equipment_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo
areg lnmules_horses f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 f_int_1930_p f_int_1935_p f_int_1940_p f_int_1945_p f_int_1950_p f_int_1954_p f_int_1960_p f_int_1964_p f_int_1970_p d_sy_* plantation_* lag1_lnmules_horses_* lag2_lnmules_horses_* lag3_lnmules_horses_* lag4_lnmules_horses_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lntractors f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 f_int_1930_p f_int_1935_p f_int_1940_p f_int_1945_p f_int_1950_p f_int_1954_p f_int_1960_p f_int_1964_p f_int_1970_p d_sy_* plantation_* lag1_lntractors_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnfarmland_a f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 f_int_1930_p f_int_1935_p f_int_1940_p f_int_1945_p f_int_1950_p f_int_1954_p f_int_1960_p f_int_1964_p f_int_1970_p d_sy_* plantation_* lag1_lnfarmland_a_* lag2_lnfarmland_a_* lag3_lnfarmland_a_* lag4_lnfarmland_a_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvaluef f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 f_int_1930_p f_int_1935_p f_int_1940_p f_int_1945_p f_int_1950_p f_int_1954_p f_int_1960_p f_int_1964_p f_int_1970_p d_sy_* plantation_* lag1_lnlandbuildingvaluef_* lag2_lnlandbuildingvaluef_* lag3_lnlandbuildingvaluef_* lag4_lnlandbuildingvaluef_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo 
areg lnlandbuildingvalue f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 f_int_1930_p f_int_1935_p f_int_1940_p f_int_1945_p f_int_1950_p f_int_1954_p f_int_1960_p f_int_1964_p f_int_1970_p d_sy_* plantation_* lag1_lnlandbuildingvalue_* lag2_lnlandbuildingvalue_* lag3_lnlandbuildingvalue_* lag4_lnlandbuildingvalue_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* $newdealcontrols  [aweight=county_w], absorb(fips) cluster(fips)
eststo
esttab, keep( f_int_*)
esttab using Tables\Robustness_PlantationInteraction.csv, keep(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 f_int_1930_p f_int_1935_p f_int_1940_p f_int_1945_p f_int_1950_p f_int_1954_p f_int_1960_p f_int_1964_p f_int_1970_p) b(3) se(3) star(* 0.05 ** 0.01) replace


/*for calculation of increases*/
clear
use preanalysis_post1930.dta
table year if flood==0, c(mean tractorsperfarm freq)
eststo clear
foreach var of varlist lntractors tractorsperfarm lntractorsperfarm{
	areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* lag1_`var'_*  cotton_s_* corn_s_* ld_* dx_* dy_* rug_* [aweight=county_w], absorb(fips) cluster(fips)
	eststo
	
}
foreach var of varlist lntractors tractorsperfarm lntractorsperfarm{
areg `var' f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970 d_sy_* cotton_s_* corn_s_* ld_* dx_* dy_* rug_* lag1_`var'_* $newdealcontrols [aweight=county_w], absorb(fips) cluster(fips)
	eststo
}
esttab using Tables\RefTable4.csv, keep(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970) order(f_int_1930 f_int_1935 f_int_1940 f_int_1945 f_int_1950 f_int_1954 f_int_1960 f_int_1964 f_int_1970) b(3) se(3) nogaps star(* 0.05 ** 0.01) replace


*Conley standard errors

set more off
*Population
foreach i of numlist 1930 1940 1950 1960 1970 {
clear all
use preanalysis_post1930.dta
keep if year==`i'
local newdeal`i' lnpcpubwor_`i' lnpcaaa_`i' lnpcrelief_`i' lnpcndloan_`i' lnpcndins_`i'
gen d_lnfrac_black = lnfrac_black - lag2_lnfrac_black_`i'
gen d_lnpopulation_black = lnpopulation_black - lag2_lnpopulation_black_`i'
gen d_lnpopulation = lnpopulation - lag2_lnpopulation_`i'
tab state_year, gen(d_year_state)

reg d_lnfrac_black f_int_`i' lag2_lnfrac_black_`i' lag3_lnfrac_black_`i' lag4_lnfrac_black_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', noc robust

reg d_lnpopulation_black f_int_`i' lag2_lnpopulation_black_`i' lag3_lnpopulation_black_`i' lag4_lnpopulation_black_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', noc robust
reg d_lnpopulation f_int_`i' lag2_lnpopulation_`i' lag3_lnpopulation_`i' lag4_lnpopulation_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', noc robust

replace x_centroid = (x_centroid+3000000)/1609.344
rename x_centroid xaxis
replace y_centroid = (y_centroid+2000000)/1609.344
rename y_centroid yaxis
gen cutoff1=50
gen cutoff2=50
x_ols xaxis yaxis cutoff1 cutoff2 d_lnfrac_black f_int_`i' lag2_lnfrac_black_`i' lag3_lnfrac_black_`i' lag4_lnfrac_black_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(19) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnpopulation_black f_int_`i' lag2_lnpopulation_black_`i' lag3_lnpopulation_black_`i' lag4_lnpopulation_black_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', xreg(19) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnpopulation f_int_`i' lag2_lnpopulation_`i' lag3_lnpopulation_`i' lag4_lnpopulation_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(19) coord(2)
drop cutoff1 cutoff2 epsilon window dis1 dis2

clear matrix
gen cutoff1=100
gen cutoff2=100
x_ols xaxis yaxis cutoff1 cutoff2 d_lnfrac_black f_int_`i' lag2_lnfrac_black_`i' lag3_lnfrac_black_`i' lag4_lnfrac_black_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(19) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnpopulation_black f_int_`i' lag2_lnpopulation_black_`i' lag3_lnpopulation_black_`i' lag4_lnpopulation_black_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(19) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnpopulation f_int_`i' lag2_lnpopulation_`i' lag3_lnpopulation_`i' lag4_lnpopulation_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(19) coord(2)
drop cutoff1 cutoff2 epsilon window dis1 dis2
clear matrix
gen cutoff1=200
gen cutoff2=200
x_ols xaxis yaxis cutoff1 cutoff2 d_lnfrac_black f_int_`i' lag2_lnfrac_black_`i' lag3_lnfrac_black_`i' lag4_lnfrac_black_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(19) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnpopulation_black f_int_`i' lag2_lnpopulation_black_`i' lag3_lnpopulation_black_`i' lag4_lnpopulation_black_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(19) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnpopulation f_int_`i' lag2_lnpopulation_`i' lag3_lnpopulation_`i' lag4_lnpopulation_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(19) coord(2)

}

*Land
foreach i of numlist 1930 1935 1940 1945 1950 1954 1960 1964 1970 {
clear
use preanalysis_post1930.dta
keep if year==`i'
local newdeal`i' lnpcpubwor_`i' lnpcaaa_`i' lnpcrelief_`i' lnpcndloan_`i' lnpcndins_`i'
gen d_lnavfarmsize = lnavfarmsize - lag1_lnavfarmsize_`i'
gen d_lnfarmland_a = lnfarmland_a - lag1_lnfarmland_a_`i'
gen d_lnlandbuildingvaluef = lnlandbuildingvaluef - lag1_lnlandbuildingvaluef_`i'
gen d_lnlandbuildingvalue = lnlandbuildingvalue - lag1_lnlandbuildingvalue_`i'
tab state_year, gen(d_year_state)

reg d_lnavfarmsize f_int_`i' lag1_lnavfarmsize_`i' lag2_lnavfarmsize_`i' lag3_lnavfarmsize_`i' lag4_lnavfarmsize_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , noc robust
reg d_lnfarmland_a f_int_`i' lag1_lnavfarmsize_`i' lag2_lnavfarmsize_`i' lag3_lnavfarmsize_`i' lag4_lnavfarmsize_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', noc robust
reg d_lnlandbuildingvaluef f_int_`i' lag1_lnlandbuildingvaluef_`i' lag2_lnlandbuildingvaluef_`i' lag3_lnlandbuildingvaluef_`i' lag4_lnlandbuildingvaluef_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , noc robust
reg d_lnlandbuildingvalue f_int_`i' lag1_lnlandbuildingvalue_`i' lag2_lnlandbuildingvalue_`i' lag3_lnlandbuildingvalue_`i' lag4_lnlandbuildingvalue_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , noc robust

replace x_centroid = (x_centroid+3000000)/1609.344
rename x_centroid xaxis
replace y_centroid = (y_centroid+2000000)/1609.344
rename y_centroid yaxis
gen cutoff1=50
gen cutoff2=50
x_ols xaxis yaxis cutoff1 cutoff2 d_lnavfarmsize f_int_`i' lag1_lnavfarmsize_`i' lag2_lnavfarmsize_`i' lag3_lnavfarmsize_`i' lag4_lnavfarmsize_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnfarmland_a f_int_`i' lag1_lnavfarmsize_`i' lag2_lnavfarmsize_`i' lag3_lnavfarmsize_`i' lag4_lnavfarmsize_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnlandbuildingvaluef f_int_`i' lag1_lnlandbuildingvaluef_`i' lag2_lnlandbuildingvaluef_`i' lag3_lnlandbuildingvaluef_`i' lag4_lnlandbuildingvaluef_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnlandbuildingvalue f_int_`i' lag1_lnlandbuildingvalue_`i' lag2_lnlandbuildingvalue_`i' lag3_lnlandbuildingvalue_`i' lag4_lnlandbuildingvalue_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop cutoff1 cutoff2 epsilon window dis1 dis2
clear matrix
gen cutoff1=100
gen cutoff2=100
x_ols xaxis yaxis cutoff1 cutoff2 d_lnavfarmsize f_int_`i' lag1_lnavfarmsize_`i' lag2_lnavfarmsize_`i' lag3_lnavfarmsize_`i' lag4_lnavfarmsize_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnfarmland_a f_int_`i' lag1_lnavfarmsize_`i' lag2_lnavfarmsize_`i' lag3_lnavfarmsize_`i' lag4_lnavfarmsize_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnlandbuildingvaluef f_int_`i' lag1_lnlandbuildingvaluef_`i' lag2_lnlandbuildingvaluef_`i' lag3_lnlandbuildingvaluef_`i' lag4_lnlandbuildingvaluef_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnlandbuildingvalue f_int_`i' lag1_lnlandbuildingvalue_`i' lag2_lnlandbuildingvalue_`i' lag3_lnlandbuildingvalue_`i' lag4_lnlandbuildingvalue_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop cutoff1 cutoff2 epsilon window dis1 dis2
clear matrix
gen cutoff1=200
gen cutoff2=200
x_ols xaxis yaxis cutoff1 cutoff2 d_lnavfarmsize f_int_`i' lag1_lnavfarmsize_`i' lag2_lnavfarmsize_`i' lag3_lnavfarmsize_`i' lag4_lnavfarmsize_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnfarmland_a f_int_`i' lag1_lnavfarmsize_`i' lag2_lnavfarmsize_`i' lag3_lnavfarmsize_`i' lag4_lnavfarmsize_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnlandbuildingvaluef f_int_`i' lag1_lnlandbuildingvaluef_`i' lag2_lnlandbuildingvaluef_`i' lag3_lnlandbuildingvaluef_`i' lag4_lnlandbuildingvaluef_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
drop epsilon window dis1 dis2
x_ols xaxis yaxis cutoff1 cutoff2 d_lnlandbuildingvalue f_int_`i' lag1_lnlandbuildingvalue_`i' lag2_lnlandbuildingvalue_`i' lag3_lnlandbuildingvalue_`i' lag4_lnlandbuildingvalue_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2)
}

*Tractors
foreach i of numlist 1930 1940 1945 1954 1970 {
clear
use preanalysis_post1930.dta
keep if year==`i'
local newdeal`i' lnpcpubwor_`i' lnpcaaa_`i' lnpcrelief_`i' lnpcndloan_`i' lnpcndins_`i'
gen d_lntractors = lntractors - lag1_lntractors_`i'
drop if d_lntractors==.
tab state_year, gen(d_year_state)

reg d_lntractors f_int_`i' lag1_lntractors_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', noc robust

replace x_centroid = (x_centroid+3000000)/1609.344
rename x_centroid xaxis
replace y_centroid = (y_centroid+2000000)/1609.344
rename y_centroid yaxis
gen cutoff1=50
gen cutoff2=50
x_ols xaxis yaxis cutoff1 cutoff2 d_lntractors f_int_`i' lag1_lntractors_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(17) coord(2)
drop cutoff1 cutoff2 epsilon window dis1 dis2
clear matrix
gen cutoff1=100
gen cutoff2=100
x_ols xaxis yaxis cutoff1 cutoff2 d_lntractors f_int_`i' lag1_lntractors_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(17) coord(2)
drop cutoff1 cutoff2 epsilon window dis1 dis2
clear matrix
gen cutoff1=200
gen cutoff2=200
x_ols xaxis yaxis cutoff1 cutoff2 d_lntractors f_int_`i' lag1_lntractors_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(17) coord(2)
}

*Equipment
foreach i of numlist 1930 1940 1970 {
clear
use preanalysis_post1930.dta
keep if year==`i'
local newdeal`i' lnpcpubwor_`i' lnpcaaa_`i' lnpcrelief_`i' lnpcndloan_`i' lnpcndins_`i'
gen d_lnvalue_equipment = lnvalue_equipment - lag1_lnvalue_equipment_`i'
tab state_year, gen(d_year_state)

reg d_lnvalue_equipment f_int_`i' lag1_lnvalue_equipment_`i' lag2_lnvalue_equipment_`i' lag3_lnvalue_equipment_`i' lag4_lnvalue_equipment_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', noc robust

replace x_centroid = (x_centroid+3000000)/1609.344
rename x_centroid xaxis
replace y_centroid = (y_centroid+2000000)/1609.344
rename y_centroid yaxis
gen cutoff1=50
gen cutoff2=50
x_ols xaxis yaxis cutoff1 cutoff2 d_lnvalue_equipment f_int_`i' lag1_lnvalue_equipment_`i' lag2_lnvalue_equipment_`i' lag3_lnvalue_equipment_`i' lag4_lnvalue_equipment_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2) 
drop cutoff1 cutoff2 epsilon window dis1 dis2
clear matrix
gen cutoff1=100
gen cutoff2=100
x_ols xaxis yaxis cutoff1 cutoff2 d_lnvalue_equipment f_int_`i' lag1_lnvalue_equipment_`i' lag2_lnvalue_equipment_`i' lag3_lnvalue_equipment_`i' lag4_lnvalue_equipment_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2) 
drop cutoff1 cutoff2 epsilon window dis1 dis2
clear matrix
gen cutoff1=200
gen cutoff2=200
x_ols xaxis yaxis cutoff1 cutoff2 d_lnvalue_equipment f_int_`i' lag1_lnvalue_equipment_`i' lag2_lnvalue_equipment_`i' lag3_lnvalue_equipment_`i' lag4_lnvalue_equipment_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'' , xreg(20) coord(2) 
}

*Mules and Horses
foreach i of numlist 1930 1935 1940 1954 1960 {
clear
use preanalysis_post1930.dta
keep if year==`i'
local newdeal`i' lnpcpubwor_`i' lnpcaaa_`i' lnpcrelief_`i' lnpcndloan_`i' lnpcndins_`i'
gen d_lnmules_horses = lnmules_horses - lag1_lnmules_horses_`i'
tab state_year, gen(d_year_state)

reg d_lnmules_horses f_int_`i' lag1_lnmules_horses_`i' lag2_lnmules_horses_`i' lag3_lnmules_horses_`i' lag4_lnmules_horses_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', noc robust

replace x_centroid = (x_centroid+3000000)/1609.344
rename x_centroid xaxis
replace y_centroid = (y_centroid+2000000)/1609.344
rename y_centroid yaxis
gen cutoff1=50
gen cutoff2=50
x_ols xaxis yaxis cutoff1 cutoff2 d_lnmules_horses f_int_`i' lag1_lnmules_horses_`i' lag2_lnmules_horses_`i' lag3_lnmules_horses_`i' lag4_lnmules_horses_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', xreg(20) coord(2)
drop cutoff1 cutoff2 epsilon window dis1 dis2
clear matrix
gen cutoff1=100
gen cutoff2=100
x_ols xaxis yaxis cutoff1 cutoff2 d_lnmules_horses f_int_`i' lag1_lnmules_horses_`i' lag2_lnmules_horses_`i' lag3_lnmules_horses_`i' lag4_lnmules_horses_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', xreg(20) coord(2)
drop cutoff1 cutoff2 epsilon window dis1 dis2
clear matrix
gen cutoff1=200
gen cutoff2=200
x_ols xaxis yaxis cutoff1 cutoff2 d_lnmules_horses f_int_`i' lag1_lnmules_horses_`i' lag2_lnmules_horses_`i' lag3_lnmules_horses_`i' lag4_lnmules_horses_`i' d_year_state* cotton_s_`i' corn_s_`i' ld_`i' dx_`i' dy_`i' rug_`i'  `newdeal`i'', xreg(20) coord(2)
}


 log close
