
* --- Program to write data do excel that fit R

* Chose result file

$setglobal resultfile %1


*$ontext
execute_load 'results/pII/results_%resultfile%.gdx'
v_y.l,
v_feedstock.l,
v_redY_cost.l,
tot_cost,
v_tot_demand.l,
v_yEnergy.l,
p_y_sales = v_y_sales.l
v_biofuelEmis_atI.l
v_endY.l


p_eq_emisTarget= eq_emisTarget.m,
*p_eq_fix = eq_fix.m,
*p_eq_fix_tot_feedstock=eq_fix_tot_feedstock.m,
*p_eq_fix_y=eq_fix_y.m,
*p_eq_fix_tot_demand = eq_fix_tot_demand.m
*p_eq_fix_lo = eq_fix_lo.m,
*p_eq_fix_tot_feedstock_lo=eq_fix_tot_feedstock_lo.m,
*p_eq_fix_y_lo=eq_fix_y_lo.m,
*p_eq_fix_tot_demand_lo = eq_fix_tot_demand_lo.m
p_eq_feedstock= eq_feedstock.m
p_eq_capacity_up =eq_capacity_up.m
p_eq_capacity_lo =eq_capacity_lo.m
p_eq_blendCap= eq_blendCap.m
*p_eq_production = eq_production.m
cost_feedstock, production_cost, investment_cost_var, investment_cost
*p_eq_redY_max = eq_redY_max.m
;
*$offtext
$ontext
p_feedstock(b_fuel,tech,i,g,f)=0;
p_feedstock("ethanol","low","114","114","grass1")=1;
p_feedstock("ethanol","low","115","114","grass1")=2;
p_feedstock("ethanol","low","114","114","grass1")=2;

p_feedstock("ethanol","low","114","115","grass1")=1;
p_feedstock("ethanol","low","115","115","grass1")=2;
p_feedstock("ethanol","low","114","115","grass1")=2;

p_feedstock("ethanol","low","114","117","grass1")=1;
p_feedstock("ethanol","low","115","117","grass1")=2;



*p_feedstock(b_fuel,tech,"114","114",'grass1')=2;
$offtext

* --- Reorder domains to fit R
* ---------------------------------------------

quota_intesities("eth") = sum(i, v_biofuelEmis_atI.l(i))/sum((b_fuel, tech, i),v_y.l(b_fuel,tech,i))/energy_ekv("ethanol");
quota_intesities("gas") = ghg_factor("all", "gasoline","all")/energy_ekv("gas");
quota_intesities("egas") = quota_intesities("eth")/quota_intesities("gas");
quota_intesities("from volume to energy corection")=energy_ekv("gas")/energy_ekv("ethanol");
quota_intesities("tj_blend_in")= (energy_ekv("gas")/energy_ekv("ethanol"))
            /(energy_ekv("gas")/energy_ekv("ethanol")+(1-0.28)/0.28);

quota_intesities("Cap_egas") = (0.72-quota_intesities("egas"))/(1-quota_intesities("egas"));
display quota_intesities;


* --- Feedstock

p_feedstock(b_fuel,tech,i,g,grass) = v_feedstock.l(grass,b_fuel,tech,i,g);

* Sum feedstock
p_feedstock(b_fuel,tech,i,g,'totfeedstock') = sum(grass, p_feedstock(b_fuel,tech,i,g,grass) );

* quick fix - remove all non total numbers
p_feedstock(b_fuel,tech,i,g,grass)=0;

* Remove duplicate feedstock flows

$batinclude res_to_R/remove_duplicate.gms feedstock grass tot totfeedstock

*$batinclude res_to_R/remove_duplicate.gms feedstock 'totfeedstock'


* check sums are equal



* --- AB feedstock
p_feedstockAB(b_fuel,tech,i,g,ab)= v_feedstock.l(ab,b_fuel,tech,i,g);

* Sum ab feedstock
p_feedstockAB(b_fuel,tech,i,g,'totfeedstockAB') = sum(ab, p_feedstock(b_fuel,tech,i,g,ab) );



