* ANALYSING BUNCHING AT INITIAL KINK SCHEDULE 1960-1970
* EXTRACTS DAT FILES FOR MATLAB KERNEL 
* COMPUTES TAXABLE INCOME (positive or negative) 
* revised Sept 2008 to include extra years 1998-2004

#delimit;

clear;
set mem 200m;
cd c:\manu\papers\done\bunching\stata;


* from 1948 to 1963: complete stability in the tax threshold + low inflation
20\% over the period 1950-1963;

* years 1960-63: tax computation;
* std deduction = 10% of agi up to a max of $1,000 ($500 is filing sep);
* exemption: $600 per person;
* bottom rate 20% (effective 18% for non-itemizers);

* 1960 a lot of bunching, especially itemizers;
* 1962 less bunching;

* year 1964-69: std deduction = max (10% of agi, $200+exemptions*$100) up 
to a max of $1,000;
* bottom rate 16% in 1964;
* bottom rate 14% in 1966-69;
* 1964 little bunching;
* starting 1970: personel exemption start growing and standard deduction expands
and set differentially between single and married;

* for all years, 1960 to 1969, return required for all individuals
with income above $600;
* requirement drops in 1970 and total number of returns falls;

* cpi08, 1960 to 2008:
0.1482  0.1497  0.1512  0.1532  0.1553  0.1578  0.1623  0.1673  0.1743  0.1838  
0.1943  0.2028  0.2093  0.2224  0.2469  0.2694  0.2850  0.3035  0.3265  0.3578  
0.3975  0.4354  0.4616  0.4814  0.5011  0.5183  0.5276  0.5455  0.5655  0.5899  
0.6193  0.6415  0.6578  0.6740  0.6884  0.7050  0.7237  0.7394  0.7497  0.7653  
0.7910  0.8132  0.8263  0.8448  0.8676  0.8967  0.9261  0.9524  1.0000;

* for X in num 60 62 64 66/72 \
D in num 0.1482   0.1512   0.1553  0.1623  0.1673  0.1743  0.1838 0.1943 0.2028  0.2093:;

for X in num 60 62 64 66/72 \
D in num 0.1482   0.1512   0.1553  0.1623  0.1673  0.1743  0.1838 0.1943 0.2028  0.2093:
use "c:\data\irs\xX" \
cap gen dweght=wght \ cap gen dweght=dwght \
replace dweght=100*dweght if X==60 | X==64 | (X>=68 & X<=75) \ 
replace dweght=dweght/100 \ * population weight \
gen married=0 \ replace married=1 if mars==1 & X<=62 \
replace married=1 if mars==2 & X>=64 \
gen taxinc=oldtxy \
gen taxincr=0 \ * taxincr is recomputed taxinc \
gen totexp=0 \
cap replace totexp=texemp if X==60 \
cap replace totexp=txpyex+ageex+blndex+dpndx+xoodep if X==62 \
cap replace totexp=txpyex+agex+blndex+xoodep if X==64 \
cap replace totexp=ageex+blndex+txpyex+dpndx if X==66 \
cap replace totexp=totex if X==67 \
cap replace totexp=xtot if X==68 | X==69 | X>=70 \
gen stdded6063=min(0.1*agi,1000) \
gen stdded6469=stdded6063 \
replace stdded6469=min(200+100*totexp,1000) if 200+100*totexp>0.1*agi \
gen stdded7072=1100 \ replace stdded7072=1050 if X==71 \ replace stdded7072=1300 if X==72 \ 
gen stdded=stdded6063 \ replace stdded=stdded6469 if X>=64 & X<=69 \
replace stdded=stdded7072 if X>=70 & X<=72 \
gen exemp=600*totexp \ 
replace exemp=625*totexp if X==70 \
replace exemp=675*totexp if X==71 \ replace exemp=750*totexp if X==72 \
gen exemp6069=600*totexp \ 
gen itemiz=0 \ replace itemiz=1 if fded==1 \
cap replace agi=agi-agidef if X>=66 & X<=71 \ * no negative agi in 1960 \
replace taxinc=agi-stdded-exemp if itemiz==0 & oldtxy==0 \
replace taxinc=agi-totald-exemp if itemiz==1 & oldtxy==0 \
replace taxincr=agi-stdded-exemp if itemiz==0 \
replace taxincr=agi-totald-exemp if itemiz==1 \
replace taxinc=taxinc/D \
replace taxincr=taxincr/D \
gen taxincstd=(agi-stdded-exemp)/D \
keep if (taxinc>-20000 & taxinc<65000) | (taxincstd>-20000 & taxincstd<65000) \
* drop if totexp==0 \ cap drop year \
gen cpi=D \ gen year=1900+X \
* gen wagsh=wages/agi \ * gen aldsh=totald/agi \
* keep if wagsh!=. & aldsh!=. \
gen waginc=1 \ replace waginc=0 if wages==0 \
gen selfinc=0 \ 
cap replace selfinc=1 if busny!=0 & X==62 \ * no selfinc info for 1960 \
cap replace selfinc=1 if schedc+farm!=0 & ( X==64 | X==73 | X>=75) \
cap replace selfinc=1 if busny-busnl+farmy-farml!=0 & (X<=72 | X==74) \
sort taxinc itemiz \
keep taxinc taxincr taxincstd dweght itemiz married year cpi totexp agi totald oldtxy stdded stdded6063 
stdded7072 exemp exemp6069
selfinc waginc \
save "c:\scratch\taxX.dta", replace \
clear;

