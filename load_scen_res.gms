*--- Load results from scenario


*$gdxin 'results_%2.gdx'
*$load J=J.l, highest_cost, y= v_y.l, cost_share, obj = v_tot_cost.l
*$gdxin
parameter p_J(*,*,*);
parameter p_y(*,*,*);
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
p_tot_demand = v_tot_demand.l, p_y_sales= v_y_sales.l, p_yEnergy=v_yEnergy.l, p_endY=v_endY.l,
p_fossil_emissions=v_fossil_emissions.l , 
rep_feedstock2, tot_FeedstockSE,feedstock_use_percent, p_solveInfo
p_emisTargetM= eq_emisTarget.m
;
acronym %2;
display cost_share, obj;
* --- only show results for ethanol
*v_feedstock(f, b_fuel, tech, i,g)=v_feedstock(f, "ethanol", tech, i,g);

J_comp(b_fuel, tech, i, "%1") = p_J(b_fuel, tech, i);
J_comp(b_fuel, tech, lan, "%1") = sum(i$lan_to_kn(lan,i), p_J(b_fuel, tech, i)$ p_J(b_fuel, tech, i));

highest_cost_comp(f, b_fuel, tech, i,cost_items,"%1")$ p_J(b_fuel, tech, i) = highest_cost(f, b_fuel, tech, i,cost_items) ;

y_comp(b_fuel, tech, i,"%1")$ p_J(b_fuel, tech, i)= p_y(b_fuel, tech, i);

cost_share_comp(b_fuel, tech, i,cost_items,"level","%1")$ p_J(b_fuel, tech, i) = cost_share(b_fuel, tech, i,cost_items);

tot_cost_comp(b_fuel, tech, i,cost_items,"level","%1")$ p_J(b_fuel, tech, i) = tot_cost(b_fuel, tech, i,cost_items);
tot_cost_comp('', "highLow", h,"Fuel change total","level","%1") = p_redY_cost(h);
tot_cost_comp('', "highLow", "SE","Fuel change total","level","%1") = sum(h, p_redY_cost(h));


cost_share_comp(b_fuel, "highLow", "SE",cost_items,"level","%1") = cost_share(b_fuel,"highLow", "SE",cost_items);

tot_cost_comp(b_fuel, "highLow", "SE",cost_items,"level","%1") = tot_cost(b_fuel,"highLow", "SE",cost_items);
tot_cost_comp("", "highLow", h,"Biofuel substitution","level","%1") =
- sum(b_fuel, sum(blend_fuel $ fuel_blend(blend_fuel,b_fuel), p_0(blend_fuel)) * energy_ekv(b_fuel) * p_tot_demand(b_fuel, h));



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

tot_cost_comp("", "highLow", "SE","Consumer loss","level","%1") = sum(h, tot_cost_comp("", "highLow", h,"Consumer loss","level","%1"));
tot_cost_comp("", "highLow", "SE","Biofuel substitution","level","%1") = sum(h, tot_cost_comp("", "highLow", h,"Biofuel substitution","level","%1") );

tot_cost_comp('', "highLow", "SE","Net cost","level","%1")
 = sum(b_fuel, tot_cost_comp(b_fuel, "highLow", "SE","total","level","%1")) + tot_cost_comp('', "highLow", "SE","Fuel change total","level","%1") ;
 
rep_feedstock2_comp(f,b_fuel,tech,i,g,'distance','%1') $ p_J(b_fuel, tech, i) = rep_feedstock2(f, b_fuel,tech,i,g,'distance');
rep_feedstock2_comp(f, b_fuel,tech,i,g,'supply','%1') $ p_J(b_fuel, tech, i) = rep_feedstock2(f, b_fuel,tech,i,g,'supply');
display tot_cost_comp;
obj_comp('%1','level') = obj;

acronym supply;
* Find the three largest low and high tech locations

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

