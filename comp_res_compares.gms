* scenario number and result file name
*$if exist 'results\results_%file1%.gdx'
$batinclude load_scen_res.gms 1 %file1%
$if exist '%path%%file2%.gdx' $batinclude load_scen_res.gms 2 %file2%
$if exist '%path%%file3%.gdx' $batinclude load_scen_res.gms 3 %file3%
$if exist '%path%%file4%.gdx' $batinclude load_scen_res.gms 4 %file4%
$if exist '%path%%file5%.gdx' $batinclude load_scen_res.gms 5 %file5%
$if exist '%path%%file6%.gdx' $batinclude load_scen_res.gms 6 %file6%
$if exist '%path%%file7%.gdx' $batinclude load_scen_res.gms 7 %file7%
$if exist '%path%%file8%.gdx '$batinclude load_scen_res.gms 8 %file8%
$if exist '%path%%file9%.gdx '$batinclude load_scen_res.gms 9 %file9%
$if exist '%path%%file10%.gdx' $batinclude load_scen_res.gms 10 %file10%
$if exist '%path%%file11%.gdx' $batinclude load_scen_res.gms 11 %file11%


*$ontext

parameter prod_comp(*, b_fuel,*,*,scen);

prod_comp('deltaProduction', b_fuel,"","SE",'2') $[comp('production', b_fuel,'total',"SE",'1') and comp('production', b_fuel,'total',"SE",'2')]
  =  comp('production', b_fuel,'total',"SE",'2') - comp('production', b_fuel,'total',"SE",'1');

prod_comp('deltaProduction', b_fuel,"","SE",'3') $[comp('production', b_fuel,'total',"SE",'2') and comp('production', b_fuel,'total',"SE",'2')]
  =  comp('production', b_fuel,'total',"SE",'3') - comp('production', b_fuel,'total',"SE",'2');

prod_comp('deltaProduction', b_fuel,"","SE",'4') $[comp('production', b_fuel,'total',"SE",'3') and comp('production', b_fuel,'total',"SE",'4')]
  =  comp('production', b_fuel,'total',"SE",'4') - comp('production', b_fuel,'total',"SE",'3');

prod_comp('deltaProduction', b_fuel,"","SE",'5') $[comp('production', b_fuel,'total',"SE",'4') and comp('production', b_fuel,'total',"SE",'5')]
  =  comp('production', b_fuel,'total',"SE",'5') - comp('production', b_fuel,'total',"SE",'4');

prod_comp('deltaProduction', b_fuel,"","SE",'6') $[comp('production', b_fuel,'total',"SE",'5') and comp('production', b_fuel,'total',"SE",'6')]
  =  comp('production', b_fuel,'total',"SE",'6') - comp('production', b_fuel,'total',"SE",'5');

prod_comp('deltaProduction', b_fuel,"","SE",'7') $[comp('production', b_fuel,'total',"SE",'6') and comp('production', b_fuel,'total',"SE",'7')]
  =  comp('production', b_fuel,'total',"SE",'7') - comp('production', b_fuel,'total',"SE",'6');

prod_comp('deltaProduction', b_fuel,"","SE",'8') $[comp('production', b_fuel,'total',"SE",'7') and comp('production', b_fuel,'total',"SE",'8')]
  =  comp('production', b_fuel,'total',"SE",'8') - comp('production', b_fuel,'total',"SE",'7');

prod_comp('deltaProduction', b_fuel,"","SE",'9') $[comp('production', b_fuel,'total',"SE",'8') and comp('production', b_fuel,'total',"SE",'9')]
  =  comp('production', b_fuel,'total',"SE",'9') - comp('production', b_fuel,'total',"SE",'8');

prod_comp('deltaProduction', b_fuel,"","SE",'10') $[comp('production', b_fuel,'total',"SE",'9') and comp('production', b_fuel,'total',"SE",'10')]
  =  comp('production', b_fuel,'total',"SE",'10') - comp('production', b_fuel,'total',"SE",'9');
  