use "c:\scratch\tax60.dta";
for X in num 62 64 66/72:
append using "c:\scratch\taxX.dta";
gen iweght=round(100*dweght);
save "c:\scratch\tax6072.dta", replace; 

* cut by item vs non item is not legitimate;



clear;
use "c:\scratch\tax6072.dta"; 

cap gen mtr=0; replace mtr=0.20 if taxinc>0;
replace mtr=0.22 if (taxinc>4000/cpi & married==1) | (taxinc>2000/cpi & married!=1);
replace mtr=0.26 if (taxinc>8000/cpi & married==1) | (taxinc>4000/cpi & married!=1);
replace mtr=0.30 if (taxinc>12000/cpi & married==1) | (taxinc>6000/cpi & married!=1);
replace mtr=0.34 if (taxinc>16000/cpi & married==1) | (taxinc>8000/cpi & married!=1);
replace mtr=0.38 if (taxinc>20000/cpi & married==1) | (taxinc>10000/cpi & married!=1);

* gen income=taxinc;
* replace income=(agi-stdded-exemp)/cpi;
* keep if income>-20000 & income<65000;

sort married taxinc;

cap gen ones=1;

sum ones [w=iweght] if year>=1960 & year<=1969 & taxinc>-20000 & taxinc<60000 & married==1;
sum ones [w=iweght]  if year>=1960 & year<=1969 & taxinc>-20000 & taxinc<60000 & married!=1;
sum ones [w=iweght]  if year>=1960 & year<=1963 & taxinc>-20000 & taxinc<60000 & married==1;
sum ones [w=iweght]  if year>=1964 & year<=1969 & taxinc>-20000 & taxinc<60000 & married==1;
sum ones [w=iweght]  if year>=1970 & year<=1972 & taxinc>-20000 & taxinc<60000 & married==1;
sum ones [w=iweght]  if year>=1960 & year<=1963 & taxinc>-20000 & taxinc<60000 & married!=1;
sum ones [w=iweght]  if year>=1964 & year<=1969 & taxinc>-20000 & taxinc<60000 & married!=1;
sum ones [w=iweght]  if year>=1970 & year<=1972 & taxinc>-20000 & taxinc<60000 & married!=1;


twoway histogram taxinc if year>=1960 & year<=1969 & taxinc>-20000 & taxinc<60000 & married==1  [fweight=iweght], bin(100)
clwidth(medthick) clcolor(navy) yaxis(2) xline(0) ||
line mtr taxinc if year>=1960 & year<=1960 & taxinc>-20000 & taxinc<60000 & married==1,
msymbol(none) c(l) yaxis(1) ylabel(0(.1).5,axis(1)) clcolor(black) clpattern(dash)  
ytitle("Marginal Tax Rate",axis(1))  ytitle("Taxable Income Density",axis(2)) ylabel(, nolabels noticks axis(2)) 
  xlabel(-20000(10000)60000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 60000))  yscale(range(.5) axis(1)) 
  title("A. Married Tax Filers") graphregion(fcolor(white))
  legend(label(2 "Marginal Tax Rate") label(1 "Density") cols(2) order(1 2));
graph export fig6A_60_69hist_married.wmf, replace;

twoway histogram taxinc if year>=1960 & year<=1969 & taxinc>-20000 & taxinc<60000 & married!=1  [fweight=iweght], bin(100)
clwidth(medthick) clcolor(navy) yaxis(2) xline(0) ||
line mtr taxinc if year>=1960 & year<=1960 & taxinc>-20000 & taxinc<60000 & married!=1,
msymbol(none) c(l) yaxis(1) ylabel(0(.1).5,axis(1)) clcolor(black) clpattern(dash)  
ytitle("Marginal Tax Rate",axis(1))  ytitle("Taxable Income Density",axis(2)) ylabel(, nolabels noticks axis(2)) 
  xlabel(-20000(10000)60000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 60000))  yscale(range(.5) axis(1)) 
  title("B. Single Tax Filers") graphregion(fcolor(white))
  legend(label(2 "Marginal Tax Rate") label(1 "Density") cols(2) order(1 2));
graph export fig6B_60_69hist_single_wide.wmf, replace;

