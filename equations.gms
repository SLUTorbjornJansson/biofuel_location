* ---------------------------------
* State equations 
* ---------------------------------
* scalars for endogenous demand, biofeul production and use start values. can be changed in $setglobal statements
scalar p_useEndoDemand /0/;
scalar p_distributeBiofuel /0/;
scalar p_hasStartValues /0/;
scalar p_useNeighbourFcn /0/;

$ifi %distributeBiofuel%==ON p_distributeBiofuel = 1;
$ifi %distributeBiofuel%==OFF p_distributeBiofuel = 0;
$ifi %endoDemand%==ON p_useEndoDemand = 1;
$ifi %endoDemand%==OFF p_useEndoDemand = 0;
$ifi %useNeighbourFcn%==ON p_useNeighbourFcn = 1;
$ifi %useNeighbourFcn%==OFF p_useNeighbourFcn = 0;



$ontext
* --- Declare variables to test infeasabilities, if needed
positive variable v_art1(f_eq,b_fuel,tech_eq,i,g);
positive variable v_art2(b_fuel, tech_eq,i);
positive variable v_art3(b_fuel, tech_eq,i);
positive variable v_art4(b_fuel,h);

positive variable v_art6(b_fuel,tech_eq,i);
positive variable v_art7(b_fuel, tech_eq, i);
$offtext

* ---------------------------------
* State equations
* ---------------------------------
* Production function
eq_production(b_fuel, tech_eq,i)..
    v_y(b_fuel,tech_eq,i) =e=
        sum(f_eq, conversion_factor(f_eq,b_fuel,i) * v_tot_feedstock(f_eq,b_fuel,tech_eq,i)) ;



* Cost function (at site)
eq_production_cost(b_fuel,tech_eq,i)..
v_production_cost(b_fuel,tech_eq,i) =e=
  investment_cost(b_fuel,tech_eq) * J(b_fuel,tech_eq,i)
  + sum((g,f_eq), v_feedstock(f_eq,b_fuel,tech_eq,i,g) * (production_cost(f_eq,b_fuel,tech_eq)+investment_cost_var(b_fuel,tech_eq)))
;
* Purchase cost
eq_feedstock_cost(b_fuel,tech_eq,i)..
v_feedstock_cost(b_fuel,tech_eq,i) =e=
    sum((f_eq,g), v_feedstock(f_eq,b_fuel,tech_eq,i,g) * cost_feedstock(f_eq,g));


* Feedstock transport costs
eq_transport_cost(b_fuel,tech_eq,i)..
v_transport_cost(b_fuel,tech_eq,i) =e=
    sum((f_eq,g), v_feedstock(f_eq,b_fuel,tech_eq,i,g) * (transport_cost_fixed + transport_cost(f_eq,i) * distance(i,g)) );

* Biofuel transport costs
eq_fueltransport_cost(b_fuel,tech_eq,i)$ p_distributeBiofuel..
v_fueltransport_cost(b_fuel,tech_eq,i) =e=
    sum(h, v_y_sales(b_fuel,tech_eq,i,h) * (fuel_transport_cost_fixed + distance_demand(i,h) * fuel_transportcost(b_fuel,i)))
;

* --- Relational equations and constraints

* Total feedstock to one facility
eq_tot_feedstock(f_eq,b_fuel,tech_eq,i)..
    v_tot_feedstock(f_eq,b_fuel,tech_eq,i) =e= sum(g, v_feedstock(f_eq,b_fuel,tech_eq,i,g));


* Restrict feedstock f from one region to be below a max available feedsetock
eq_feedstock(f_eq,g)..
  sum((b_fuel,tech_eq,i), v_feedstock(f_eq,b_fuel,tech_eq,i,g)
*-v_art1(f_eq,b_fuel,tech_eq,i,g)
) =l= feedstock(f_eq,g);


* Restricting production to be within tech_eqbounds
* Also assures production only if J is 1 (production facility exists)
eq_capacity_up(b_fuel,tech_eq,i)..
v_y(b_fuel,tech_eq,i)
*-v_art2(b_fuel,tech_eq,i)
 =l= capacity_constraint_up(b_fuel,tech_eq,i) * J(b_fuel,tech_eq,i);

