*--- Load results from scenario


*$gdxin 'results_%2.gdx'
*$load J=J.l, highest_cost, y= v_y.l, cost_share, obj = v_tot_cost.l
*$gdxin
parameter p_J(*,*,*);
parameter p_y(*,*,*);
parameter p_feedstock(*,*,*,*,*);
scalar p_totEmissions;
parameter p_fossil_emissions(f_fuel, h);
parameter p_biofuelEmis(*, GHGcat,b_fuel,tech,i,*);
parameter p_redY_cost(h);
parameter p_tot_demand(fuels, h);
parameter p_endY(end_fuel,h);
parameter p_yEnergy(blend_fuel,h);
parameter p_y_sales(b_fuel,tech,i,h);
scalar p_emisTargetM;

scalar obj;
execute_load '%path%%2.gdx', p_J=J.l, p_y= v_y.l,highest_cost, cost_share, tot_cost, obj = v_tot_cost.l, p_redY_cost = v_redY_cost.l,
 p_totEmissions=v_totEmissions.l, p_biofuelEmis=v_biofuelEmis.l,
 p_feedstock=v_feedstock.l,
p_tot_demand = v_tot_demand.l, p_y_sales= v_y_sales.l, p_yEnergy=v_yEnergy.l, p_endY=v_endY.l,
p_fossil_emissions=v_fossil_emissions.l , 
rep_feedstock2, tot_FeedstockSE,feedstock_use_percent, p_solveInfo
p_emisTargetM= eq_emisTarget.m
;
acronym %2;
display cost_share, obj;
* --- only show results for ethanol
*v_feedstock(f, b_fuel, tech, i,g)=v_feedstock(f, "ethanol", tech, i,g);

* index data by scenario

* Facilities
J_comp(b_fuel, tech, i, "%1") = p_J(b_fuel, tech, i);
J_comp(b_fuel, tech, lan, "%1") = sum(i$lan_to_kn(lan,i), p_J(b_fuel, tech, i)$ p_J(b_fuel, tech, i));
* --- Distance between  feedstock and facility
rep_feedstock2_comp(f,b_fuel,tech,i,g,'distance','%1') $ p_J(b_fuel, tech, i) = rep_feedstock2(f, b_fuel,tech,i,g,'distance');

* feedstock from each region to a facility
rep_feedstock2_comp(f, b_fuel,tech,i,g,'supply','%1') $ p_J(b_fuel, tech, i) = rep_feedstock2(f, b_fuel,tech,i,g,'supply');


* --- Objective value
obj_comp('%1','level') = obj;

acronym supply;



* --- Comp, various data, at facility location i

* Find the production of the  four largest low and high (and medium if existing) tech locations
* based on the largest, seconf largest,m etc. can miss if two are equal size!

alias(ii,i);
comp('production', b_fuel,tech,i,'%1')$ p_J( b_fuel, tech, i) =  p_y(b_fuel, tech, i);
comp('production', b_fuel,"low1",'','%1')= smax(i,comp('production', b_fuel,"low",i,'%1'));
comp('production', b_fuel,"low1",'','%1')$ (comp('production', b_fuel,"low1",'','%1')=0) = 1;
comp('production', b_fuel,"low",i,'%1')$(comp('production', b_fuel,"low",i,'%1')= comp('production', b_fuel,"low1",'','%1')) = 0;
comp('production', b_fuel,"low2",'','%1')= smax(i,comp('production', b_fuel,"low",i,'%1'));
comp('production', b_fuel,"low2",'','%1')$ (comp('production', b_fuel,"low2",'','%1')=0) = 1;
comp('production', b_fuel,"low",i,'%1')$(comp('production', b_fuel,"low",i,'%1')= comp('production', b_fuel,"low2",'','%1')) = 0;
comp('production', b_fuel,"low3",'','%1')= smax(i,comp('production', b_fuel,"low",i,'%1'));
comp('production', b_fuel,"low3",'','%1')$ (comp('production', b_fuel,"low3",'','%1')=0) = 1;
comp('production', b_fuel,"low",i,'%1')$(comp('production', b_fuel,"low",i,'%1')= comp('production', b_fuel,"low3",'','%1')) = 0;

