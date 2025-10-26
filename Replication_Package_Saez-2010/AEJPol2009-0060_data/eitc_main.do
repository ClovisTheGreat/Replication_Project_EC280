* PROGRAM 7/2008 TO EXTRACT EITC DISTRIBUTIONS FOR ANALYSIS FOR BUNCHING PAPER AND SUBSEQUENT PAPER
* ALSO PRODUCES ALL FIGURES AND TABLE 1 estimates
#delimit;

clear;
set mem 300m;
cd c:\manu\papers\done\bunching\stata;

* CAREFUL, WAGES HAVE BEEN BLURRED (AVERAGED OVER GROUPS OF 3, BY STATE*(married vs not) AND SORTING BY WAGE) 
even at bottom;
* BLURRING STARTS in 1996, introduces noise in wage measure, especially in small states;
* blurring by state starts in 1997 (1996 blurring by wages was nationally based);
* when reconstituting wagescalc=agi+agiadj-(sum of all other income components);
* almpd and almrec is blurred nationally, very few cases;
* other income is always missing, moving in agiadj is missing starting in 2000 
(only .25\% (or 55,000) of EIC recipients have moving>0 in 1999);
* only .35\% (or 69,000) EIC recipients receive alimony, less than 10,000 pay alimony;

* need to get rid of singles with no kids and xfpt=0 (claimed as dependents on another return),
* xfpt=0 starts working in 1987;

* closest definition of earny for EIC purposes is wages+schedc-setax/2;
* it will miss W2 income excluded from EIC base (but no alternative observation for non EIC recipients);

* 1974 is placebo year, before EITC was in place;
* CAREFULL: perhaps less many filers ;
* 1975 is the first year EITC in place;
* for years 1975-78;
* eligibility: one kid (under 19 or student) dependent;
* (in some rare occasions, no dep child shows up on tax returns but EITC valid);
* head of household or married filing jointly; 
* employment income = wages -sick pay+ self employment income (sey);
* EITC base=employment income if agi<4000;
* EITC base=agi or employment income if agi>4000 whichever gives smallest EIC;
* EITC schedule: -10% 0-4000, 10%, 4000-8000 (single kink);
* for years 1979-84;
* employment income = wages + self employment income (sey)
* EITC base=employment income if agi<6000
* EITC base=agi or employment income) if agi>6000 whichever gives smallest EIC;
* EITC schedule: -10% 0-5000, 0% 5000-6000, 12.5% 6000-10000 (double kink);
* for years 1985-86;
* EITC schedule: -11% 0-5000, 0% 5000-6500, 12.22% 6500-11000 (double kink);
* for years 1987, subsidy rate increases, plateau expanded (88),
phasing out range expanded;
* EITC schedule 1987: -14% 0-6075, 0% 6075-6925, 10% 6925-15432;
* EITC schedule 1988: -14% 0-6225, 0% 6225-9875, 10% 9875-18575;
* EITC schedule 1989: -14% 0-6500, 0% 6500-10250, 10% 10250-19340;
* EITC schedule 1990: -14% 0-6800, 0% 6800-10750, 10% 10750-20295, TO CHECK;
* For years 1991-1993: further expansion of rates, multi-children;
* (health insurance credit: -6%, 0, 4.3%);
* (child born in the year: -5%, 0, 3.6%); 
* EITC schedule 1991: -16.5% 0-7100, 0% 7100-11250, 11.9% 11250-21250;
* EITC schedule 1992: -17.5% 0-7500, 0% 7500-11850, 12% 11850-22370;
* EITC schedule 1993: -22% 0-7750, 0% 7750-12200, 13.2% 12200-23050;

