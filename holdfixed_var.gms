* ------------------------------------
* Defining variables that should be holdfixed to zero, i.e no possible values for these as excluded from model
* to reduce computing time
* ------------------------------------


loop(notusedF,
  if (sum(g, feedstock(notusedF,g)) = 0,

    v_feedstock.fx(notusedF,fuel,tech,i,g) = 0 ;
    v_tot_feedstock.fx(notusedF,fuel,tech,i)=0;
    v_EFeedstock.fx(notusedF,fuel,tech,i,g)=0;
    v_ETransport.fx(notusedF,fuel,tech,i,g)=0;
    v_ELUC.fx(notusedF,fuel,tech,i,g)=0;
  )
);


loop(notusedFuel,
  if (sum(h, max_demand(notusedFuel, h)) = 0,

    J.fx(notusedFuel,tech,i)=0;
    v_feedstock.fx(f,notusedFuel,tech,i,g) = 0 ;
    v_production_cost.fx(notusedFuel, tech,i)=0;
    v_feedstock_cost.fx(notusedFuel,tech,i)=0;
    v_transport_cost.fx(notusedFuel,tech,i)=0;
    v_tot_feedstock.fx(f,notusedFuel,tech,i)=0;
    v_fueltransport_cost.fx(notusedFuel,tech,i) $  p_useDemand=0;
    v_y_sales.fx(notusedFuel,tech,i,h) $ p_useDemand =0;
    v_y.fx(notusedFuel,tech,i)=0;
    v_tot_demand.fx(notusedFuel,h) $ p_useDemand=0;

    v_EFeedstock.fx(f,notusedFuel,tech,i,g)=0;
    v_EProduction.fx(notusedFuel,tech,i)=0;
    v_EInvestment.fx(notusedFuel,tech,i)=0;
    v_ETransport.fx(f,notusedFuel,tech,i,g)=0;
    v_EDistribution.fx(notusedFuel,tech,i,h) $ p_useDemand=0;
    v_ELUC.fx(f,notusedFuel,tech,i,g)=0;
    v_EFossilSubs.fx(notusedFuel,tech,i,h)=0;
  )
);
