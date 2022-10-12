*  scenario setting LP
* --------------------
* percentage ov the levels, of max target becomes target for that level
p_prodtarget(b_fuel) = %level%/100 * max_target(b_fuel);
min_demand(b_fuel, h) = 0;
min_demand(b_fuel, h) =fuelUse_biofuelEqu(b_fuel,h)  * minDemand_share(b_fuel) ;
max_demand(b_fuel, h) = 0;
* --- max demand assumed to be somewhat higher than blend in assumption, but higher than max production target in total
max_demand(b_fuel, h) = fuelUse_biofuelEqu(b_fuel,h) * maxDemand_share(b_fuel) ;


* old version
*max_demand(b_fuel,h)= p_target(b_fuel)* demand_share(b_fuel,h) * 1.2;
*min_demand(b_fuel,h)=0;
*min_demand(b_fuel,h)=p_target(b_fuel)* demand_share(b_fuel,h) * 0.8;

display p_prodtarget;
if (sum(b_fuel,p_prodtarget(b_fuel))> sum((f,b_fuel,i,g),conversion_factor(f,b_fuel,i)* feedstock(f,g)), abort 'feedstock supply lower than target level');

if (sum(b_fuel,p_prodtarget(b_fuel))< sum((b_fuel,h), min_demand(b_fuel,h)), abort 'Demand min higher than target level');
if (sum(b_fuel,p_prodtarget(b_fuel))> sum((h,b_fuel),max_demand(b_fuel,h)), abort 'Demand max lower than target level');

*execute_unload 'results\param%scen%.gdx' cost_feedstock, investment_cost, investment_cost_var, production_cost, transport_cost_fixed, transport_cost,
*fuel_transport_cost_fixed, fuel_transportcost, capacity_constraint_up, capacity_constraint_lo, p_target;

*$exit


$include 'LP/solve_LP.gms' ;

$include 'LP/reporting_LP.gms'