* For years 1994-1998: big expansion, zero and multi-children effective;
* EITC schedule 1994;
* no kids: -7.65% 0-4000, 0% 4000-4975, 7.65% 4975-8975;
* one kid: -26.5% 0-7750, 0% 7750-11000, 16% 11000-23755;
* two kids: -31% 0-8450, 0% 8450-11000, 17.7% 11000-25295;
* EITC schedule 1995;
* no kids: -7.65% 0-4125, 0% 4125-5150, 7.65% 5150-9230;
* one kid: -34% 0-6150, 0% 6150-11300, 16% 11300-24396;
* two kids: -36% 0-8600, 0% 8600-11300, 20.2% 11300-26672;
* EITC schedule 1996;
* no kids: -7.65% 0-4200, 0% 4200-5300, 7.65% 5300-9500;
* one kid: -34% 0-6350, 0% 6350-11650, 16% 11650-25078;
* two kids: -40% 0-8890, 0% 8890-11650, 21% 11650-28495;
* EITC schedule 1997;
* no kids: -7.65% 0-4300, 0% 4300-5450, 7.65% 5450-9770;
* one kid: -34% 0-6500, 0% 6500-11950, 16% 11950-25760;
* two kids: -40% 0-9100, 0% 9100-11950, 21% 11950-29290;
* EITC schedule 1998;
* no kids: -7.65% 0-4460, 0% 4460-5570, 7.65% 5570-10030;
* one kid: -34% 0-6680, 0% 6680-12260, 16% 12260-26473;
* two kids: -40% 0-9390, 0% 9390-12260, 21% 12260-30095;
* EITC schedule 1999;
* no kids: -7.65% 0-4530, 0% 4530-5670, 7.65% 5670-10200;
* one kid: -34% 0-6800, 0% 6800-12460, 16% 12460-26928;
* two kids: -40% 0-9540, 0% 9540-12460, 21% 12460-30580;
* EITC schedule 2000;
* no kids: -7.65% 0-4600, 0% 4600-5800, 7.65% 5800-10380;
* one kid: -34% 0-6900, 0% 6900-12700, 16% 11950-27413;
* two kids: -40% 0-9700, 0% 9700-12700, 21% 11950-31152;
* EITC schedule 2001;
* no kids: -7.65% 0-4760, 0% 4760-5950, 7.65% 5950-10710;
* one kid: -34% 0-7140, 0% 7140-13090, 16% 13090-28281;
* two kids: -40% 0-10020, 0% 10020-13090, 21% 13090-32121;
* EITC schedule 2002; * for married plateau is \$1000 longer in 2002;
* no kids: -7.65% 0-4910-6150-11060;
* one kid: -34% 0-7370-13520-29201;
* two kids: -40% 0-10350-13520-33178;
* EITC schedule 2003; * for married plateau is \$1000 longer in 2003;
* no kids: -7.65% 0-4990-6240-11230;
* one kid: -34% 0-7490-13730-29666;
* two kids: -40% 0-10510-13730-33692;
* EITC schedule 2004; * for married plateau is \$1000 longer in 2004;
* no kids: -7.65% 0-5100-6390-11490;
* one kid: -34% 0-7660-14040-30338;
* two kids: -40% 0-10750-14040-34458;
* EITC schedule 2005; * for married plateau is \$2000 longer in 2005;
* no kids: -7.65% 0-5220-6530-11750;
* one kid: -34% 0-7830-14370-31030;
* two kids: -40% 0-11000-14370-34458;
* EITC schedule 2006; * for married plateau is \$2000 longer in 2006;
* no kids: -7.65% 0-5380-6740-12120;
* one kid: -34% 0-8080-14810-32001;
* two kids: -40% 0-11340-14810-36348;
* EITC schedule 2007; * for married plateau is \$2000 longer in 2007;
* no kids: -7.65% 0-5590-7000-12590;
* one kid: -34% 0-8390-15390-33241;
* two kids: -40% 0-11790-15390-37783;
* EITC schedule 2008; * for married plateau is \$3000 longer in 2008;
* no kids: -7.65% 0-5720-7160-12880;
* one kid: -34% 0-8580-15740-33995;
* two kids: -40% 0-12060-15740-38646;

* http://www.taxpolicycenter.org/taxfacts/displayafact.cfm?Docid=36   ;

* official inflation parameters from IRS (see excel file state-code.xls in EITC_IRS directory) from 1981-2008:
0.3867  0.4301  0.4639  0.4811  0.5003  0.5192  0.5325  0.5466  0.5692  0.5962  
0.6251  0.6581  0.6781  0.6988  0.7170  0.7374  0.7577  0.7785  0.7916  0.8061  
0.8311  0.8585  0.8721  0.8920  0.9126  0.9409  0.9776  1.0000:;

* cpi-u-rs, 1960 to 2000:;

* on 6/28/2008, I switched to IRS inflation parameters to align kinks perfectly;
* for X in num 87 88 89 90 91 92 93 94 95 96 97 98 99 2000 2001 2002 2003 2004 \ 
D in num 0.5325  0.5466  0.5692  0.5962 0.6251  0.6581  0.6781  0.6988  0.7170  0.7374  0.7577  
0.7785  0.7916  0.8061 0.8311  0.8585  0.8721  0.8920:;

cap log close;
log using eitc_build.log, replace;

* series SK, SNK, MK, MNK, M1K are based on CPS numbers in excel file income.xls sheet CPS vs tax returns;