comp('facilites', b_fuel,tech,'','%1')$ sum(i,p_J( b_fuel, tech, i)) = sum(i, p_J(b_fuel, tech, i));
comp('allfacilites', b_fuel,'','','%1') = sum(tech, comp('facilites', b_fuel,tech,'','%1'));
comp('controlgraphfacilites', b_fuel,'','','%1') = sum(graphtechs$ (comp('production', b_fuel,graphtechs,'','%1')>1), 1);
comp('aveProd', b_fuel,tech,'','%1')$ sum(i, p_J(b_fuel, tech, i) )= sum(i, p_y(b_fuel, tech, i)) / sum(i$p_y(b_fuel, tech, i),1);
comp('maxDist', b_fuel,tech,i,'%1')$ p_J(b_fuel, tech, i) = smax((g,f), rep_feedstock2(f, b_fuel,tech,i,g,'distance'));
comp('aveDist', b_fuel,tech,i,'%1')$ p_J(b_fuel, tech, i) = sum((f,g),rep_feedstock2(f, b_fuel,tech,i,g,'supply')
                                                                * rep_feedstock2(f, b_fuel,tech,i,g,'distance'))
                                                             /sum((f,g),rep_feedstock2(f, b_fuel,tech,i,g,'supply'));
comp('aveDist', b_fuel,"","total",'%1')$ sum((i,tech),p_J(b_fuel, tech, i)) =  sum((f,tech,g,i),rep_feedstock2(f, b_fuel,tech,i,g,'supply')
                                                                                  * rep_feedstock2(f, b_fuel,tech,i,g,'distance'))
                                                                                /sum((f,tech,g,i),rep_feedstock2(f, b_fuel,tech,i,g,'supply'));
comp('objective',"","total",'','%1') = obj;

comp('production', b_fuel,tech,i,'%1')$ p_y(b_fuel, tech, i)= p_y(b_fuel, tech, i);
comp('production', b_fuel,'total',"SE",'%1')=sum((tech,i), comp('production', b_fuel,tech,i,'%1'));

comp("fuel use Energy",fuels,"",h,'%1')=   energy_ekv(fuels) * p_tot_demand(fuels, h);
comp("fuel use Energy",fuels,"","SE",'%1')= sum(h, comp("fuel use Energy",fuels,"",h,'%1'));

feedstock_use_comp('TotFeedstock',f,'%1')= tot_feedstockSE(f);
feedstock_use_comp('TotFeedstockPercent',f,'%1')= feedstock_use_percent(f);

comp_emissions("Total",'','','','SE','%1') =p_totEmissions;
comp_emissions(GHGcat,'','','',i,'%1') =

                    sum((f,b_fuel,tech,g),p_biofuelEmis(f,GHGcat,b_fuel,tech,i,g)) $ [sameas(GHGcat,"feedstock") or sameas(GHGcat,"transport")]
                  + sum((ab,b_fuel,tech,g), p_biofuelEmis(ab,GHGcat,b_fuel,tech, i,g)) $ [sameas(GHGcat,"LUC")]
                  + sum((b_fuel,tech), p_biofuelEmis("all",GHGcat,b_fuel,tech,i,"all"))  $ [sameas(GHGcat,"production") or sameas(GHGcat,"investment")]
                  + sum((b_fuel,tech,h), p_biofuelEmis("all",GHGcat,b_fuel,tech,i,h))  $ [sameas(GHGcat,"distribution")]
                  + sum((b_fuel, tech,h), p_biofuelEmis("all",GHGcat,b_fuel,tech,i,h))$ [sameas(GHGcat,"gasolineSubs") or sameas(GHGcat,"dieselSubs")]
                                          ;

comp_emissions(GHGcat,'','','',"SE",'%1') = sum(i, comp_emissions(GHGcat,'','','',i,'%1'));

comp_emissions(f_fuel,'','','',h,'%1') = p_fossil_emissions(f_fuel,h);
comp_emissions(f_fuel,'','','',"SE",'%1')  = sum(h, comp_emissions(f_fuel,'','','',h,'%1'));

comp_emissions("FossilSubs","ethanol",'','',h,'%1') = sum((tech,i), p_y_sales("ethanol",tech,i,h)) * ghg_factor("all", "gasolineSubs","all");


