* Scenario
* Run all levels for GHG, + 35 and 45%
$setglobal scen _SA_AgFC_lowCap_feb24_VAT

* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand



$setglobal endoDemand ON
$setglobal optfile 1
$setglobal level 00
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget100_7feb.gdx


*  --- 40 %
* --------------------------------------------------------------------------------
$setglobal emistarget 40

* --- Scenario main assumption
* decrease blend cap with  50% (38% original)
blend_cap(blend_fuel,h) = blend_cap(blend_fuel,h) * 0.5;

* No ALA land
v_feedstock.fx(ab, b_fuel,tech,i,g) = 0;
v_feedstock.fx(abP, b_fuel,tech,i,g) = 0;

* half feedstock costs for ALA
parameter old_cost_feedstock(f,g);
old_cost_feedstock(f,g) =cost_feedstock(f,g);
cost_feedstock(f,g)= cost_feedstock_Ag(f,g);

* no biotax
biotax("ethanol")= 0;

*add the VAT on biofuel
p_VAT= 0.25;


* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission, well ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load biofeul location values
execute_load 'temp\res_all\pII_VAT\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%%scen%'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<0.99) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* --- Reset ---
* Reset fixed values
p_J(b_fuel, tech, i) = 0;

fix(b_fuel,tech,i) = 0;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

* Reset production costs
cost_feedstock(f,g)= old_cost_feedstock(f,g);
* reset blend cap
blend_cap(blend_fuel,h) = blend_cap(blend_fuel,h)*2;

* Reset bound on ALA
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;
v_feedstock.lo(abP,b_fuel,tech,i,g) = 0;
v_feedstock.up(abP,b_fuel,tech,i,g) = +inf;