for X in num 87 88 89 90 91 92 93 94 95 96 97 98 99 2000 2001 2002 2003 2004 \ 
D in num 0.5325  0.5466  0.5692  0.5962 0.6251  0.6581  0.6781  0.6988  0.7170  0.7374  0.7577  
0.7785  0.7916  0.8061 0.8311  0.8585  0.8721  0.8920 \
SK in num 7252    7320    7587    7752    8004    8326    8550    8961    
9055    9284    9583    9491    9547    9357    9374    9913    10054   10152 \
SNK in num 30691   31937   33144   33279   34161   34887   34670   34975   
36077   36776   37831   38721   39557   40038   42243   42637   43904   44128 \
M1K in num 10032   10013   9829    9750    9319    9328    9320    9452    
9564    9352    9510    9581    9545    9402    9675    9832    9875    9763 \
MK in num 24646   24600   24735   24537   24397   24420   24707   25058   
25241   24920   25083   25269   25066   25248   25980   25792   25914   25793 \
MNK in num 26891   27209   27365   27780   27750   28037   28464   28113   
28617   28647   28521   29048   29704   30063   30612   30955   31406   31926:
 
clear \
use "c:\data\irs\xX" \
cap drop year \
gen cpi=D \ gen popsk=SK \ gen popmk=MK \
gen popsnk=SNK \ gen popmnk=MNK \  gen popm1k=M1K \
gen year=X \ replace year=X+1900 if X<100 \
cap gen dweght=wght \ cap gen dweght=dwght \
replace dweght=100*dweght if X==60 | X==64 | (X>=68 & X<=75) \ 
cap gen dpndx=xocah+0*xocawh if X==75 | (X>=79) \ * dpndx is an approx for EIC kids xocah 
displays about the same correlation with eic=1,2 than xocah+xocawh, correspond in about 90% of cases,
reporting fewer kids for exemptions than for EIC is the most common case (not surprising as exemptions
can be traded but not EIC kids) \
cap gen sey=0 \ * no sey variable (self-empl income) in 1977 \
* only setax variable in 74, 75, 82-86 \
drop if xfpt==0 \ * drop those with no exemption for themselves, works only 1987 and after \
* recalculating wages from 1996 on due to blurring \
* adjustments to AGI \
gen agiadj=0 \
cap replace agiadj=empexp+iraded+irasec+keogh+penlty+almpd if X==87 \
cap replace agiadj=empexp+iraded+irasec+keogh+penlty+almpd+health if X==88 | X==89 \
cap replace agiadj=hsetax+iraded+irasec+keogh+penlty+almpd+health if X>=90 & X<=91 \
cap replace agiadj=hsetax+moving+iraded+irasec+keogh+penlty+almpd+health if X>=92 & X<=96 \
cap replace agiadj=hsetax+moving+iraded+keogh+penlty+almpd+health+stloan if X==97 \
cap replace agiadj=hsetax+moving+iraded+keogh+penlty+almpd+health+stloan if X>=98 & X<=99 \
cap replace agiadj=hsetax+iraded+keogh+penlty+almpd+health+stloan if X==2000 | X==2001 \
cap replace agiadj=eduexp+stloan+tuided+hsetax+iraded+keogh+penlty+almpd+health if X==2003 | X==2002 \
cap replace agiadj=eduexp+stloan+tuided+hsetax+iraded+keogh+penlty+almpd+health+hsave if X==2004 \
* capital gains in AGI \
gen kgagi=0 \
cap replace kgagi=cgagi+cgdist+supgn if (X<=96 & X>=79) | (X>=98) \
cap replace kgagi=cgagi+supgn if X==97 \
* pensions in AGI \
gen peninc=0 \
cap replace peninc=penagi if X==87 \
cap replace peninc=txpen+taxira  if X>=88 & X<=95 \
cap replace peninc=txpen+ftpen  if X>=96 | X==91 \
* totinc excluding wages \
gen totinc_comp=kgagi+inty+divagi+stxref+almrec+schedc+peninc+schede+farm+uiagi+ssagi \
* calculating wages \
gen wagescalc=agi+agiadj-totinc_comp \ replace wagescalc=wages if wagescalc<0 | wages==0 | wagescalc==. \
gen eicbase=wagescalc+schedc+farm-setax/2 \ 

