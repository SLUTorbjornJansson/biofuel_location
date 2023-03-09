*** Add missing data

*** Normalization of CAPRI data to BM


v_yield2('ave','normalization') = (sum(g $ land_area(g,"total",'BM') , v_yield2(g,'BM')*land_area(g,"total",'BM') ) / sum(g, land_area(g,"total",'BM') ))
           / (sum(NUTS2Regions $ land_area(NUTS2Regions,"total",'CAPRI'), v_yield2(NUTS2Regions,'CAPRI') * land_area(NUTS2Regions,"total",'CAPRI')) / sum(NUTS2Regions, land_area(NUTS2Regions,"total",'CAPRI')));
           
v_agri_dens('ave','normalization') = (sum(g, land_area(g,"arable",'BM') )/ sum(g, land_area(g, "total",'BM')))
               / (sum(NUTS2Regions, land_area(NUTS2Regions,"arable",'CAPRI'))/ sum(NUTS2Regions, land_area(NUTS2Regions,"total",'CAPRI')));
               
v_ley_dens('ave','normalization')  = (sum(g, land_area(g,"ley",'BM'))  / sum(g, land_area(g,"total",'BM')))
               / (sum((grassareas, g),  land_area(g,"ley",'CAPRI'))  / sum(g, land_area(g,"total",'CAPRI')));

v_ley_elas('ave','normalization') = (sum(g $ land_area(g,"total",'BM') , v_ley_elas(g,'BM')*land_area(g,"total",'BM') ) / sum(g, land_area(g,"total",'BM') ))
           / (sum(NUTS2Regions $ land_area(NUTS2Regions,"total",'CAPRI'), v_ley_elas(NUTS2Regions,'CAPRI') * land_area(NUTS2Regions,"total",'CAPRI')) / sum(NUTS2Regions, land_area(NUTS2Regions,"total",'CAPRI')));

v_GHG_intensity('ave','normalization') = (sum(g $ land_area(g,"total",'BM') , v_GHG_intensity(g,'BM')*land_area(g,"total",'BM') ) / sum(g, land_area(g,"total",'BM') ))
           / (sum(g $ land_area(g,"total",'CAPRI'), v_GHG_intensity(g,'CAPRI') * land_area(g,"total",'CAPRI')) / sum(g, land_area(g,"total",'CAPRI')));

v_feedstock_cost2('ave','normalization') = (sum(g $ land_area(g,"total",'BM') , v_feedstock_cost2(g,'BM')*land_area(g,"total",'BM') ) / sum(g, land_area(g,"total",'BM') ))
           / (sum(g $ land_area(g,"total",'CAPRI'), v_feedstock_cost2(g,'CAPRI') * land_area(g,"total",'CAPRI')) / sum(g, land_area(g,"total",'CAPRI')));
*

v_yield2('ave','CAPRI_norm')        =v_yield2('ave','normalization')         *v_yield2('ave','CAPRI')        ;
                                                                                                            
v_agri_dens('ave','CAPRI_norm')     =v_agri_dens('ave','normalization')      *v_agri_dens('ave','CAPRI')     ;
                                                                                                       
v_ley_dens('ave','CAPRI_norm')      =v_ley_dens('ave','normalization')       *v_ley_dens('ave','CAPRI')      ;
                                                                                                                                             
v_ley_elas('ave','CAPRI_norm')      =v_ley_elas('ave','normalization')       *v_ley_elas('ave','CAPRI')      ;                                     ;
                                                                                                          
v_GHG_intensity('ave','CAPRI_norm') =v_GHG_intensity('ave','normalization')  *v_GHG_intensity('ave','CAPRI') ;
                                                                                                              
v_feedstock_cost2('ave','CAPRI_norm')=v_feedstock_cost2('ave','normalization') *v_feedstock_cost2('ave','CAPRI');
                                                                                                                  
                                                                             
