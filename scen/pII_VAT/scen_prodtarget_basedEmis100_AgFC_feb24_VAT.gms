* Scenario
* Run all levels for GHG, + 35 and 45%
$setglobal scen _AgFeedC_feb24_VAT

* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand



$setglobal endoDemand ON
$setglobal optfile 1
$setglobal emistarget 00
$setglobal level 00
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget100_7feb.gdx


*  --- Emistarget 100%
* --------------------------------------------------------------------------------

$setglobal level emis100

parameter tot_prod(b_fuel);
execute_load 'results\PII_VAT\results_data_rev_EndoON_distrON_gap005_target00_emistarget100_AgFeedC_feb24_VAT.gdx'
v_y.l
;
tot_prod(b_fuel) = sum((i, tech), v_y.l(b_fuel, tech,i));
option kill = v_y;

p_prodTarget(b_fuel) = tot_prod(b_fuel);


* ---for exogenous demand, max and min demand in tonnes biofuel
max_demand(b_fuel, h) = 0;
min_demand(b_fuel, h) = f_fuel_0("gasE",h)/energy_ekv("ethanol")   * minDemand_share(b_fuel) ;
max_demand(b_fuel, h) = 0;
* --- max demand assumed to be somewhat higher than blend in assumption, but higher than max production target in total
max_demand(b_fuel, h) = sum( blend_fuel $ fuel_blend(blend_fuel,b_fuel), f_fuel_0(blend_fuel,h))/energy_ekv(b_fuel) * maxDemand_share(b_fuel);


* no tax on bio
biotax("ethanol")= 0;
* only add VAT tax based on production cost
p_VAT = 0.25;


* Change feedstock cost to "new"
parameter old_cost_feedstock(f,g);
old_cost_feedstock(f,g) =cost_feedstock(f,g);
cost_feedstock(f,g)= cost_feedstock_Ag(f,g);

* No ALA land
v_feedstock.fx(ab, b_fuel,tech,i,g) = 0;
v_feedstock.fx(abP, b_fuel,tech,i,g) = 0;



$include 'solve.gms' ;

$include 'reporting.gms'










* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

* Reset production costs
cost_feedstock(f,g)= old_cost_feedstock(f,g);

* Reset bound on ALA
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;
v_feedstock.lo(abP,b_fuel,tech,i,g) = 0;
v_feedstock.up(abP,b_fuel,tech,i,g) = +inf;


