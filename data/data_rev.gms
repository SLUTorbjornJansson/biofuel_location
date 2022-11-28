* ---------------------------------
*  data
*  Biofuel facility location model
* ---------------------------------

* --- Set some conversion factors
* 2019 euro , riksbank.se 1 eur 2019= 10,3697 sek   , 1 sek= 0,0964
scalar Euro_SEK2019 'Euro per SEK 2019'/0.0964/;

* INflation SEK 2007-2019 (334,26 SEK/290,51SEK, SCB) and exchange rate 2007 USD-SEK (1 usd=6.9053, riksbank.se)
scalar inflUSDExrate2007 'inflation between 2007 and 2019, and exc rate USD to SEK 2007'/7.945/;
* Currency conversion from 1 euro 2015 = 9.3467 SEK 2015. Inflation 2015:2019= 334.26/313.35= 1.067. 9.3467*1.067= 9.970
scalar inflEURExrate2015 'inflation between 2015 and 2019, and exc rate EUR to SEK 2015' /9.970/;

scalar tonne_to_Ttonne /0.001/;
scalar m3_to_Tm3 /0.001/;
scalar kg_to_Ttonne /0.000001/;
scalar Eur_to_M_Eur /0.000001/;

* ---------------------------------
* Load data
* ---------------------------------

* --- Load distance data

* MApping between ID :s
$gdxin 'data\municip_scb.gdx'
$load objectid kn_map
$gdxin

alias (knkod,knkod2);
alias (objectid,objectid2);

* Load distance between centroids
parameter dist(objectid,objectid)'distance between centroids with objectid domain';

$gdxin 'data\distance_scb.gdx'
$load dist=d
$gdxin

* Change to muniicpality codes instead of object id numbers
parameter dist2(knkod, objectid)'distance between centroids with knkod domain, first position';
parameter dist3(knkod, knkod)'distance between centroids with knkod domain, second position';
dist2(knkod,objectid)= sum(objectid2 $ kn_map(objectid2,knkod), dist(objectid2, objectid));
dist3(knkod,knkod2)= sum(objectid $ kn_map(objectid,knkod2),dist2(knkod, objectid));

*write distance to the between supply and facility distance, and from facility to demand region
execute_unload 'data\dist_temp.gdx' dist2 dist3;
option kill = dist2;
execute_load 'data\dist_temp.gdx' distance=dist3 distance_demand=dist3;

* Half radius of municipalities could be used for withint municipality distances
$gdxin 'data\municipality_areas_radius.gdx'
$load
parameter halfRadius(*,*);
$load halfRadius
$GDXIN


* load tortuosity factor (from own samle in Googel maps)
$gdxin 'data\tortuosity.gdx'
$load
parameter tortuosity_factor(lan);
$load tortuosity_factor
$GDXIN


* --- DAta on land share per class
* Load data of share of land in a certain land class
$gdxin 'data\municipality_areas_landShare.gdx'
$load
parameter landShare(*,*);
$load landShare
$GDXIN



* --- load agricultural area data

$gdxin 'data\arable_land_area_15_19.gdx'
$load
parameter areaHA2(*,*,*) 'Hectares of agricultural land';

$load areaHA2=AreaHA
$GDXIN



$gdxin 'data\yield_vall.gdx'
$load
parameter yieldHA(*,*,*,*);
$load yieldHA
$GDXIN


$gdxin 'data\yield_vall_prod_omr.gdx'
$load
parameter yieldHA_prodomr(prodomr,*,*);
$load yieldHA_prodomr
$GDXIN

* --- Load data abandonned agricultural land

* agriculturala land data changes from Board of agriculture
* https://statistik.sjv.se/PXWeb/pxweb/sv/Jordbruksverkets%20statistikdatabas/Jordbruksverkets%20statistikdatabas__Arealer__1%20Riket%20l%C3%A4n%20kommun/JO0104B2.px/

*$gdxin 'data\crop_area_2010_2020_SJV.gdx'
*$load
*parameter data_agri_area(g)'HA change in agricultural area 2010 to 2020, SJV';
*$load data_agri_area
*$GDXIN

