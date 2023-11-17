*  scenario setting LP
* --------------------

* Set production target
* percentage ov the levels, of max target becomes target for that level
p_prodTarget(b_fuel) = %level%/100 * max_target(b_fuel);



* ---for exogenous demand, max and min demand in tonnes biofuel
min_demand(b_fuel, h) = 0;
min_demand(b_fuel, h) = f_fuel_0("gasE",h)/energy_ekv("ethanol")   * minDemand_share(b_fuel) ;
max_demand(b_fuel, h) = 0;
* --- max demand assumed to be somewhat higher than blend in assumption, but higher than max production target in total
max_demand(b_fuel, h) = sum( blend_fuel $ fuel_blend(blend_fuel,b_fuel), f_fuel_0(blend_fuel,h))/energy_ekv(b_fuel) * maxDemand_share(b_fuel);


* Test
display p_prodtarget;
*if (sum(b_fuel,p_prodtarget(b_fuel))> sum((f,b_fuel,i,g),conversion_factor(f,b_fuel,i)* feedstock(f,g)), abort 'feedstock supply lower than target level');

*if (sum(b_fuel,p_prodtarget(b_fuel))< sum((b_fuel,h), min_demand(b_fuel,h)), abort 'Demand min higher than target level');
*if (sum(b_fuel,p_prodtarget(b_fuel))> sum((h,b_fuel),max_demand(b_fuel,h)), abort 'Demand max lower than target level');



$include 'LP/solve_LP.gms' ;

$include 'LP/reporting_LP.gms'


