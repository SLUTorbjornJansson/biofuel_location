* ---------------------------------
* State equations and solve model
* ---------------------------------
scalar p_useDemand /0/;
scalar p_useEndoDemand /0/;
scalar p_hasStartValues /0/;

$ifi %demandMode%==demand p_useDemand = 1;
$ifi %demandMode%==noDemand p_useDemand = 0;
$ifi %demandType%==endoDemand p_useEndoDemand = 1;
$ifi %demandType%==exoDemand p_useEndoDemand = 0;

* ---------------------------------
* State equations
* ---------------------------------

eq_production(fuel, tech,i)..
    v_y(fuel,tech,i) =e=
        sum(f, conversion_factor(f,fuel,i) * v_tot_feedstock(f,fuel,tech,i)) ;

* Cost function (at site)
eq_production_cost(fuel,tech,i)..
v_production_cost(fuel,tech,i) =e=
  investment_cost(fuel,tech) * J(fuel,tech,i)
  + sum((g,f), v_feedstock(f,fuel,tech,i,g) * (production_cost(f,fuel,tech)+investment_cost_var(fuel,tech)))
;
* Purchase cost
eq_feedstock_cost(fuel,tech,i)..
v_feedstock_cost(fuel,tech,i) =e=
    sum((f,g), v_feedstock(f,fuel,tech,i,g) * cost_feedstock(f,g));


* Transport costs
eq_transport_cost(fuel,tech,i)..
v_transport_cost(fuel,tech,i) =e=
    sum((f,g), v_feedstock(f,fuel,tech,i,g) * (transport_cost_fixed + transport_cost(f,i) * distance(i,g)) );

eq_fueltransport_cost(fuel,tech,i)$ (p_useDemand or p_useEndoDemand)..
v_fueltransport_cost(fuel,tech,i) =e=
    sum(h, v_y_sales(fuel,tech,i,h) * (fuel_transport_cost_fixed + distance_demand(i,h) * fuel_transportcost(fuel,i)))
;

* Relational equations and constraints

*Total feedstock to one facility
eq_tot_feedstock(f,fuel,tech,i)..
    v_tot_feedstock(f,fuel,tech,i) =e= sum(g, v_feedstock(f,fuel,tech,i,g));

positive variable v_art1(f,fuel,tech,i,g);
* Restrict feedstock f from one region to be below a max
eq_feedstock(f,g)..
  sum((fuel,tech,i), v_feedstock(f,fuel,tech,i,g)
*-v_art1(f,fuel,tech,i,g)
) =l= feedstock(f,g);


positive variable v_art2(fuel, tech,i);
positive variable v_art3(fuel, tech,i);
* Restricting production to be within tech bounds
* Also assures production only if J is positive (production facility exists)
eq_capacity_up(fuel,tech,i)..
    v_y(fuel,tech,i)
*-v_art2(fuel,tech,i)
 =l= capacity_constraint_up(fuel,tech,i) ;

eq_capacity_lo(fuel,tech,i)..
    v_y(fuel,tech,i)
*+ v_art3(fuel, tech,i)
=g= capacity_constraint_lo(fuel,tech,i) ;

* demand restriction. All production must be sold to a point h

eq_demandEq(fuel,tech,i)$ (p_useDemand or p_useEndoDemand)..
v_y(fuel,tech,i) =e= sum(h, v_y_sales(fuel,tech,i,h));

eq_tot_demand(fuel,h)$ (p_useDemand or p_useEndoDemand)..
v_tot_demand(fuel, h) =e= sum((tech,i), v_y_sales(fuel,tech,i,h));
*eq_tot_demand(fuel,h)..
*v_tot_demand(fuel, h) =e= 1;
* Specify maximum demand per point, and also minimum

positive variable v_art4(fuel,h);
eq_demandMax(fuel,h)$ p_useDemand..
*  v_tot_demand(fuel, h) =l= max_demand(fuel,h);
sum((tech,i), v_y_sales(fuel,tech,i,h))
* -v_art4(fuel,h)
=l= max_demand(fuel,h);

