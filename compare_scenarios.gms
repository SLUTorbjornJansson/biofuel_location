* Compare scenarios
* ----------------------
* Use limited part of fuel cost segments (ON/OFF)(ON default)

$ifi %smallfuelset% == ''  $setglobal smallFuelSet ON


$include declarations.gms
* Use all fuel segments if OFF. Neeeded to compute costs in data
$if %smallFuelSet% == OFF end_fuel(end_fuel_Large) =yes;

*$setglobal tonneM3 1000;
*$setglobal SEK_CO2 1000000;
$include data/data_rev.gms

$ontext
* Load necessary sets
set i;
set g;
set h;

$gdxin 'data\municip_scb.gdx'
$load i=knkod
$LOAD g=knkod
$load h=knkod
$gdxin


$gdxin 'data\kommunlankod_1219_modified.gdx'
$load
sets
lan
lan
lan_to_kn
$load lan lan_to_kn
$gdxin

set fuels /ethanol, methanol, gas, die/;
set fuel(fuels) 'biofuels' /ethanol/;
set tech /low, medium, high/;
set f /grass1, grass2, grass3, ab1, ab2, ab3/;
*set cost_items /feedstock, production_costs,price,var_production,transport,var_investment,fixed_investment,demand_transport, total/;

*set i(knkod) 'facility locations' /set.knkod/;
set knname;
set GHGcat /feedstock, production, investment, transport, distribution, LUC, all, gasoline, gasolinesubs, diesel, allgasoline, carbonstock/;
$offtext

set scen /1*20/;
set graphtechs /low1, low2, low3,medium1, medium2, medium3,medium4, high1,high2,high3,high4/;

* Declare parameters----------
*-------------------------------
$include reporting_parameters.gms
parameter J_comp(b_fuel, tech, *, scen);
parameter comp(*,*,*,*,scen);
parameter highest_cost_comp(f, b_fuel, *, *,cost_items,scen);
parameter feedstock_use_comp(*,*,scen);

parameter y_comp(b_fuel, tech, i,scen);

parameter cost_share_comp(*, *, *,cost_items, *, scen);
parameter tot_cost_comp(*, *, *,*,*, scen);
parameter obj_comp(scen,*);
parameter rep_feedstock2_comp(f, b_fuel,tech,i,g,*,scen);
parameter comp_emissions(*,*,*,*,*,scen);
parameter use_blend_cap(blend_fuel,*,*,scen) "changes in fuel consumption relative blend target, and total fuel values";

parameter scen_name(scen);
parameter p_solveInfo_comp(*,scen);
parameter p_MAC(*,scen);







* Chose scenarios to compare and load their information, and compute results
* ---------------------------------------------
$include comp_res_compares.gms




$ontext
execute_load 'results_%scenario2%.gdx' j2=j.l, highest_cost2 =highest_cost, y2= v_y.l, cost_share2=cost_share, obj2 = v_tot_cost.l;
J_comp, b_fuel, tech, i, "%scenario2%")= J2, b_fuel, tech, i);
highest_cost_comp(f, b_fuel, tech, i,costs,"%scenario2%") = highest_cost2(f, b_fuel, tech, i,costs) ;
y_comp, b_fuel, tech, i,"%scenario2%")= y2, b_fuel, tech, i);
cost_share_comp, b_fuel, tech, i,costs,"%scenario2%") = cost_share2, b_fuel, tech, i,costs);

obj_comp('%scenario2%') = obj2;
$offtext


* Write results to GDX
* ----------------------------
execute_unload 'compare_res\compare_scenarios_%version%.gdx' J_comp, highest_cost_comp,
y_comp, cost_share_comp, tot_cost_comp, obj_comp,rep_feedstock2_comp, comp, prod_comp, feedstock_use_comp
scen_name p_solveInfo_comp, comp_emissions, tot_emis_comp, use_blend_cap, p_MAC
;


*=== Now write to Excel file from GDX
* -----------------------------------------
*=== Since we do not specify a sheet, data is placed in first sheet
execute 'gdxxrw.exe compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=comp'

*=== Write
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=obj_comp rng=NewSheetObj! '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=J_comp rng=NewSheetJ! ' 
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=prod_comp rng=NewSheetProduction! '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=cost_share_comp rng=NewSheetCostShare! '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=tot_cost_comp rng=NewSheetTotCost! '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=rep_feedstock2_comp rng=NewSheetRepFeedstock! '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=scen_name rng=NewSheetScenName! acronyms=1 '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=feedstock_use_comp rng=NewSheetFeedstockUse! '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=comp_emissions rng=NewSheetEmissions! '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=tot_emis_comp rng=NewSheetChangeEmissions! '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=use_blend_cap rng=NewSheetFossilCap! '
execute 'gdxxrw.exe  compare_res\compare_scenarios_%version%.gdx o=compare_res\compare_scenarios_%version%.xls par=p_MAC rng=MAC! '