prod_comp('deltaProduction', b_fuel,"","SE",'11') $[comp('production', b_fuel,'total',"SE",'10') and comp('production', b_fuel,'total',"SE",'11')]
  =  comp('production', b_fuel,'total',"SE",'11') - comp('production', b_fuel,'total',"SE",'10');

*$onorder
*obj_comp("2",'change') $ obj_comp("1",'level')= obj_comp("2",'level')/obj_comp("1",'level');
obj_comp("3",'change') $ obj_comp("1",'level')= obj_comp("3",'level')/obj_comp("1",'level');
obj_comp("4",'change') $ obj_comp("3",'level')= obj_comp("4",'level')/obj_comp("3",'level');
obj_comp("5",'change') $ obj_comp("4",'level')= obj_comp("5",'level')/obj_comp("4",'level');
obj_comp("6",'change') $ obj_comp("5",'level')= obj_comp("6",'level')/obj_comp("5",'level');
obj_comp("7",'change') $ obj_comp("6",'level')= obj_comp("7",'level')/obj_comp("6",'level');
obj_comp("8",'change') $ obj_comp("7",'level')= obj_comp("8",'level')/obj_comp("7",'level');
obj_comp("9",'change') $ obj_comp("8",'level')= obj_comp("9",'level')/obj_comp("8",'level');
obj_comp("10",'change') $ obj_comp("9",'level')= obj_comp("10",'level')/obj_comp("9",'level');
obj_comp("11",'change') $ obj_comp("10",'level')= obj_comp("11",'level')/obj_comp("10",'level');



* Marginal cost : as the percentage change from increasing target level by 1 percentage point
*obj_comp(scen,'change_percent') $ obj_comp(scen-1,'level')
*    = (obj_comp(scen,'level') / obj_comp(scen-1,'level'));

*$ontext-1
obj_comp("2",'deltachange')$ obj_comp("1",'level')
    = (obj_comp("2",'level')-obj_comp("1",'level'));
obj_comp("3",'deltachange')$ obj_comp("2",'level')
    = (obj_comp("3",'level')-obj_comp("2",'level')) ;
obj_comp("4",'deltachange')$ obj_comp("3",'level')
    = (obj_comp("4",'level')-obj_comp("3",'level')) ;
obj_comp("5",'deltachange')$ obj_comp("4",'level')
    = (obj_comp("5",'level')-obj_comp("4",'level')) ;
obj_comp("6",'deltachange')$ obj_comp("5",'level')
    = (obj_comp("6",'level')-obj_comp("5",'level')) ;
obj_comp("7",'deltachange')$ obj_comp("6",'level')
    = (obj_comp("7",'level')-obj_comp("6",'level')) ;
obj_comp("8",'deltachange')$ obj_comp("7",'level')
    = (obj_comp("8",'level')-obj_comp("7",'level'));
obj_comp("9",'deltachange')$ obj_comp("8",'level')
    = (obj_comp("9",'level')-obj_comp("8",'level')) ;
obj_comp("10",'deltachange')$ obj_comp("9",'level')
    = (obj_comp("10",'level')-obj_comp("9",'level')) ;

obj_comp(scen,'deltachangeProd') $sum(b_fuel,prod_comp('deltaProduction', b_fuel,"","SE",scen))
  = obj_comp(scen,'deltachange')/ sum(b_fuel,prod_comp('deltaProduction', b_fuel,"","SE",scen)) ;


* tot cost change per item for each facility
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"2")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"1")
    =[ tot_cost_comp(b_fuel,tech,i,cost_items,'level',"2") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"1")] ;
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"3")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"2")
    = [tot_cost_comp(b_fuel,tech,i,cost_items,'level',"3") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"2")] ;
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"4")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"3")
    = [tot_cost_comp(b_fuel,tech,i,cost_items,'level',"4") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"3")] ;
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"5")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"4")
    = [tot_cost_comp(b_fuel,tech,i,cost_items,'level',"5") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"4")];
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"6")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"5")
    = [tot_cost_comp(b_fuel,tech,i,cost_items,'level',"6") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"5")] ;
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"7")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"6")
    = [tot_cost_comp(b_fuel,tech,i,cost_items,'level',"7") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"6")];
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"8")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"7")
    = [tot_cost_comp(b_fuel,tech,i,cost_items,'level',"8") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"7")] ;
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"9")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"8")
    = [tot_cost_comp(b_fuel,tech,i,cost_items,'level',"9") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"8")] ;
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"10")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"9")
    = [tot_cost_comp(b_fuel,tech,i,cost_items,'level',"10") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"9")];