eq_capacity_lo(b_fuel,tech_eq,i)..
v_y(b_fuel,tech_eq,i)
*+ v_art3(b_fuel, tech_eq,i)
=g= capacity_constraint_lo(b_fuel,tech_eq,i) * J(b_fuel,tech_eq,i);

* demand restriction. All production must be sold to some point h
eq_demandEq(b_fuel,tech_eq,i)$ p_distributeBiofuel..
v_y(b_fuel,tech_eq,i) =e= sum(h, v_y_sales(b_fuel,tech_eq,i,h));

* total demand in one region equals all streams to it
eq_tot_demand(b_fuel,h)$ p_distributeBiofuel..
v_tot_demand(b_fuel, h) =e= sum((tech_eq,i), v_y_sales(b_fuel,tech_eq,i,h));


* --- The following only for exogenous demand

* Setting maximum and minimum demand, if other than blend in cap
eq_demandMax(b_fuel,h)$ (p_distributeBiofuel and not p_useEndoDemand)..
*  v_tot_demand(b_fuel, h) =l= max_demand(b_fuel,h);
    sum((tech_eq,i), v_y_sales(b_fuel,tech_eq,i,h))
* -v_art4(b_fuel,h)
    =l= max_demand(b_fuel,h);

eq_demandMin(b_fuel,h)$ (p_distributeBiofuel and not p_useEndoDemand)..
        sum((tech_eq,i), v_y_sales(b_fuel,tech_eq,i,h))
*        + v_art4(b_fuel,h)
        =g= min_demand(b_fuel,h);
 
* fix blend fuel energy volume to current

eq_fixFuelvolume(blend_fuel, h) $ (p_distributeBiofuel and not p_useEndoDemand)..
f_fuel_0(blend_fuel,h) + v_yEnergy(blend_fuel,h) =e= f_fuel_0(blend_fuel,h);


* Retriction on blend - in 
eq_blendCap(blend_fuel,h )..
sum(b_fuel $ fuel_blend(blend_fuel,b_fuel), energy_ekv(b_fuel) * v_tot_demand(b_fuel, h)) =l= blend_cap(blend_fuel,h) * (f_fuel_0(blend_fuel,h) +v_yEnergy(blend_fuel,h));


* -- The endogenous fuel demand

* Blend fuels to consumption of blended fuels, in energy units
eq_energyEkv(blend_fuel,h) $ p_useEndoDemand..
v_yEnergy(blend_fuel,h) =e= sum(fuels $ fuel_blend(blend_fuel,fuels), energy_ekv(fuels)*v_tot_demand(fuels, h)) ;


* fuel consumption equals sum of consumption in all cost segments
eq_end_uses(blend_fuel,h) $ p_useEndoDemand..
v_yEnergy(blend_fuel,h) =e= sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), v_endY(end_fuel,h));

* Each cost segment is bounded 
eq_redY_max(end_fuel, h) $ p_useEndoDemand..
v_endY(end_fuel,h) =g= max_redY(end_fuel, h);

v_endY.lo(end_fuel,h) =max_redY(end_fuel, h);

eq_redY_min(end_fuel, h) $ p_useEndoDemand..
v_endY(end_fuel,h) =l= min_redY(end_fuel, h);
v_endY.up(end_fuel,h) = min_redY(end_fuel, h);


* Equations defining differnt parts of cost (and benefits) of decreasing fuel use         
eq_redY_fossilCostGainRed(end_fuel,h) $ p_useEndoDemand ..
v_redY_fossilCostGainRed(end_fuel, h) =e= sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel)) * v_endY(end_fuel,h);

eq_redY_fossilCostGainBio(b_fuel, h)..
v_redY_fossilCostGainBio(b_fuel, h) =e= - (sum(blend_fuel $ fuel_blend(blend_fuel,b_fuel), p_0(blend_fuel)) - biotax(b_fuel)) * energy_ekv(b_fuel) * v_tot_demand(b_fuel, h);

eq_redY_consLoss(end_fuel,h) $ p_useEndoDemand..
v_redY_consLoss(end_fuel, h) =e= -  md_consumer(end_fuel, h) * v_endY(end_fuel,h);

