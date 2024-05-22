* Scenario
* Run all levels for GHG, + 35 and 45%
$setglobal scen _100p_FeedC_may

* reach climate target based on 35% reduction of current gasoline emissions (half of 70% target)
* Use new demand



$setglobal endoDemand ON
$setglobal optfile 1
$setglobal level 00
$setglobal startValueFile results\results_data_rev_EndoON_distrON_gap001_target00_emistarget06_100p_FeedC_may.gdx




* Emission target from argument of this batinclude file?
* --------------------------------------------------------------------------------
$set emistarget %1





* No ALA land
*v_feedstock.fx(abP,g) = 0;
*v_feedstock.fx(ab,g) = 0;
*TJ
v_feedstock_prod.fx(abP,b_fuel,g) = 0;
v_feedstock_prod.fx(ab,b_fuel,g) = 0;

* No tax on biofuel
biotax("ethanol")= 0;

* Add the VAT of 25%
p_VAT=0.25;

* Fix fuel use -biofeul replacemtn only possible
v_yEnergy.fx(blend_fuel,h)=0;

**TJ as a consequence, fix also the consumption of blended fuel
*v_endY.fx(end_fuel,h) = 0;
**TJ ... and the consumer surplus change is then also zero
*v_redY_fossilCostGainRed.fx(end_fuel, h) = 0;  
*v_redY_consLoss.fx(end_fuel, h) = 0;


*remove blend -in cap
blend_cap(blend_fuel,h) =1;

* Change feedstock cost to "new"
cost_feedstock(grass,g)= cost_feedstock_Ag(grass,g);



$ifi %scen_has_ini% == yes $goto just_run
* --- Change data to match 100 percentile
* based on median values, for the lowest third of values of feedstockCost
 

scalar s_distance_factor /0.518340  /;
scalar s_yield_factor /0.010376 /  ;
scalar s_ley_factor /0.116681  /   ;
scalar s_ghgIntens_factor /0.042372  /;
scalar s_elas_factor /0.46705   /  ;
scalar s_cost_factor /0.1246   /   ;
 parameter distance_factor  ;
parameter yield_factor     ;
parameter ley_factor       ;
parameter ghgIntens_factor ;
parameter elas_factor      ;
parameter cost_factor      ;
parameter arab_factor(g);

parameter landAreaSCB(*,*);
parameter prodEmistarget;
parameter shareProdOfTotalFuel;


* --- Load data of share of land in a certain land class
$gdxin 'data\municipality_areas_land.gdx'
$load
$load landAreaSCB =landarea
$GDXIN

$setGlobal scen_has_ini yes
$label just_run

distance_factor $ sum(g, landareaSCB(g, "total landareal")) = s_distance_factor /
                    (sum(g, areaHA2(g,"total akerareal","average15_19"))/ sum(g, landareaSCB(g, "total landareal")));



yield_factor $ (sum(g, yield(g,'grass1') * areaHA2(g,"total akerareal","average15_19")) and sum(g $ yield(g,'grass1'), areaHA2(g,"total akerareal","average15_19")))
    = s_yield_factor /
                    (sum(g, yield(g,'grass1') * areaHA2(g,"total akerareal","average15_19"))
                                / sum(g $ yield(g,'grass1'), areaHA2(g,"total akerareal","average15_19")));
                                

ley_factor $ (sum((g,grassareas), areaHA2(g,grassareas,"average15_19")) and sum(g , areaHA2(g,"total akerareal","average15_19")))
     = s_ley_factor /
                    (sum((g,grassareas), areaHA2(g,grassareas,"average15_19"))
                                / sum(g , areaHA2(g,"total akerareal","average15_19")));
                                
ghgIntens_factor $ (sum(g, ghg_factor("grass1","feedstock",g) * areaHA2(g,"total akerareal","average15_19")) and sum(g $ yield(g,'grass1'), areaHA2(g,"total akerareal","average15_19")))
    = s_ghgIntens_factor /
                    (sum(g, ghg_factor("grass1","feedstock",g) * areaHA2(g,"total akerareal","average15_19"))
                                / sum(g $ ghg_factor("grass1","feedstock",g), areaHA2(g,"total akerareal","average15_19")));
                                
elas_factor $ (sum(g, sum(lan$lan_to_kn(lan,g),elas_fodder("grass1",lan))  * areaHA2(g,"total akerareal","average15_19")) and sum(g $ yield(g,'grass1'), areaHA2(g,"total akerareal","average15_19")))
    = s_elas_factor/
                    (sum(g, sum(lan$lan_to_kn(lan,g),elas_fodder("grass1",lan) * areaHA2(g,"total akerareal","average15_19")))
                                / sum(g, areaHA2(g,"total akerareal","average15_19")));