tot_cost_comp(b_fuel,tech,i,cost_items,'deltachange',"11")$tot_cost_comp(b_fuel,tech,i,cost_items,'level',"10")
    = [tot_cost_comp(b_fuel,tech,i,cost_items,'level',"11") - tot_cost_comp(b_fuel,tech,i,cost_items,'level',"10")];


* For sweden total
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"2")$tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"1")
    =[ tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"2") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"1")] ;
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"3")$tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"2")
    = [tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"3") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"2")] ;
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"4")$tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"3")
    = [tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"4") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"3")] ;
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"5")$tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"4")
    = [tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"5") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"4")] ;
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"6")$tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"5")
    = [tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"6") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"5")] ;
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"7")$tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"6")
    = [tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"7") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"6")] ;
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"8")$tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"7")
    = [tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"8") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"7")] ;
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"9")$tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"8")
    = [tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"9") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"8")] ;
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"10")$tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"9")
    = [tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"10") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"9")];
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',"11")$ (tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"10") and tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"11"))
    = [tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"11") - tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'level',"10")];
    
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"2")$tot_cost_comp('',  "highLow", "SE",cost_items,'level',"1")
    =[ tot_cost_comp('',  "highLow", "SE",cost_items,'level',"2") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"1")] ;
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"3")$tot_cost_comp('',  "highLow", "SE",cost_items,'level',"2")
    = [tot_cost_comp('',  "highLow", "SE",cost_items,'level',"3") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"2")] ;
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"4")$tot_cost_comp('',  "highLow", "SE",cost_items,'level',"3")
    = [tot_cost_comp('',  "highLow", "SE",cost_items,'level',"4") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"3")] ;
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"5")$tot_cost_comp('',  "highLow", "SE",cost_items,'level',"4")
    = [tot_cost_comp('',  "highLow", "SE",cost_items,'level',"5") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"4")] ;
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"6")$tot_cost_comp('',  "highLow", "SE",cost_items,'level',"5")
    = [tot_cost_comp('',  "highLow", "SE",cost_items,'level',"6") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"5")] ;
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"7")$tot_cost_comp('',  "highLow", "SE",cost_items,'level',"6")
    = [tot_cost_comp('',  "highLow", "SE",cost_items,'level',"7") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"6")] ;
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"8")$tot_cost_comp('',  "highLow", "SE",cost_items,'level',"7")
    = [tot_cost_comp('',  "highLow", "SE",cost_items,'level',"8") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"7")] ;
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"9")$tot_cost_comp('',  "highLow", "SE",cost_items,'level',"8")
    = [tot_cost_comp('',  "highLow", "SE",cost_items,'level',"9") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"8")] ;
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"10")$tot_cost_comp('',  "highLow", "SE",cost_items,'level',"9")
    = [tot_cost_comp('',  "highLow", "SE",cost_items,'level',"10") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"9")];
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',"11")$ (tot_cost_comp('',  "highLow", "SE",cost_items,'level',"10") and tot_cost_comp('',  "highLow", "SE",cost_items,'level',"11"))
    = [tot_cost_comp('',  "highLow", "SE",cost_items,'level',"11") - tot_cost_comp('',  "highLow", "SE",cost_items,'level',"10")];


* COST CHANGE PER PRODUCTION UNIT
tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachangeProd',scen) $ prod_comp('deltaProduction', b_fuel,"","SE",scen)
  = tot_cost_comp(b_fuel,  "highLow", "SE",cost_items,'deltachange',scen) / prod_comp('deltaProduction', b_fuel,"","SE",scen);