twoway kdensity taxinc if year>=1960 & year<=1969 & taxinc>-20000 & taxinc<60000 & married==1 [fweight=iweght], width(500)
clwidth(medthick) clcolor(black) yaxis(2) xline(0) ||
kdensity taxincstd if year>=1960 & year<=1969 & taxincstd>-20000 & taxincstd<60000 & married==1 [fweight=iweght], width(500)
clwidth(medthick) clpattern(dot) clcolor(black) yaxis(2) xline(0) ||
line mtr taxinc if year>=1960 & year<=1960 & taxinc>-20000 & taxinc<60000 & married==1,
msymbol(none) c(l) yaxis(1) ylabel(0(.1).5,axis(1)) clcolor(black) clpattern(dash)  
ytitle("Marginal Tax Rate",axis(1))  ytitle("Taxable Income Density",axis(2)) ylabel(, nolabels noticks axis(2)) 
  xlabel(-20000(10000)60000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 60000))  yscale(range(.5) axis(1)) 
  title("A. Married Tax Filers") graphregion(fcolor(white))
  legend(label(3 "MTR") label(2 "Standard Deduction") label(1 "Taxable Income") cols(3) order(1 2 3));
graph export fig7A_60_69hist_married_std.wmf, replace;

twoway kdensity taxinc if year>=1960 & year<=1969 & taxinc>-20000 & taxinc<60000 & married!=1 [fweight=iweght], width(500)
clwidth(medthick) clcolor(black) yaxis(2) xline(0) ||
kdensity taxincstd if year>=1960 & year<=1969 & taxincstd>-20000 & taxincstd<60000 & married!=1 [fweight=iweght], width(500)
clwidth(medthick) clpattern(dot) clcolor(black) yaxis(2) xline(0) ||
line mtr taxinc if year>=1960 & year<=1960 & taxinc>-20000 & taxinc<60000 & married!=1,
msymbol(none) c(l) yaxis(1) ylabel(0(.1).5,axis(1)) clcolor(black) clpattern(dash)  
ytitle("Marginal Tax Rate",axis(1))  ytitle("Taxable Income Density",axis(2)) ylabel(, nolabels noticks axis(2)) 
  xlabel(-20000(10000)60000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 60000))  yscale(range(.5) axis(1)) 
  title("A. Single Tax Filers") graphregion(fcolor(white))
  legend(label(3 "MTR") label(2 "Standard Deduction") label(1 "Taxable Income") cols(3) order(1 2 3));
graph export fig7B_60_69hist_single_std_wide.wmf, replace;

twoway kdensity taxinc if year>=1960 & year<=1963 & taxinc>-20000 & taxinc<60000 & married==1 [fweight=iweght], width(600)
clwidth(medthick) clcolor(black)  xline(0) ||
kdensity taxinc if year>=1964 & year<=1969 & taxinc>-20000 & taxinc<60000 & married==1 [fweight=iweght], width(600)
clwidth(medthick) clpattern(dash) clcolor(black)  ||
kdensity taxinc if year>=1969 & year<=1972 & taxinc>-20000 & taxinc<60000 & married==1 [fweight=iweght], width(600)
clwidth(medthick) clpattern(dot) clcolor(black)  
  ytitle("Taxable Income Density") ylabel(, nolabels noticks) 
  xlabel(-20000(10000)60000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 60000))  
  title("A. Married Tax Filers") graphregion(fcolor(white))
  legend(label(3 "1970-1972") label(2 "1964-1969") label(1 "1960-1963") cols(3) order(1 2 3));
graph export fig8A_60_72hist_married_dynamic.wmf, replace;

twoway kdensity taxinc if year>=1960 & year<=1963 & taxinc>-20000 & taxinc<60000 & married!=1 [fweight=iweght], width(500)
clwidth(medthick) clcolor(black)  xline(0) ||
kdensity taxinc if year>=1964 & year<=1969 & taxinc>-20000 & taxinc<60000 & married!=1 [fweight=iweght], width(500)
clwidth(medthick) clpattern(dash) clcolor(black)  ||
kdensity taxinc if year>=1969 & year<=1972 & taxinc>-20000 & taxinc<60000 & married!=1 [fweight=iweght], width(500)
clwidth(medthick) clpattern(dot) clcolor(black)  
  ytitle("Taxable Income Density") ylabel(, nolabels noticks) 
  xlabel(-20000(10000)60000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 60000))  
  title("B. Single Tax Filers") graphregion(fcolor(white))
  legend(label(3 "1970-1972") label(2 "1964-1969") label(1 "1960-1963") cols(3) order(1 2 3));
graph export fig8B_60_72hist_single_dynamic_wide.wmf, replace;



* TABLE 4 ELASTICITY REGRESSIONS calling subroutine eitc_elasticity_sub.do;

