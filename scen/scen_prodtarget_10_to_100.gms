* Scenarioprod 10-110%
$setglobal scen _7feb

* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand

* NO ab fedstock
v_feedstock.fx(ab, b_fuel,tech,i,g) = 0;
$setglobal endoDemand ON
$setglobal optfile 1
$setglobal level 00
$setglobal emistarget 00
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target100_emistarget00_7feb.gdx

* --------------------------------------------------------------------------------
$setglobal level 100


$include 'scenario_setting.gms' ;


*  --- 10 %
* --------------------------------------------------------------------------------
$setglobal level 10


$include 'scenario_setting.gms' ;


*  --- 20 %
* --------------------------------------------------------------------------------
$setglobal level 20


$include 'scenario_setting.gms' ;

*  --- 30 %
* --------------------------------------------------------------------------------
$setglobal level 30


$include 'scenario_setting.gms' ;


*  --- 40 %
* --------------------------------------------------------------------------------
$setglobal level 40


$include 'scenario_setting.gms' ;



*  --- 50 %
* --------------------------------------------------------------------------------
$setglobal level 50


$include 'scenario_setting.gms' ;

*  --- 60 %
* --------------------------------------------------------------------------------
$setglobal level 60


$include 'scenario_setting.gms' ;

*  --- 70 %
* --------------------------------------------------------------------------------
$setglobal level 70


$include 'scenario_setting.gms' ;

*  --- 80 %
* --------------------------------------------------------------------------------
$setglobal level 80


$include 'scenario_setting.gms' ;

*  --- 90 %
* --------------------------------------------------------------------------------
$setglobal level 90


$include 'scenario_setting.gms' ;




