* Scenarioprod 10-110%
$setglobal scen _17jan
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget30_17jan.gdx
* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand

* NO ab fedstock
v_feedstock.fx(ab, b_fuel,tech,i,g) = 0;
$setglobal endoDemand ON
$setglobal optfile 1
$setglobal level 00
$setglobal emistarget 00

*  --- 10 %
* --------------------------------------------------------------------------------

$setglobal emistarget Prod10
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target10_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;


*  --- 20 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod20
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target20_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

*  --- 30 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod30
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target30_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;


*  --- 40 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod40
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target40_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;



*  --- 50 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod50
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target50_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

*  --- 60 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod60
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target60_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

*  --- 70 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod70
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target70_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

*  --- 80 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod80
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target80_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

*  --- 90 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod90
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target90_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

*  --- 100 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod100
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target100_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

*  --- 110 %
* --------------------------------------------------------------------------------
$setglobal emistarget prod110
* load ethanol emission from same production target level
execute_load 'results\results_data_rev_EndoON_distrON_gap005_target100_emistarget00_17jan.gdx'
v_totEmissions.l;
p_emisTarget = v_totEmissions.l;
option kill = v_totEmissions;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;