$batinclude res_to_R/remove_duplicate.gms feedstockAB ab totab totfeedstockAB

* --- AB pasture feedstock
p_feedstockABP(b_fuel,tech,i,g,abP)= v_feedstock.l(abP,b_fuel,tech,i,g);

* Sum ab feedstock
p_feedstockABP(b_fuel,tech,i,g,'totfeedstockABP') = sum(abP, p_feedstock(b_fuel,tech,i,g,abP) );



$batinclude res_to_R/remove_duplicate.gms feedstockABP abP totabP totfeedstockABP



* --- Y 
p_y(tech,i, b_fuel) $ [v_y.l(b_fuel,tech,i)> 1] = v_y.l(b_fuel,tech,i);

* --- Red Y cost - net cost for reducing fuel
p_redY_cost(h) = v_redY_cost.l(h);


* --- reduced cost for fossil decrease due to ethanol
reduced_fossil_biofuel(h,"ethanol") = p_0("gasE") * energy_ekv("ethanol") * v_tot_demand.l("ethanol",h);


* --- Total demand, for ethanol consumption
p_tot_demand(h,fuels) = v_tot_demand.l(fuels,h);

* --- Net fuel change (energy ekv)
p_fuel_change(h,"ethanol") = v_tot_demand.l('ethanol',h)* energy_ekv("ethanol") ;
p_fuel_change(h,"ethanol_0") =0;
p_fuel_change(h,"gas") = v_tot_demand.l('gas',h)* energy_ekv("gas") ;
p_fuel_change(h,"gas_0") = f_fuel_0("gasE",h);
p_fuel_change(h,"dieB") = v_tot_demand.l('die',h)* energy_ekv("die") ;
p_fuel_change(h,"dieB_0") = f_fuel_0("dieB",h);
p_fuel_change(h,"gasE") = v_tot_demand.l('gas',h)* energy_ekv("gas") +v_tot_demand.l('ethanol',h)* energy_ekv("ethanol") ;
p_fuel_change(h,"gasE_0") = f_fuel_0("gasE",h);



* ---- Policy -----


$ontext
* Old version policy
policy(h, 'gasoline') = p_eq_fix_tot_demand('gas',h) + p_eq_fix_tot_demand_lo('gas',h);
policy(h, 'diesel') = p_eq_fix_tot_demand('die',h) + p_eq_fix_tot_demand_lo('die',h);
policy(h, 'ethanolCons') = p_eq_fix_tot_demand('ethanol',h) + p_eq_fix_tot_demand_lo('ethanol',h);
policy(i, 'locationHigh') =  p_eq_fix('ethanol','high',i) + p_eq_fix_lo('ethanol','high',i);
policy(i, 'locationLow') =  p_eq_fix('ethanol','low',i) + p_eq_fix_lo('ethanol','low',i);
policy(i, 'yHigh') =  p_eq_fix_y('ethanol','low',i) +p_eq_fix_y_lo('ethanol','low',i);
policy(i, 'yLow') =  p_eq_fix_y('ethanol','low',i) + p_eq_fix_y_lo('ethanol','low',i);
policy(G, 'grass1High') = p_eq_fix_tot_feedstock('grass1',"ethanol",'high',g) + p_eq_fix_tot_feedstock_lo('grass1',"ethanol",'high',g);
policy(g, 'grass1Low') = p_eq_fix_tot_feedstock('grass1',"ethanol",'low',g) + p_eq_fix_tot_feedstock_lo('grass1',"ethanol",'low',g);
policy(g, 'grass2High') = p_eq_fix_tot_feedstock('grass2',"ethanol",'high',g) + p_eq_fix_tot_feedstock_lo('grass2',"ethanol",'high',g);
policy(g, 'grass2Low') = p_eq_fix_tot_feedstock('grass2',"ethanol",'low',g)  + p_eq_fix_tot_feedstock_lo('grass2',"ethanol",'low',g);
policy(g, 'grass3High') = p_eq_fix_tot_feedstock('grass3',"ethanol",'high',g) + p_eq_fix_tot_feedstock_lo('grass3',"ethanol",'high',g);
policy(g, 'grass3Low') = p_eq_fix_tot_feedstock('grass3',"ethanol",'low',g) + p_eq_fix_tot_feedstock_lo('grass3',"ethanol",'low',g);
$offtext