eq_redYCost(h) $ p_useEndoDemand..
v_redY_cost(h) =e= sum(end_fuel, v_redY_fossilCostGainRed(end_fuel, h))
                    + sum(b_fuel, v_redY_fossilCostGainBio(b_fuel,h))
                    + sum(end_fuel, v_redY_consLoss(end_fuel, h));

* --- Emissions

eq_EFeedstock(f_eq,b_fuel,tech_eq,i,g)..
v_biofuelEmis(f_eq,"feedstock",b_fuel,tech_eq,i,g)  =e=  v_feedstock(f_eq,b_fuel,tech_eq,i,g) * ghg_factor(f_eq,"feedstock",g);

eq_EProduction(b_fuel,tech_eq,i)..
v_biofuelEmis("all","production",b_fuel,tech_eq,i,"all") =e= v_y(b_fuel,tech_eq,i) * ghg_factor("all","production","all");

eq_EInvestment(b_fuel,tech_eq,i)..
v_biofuelEmis("all","investment", b_fuel,tech_eq,i, "all") =e= J(b_fuel,tech_eq,i) * ghg_factor("all","investment","all");

eq_ETransport(f_eq,b_fuel,tech_eq,i,g)..
v_biofuelEmis(f_eq,"transport",b_fuel,tech_eq,i,g) =e= v_feedstock(f_eq,b_fuel,tech_eq,i,g)* distance(i,g)*ghg_factor("all", "transport","all");

eq_EDistribution(b_fuel,tech_eq,i,h) $ p_distributeBiofuel..
v_biofuelEmis("all","distribution",b_fuel,tech_eq,i,h) =e= v_y_sales(b_fuel,tech_eq,i,h)* distance_demand(i,h)*ghg_factor("all", "distribution","all");

eq_ELUC(f_eq,b_fuel,tech_eq,i,g)..
* will only take abanndonned land as ony these have carbon stock changes
v_biofuelEmis(f_eq,"LUC",b_fuel,tech_eq, i,g) =e=  v_feedstock(f_eq,b_fuel,tech_eq,i,g)  * ghg_factor(f_eq,"LUC",g);

* equation for fossil emission decrease, when endogenous demand not used
eq_EGasolineSubs(b_fuel,tech_eq,i,h) $ (p_distributeBiofuel and not p_useEndoDemand)..
*for assumed direct  substitution
v_biofuelEmis("all","gasolineSubs",b_fuel,tech_eq,i,h) =e= v_y_sales(b_fuel,tech_eq,i,h)*
                                                    [ghg_factor("all", "gasolineSubs","all")$ sameas(b_fuel, "ethanol")];

eq_EDieselSubs(b_fuel,tech_eq,i,h) $ (p_distributeBiofuel and not p_useEndoDemand)..
*for assumed direct  substitution                                                    
v_biofuelEmis("all","dieselSubs",b_fuel,tech_eq,i,h) =e= v_y_sales(b_fuel,tech_eq,i,h)*
                                                    [ghg_factor("all", "dieselSubs","all")$ sameas(b_fuel, "biodie")];                                                    

* Emission decrease per fossil fuel ,  in t tonne co2 per t m3 fuel
eq_fossilEmissions(f_fuel,h) $ p_useEndoDemand..
v_fossil_emissions(f_fuel,h)=e= v_tot_demand(f_fuel,h) * ghg_factor("all", "gasoline","all") $ sameas(f_fuel, "gas")
                         + v_tot_demand(f_fuel,h) * ghg_factor("all", "diesel","all") $ sameas(f_fuel, "die")
                         ;

* Total biofuel emissions
eq_biofuelEmissions(i)..
v_biofuelEmis_atI(i) =e= 
sum(GHGcat,
                    sum((f_eq,b_fuel,tech_eq,g),v_biofuelEmis(f_eq,GHGcat,b_fuel,tech_eq,i,g)) $ [sameas(GHGcat,"feedstock") or sameas(GHGcat,"transport")]
                  + sum((f_eq,b_fuel,tech_eq,g), v_biofuelEmis(f_eq,GHGcat,b_fuel,tech_eq, i,g)) $ [sameas(GHGcat,"LUC")]
                  + sum((b_fuel,tech_eq), v_biofuelEmis("all",GHGcat,b_fuel,tech_eq,i,"all"))  $ [sameas(GHGcat,"production") or sameas(GHGcat,"investment")]
                  + sum((b_fuel,tech_eq,h), v_biofuelEmis("all",GHGcat,b_fuel,tech_eq,i,h))  $ [sameas(GHGcat,"distribution")]
                  + sum((b_fuel, tech_eq,h), v_biofuelEmis("all",GHGcat,b_fuel,tech_eq,i,h))$ [(p_distributeBiofuel and not p_useEndoDemand)  and sameas(GHGcat,"gasolineSubs")]
                  + sum((b_fuel, tech_eq,h), v_biofuelEmis("all",GHGcat,b_fuel,tech_eq,i,h))$ [(p_distributeBiofuel and not p_useEndoDemand)  and sameas(GHGcat,"dieselSubs")]
                  )
                        ;

