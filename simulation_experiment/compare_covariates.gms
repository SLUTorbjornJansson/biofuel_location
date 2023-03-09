***********************************************************************************
*** Compare covariates
***********************************************************************************



* calculate difference and absolute difference between biofeul model regions and CAPRI regions
diff_v_yield2(g,NUTS2Regions, 'diff') = v_yield2(g,'BM')-v_yield2(NUTS2Regions,'CAPRI_norm');                         
diff_v_agri_dens(g,NUTS2Regions, 'diff')= v_agri_dens(g,'BM')-v_agri_dens(NUTS2Regions,'CAPRI_norm');                     
diff_v_ley_dens(g,NUTS2Regions, 'diff') = v_ley_dens(g,'BM')-v_ley_dens(NUTS2Regions,'CAPRI_norm');                      
diff_v_ley_elas(g,NUTS2Regions, 'diff') = v_ley_elas(g,'BM')-v_ley_elas(NUTS2Regions,'CAPRI_norm');                      
diff_v_GHG_intensity(g,NUTS2Regions, 'diff') = v_GHG_intensity(g,'BM')-v_GHG_intensity(NUTS2Regions,'CAPRI_norm');                 
diff_v_feedstock_cost2(g,NUTS2Regions, 'diff') = v_feedstock_cost2(g,'BM')-v_feedstock_cost2(NUTS2Regions,'CAPRI_norm');

diff_v_yield2(g,NUTS2Regions, 'abs diff') =          ABS(diff_v_yield2(g,NUTS2Regions, 'diff')         );
diff_v_agri_dens(g,NUTS2Regions, 'abs diff')=       ABS(diff_v_agri_dens(g,NUTS2Regions, 'diff')     );
diff_v_ley_dens(g,NUTS2Regions, 'abs diff') =       ABS(diff_v_ley_dens(g,NUTS2Regions, 'diff')      );
diff_v_ley_elas(g,NUTS2Regions, 'abs diff') =       ABS(diff_v_ley_elas(g,NUTS2Regions, 'diff')      );
diff_v_GHG_intensity(g,NUTS2Regions, 'abs diff') =  ABS(diff_v_GHG_intensity(g,NUTS2Regions, 'diff') );           
diff_v_feedstock_cost2(g,NUTS2Regions, 'abs diff') = ABS(diff_v_feedstock_cost2(g,NUTS2Regions, 'diff'));



