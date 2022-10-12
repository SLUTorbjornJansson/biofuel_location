* ---------------------------------
* Biofuel facility location model
*
* declaration of parameter, sets, variables, equations
* ---------------------------------

* create sets to use for model
set reg 'sub regions' /1*7/;
set reg2 'larger regions' /21*25/ ;
display reg2;
set reg_map(reg,reg2);

* Regions per use
set i(reg) 'facility locations' /set.reg/;
set g(reg) 'feedstock locations'/set.reg/;
set h(reg) 'demand locations' /set.reg/;
set tech 'technology, type and size' /low, medium,high/;
*set capacity 'capacity levels' /low, medium, high/;
set fuel 'biofuels' /ethanol, methanol/;
set f 'feedstock types' /wheat, grass1, grass2, grass3,ab1, ab2, ab3/;
set ab(f) 'subset of abandonned land' /ab1, ab2, ab3/;

set f_fuel 'fossil fuels' /gasoline,ethanolE,gasE,diesel,dieB/;

set fuel_to_fossil(fuel,f_fuel) 'mapping from fuel to fossil fuel'/
         ethanol.ethanolE
         /;
set GHGcat /feedstock, production, investment, transport, distribution, LUC, all, gasoline, allgasoline, carbonstock/;

* Alias to be able to allow summations
alias (reg,regreg);
alias (i,ii);
alias (g,gg);
alias (h,hh);
alias(f,ff);
alias(ab,aabb);

* --- Declare parameters
* distances
parameter distance(i,g)'Distance between feedstock region g and facility region i';
parameter distance_demand(i,h)'Distance betseen a faciality location i and demand point h';

*costs
parameter transport_cost(f,i)'variable transport cost SEK per km of feedstock f to region i';
parameter transport_cost_fixed 'fixed transport cost of feedstock';
parameter cost_feedstock(f,g)   'Price of biomass feedstock f in region g';
parameter elas_fodder(f,g) "own price elasticities for Fodder, used for Reed canary grass, as they compete for land and similar: SE11, SE21,SE22,SE23,SE31,SE32";
parameter production_cost(f,fuel, tech)'variable production cost per tonne feedstock of feedstock f to fuel, at a capacity level,(per year) ';
parameter production_cost_2(fuel, tech);
parameter investment_cost_var(fuel, tech)'Variable investment cost per year, per tonne feedstock, for a fuel and capacity level';
parameter investment_cost(fuel, tech) 'Fixed investment cost for a fuel and capacity level, annulized ';
parameter fuel_transportcost(fuel,i) 'variable transport cost SEK per km of fuel from region i';
parameter fuel_transport_cost_fixed 'fixed transport cost of fuel';

*technology/restrictins
parameter conversion_factor(f,fuel,i) 'm^3 of fuel per tonne feedstock f, at facility at i ';
parameter feedstock(f,g) 'maximum feedstock supply of f in region g';
parameter max_demand(fuel,h) 'maximum fuel demand in demand region h';
parameter min_demand(fuel,h) 'minimum fuel demand in demand region h';
parameter capacity_constraint_up(fuel, tech,i) 'maximum capacity of production of a fuel at facility i, in m^3';
parameter capacity_constraint_lo(fuel, tech,i) 'minimium capacity of production of a fuel at facility i, in m^3';
parameter facilitySuitability(fuel, tech,i) 'facility sutability indicator, 1 or 0, ';
parameter p_target(fuel) 'Target value of production of a fuel in the whole region, m^3';
parameter p_emisTarget 'Target value for emission reduction in the whole region, kg CO2eq';
parameter max_target(fuel) 'max target level of all scenarios';


*paper 2 parmaeters

parameter fuel_ekv(fuel,f_fuel);
parameter blend_cap(f_fuel,h) 'max blending of biofuel into fossil fuel';
parameter demand_intercept(f_fuel,h) 'intercept of inverse regional demand function';
parameter demand_slope(f_fuel,h) 'slope of inverse regional demand function';
parameter p_0(f_fuel) 'initial fuel price';


parameter conversion_cost_ha(ab) 'per hectare conversion cost' ;
scalar interceptAb /1/;
scalar slopeAb /0.1/;

parameter conversion_cost(g,ab) 'per tonne dm conversion cost' ;
parameter yield(f,g);
parameter prod_costAb(g,ab);
parameter carbon_change(g,f) 'change in carbon stock from abanndonned to energy crop';
*parameter p_ghg(GHGcat,*)'ghg in a facility region i, per category';
parameter GHG_factor(*,GHGcat,*)'emission factors, kg per m3(for fuel) or tonne  (for feedstock)';



