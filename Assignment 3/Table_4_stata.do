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