* eitc_estim=(zstar,t0,t1,delta,yearmin,yearmax,self,kids,marst,eitc,bstrap,hate,se,sebootstrap);
* self=0: only wage earners, self=1: only self-employed, self=2: all, self=3 only kgain=1,
self=4, only item=1, self=5, only contr=1;
* kids=0: no conditions on kids, kids=1: 1 kid, kids=2: 2+ kids, kids=3 (no kid EITC for 1994+);
* marst=0: use everybody (for gap), marst=1 (only singles), marst=2 (only married);
* eitc=1: for eitc estimation (no gap), eitc=2 (eitc gap), eitc=0, reg fed;
* bstrap=1, compute bootstrap se estimates, bstrap=0, do not compute bootstrap se;
cap gen eic=0;

matrix input eitc_estim=(
0,0,.16,1500,1960,1969,2,0,0,0,0,0,0,0 \
0,0,.16,1500,1960,1969,2,0,2,0,0,0,0,0 \
0,0,.16,1500,1960,1969,2,0,1,0,0,0,0,0 \
0,0,.20,1500,1960,1963,2,0,0,0,0,0,0,0 \
0,0,.20,1500,1960,1963,2,0,2,0,0,0,0,0 \
0,0,.20,1500,1960,1963,2,0,1,0,0,0,0,0 \
0,0,.14,1500,1964,1969,2,0,0,0,0,0,0,0 \
0,0,.14,1500,1964,1969,2,0,2,0,0,0,0,0 \
0,0,.14,1500,1964,1969,2,0,1,0,0,0,0,0 \
0,0,.14,1500,1970,1972,2,0,0,0,0,0,0,0 \
0,0,.14,1500,1970,1972,2,0,2,0,0,0,0,0 \
0,0,.14,1500,1970,1972,2,0,1,0,0,0,0,0 );

local numi=rowsof(eitc_estim);