cap replace sey=setax/0.079 if X==74 | X==75 \
cap replace sey=setax/0.0935 if X==82 \
cap replace sey=setax/0.1 if X==83 \ * TO BE CHECKED \
cap replace sey=setax/0.113 if X==84 \
cap replace sey=setax/0.118 if X==85 \
cap replace sey=setax/0.123 if X==86 \
* drop if dpndx==0 & mars!=1 \
gen married=0 \ replace married=1 if mars==2 | mars==3 | mars==6 \
replace dweght=dweght/2 if mars==3 | mars==6 \ * divide weight by 2 for joint filers \
replace married=0 if mars==2 & xfst==0 & X>=2000 \ * qualifying widowers are lumped with married starting on 2000 \
gen single=0 \ replace single=1 if mars==1 \ * SINGLES is a control group \
gen head=0 \ replace head=1 if married==0 & single==0 \ * head of household and widowers \
gen eicbase_cpi=eicbase/D \
keep if eicbase>0 & eicbase_cpi<100000 \
gen self=0 \ replace self=1 if schedc+farm!=0 \
* gen numchild=1 \
* cap replace numchild=eic if X>=94 \
* gen child0=0 \ * replace child0=1 if numchild==0 \
* gen child1=0 \ * replace child1=1 if numchild==1 \
* gen child2=0 \ * replace child2=1 if numchild>=2 \
gen numchild=dpndx \
gen numchild2=min(numchild,2) \
bys married numchild2: egen countmarchild=sum(dweght) \
replace countmarchild=countmarchild/100000 \
drop if mars==3 | mars==6 \ * remove married filing separately never qualify for EIC \
gen eitc=0 \
cap gen earny=eic if X==87 \ 
cap replace eitc=1 if earny>0 & (X!=2000 & X!=2001) \ * careful earny is no good in 2000 and 2001 \
cap replace eitc=1 if eic!=0 & X<=87 \ 
cap replace eitc=1 if (eic!=0 | eicref+eicoff+eicref>0) & (X==2000 | X==2001) \
gen numchild3=min(numchild,3) \
cap gen eic=eitc \ replace eic=eitc if X==87 \
bys married numchild3 eitc: egen countmarchildeitc=sum(dweght) \
replace countmarchildeitc=countmarchildeitc/100000 \ * counts of eitc recipients vs not \
cap gen newtxy=0 \
gen taxinc=newtxy \
cap replace taxinc=agi-totald-exempt if newtxy==0 \
* replace taxinc=taxinc/D \
gen ui=0 \ replace ui=1 if uiagi>0 & uiagi!=. \
gen ssb=0 \ replace ssb=1 if gssb>0 & gssb!=. \
* replace uiagi=uiagi/D \
gen taxprep = 0 \ replace taxprep=1 if prep==1 \
keep dweght year flpdyr eicbase earny wages wagescalc agi self numchild mars married 
single head schedc setax sey ui uiagi ssb eitc eicbase_cpi taxprep count*
cpi pop*  eic eitc \
order agi eicbase earny wages wagescalc schedc  \
save "c:\scratch\irs\eicX.dta", replace ;
count;

clear;
use "c:\scratch\irs\eic87.dta";
for X in num 88 89 90 91 92 93 94 95 96 97 98 99 2000 2001 2002 2003 2004:
append using "c:\scratch\irs\eicX.dta";
replace flpdyr=flpdyr+1900 if flpdyr<100;
gen dweghtnorm=dweght;
replace dweghtnorm=dweght/popsk if married==0 & numchild>0;
replace dweghtnorm=dweght/popsnk if married==0 & numchild==0;
replace dweghtnorm=dweght/popm1k if married==1 & numchild==1;
replace dweghtnorm=dweght/(popmk-popm1k) if married==1 & numchild>1;
replace dweghtnorm=dweght/popmnk if married==1 & numchild==0;
replace dweghtnorm=round(100000*dweghtnorm);
gen dweghtnorm2=dweghtnorm;replace dweghtnorm2=round(dweghtnorm*7/10) if year>=1995;

gen dweghtirs=0;gen numchild2=min(numchild,2);
bys year married numchild2: egen totweght=sum(dweght);
replace dweghtirs=round(10000000000*dweght/totweght);
gen dweghtirs2=dweghtirs;replace dweghtirs2=round(dweghtirs*7/10) if year>=1995;
* dweghtirs gives same weight for each group year*married*numchild2 automatically;

gen eicamt=0; * eic amount in 2008 dollars based on #kids;
replace eicamt=min(eicbase_cpi*.4,4824) if numchild>=2 & year>=1994;
replace eicamt=min(eicamt,4824-(eicbase_cpi-15740)*.2106) if numchild>=2 & year>=1994 & eicbase_cpi>15740;
replace eicamt=min(eicbase_cpi*.34,2917) if numchild==1 & year>=1994;
replace eicamt=min(eicamt,2917-(eicbase_cpi-15740)*.1598) if numchild==1 & year>=1994 & eicbase_cpi>15740;
replace eicamt=0 if eicamt<0;
replace eicamt=min(eicbase_cpi*.0765,438) if numchild==0 & year>=1994;
replace eicamt=min(eicamt,438-(eicbase_cpi-7160)*.0765) if numchild==0 & year>=1994 & eicbase_cpi>7160;
replace eicamt=0 if eicamt<0;

replace eicamt=min(eicbase_cpi*.14,874/0.5466) if numchild>=1 & year<1994;
replace eicamt=min(eicamt,874/0.5466-(eicbase_cpi-9840/0.5466)*.10) if numchild>=1 & year<1994 & eicbase_cpi>9840/0.5466;
replace eicamt=0 if eicamt<0;