eq_demandMin(fuel,h)$ p_useDemand..
        sum((tech,i), v_y_sales(fuel,tech,i,h)) + v_art4(fuel,h) =g= min_demand(fuel,h);


* If 1, it is suitable, otherwise zero and non-suitable
eq_facility_suitability(fuel,tech,i)..
    J(fuel,tech,i) =l= facilitySuitability(fuel,tech,i);

* --- paper 2 demand model ---
* ----------------------------



* --- Scenario restrictions'

positive variable v_art6(fuel,tech,i);
e_J(fuel,tech)..

* the number of facilites must be non-negative (can be restricted to a given number)
    sum(i, J(fuel,tech,i)
*-v_art6(fuel,tech,i)
)
*=g= 0
=l= facility_max(tech)
;

* Restrict to at most one tech level type of facility (fuel type) per region


eq_facilityRestrictionTech(fuel,i)..
    sum(tech, J(fuel,tech,i)) =l= max_facilityReg;

* Restrict to only one type of fuel per facility...
* not ready
eq_facilityRestrictionFeed(fuel, tech, i)..
1=e=1;
*    sum(f,abs(v_tot_feedstock(f,fuel,tech,i))) =l= max(f,v_tot_feedstock(f,fuel,tech,i));

* Biofuel production target

positive variable v_art7(fuel, tech, i);
eq_target(fuel)..
  sum((tech,i),v_y(fuel,tech,i)
*+v_art7(fuel, tech, i)
) =g= p_target(fuel);


* --- Emissions



eq_EFeedstock(f,fuel,tech,i,g)..
v_EFeedstock(f,fuel,tech,i,g)  =e=  v_feedstock(f,fuel,tech,i,g) * ghg_factor(f,"feedstock",g);
*v_EFeedstock(f,fuel,tech,i,g)  =e=  v_feedstock.l(f,fuel,tech,i,g) * sum(lan$lan_to_kn(lan,g),ghg_factor(f,"feedstock",lan));

eq_EProduction(fuel,tech,i)..
v_EProduction(fuel,tech,i) =e= v_y(fuel,tech,i) * ghg_factor("all","production","all");

eq_EInvestment(fuel,tech,i)..
v_EInvestment(fuel,tech,i) =e= J(fuel,tech,i) * ghg_factor("all","investment","all");

eq_ETransport(f,fuel,tech,i,g)..
v_ETransport(f,fuel,tech,i,g) =e= v_feedstock(f,fuel,tech,i,g)* distance(i,g)*ghg_factor("all", "transport","all");

eq_EDistribution(fuel,tech,i,h) $ (p_useDemand or p_useEndoDemand)..
v_EDistribution(fuel,tech,i,h) =e= v_y_sales(fuel,tech,i,h)* distance_demand(i,h)*ghg_factor("all", "distribution","all");

eq_ELUC(ab,fuel,tech,i,g)..
* will only take abanndonned land as ony these have carbon stock changes
v_ELUC(ab,fuel,tech, i,g) =e=  v_feedstock(ab,fuel,tech,i,g)  * ghg_factor(ab,"LUC",g);


eq_EFossilSubs(fuel,tech,i,h) $ p_useDemand..
*for assumed direct  substitution
v_EFossilSubs(fuel,tech,i,h) =e= v_y_sales(fuel,tech,i,h)* ghg_factor("all", "gasolineSubs","all");
* for assumed andogenous substitution, where gaoline is endogenous
*v_EFossilSubs(fuel,tech,i,h) =e= (v_yEnergy("gasoline",h) - p_yEnergy0("gasoline",h))* ghg_factor("all", "gasoline","all");


eq_emissions(i)..
v_emissions(i) =e= sum((f,fuel,tech,g),v_EFeedstock(f,fuel,tech,i,g)+v_ETransport(f,fuel,tech,i,g))
                  + sum((ab,fuel,tech,g), v_ELUC(ab,fuel,tech, i,g))
                  + sum((fuel,tech), v_EProduction(fuel,tech,i)+v_EInvestment(fuel,tech,i))
                  + sum((fuel,tech,h), v_EDistribution(fuel,tech,i,h))
                  + sum((fuel, tech,h), v_EFossilSubs(fuel,tech,i,h))$p_useDemand
                         ;