foreach kk of numlist 1/`numi' {;
cap drop zinc;
gen zinc=taxinc; 
matrix estim=eitc_estim[`kk',1..14];
do eitc_elasticity_sub.do;
matrix eitc_estim[`kk',12]=estim[1,12];
matrix eitc_estim[`kk',13]=estim[1,13];
matrix eitc_estim[`kk',14]=estim[1,14];
};

matrix list eitc_estim;

cap drop  eitc_estim*;

svmat eitc_estim;
outsheet eitc_estim* if _n<=`numi' using result_6069.xls, replace;

clear;

* YEARS 1988 to 2004, regular schedule;

* official inflation parameters from IRS (see excel file state-code.xls in EITC_IRS directory) from 1981-2008:
0.3867  0.4301  0.4639  0.4811  0.5003  0.5192  0.5325  0.5466  0.5692  0.5962  
0.6251  0.6581  0.6781  0.6988  0.7170  0.7374  0.7577  0.7785  0.7916  0.8061  
0.8311  0.8585  0.8721  0.8920  0.9126  0.9409  0.9776  1.0000:;

* for X in num 2004 \ D in num 0.8920:;

clear;
for X in num 88 89 90 91 92 93 94 95 96 97 98 99 2000 2001 2002 2003 2004 \ 
D in num 0.5466  0.5692  0.5962 0.6251  0.6581  0.6781  0.6988  0.7170  0.7374  0.7577  
0.7785  0.7916  0.8061 0.8311  0.8585  0.8721  0.8920:
use "c:\data\irs\xX" \
replace dweght=dweght/100 \ * population weight \
gen iweght=round(100*dweght) \
gen married=0 \ replace married=1 if mars==2 \
gen taxinc=newtxy \
gen taxincr=0 \ * taxincr is recomputed taxinc \
drop if xtot==0 \ * drop taxpayers that can be claimed as dependents \
drop if mars==3 \ * drop married filing separately \
gen itemiz=0 \ replace itemiz=1 if fded==1 \
gen childc=0 \ replace childc=1 if xocah>=1 \ replace childc=0 if childc==. \

\ * determining item status for those who don't have fded=1,2 (regular comp) year and previous year \

replace itemiz=1 if X==2004 & fded>=3 & mars==1 &
(totald!=4850) & (totald!=4750) \
replace itemiz=1 if X==2004 & fded>=3 & mars==2 &
(totald!=9700) & (totald!=9500) \
replace itemiz=1 if X==2004 & fded>=3 & mars>=4 &
(totald!=7150) & (totald!=7000) \

replace itemiz=1 if X==2003 & fded>=3 & mars==1 &
(totald!=4750) & (totald!=4700) \
replace itemiz=1 if X==2003 & fded>=3 & mars==2 &
(totald!=9500) & (totald!=7850) \
replace itemiz=1 if X==2003 & fded>=3 & mars>=4 &
(totald!=7000) & (totald!=6900) \

replace itemiz=1 if X==2002 & fded>=3 & mars==1 &
(totald!=4700) & (totald!=4550) \
replace itemiz=1 if X==2002 & fded>=3 & mars==2 &
(totald!=7850) & (totald!=7600) \
replace itemiz=1 if X==2002 & fded>=3 & mars>=4 &
(totald!=6900) & (totald!=6650) \

replace itemiz=1 if X==2001 & fded>=3 & mars==1 &
(totald!=4550) & (totald!=4400) \
replace itemiz=1 if X==2001 & fded>=3 & mars==2 &
(totald!=7600) & (totald!=7350) \
replace itemiz=1 if X==2001 & fded>=3 & mars>=4 &
(totald!=6650) & (totald!=6450) \

replace itemiz=1 if X==2000 & fded>=3 & mars==1 &
(totald!=4400) & (totald!=4300) \
replace itemiz=1 if X==2000 & fded>=3 & mars==2 &
(totald!=7350) & (totald!=7200) \
replace itemiz=1 if X==2000 & fded>=3 & mars>=4 &
(totald!=6450) & (totald!=6350) \

replace itemiz=1 if X==99 & fded>=3 & mars==1 &
(totald!=4300) & (totald!=4250) \
replace itemiz=1 if X==99 & fded>=3 & mars==2 &
(totald!=7200) & (totald!=7100) \
replace itemiz=1 if X==99 & fded>=3 & mars>=4 &
(totald!=6350) & (totald!=6250) \

replace itemiz=1 if X==98 & fded>=3 & mars==1 &
(totald!=4250) &
(totald!=4150 & totald!=5150 & totald!=6150) \
replace itemiz=1 if X==98 & fded>=3 & mars==2 &
(totald!=7100) &
(totald!=6900 & totald!=7700 & totald!=8500 & totald!=9300) \
replace itemiz=1 if X==98 & fded>=3 & mars>=4 &
(totald!=6250) &
(totald!=6050 & totald!=7050 & totald!=8050) \

replace itemiz=1 if X==97 & fded>=3 & mars==1 &
(totald!=4150 & totald!=5150 & totald!=6150) &
(totald!=4000 & totald!=5000 & totald!=6000) \
replace itemiz=1 if X==97 & fded>=3 & mars==2 &
(totald!=6900 & totald!=7700 & totald!=8500 & totald!=9300) &
(totald!=6700 & totald!=7500 & totald!=8300 & totald!=9100) \
replace itemiz=1 if X==97 & fded>=3 & mars>=4 &
(totald!=6050 & totald!=7050 & totald!=8050) &
(totald!=5900 & totald!=6900 & totald!=7900) \

replace itemiz=1 if X==96 & fded>=3 & mars==1 &
(totald!=4000 & totald!=5000 & totald!=6000) & 
(totald!=3900 & totald!=4850 & totald!=5800) \
replace itemiz=1 if X==96 & fded>=3 & mars==2 &
(totald!=6700 & totald!=7500 & totald!=8300 & totald!=9100) & 
(totald!=6550 & totald!=7300 & totald!=8050 & totald!=8800) \
replace itemiz=1 if X==96 & fded>=3 & mars>=4 &
(totald!=5900 & totald!=6900 & totald!=7900) & 
(totald!=5750 & totald!=6700 & totald!=7650) \

replace itemiz=1 if X==95 & fded>=3 & mars==1 &
(totald!=3900 & totald!=4850 & totald!=5800) &
(totald!=3800 & totald!=4750 & totald!=5700) \
replace itemiz=1 if X==95 & fded>=3 & mars==2 &
(totald!=6550 & totald!=7300 & totald!=8050 & totald!=8800) &
(totald!=6350 & totald!=7100 & totald!=7850 & totald!=8600)  \
replace itemiz=1 if X==95 & fded>=3 & mars>=4 &
(totald!=5750 & totald!=6700 & totald!=7650) &
(totald!=5600 & totald!=6550 & totald!=7500)  \

replace itemiz=1 if X==94 & fded>=3 & mars==1 &
(totald!=3800 & totald!=4750 & totald!=5700) &
(totald!=3700 & totald!=4600 & totald!=5500) \
replace itemiz=1 if X==94 & fded>=3 & mars==2 &
(totald!=6350 & totald!=7100 & totald!=7850 & totald!=8600) &
(totald!=6200 & totald!=6900 & totald!=7600 & totald!=8300)  \
replace itemiz=1 if X==94 & fded>=3 & mars>=4 &
(totald!=5600 & totald!=6550 & totald!=7500) &
(totald!=5450 & totald!=6350 & totald!=7250) \

replace itemiz=1 if X==93 & fded>=3 & mars==1 &
(totald!=3700 & totald!=4600 & totald!=5500) &
(totald!=3600 & totald!=4500 & totald!=5400)  \
replace itemiz=1 if X==93 & fded>=3 & mars==2 &
(totald!=6200 & totald!=6900 & totald!=7600 & totald!=8300) &
(totald!=6000 & totald!=6700 & totald!=7400 & totald!=8100)  \
replace itemiz=1 if X==93 & fded>=3 & mars>=4 &
(totald!=5450 & totald!=6350 & totald!=7250) &
(totald!=5250 & totald!=6150 & totald!=7050) \

replace itemiz=1 if X==92 & fded>=3 & mars==1 &
(totald!=3600 & totald!=4500 & totald!=5400) &
(totald!=3400 & totald!=4250 & totald!=5100) \
replace itemiz=1 if X==92 & fded>=3 & mars==2 &
(totald!=6000 & totald!=6700 & totald!=7400 & totald!=8100) &
(totald!=5700 & totald!=6350 & totald!=7000 & totald!=7650) \
replace itemiz=1 if X==92 & fded>=3 & mars>=4 &
(totald!=5250 & totald!=6150 & totald!=7050) &
(totald!=5000 & totald!=5850 & totald!=6700) \

replace itemiz=1 if X==91 & fded>=3 & mars==1 &
(totald!=3400 & totald!=4250 & totald!=5100) &
(totald!=3250 & totald!=4050 & totald!=4850) \
replace itemiz=1 if X==91 & fded>=3 & mars==2 &
(totald!=5700 & totald!=6350 & totald!=7000 & totald!=7650) &
(totald!=5450 & totald!=6100 & totald!=6750 & totald!=7400) \
replace itemiz=1 if X==91 & fded>=3 & mars>=4 &
(totald!=5000 & totald!=5850 & totald!=6700) &
(totald!=4750 & totald!=5550 & totald!=6350) \

replace itemiz=1 if X==90 & fded>=3 & mars==1 &
(totald!=3250 & totald!=4050 & totald!=4850) &
(totald!=3100 & totald!=3850 & totald!=4600) \
replace itemiz=1 if X==90 & fded>=3 & mars==2 &
(totald!=5450 & totald!=6100 & totald!=6750 & totald!=7400) &
(totald!=5200 & totald!=5800 & totald!=6400 & totald!=7000) \
replace itemiz=1 if X==90 & fded>=3 & mars>=4 &
(totald!=4750 & totald!=5550 & totald!=6350) &
(totald!=4550 & totald!=5300 & totald!=6050) \

replace itemiz=1 if X==89 & fded>=3 & mars==1 &
(totald!=3100 & totald!=3850 & totald!=4600) &
(totald!=3000 & totald!=3750 & totald!=4500) \
replace itemiz=1 if X==89 & fded>=3 & mars==2 &
(totald!=5200 & totald!=5800 & totald!=6400 & totald!=7000) &
(totald!=5000 & totald!=5600 & totald!=6200 & totald!=6800) \
replace itemiz=1 if X==89 & fded>=3 & mars>=4 &
(totald!=4550 & totald!=5300 & totald!=6050) &
(totald!=4400 & totald!=5150 & totald!=5900) \

replace itemiz=1 if X==88 & fded>=3 & mars==1 &
(totald!=3000 & totald!=3750 & totald!=4500) &
(totald!=2540 & totald!=3750 & totald!=4500) \
replace itemiz=1 if X==88 & fded>=3 & mars==2 &
(totald!=5000 & totald!=5600 & totald!=6200 & totald!=6800) &
(totald!=3760 & totald!=5600 & totald!=6200 & totald!=6800) \
replace itemiz=1 if X==88 & fded>=3 & mars>=4 &
(totald!=4400 & totald!=5150 & totald!=5900) &
(totald!=2540 & totald!=5150 & totald!=5900) \

replace taxinc=agi-totald-exempt if newtxy==0 \
replace taxincr=agi-totald-exempt \
replace taxinc=taxinc/D \
replace taxincr=taxincr/D \
replace nystax=nystax/D \ * tax base for regular brackets post 1993 \
gen self=0 \ replace self=1 if schedc+farm!=0 \
gen kgain=0 \ replace kgain=1 if cgagi>0 \
gen cont=0 \ replace cont=1 if contrd>0 \
gen wag=0 \ replace wag=1 if wages>0 \
gen taxprep=0 \ cap replace taxprep=1 if prep==1 \ replace taxprep=0 if taxprep==. \
* tax credits \
gen tcredit=0 \ replace tcredit=1 if  txcred>0 \
gen notax=0 \ replace notax=1 if taxbc>0 & taxaft==0 \
gen addbase=txcred/.15 \
sort taxinc itemiz \ cap drop year \ gen year=1900+X if X<100 \ replace year=X if X>100 \ 
gen cpi=D \
cap gen nystax=0 \
cap gen chtcr=0 \ cap gen accrd=0 \ cap gen n24=0 \
keep year taxinc taxincr nystax dweght iweght itemiz married cpi agi totald exempt newtxy xtot mars
self kgain cont taxprep childc wag tcredit notax addbase eicrd chtcr accrd n24 \
keep if (taxinc>-20000 & taxinc<65000) | (taxinc>-20000 & taxinc<110000 & mars==2) |
(nystax>150000 & nystax<250000 & mars==2 & year>=1993) | (nystax>250000 & nystax<500000 & year>=1993) \
save "c:\scratch\taxX.dta", replace \

clear; 
use "c:\scratch\tax88.dta";
for X in num 89 90 91 92 93 94 95 96 97 98 99 2000 2001 2002 2003 2004:
append using "c:\scratch\taxX.dta";
replace taxprep=. if year==1989 | year==1990; * no tax prep info for those years;
gen stdded=0;
for X in num 1988/2004 \ 
D in num 3000 3100 3250 3400 3600 3700 3800 3900 4000 4150 4250 4300 4400 4550 4700 4750 4850 \
E in num 5000 5200 5450 5700 6000 6200 6350 6550 6700 6900 7100 7200 7350 7600 7850 9500 9700 \
F in num 4400 4550 4750 5000 5250 5450 5600 5750 5900 6050 6250 6350 6450 6650 6900 7000 7150:
replace stdded=D if year==X & mars==1 \
replace stdded=E if year==X & mars==2 \
replace stdded=F if year==X & mars>2;
gen taxincstd=(agi-exemp-stdded)/cpi;
 
save "c:\scratch\tax8804.dta", replace; 

* cut by item vs non item is not legitimate;


clear;set mem 300m;
use "c:\scratch\tax8804.dta"; 
* gen income=taxinc;
* replace income=(agi-stdded-exemp)/cpi;
* keep if income>-20000 & income<65000; 

cap gen ones=1;

cap gen mtr=0; replace mtr=0.15 if taxinc>0;
replace mtr=0.28 if (taxinc>54350 & mars==2) | (taxinc>32550 & mars==1) | (taxinc>43650 & mars>=4);
replace mtr=0.31 if (taxinc>131450 & mars==2) | (taxinc>78850 & mars==1) | (taxinc>112650 & mars>=4);
replace mtr=0.36 if ((taxinc>200300 & mars==2) | (taxinc>164550 & mars==1) | (taxinc>182400 & mars>=4)) & year>=1993;
replace mtr=0.396 if taxinc>357700 & year>=1993;

sort taxinc;

* higher kink points;
* histograms 15/28 kink point;


sum ones if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<80000 & mars==2 ; 
sum ones [w=dweght] if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<80000 & mars==2 ;
sum ones if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<60000 & mars!=2 ; 
sum ones [w=dweght] if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<60000 & mars==1 ;
sum ones [w=dweght] if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<40000;
bys childc: sum ones [w=dweght] if year>=1998 & year<=2004 & taxinc>-20000 & taxinc<40000;

* Figure 9A, 1988-2002, married;
twoway histogram taxinc if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<80000 & mars==2  [fweight=iweght], 
bin(100) clwidth(medthick) clcolor(navy) yaxis(2) xline(0 54350) ||
line mtr taxinc  if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<80000 & mars==2,
msymbol(none) c(l) yaxis(1) ylabel(0(.1).5,axis(1)) clcolor(black) clpattern(dash)  
ytitle("Marginal Tax Rate",axis(1))  ytitle("Taxable Income Density ($1000 bins)",axis(2)) ylabel(, nolabels noticks axis(2)) 
  xlabel(-20000(10000)80000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 80000))  yscale(range(.5) axis(1)) 
  title("A. Married Tax Filers") graphregion(fcolor(white))
  legend(label(2 "Marginal Tax Rate") label(1 "Density") cols(2) order(1 2));
graph export fig9A_15_28_married.wmf, replace;

* Figure 9B, 1988-2002, single;
twoway histogram taxinc if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<60000 & mars==1  [fweight=iweght], 
bin(100) clwidth(medthick) clcolor(navy) yaxis(2) xline(0 32550) ||
line mtr taxinc  if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<60000 & mars==1,
msymbol(none) c(l) yaxis(1) ylabel(0(.1).5,axis(1)) clcolor(black) clpattern(dash)  
ytitle("Marginal Tax Rate",axis(1))  ytitle("Taxable Income Density ($800 bins)",axis(2)) ylabel(, nolabels noticks axis(2)) 
  xlabel(-20000(10000)60000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 60000))  yscale(range(.5) axis(1)) 
  title("B. Single Tax Filers") graphregion(fcolor(white))
  legend(label(2 "Marginal Tax Rate") label(1 "Density") cols(2) order(1 2));