highestFeedstock("grass1", b_fuel, tech,g) $ (sum(i, v_feedstock.l('grass1',b_fuel,tech,i,g)) and not sum(i, v_feedstock.l('grass2',b_fuel,tech,i,g)))  = 1;
highestFeedstock("grass2", b_fuel, tech,g) $ (sum(i, v_feedstock.l('grass2',b_fuel,tech,i,g)) and not sum(i, v_feedstock.l('grass3',b_fuel,tech,i,g))) = 1;
highestFeedstock("grass3", b_fuel, tech,g) $ sum(i, v_feedstock.l('grass3',b_fuel,tech,i,g)) = 1;
display highestFeedstock;



* Tax on egas- transfer emission intensity to energy ekvivalents  , on v_yEnergy("gasE",h)
*lamda*epsioon gas onn 
policy_all('','','',h,'', "gas") = -p_eq_emisTarget * ghg_factor("all", "gasoline","all") /energy_ekv("gas"); 

* Tax on diesel- transfer emission intensity to energy ekvivalents, on v_yEnergy("dieB",h)
*lamda*epsioon gas
policy_all('','','',h,'', "dieB") = -p_eq_emisTarget * ghg_factor("all", "diesel","all") /energy_ekv("die"); 

* Fee ethanol: on v_tot_demand("ethanol", h) (so on valume, not TJ)
* p_0 gas + shadow value of cap - tax egas
policy_all('','','',h,'', "ethanol") = (p_0("gasE") + p_eq_blendCap("gasE",h ) ) * energy_ekv("ethanol");
policy_all('','','',h,'', "ethanol_net") =  p_eq_blendCap("gasE",h ) * energy_ekv("ethanol");

* Subsidy to ethanol production : on v_y(tech,i, b_fuel)
* MC production and variable investment+ shadow value of capacity constraint
* + transport cost + emis_ tax transport
*+ shadow value of eq_production(fuel, tech,i)(which is on y) or eq_tot_feedstock(f,fuel,tech,i) (WHICH IS ON X)
* cehck if these last exist and are equal

longest_stream('',tech,i,"demand") =0;
longest_stream('',tech,i,"demand")$ sum(h, p_y_sales("ethanol",tech,i,h)) = smax(h $p_y_sales("ethanol",tech,i,h) ,
        distance_demand(i,h ));

policy_all('',b_fuel,tech,'',i, "capacityWithTrans") $ v_y.l(b_fuel,tech,i) =
    (
    production_cost("grass1",b_fuel, tech)
    + investment_cost_var(b_fuel,tech)
    - p_eq_capacity_up(b_fuel,tech,i)
    - p_eq_capacity_lo(b_fuel,tech,i)
        ) 
+ (fuel_transport_cost_fixed + longest_stream('',tech,i,"demand") * fuel_transportcost(b_fuel,i)) 
+ p_eq_emisTarget * longest_stream('',tech,i,"demand")*ghg_factor("all", "distribution","all")
*+ conversion_factor("grass1",b_fuel,i) * p_eq_production(b_fuel, tech,i)
;

policy_all('',b_fuel,tech,'',i, "capacity_MC_varInvProd") $ v_y.l(b_fuel,tech,i) =
    (
    production_cost("grass1",b_fuel, tech)
    + investment_cost_var(b_fuel,tech)
        ) 
;

policy_all('',b_fuel,tech,'',i, "capacity_MC_shadow") $ v_y.l(b_fuel,tech,i) =
    (
    - p_eq_capacity_up(b_fuel,tech,i)
    - p_eq_capacity_lo(b_fuel,tech,i)
)
;

policy_all('',b_fuel,tech,'',i, "capacity_MC") $ v_y.l(b_fuel,tech,i) =
    policy_all('',b_fuel,tech,'',i, "capacity_MC_shadow") + policy_all('',b_fuel,tech,'',i, "capacity_MC_varInvProd");

