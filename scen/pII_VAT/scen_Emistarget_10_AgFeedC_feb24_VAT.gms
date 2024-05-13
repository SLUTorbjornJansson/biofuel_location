* Scenario
* Run all levels for GHG, + 35 and 45%
$setglobal scen _AgFeedC_feb24_VAT

* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand



$setglobal endoDemand ON
$setglobal optfile 1
$setglobal level 00
*$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_crpALAhigh_7dec.gdx
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget20_12may.gdx


*  Set reduction in emissions
* --------------------------------------------------------------------------------
$setglobal emistarget 20



* no tax on bio
biotax("ethanol")= 0;
* only add VAT tax based on production cost
p_VAT = 0.25;


* Change feedstock cost to "new"
parameter old_cost_feedstock(f,g);
old_cost_feedstock(f,g) =cost_feedstock(f,g);
cost_feedstock(f,g)= cost_feedstock_Ag(f,g);

* No ALA land
v_feedstock_prod.fx(ab, b_fuel,g) = 0;
v_feedstock_prod.fx(abP, b_fuel,g) = 0;


* No change in consumption of blended fuel in this scenario
v_yEnergy.fx(blend_fuel,h) = 0;

* Allow a lot of blending-in in this scenario
blend_cap(blend_fuel,h) = 1;


* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission, well ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

* Reset production costs
cost_feedstock(f,g)= old_cost_feedstock(f,g);

* Reset bound on ALA
v_feedstock_prod.lo(ab, b_fuel,g) = 0;
v_feedstock_prod.up(ab, b_fuel,g) = +inf;
v_feedstock_prod.lo(abP,b_fuel,g) = 0;
v_feedstock_prod.up(abP,b_fuel,g) = +inf;