comp('production', b_fuel,"medium1",'','%1')= smax(i,comp('production', b_fuel,"medium",i,'%1'));
comp('production', b_fuel,"medium1",'','%1')$ (comp('production', b_fuel,"medium1",'','%1')=0) = 1;
comp('production', b_fuel,"medium",i,'%1')$(comp('production', b_fuel,"medium",i,'%1')= comp('production', b_fuel,"medium1",'','%1')) = 0;
comp('production', b_fuel,"medium2",'','%1')= smax(i,comp('production', b_fuel,"medium",i,'%1'));
comp('production', b_fuel,"medium2",'','%1')$ (comp('production', b_fuel,"medium2",'','%1')=0) = 1;
comp('production', b_fuel,"medium",i,'%1')$(comp('production', b_fuel,"medium",i,'%1')= comp('production', b_fuel,"medium2",'','%1')) = 0;
comp('production', b_fuel,"medium3",'','%1')= smax(i,comp('production', b_fuel,"medium",i,'%1'));
comp('production', b_fuel,"medium3",'','%1')$ (comp('production', b_fuel,"medium3",'','%1')=0) = 1;
comp('production', b_fuel,"medium",i,'%1')$(comp('production', b_fuel,"medium",i,'%1')= comp('production', b_fuel,"medium3",'','%1')) = 0;
comp('production', b_fuel,"medium4",'','%1')= smax(i,comp('production', b_fuel,"medium",i,'%1'));
comp('production', b_fuel,"medium4",'','%1')$ (comp('production', b_fuel,"medium4",'','%1')=0) = 1;
comp('production', b_fuel,"medium",i,'%1')$(comp('production', b_fuel,"medium",i,'%1')= comp('production', b_fuel,"medium4",'','%1')) = 0;


comp('production', b_fuel,"high1",'','%1')= smax(i,comp('production', b_fuel,"high",i,'%1'));
comp('production', b_fuel,"high1",'','%1')$ (comp('production', b_fuel,"high1",'','%1')=0) = 1;
comp('production', b_fuel,"high",i,'%1')$(comp('production', b_fuel,"high",i,'%1')= comp('production', b_fuel,"high1",'','%1')) = 0;
comp('production', b_fuel,"high2",'','%1')= smax(i,comp('production', b_fuel,"high",i,'%1'));
comp('production', b_fuel,"high2",'','%1')$ (comp('production', b_fuel,"high2",'','%1')=0) = 1;
comp('production', b_fuel,"high",i,'%1')$(comp('production', b_fuel,"high",i,'%1')= comp('production', b_fuel,"high2",'','%1')) = 0;
comp('production', b_fuel,"high3",'','%1')= smax(i,comp('production', b_fuel,"high",i,'%1'));
comp('production', b_fuel,"high3",'','%1')$ (comp('production', b_fuel,"high3",'','%1')=0) = 1;
comp('production', b_fuel,"high",i,'%1')$(comp('production', b_fuel,"high",i,'%1')= comp('production', b_fuel,"high3",'','%1')) = 0;
comp('production', b_fuel,"high4",'','%1')= smax(i,comp('production', b_fuel,"high",i,'%1'));
comp('production', b_fuel,"high4",'','%1')$ (comp('production', b_fuel,"high4",'','%1')=0) = 1;
comp('production', b_fuel,"high",i,'%1')$(comp('production', b_fuel,"high",i,'%1')= comp('production', b_fuel,"high4",'','%1')) = 0;

* total number of facilites , of each tech and total, 
comp('facilites', b_fuel,tech,'','%1')$ sum(i,p_J( b_fuel, tech, i)) = sum(i, p_J(b_fuel, tech, i));
comp('allfacilites', b_fuel,'','','%1') = sum(tech, comp('facilites', b_fuel,tech,'','%1'));

* control nu,ber of facilites assigned to High1 etc, as one can be overwritten
comp('controlgraphfacilites', b_fuel,'','','%1') = sum(graphtechs$ (comp('production', b_fuel,graphtechs,'','%1')>1), 1);

