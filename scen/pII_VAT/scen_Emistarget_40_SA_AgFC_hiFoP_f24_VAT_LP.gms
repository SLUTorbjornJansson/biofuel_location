* Scenario
* Run all levels for GHG, + 35 and 45%
$setglobal scen _SA_AgFC_hiFoP_feb24_VAT

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
* 20% lower initial price

p_0(blend_fuel) = p_0(blend_fuel) * 1.2;
* Assume that we have the same quantity at a higher price (shifted demand curve)

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


* No tax on biofuel
biotax("ethanol")= 0;

* Add the VAT of 25%
p_VAT=0.25;


* Change feedstock cost to "new"
parameter old_cost_feedstock(f,g);
old_cost_feedstock(f,g) =cost_feedstock(f,g);
cost_feedstock(f,g)= cost_feedstock_Ag(f,g);

* No ALA land
v_feedstock.fx(ab, b_fuel,tech,i,g) = 0;
v_feedstock.fx(abP, b_fuel,tech,i,g) = 0;





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

* Reset bound on ALA
v_feedstock.lo(ab,b_fuel,tech,i,g) = 0;
v_feedstock.up(ab,b_fuel,tech,i,g) = +inf;
v_feedstock.lo(abP,b_fuel,tech,i,g) = 0;
v_feedstock.up(abP,b_fuel,tech,i,g) = +inf;




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