graph export fig9B_15_28_single.wmf, replace;

/*
* Figure 9C, 1988-2002, heads;
twoway histogram taxinc if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<60000 & mars==4  [fweight=iweght], 
bin(100) clwidth(medthick) clcolor(navy) yaxis(2) xline(0 32550) ||
line mtr taxinc  if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<60000 & mars==4,
msymbol(none) c(l) yaxis(1) ylabel(0(.1).5,axis(1)) clcolor(black) clpattern(dash)  
ytitle("Marginal Tax Rate",axis(1))  ytitle("Taxable Income Density ($800 bins)",axis(2)) ylabel(, nolabels noticks axis(2)) 
  xlabel(-20000(10000)60000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 60000))  yscale(range(.5) axis(1)) 
  title("B. Single Tax Filers") graphregion(fcolor(white))
  legend(label(2 "Marginal Tax Rate") label(1 "Density") cols(2) order(1 2));
graph export fig9C_15_28_heads.wmf, replace; */

* Figure 10A, 1988-2002, item;
twoway kdensity taxinc if year>=1988 & year<=2002 & taxinc>-20000 & taxinc<40000 & mars!=0 [fweight=iweght], 
width(400) clwidth(medthick) clcolor(black) ||
kdensity taxincstd if year>=1988 & year<=2002 & taxincstd>-20000 & taxincstd<40000 & mars!=0 
[fweight=iweght], width(400) clwidth(medthick) clcolor(black) clpattern(dash) xline(0 54350) 
ytitle("Taxable Income Density") ylabel(, nolabels noticks)
  xlabel(-20000(10000)40000)  xtitle("Taxable Income (2008 $)")  
  title("A. Effects of Itemizing") graphregion(fcolor(white))
  legend(label(2 "Standard Deduction") label(1 "Taxable Income") cols(2) order(1 2)) ; 
  graph export fig10A_15_28_item.wmf, replace;