* SUbsdy to investment, on J(b_fuel,tech,i)         
policy_all('', b_fuel, tech,'',i, "investment")$ p_y(tech,i, b_fuel) =
    investment_cost(b_fuel,tech)
    ;
    

* Subsidy to feedstock production :on sum(i, v_feedstock(f,fuel,tech,i,g))
*MC pfeestock + shadow value of capacity constraint
* + transport cost + emis_ tax transport
*+ shadow value of eq_production(fuel, tech,i)(which is on y) or eq_tot_feedstock(f,fuel,tech,i) (WHICH IS ON X)  * conversion factor
* cehck if these last exist and are equal
longest_stream(b_fuel,tech,g,"feedstock")= 0;
longest_stream(b_fuel,tech,g,"feedstock") $ sum((i,f), v_feedstock.l(f,b_fuel,tech,i,g)) = smax(i $ sum(f,v_feedstock.l(f,b_fuel,tech,i,g)),
        distance(i,g ));

display highestFeedstock, p_eq_feedstock, transport_cost, longest_stream, distance, p_y_sales, p_eq_emisTarget, ghg_factor, p_y, p_0;


policy_all('feedstock', b_fuel, tech,g,'', "feedstock") $ sum((i,f), v_feedstock.l(f,b_fuel,tech,i,g)) =
sum(f $highestFeedstock(f, b_fuel, tech,g),
        (cost_feedstock(f,g) - p_eq_feedstock(f,g))
        )
        
+ (transport_cost_fixed + longest_stream(b_fuel,tech,g,"feedstock") * transport_cost('grass1','114')) 
+ p_eq_emisTarget * longest_stream(b_fuel,tech,g,"feedstock") * ghg_factor("all", "transport","all")
*+ smax(i $ sum(f,v_feedstock.l(f,b_fuel,tech,i,g)), p_eq_production(b_fuel, tech,i))
*        * sum((f,i)$ v_feedstock.l(f,b_fuel,tech,i,g), highestFeedstock(f, b_fuel, tech,g)* conversion_factor(f,b_fuel,'114') * conversion_factor(f,b_fuel,'114'))
;

policy_all('feedstock', b_fuel, tech,g,'', "feedstock_MC_real") $ sum((i,f), v_feedstock.l(f,b_fuel,tech,i,g)) =
sum(f $highestFeedstock(f, b_fuel, tech,g),
        cost_feedstock(f,g) 
        )
;
policy_all('feedstock', b_fuel, tech,g,'', "feedstock_MC_shadow") $ sum((i,f), v_feedstock.l(f,b_fuel,tech,i,g)) =
sum(f $highestFeedstock(f, b_fuel, tech,g),
         - p_eq_feedstock(f,g)
        )
;
* on v_feedstock(f,fuel,tech,i,g)
policy_all(f, b_fuel, tech,g,i, "feedstock transport") =
- p_eq_emisTarget * distance(i,g ) * ghg_factor("all", "transport","all");

* on v_y_sales(fuel,tech,i,h)
policy_all('', b_fuel, tech,i,h, "fuel distribution") =
- p_eq_emisTarget * distance_demand(i,h ) * ghg_factor("all", "distribution","all");


* Marginal cost of fuel consumption
highestFuelCost(end_fuel,h)=0;
highestFuelCost("gasE_1",h)  $ ( v_endY.l("gasE_1",h) and not v_endY.l("gasE_2",h))  = 1;
highestFuelCost("gasE_2",h)  $ ( v_endY.l("gasE_2",h) and not v_endY.l("gasE_3",h))  = 1;
highestFuelCost("gasE_3",h)  $ ( v_endY.l("gasE_3",h) and not v_endY.l("gasE_4",h))  = 1;
highestFuelCost("gasE_4",h)  $ ( v_endY.l("gasE_4",h) and not v_endY.l("gasE_5",h))  = 1;
highestFuelCost("gasE_5",h)  $ v_endY.l("gasE_5",h) = 1;
highestFuelCost("dieB_1",h)  $ ( v_endY.l("dieB_1",h) and not v_endY.l("dieB_2",h))  = 1;
highestFuelCost("dieB_2",h)  $ ( v_endY.l("dieB_2",h) and not v_endY.l("dieB_3",h))  = 1;
highestFuelCost("dieB_3",h)  $ ( v_endY.l("dieB_3",h) and not v_endY.l("dieB_4",h))  = 1;
highestFuelCost("dieB_4",h)  $ ( v_endY.l("dieB_4",h) and not v_endY.l("dieB_5",h))  = 1;
highestFuelCost("dieB_5",h)  $   v_endY.l("dieB_5",h) = 1;


