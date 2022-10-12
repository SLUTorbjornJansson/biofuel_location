*******************************
* Generate background data
*******************************

$setglobal setting data_rev
$setglobal level 10

$setglobal tonneM3 1000;
$setglobal SEK_CO2 1000000;

$include 'declarations.gms'

* ---------------------------------
* Add data
* ---------------------------------

$include data\%setting%.gms


* --- Load data of share of land in a certain land class
$gdxin 'data\municipality_areas_land.gdx'
$load
parameter landArea(*,*);
$load landArea
$GDXIN
parameter land_area2(*,*);
land_area2(h, "total")=landarea(h, "total landareal");
land_area2(g, "arable")=areaHA2(g,"total akerareal","average15_19");

execute_unload 'results\land_area.gdx' land_area2;
execute 'gdxxrw.exe results\land_area.gdx o=results\land_area.xls par=land_area2 rng=landArea! rdim=1 cdim=1';


* --- Feedstock per hectare to xls file
parameter feedstockAreaShare(g);
feedstockAreaShare(g)= sum(f,feedstock(f,g))/landArea(g,"total landareal");

execute_unload 'results\feedstock_share.gdx' feedstockAreaShare;
execute 'gdxxrw.exe results\feedstock_share.gdx o=results\feedstock_share.xls par=feedstockAreaShare rdim=1 cdim=0'

* --- Feedstock cost per region to xlx file
parameter feedstockCost(g);

* Using first price level
* Using first price level
feedstockCost(g)= cost_feedstock("grass1",g);
execute_unload 'results\feedstock_cost.gdx' feedstockCost;
execute 'gdxxrw.exe results\feedstock_cost.gdx o=results\feedstock_cost.xls par=feedstockCost rdim=1 cdim=0'
$ontext

* --- Fuel density
parameter demandAreaShare(h) 'Percentage of demand per hectare';
demandAreaShare(h)=
    fuelUse_liquid(h)
    /landArea(h,"total landareal");
execute_unload 'results\demand_dens.gdx' demandAreaShare;
execute 'gdxxrw.exe results\demand_dens.gdx o=results\demand_dens.xls par=demandAreaShare rdim=1 cdim=0'

* ---- Aviation fuel density
$gdxin 'data\air_passengers.gdx'
$load
parameter avePassenger(*);
$load avePassenger
$GDXIN


parameter demandAreaShareAviation(h)'Percentage of aviation demand per hectare';
demandAreaShareAviation(h)
= total_fuelUse_liquid("liquid", "total")*(avePassenger(h)/avePassenger("totalt"))
    /landArea(h,"total landareal");
execute_unload 'results\demand_densAviation.gdx' demandAreaShareAviation;
execute 'gdxxrw.exe results\demand_densAviation.gdx o=results\demand_densAviation.xls par=demandAreaShareAviation rdim=1 cdim=0'


* --- Shipping fuel density
$gdxin 'data\shipping.gdx'
$load
parameter shipping_fuel(*);
$load shipping_fuel
$GDXIN

parameter demandAreaShareShipping(h) 'Percentage of shipping demand per hectare';
demandAreaShareShipping(h)
= total_fuelUse_liquid("liquid", "total")*(shipping_fuel(h)/shipping_fuel("totalt"))
    /landArea(h,"total landareal");

execute_unload 'results\demand_densShipping.gdx' demandAreaShareShipping;
execute 'gdxxrw.exe results\demand_densShipping.gdx o=results\demand_densShipping.xls par=demandAreaShareShipping rdim=1 cdim=0'


* --- Abandoned land
* --- Load data of share of land in a certain land class
$gdxin 'results\results_data_rev_noDemand_gap025_target00_Ndemand_Ctarget.gdx'
$load
parameter feedstock2(*,*);
$load feedstock2=feedstock
$GDXIN

* --- Feedstock per hectare to xls file
parameter ABfeedstockAreaShare(g);
ABfeedstockAreaShare(g)= sum(ab,feedstock2(ab,g))* tTonne_convert/landArea(g,"total landareal");

execute_unload 'results\feedstock_shareAB.gdx' ABfeedstockAreaShare;
execute 'gdxxrw.exe results\feedstock_shareAB.gdx o=results\feedstock_shareAB.xls par=ABfeedstockAreaShare rdim=1 cdim=0'

* --- Fuel elasticities
* --- Load data of share of land in a certain land class
$gdxin 'data\fuel_elasticities.gdx'
$load
*parameter elas_fuel(*,*);
$load elas_fuel
$GDXIN


elas_fuel(h,"gasE") =  sum(lan $ lan_to_kn(lan,h), elas_fuel(lan,"gasE"));

parameter gasElas(h);
gasElas(h)= elas_fuel(h,"gasE");
display elas_fuel, gasElas;
execute_unload 'results\cheeck' gasElas, elas_fuel;
*$exit
execute_unload 'results\elasFuel.gdx' gasElas;
execute 'gdxxrw.exe results\elasFuel.gdx o=results\elasFuel.xls par=gasElas rdim=1 cdim=0'
$offtext
* --- Initial  fuel emissions
* from TJ to m3, to multiply with emission factor per m3
parameter p_base_Emis(*, h);
p_base_Emis("gas", h) = f_fuel_0("gasE",h)/energy_ekv("gas") * ghg_factor("all","gasoline","all");
p_base_Emis("die", h) = f_fuel_0("gasE",h) /energy_ekv("die") * ghg_factor("all","diesel","all") ;
p_base_Emis("Total", h) = p_base_Emis("gas", h)+ p_base_Emis("die", h);

execute_unload 'results\baseEmis.gdx' p_base_Emis;
execute 'gdxxrw.exe results\baseEmis.gdx o=results\baseEmis.xls par=p_base_Emis rdim=2 cdim=0'

* --- Initial cost fuel level

parameter p_base_FuelCost(*, h);
p_base_FuelCost("gas", h) = f_fuel_0("gasE",h) * p_0("gasE") ;
p_base_FuelCost("die", h) = f_fuel_0("dieB",h) * p_0("dieB") ;
p_base_FuelCost("Total", h) = p_base_FuelCost("gas", h)+ p_base_FuelCost("die", h);

parameter f_fuel_0_2(*,*);
f_fuel_0_2(h,"gasE") =f_fuel_0("gasE",h);
f_fuel_0_2(h,"dieB") =f_fuel_0("dieB",h);
execute_unload 'results\baseFuelCost.gdx' p_base_FuelCost, f_fuel_0_2;
execute 'gdxxrw.exe results\baseFuelCost.gdx o=results\baseFuelCost.xls par=p_base_FuelCost rng=base_fuel_cost! rdim=2 cdim=0 '
execute 'gdxxrw.exe results\baseFuelCost.gdx o=results\baseFuelCost.xls par=f_fuel_0_2 rng=fuel0! rdim=1 cdim=1 '
*rdim=2 cdim=0 