* ghg_factor in t tonne co2 per t m3 fuel
eq_fossilEmissions $ p_useEndoDemand..
v_fossil_emissions =e= sum(h, v_tot_demand("gas",h) * ghg_factor("all", "gasoline","all"))
                         + sum(h, v_tot_demand("die",h) * ghg_factor("all", "diesel","all"))
;

eq_totEmissions..
v_totEmissions =e= sum(i, v_emissions(i))
+ v_fossil_emissions $ p_useEndoDemand
;
*$offtext
*eq_totEmissions..
*v_totEmissions =e=
*sum((f,fuel,tech,g),v_EFeedstock(f,fuel,tech,i,g)+ v_ELUC(f,fuel,tech, i,g)+v_ETransport(f,fuel,tech,i,g))
*                  + sum((fuel,tech,i), v_EProduction(fuel,tech,i))
*+v_EInvestment(fuel,tech,i))
*                  + sum((fuel,tech,h), v_EDistribution(fuel,tech,i,h))
*                  + sum((fuel, tech,h), v_EFossilSubs(fuel,tech,i,h)))
;


e_emisTarget..
  v_totEmissions =l= p_EmisTarget;


scalar art_cost /40000/;

* The modelling of new demand

eq_energyEkv(blend_fuel,h) $ p_useEndoDemand..
v_yEnergy(blend_fuel,h) =e= sum(fuels $ fuel_blend(blend_fuel,fuels), energy_ekv(fuels)*v_tot_demand(fuels, h)) ;

eq_blendCap(blend_fuel,h )$ p_useEndoDemand..
sum(fuel $ fuel_blend(blend_fuel,fuel), energy_ekv(fuel) * v_tot_demand(fuel, h)) =l= blend_cap(blend_fuel,h) * (f_fuel_0(blend_fuel,h) +v_yEnergy(blend_fuel,h));

end_uses(blend_fuel,h) $ p_useEndoDemand..
v_yEnergy(blend_fuel,h) =e= sum(endF_fuel $ end_fuel_map(endF_fuel, blend_fuel), v_endY(endF_fuel,h));

eq_redY_max(endF_fuel, h) $ p_useEndoDemand..
v_endY(endF_fuel,h) =g= max_redY(endF_fuel, h);

eq_redY_min(endF_fuel, h) $ p_useEndoDemand..
v_endY(endF_fuel,h) =l= min_redY(endF_fuel, h);

eq_redYCost(h) $ p_useEndoDemand..
v_redY_cost(h) =e= - sum(fuel, sum(blend_fuel $ fuel_blend(blend_fuel,fuel), p_0(blend_fuel)) * energy_ekv(fuel) * v_tot_demand(fuel, h))
                 + sum(endF_fuel, sum(blend_fuel $ end_fuel_map(endF_fuel, blend_fuel), p_0(blend_fuel)) * v_endY(endF_fuel,h))
                 - sum(endF_fuel, md_consumer(endF_fuel, h) * v_endY(endF_fuel,h));



* --- Objective function: minimize total costs

eq_tot_cost..
    v_tot_cost =e= sum((fuel,tech,i), v_production_cost(fuel,tech,i)+ v_feedstock_cost(fuel,tech,i)
    + v_transport_cost(fuel,tech,i)
* WHen demand  active - transport costs in objective

+ v_fueltransport_cost(fuel,tech,i) $ (p_useDemand or p_useEndoDemand)

)
+ sum(h, v_redY_cost(h)) $ p_useEndoDemand
*+ sum((f,fuel,tech,i,g),art_cost*v_art1(f,fuel,tech,i,g))+
*sum((fuel, tech, i),art_cost*v_art2(fuel,tech,i)+art_cost*v_art3(fuel, tech,i)) + sum((fuel, tech,i),art_cost*v_art6(fuel, tech,i)) + sum((fuel,tech,i),art_cost*v_art7(fuel,tech,i))
;

* -----------------------------
* Declare model
* -----------------------------

Model m_locate /all/;