eq_totEmissions..
v_totEmissions =e=
    sum(i, v_biofuelEmis_atI(i))
+   sum((f_fuel, h), v_fossil_emissions(f_fuel,h)) $ p_useEndoDemand
;

* --- Targtes

eq_prodTarget(b_fuel)..
  sum((tech_eq,i),v_y(b_fuel,tech_eq,i)
*+v_art7, b_fuel, tech_eq, i)
) =g= p_prodTarget(b_fuel);

eq_emisTarget..
  v_totEmissions =l= p_EmisTarget;





* --- Objective function: minimize total costs

eq_tot_cost..
v_tot_cost =e=
   sum((b_fuel,tech_eq,i), v_production_cost(b_fuel,tech_eq,i)+ v_feedstock_cost(b_fuel,tech_eq,i)
    + v_transport_cost(b_fuel,tech_eq,i)
    
* When demand  active - transport costs in objective

    + v_fueltransport_cost(b_fuel,tech_eq,i) $ p_distributeBiofuel

    )
    * (1 + p_VAT)
*
+ sum(h, v_redY_cost(h)) $ p_useEndoDemand
+ sum((b_fuel, h), v_redY_fossilCostGainBio(b_fuel,h)) $ (not p_useEndoDemand)
*+ sum((f_eq,b_fuel,tech_eq,i,g),art_cost*v_art1(f_eq,b_fuel,tech_eq,i,g))+
*sum((b_fuel, tech_eq, i),art_cost*v_art2(b_fuel,tech_eq,i)+art_cost*v_art3(b_fuel, tech_eq,i)) + sum((b_fuel, tech_eq,i),art_cost*v_art6(b_fuel, tech_eq,i)) + sum((b_fuel,tech_eq,i),art_cost*v_art7(b_fuel,tech_eq,i))

;


* --- Model restrictions

e_J(b_fuel,tech_eq)..

* the number of facilites must be non-negative (can be restricted to a given number)
    sum(i, J(b_fuel,tech_eq,i)
*-v_art6(b_fuel,tech_eq,i)
)
*=g= 0
=l= p_facility_max(tech_eq)
;

* Restrict to at most one tech_eqlevel type of facility (fuel type) per region

eq_facilityRestrictionTech(b_fuel,i)..
    sum(tech_eq, J(b_fuel,tech_eq,i)) =l= p_max_facilityReg;

* Restrict to only one type of fuel per facility...
* not ready
eq_facilityRestrictionFeed(b_fuel, tech_eq, i)..
1=e=1;
*    sum(f_eq,abs(v_tot_feedstock(f_eq,b_fuel,tech_eq,i))) =l= max(f_eq,v_tot_feedstock(f_eq,b_fuel,tech_eq,i));


* If 1, it is suitable, otherwise zero and non-suitable. Possibility to exclude facility sites
eq_facility_suitability(b_fuel,tech_eq,i)..
    J(b_fuel,tech_eq,i) =l= facilitySuitability(b_fuel,tech_eq,i);
*0=e=0;
* Restrict facilities in neigbouring area



eq_noNeighbour(b_fuel, tech_eq,i)$ p_useNeighbourFcn..
*0=e=0;
    sum(ii$ (distance_facility(i,ii)<300), J(b_fuel,tech_eq,ii)) =l= 1;
* -----------------------------
* Declare model
* -----------------------------

Model m_locate /all/;



* Put some regions as not suitable for facilites, to ease solving
facilitySuitability(b_fuel,tech_eq,i) $borderAndCityMunicipality(i) = 0;
J.fx(b_fuel,tech_eq,i) $ (facilitySuitability(b_fuel,tech_eq,i)=0)  =0;