* Average production per facility, 
comp('aveProd', b_fuel,tech,'','%1')$ sum(i, p_J(b_fuel, tech, i) )= sum(i, p_y(b_fuel, tech, i)) / sum(i$p_y(b_fuel, tech, i),1);

* Max distance beween a facility and a fedstock region, average distance for a facility and in total
comp('maxDist', b_fuel,tech,i,'%1')$ p_J(b_fuel, tech, i) = smax((g,f), rep_feedstock2(f, b_fuel,tech,i,g,'distance'));
comp('aveDist', b_fuel,tech,i,'%1')$ p_J(b_fuel, tech, i) = sum((f,g),rep_feedstock2(f, b_fuel,tech,i,g,'supply')
                                                                * rep_feedstock2(f, b_fuel,tech,i,g,'distance'))
                                                             /sum((f,g),rep_feedstock2(f, b_fuel,tech,i,g,'supply'));
comp('aveDist', b_fuel,"","total",'%1')$ sum((i,tech),p_J(b_fuel, tech, i)) =  sum((f,tech,g,i),rep_feedstock2(f, b_fuel,tech,i,g,'supply')
                                                                                  * rep_feedstock2(f, b_fuel,tech,i,g,'distance'))
 
                                                                              /sum((f,tech,g,i),rep_feedstock2(f, b_fuel,tech,i,g,'supply'));
* objective value 
comp('objective',"","total",'','%1') = obj;

* production per site with location, and sweden total
comp('production', b_fuel,tech,i,'%1')$ p_y(b_fuel, tech, i)= p_y(b_fuel, tech, i);
comp('production', b_fuel,'total',"SE",'%1')=sum((tech,i), comp('production', b_fuel,tech,i,'%1'));

* Change in fuel use per fuel type, in TJ
comp("fuel use Energy",fuels,"",h,'%1')=   energy_ekv(fuels) * p_tot_demand(fuels, h);
comp("fuel use Energy",fuels,"","SE",'%1')= sum(h, comp("fuel use Energy",fuels,"",h,'%1'));

* highest cost and dcost share for biofuel
highest_cost_comp(f, b_fuel, tech, i,cost_items,"%1")$ p_J(b_fuel, tech, i) = highest_cost(f, b_fuel, tech, i,cost_items) ;
cost_share_comp(b_fuel, tech, i,cost_items,"level","%1")$ p_J(b_fuel, tech, i) = cost_share(b_fuel, tech, i,cost_items);
cost_share_comp(b_fuel, "highLow", "SE",cost_items,"level","%1") = cost_share(b_fuel,"highLow", "SE",cost_items);


* Production info
y_comp(b_fuel, tech, i,"%1")$ p_J(b_fuel, tech, i)= p_y(b_fuel, tech, i);


* Costs per cost item
tot_cost_comp(b_fuel, tech, i,cost_items,"level","%1")$ p_J(b_fuel, tech, i) = tot_cost(b_fuel, tech, i,cost_items);
tot_cost_comp(b_fuel, tech, i,"Total biofuel","level","%1")$ p_J(b_fuel, tech, i) = tot_cost(b_fuel, tech, i,"total");
tot_cost_comp('', "highLow", h,"Fuel change total","level","%1") = p_redY_cost(h);
tot_cost_comp('', "highLow", "SE","Fuel change total","level","%1") = sum(h, p_redY_cost(h));
tot_cost_comp(b_fuel, "highLow", "SE",cost_items,"level","%1") = tot_cost(b_fuel,"highLow", "SE",cost_items);
tot_cost_comp(b_fuel, "highLow", "SE","Total biofuel","level","%1") = tot_cost(b_fuel, "highLow", "SE","total");

* saved costs from biofuel replacment - fossil price times quantity
tot_cost_comp(b_fuel, "highLow", h,"Biofuel substitution","level","%1") =
-  sum(blend_fuel $ fuel_blend(blend_fuel,b_fuel), p_0(blend_fuel)) * energy_ekv(b_fuel) * p_tot_demand(b_fuel, h);


