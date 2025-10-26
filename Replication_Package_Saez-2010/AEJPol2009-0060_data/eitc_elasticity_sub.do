* PROGRAM 9/2008 that does subroutine to compute elasticities and se (regular and bootstrap) based on vector of input
#delimit;

/*
clear;
set mem 300m;
cd c:\manu\papers\done\bunching\stata;

* bunching paper;
clear;
use "c:\scratch\irs\eicbig.dta", replace;
keep if eicbase_cpi<50000; 
sort eicbase_cpi; */

* I use as input the vector estim=(zstar,t0,t1,delta,yearmin,yearmax,self,kids,mars,eitc);
* self=0: only wage earners, self=1: only self-employed, self=2: all;
* kids=0: no conditions on kids, kids=1: 1 kid, kids=2: 2+ kids;
* marst=0: use everybody (married+single+heads), marst=2 (only married joint), marst=1 (exclude married=single+heads),
(for eitc purposes singles and heads are together);
* eitc=1: for eitc estimation (no gap), eitc=2 (eitc gap), eitc=0, reg fed;
* bstrap=1, compute bootstrap se estimates, bstrap=0, do not compute bootstrap se;

cap drop cte h0 h1 hb bunch group kidscond selfcond marscond;
gen cte=1;gen h0=0;gen h1=0;gen hb=0;gen bunch=0;gen group=0;gen kidscond=0;gen selfcond=0;
gen marscond=0;
cap gen eicbase_cpi=0; cap gen eitc=0; cap gen numchild=0;cap gen xtot=0;

* matrix input estim=(32550,.15,.28,1000,1988,2002,0,0,1,0,0,0,0,0);
* estim=(zstar,t0,t1,delta,yearmin,yearmax,self,kids,marst,eitc,bstrap,hate,stder,stderbs);
local zbar=estim[1,1];local t0=estim[1,2];local t1=estim[1,3];local d=estim[1,4];
local yearmin=estim[1,5];local yearmax=estim[1,6];local selfinc=estim[1,7];
local kids=estim[1,8];local marst=estim[1,9];local eitc=estim[1,10];
local bstrap=estim[1,11];

* EITC married extension;
* replace zinc=eicbase_cpi if `eitc'==1 | `eitc'==2;
replace zinc=eicbase_cpi-1000 if year>=2002 & married==1 & `t1'==0 & `eitc'==2; 
replace zinc=eicbase_cpi-1000 if year>=2002 & married==1 & `t0'==0 & `eitc'==1; 
* replace zinc=taxinc if `eitc'==0;

replace kidscond=1 if `kids'==0 & eitc==1 & `eitc'==1;
replace kidscond=1 if `kids'==0 & (numchild>=1 & year<=1993 & `eitc'==2);
replace kidscond=1 if `kids'==1 & ((eic==1 & year>=1994 & `eitc'==1) | (numchild==1 & year>=1994 & `eitc'==2));
replace kidscond=1 if `kids'==2 & ((eic==2 & year>=1994 & `eitc'==1) | (numchild>=2 & year>=1994 & `eitc'==2));
replace kidscond=1 if `kids'==3 & (eic==0 & year>=1994 & `eitc'==1); * no kids EITC;

replace kidscond=1 if `kids'==0 & `eitc'==0;

cap gen self=0;cap gen kgain=0;cap gen item=0;cap gen cont=0;

replace selfcond=1 if `selfinc'==2;
replace selfcond=1 if `selfinc'==0 & self==0;
replace selfcond=1 if `selfinc'==1 & self==1;
cap replace selfcond=1 if `selfinc'==3 & kgain==1;
cap replace selfcond=1 if `selfinc'==4 & item==1;
cap replace selfcond=1 if `selfinc'==5 & cont==1;

replace marscond=1 if `marst'==0;
replace marscond=1 if `marst'==1 & married==0 & `eitc'!=0;
replace marscond=1 if `marst'==2 & married==1 & `eitc'!=0;
replace marscond=1 if `marst'==1 & married==0 & `eitc'==0;
replace marscond=1 if `marst'==2 & married==1 & `eitc'==0;
replace marscond=0 if mars!=1 & `marst'==1 & `eitc'==0 & `zbar'>0; * need to drop heads as zbar not aligned heads-singles;

/* cap replace marscond=1 if `marst'==1 & mars==1 & `eitc'==0;
cap replace marscond=1 if `marst'==2 & mars==2 & `eitc'==0;
cap replace marscond=1 if `marst'==3 & mars>2 & `eitc'==0; */

replace group=1 if year>=`yearmin' & year<=`yearmax' & kidscond==1 & selfcond==1 & marscond==1;
replace h0=0;replace h0=1 if zinc<`zbar'-`d' & zinc>=`zbar'-2*`d' & group==1;
replace h1=0;replace h1=1 if zinc<`zbar'+2*`d' & zinc>=`zbar'+`d' & group==1;
replace hb=0;replace hb=1 if zinc<`zbar'+`d' & zinc>=`zbar'-`d' & group==1;
replace bunch=hb-h0-h1; replace h1=h1/`d';replace h0=h0/`d';

* adjust zstar upward when zbar=0;
cap gen incadd=0;cap gen taxinc=agi/cpi;
replace incadd=agi/cpi-taxinc;
reg incadd cte [w=dweght] if hb==1, noconstant;
local examt=_b[cte]; 
local zstar=`zbar'+`examt'*(`zbar'==0);display `zstar';

* quadratic direct solution;

mvreg h0 h1 bunch = cte [w=dweght] if h0+h1+hb>0 & group==1, noconstant;
nlcom log(( 2*[bunch]_b[cte]/`zstar'+[h0]_b[cte]-[h1]_b[cte]+((2*[bunch]_b[cte]/`zstar'+[h0]_b[cte]-[h1]_b[cte])^2+ 4*[h0]_b[cte]*[h1]_b[cte])^0.5)/(2*[h0]_b[cte]))/log((1-`t0')/(1-`t1')), post;
matrix estim[1,12]=_b[_nl_1];matrix estim[1,13]=_se[_nl_1];
local e=_b[_nl_1];local se=_se[_nl_1];
display `e';display `se';

* bootstrap standard errors;
cap drop ones;cap drop elas;
cap gen ones=1;cap gen elas=.;
local ii=(1-`bstrap')*400;
set seed 10000;
while `ii'<=399 {;
local ii=`ii'+1;
replace ones=1;
bsample, weight(ones); cap drop dweghtb;
gen dweghtb=ones*dweght;
mvreg h0 h1 bunch = cte [w=dweghtb] if h0+h1+hb>0 & group==1, noconstant;
nlcom log(( 2*[bunch]_b[cte]/`zstar'+[h0]_b[cte]-[h1]_b[cte]+((2*[bunch]_b[cte]/`zstar'+[h0]_b[cte]-[h1]_b[cte])^2+ 4*[h0]_b[cte]*[h1]_b[cte])^0.5)/(2*[h0]_b[cte]))/log((1-`t0')/(1-`t1')), post;
local e=_b[_nl_1]; display `ii'; replace elas=`e' if _n==`ii'; };
_pctile elas, percentiles(2.5 97.5);matrix estim[1,14]=(r(r1)-r(r2))/(2*1.96);
local emin=r(r1);local emax=r(r2);
local seboots=(`emax'-`emin')/(2*1.96);
display `seboots';