* Figure 10B, 1998-2004, child tax credit;
twoway kdensity taxinc if year>=1998 & year<=2004 & taxinc>-20000 & taxinc<40000 & mars!=0 & childc==1
[fweight=iweght], width(500) clwidth(medthick) clcolor(black) xline(0) ||
kdensity taxinc if year>=1998 & year<=2004 & taxinc>-20000 & taxinc<40000 & mars!=0 & childc==0 [fweight=iweght], 
width(500) clwidth(medthick) clcolor(black) clpattern(dash) 
ytitle("Taxable Income Density") ylabel(, nolabels noticks) 
  xlabel(-20000(10000)40000)  xtitle("Taxable Income (2008 $)") xscale(range(-20000 40000))  
  title("B. Child Tax Credit Effects") graphregion(fcolor(white))
  legend(label(2 "No children") label(1 "Children") cols(2) order(1 2));
  graph export fig10B_15_28_childc.wmf, replace;

* TABLE 4 ELASTICITY REGRESSIONS calling subroutine eitc_elasticity_sub.do;

* eitc_estim=(zstar,t0,t1,delta,yearmin,yearmax,self,kids,marst,eitc,bstrap,hate,se,sebootstrap);
* self=0: only wage earners, self=1: only self-employed, self=2: all, self=3 only kgain=1,
self=4, only item=1, self=5, only contr=1;
* kids=0: no conditions on kids, kids=1: 1 kid, kids=2: 2+ kids, kids=3 (no kid EITC for 1994+);
* marst=0: use everybody (for gap), marst=1 (only singles), marst=2 (only married);
* eitc=1: for eitc estimation (no gap), eitc=2 (eitc gap), eitc=0, reg fed;
* bstrap=1, compute bootstrap se estimates, bstrap=0, do not compute bootstrap se;