display facilitySuitability, J.lo, J.up, borderAndCityMunicipality;

* fix medium and low facilities to 0, to avoidnthem (not only in constriant)
*J.fx(b_fuel, "medium",i)=0;
*J.fx(b_fuel, "low",i)=0;

* --- Bounds implied by constraints


v_y.up(b_fuel,tech_eq,i)
    = capacity_constraint_up(b_fuel,tech_eq,i);
v_production_cost.up(b_fuel,tech_eq,i) $ smax(f_eq, conversion_factor(f_eq,b_fuel,i) * (production_cost(f_eq,b_fuel,tech_eq)+investment_cost_var(b_fuel,tech_eq)))
    = capacity_constraint_up(b_fuel,tech_eq,i) /smax(f_eq, conversion_factor(f_eq,b_fuel,i) * (production_cost(f_eq,b_fuel,tech_eq)+investment_cost_var(b_fuel,tech_eq)));
v_feedstock_cost.up(b_fuel,tech_eq,i) $ smax(f_eq, conversion_factor(f_eq,b_fuel,i) * smax(g, cost_feedstock(f_eq,g)))
    = capacity_constraint_up(b_fuel,tech_eq,i) / smax(f_eq, conversion_factor(f_eq,b_fuel,i) * smax(g, cost_feedstock(f_eq,g)));
v_transport_cost.up(b_fuel,tech_eq,i) $ smax(f_eq, conversion_factor(f_eq,b_fuel,i) * (transport_cost_fixed + transport_cost(f_eq,i) * smax(gg, distance(i,gg))) )
    = capacity_constraint_up(b_fuel,tech_eq,i) / smax(f_eq, conversion_factor(f_eq,b_fuel,i) * (transport_cost_fixed + transport_cost(f_eq,i) * smax(gg, distance(i,gg))) );
v_fueltransport_cost.up(b_fuel,tech_eq,i) = capacity_constraint_up(b_fuel,tech_eq,i) * (fuel_transport_cost_fixed +  fuel_transportcost(b_fuel,i) * smax(hh, distance_demand(i,hh) ));
v_tot_feedstock.up(f_eq,b_fuel,tech_eq,i) $ conversion_factor(f_eq,b_fuel,i)
    = capacity_constraint_up(b_fuel,tech_eq,i) /conversion_factor(f_eq,b_fuel,i);
v_feedstock.up(f_eq,b_fuel,tech_eq,i,g) $ conversion_factor(f_eq,b_fuel,i)
    = capacity_constraint_up(b_fuel,tech_eq,i) /conversion_factor(f_eq,b_fuel,i);
v_feedstock.up(f_eq,b_fuel,tech_eq,i,g)
    = feedstock(f_eq,g);

* based on assumption that fuel will not increase dramatically, and cannot be egative
v_yEnergy.up(blend_fuel,h)
    = f_fuel_0(blend_fuel,h);
v_yEnergy.lo(blend_fuel,h)
    = -f_fuel_0(blend_fuel,h);

v_biofuelEmis.up(f_eq,"feedstock",b_fuel,tech_eq,i,g) $ (conversion_factor(f_eq,b_fuel,i) * ghg_factor(f_eq,"feedstock",g))
    =  capacity_constraint_up(b_fuel,tech_eq,i) /conversion_factor(f_eq,b_fuel,i) * ghg_factor(f_eq,"feedstock",g);
v_biofuelEmis.up("all","production",b_fuel,tech_eq,i,"all")
    = capacity_constraint_up(b_fuel,tech_eq,i) * ghg_factor("all","production","all");
v_biofuelEmis.up("all","investment", b_fuel,tech_eq,i, "all")
    =  ghg_factor("all","investment","all");
v_biofuelEmis.up(f_eq,"transport",b_fuel,tech_eq,i,g)
    = feedstock(f_eq,g)* distance(i,g)*ghg_factor("all", "transport","all");
v_biofuelEmis.up("all","distribution",b_fuel,tech_eq,i,h)
    = capacity_constraint_up(b_fuel,tech_eq,i) * distance_demand(i,h)*ghg_factor("all", "distribution","all");