save "c:\scratch\irs\eicbig.dta", replace;

* bunching paper figures and table;

clear;
set mem 300m;
use "c:\scratch\irs\eicbig.dta", replace; 
keep if eicbase_cpi<60000; 
sort eicbase_cpi; 
cap gen ones=1; 
gen wage_cpi=wagescalc/cpi;

* Figure 3A, 1995-2004, EITC 1 kid and then 2+ kids;
twoway histogram eicbase_cpi if numchild==1 & year>=1995 & eicbase_cpi<50000  [fweight=dweght], bin(100) clwidth(medthick) clcolor(navy) yaxis(2) xline(8580 15740 33995) ||
line eicamt eicbase_cpi  if eicbase_cpi<50000 & year>=1995 & numchild==1,
msymbol(none) c(l) yaxis(1) ylabel(0(1000)5000,axis(1)) clcolor(black) clpattern(dash)  
ytitle("EIC Amount (2008 $)",axis(1))  ytitle("Earnings Density ($500 bins)",axis(2)) ylabel(, nolabels noticks axis(2)) yscale(axis(1) range(5000))
  xlabel(0(5000)50000)  xtitle("Earnings (2008 $)") xscale(range(50000))  yscale(range(5000))
  yscale(range(.000038) axis(2))
  title("A. One Child") graphregion(fcolor(white))
  legend(label(2 "EIC Amount") label(1 "Density") cols(2) order(1 2));
graph export fig3A_EITC_1kid.wmf, replace;

sum ones if numchild==1 & year>=1995 & eicbase_cpi<50000; 
sum ones [w=dweght] if numchild==1 & year>=1995 & eicbase_cpi<50000; 

twoway histogram eicbase_cpi if numchild>=2 & year>=1995 & eicbase_cpi<50000  [fweight=dweght], bin(100) clwidth(medthick) clcolor(navy) yaxis(2) ||
line eicamt eicbase_cpi  if eicbase_cpi<50000 & year>=1995 & numchild>=2,
msymbol(none) c(l) yaxis(1) ylabel(0(1000)5000,axis(1)) clcolor(black) clpattern(dash)  
ytitle("EIC Amount ($)",axis(1))  ytitle("Earnings Density ($500 bins)",axis(2)) ylabel(, nolabels noticks axis(2)) 
 yscale(axis(1) range(5000)) yscale(range(.00004) axis(2))
  xlabel(0(5000)50000)  xtitle("Earnings (2008 $)") xscale(range(50000))  yscale(range(5000))
  title("B. Two Children or More") graphregion(fcolor(white))
  legend(label(2 "EIC Amount") label(1 "Density") cols(2) order(1 2)) xline(12060 15740 38646);
graph export fig3B_EITC_2kid.wmf, replace;

sum ones if numchild>=2 & year>=1995 & eicbase_cpi<50000;
sum ones [w=dweght] if numchild>=2 & year>=1995 & eicbase_cpi<50000;


* Figure 4, 1995-2004, EITC 1 kid and then 2+ kids, broken down by SEI and no SEI;

twoway 
kdensity eicbase_cpi if numchild==1 & year>=1995 & eicbase_cpi<50000 & self==0  [fweight=dweght], width(400) clwidth(medthick) clpattern(shortdash)  clcolor(black) yaxis(2) ||
kdensity eicbase_cpi if numchild==1 & year>=1995 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(400) clwidth(medthick) clcolor(black) yaxis(2) ||
line eicamt eicbase_cpi  if eicbase_cpi<50000 & year>=1995 & numchild==1,
msymbol(none) c(l) yaxis(1) ylabel(0(1000)5000,axis(1)) clcolor(orange) clpattern(dash)  
ytitle("EIC Amount ($)",axis(1))  ytitle("Earnings Density",axis(2)) ylabel(, nolabels noticks axis(2)) yscale(axis(1) range(5000))
  xlabel(0(5000)50000)  xtitle("Earnings (2008 $)")  xscale(range(50000)) yscale(range(5000))
  title("A. One Child") graphregion(fcolor(white))
  legend(label(3 "EIC Amount") label(1 "Wage Earners") label(2 "Self-Employed") cols(3) order(1 2 3)) xline(8580 15740 33995)
  xline(5580 7080 10080 11580, lpattern(dot) lcolor(gs12));

graph export fig4A_EITC_1kid_sei.wmf, replace;

sum ones if numchild==1 & year>=1995 & eicbase_cpi<50000 & self==0;
sum ones [w=dweght] if numchild==1 & year>=1995 & eicbase_cpi<50000 & self==0;
sum ones if numchild==1 & year>=1995 & eicbase_cpi<50000 & self==1;
sum ones [w=dweght] if numchild==1 & year>=1995 & eicbase_cpi<50000 & self==1;