cap gen eic=0;

matrix input eitc_estim=(
0,0,.15,2000,1988,2002,2,0,0,0,0,0,0,0 \
0,0,.15,2000,1988,2002,2,0,2,0,0,0,0,0 \
0,0,.15,2000,1988,2002,2,0,1,0,0,0,0,0 \
0,0,.15,1500,1988,2002,2,0,0,0,0,0,0,0 \
0,0,.15,1500,1988,2002,2,0,2,0,0,0,0,0 \
0,0,.15,1500,1988,2002,2,0,1,0,0,0,0,0 \
0,0,.15,2500,1988,2002,2,0,0,0,0,0,0,0 \
0,0,.15,2500,1988,2002,2,0,2,0,0,0,0,0 \
0,0,.15,2500,1988,2002,2,0,1,0,0,0,0,0 \
54350,.15,.28,2000,1988,2002,2,0,2,0,0,0,0,0 \
32550,.15,.28,2000,1988,2002,2,0,1,0,0,0,0,0 \
54350,.15,.28,2000,1988,2002,1,0,2,0,0,0,0,0 \
32550,.15,.28,2000,1988,2002,1,0,1,0,0,0,0,0 \
200300,.31,.36,3000,1993,2004,2,0,2,0,0,0,0,0 \
357700,.36,.396,4000,1993,2004,2,0,2,0,0,0,0,0);

local numi=rowsof(eitc_estim);

foreach kk of numlist 1/`numi' {;
cap drop zinc;
gen zinc=taxinc; * replace zinc=(agi-stdded-exemp)/cpi if `kk'<=9;
replace zinc=nystax if eitc_estim[`kk',1]>150000;
matrix estim=eitc_estim[`kk',1..14];
do eitc_elasticity_sub.do;
matrix eitc_estim[`kk',12]=estim[1,12];
matrix eitc_estim[`kk',13]=estim[1,13];
matrix eitc_estim[`kk',14]=estim[1,14];
};

matrix list eitc_estim;

cap drop  eitc_estim*;

svmat eitc_estim;
outsheet eitc_estim* if _n<=`numi' using result_8804.xls, replace;