display highestFuelCost, v_endY.l, p_eq_redY_max, p_0;


policy_all('', blend_fuel, '','',h, "End fuel p ave eth ") $ sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), v_endY.l(end_fuel,h)) =

(- sum(b_fuel $ fuel_blend(blend_fuel,b_fuel), p_0(blend_fuel) * energy_ekv(b_fuel) * v_tot_demand.l(b_fuel, h)));

policy_all('', blend_fuel, '','',h, "End fuel p ave  ") $ sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), v_endY.l(end_fuel,h)) =
-(- sum(b_fuel $ fuel_blend(blend_fuel,b_fuel), p_0(blend_fuel) * energy_ekv(b_fuel) * v_tot_demand.l(b_fuel, h))
 + sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel) * v_endY.l(end_fuel,h)))
              /  sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), v_endY.l(end_fuel,h));
              
policy_all('', blend_fuel, '','',h, "End fuel p ave gase ") $ sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), v_endY.l(end_fuel,h)) =

(
 - sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel) * v_endY.l(end_fuel,h)))
              /  sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), v_endY.l(end_fuel,h));
 
policy_all('', blend_fuel, '','',h, "End fuel MC") $ sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), v_endY.l(end_fuel,h)) =

(+ sum(b_fuel $ fuel_blend(blend_fuel,b_fuel), p_0(blend_fuel) * energy_ekv(b_fuel) * v_tot_demand.l(b_fuel, h))
 - sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), p_0(blend_fuel) * v_endY.l(end_fuel,h)))
              /  sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), v_endY.l(end_fuel,h))
+ sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel), md_consumer(end_fuel, h) * highestFuelCost(end_fuel,h) )
+ sum(end_fuel $ end_fuel_map(end_fuel, blend_fuel),  p_eq_redY_max(end_fuel, h)* highestFuelCost(end_fuel,h))

;





$ontext


policy_all('feedstock', b_fuel, tech,g,'', "feedstock") =
sum(f,
        (cost_feedstock(f,g) - p_eq_feedstock(f,g))
        * highestFeedstock(f, b_fuel, tech,g));
        
policy_all(f, b_fuel, tech,'',i, "capacity")  =
    (
    production_cost(f,b_fuel, tech)
    + investment_cost_var(b_fuel,tech)
    - p_eq_capacity_up(b_fuel,tech,i)
    - p_eq_capacity_lo(b_fuel,tech,i)
        ) $ v_y.l(b_fuel,tech,i);
        
policy_all('', b_fuel, tech,'',i, "investment")$ p_y(tech,i, b_fuel) =
    investment_cost(b_fuel,tech)
    ;

$offtext
alias(tech, tech2);                      
policy2(g, "feedstock") $sum(tech, policy_all('feedstock', "ethanol", tech,g,'', "feedstock"))= smax(tech $policy_all('feedstock', "ethanol", tech,g,'', "feedstock"), policy_all('feedstock', "ethanol", tech,g,'', "feedstock"));

policy2(g, "feedstock_MC") $ sum(tech, (policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_real") + policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_shadow")))=
    smax(tech $ policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_real"), (policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_real") + policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_shadow")) );
policy2(g, "feedstock_MC_real") $ policy2(g, "feedstock_MC") =
  sum(tech   $ [ (policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_real") + policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_shadow"))
    = smax(tech2 $ policy_all('feedstock', "ethanol", tech2,g,'', "feedstock_MC_real"), (policy_all('feedstock', "ethanol", tech2,g,'', "feedstock_MC_real") + policy_all('feedstock', "ethanol", tech2,g,'', "feedstock_MC_shadow")))]
    , policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_real"));  

