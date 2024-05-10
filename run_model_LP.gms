* ---------------------------------------------------------------------------------------------------------------
* Run several scenarios
* ---------------------------------------------------------------------------------------------------------------
* --- Inital settings, can be changed for each scenario
* Scenario name ending
$setglobal scen _normal

* Specify if Endogenous demand is used (on), or exogenous (OFF) (a biofuel consumption constraint)
$setglobal endoDemand OFF

* Specify if biofuel produced is distributed to end user (ON), or not (OFF)
$setglobal distributeBiofuel ON

* Model biofeul production or not (i.e. p_prodtarget and v_y =0, in solve.gms) (use biofuel on =0)
$setglobal noBio 0

* Set production target level
$setglobal level 70

*Set emission target level
$setglobal emistarget 70

* max relative optimality gap for MIP model solution (seem to override opt file)
$setglobal gap 005
* reslim deafult 300, for 300 minutes (* 60)
$setglobal reslim 2000

* Use start values for MIP problem (1) or not (0)
$setglobal mipstart 1
* to use 1 as startvalue for all variables: 1
$setglobal start_value1 0

* OPtimization working on  number of threads (deafult =1);
$setglobal threads 6

* Use gams option file (1/0) (osicplex.opt: CPXPARAM_Advance, CPXPARAM_Threads, CPXPARAM_MIP_Display, CPXPARAM_Emphasis_MIP, PXPARAM_MIP_Pool_Capacity, CPXPARAM_MIP_Tolerances_AbsMIPGap                0 
$setglobal optfile 1

*To use holdfixed variables file, i.e. Defining variables that should be holdfixed to zero, i.e no possible values for these as excluded from model: 1
$setglobal holdfixed_var 0

* impose constrint on maximum distance between feedstock and facility (yes=1, no=0)
$setglobal distConstr 0

* Restrict facilities per region 
$setglobal maxfacilityReg 1


* .. and facilities in the country
$setglobal facility_max 10

* Specify if use the equation that facilites canot be to close are used
$setglobal useNeighbourFcn OFF



* Sert default startvalue file for MIPstart
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_25jan.gdx


* --- Settings that can NOT  be set by scenario, as they are defined before equations
$setglobal data data_rev

* Use limited part of fuel cost segments (ON/OFF)(ON default)
$setglobal smallFuelSet ON

$setglobal policy OFF

* --- Model code begins

$include 'write_data.gms'

*$offlisting
$include 'LP/declarations_LP.gms'
* sets for non used variables
set notusedF(f) 'feedstock that is not used in simulation' /wheat/;
*set notusedFuel(fuel) 'fuel not used in model' /methanol/;''

* Use all fuel segments if OFF. Neeeded to compute costs in data
$if %smallFuelSet% == OFF end_fuel(end_fuel_Large) =yes;
* Set not uset set elements away - save memory?
f_eq(f) =NO;
f_eq("grass1")=yes;
f_eq("grass2")=yes;
f_eq("grass3")=yes;
f_eq("ab1")=yes;
f_eq("ab2")=yes;
f_eq("ab3")=yes;
*
tech_eq("medium") =NO;


* --------------------------------
* Add data
* ---------------------------------

* Loads and defines data to parameters
$include data\%data%.gms

* Add paramters connected to reporting
$include 'reporting_parameters.gms'

* -------------------------------------------------
* -------------------------------------------------
*$include 'LP/equations_policy.gms'
$include 'equations.gms'
equation eq_fix(b_fuel, tech,i);
*equation eq_fix_y(b_fuel,tech,i);
*equation eq_fix_feedstock(f,b_fuel,tech,i,g);
*equation eq_fix_y_sales(b_fuel,tech,i,h);
*equation eq_fix_gas(f_fuel, h);
parameter fix(b_fuel,tech,i);
parameter fix_y(b_fuel,tech,i);
parameter fix_feedstock(f,b_fuel,tech,i,g);
parameter fix_y_sales(b_fuel,tech,i,h);
parameter fix_tot_demand(f_fuel,h);


fix(b_fuel,tech_eq,i)=0;
eq_fix(b_fuel,tech_eq,i)..
J(b_fuel,tech_eq,i) =e= 1$fix(b_fuel,tech_eq,i)+0;
$ontext
fix_y(b_fuel,tech,i)=0;
eq_fix_y(b_fuel,tech,i)..
v_y(b_fuel,tech,i) =e= fix_y(b_fuel,tech,i);

fix_y_sales(b_fuel,tech,i,h)=0;
eq_fix_y_sales(b_fuel,tech,i,h)..
v_y_sales(b_fuel,tech,i,h) =e= fix_y_sales(b_fuel,tech,i,h);

fix_feedstock(f,b_fuel,tech,i,g)=0;
eq_fix_feedstock(f,b_fuel,tech,i,g)..
v_feedstock(f,b_fuel,tech,i,g) =e= fix_feedstock(f,b_fuel,tech,i,g);

fix_tot_demand(f_fuel,h) = 0;
eq_fix_gas(f_fuel, h)..
v_tot_demand(f_fuel,h) =e= fix_tot_demand(f_fuel,h);
$offtext


* -----------------------------------------------
*Model m_locateLP /all/;
*--------------------
*-----------------------------------------------


* Set a deafult emission target to be able to reset
parameter deafult_emisTarget;
deafult_emisTarget = p_emisTarget;

* ---------------------------------------
* Run scenarios


parameter p_J(b_fuel,tech,i) 'values of J from other scenario';
Parameter p_feedstock(f,b_fuel,tech,i,g) ;
Parameter p_y_sales(b_fuel,tech,i,h);
Parameter p_y(b_fuel,tech,i);
parameter p_tot_demand(fuels, h);

*$include scen\pIII_VAT\scen_Emistarget_20_ALA_feb24_VAT_LP.gms
*$stop
$include scen\PIII_VAT\%scenariofile%.gms