twoway 
kdensity eicbase_cpi if numchild>=2 & year>=1995 & eicbase_cpi<50000 & self==0  [fweight=dweght], width(400) clwidth(medthick) clpattern(shortdash)  clcolor(black) yaxis(2) ||
kdensity eicbase_cpi if numchild>=2 & year>=1995 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(400) clwidth(medthick) clcolor(black) yaxis(2) ||
line eicamt eicbase_cpi  if eicbase_cpi<50000 & year>=1995 & numchild>=2,
msymbol(none) c(l) yaxis(1) ylabel(0(1000)5000,axis(1)) clcolor(orange) clpattern(dash)  
ytitle("EIC Amount ($)",axis(1))  ytitle("Earnings Density",axis(2)) ylabel(, nolabels noticks axis(2)) yscale(axis(1) range(5000))
  xlabel(0(5000)50000)  xtitle("Earnings (2008 $)")  xscale(range(50000)) yscale(range(5000))
  title("B. Two or More Children") graphregion(fcolor(white))
  legend(label(3 "EIC Amount") label(1 "Wage Earners") label(2 "Self-Employed") cols(3) order(1 2 3)) xline(12060 15740 38646)
   xline(9060 10560 13560 15060, lpattern(dot) lcolor(gs12));

graph export fig4B_EITC_2kid_sei.wmf, replace;

sum ones if numchild>=2 & year>=1995 & eicbase_cpi<50000 & self==0;
sum ones [w=dweght] if numchild>=2 & year>=1995 & eicbase_cpi<50000 & self==0;
sum ones if numchild>=2 & year>=1995 & eicbase_cpi<50000 & self==1;
sum ones [w=dweght] if numchild>=2 & year>=1995 & eicbase_cpi<50000 & self==1;

* Figure 5, bunching dynamics;
twoway 
kdensity eicbase_cpi if numchild==1 & year>=1995 & year<=1999 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(600) clwidth(medthick) clpattern(shortdash)  clcolor(black) yaxis(2) ||
kdensity eicbase_cpi if numchild==1 & year>=2000 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(600) clwidth(medthick) clcolor(black) yaxis(2) ||
line eicamt eicbase_cpi  if eicbase_cpi<50000 & year>=1995 & numchild2==1,
msymbol(none) c(l) yaxis(1) ylabel(0(1000)5000,axis(1)) clcolor(orange) clpattern(dash)  
ytitle("EIC Amount ($)",axis(1))  ytitle("Earnings Density",axis(2)) ylabel(, nolabels noticks axis(2)) yscale(axis(1) range(5000))
  xlabel(0(5000)50000)  xtitle("Earnings (2008 $)")  xscale(range(50000)) yscale(range(5000))
  title("A. One Child (Self-Employed only)") graphregion(fcolor(white))
  legend(label(3 "EIC Amount") label(1 "1995-1999") label(2 "2000-2004") cols(3) order(1 2 3)) xline(8580 15740 33995);
graph export fig5A_EITC_1kid_sei_time.wmf, replace;

sum ones if numchild==1 & year>=1995 & year<=1999 & eicbase_cpi<50000 & self==1;
sum ones [w=dweght] if numchild==1 & year>=1995 & year<=1999 & eicbase_cpi<50000 & self==1;
sum ones if numchild==1 & year>=2000 & eicbase_cpi<50000 & self==1;
sum ones [w=dweght] if numchild==1 & year>=2000 & eicbase_cpi<50000 & self==1;

twoway 
kdensity eicbase_cpi if numchild>=2 & year>=1995 & year<=1999 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(600) clwidth(medthick) clpattern(shortdash)  clcolor(black) yaxis(2) ||
kdensity eicbase_cpi if numchild>=2 & year>=2000 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(600) clwidth(medthick) clcolor(black) yaxis(2) ||
line eicamt eicbase_cpi  if eicbase_cpi<50000 & year>=1995 & numchild>=2,
msymbol(none) c(l) yaxis(1) ylabel(0(1000)5000,axis(1)) clcolor(orange) clpattern(dash)  
ytitle("EIC Amount ($)",axis(1))  ytitle("Earnings Density",axis(2)) ylabel(, nolabels noticks axis(2)) yscale(axis(1) range(5000))
  xlabel(0(5000)50000)  xtitle("Earnings (2008 $)")  xscale(range(50000)) yscale(range(5000))
  title("B. Two or More Children (Self-Employed only)") graphregion(fcolor(white))
  legend(label(3 "EIC Amount") label(1 "1995-1999") label(2 "2000-2004") cols(3) order(1 2 3)) xline(12060 15740 38646);
graph export fig5B_EITC_2kid_sei_time.wmf, replace;

