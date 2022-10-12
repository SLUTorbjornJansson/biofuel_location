* Scenario
* Run all levels for GHG, + 35 and 45%

* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand

* NO ab fedstock
v_feedstock.fx(ab, b_fuel,tech,i,g) = 0;
$setglobal endoDemand ON
$setglobal optfile 1
$setglobal level 00
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget100_7feb.gdx
$setglobal emistarget 70








* -----------------------------------------------------------------------
* Test initial fuel price assumption
* Using 40% target as base


$setglobal scen _SA_loFprice_LP_7feb

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;


* Load values
execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_SA_loFprice_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;



* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


* --- Scenario main assumption
* 20% lower initial price


p_0(blend_fuel) = p_0(blend_fuel) * 0.8;

* Re-calculate consumer losses
md_consumer(end_fuel, h)$ sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), f_fuel_0 (blend_fuel,h))=
* cost based on end of segment
- (fuel_segment(end_fuel)
*, this was an average    + 0.1 - 0.2$(sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1"))
* take the average of the segment, based on the length of each segment
                        + 0.5 * smin(end_fuel2, abs(fuel_segment(end_fuel2))) $(not (sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1")))
* Special treatment of positive fuel increase                      *
                        - 0.5 * fuel_segment("gasE_m1") $ sameas(end_fuel,"gasE_m1")
                        - 0.5 * fuel_segment("dieB_m1") $ sameas(end_fuel,"dieB_m1")
                                )
                              * sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel),
                                        p_0(blend_fuel) * f_fuel_0(blend_fuel,h) / (elas_fuel(h, blend_fuel) * f_fuel_0 (blend_fuel,h)))
                            + sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel)) ;






$include 'LP/scenario_setting_LP.gms';

* --- Reset ---
* Reset initial fuel price

p_0(blend_fuel) = p_0(blend_fuel)/0.8;

* Re-calculate consumer losses
md_consumer(end_fuel, h)$ sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), f_fuel_0 (blend_fuel,h))=
* cost based on end of segment
- (fuel_segment(end_fuel)
*, this was an average    + 0.1 - 0.2$(sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1"))
* take the average of the segment, based on the length of each segment
                        + 0.5 * smin(end_fuel2, abs(fuel_segment(end_fuel2))) $(not (sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1")))
* Special treatment of positive fuel increase                      *
                        - 0.5 * fuel_segment("gasE_m1") $ sameas(end_fuel,"gasE_m1")
                        - 0.5 * fuel_segment("dieB_m1") $ sameas(end_fuel,"dieB_m1")
                                )
                              * sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel),
                                        p_0(blend_fuel) * f_fuel_0(blend_fuel,h) / (elas_fuel(h, blend_fuel) * f_fuel_0 (blend_fuel,h)))
                            + sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel)) ;





* ------------------------------------------------------------------------------
* Test initial fuel price assumption
* Using 40% target as base


$setglobal scen _SA_hiFprice_LP_7feb

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_SA_hiFprice_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;


* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);



* --- Scenario main assumption
* 20% lower initial price

p_0(blend_fuel) = p_0(blend_fuel) * 1.2;

* Re-calculate consumer losses
md_consumer(end_fuel, h)$ sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), f_fuel_0 (blend_fuel,h))=
* cost based on end of segment
- (fuel_segment(end_fuel)
*, this was an average    + 0.1 - 0.2$(sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1"))
* take the average of the segment, based on the length of each segment
                        + 0.5 * smin(end_fuel2, abs(fuel_segment(end_fuel2))) $(not (sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1")))
* Special treatment of positive fuel increase                      *
                        - 0.5 * fuel_segment("gasE_m1") $ sameas(end_fuel,"gasE_m1")
                        - 0.5 * fuel_segment("dieB_m1") $ sameas(end_fuel,"dieB_m1")
                                )
                              * sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel),
                                        p_0(blend_fuel) * f_fuel_0(blend_fuel,h) / (elas_fuel(h, blend_fuel) * f_fuel_0 (blend_fuel,h)))
                            + sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel)) ;





$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_7feb

$include 'LP/scenario_setting_LP.gms';


* --- Reset ---
* Reset initial fuel price

p_0(blend_fuel) = p_0(blend_fuel)/1.2;

* Re-calculate consumer losses
md_consumer(end_fuel, h)$ sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), f_fuel_0 (blend_fuel,h))=
* cost based on end of segment
- (fuel_segment(end_fuel)
*, this was an average    + 0.1 - 0.2$(sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1"))
* take the average of the segment, based on the length of each segment
                        + 0.5 * smin(end_fuel2, abs(fuel_segment(end_fuel2))) $(not (sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1")))
* Special treatment of positive fuel increase                      *
                        - 0.5 * fuel_segment("gasE_m1") $ sameas(end_fuel,"gasE_m1")
                        - 0.5 * fuel_segment("dieB_m1") $ sameas(end_fuel,"dieB_m1")
                                )
                              * sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel),
                                        p_0(blend_fuel) * f_fuel_0(blend_fuel,h) / (elas_fuel(h, blend_fuel) * f_fuel_0 (blend_fuel,h)))
                            + sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel)) ;




