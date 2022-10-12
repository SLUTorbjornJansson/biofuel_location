* Scenario
* Run all levels for GHG, + 35 and 45%
$setglobal scen _LP_7feb

* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand

* NO ab fedstock
v_feedstock.fx(ab, b_fuel,tech,i,g) = 0;
$setglobal endoDemand ON
$setglobal optfile 1
$setglobal level 00
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget100_7feb.gdx




$ontext
*  --- 10 %
* --------------------------------------------------------------------------------
$setglobal emistarget 10

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

$exit
*  --- 20 %
* --------------------------------------------------------------------------------
$setglobal emistarget 20
* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

*  --- 30 %
* --------------------------------------------------------------------------------
$setglobal emistarget 30

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

*  --- 35 %
* --------------------------------------------------------------------------------
$setglobal emistarget 35

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

*  --- 40 %
* --------------------------------------------------------------------------------
$setglobal emistarget 40

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;


*  --- 45 %
* --------------------------------------------------------------------------------
$setglobal emistarget 45

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;


*  --- 50 %
* --------------------------------------------------------------------------------
$setglobal emistarget 50

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

*  --- 60 %
* --------------------------------------------------------------------------------
$setglobal emistarget 60

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

*  --- 70 %
* --------------------------------------------------------------------------------
$setglobal emistarget 70

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

*  --- 80 %
* --------------------------------------------------------------------------------
$setglobal emistarget 80

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

*  --- 90 %
* --------------------------------------------------------------------------------
$setglobal emistarget 90

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

*  --- 100 %
* --------------------------------------------------------------------------------
$setglobal emistarget 100

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;



*  --- 110 %
* --------------------------------------------------------------------------------
$setglobal emistarget 110

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

*  --- 120 %
* --------------------------------------------------------------------------------
$setglobal emistarget 120

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

$offtext

*  --- 250 %
* --------------------------------------------------------------------------------
$setglobal emistarget 250

* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


$include 'LP/scenario_setting_LP.gms';

* ---- Reset ---

* reset emission target
p_emisTarget = deafult_emisTarget;

* let v_feedstock be positive free
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;