sum ones if numchild>=2 & year>=1995 & year<=1999 & eicbase_cpi<50000 & self==1;
sum ones [w=dweght] if numchild>=2 & year>=1995 & year<=1999 & eicbase_cpi<50000 & self==1;
sum ones if numchild>=2 & year>=2000 & eicbase_cpi<50000 & self==1;
sum ones [w=dweght] if numchild>=2 & year>=2000 & eicbase_cpi<50000 & self==1; 


tab year self [w=dweght];

/*
* sey>0 vs sey<0;
twoway 
kdensity eicbase_cpi if numchild>=2 & year>=1995 & year<=2004 & schedc<0 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(600) clwidth(medthick) clpattern(shortdash)  clcolor(black) yaxis(2) ||
kdensity eicbase_cpi if numchild>=2 & year>=1995 & year<=2004 & schedc>=0 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(600) clwidth(medthick) clcolor(black) yaxis(2) ||
line eicamt eicbase_cpi  if eicbase_cpi<50000 & year>=1995 & numchild>=2,
msymbol(none) c(l) yaxis(1) ylabel(0(1000)5000,axis(1)) clcolor(orange) clpattern(dash)  
ytitle("EIC Amount ($)",axis(1))  ytitle("Earnings Density",axis(2)) ylabel(, nolabels noticks axis(2)) yscale(axis(1) range(5000))
  xlabel(0(5000)50000)  xtitle("Earnings (2008 $)")  xscale(range(50000)) yscale(range(5000))
  title("B. Two or More Children (Self-Employed only)") graphregion(fcolor(white))
  legend(label(3 "EIC Amount") label(1 "1995-1999") label(2 "2000-2004") cols(3) order(1 2 3)) xline(12060 15740 38646);
graph export EITC_2kid_sei_sign.wmf, replace;

* Old EITC
twoway 
kdensity eicbase_cpi if numchild>=1 & year>=1988 & year<=1990 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(300) clwidth(medthick) clpattern(shortdash)  clcolor(black) yaxis(2) ||
kdensity eicbase_cpi if numchild>=1 & year>=1991 & year<=1993 & eicbase_cpi<50000 & self==1  [fweight=dweght], width(300) clwidth(medthick) clcolor(black) yaxis(2) ||
line eicamt eicbase_cpi  if eicbase_cpi<50000 & year<1994 & numchild>=1,
msymbol(none) c(l) yaxis(1) ylabel(0(1000)5000,axis(1)) clcolor(orange) clpattern(dash)  
ytitle("EIC Amount ($)",axis(1))  ytitle("Earnings Density",axis(2)) ylabel(, nolabels noticks axis(2)) yscale(axis(1) range(5000))
  xlabel(0(5000)50000)  xtitle("Earnings (2008 $)")  xscale(range(50000)) yscale(range(5000))
  title("Old EITC (Self-Employed only)") graphregion(fcolor(white))
  legend(label(3 "EIC Amount") label(1 "1988-1990") label(2 "1991-1993") cols(3) order(1 2 3)) xline(11416 18002 33985);
graph export fig5C_EITC_old_sei_time.wmf, replace;
*/

* TABLE 2 ELASTICITY REGRESSIONS calling subroutine eitc_elasticity_sub.do;

* eitc_estim=(zstar,t0,t1,delta,yearmin,yearmax,self,kids,marst,eitc,bstrap,hate,se,sebootstrap);
* self=0: only wage earners, self=1: only self-employed, self=2: all;
* kids=0: no conditions on kids, kids=1: 1 kid, kids=2: 2+ kids, kids=3 (no kid EITC for 1994+);
* marst=0: use everybody (for gap), marst=1 (only singles), mars=2 (only married);
* eitc=1: for eitc estimation (no gap), eitc=2 (eitc gap), eitc=0, reg fed;
* bstrap=1, compute bootstrap se estimates, bstrap=0, do not compute bootstrap se;