* Consumer loss costs calcualted as in data section
tot_cost_comp("", "highLow", h,"Consumer loss","level","%1")  =
- sum(end_fuel 
            , p_endY(end_fuel,h) *

                    (- (fuel_segment(end_fuel)
                        + 0.5 * smin(end_fuel2, abs(fuel_segment(end_fuel2))) $(not (sameas(end_fuel,"gasE_m1") or sameas(end_fuel,"dieB_m1")))
* Special treatment of positive fuel increase                      *
                        - 0.5 * fuel_segment("gasE_m1") $ sameas(end_fuel,"gasE_m1")
                        - 0.5 * fuel_segment("dieB_m1") $ sameas(end_fuel,"dieB_m1")
                                )
                              * sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel),
                                        p_0(blend_fuel) * f_fuel_0(blend_fuel,h) / (elas_fuel(h, blend_fuel) * f_fuel_0(blend_fuel,h)))

                    ) $  sum(blend_fuel $ end_fuel_map(end_fuel, blend_fuel), f_fuel_0 (blend_fuel,h))
);

* Aggregate to Sweden
tot_cost_comp("", "highLow", "SE","Consumer loss","level","%1") = sum(h, tot_cost_comp("", "highLow", h,"Consumer loss","level","%1"));
tot_cost_comp(b_fuel, "highLow", "SE","Biofuel substitution","level","%1") = sum(h, tot_cost_comp("", "highLow", h,"Biofuel substitution","level","%1") );
tot_cost_comp(b_fuel, "highLow", "SE","Biofuel substitution","level","%1") = sum(h, tot_cost_comp(b_fuel, "highLow", h,"Biofuel substitution","level","%1") );

* Net biofuel cost (only for Sweden as at different locations)
tot_cost_comp(b_fuel, "highLow", "SE","Net Biofuel","level","%1")
    = tot_cost_comp(b_fuel, "highLow", "SE","Total biofuel","level","%1") + tot_cost_comp(b_fuel, "highLow", "SE","Biofuel substitution","level","%1");

* Total costs for biofuel and fuel decresase (in total fuel change, the reduced costs for fossils, attributed to biofuel is included, but not so in all reporting)
tot_cost_comp('', "highLow", "SE","Net cost","level","%1")
 = sum(b_fuel, tot_cost_comp(b_fuel, "highLow", "SE","Total biofuel","level","%1")) + tot_cost_comp('', "highLow", "SE","Fuel change total","level","%1") ;
 
* percentage of total direct biofuel costs
tot_cost_comp(b_fuel, "highLow", "SE",cost_items,"shareBiofuelCost","%1") $tot_cost_comp(b_fuel, "highLow", "SE","Total biofuel","level","%1")
    = tot_cost_comp(b_fuel, "highLow", "SE",cost_items,"level","%1") / tot_cost_comp(b_fuel, "highLow", "SE","Total biofuel","level","%1");

* Average cost per item
tot_cost_comp(b_fuel, "highLow", "SE",cost_items,"AverageCostBio","%1") $ comp('production', b_fuel,'total',"SE",'%1')
    = tot_cost_comp(b_fuel, "highLow", "SE",cost_items,"level","%1")/ comp('production', b_fuel,'total',"SE",'%1');
tot_cost_comp(b_fuel, "highLow", "SE","Biofuel substitution","AverageCostBio","%1") $ comp('production', b_fuel,'total',"SE",'%1')
    =  tot_cost_comp(b_fuel, "highLow", "SE","Biofuel substitution","level","%1")/ comp('production', b_fuel,'total',"SE",'%1');   

tot_cost_comp(b_fuel, "highLow", "SE",'Net biofuel',"AverageCostBio","%1") $ comp('production', b_fuel,'total',"SE",'%1')
    = tot_cost_comp(b_fuel, "highLow", "SE","Net Biofuel","level","%1")/ comp('production', b_fuel,'total',"SE",'%1');




