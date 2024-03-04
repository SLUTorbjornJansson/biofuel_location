* Scenario
* Run all levels for GHG, + 35 and 45%
$setglobal scen _SA_AgFC_hiFeedAv_feb2024_VAT

* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand



$setglobal endoDemand ON
$setglobal optfile 1
$setglobal level 00
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget100_7feb.gdx


*  --- 70 %
* --------------------------------------------------------------------------------
$setglobal emistarget 70

* --- Scenario main assumption
* Increase feedstock availability by 20%, by putting it on third price level "grass3"

* set deafult setting
parameter base_feedstock(f,g);
base_feedstock(f,g) = feedstock(f,g);

*  Put feedstock increase on third price level, "grass3"
feedstock("grass3",g) = feedstock("grass3",g) + 0.2 * sum(f, feedstock(f,g));



* Change feedstock cost to "new"
parameter old_cost_feedstock(f,g);
old_cost_feedstock(f,g) =cost_feedstock(f,g);
cost_feedstock(f,g)= cost_feedstock_Ag(f,g);

* No ALA land
v_feedstock.fx(ab, b_fuel,tech,i,g) = 0;
v_feedstock.fx(abP, b_fuel,tech,i,g) = 0;



* no biotax
biotax("ethanol")= 0;

*add the VAT on biofuel
p_VAT= 0.25;

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission, well ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset feedstock levels
feedstock(f,g) = base_feedstock(f,g);
* reset emission target
p_emisTarget = deafult_emisTarget;

* Reset production costs
cost_feedstock(f,g)= old_cost_feedstock(f,g);

*remove  the VAT on biofuel
p_VAT= 0;

* Reset bound on ALA
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;
v_feedstock.lo(abP,b_fuel,tech,i,g) = 0;
v_feedstock.up(abP,b_fuel,tech,i,g) = +inf;