policy2(g, "feedstock_MC_shadow") $ policy2(g, "feedstock_MC") =
  sum(tech $ [ (policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_real") + policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_shadow"))
    = smax(tech2 $ policy_all('feedstock', "ethanol", tech2,g,'', "feedstock_MC_real"), (policy_all('feedstock', "ethanol", tech2,g,'', "feedstock_MC_real") + policy_all('feedstock', "ethanol", tech2,g,'', "feedstock_MC_shadow")))]  
   , policy_all('feedstock', "ethanol", tech,g,'', "feedstock_MC_shadow"));




policy2(i, "capacity_MC") $ sum(tech, policy_all('',"ethanol",tech,'',i, "capacity_MC") ) =
smax(tech $ policy_all('', "ethanol", tech,'',i, "capacity_MC"),
    policy_all('',"ethanol",tech,'',i, "capacity_MC") ) ;


policy2(i, "capacity_MC_varInvProd") $ policy2(i, "capacity_MC") =
    sum(tech $ [ policy_all('',"ethanol",tech,'',i, "capacity_MC") 
 = smax(tech2 $ policy_all('',"ethanol",tech2,'',i, "capacity_MC"), policy_all('',"ethanol",tech2,'',i, "capacity_MC")) 
], policy_all('', "ethanol", tech,'',i, "capacity_MC_varInvProd"));

policy2(i, "capacity_MC_shadow") $ policy2(i, "capacity_MC") =
    sum(tech $ [ policy_all('',"ethanol",tech,'',i, "capacity_MC") 
 = smax(tech2 $ policy_all('', "ethanol", tech2,'',i, "capacity_MC"), policy_all('',"ethanol",tech2,'',i, "capacity_MC") ) 
], policy_all('', "ethanol", tech,'',i, "capacity_MC_shadow"));

*smax(tech $ policy_all('', "ethanol", tech,'',i, "capacity_MC"), policy_all('', "ethanol", tech,'',i, "capacity_MC_varInvProd") + policy_all('', "ethanol", tech,'',i, "capacity_MC_shadow")) ;




policy2(i, "capacity_MC") $ sum(tech, policy_all('', "ethanol", tech,'',i, "capacity_MC")) =
smax(tech $ policy_all('', "ethanol", tech,'',i, "capacity_MC"), policy_all('', "ethanol", tech,'',i, "capacity_MC_varInvProd") + policy_all('', "ethanol", tech,'',i, "capacity_MC_shadow")) ;

*policy2(i, "capacity_MC") $ sum(tech, policy_all('', "ethanol", tech,'',i, "capacity_MC")) = smax(tech $ policy_all('', "ethanol", tech,'',i, "capacity_MC"), policy_all('', "ethanol", tech,'',i, "capacity_MC")) ;

*adding  revenues from sales
policy2(i, "capacityWithTrans_LessRev") = smax(tech, policy_all('grass1', "ethanol", tech,'',i, "capacityWithTrans")) - p_0("gasE")* energy_ekv("ethanol")  ;
policy2(i, "InvLow") = policy_all('', 'ethanol', 'low','',i, "investment");
policy2(i, "InvHigh") = policy_all('', 'ethanol', 'High','',i, "investment");


*policy2(h, 'gasoline_m3')=  ghg_factor("all", "gasoline","all") *p_eq_emisTarget;
*policy2(h, 'diesel_m3')=  ghg_factor("all", "diesel","all") *p_eq_emisTarget;

* tax per egas energy ekvivalent based on the shadow value for gasoline per energy equivalent egas. Also per diesel respectively gasoline eqiuivalen volume

                            
policy2(h, "dieB_energyEkv")$ (v_yEnergy.l('dieB',h) + f_fuel_0('dieB',h))=
            policy_all('','','',h,'', "dieB");

policy2(h, "dieB_tM3") =  policy2(h, "dieB_energyEkv") *energy_ekv("die");       
            