matrix input eitc_estim=(
8580,-.34,0,1500,1995,2004,2,1,0,1,1,0,0,0 \
12060,-.4,0,1500,1995,2004,2,2,0,1,1,0,0,0 \
8580,-.34,0,1500,1995,2004,1,1,0,1,1,0,0,0 \
12060,-.4,0,1500,1995,2004,1,2,0,1,1,0,0,0 \
8580,-.34,0,1500,1995,2004,0,1,0,1,1,0,0,0 \
12060,-.4,0,1500,1995,2004,0,2,0,1,1,0,0,0 \

15740,0,.16,1000,1995,2004,2,1,0,1,0,0,0,0 \
15740,0,.21,1000,1995,2004,2,2,0,1,0,0,0,0 \
15740,0,.16,1000,1995,2004,1,1,0,1,0,0,0,0 \
15740,0,.21,1000,1995,2004,1,2,0,1,0,0,0,0 \
15740,0,.16,1000,1995,2004,0,1,0,1,0,0,0,0 \
15740,0,.21,1000,1995,2004,0,2,0,1,0,0,0,0 \

33995,.16,0,1000,1995,2004,2,1,0,2,0,0,0,0 \
38646,.21,0,1000,1995,2004,2,2,0,2,0,0,0,0 \
33995,.16,0,1000,1995,2004,1,1,0,2,0,0,0,0 \
38646,.21,0,1000,1995,2004,1,2,0,2,0,0,0,0 \
33995,.16,0,1000,1995,2004,0,1,0,2,0,0,0,0 \
38646,.21,0,1000,1995,2004,0,2,0,2,0,0,0,0 \

8580,-.34,0,1000,1995,2004,2,1,0,1,0,0,0,0 \
12060,-.4,0,1000,1995,2004,2,2,0,1,0,0,0,0 \
8580,-.34,0,1000,1995,2004,1,1,0,1,0,0,0,0 \
12060,-.4,0,1000,1995,2004,1,2,0,1,0,0,0,0 \
8580,-.34,0,1000,1995,2004,0,1,0,1,0,0,0,0 \
12060,-.4,0,1000,1995,2004,0,2,0,1,0,0,0,0 \

8580,-.34,0,2000,1995,2004,2,1,0,1,0,0,0,0 \
12060,-.4,0,2000,1995,2004,2,2,0,1,0,0,0,0 \
8580,-.34,0,2000,1995,2004,1,1,0,1,0,0,0,0 \
12060,-.4,0,2000,1995,2004,1,2,0,1,0,0,0,0 \
8580,-.34,0,2000,1995,2004,0,1,0,1,0,0,0,0 \
12060,-.4,0,2000,1995,2004,0,2,0,1,0,0,0,0 \

8580,-.34,0,1500,1995,1999,2,1,0,1,0,0,0,0 \
12060,-.4,0,1500,1995,1999,2,2,0,1,0,0,0,0 \
8580,-.34,0,1500,1995,1999,1,1,0,1,0,0,0,0 \
12060,-.4,0,1500,1995,1999,1,2,0,1,0,0,0,0 \
8580,-.34,0,1500,1995,1999,0,1,0,1,0,0,0,0 \
12060,-.4,0,1500,1995,1999,0,2,0,1,0,0,0,0 \

8580,-.34,0,1500,2000,2004,2,1,0,1,0,0,0,0 \
12060,-.4,0,1500,2000,2004,2,2,0,1,0,0,0,0 \
8580,-.34,0,1500,2000,2004,1,1,0,1,0,0,0,0 \
12060,-.4,0,1500,2000,2004,1,2,0,1,0,0,0,0 \
8580,-.34,0,1500,2000,2004,0,1,0,1,0,0,0,0 \
12060,-.4,0,1500,2000,2004,0,2,0,1,0,0,0,0 \

11416,-.16,0,1000,1988,1993,2,0,0,1,0,0,0,0 \
11416,-.16,0,1000,1988,1993,1,0,0,1,0,0,0,0 \
11416,-.16,0,1000,1988,1993,0,0,0,1,0,0,0,0 \
18000, 0,.11,1000,1988,1993,2,0,0,1,0,0,0,0 \
18000, 0,.11,1000,1988,1993,1,0,0,1,0,0,0,0 \
18000, 0,.11,1000,1988,1993,0,0,0,1,0,0,0,0 \
11416,-.140,0,1000,1988,1990,2,0,0,1,0,0,0,0 \
11416,-.140,0,1000,1988,1990,1,0,0,1,0,0,0,0 \
11416,-.140,0,1000,1988,1990,0,0,0,1,0,0,0,0 \
11416,-.184,0,1000,1991,1993,2,0,0,1,0,0,0,0 \
11416,-.184,0,1000,1991,1993,1,0,0,1,0,0,0,0 \
11416,-.184,0,1000,1991,1993,0,0,0,1,0,0,0,0 \
5720,-.0765,0,1000,1995,2004,2,1,0,1,1,0,0,0 \
8580,0,.07650,1000,1995,2004,2,2,0,1,1,0,0,0 );


local numi=rowsof(eitc_estim);

foreach kk of numlist 1/`numi' {;
cap drop zinc;
gen zinc=eicbase_cpi;
matrix estim=eitc_estim[`kk',1..14];
do eitc_elasticity_sub.do;
matrix eitc_estim[`kk',12]=estim[1,12];
matrix eitc_estim[`kk',13]=estim[1,13];
matrix eitc_estim[`kk',14]=estim[1,14];
};

matrix list eitc_estim;

cap drop  eitc_estim*;

svmat eitc_estim;
outsheet eitc_estim* if _n<=`numi' using result1.xls, replace;

log close;