variable v_consumerCost(h);
alias (f_fuel,f_fuel2);
alias (f_fuel, f_fuel3);


* ---------------------------------
*  Declaration of variables
* ---------------------------------

* Declare variables
positive variable v_feedstock(f,fuel,tech,i,g) 'feedstock delivered to facility i from supplier at g for production of a fuel';
positive variable v_production_cost(fuel, tech,i) 'Total variable production costs at facility at i';
positive variable v_feedstock_cost(fuel,tech,i) 'Total purchase cost for facility at i';
positive variable v_transport_cost(fuel,tech,i) 'Total transport cost for facility at i ';
positive variable v_tot_feedstock(f,fuel,tech,i)'Total feedstock used at i';
positive variable v_fueltransport_cost(fuel,tech,i)'Total transport cost of fuel from facility at i ';
positive variable v_y_sales(fuel,tech,i,h) 'Total sales of y to demand point h';
positive variable v_y(fuel,tech,i)'Total production of fuel at i';
positive variable v_tot_demand(fuel, h) 'total demand at one location h';



variable v_EFeedstock(f,fuel,tech,i,g);
variable v_EProduction(fuel,tech,i);
variable v_EInvestment(fuel,tech,i);
variable v_ETransport(f,fuel,tech,i,g);
variable v_EDistribution(fuel,tech,i,h);
variable v_ELUC(f,fuel,tech,i,g);
variable v_EFossilSubs(fuel,tech,i,h);
variable v_Emissions(i);
variable v_totEmissions;

variable v_tot_cost 'total cost';

Binary Variable J(fuel,tech,i) 'Investment decision 1 or 0';

* paper 2 variables
positive variable v_yEnergy(f_fuel,h) 'fuels expressed in energy equivalents';
positive variable v_blend_rate(f_fuel,h) 'blending rate of biofuel into fossil fuel';
*variable v_price(f_fuel);
variable v_consumerCost(h);

*$ontext
* ---------------------------------
* Declaration of equations
* ---------------------------------
equation eq_production_cost(fuel,tech,i) "cost function for production at facility";
equation eq_feedstock_cost(fuel,tech,i);
equation eq_transport_cost(fuel,tech,i);
equation eq_tot_feedstock(f,fuel,tech,i) ;

equation eq_fueltransport_cost(fuel,tech,i);
equation eq_production(fuel,tech,i) "production function at facility";

*--- Restrictions
equation e_J(fuel,tech) 'Number of facilities restriction';
equation eq_target(fuel) "production target";
equation eq_facilityRestrictionTech(fuel,i) 'Restricting number of differnt facility technology at same place';
equation eq_facilityRestrictionFeed(fuel, tech, i) 'Restricting number of differnt feedstock per facility';

equation eq_feedstock(f,g) "max feedstock uptake from supply region g";
equation eq_capacity_up(fuel,tech,i) 'tech capacity constraint upper';
equation eq_capacity_lo(fuel,tech,i) 'tech capacity constraint lower';

equation eq_demandEq(fuel,tech,i)"sales of y equals production of y";
equation eq_demandMax(fuel,h) "restrict max demand at point h";
equation eq_demandMin(fuel,h) "restrict min demand at point h";
equation eq_tot_demand(fuel,h) 'Total demand at one location h';

equation eq_facility_suitability(fuel,tech,i) 'restrict only suitable places for facility location';

equation eq_tot_cost 'Total cost of the biofuel system';


*Emissions
equation eq_EFeedstock(f,fuel,tech,i,g);
equation eq_EProduction(fuel,tech,i);
equation eq_EInvestment(fuel,tech,i);
equation eq_ETransport(f,fuel,tech,i,g);
equation eq_EDistribution(fuel,tech,i,h);
equation eq_ELUC(f,fuel,tech,i,g);
equation eq_EFossilSubs(fuel,tech,i,h);
equation eq_Emissions(i);
equation eq_TotEmissions;
equation e_emisTarget;

* paper 2 equations
equation eq_energyEkv(f_fuel,h) 'tranforming fuels to energy content';
equation eq_blending(f_fuel,h) 'blending fuels of differnt types';
*equation eq_blend_rate(f_fuel,h) 'blending rate equation';
*equation eq_blendCap(f_fuel,h) 'maximum blending rate';
*equation eq_demandCost(h);

