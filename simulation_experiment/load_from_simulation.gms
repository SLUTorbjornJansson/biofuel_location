***  Program extracting data from biofuel model optimzation to use as data for regression
***********************************************************************************************
$setlocal simulations %1


* 
land_area(g,"total",'BM') = landareaSCB(g, "total landareal");
land_area(lan,"total",'BM') = sum(g $ lan_to_kn(lan,g), land_area(g,"total",'BM'));
land_area(g,"arable",'BM') = areaHA2(g,"total akerareal","average15_19");
land_area(lan,"arable",'BM') = sum(g $ lan_to_kn(lan,g), land_area(g,"arable",'BM'));
* Specifying ley as the set "grassareas" : "slatter- och betesvall som utnyttjas", "slattervall och gronfoder","ej utnyttjad slatter- och betesvall",
*"energiskog","trada","ospecificerad akermark","annan obrukad akermark" /;
land_area(g,"ley",'BM') = sum(grassareas, areaHA2(g,grassareas,"average15_19"));
land_area(lan,"ley",'BM') = sum(g $ lan_to_kn(lan,g), land_area(g,"ley",'BM'));



v_yield2(g,'BM') = yield(g,"grass1");
v_yield2(lan,'BM') = sum(g $ lan_to_kn(lan,g), v_yield2(g,'BM') * land_area(g,"arable",'BM'))
                    / sum(g $ lan_to_kn(lan,g), land_area(g,"arable",'BM'));

v_agri_dens(g,'BM') $ land_area(g,"total",'BM') = land_area(g,"arable",'BM') / land_area(g,"total",'BM');
v_agri_dens(lan,'BM') $ land_area(lan,"total",'BM') = land_area(lan,"arable",'BM') / land_area(lan,"total",'BM');



v_ley_dens(g,'BM')$ land_area(g,"arable",'BM')= land_area(g,"ley",'BM') / land_area(g,"arable",'BM');
v_ley_dens(lan,'BM')$ land_area(lan,"arable",'BM')= land_area(lan,"ley",'BM') / land_area(lan,"arable",'BM');

v_ley_elas(g,'BM') = sum(lan$lan_to_kn(lan,g),elas_fodder("grass1",lan));
v_ley_elas(lan,'BM') = elas_fodder("grass1",lan);

* use the feedstock emissions intensity
v_GHG_intensity(g,'BM') = ghg_factor('grass1', "feedstock",g);
v_GHG_intensity(lan,'BM') = sum(g $ lan_to_kn(lan,g), v_GHG_intensity(g,'BM') * land_area(g,"arable",'BM'))
                    / sum(g $ lan_to_kn(lan,g), land_area(g,"arable",'BM'));

v_feedstock_cost2(g,'BM') = cost_feedstock('grass1',g);
v_feedstock_cost2(lan,'BM') = sum(g $ lan_to_kn(lan,g), v_feedstock_cost2(g,'BM') * land_area(g,"arable",'BM'))
                    / sum(g $ lan_to_kn(lan,g), land_area(g,"arable",'BM'));

* add border dummy


* Put some regions as not suitable for facilites, to ease solving
facilitySuitability(b_fuel,tech,i) $borderAndCityMunicipality(i) = 0;
J.fx(b_fuel,tech,i) $ (facilitySuitability(b_fuel,tech,i)=0)  =0;

display facilitySuitability, J.lo, J.up, borderAndCityMunicipality;
v_borderDummy(g,'BM') = sum(i $ sameas(g,i), borderAndCityMunicipality(i));
display v_borderDummy, borderAndCityMunicipality;

*** Load results from simulation experiment

execute_load 'results/pII/results_%simulations%.gdx'
carbonpricetemp=eq_emisTarget.m, v_feedstock.l;

v_carbon_price(g,'BM') = carbonpricetemp;
v_carbon_price(lan,'BM') = sum(g $ lan_to_kn(lan,g), v_carbon_price(g,'BM')) / sum(g $ lan_to_kn(lan,g), 1);


Y_usedfeedstock(grass,b_fuel,tech,i,g,'BM') = v_feedstock.l(grass,b_fuel,tech,i,g);

* for ley land
Y_usedLand(g,'BM')$v_yield2(g,'BM') = sum((grass, b_fuel, tech,i), Y_usedfeedstock(grass,b_fuel,tech,i,g,'BM')/ v_yield2(g,'BM'));
Y_usedLand(lan,'BM')$ sum(g $ lan_to_kn(lan,g), Y_usedLand(g,'BM')) = sum(g $ lan_to_kn(lan,g), Y_usedLand(g,'BM'));
Y_landShare(g,'BM') $ land_area(g,"arable",'BM')  = Y_usedLand(g,'BM')/ land_area(g,"arable",'BM') ;
Y_landShare(lan,'BM') $ sum(g $ lan_to_kn(lan,g), land_area(g,"arable",'BM')) = sum(g $ lan_to_kn(lan,g), Y_usedLand(g,'BM'))
                                                                                  / sum(g $ lan_to_kn(lan,g), land_area(g,"arable",'BM')) ;

display v_yield2, v_agri_dens, v_ley_dens, v_GHG_intensity, v_feedstock_cost2, v_borderDummy, v_carbon_price;

*assign data id
    data_point('%2',reg, 'yield') = v_yield2(reg,'BM');
    data_point('%2',reg,'agriDens') = v_agri_dens(reg,'BM');
    data_point('%2',reg,'leyDens') = v_ley_dens(reg,'BM');
    data_point('%2',reg,'leyElas') = v_ley_elas(reg,'BM');
    data_point('%2',reg,'GHGintensity') = v_GHG_intensity(reg,'BM');
    data_point('%2',reg,'feedstockCost') = v_feedstock_cost2(reg,'BM');
    data_point('%2',reg,'borderDummy') = v_borderDummy(reg,'BM');
    data_point('%2',reg,'carbonPrice') = v_carbon_price(reg,'BM');
    data_point('%2',reg,'landShare') = Y_landShare(reg,'BM');
*    data_point('%2',lan,'landShare') = Y_landShare(lan,'BM');

letter_scen_map('%2','%1')=yes;