* --- Feedstock use
feedstock_use_comp('TotFeedstock0',f,'%1')= tot_feedstockSE(f);
* add small number to get an obs
feedstock_use_comp('TotFeedstock',f,'%1') = 0.000001 + sum((b_fuel,tech,i,g), p_feedstock(f,b_fuel,tech,i,g));
feedstock_use_comp('TotFeedstockPercent',f,'%1')=0.0001+ feedstock_use_percent(f);


* ---- Emission change
comp_emissions("Total",'','','level','SE','%1') =p_totEmissions;

* per category connected to biofuel
comp_emissions(GHGcat,b_fuel,'','level',i,'%1') =

                    sum((f,tech,g),p_biofuelEmis(f,GHGcat,b_fuel,tech,i,g)) $ [sameas(GHGcat,"feedstock") or sameas(GHGcat,"transport")]
                  + sum((ab,tech,g), p_biofuelEmis(ab,GHGcat,b_fuel,tech, i,g)) $ [sameas(GHGcat,"LUC")]
                  + sum((tech), p_biofuelEmis("all",GHGcat,b_fuel,tech,i,"all"))  $ [sameas(GHGcat,"production") or sameas(GHGcat,"investment")]
                  + sum((tech,h), p_biofuelEmis("all",GHGcat,b_fuel,tech,i,h))  $ [sameas(GHGcat,"distribution")]

* replacement emissions reduction if demand model not in use                  
                  + sum(( tech,h), p_biofuelEmis("all",GHGcat,b_fuel,tech,i,h))$ [sameas(GHGcat,"gasolineSubs") or sameas(GHGcat,"dieselSubs")]
                                          ;
comp_emissions(GHGcat,'biofuelTotal','','level',i,'%1') = sum(b_fuel, comp_emissions(GHGcat,b_fuel,'','level',i,'%1') );

comp_emissions(GHGcat,b_fuel,'','level',"SE",'%1') = sum(i, comp_emissions(GHGcat,b_fuel,'','level',i,'%1'));
comp_emissions(GHGcat,'biofuelTotal','','level',"SE",'%1') = sum(i, comp_emissions(GHGcat,'biofuelTotal','','level',i,'%1') );

* Emissions from fossil fuel brutto
comp_emissions('Fossil',f_fuel,'','level',h,'%1') = p_fossil_emissions(f_fuel,h);
comp_emissions('Fossil',f_fuel,'','level',"SE",'%1')  = sum(h, comp_emissions(f_fuel,'','','level',h,'%1'));

* emissisn reduction acconte d to biofuel
comp_emissions("FossilSubs","ethanol",'','level',h,'%1') = sum((tech,i), p_y_sales("ethanol",tech,i,h)) * ghg_factor("all", "gasolineSubs","all");
comp_emissions("FossilSubs","biofuelTotal",'','level',h,'%1') = sum(b_fuel, comp_emissions("FossilSubs","ethanol",'','level',h,'%1'));

comp_emissions("FossilSubs","ethanol",'','level',"SE",'%1')  = sum(h, comp_emissions("FossilSubs","ethanol",'','level',h,'%1')) ;
comp_emissions("FossilSubs","biofuelTotal",'','level',"SE",'%1') = sum(b_fuel, comp_emissions("FossilSubs",b_fuel,'','level',"SE",'%1'));

* Net emissions reduction, fossils (net of share going to biofuels replacing fossils)
comp_emissions("FossilDecrease",f_fuel,'','level',h,'%1') = comp_emissions('Fossil',f_fuel,'','level',h,'%1') 
                                - comp_emissions("FossilSubs","ethanol",'','level',h,'%1') $ sameas(f_fuel,"gas")
*                                - comp_emissions("FossilSubs","...",'','',h,'%1') $ sameas(f_fuel,"diesel")                             
;

comp_emissions("FossilDecrease",f_fuel,'','level',"SE",'%1') = sum(h, comp_emissions("FossilDecrease",f_fuel,'','level',h,'%1'));

* Direct emissions from biofuel, per facility
comp_emissions("BiofuelEmis",b_fuel,'','level',i,'%1')= sum(GHGcat $ [not (sameas(GHGcat,"gasolineSubs") or sameas(GHGcat,"dieselSubs"))],
                                                    comp_emissions(GHGcat,b_fuel,'','level',i,'%1'));