policy2(h, "egas_energyEkv")$ (v_yEnergy.l('gasE',h) + f_fuel_0('gasE',h))=
            policy_all('','','',h,'', "gasE");
            
policy2(h, "egas_tM3gasoline") =  policy2(h, "egas_energyEkv") *energy_ekv("gas");      

*                                (policy2(h, 'gasoline_m3')
*                                * (v_tot_demand.l("gas",h)+ f_fuel_0('gasE',h)/energy_ekv("gas"))
*                                / (v_yEnergy.l('gasE',h) + f_fuel_0('gasE',h)) );
 
* --- Tax on ethanol volume (MIGHT BE NEGATIVE, THUS BECOME SUBSIDY?)
policy2(h, "ethanol_tM3") $ p_tot_demand(h,"ethanol")  = policy_all('','','',h,'', "ethanol") ;
policy2(h, "ethanol_net") = policy_all('','','',h,'', "ethanol_net");

* tax on transport
policy2(g, "feedstock transport") = smax((i,tech), policy_all('grass1', "ethanol", tech,g,i, "feedstock transport")); 
* on v_y_sales(fuel,tech,i,h)s
policy2(h, "fuel distribution") = smax((tech,i), policy_all('', 'ethanol', tech,i,h, "fuel distribution"));
                                                           
                               
policy2(h, "End fuel MC Egas") = policy_all('', "gasE", '','',h, "End fuel MC") ;
policy2(h, "End fuel MC dieB") = policy_all('', "dieB", '','',h, "End fuel MC") ;                                        

* Write results to GDX
* ----------------------------


kna("kn","cost")=1;
execute_unload 'res_to_R\%resultfile%.gdx'
p_y, p_feedstock, p_feedstockAB, p_redY_cost, tot_cost, p_tot_demand, kna, reduced_fossil_biofuel, policy, policy2, policy_all, p_fuel_change, highestFuelCost, p_eq_redY_max, md_consumer, p_0
;


* Write excel file


execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=p_y rng=y! '
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=p_feedstock rng=feedstock! '
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=p_feedstockAB rng=feedstockALA! '
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=p_feedstockABP rng=feedstockALAP! '
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=kna rdim=2 cdim=0 rng=redYcost!A1'
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=p_redY_cost rdim=1 cdim=0 rng=redYcost!A2'
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=tot_cost rng=tot_cost! '
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=p_tot_demand rng=tot_demand! '
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=reduced_fossil_biofuel rng=reduced_fossil_biofuel! '
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=policy rng=policy! '
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=policy2 rng=policy2! '
execute 'gdxxrw.exe res_to_R\%resultfile%.gdx o=res_to_R\%resultfile%.xls par=p_fuel_change rng=fuel_change! '


* Remove data

option kill = v_y.l            ;
option kill = v_feedstock.l    ;
option kill = v_redY_cost.l    ;
option kill = v_yEnergy.l;
option kill = tot_cost         ;
option kill = v_tot_demand.l   ;

option kill =p_redY_cost                   ;
option kill =p_y                         ;
option kill =p_feedstock     ;
option kill =p_feedstockAB;
option kill =p_feedstockABP;
option kill =p_tot_demand              ;
option kill = p_y_sales;


option kill = p_eq_emisTarget;
option kill = p_eq_fix ;
option kill = p_eq_fix_tot_feedstock;
option kill = p_eq_fix_y;
option kill = p_eq_fix_tot_demand;
option kill = p_eq_fix_lo ;
option kill = p_eq_fix_tot_feedstock_lo;
option kill = p_eq_fix_y_lo;
option kill = p_eq_fix_tot_demand_lo ;
option kill = p_eq_feedstock;
option kill = p_eq_capacity_up; 
option kill = p_eq_capacity_lo;
option kill = p_eq_blendCap;
option kill = p_eq_production;
option kill = p_fuel_change;

option kill = initialfeedstock;
option kill = endfeedstock;
option kill = policy;
option kill = policy2;
option kill = policy_all;
option kill = highestFeedstock;
option kill = longest_stream;

option kill = cost_feedstock;
option kill =  production_cost;
option kill =  investment_cost_var;
option kill =  investment_cost;
