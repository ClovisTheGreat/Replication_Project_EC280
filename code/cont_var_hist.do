* run the following in order:
* Generate_flood.do
* flood_preanalysis.do
* then run this file to generate the histograms

clear all
set matsize 11000
set mem 1g

use preanalysis.dta

hist farmland if year == 1920

graph export Farmland_per_county_in_1920.png, as(png) replace

hist farmland if year == 1970

graph export Farmland_per_county_in_1970.png, as(png) replace