* Add yield for grass on abanndonned land
* Panoutsou, C. (Ed.). (2017). Modeling and Optimization of Biomass Supply Chains:
* Top-Down and Bottom-up Assessment for Agricultural, Forest and Waste Feedstock. Academic Press.
$gdxin 'data\RCG_yield_GLOBIOM.gdx'
$load
parameter yield_ab(lan) 'tonne per ha';
$load yield_ab
$GDXIN


* Load municipalty data on abandoned agricultural land
$gdxin 'data\ALA_municiaplity_O_and_B_2016.gdx'
$load
parameter ALA_crop(g);
$load ALA_crop
$GDXIN

** Load data on abandoned agricultural land
*$gdxin 'data\ALA_areas.gdx'
*$load
*parameter data_ALA_area(lan);
*$load data_ALA_area
*$GDXIN
*
*
*$gdxin 'data\ALA_areas_pasture.gdx'
*$load
*parameter data_ALA_pasture_area(lan);
*$load data_ALA_pasture_area
*$GDXIN



* --- Load costs

* Alternative costs in sek per tonne
$gdxin 'data\alternative_costs.gdx'
$load
parameter cost_feedstock_prodOmr(prodOmr,f);
$load cost_feedstock_prodOmr
$GDXIN

* Fodder ownprice elasticities
parameter data_elas_fodder(lan);
$gdxin 'data\elasticities.gdx'
$load
$load data_elas_fodder
$GDXIN

* --- Cost of using abandonned land
* we have conversion costs (equal everywhere) and production costs  (regionally differning)
*Havlík, P., Schneider, U. A., Schmid, E., Böttcher, H., Fritz, S., Skalský, R., Aoki K., De Cara S., Kindermann G., Kraxner F., Leduc S., McCallum I., Mosnier A., Sauer T. & Obersteiner, M. (2011).
* Global land-use implications of first and second generation biofuel targets. Energy policy, 39(10), 5690-5702.

$gdxin 'data\conversion_cost.gdx'
$load
parameter conversion_cost_ha(f);
$load conversion_cost_ha
$GDXIN

* Field production costs per tonne
*Panoutsou, C. (Ed.). (2017). Modeling and Optimization of Biomass Supply Chains:
*Top-Down and Bottom-up Assessment for Agricultural, Forest and Waste Feedstock. Academic Press.
$gdxin 'data\RCG_cost_GLOBIOM.gdx'
$load
parameter data_prod_cost(lan);
$load data_prod_cost
$GDXIN


