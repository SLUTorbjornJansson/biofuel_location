* ------------------------------------
* Start values, 1 for each variables
* ------------------------------------

J.l(b_fuel,tech,i)=1;
v_feedstock.l(f,b_fuel,tech,i,g) = 1 ;
v_production_cost.l(b_fuel, tech,i)=1;
v_feedstock_cost.l(b_fuel,tech,i)=1;
v_transport_cost.l(b_fuel,tech,i)=1;
v_tot_feedstock.l(f,b_fuel,tech,i)=1;
v_fueltransport_cost.l(b_fuel,tech,i)=1;
v_y_sales.l(b_fuel,tech,i,h)=1;
v_y.l(b_fuel,tech,i)=1;
v_tot_demand.l(b_fuel,h)=1;

v_biofuelEmis_atI.l(i)=1;
v_totEmissions.l=1;

v_tot_cost.l =1;

v_yEnergy.l(blend_fuel,h) =1;
*v_blend_rate.l(blend_fuel,h)=1;