* ----------------------------------------------------------

* Test higher blend cap by 50%
* Using 40% target as base


$setglobal scen _SA_2blendCap_LP_7feb

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;


execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_SA_2blendCap_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);

* --- Scenario main assumption
* increase blend cap with  100% (38% original)
blend_cap(blend_fuel,h) = blend_cap(blend_fuel,h)*2;




$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_7feb

$include 'LP/scenario_setting_LP.gms';

* --- Reset ---
* reset blend cap
blend_cap(blend_fuel,h) = blend_cap(blend_fuel,h)/2;


* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------

* Test feedstock cost
* Using 40% target as base


$setglobal scen _SA_loFeedC_LP_7feb

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_SA_loFeedC_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);


* --- Scenario main assumption
* decrease feedstock costs with 20%
cost_feedstock(f,g) = cost_feedstock(f,g)* 0.8;

$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_7feb

$include 'LP/scenario_setting_LP.gms';

* --- Reset ---
* Reset feedstock costs with 20%
cost_feedstock(f,g) = cost_feedstock(f,g)/0.8;



* ------------------------------------------------------------------------------

* Test feedstock cost
* Using 40% target as base


$setglobal scen _SA_hiFeedC_LP_7feb

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_SA_hiFeedC_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);

* --- Scenario main assumption
* decrease feedstock costs with 20%
cost_feedstock(f,g) = cost_feedstock(f,g)* 1.2;



$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_7feb

$include 'LP/scenario_setting_LP.gms';

* --- Reset ---
* Reset feedstock costs with 20%
cost_feedstock(f,g) = cost_feedstock(f,g)/1.2;

* ------------------------------------------------------------------------------

* Test feedstock availability - Increase
* Using 40% target as base


$setglobal scen _SA_hiFeedAv_LP_7feb

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_SA_hiFeedAv_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);

* --- Scenario main assumption
* Increase feedstock availability by 20%, by putting it on third price level "grass3"

* set deafult setting
parameter base_feedstock(f,g);
base_feedstock(f,g) = feedstock(f,g);

*  Put feedstock increase on third price level, "grass3"
feedstock("grass3",g) = feedstock("grass3",g) + 0.2 * sum(f, feedstock(f,g));


$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_7feb

$include 'LP/scenario_setting_LP.gms';

* --- Reset ---
* reset feedstock levels
feedstock(f,g) = base_feedstock(f,g);

* ------------------------------------------------------------------------------
* Test feedstock availability - Decrease
* Using 40% target as base


$setglobal scen _SA_loFeedAv_LP_7feb

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_SA_loFeedAv_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);

* --- Scenario main assumption
* Decrease feedstock availability by 20%, by putting it on third price level "grass3"

* set deafult setting
parameter base_feedstock(f,g);
base_feedstock(f,g) = feedstock(f,g);

*  Put feedstock decrease on third price level, "grass3"
* calculate total decrease
parameter decrease_feedstock(g);
decrease_feedstock(g)= 0.2 * sum(f, feedstock(f,g));
* decrease on grass2 if grass3 too small
feedstock("grass2",g)$[feedstock("grass3",g) < 0.2 * decrease_feedstock(g)]
    = feedstock("grass2",g) - (0.2 * decrease_feedstock(g)-feedstock("grass3",g));
* Decrease grass3 to at most 0
feedstock("grass3",g) = max(0,feedstock("grass3",g) - 0.2 * decrease_feedstock(g));


$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_7feb

$include 'LP/scenario_setting_LP.gms';

* --- Reset ---
* reset feedstock levels
feedstock(f,g) = base_feedstock(f,g);



* ------------------------------------------------------------------------------


* Test elasticities - all equal in sweden based on Tirkaso and Gren
* Using 40% target as base


$setglobal scen _SA_evenElas_LP_7feb

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;

execute_load 'results\results_%data%_EndoON_distrON_gap005_target00_emistarget%emistarget%_SA_evenElas_7feb'
p_J=J.l;

p_J(b_fuel, tech, i)$(p_J(b_fuel, tech, i)<1) = 0 ;

* Set fixed values
fix(b_fuel,tech,i) = p_J(b_fuel,tech,i);

* --- Scenario main assumption
* equal eslasticities in sweden based on Tirkaso and Gren
* Save base elasticities
parameter base_elas(h, blend_fuel);
base_elas(h, blend_fuel) = elas_fuel(h, blend_fuel);

* Set new elasticities
elas_fuel(h, "gasE") = 0.51;
elas_fuel(h, "dieB") = 0.351;


