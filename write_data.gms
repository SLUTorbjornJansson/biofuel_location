*---------------------------------
* Write data to GDX
*---------------------------------

* Write distance data to
$if not exist data\distance_scb.gdx $call 'csv2gdx data\distance_scb.csv output=data\distance_scb.gdx id=d index=2,3 value=6 useHeader=yes';


* Mapping for differnt types of regions
*execute 'gdxxrw data\kommunlankod_1219_modified.xlsx output=data\kommunalkod_1219_modified.gdx index=index!A2 '
$if not exist data\kommunlankod_1219_SCB.gdx $call 'gdxxrw data\kommunlankod_1219_SCB.xlsx output=data\kommunlankod_1219_SCB.gdx index=index!A2 '

$if not exist data\municip_scb.gdx $call 'gdxxrw data\municip_scb.xlsx output=data\municip_scb.gdx index=index!A2'
* --- Read EXCEL files to GDX format
* Arable land used for "sl�ttervall"
*execute 'gdxxrw data\arable_land_area_15_19.xlsx o=data\arable_land_area_15_19.gdx par=areaHA rng=A3 rDim=2 cDim=1 '
$if not exist data\arable_land_area_15_19.gdx $call 'gdxxrw data\arable_land_area_15_19.xlsx output=data\arable_land_area_15_19.gdx par=areaHA rng=A3 rDim=2 cDim=1  '

* yeild of "sl�ttervall" (total) per l�n (5 year average)
*execute 'gdxxrw data\yield_vall.xlsx o=data\yield_vall.gdx par=yieldHA rng=A3 rDim=3 cDim=1 '
$if not exist data\yield_vall.gdx $call 'gdxxrw data\yield_vall.xlsx output=data\yield_vall.gdx par=yieldHA rng=A3 rDim=3 cDim=1  '

* yeild of "sl�ttervall" (total) per production area (5 year average)
*execute 'gdxxrw data\yield_vall_prod_omr.xlsx o=data\yield_vall_prod_omr.gdx par=yieldHA_prodomr rng=B3 rDim=2 cDim=1 '
$if not exist data\yield_vall_prod_omr.gdx $call 'gdxxrw data\yield_vall_prod_omr.xlsx output=data\yield_vall_prod_omr.gdx par=yieldHA_prodomr rng=B3 rDim=2 cDim=1  '

* Transport fuel use per municipality
*execute 'gdxxrw data\fuel_transport_2014_2018.xlsx o=data\fuel_transport_2014_2018.gdx par=fuel_demand rng=C3 rDim=5 cDim=1 '
$if not exist data\fuel_transport_2014_2018.gdx $call 'gdxxrw data\fuel_transport_2014_2018.xlsx output=data\fuel_transport_2014_2018.gdx par=fuel_demand rng=C3 rDim=5 cDim=1  '

* Share of passengers per airport
*execute 'gdxxrw data\air_passengers.xlsx o=data\air_passengers.gdx par=avePassenger ignoreColumns=B,C,D,E rng=A3 rDim=1'
$if not exist data\air_passengers.gdx $call 'gdxxrw data\air_passengers.xlsx output=data\air_passengers.gdx par=avePassenger ignoreColumns=B,C,D,E rng=A3 rDim=1  '

* Share of fuel per harbor
$if not exist data\shipping.gdx $call 'gdxxrw data\shipping.xlsx output=data\shipping.gdx par=shipping_fuel ignoreColumns=B,C,D,E,F,G,H,I,J,K,L rng=A2 rDim=1'

* Tortuosity factor based on measurment  on Google maps per county
*execute 'gdxxrw data\tortuosity.xlsx o=data\tortuosity.gdx par=tortuosity_factor ignoreColumns=B,C,D,E rng=A3 rDim=1'
$if not exist data\tortuosity.gdx $call 'gdxxrw data\tortuosity.xlsx output=data\tortuosity.gdx par=tortuosity_factor ignoreColumns=B,C,D,E rng=A3 rDim=1  '

* Half radius of municipality area to caclulate in region distance. includes water
*execute 'gdxxrw data\municipality_areas.xlsx o=data\municipality_areas_radius.gdx par=halfRadius ignoreColumns=B,D,E,F rng=A4 rDim=2 '
$if not exist data\municipality_areas_radius.gdx $call 'gdxxrw data\municipality_areas.xlsx output=data\municipality_areas_radius.gdx par=halfRadius ignoreColumns=B,D,E,F rng=A4 rDim=2  '


