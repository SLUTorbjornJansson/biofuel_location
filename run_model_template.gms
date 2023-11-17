* ---------------------------------------------------------------------------------------------------------------
* Main program to run the model
* The model optimizes location of biofuel production facilites, use of feedstock from agricultural land, consumption
* of fossil fuel and biofuel to reach a policy target
* ---------------------------------------------------------------------------------------------------------------

* --- Inital settings, can be changed for each scenario
* Scenario name ending
$setglobal scen _normal

* Specify if Endogenous demand is used (on), or exogenous (OFF) (a biofuel consumption constraint)
$setglobal endoDemand ON

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
$setglobal start_value1 1

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

* -------------------------------------------------------------
* --- Model code begins
* -------------------------------------------------------------

* - Create data files: gdx files from excel
$include 'write_data.gms'

*$offlisting

* - Declaration of sets, parameters (except temporary), variables and equations
$include 'declarations.gms'

* Define sets for non used variables (to decrease variables)
set notusedF(f) 'feedstock that is not used in simulation' /wheat/;
*set notusedFuel, b_fuel, 'fuel not used in model' /methanol/;

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

display f,  f_eq, tech_eq;



* --------------------------------
* Add data
* ---------------------------------

* Loads and defines data to parameters
$include data\%data%.gms

* Add paramters connected to reporting
$include 'reporting_parameters.gms'

$ontext
* Possibility to add randum small differnces in data
$funclibin stolib stodclib

function randuniform     /stolib.duniform    /;


parameter randx(g)    numbers from distributions;

randx(g)=randuniform(-1,1);
parameter randx2(h)    numbers from distributions;

randx2(h)=randuniform(-1,1);

parameter random_mtpl(g);
random_mtpl(g) = 1 + 0.01*randx(g) ;
parameter random_mtpl2(h);
random_mtpl2(h) = 1 + 0.01*randx2(h) ;

cost_feedstock(f,g)=cost_feedstock(f,g)*random_mtpl(g);
md_consumer(end_fuel, h)= md_consumer(end_fuel, h)*random_mtpl2(h);
$offtext

* -------------------------------------------------
$include 'equations.gms'
*-----------------------------------------------


* --- Check some data
*$include checks.gms


* Set a deafult emission target to be able to reset
parameter deafult_emisTarget;
deafult_emisTarget = p_emisTarget;
*execute_unload "%results_out%\res.gdx" deafult_emisTarget;


* ---------------------------------------
* --- Run scenarios
* ------------------------------------------------------------------------------

*$include scen\scen_Emistarget_20_33percentile_feedC_exper.gms
*$exit
*$include scen\scen_Emistarget_noEth_10_to_100.gms
*$include scen\scen_Emistarget_10_25percentile_exper.gms
*$include scen\scen_prodtarget_10_to_100.gms


*$include scen\scen_prodEmistarget_10_to_100.gms
*$include scen\scen_Emistarget_10_to_100_noALA.gms
*$include scen\scen_Emistarget_10_to_100_crpPastALA.gms
*$include scen\scen_Emistarget_10_to_100_crpALALUCdiff_nov.gms
*$include scen\scen_Emistarget_10_to_100_crpALAhigh_nov.gms
*$include scen\scen_Emistarget_10_to_100_crpPastALAhigh_nov.gms

*$include scen\scen_prodtarget_basedEmis10_to_100_crpPastALA.gms



$include scen\%scenariofile%.gms




$exit