* Re-calculate consumer losses
md_consumer(end_fuel, h)$ sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), f_fuel_0 (blend_fuel,h))=
* cost based on end of segment
- (fuel_segment(end_fuel)
*, this was an average    + 0.1 - 0.2$(sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1"))
* take the average of the segment, based on the length of each segment
                        + 0.5 * smin(end_fuel2, abs(fuel_segment(end_fuel2))) $(not (sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1")))
* Special treatment of positive fuel increase                      *
                        - 0.5 * fuel_segment("gasE_m1") $ sameas(end_fuel,"gasE_m1")
                        - 0.5 * fuel_segment("dieB_m1") $ sameas(end_fuel,"dieB_m1")
                                )
                              * sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel),
                                        p_0(blend_fuel) * f_fuel_0(blend_fuel,h) / (elas_fuel(h, blend_fuel) * f_fuel_0 (blend_fuel,h)))
                            + sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel)) ;




$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_7feb

$include 'LP/scenario_setting_LP.gms';

* --- Reset ---
* Reset fuel elasticities and consumer costs
elas_fuel(h, blend_fuel) = base_elas(h, blend_fuel);


* Re-calculate consumer losses
md_consumer(end_fuel, h)$ sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), f_fuel_0 (blend_fuel,h))=
* cost based on end of segment
- (fuel_segment(end_fuel)
*, this was an average    + 0.1 - 0.2$(sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1"))
* take the average of the segment, based on the length of each segment
                        + 0.5 * smin(end_fuel2, abs(fuel_segment(end_fuel2))) $(not (sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1")))
* Special treatment of positive fuel increase                      *
                        - 0.5 * fuel_segment("gasE_m1") $ sameas(end_fuel,"gasE_m1")
                        - 0.5 * fuel_segment("dieB_m1") $ sameas(end_fuel,"dieB_m1")
                                )
                              * sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel),
                                        p_0(blend_fuel) * f_fuel_0(blend_fuel,h) / (elas_fuel(h, blend_fuel) * f_fuel_0 (blend_fuel,h)))
                            + sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel)) ;



* ------------------------------------------------------------------------------
$exit
* ------------------------------------------------------------------------------
*$offtext
* ------------------------------------------------------------------------------


* Test fuel costs - more segments
* Using 10% target as base


$setglobal scen _SA_manySegments_7feb

* --- Scenario main assumption

* Use limited part of fuel cost segments (ON/OFF)(ON default) - set in mainfile
*-------------------------
*$setglobal smallFuelSet OFF


* Assume emissions from gasoline and diesel should decrease by 40%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok
$setglobal emistarget 10

p_emisTarget = -%emistarget%/ 100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));


$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_3feb
$include 'scenario_setting.gms' ;


* reset emission target
p_emisTarget = deafult_emisTarget;




* ------------------------------------------------------------------------------------------
$setglobal scen _SA_manySegments_7feb

* --- Scenario main assumption

* Use limited part of fuel cost segments (ON/OFF)(ON default) - set in mainfile
*-------------------------
*$setglobal smallFuelSet OFF


* Assume emissions from gasoline and diesel should decrease by 40%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok
$setglobal emistarget 20

p_emisTarget = -%emistarget%/ 100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));


$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_3feb
$include 'scenario_setting.gms' ;


* reset emission target
p_emisTarget = deafult_emisTarget;

* ------------------------------------------------------------------------------


* Test fuel costs - more segments
* Using 30% target as base


$setglobal scen _SA_manySegments_7feb

* --- Scenario main assumption

* Use limited part of fuel cost segments (ON/OFF)(ON default) - set in mainfile
*-------------------------
*$setglobal smallFuelSet OFF


* Assume emissions from gasoline and diesel should decrease by 40%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok
$setglobal emistarget 30

p_emisTarget = -%emistarget%/ 100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));


$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_3feb
$include 'scenario_setting.gms' ;


* reset emission target
p_emisTarget = deafult_emisTarget;



* ------------------------------------------------------------------------------------------
$setglobal scen _SA_manySegments_7feb

* --- Scenario main assumption

* Use limited part of fuel cost segments (ON/OFF)(ON default) - set in mainfile
*-------------------------
*$setglobal smallFuelSet OFF


* Assume emissions from gasoline and diesel should decrease by 40%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok
$setglobal emistarget 60

p_emisTarget = -%emistarget%/ 100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));


$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_3feb
$include 'scenario_setting.gms' ;


* reset emission target
p_emisTarget = deafult_emisTarget;


* ------------------------------------------------------------------------------------------
$setglobal scen _SA_manySegments_7feb

* --- Scenario main assumption

* Use limited part of fuel cost segments (ON/OFF)(ON default) - set in mainfile
*-------------------------
*$setglobal smallFuelSet OFF


* Assume emissions from gasoline and diesel should decrease by 40%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok
$setglobal emistarget 70

p_emisTarget = -%emistarget%/ 100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));


$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap005_target00_emistarget40_3feb
$include 'scenario_setting.gms' ;


* reset emission target
p_emisTarget = deafult_emisTarget;