* Share of land that is of acertaon land class (excluding water)
$if not exist data\municipality_areas.gdx $call 'gdxxrw data\municipality_areas.xlsx o=data\municipality_areas_land.gdx par=landArea ignoreColumns=B rng=A4 rDim=2 '
*execute 'gdxxrw data\municipality_areas.xlsx o=data\municipality_areas_land.gdx par=landArea ignoreColumns=B rng=A4 rDim=2 '

* Share of land that is of a certain land class (excluding water)
*execute 'gdxxrw data\municipality_areas.xlsx o=data\municipality_areas_landShare.gdx par=landShare ignoreColumns=B,D rng=A4 rDim=2 '
$if not exist data\municipality_areas_landShare.gdx $call 'gdxxrw data\municipality_areas.xlsx output=data\municipality_areas_landShare.gdx par=landShare ignoreColumns=B,D rng=A4 rDim=2'


*Alternative cost for silage production
*execute 'gdxxrw data\alternative_costs.xlsx o=data\alternative_costs.gdx par=price_feedstock_prodOmr rng=A4 rDim=2 '
$if not exist data\alternative_costs.gdx $call 'gdxxrw data\alternative_costs.xlsx output=data\alternative_costs.gdx par=cost_feedstock_prodOmr rng=A4 rDim=2  '


* Elasticities for fodder,
*execute 'gdxxrw data\alternative_costs.xlsx o=data\alternative_costs.gdx par=price_feedstock_prodOmr rng=A4 rDim=2 '
$if not exist data\elasticities.gdx $call 'gdxxrw data\elasticities.xlsx output=data\elasticities.gdx par=data_elas_fodder rng=A4 rDim=1'

* GHG emission factors
$if not exist data\GHG.gdx $call 'gdxxrw data\GHG.xlsx output=data\GHG.gdx par=ghg_factor rng=A2 rDim=3'

* RCG cost, from GLOBIOM, here used for abanndonned land
$if not exist data\RCG_cost_GLOBIOM.gdx $call 'gdxxrw data\RCG_yield_cost_GLOBIOM.xlsx output=data\RCG_cost_GLOBIOM.gdx par=data_prod_cost rng=roadside_cost!B3 rDim=1'

* conversion cost for abanddoned land, three costs
$if not exist data\conversion_cost.gdx $call 'gdxxrw data\conversion_cost.xlsx output=data\conversion_cost.gdx par=conversion_cost_ha rng=conversion_cost!A2 rDim=1'

* RCG yield, from GLOBIOM, here used for abanndonned land
$if not exist data\RCG_yield_GLOBIOM.gdx $call 'gdxxrw data\RCG_yield_cost_GLOBIOM.xlsx output=data\RCG_yield_GLOBIOM.gdx par=yield_ab rng=yield!B3 rDim=1'

* Change in crop area (arable land,not grassland) 2010 to 2020. Used to approxoimate distribution of abanndonned land
$if not exist data\crop_area_2010_2020_SJV.gdx $call 'gdxxrw data\crop_area_2010_2020_SJV.xlsx output=data\crop_area_2010_2020_SJV.gdx par=data_agri_area rng=A4 ignoreColumns=B,C,D,E rDim=1'

* Fuel elasticiteis for fossil fuels, regional
$if not exist data\fuel_elasticities.gdx $call 'gdxxrw data\fuel_elasticities.xlsx output=data\fuel_elasticities.gdx par=elas_fuel rng=B4 rDim=2'


* Population, regional
$if not exist data\population_2019.gdx $call 'gdxxrw data\population_2019.xlsx output=data\population_2019.gdx par=population ignoreColumns=B rng=a11 rDim=1'

* Fuel deliveries, regional
$if not exist data\fuel_delivery_2018.gdx $call 'gdxxrw data\fuel_delivery_2018.xlsx output=data\fuel_delivery_2018.gdx par=fuel_delivery ignoreColumns=B,C,D,E,G rng=a4 rDim=2'

* Include regional data on ALA (to be updated if finer resolution retrived) Olofsson, J., & Börjesson, P. (2016). Nedlagd åkermark för biomassaproduktion–kartläggning och potentialuppskattning. (Report No. 2016: 01), tabell 7
* Hectares of ALA per county, old cropland
$if not exist data\ALA_areas.gdx $call 'gdxxrw data\ALA_areas.xlsx output=data\ALA_areas.gdx par=data_ALA_area rng=A3 ignoreColumns=B,C,D,E,G,H,I,J,K,L,M rDim=1'

* Hectares old pasture area, total hectares from O and B, distributed as old cropland
$if not exist data\ALA_areas_pasture.gdx $call 'gdxxrw data\ALA_areas.xlsx output=data\ALA_areas_pasture.gdx par=data_ALA_pasture_area rng=pasture!A3 ignoreColumns=B rDim=1'