comp_emissions("FossilSubs",b_fuel,'','',"SE",'%1')  = sum(h, comp_emissions("FossilSubs","ethanol",'','',h,'%1')) ;
comp_emissions("FossilDecrease",f_fuel,'','',h,'%1') = comp_emissions(f_fuel,'','','',h,'%1')
                                - comp_emissions("FossilSubs","ethanol",'','',h,'%1') $ sameas(f_fuel,"gas")
*                                - comp_emissions("FossilSubs","...",'','',h,'%1') $ sameas(f_fuel,"diesel")                             
;

comp_emissions("FossilDecrease",f_fuel,'','',"SE",'%1') = sum(h, comp_emissions("FossilDecrease",f_fuel,'','',h,'%1'));

comp_emissions("EthEmis",'','','',i,'%1')= sum(GHGcat $ [not (sameas(GHGcat,"gasolineSubs") or sameas(GHGcat,"dieselSubs"))],
                                                    comp_emissions(GHGcat,'','','',i,'%1'));
                                                    
comp_emissions("EthEmis",'','','',"SE",'%1') = sum(i, comp_emissions("EthEmis",'','','',i,'%1'));

alias (h,hh);              
comp_emissions("EthEmisPerH",'','','',h,'%1') =  sum((i, tech) $  (p_y_sales("ethanol",tech,i,h) and sum(hh, p_y_sales("ethanol",tech,i,hh))),
            comp_emissions("EthEmis",'','','',i,'%1') * ((p_y_sales("ethanol",tech,i,h)/ sum(hh, p_y_sales("ethanol",tech,i,hh))))
            );
            
comp_emissions("EthEmisPerH",'','','',"SE",'%1') = sum(h, comp_emissions("EthEmisPerH",'','','',h,'%1'));  

* fuel and fuel mix levels
* with "fuel" defined as biofuels, the sum is the amount ethnaol
use_blend_cap(blend_fuel,h,"%biofuel",'%1') $ (f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h))
= sum(b_fuel $ fuel_blend(blend_fuel, b_fuel), energy_ekv( b_fuel) * p_tot_demand( b_fuel, h)) /
 (f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h));
use_blend_cap(blend_fuel,"SE","%biofuel",'%1')$sum(h,f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h))
 = sum((b_fuel,h) $ fuel_blend(blend_fuel, b_fuel), energy_ekv(b_fuel) * p_tot_demand(b_fuel, h)) /
   sum(h,f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h));

use_blend_cap(blend_fuel,h,"cap hit",'%1')$ (use_blend_cap(blend_fuel,h,"%biofuel",'%1') ge blend_cap(blend_fuel,h))= yes;
use_blend_cap(blend_fuel,"SE","cap hit",'%1')$ (use_blend_cap(blend_fuel,"SE","%biofuel",'%1') ge smax(h,blend_cap(blend_fuel,h)))= yes;

use_blend_cap(blend_fuel,h,"TotalAmountInitial",'%1') = f_fuel_0(blend_fuel,h);
use_blend_cap(blend_fuel,"SE","TotalAmountInitial",'%1') = sum(h, use_blend_cap(blend_fuel,h,"TotalAmountInitial",'%1'));

use_blend_cap(blend_fuel,h,"TotalAmountBlend",'%1') = f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h);
use_blend_cap(blend_fuel,"SE","TotalAmountBlend",'%1') = sum(h, f_fuel_0(blend_fuel,h) +p_yEnergy(blend_fuel,h));

use_blend_cap(blend_fuel,h,"TotalAmountFossil",'%1') = sum(f_fuel $ fuel_blend(blend_fuel,f_fuel), f_fuel_0(blend_fuel,h) + energy_ekv(f_fuel) * p_tot_demand(f_fuel, h));
use_blend_cap(blend_fuel,"SE","TotalAmountFossil",'%1') = sum(h, use_blend_cap(blend_fuel,h,"TotalAmountFossil",'%1'));


* MAAC

p_MAC("emisTarget","%1") = p_emisTargetM;


scen_name('%1') = %2;
p_solveInfo_comp("solveStat",'%1') =p_solveInfo("solveStat");
p_solveInfo_comp("modelStat",'%1') =p_solveInfo("modelStat");
p_solveInfo_comp("resUsd",'%1') =p_solveInfo("resUsd");


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
