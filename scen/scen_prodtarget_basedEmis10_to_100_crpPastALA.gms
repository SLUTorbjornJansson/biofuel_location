* Scenarioprod 10-110%
$setglobal scen _crpPastALALUC_7okt

* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand

* ALA from cropland, and pasture

$setglobal endoDemand ON
*$setglobal optfile 1
$setglobal level 00
$setglobal emistarget 00
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target100_emistarget00_7feb.gdx

* --------------------------------------------------------------------------------
parameter tot_prod(b_fuel);

$setglobal level emis40

execute_load 'results\results_data_rev_EndoON_distrON_gap02_target00_emistarget40_crpPastALA_7okt.gdx'
v_y.l
;
tot_prod(b_fuel) = sum((i, tech), v_y.l(b_fuel, tech,i));
option kill = v_y;

p_prodTarget(b_fuel) = tot_prod(b_fuel);


min_demand(b_fuel, h) = 0;
min_demand(b_fuel, h) = fuelUse_biofuelEqu(b_fuel,h)  * minDemand_share(b_fuel) ;
max_demand(b_fuel, h) = 0;
* --- max demand assumed to be somewhat higher than blend in assumption, but higher than max production target in total
max_demand(b_fuel, h) = fuelUse_biofuelEqu(b_fuel,h) * maxDemand_share(b_fuel);

display p_prodtarget;
if (sum(b_fuel,p_prodtarget(b_fuel))> sum((f,b_fuel,i,g),conversion_factor(f,b_fuel,i)* feedstock(f,g)), abort 'feedstock supply lower than target level');

if (sum(b_fuel,p_prodtarget(b_fuel))< sum((b_fuel,h), min_demand(b_fuel,h)), abort 'Demand min higher than target level');
if (sum(b_fuel,p_prodtarget(b_fuel))> sum((h,b_fuel),max_demand(b_fuel,h)), abort 'Demand max lower than target level');

*execute_unload 'results\param%scen%.gdx' cost_feedstock, investment_cost, investment_cost_var, production_cost, transport_cost_fixed, transport_cost,
*fuel_transport_cost_fixed, fuel_transportcost, capacity_constraint_up, capacity_constraint_lo, p_target;

*$exit


$include 'solve.gms' ;

$include 'reporting.gms'