* --- Load ghg emissiion data
* Load GHG data, factors in kg co2 per tonne, m3 or hectare.
* fossil fuels: Naturv�rdsverket (2019a). Emissionsfaktorer och v�rmev�rden 2020. Uppdaterad: 2019-12-02.
* Feedstock: Ahlgren   S., Aronsson   P., Hansson   P-A., Kimming   M. and Lundkvist   H. (2011). Greenhouse gas emissions from cultivation of agricultural crops for biofuels and production of biogas from manure - Implementation of the Directive of the European Parliament and of the Council on the promotion of the use of energy from renewable sources.
*Revised edition including supplementary calculations for additional crops. Dnr SLU ua 12-4067/08, Swedish University of Agricultural Sciences, Uppsala, Sweden.
* production : from greet model, Bonomi, A., Cavalett, O., Colling Klein, B., Ferreira Chagas, M. and Rinke Dias Souza, N. (2019). Comparison of Biofuel
* Life Cycle Analysis Tools. Phase 2, Part 2: biochemical 2G ethanol production and distribution. Technical Report. IEA Bioenergy.
* LUC: Ruesch, A., and Gibbs H. K. (2008). Global Vegetation biomass carbon stocks - 1 km resolution. New IPCC Tier-1 Global Biomass Carbon Map For the Year 2000. Available online from the Carbon Dioxide Information Analysis Center[http://cdiac.ornl.gov],
*  Oak Ridge National Laboratory, Oak Ridge, Tennessee. http://cdiac.ornl.gov/epubs/ndp/global_carbon/carbon_documentation.html
*
$gdxin 'data\GHG.gdx'
$load
$load GHG_factor
$GDXIN

* --- Fuel data

* Load data on transport fuel use per municipality
$gdxin 'data\fuel_transport_2014_2018.gdx'
$load
parameter fuel_demand(h,*,*,*,*,*);
$load fuel_demand
$GDXIN

$gdxin 'data\fuel_delivery_2018.gdx'
$load
parameter fuel_delivery(h,*);
$load fuel_delivery
$GDXIN

* --- Demand specification
parameter elas_fuel(*,blend_fuel) 'Demand elasticities for fossil fuels (assumed same with blended biofuels in them)';
$gdxin 'data\fuel_elasticities.gdx'
$load
$load elas_fuel
$GDXIN



* ---------------------------------
* Fill parameters with data
* ---------------------------------

* --- Distance ------------

* Adjust distances with tortuoisty factors
distance(i,g)=
  distance(i,g)
* divide with 1.4 the turtosity factor still in the data in distance_scb.csv
  /1.4
* Multiply with county specific tortuosity factor (average origin/destination)
  * [(sum(lan$lan_to_kn(lan,i),tortuosity_factor(lan)) + sum(lan$lan_to_kn(lan,g),tortuosity_factor(lan)))
      /2];

distance_demand(i,h)=
  distance_demand(i,h)
* divide with 1.4 the turtosity factor still in the data
  /1.4
  * [(sum(lan$lan_to_kn(lan,i),tortuosity_factor(lan)) + sum(lan$lan_to_kn(lan,h),tortuosity_factor(lan)))
      /2];

*
* Make county dependent tortuosity factor : take average of origin county and destination county
* In region distance added for regions with transport only within 
* Distances in a municipality given by the half of the imagined radius of a circle of the same size as the municiplaity total area(water and land).
* SCB https://www.statistikdatabasen.scb.se/pxweb/sv/ssd/START__MI__MI0802/Areal2012N/
distance(i,g) $ (ord(i)=ord(g))= halfRadius(i,"total landareal") * sum(lan$lan_to_kn(lan,i),tortuosity_factor(lan)) ;


* --- Feedstock availablility, t tonne in region g ------

area_factor(f,g)= 0.25;
area_factor('grass3',g)= 0.1;


set grassareas 'elemets in data categorizes as ley land'/"slatter- och betesvall som utnyttjas",
"slattervall och gronfoder","ej utnyttjad slatter- och betesvall",
"energiskog","trada","ospecificerad akermark","annan obrukad akermark" /;

feedstock_area(g,"grass1")=
  sum(grassareas, areaHA2(g,grassareas,"average15_19"))  * area_factor("grass1",g) ;

feedstock_area(g,"grass2")=
  sum(grassareas, areaHA2(g,grassareas,"average15_19"))  * area_factor("grass2",g);

* 10 percent of other arable land (total agri area minus grassareas)
feedstock_area(g,"grass3")=  max[0,(areaHA2(g,"total akerareal","average15_19")- sum(grassareas, areaHA2(g,grassareas,"average15_19")))] * area_factor('grass3',g);


* Yeild of reed canary grass in Ume� (knKod 2480, lan 24), approximated to 5.85, (Produktionsf�ruts�ttningar f�r biobr�nslen inom svenskt jordbruk
*B�rjesson, P�l)

scalar canary_yield 'T tonne per hectare' /0.005850/;


* Distribute yields based on yield of ley
yield(g,"grass1")=
{
  canary_yield
  * sum(lan$lan_to_kn(lan,g) ,yieldHA(lan,"Hektarskord, kg per hektar","slattervall, totalt","average_14_18"))
  /yieldHA("24","Hektarskord, kg per hektar","slattervall, totalt","average_14_18") }
;

*If yield missing
yield(g,"grass1")$ (yield(g,"grass1")=0) =
{
  canary_yield
  * sum(prodOmr $ prodOmr_to_kn(g,prodOmr) ,yieldHA_prodomr(prodOmr,"Slattervall, Total vallskord","average_14_18"))
  /yieldHA("24","Hektarskord, kg per hektar","slattervall, totalt","average_14_18") }
;

* Assume same yield on all cost categories
yield(g,"grass2")=yield(g,"grass1");
yield(g,"grass3")=yield(g,"grass1");


* Available feedstock per region based on yield
feedstock(f,g)=feedstock_area(g,f) * yield(g,f);

* Abandonned agricultural land (ALA)
* --------------------------
* Old cropl land ALA
parameter ALA_land(*) 'ALA area old crop land'; 
* ALA is on municiaplity. 1.6% missing. add tihis manualy
ALA_land(g) = ALA_crop(g) * 1.016;

* To convert from county level
* sum total agricultural area for county
*areaHA2(lan,"total akerareal","average15_19") = sum(g $ lan_to_kn(lan,g), areaHA2(g,"total akerareal","average15_19"));

* calculate ALA per municipality based on municipality's share of agricultual land in county (lan)
*ab_land(g)  = sum(lan$lan_to_kn(lan,g), ab_land(lan)) *
*               [areaHA2(g,"total akerareal","average15_19")/ sum(lan$ lan_to_kn(lan,g), areaHA2(lan,"total akerareal","average15_19") )];


*  Add old pasture ALA
* Total old pasture from Olofsson and Börjesson 2016, p  32'
* distribute as ab_land
* add parameter
parameter ALA_land_pasture(*)'ALA area on pasture';


ALA_land_pasture("total") = 80000;

* calculate ALA per municipality based on municipality's share of crop ALA
ALA_land_pasture(g)  = ALA_land_pasture("total") 
        * ALA_crop(g) / sum(gg, ALA_crop(gg));
                



* Yield in thousand tonne per hectare
yield_ab(lan) = yield_ab(lan)* tonne_to_Ttonne;
yield(g,ab) = sum(lan $ lan_to_kn(lan,g) , yield_ab(lan));

* For old pasture, assume same yield as ALA
yield(g,"abP1") = yield(g,"ab1");
yield(g,"abP2") = yield(g,"ab2");
yield(g,"abP3") = yield(g,"ab3");

* Calculate feedstock levels, equal shares of total (ala_land) per cost segment ab
* FOr old cropland
feedstock(ab,g) =  1/sum(aabb,1)* ALA_land(g)* yield(g,ab);


* FOr old pasture
feedstock(abP,g) =  1/sum(aabbP,1)* ALA_land_pasture(g)* yield(g,abP);


* --- test if negative feedstock
if (smin((g,f),feedstock(f,g))<0, abort 'Negative feedstock level in some region');




* --- Costs ----------------

* Define feedstock elasticities
* CAPRI database (CAPRI Modelling System, 2020), (see table PELAGRP)
elas_fodder(grass,lan)=data_elas_fodder(lan);

* Turn feedstock cost into million euro per t tonne, per region g
* Therefore, the production cost p_(f,g) for reed canary grass is assumed to equal the opportunity cost for silage production,
* on agricultural production region level, from the Agriwise business-calculation database (Agriwise, 2019). 
cost_feedstock_prodOmr(prodOmr,f) = cost_feedstock_prodOmr(prodOmr,f) * Eur_to_M_Eur / tonne_to_Ttonne * Euro_SEK2019;

* per region g
cost_feedstock(f,g) = sum(prodOmr $ prodOmr_to_kn(g,prodOmr), cost_feedstock_prodOmr(prodOmr,f));


* Calculate costs for other cost categories based on elasticites
cost_feedstock("grass2",g) = sum(prodOmr $ prodOmr_to_kn(g,prodOmr), cost_feedstock_prodOmr(prodOmr,"grass1"))*
                                         (1+area_factor('grass1',g)/ (sum(lan$lan_to_kn(lan,g),elas_fodder("grass1",lan))));
cost_feedstock("grass3",g) =  cost_feedstock("grass2",g)*
                                         (1+area_factor('grass2',g)/ (sum(lan$lan_to_kn(lan,g),elas_fodder("grass2",lan))));


* --- Cost of using abandonned land
* we have conversion costs (equal everywhere) and production costs  (regionally differning)


* Convert to million euro per ha
conversion_cost_ha(ab) = conversion_cost_ha(ab) *Eur_to_M_Eur * Euro_SEK2019;

* Conversion cost,  million euro per t tonne
conversion_cost(g,ab) $ yield(g,ab) = conversion_cost_ha(ab) /yield(g,ab);

* For old pasture, assume same
conversion_cost(g,"abP1") $ yield(g,"abP1") =conversion_cost(g,"ab1");
conversion_cost(g,"abP2") $ yield(g,"abP2") =conversion_cost(g,"ab2");
conversion_cost(g,"abP3") $ yield(g,"abP3") =conversion_cost(g,"ab3");


* Field production costs per tonne

* To million euro per thousand tonne 
data_prod_cost(lan)= data_prod_cost(lan) * Eur_to_M_Eur / m3_to_Tm3;

* to municipality level
prod_costAb(g,ab)= sum(lan $ lan_to_kn(lan,g), data_prod_cost(lan)) ;

* For pasture, assume same
prod_costAb(g,"abP1") = prod_costAb(g,"ab1");
prod_costAb(g,"abP2") = prod_costAb(g,"ab2");
prod_costAb(g,"abP3") = prod_costAb(g,"ab3");

* Total costs, million euro per t tonne
cost_feedstock(ab,g)= prod_costAb(g,ab) + conversion_cost(g,ab);
cost_feedstock(abP,g)= prod_costAb(g,abP) + conversion_cost(g,abP);



* --- Production costs, per t tonne of feedstock
* Lin et al. (2013), Lin, T., Rodríguez, L. F., Shastri, Y. N., Hansen, A.C. and Ting, KC. (2013). GIS‐enabled biomass‐ethanol
* supply chain optimization: model development and Miscanthus application. Biofuels, Bioproducts and Biorefining 7:314-333.
parameter production_costUSD(f,b_fuel, tech) 'production cost in USD 2007 per t tonne feedstock';

production_costUSD(f,b_fuel, tech) = 0.058;
production_cost(f,b_fuel, "low")    = production_costUSD(f,b_fuel, "low") * inflUSDExrate2007 * Euro_SEK2019;
production_cost(f,b_fuel, "high") = production_costUSD(f,b_fuel, "high") * inflUSDExrate2007 * Euro_SEK2019;




* --- Variable investment cost, million Euro  per t tonne biomass
* Lin et al. (2013), Lin, T., Rodríguez, L. F., Shastri, Y. N., Hansen, A.C. and Ting, KC. (2013). GIS‐enabled biomass‐ethanol
* supply chain optimization: model development and Miscanthus application. Biofuels, Bioproducts and Biorefining 7:314-333.
parameter investment_cost_varUSD(b_fuel,tech) 'variable investment cost in USD 2007 per t tonne feedstock';
investment_cost_varUSD(b_fuel,"low") = 0.0743 ;
investment_cost_varUSD(b_fuel,"high") = 0.0519;
investment_cost_var(b_fuel,"low")    = investment_cost_varUSD(b_fuel,"low") * inflUSDExrate2007 * Euro_SEK2019;
investment_cost_var(b_fuel,"high") = investment_cost_varUSD(b_fuel,"high") * inflUSDExrate2007 * Euro_SEK2019;

* --- Fixed investmetn cost, million Euro per facility
* Lin et al. (2013), Lin, T., Rodríguez, L. F., Shastri, Y. N., Hansen, A.C. and Ting, KC. (2013). GIS‐enabled biomass‐ethanol
* supply chain optimization: model development and Miscanthus application. Biofuels, Bioproducts and Biorefining 7:314-333.
parameter investment_costUSD(b_fuel,tech) 'fixed investment cost in USD 2007 million per facility';
investment_costUSD(b_fuel,"low") = 8 ;
investment_costUSD(b_fuel,"high") = 20.5;
investment_cost(b_fuel,"low")  = investment_costUSD(b_fuel,"low") * inflUSDExrate2007* Euro_SEK2019;
investment_cost(b_fuel,"high") = investment_costUSD(b_fuel,"high") * inflUSDExrate2007 *Euro_SEK2019;




* Transport costs
* De Jong, S., Hoefnagels, R., Wetterlund, E., Pettersson, K., Faaij, A. and Junginger, M. (2017). Cost optimization of biofuel
*production–The impact of scale, integons. Applied Energy 195:1055-1070.
parameter transport_costEUR(f,i) 'M Eur per t tonne and km'; 
parameter transport_cost_fixedEUR 'M EURO per t tonne'; 
parameter fuel_transportcostEUR(b_fuel,i) 'M Eur per t m3 and km';
parameter fuel_transport_cost_fixedEUR M EURO per t m3;
transport_costEUR(f,i) =   0.000162;
transport_cost_fixedEUR =  0.00511;
fuel_transportcostEUR(b_fuel,i)=    0.000162;
fuel_transport_cost_fixedEUR =  0.00131;

transport_cost(f,i) =   transport_costEUR(f,i)* inflEURExrate2015 *Euro_SEK2019;
transport_cost_fixed =  transport_cost_fixedEUR * inflEURExrate2015 * Euro_SEK2019;
fuel_transportcost(b_fuel,i)=    fuel_transportcostEUR(b_fuel,i) * inflEURExrate2015 * Euro_SEK2019;
fuel_transport_cost_fixed =  fuel_transport_cost_fixedEUR * inflEURExrate2015 * Euro_SEK2019;


* --- Production specification
* Converion of feedstock to biofuel, T m3  biofeul per t tonne feedstock
* Lin et al. (2013), Lin, T., Rodríguez, L. F., Shastri, Y. N., Hansen, A.C. and Ting, KC. (2013). GIS‐enabled biomass‐ethanol
* supply chain optimization: model development and Miscanthus application. Biofuels, Bioproducts and Biorefining 7:314-333.
conversion_factor(f,b_fuel,i)=0.3;

* Capacity constraints, multiplied with conversion_factor to get 1000 m^3 biofuel
* Lin et al. (2013), Lin, T., Rodríguez, L. F., Shastri, Y. N., Hansen, A.C. and Ting, KC. (2013). GIS‐enabled biomass‐ethanol
* supply chain optimization: model development and Miscanthus application. Biofuels, Bioproducts and Biorefining 7:314-333.
capacity_constraint_lo("ethanol","medium",i) = 0;
capacity_constraint_up("ethanol","medium",i) = 0;
capacity_constraint_lo("ethanol","low",i) = 50 * conversion_factor("grass1","ethanol",i);
capacity_constraint_up("ethanol","low",i) = 600 * conversion_factor("grass1","ethanol",i);
capacity_constraint_lo("ethanol","high",i) = 600 * conversion_factor("grass1","ethanol",i);
capacity_constraint_up("ethanol","high",i) = 1200 * conversion_factor("grass1","ethanol",i);




* --- Suitable regions
* can be set to zero if a sample of suitable regions are made
facilitySuitability(b_fuel, tech,i)=1;

* --- Policy target    (1000 m^3 fuel)

* Policy targets, defaults

* Emission target in thousand tonne CO2.
* positive to allow for increases
p_emisTarget= 1500;

* production target
p_prodTarget(b_fuel) = 0;

* Max production target to base production targets on
max_target("ethanol") = 1700;



* --- GHG emissions 

* to municipality level
ghg_factor(f, "feedstock",g) = sum(lan$lan_to_kn(lan,g),ghg_factor(f,"feedstock",lan));
ghg_factor(ab, "feedstock",g) = ghg_factor("grass1", "feedstock",g);
ghg_factor(abP, "feedstock",g) = ghg_factor("grass1", "feedstock",g);

ghg_factor("perhectare", GHGcat,g) = ghg_factor("perhectare", GHGcat,"all");
ghg_factor("perhectare", GHGcat,g) = sum(lan$lan_to_kn(lan,g),  sum(nuts2 $ nuts2_to_lan(nuts2,lan), ghg_factor("perhectare",GHGcat,nuts2)));

* LUC, living biomass and SOC, from per hectare to per tonne
* for old cropland
ghg_factor(ab,GHGcat,g) $ yield(g,ab) = ghg_factor("perhectare", GHGcat,g) / yield(g,ab) * tonne_to_Ttonne;
* For old pasture
ghg_factor(abP,GHGcat,g) $ (yield(g,abP) and ghg_factor("perhectare",GHGcat,g)) = ghg_factor("perhectare", GHGcat,g) / yield(g,abP) * tonne_to_Ttonne;

* assume LUC is from cropland, half like from mnatural vegataion (i.e it wuld have been like grassland anyway, or natural vegeation)
ghg_factor(ab,"LUC",g)= ghg_factor(ab,"LUCabovecrp",g) + ghg_factor(ab,"SOCcrp",g);

* for pasture, assume LUC is from natural land to grassland
ghg_factor(abP,"LUC",g)= ghg_factor(abP,"LUCabovenat",g) + ghg_factor(abP,"SOCgrassland",g);


* To t tonne CO2 per t tonne or t m3
ghg_factor(f,GHGcat,g) = ghg_factor(f,GHGcat,g) / tonne_to_Ttonne * kg_to_Ttonne;
ghg_factor("all",GHGcat,"all") = ghg_factor("all",GHGcat,"all")/ tonne_to_Ttonne * kg_to_Ttonne;



* ------------ Demand modelling-----------


* Energy equivalents for fuels
*  Using table 14 in https://www.energimyndigheten.se/globalassets/statistik/transport/transportsektorns-energianvandning-2016.pdf,
* Equlas      TJ per thousand m3
energy_ekv("gas") =32.76;
energy_ekv("die") =35.28;
energy_ekv("ethanol") =21.24;


parameter MWh_to_t_M3(b_fuel) 'M3  per MWh';
MWh_to_t_M3("ethanol") = 0.168;

scalar MWh_to_TJ  /0.0036/;

*fuel use in MWh: fuelUse_liquid_MWh(h)
* from data/share_fossils.xlsx
parameter share_fossilType(blend_fuel) 'SWE national share of road trasnport to gasoline resp diesel (MWh)(of total of gasoline and diesel, including biocomponents)';
share_fossilType("gasE")= 0.33;
share_fossilType("dieB")= 0.67;




$ontext
parameter demand(b_fuel,h)'demand per municipality';
demand(b_fuel,h)
=    (fuel_demand(h,"941","slutanv. transporter","905","flytande (icke fornybara)","Average_14_18")
        + fuel_demand(h,"941","slutanv. transporter","920","flytande (fornybara)","Average_14_18"))
 ;
parameter total_demand(b_fuel,*);
total_demand(b_fuel, "total") = sum(h,demand(b_fuel,h));
*total_demand(b_fuel, "value") = sum(h,demand_share(b_fuel,h)*p_target(b_fuel));
display  total_demand, b_fuel_demand;
$offtext
*$ontext
* Based on gasoline
* ------------------------------
* use is in MWh. Using table 14 in https://www.energimyndigheten.se/globalassets/statistik/transport/transportsektorns-energianvandning-2016.pdf,
* gives litres of ethanol needed for each MWh of energy.
* 21.24 GJ per m3. 0.28 MWh perGJ. ->  x MWh / ((0.28 MWh/GJ) * (21.24 GJ/m3))= 0.168. 1 MwH=0.168 m3
* further, about 27000 of 91000 drivmedel (Drivmedel 2018) was gasoline. IN sweden as a total. therefore asusume this share was gasoline in all municipalities




fuelUse_0_Tm3(h,"gas") = fuel_delivery(h,"bensin") * m3_to_Tm3;
fuelUse_0_Tm3(h,"die") = fuel_delivery(h,"diesel/EO1") * m3_to_Tm3;

* calcualte inital fuel use levels in TJ
f_fuel_0("gasE",h)= fuelUse_0_Tm3(h,"gas") * energy_ekv("gas");
f_fuel_0("dieB",h)= fuelUse_0_Tm3(h,"die") * energy_ekv("die");

* set blend-in  cap for biofuel into gasoline
blend_cap(blend_fuel,h) =0.38;

* For exogenous demand
* --- Specify coefficients for bounds on demand
parameter minDemand_share(b_fuel);
parameter maxDemand_share(b_fuel) 'Share of max_target as max demand. Assumed in blend in 2030 30%, Energimyndigheten, adding some and assuring more than max target';

minDemand_share("ethanol") = 0 ;
maxDemand_share("ethanol") $ sum(h, f_fuel_0("gasE",h))
    = 1.1 * max_target("ethanol") * energy_ekv("ethanol")
            / sum(h, f_fuel_0("gasE",h));
        ;

* -- Share of demand per municipality
parameter demand_share(b_fuel,h)'Share of demand per municipality';
demand_share(b_fuel,h) $ (f_fuel_0("gasE",h) + f_fuel_0("dieB",h))
=    (f_fuel_0("gasE",h) + f_fuel_0("dieB",h))
    /sum(hh, f_fuel_0("gasE",hh) + f_fuel_0("dieB",hh))
;

display  demand_share,  fuel_demand, maxDemand_share ;
* Max and min demand of fuel at each region
*max_demand(b_fuel,h)=0;
*min_demand(b_fuel,h)= 0;

* Demand allowed +/- 20% from b_fuel use shares, of the target
* are set in the scenario_setting.gms file (for each scenario)

*max_demand(b_fuel,h)= p_target(b_fuel)* demand_share(b_fuel,h) * 1.2;

*min_demand(b_fuel,h)=p_target(b_fuel)* demand_share(b_fuel,h) * 0.8;
*$offtext

*parameter blend_cap(blend_fuel,h);

* based on Board of energy's proposal of 28% mandatory blend in 2030


* --- Demand specification

elas_fuel(h,blend_fuel) =  sum(lan $ lan_to_kn(lan,h), elas_fuel(lan,blend_fuel));


* Fossil fuel prices, from Energy in Sweden Facts and Figures 2021, 2019 level , million sek/ t m3,

p_0("gasE") = 15.770;
p_0("dieB") = 16.100;

* in M EUR per TJ
p_0("gasE") = p_0("gasE") /energy_ekv("gas") *Euro_SEK2019 ;
p_0("dieB") = p_0("dieB") /energy_ekv("die") *Euro_SEK2019;


* Consumer loss

* shares per fuel segment
parameter fuel_segment(end_fuel_Large) 'end point of total fuel for each segment';
fuel_segment("gasE_m1") = 0.2;
fuel_segment("gasE_1")  = -0.2;
fuel_segment("gasE_1b") = -0.1;
fuel_segment("gasE_2")  = -0.4;
fuel_segment("gasE_2b") = -0.3;
fuel_segment("gasE_3")  = -0.6;
fuel_segment("gasE_3b") = -0.5;
fuel_segment("gasE_4")  = -0.8;
fuel_segment("gasE_4b") = -0.7;
fuel_segment("gasE_5")  = -1;
fuel_segment("gasE_5b") = -0.9;


fuel_segment("dieB_m1")  = 0.2; 
fuel_segment("dieB_1")   = -0.2;
fuel_segment("dieB_1b")   = -0.1;
fuel_segment("dieB_2")   = -0.4;
fuel_segment("dieB_2b")  = -0.3;
fuel_segment("dieB_3")   = -0.6;  
fuel_segment("dieB_3b")  = -0.5;
fuel_segment("dieB_4")   = -0.8;  
fuel_segment("dieB_4b")  = -0.7;
fuel_segment("dieB_5")   = -1;  
fuel_segment("dieB_5b")  = -0.9;

* Marginal demand decreasing with quantity
alias (end_fuel, end_fuel2);
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

* --- Restriction on quantities per each cost level


*max_redY(end_fuel, h) = sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), f_fuel_0(blend_fuel,h)) * smax(end_fuel2, fuel_segment(end_fuel2));



* maybe have more spans close to start point, then high cost?
max_redY(end_fuel, h) = - sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), f_fuel_0(blend_fuel,h)) * smin(end_fuel2, abs(fuel_segment(end_fuel2)));
max_redY("gasE_m1", h) = 0;
max_redY("dieB_m1", h) = 0;

min_redY(end_fuel, h) = 0;

* Assume only partial increase possible
min_redY("gasE_m1", h) = f_fuel_0("gasE",h) * fuel_segment("gasE_m1");
min_redY("dieB_m1", h) = f_fuel_0("dieB",h) * fuel_segment("dieB_m1");



*-------------------------
* Easing modelling
* --------------------
* deafults
p_facility_max(tech)= 20;
distance_max= +inf;
p_max_facilityReg=1;
scalar p_distConstraint /0/;