cost_factor $(sum(g, cost_feedstock("grass1",g) * areaHA2(g,"total akerareal","average15_19")) and sum(g , areaHA2(g,"total akerareal","average15_19")))
    = s_cost_factor  /
                    (sum(g, cost_feedstock("grass1",g) * areaHA2(g,"total akerareal","average15_19"))

                                / sum(g , areaHA2(g,"total akerareal","average15_19")));
* Ley area - will be transferred to share ley
    

* Distances - will be transferred to agricultural density
distance_demand(i,h) = distance_demand(i,h)/distance_factor ;
distance(i,g) = distance(i,g) /distance_factor;

* Yield -
yield(g,f) = yield_factor * yield(g,f);

* if share increase by 50%, increase grass1 and grass2 by 50%, adjust grass3 accordingly, to make total available area equal.
* that is, we most care about the corect amount of ey, and then adjust the share arable we can take


* Arable land factor should make sure we have the same amount of land
arab_factor(g)$ feedstock_area(g,"grass3") = (1- ley_factor )* (feedstock_area(g,"grass1") + feedstock_area(g,"grass2"))
                /  feedstock_area(g,"grass3")
                +1;
         
feedstock_area(g,"grass1") = ley_factor  * feedstock_area(g,"grass1");
feedstock_area(g,"grass2") = ley_factor  * feedstock_area(g,"grass2");

* change arable land ara accordingly
feedstock_area(g,"grass3") = feedstock_area(g,"grass3") * arab_factor(g); 


* Available feedstock per region based on yield
feedstock(f,g)=feedstock_area(g,f) * yield(g,f);

* GHG intensity crops
ghg_factor(f,"feedstock",g) = ghgIntens_factor * ghg_factor(f,"feedstock",g);

* Fodder elasticity
* change on county ('lan') regional level
elas_fodder(grass,lan) = elas_factor * elas_fodder(grass,lan);

* Feedstock cost
* change on inital level (grass1)
cost_feedstock_prodOmr(prodOmr,f) = cost_factor * cost_feedstock_prodOmr(prodOmr,f);

* calculate new costs based on costs and elas
* per region g
cost_feedstock(f,g) = sum(prodOmr $ prodOmr_to_kn(g,prodOmr), cost_feedstock_prodOmr(prodOmr,f));

* Calculate costs for other cost categories based on elasticites
cost_feedstock("grass2",g) = sum(prodOmr $ prodOmr_to_kn(g,prodOmr), cost_feedstock_prodOmr(prodOmr,"grass1"))*
                                         (1+area_factor('grass1',g)/ (sum(lan$lan_to_kn(lan,g),elas_fodder("grass1",lan))));
cost_feedstock("grass3",g) =  cost_feedstock("grass2",g)*
                                         (1+area_factor('grass2',g)/ (sum(lan$lan_to_kn(lan,g),elas_fodder("grass2",lan))));
display feedstock, yield, feedstock_area, arab_factor;





* Assume emissions from gasoline and diesel should decrease by 70%
* assume that is these fuels multiplied with emission factors. this will leave out some emission weel ok

p_emisTarget = -%emistarget% /100 * (sum(h, f_fuel_0("gasE",h)/energy_ekv("gas")) * ghg_factor("all", "gasoline","all"));
display p_emisTarget, ghg_factor, f_fuel_0;
display ghg_factor;

*Adjust demand shares when only
* emission per unit biofeul seem to be 0.45 .
* approximate production for the emissions target

prodEmistarget = p_emisTarget/ (ghg_factor("all", "gasolineSubs","all")+ 0.45);
shareProdOfTotalFuel = prodEmistarget / sum(h, f_fuel_0("gasE",h)/energy_ekv("ethanol"));

* let max min demand be 10% above and below teh equal share
minDemand_share(b_fuel) = shareProdOfTotalFuel*0.9;
maxDemand_share(b_fuel) = shareProdOfTotalFuel*1.1;

display prodEmistarget,shareProdOfTotalFuel,minDemand_share,maxDemand_share;



* --- Run scenario

$include 'scenario_setting.gms' ;

* --- Reset ---
* reset emission target
p_emisTarget = deafult_emisTarget;

* Reset bound on ALA
* v_feedstock.lo(ab,g) = 0;
* v_feedstock.up(ab,g) = +inf;
*v_feedstock.lo(abP,g) = 0;
*v_feedstock.up(abP,g) = +inf;
*TJ
v_feedstock_prod.up(abP,b_fuel,g) = +inf;
v_feedstock_prod.up(ab,b_fuel,g)  = +inf;