tot_cost_comp('',  "highLow", "SE",cost_items,'deltachangeProd',scen) $ sum(b_fuel,prod_comp('deltaProduction',b_fuel,"","SE",scen))
  = tot_cost_comp('',  "highLow", "SE",cost_items,'deltachange',scen) / sum(b_fuel, prod_comp('deltaProduction',b_fuel,"","SE",scen));


* Emission change
parameter tot_emis_comp(*, *,*,*,scen) 'Emission difference between two scenarios';

tot_emis_comp('', "SE","Total",'deltachange',"2")$ [comp_emissions("Total",'','','','SE',"2") and comp_emissions("Total",'','','','SE','1')]
    = comp_emissions("Total",'','','','SE',"2") - comp_emissions("Total",'','','','SE','1') ;

tot_emis_comp('', "SE","Total",'deltachange',"3") $ [comp_emissions("Total",'','','','SE',"3") and comp_emissions("Total",'','','','SE','2')]
    = comp_emissions("Total",'','','','SE',"3") - comp_emissions("Total",'','','','SE','2') ;

tot_emis_comp('', "SE","Total",'deltachange',"4")$ [comp_emissions("Total",'','','','SE',"4") and comp_emissions("Total",'','','','SE','3')]
    = comp_emissions("Total",'','','','SE',"4") - comp_emissions("Total",'','','','SE','3') ;

tot_emis_comp('', "SE","Total",'deltachange',"5")$ [comp_emissions("Total",'','','','SE',"5") and comp_emissions("Total",'','','','SE','4')]
    = comp_emissions("Total",'','','','SE',"5") - comp_emissions("Total",'','','','SE','4') ;

tot_emis_comp('', "SE","Total",'deltachange',"6")$ [comp_emissions("Total",'','','','SE',"6") and comp_emissions("Total",'','','','SE','5')]
    = comp_emissions("Total",'','','','SE',"6") - comp_emissions("Total",'','','','SE','5') ;

tot_emis_comp('', "SE","Total",'deltachange',"7")$ [comp_emissions("Total",'','','','SE',"7") and comp_emissions("Total",'','','','SE','6')]
    = comp_emissions("Total",'','','','SE',"7") - comp_emissions("Total",'','','','SE','6') ;

tot_emis_comp('', "SE","Total",'deltachange',"8")$ [comp_emissions("Total",'','','','SE',"8") and comp_emissions("Total",'','','','SE','7')]
    = comp_emissions("Total",'','','','SE',"8") - comp_emissions("Total",'','','','SE','7') ;

tot_emis_comp('', "SE","Total",'deltachange',"9")$ [comp_emissions("Total",'','','','SE',"9") and comp_emissions("Total",'','','','SE','8')]
    = comp_emissions("Total",'','','','SE',"9") - comp_emissions("Total",'','','','SE','8') ;

tot_emis_comp('', "SE","Total",'deltachange',"10")$ [comp_emissions("Total",'','','','SE',"10") and comp_emissions("Total",'','','','SE','9')]
    = comp_emissions("Total",'','','','SE',"10") - comp_emissions("Total",'','','','SE','9') ;
    
tot_emis_comp('', "SE","Total",'deltachange',"11")$ [comp_emissions("Total",'','','','SE',"11") and comp_emissions("Total",'','','','SE','10')]
    = comp_emissions("Total",'','','','SE',"11") - comp_emissions("Total",'','','','SE','10') ;


* per production unit
tot_emis_comp('', "SE","Total",'deltachangeEthProd',scen)$ sum(b_fuel, prod_comp('deltaProduction',b_fuel,"","SE",scen))
  = tot_emis_comp('', "SE","Total",'deltachange',scen) / sum(b_fuel,prod_comp('deltaProduction',b_fuel,"","SE",scen));

* MAC
tot_emis_comp("", "SE","Total",'MAC',scen) $ tot_emis_comp('', "SE","Total",'deltachange',scen)
  = sum(b_fuel, tot_cost_comp('',  "highLow", "SE","Net cost",'deltachange',scen)) /  tot_emis_comp('', "SE","Total",'deltachange',scen);
