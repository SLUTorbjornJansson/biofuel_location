*** Read CAPRI data

v_yield2(g,'CAPRI') =1;
v_agri_dens(g,'CAPRI') =         1;
v_agri_dens('average','CAPRI') = 1;
                               
v_ley_dens(g,'CAPRI') =          1;
                              
v_ley_elas(g,'CAPRI') =          1;
                               
* use the feedstock em         1;
v_GHG_intensity(g,'CAPRI') =     1;
                             
v_feedstock_cost2(g,'CAPRI') =    1;
                      
* add border dummy    
v_borderDummy(g,'CAPRI')= 0;


land_area(g,"total",'CAPRI') = 1;
land_area(g,"arable",'CAPRI') = 1;
land_area(g,"ley",'CAPRI') = 1;











