* ---------------------------------------------------------------------------------------------------------------
* Run several scenarios
* ---------------------------------------------------------------------------------------------------------------

* --- Inital settings, can be changed for each scenario

* Specify if Endogenous demand is used (on), or exogenous (OFF)
$setglobal endoDemand ON
* Specify if biofuel produced is distributed to end user (ON), or not (OFF)
$setglobal distributeBiofuel ON

* Turn on or off ethanol (p_prodtarget and v_y =0) (use ethanol on =0)
$setglobal noEth 0

$setglobal level 70
$setglobal emistarget 70
$setglobal fixedlocations

$setglobal scen _normal


$setglobal gap 005
* reslim deafult 300, for 300 minutes (* 60)
$setglobal reslim 1440
$setglobal mipstart 1
* threads deafult =1;
$setglobal threads 30
* to use 1 startvalue: 1
$setglobal start_value1 1
*To use holdfixed variables file: 1
$setglobal holdfixed_var 0

$setglobal distConstr 0

$setglobal optfile 1

$setglobal startValueFile results\PII\results_data_rev_noDemand_gap005_target00_ND_Ctarget_gas50percent


* --- can NOT  be set by scenario
$setglobal data data_rev
* Use limited part of fuel cost segments (ON/OFsmallFuelSetF)(ON default)
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

* --------------------------------
* Add data
* ---------------------------------

$include 'data\%data%.gms'

$include 'reporting_parameters.gms'

$ontext
* Add randum small differnces in data
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
md_consumer(endF_fuel, h)= md_consumer(endF_fuel, h)*random_mtpl2(h);
$offtext

* -------------------------------------------------
$include 'LP/equations_policy.gms'
equation eq_fix(b_fuel,tech,i);
*equation eq_fix_y(b_fuel,tech,i);
*equation eq_fix_feedstock(f,b_fuel,tech,i,g);
*equation eq_fix_y_sales(b_fuel,tech,i,h);
*equation eq_fix_gas(f_fuel, h);
parameter fix(b_fuel,tech,i);
parameter fix_y(b_fuel,tech,i);
parameter fix_feedstock(f,b_fuel,tech,i,g);
parameter fix_y_sales(b_fuel,tech,i,h);
parameter fix_tot_demand(f_fuel,h);


fix(b_fuel,tech,i)=0;
eq_fix(b_fuel,tech,i)..
J(b_fuel,tech,i) =e= 1$fix(b_fuel,tech,i)+0;
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

Model m_locateLP /all/;
*-----------------------------------------------

* Do not use extra end use
*v_endY.fx(extraEndF_fuel,h)= 0;

* Priority order of integer variables
*m_locate.prioropt = 1;
*J.prior(fuel,"high",i)   = 1;
*J.prior(fuel,"low",i)   = 2;
*J.prior(fuel,"medium",i)  = 3;

* Restrict facilities per region and facilities in the country
max_facilityReg = 1;

facility_max(tech)=10;
*facility_max(tech) $ [sum((fuel, i), conversion_factor("grass1",fuel,i)) and  sum((fuel, i), capacity_constraint_lo(fuel,tech,i))] = sum((f,g), feedstock(f,g)) /
*                                          [sum((fuel,i) $ (conversion_factor("grass1",fuel,i) and  capacity_constraint_lo(fuel,tech,i)), capacity_constraint_lo(fuel,tech,i)/conversion_factor("grass1",fuel,i))
*                                              /sum((fuel, i) $ conversion_factor("grass1",fuel,i),1)]
*                                    ;


* --- Check some data

parameter checks(*,*);
* fossil q compared ethanol
checks("ethmax","SE")=sum((f,g), feedstock(f,g)*0.3)*energy_ekv("ethanol");
checks("fossilmax", "se")= sum((blend_fuel,h), f_fuel_0(blend_fuel,h));

execute_load 'results\PII\results_%data%_noDemand_gap005_target00_ND_Ctarget_gas40percent.gdx'
v_totEmissions.l, v_tot_cost.l;

* prodtarget emissions vs climate target
checks("emis_eth70target", "se")= v_totemissions.l;
*checks("emis_70_Ctarget", "se")=  0.7 * (sum(h, f_fuel_0("gasE",h)) * ghg_factor("all", "gasoline","all") + sum(h, f_fuel_0("dieB",h)) * ghg_factor("all", "diesel", "all"));
p_prodTarget(b_fuel) = %level%/100 * max_target(b_fuel) ;
* cost per TJ ethanol
checks("cost_per_TJ_eth", "se") = v_tot_cost.l/(p_prodTarget("ethanol")*energy_ekv("ethanol"));
checks("cost_per_TJ_gas", "1") = sum(h, md_consumer("gasE_1", h)) / sum(h $md_consumer("gasE_1", h), 1);
checks("price_gas", "se") = p_0("gasE");
checks("cost_per_co2_reduction", "se")= checks("cost_per_TJ_gas", "1")/(ghg_factor("all", "gasoline","all")/energy_ekv("gas"));
checks("cost_per_co2_eth", "se")=  v_tot_cost.l/v_totEmissions.l;

*display checks, p_prodtarget, energy_ekv, v_tot_cost.l;
*$exit

parameter emis(*);
*emis("fossil") = [sum(h, f_fuel_0("dieB",h)) * ghg_factor("all", "diesel","all")/energy_ekv("die")
*                        + sum(h, f_fuel_0("gasE",h)) * ghg_factor("all", "gasoline","all")/energy_ekv("gas")]*0.75;
execute_load 'results\results_%data%_noDemand_gap005_target00_ND_Ctarget_gas40percent.gdx'
v_totEmissions.l;


display  p_emisTarget, max_redY, v_tot_demand.lo, f_fuel_0;
*$exit

* Set a deafult emission target to be able to reset
parameter deafult_emisTarget;
deafult_emisTarget = p_emisTarget;

* ---------------------------------------
* Run scenarios
* ---------------------------------------
$ontext
* PROBLEM TO SOLVE ONLY LP AS THEN INVESTMENT COST CANNOT BE BASED ON YES/NO
$setglobal scen _normal_LP

* NO ab fedstock
v_feedstock.fx(ab,fuel,tech,i,g) = 0;

$setglobal level 70
$setglobal startlevel 70_01percent
$include 'scenario_setting_LP.gms';

* let v_feedstock be positive free
v_feedstock.lo(ab,fuel,tech,i,g) = 0;
v_feedstock.up(ab,fuel,tech,i,g) = +inf;

$offtext
* ---------------------------------------

parameter p_J(b_fuel,tech,i) 'values of J from other scenario';
Parameter p_feedstock(f,b_fuel,tech,i,g) ;
Parameter p_y_sales(b_fuel,tech,i,h);
Parameter p_y(b_fuel,tech,i);
parameter p_tot_demand(fuels, h);

$include scen/scen_Emistarget_10_to_100_LP.gms




