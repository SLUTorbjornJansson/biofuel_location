* Choose files to make into r available data



* --- Read result file

$include declarations.gms
$include data/data_rev.gms
$include reporting_parameters.gms
parameter p_redY_cost(*);
parameter p_y(*,*,*);
parameter p_y_sales(b_fuel,tech,i,h);
parameter p_feedstock(b_fuel,tech,i,g,*) ;
parameter p_feedstockAB(b_fuel,tech,i,g,*) ;
parameter p_tot_demand(h,fuels);
parameter reduced_fossil_biofuel(h,b_fuel) 'reduced fossil costs due to ethanol production';


scalar p_eq_emisTarget;
parameter P_eq_fix(b_fuel,tech,i);
parameter P_eq_fix_y(b_fuel,tech,i);
parameter P_eq_fix_tot_feedstock(f,b_fuel,tech,g);
parameter P_eq_fix_tot_demand(fuels,h);
parameter P_eq_fix_lo(b_fuel,tech,i);
parameter P_eq_fix_y_lo(b_fuel,tech,i);
parameter P_eq_fix_tot_feedstock_lo(f,b_fuel,tech,g);
parameter P_eq_fix_tot_demand_lo(fuels,h);
parameter p_eq_feedstock(f,g);
parameter p_eq_capacity_up(b_fuel,tech,i);
parameter p_eq_capacity_lo(b_fuel,tech,i);
Parameter p_eq_blendCap(blend_fuel,h );
Parameter p_eq_production(b_fuel, tech,i);
parameter  p_eq_redY_max(end_fuel, h);

parameter p_fuel_change(h,*) 'change in fuel type';

* for column headers for redYcost
set a /kn/;
set b /cost/;
parameter kna(*,*);

parameter policy(*, *) 'Optimal policy levels -old version';
parameter policy_all(*, *, *,*,*,*) 'all policy for all tech etc';
parameter policy2(*, *);
parameter highestFeedstock(*, b_fuel, tech,*) 'Higest price level used in region ';
parameter longest_stream(*,tech,*,*) 'longest transport distance of fuel or feedstock';
parameter highestFuelCost(end_fuel,h);

display p_0;

*emission cap
*(1-0.28)= cap +(1-cap)* emisintensity(eth)/emisintensity(gas)
parameter quota_intesities;





*$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget40_LP_7feb
$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget20_LP_7feb
$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget30_LP_7feb
$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget40_LP_7feb
$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget50_LP_7feb
$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget60_LP_7feb
$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget70_LP_7feb
$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget80_LP_7feb
$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget90_LP_7feb
$batinclude 'res_to_R/R_excel.gms' data_rev_EndoON_distrON_gap005_target00_emistarget100_LP_7feb