comp_emissions("BiofuelEmis","biofuelTotal",'','level',i,'%1')= sum(b_fuel, comp_emissions("BiofuelEmis",b_fuel,'','level',i,'%1'));
                                                    
comp_emissions("BiofuelEmis",b_fuel,'','level',"SE",'%1') = sum(i, comp_emissions("BiofuelEmis",b_fuel,'','level',i,'%1'));
comp_emissions("BiofuelEmis","biofuelTotal",'','level',"SE",'%1') = sum(b_fuel, comp_emissions("BiofuelEmis",b_fuel,'','level',"SE",'%1'));

comp_emissions("NetBiofuelEmis",b_fuel,'','level',"SE",'%1') = comp_emissions("BiofuelEmis",b_fuel,'','level',"SE",'%1') + comp_emissions("FossilSubs",b_fuel,'','level',"SE",'%1');
comp_emissions("NetBiofuelEmis","biofuelTotal",'','level',"SE",'%1') = sum(b_fuel, comp_emissions("NetBiofuelEmis",b_fuel,'','level',"SE",'%1'));

* Share emissions reduction to each fuel

comp_emissions("NetBiofuelEmis",b_fuel,'','share',"SE",'%1') $ comp_emissions("Total",'','','level','SE','%1')
 = comp_emissions("NetBiofuelEmis",b_fuel,'','level',"SE",'%1') /
  comp_emissions("Total",'','','level','SE','%1');
comp_emissions("NetBiofuelEmis","biofuelTotal",'','share',"SE",'%1') $ comp_emissions("Total",'','','level','SE','%1')
 = comp_emissions("NetBiofuelEmis","biofuelTotal",'','level',"SE",'%1') /
  comp_emissions("Total",'','','level','SE','%1');
  
comp_emissions("FossilDecrease",f_fuel,'','share',"SE",'%1') $ comp_emissions("Total",'','','level','SE','%1')
    =comp_emissions("FossilDecrease",f_fuel,'','level',"SE",'%1')  /
  comp_emissions("Total",'','','level','SE','%1');
comp_emissions("FossilDecrease","fossilTotal",'','share',"SE",'%1') $ comp_emissions("Total",'','','level','SE','%1')
    =sum(f_fuel, comp_emissions("FossilDecrease",f_fuel,'','level',"SE",'%1'))  /
  comp_emissions("Total",'','','level','SE','%1');
  
* Average emissions per biofuel unit, drect emissions and net of replacment emissions reduction
comp_emissions("BiofuelEmis",b_fuel,'','average',"SE",'%1') $ comp('production', b_fuel,'total',"SE",'%1')= comp_emissions("BiofuelEmis",b_fuel,'','level',"SE",'%1') / comp('production', b_fuel,'total',"SE",'%1');
comp_emissions(GHGcat,b_fuel,'','average',"SE",'%1') $ comp('production', b_fuel,'total',"SE",'%1')= comp_emissions(GHGcat,b_fuel,'','level',"SE",'%1') / comp('production', b_fuel,'total',"SE",'%1');
comp_emissions("FossilSubs",b_fuel,'','average',"SE",'%1') $ comp('production', b_fuel,'total',"SE",'%1')=
    comp_emissions("FossilSubs",b_fuel,'','level',"SE",'%1')
        / comp('production', b_fuel,'total',"SE",'%1');

comp_emissions("NetBiofuelEmis",b_fuel,'','average',"SE",'%1') $ comp('production', b_fuel,'total',"SE",'%1')=
    comp_emissions("NetBiofuelEmis",b_fuel,'','level',"SE",'%1')
        / comp('production', b_fuel,'total',"SE",'%1');

alias (h,hh);
* Direct emissions from biofuel, per demand region          
comp_emissions("BiofuelEmisPerH",'ethanol','','',h,'%1') =  sum((i, tech) $  (p_y_sales("ethanol",tech,i,h) and sum(hh, p_y_sales("ethanol",tech,i,hh))),
            comp_emissions("BiofuelEmis",'ethanol','','',i,'%1') * ((p_y_sales("ethanol",tech,i,h)/ sum(hh, p_y_sales("ethanol",tech,i,hh))))
            );
            
comp_emissions("BiofuelEmisPerH",'','','',"SE",'%1') = sum(h, comp_emissions("BiofuelEmisPerH",'','','',h,'%1'));  

* --- Change in level of fuel use and blend fuel levels
* with "fuel" defined as biofuels, the sum is the amount ethnaol
use_blend_cap(blend_fuel,h,"%biofuel",'%1') $ (f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h))
= sum(b_fuel $ fuel_blend(blend_fuel, b_fuel), energy_ekv( b_fuel) * p_tot_demand( b_fuel, h)) /
 (f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h));
 
use_blend_cap(blend_fuel,"SE","%biofuel",'%1')$sum(h,f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h))
 = sum((b_fuel,h) $ fuel_blend(blend_fuel, b_fuel), energy_ekv(b_fuel) * p_tot_demand(b_fuel, h)) /
   sum(h,f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h));

use_blend_cap(blend_fuel,h,"cap hit",'%1') = 0.000001;
use_blend_cap(blend_fuel,h,"cap hit",'%1')$ (use_blend_cap(blend_fuel,h,"%biofuel",'%1') ge blend_cap(blend_fuel,h))= 1;
use_blend_cap(blend_fuel,"SE","cap hit",'%1')$ (use_blend_cap(blend_fuel,"SE","%biofuel",'%1') ge smax(h,blend_cap(blend_fuel,h)))= 1;

use_blend_cap(blend_fuel,h,"TotalAmountInitial",'%1') = f_fuel_0(blend_fuel,h);
use_blend_cap(blend_fuel,"SE","TotalAmountInitial",'%1') = sum(h, use_blend_cap(blend_fuel,h,"TotalAmountInitial",'%1'));

use_blend_cap(blend_fuel,h,"TotalAmountBlend",'%1') = f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h);
use_blend_cap(blend_fuel,"SE","TotalAmountBlend",'%1') = sum(h, f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h));

use_blend_cap(blend_fuel,h,"TotalAmountFossil",'%1') = sum(f_fuel $ fuel_blend(blend_fuel,f_fuel), f_fuel_0(blend_fuel,h) + energy_ekv(f_fuel) * p_tot_demand(f_fuel, h));
use_blend_cap(blend_fuel,"SE","TotalAmountFossil",'%1') = sum(h, use_blend_cap(blend_fuel,h,"TotalAmountFossil",'%1'));


* MAC, shadow value of emissions target

p_MAC("emisTarget","%1") = p_emisTargetM;

* add scenaroi name
scen_name('%1') = %2;

* --- Solution report information
p_solveInfo_comp("solveStat",'%1') =p_solveInfo("solveStat");
p_solveInfo_comp("modelStat",'%1') =p_solveInfo("modelStat");
p_solveInfo_comp("resUsd",'%1') = p_solveInfo("resUsd");


$ontext
*=== Now write to variable levels to Excel file from GDX
*=== Write production levels
execute 'gdxxrw.exe results_%2.gdx o=supply_%1.xls var=v_y.l'

*=== Write supply
execute 'gdxxrw.exe results_%2.gdx o=supply_%1.xls par=feedstock_use_percent_supply rng=supply'

* Write borders info
execute 'gdxxrw.exe results_%2.gdx o=supply_%1.xls var=v_feedstock.l rng=border!'
$offtext



option kill = p_J;
option kill = highest_cost;
option kill = p_y;
option kill = p_feedstock;
option kill = p_yEnergy;
option kill = cost_share;
option kill = tot_cost;
option kill = obj;
option kill = p_solveInfo;
option kill = feedstock_use_percent;
option kill = tot_feedstockSE;
option kill = p_totEmissions;
option kill = p_fossil_emissions;
option kill = p_biofuelEmis;
option kill = p_redY_cost;
option kill = p_tot_demand;
option kill = p_emisTargetM;
