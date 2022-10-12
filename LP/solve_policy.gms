* --- Solve model --
*-------------------
*lim col=0
*limrow =0
m_locatepolicy.solprint=1;
*  eqation.m


Option MIP = osicplex;
* OSICPLEX, CBC or SOPLEX
m_locatepolicy.reslim = 30*60;

* set start time to calculate elapsed time
starttime = jnow;

* --- Solve settings

* --- Fix variables with known outcome to avoid varibales in equations

m_locatepolicy.holdfixed = 1;



*if ( %holdfixed_var% = 1,

*$include holdfixed_var.gms
*);


$ifi %distConstr%==1 p_distConstraint = 1;
v_feedstock.fx(f,b_fuel,tech,i,g) $ ((distance(i,g) > 1000) and p_distConstraint)= 0 ;


display  v_feedstock.l, v_feedstock.up;


m_locatepolicy.savepoint = 1;
m_locatepolicy.Reslim    =  %reslim% * 60;
m_locatepolicy.optcr= 0.%gap%;

Option BRatio = 1.0;

m_locatepolicy.threads=%threads%;


%fixedlocations%

* indicate using MIP start values or not
*m_locatepolicy.integer4 = %mipstart%;

* startvalues set to 1, to have starting vaules
if ( %start_value1% = 1,
$include start_value_1.gms
);

execute_loadpoint '%startValueFile%'
J
v_feedstock
v_y_sales
v_y
v_transport_cost
v_feedstock_cost
v_production_cost
v_fueltransport_cost
v_tot_demand
v_tot_feedstock

v_biofuelEmis
v_biofuelEmis_atI
v_fossil_emissions
v_totEmissions

v_tot_cost

v_yEnergy
v_blend_rate
v_endY
v_redY_cost

;
display J.l;
if(execError gt 0,
    display "Tried to load restart values, but got an error.";
   execError = 0;
);
*$offtext



*           === SOLVE the model ===
*           (minimizing the weighted sum of squared deviations under constraints)

*           The first solve may be either far off or perfect (if starting values are good)
*           We give just a little time at this point, because experience shows that
*           if the solver is restarted from a better point, it is faster.
            m_locatepolicy.Reslim    =  20;
            SOLVE m_locatepolicy USING MIP MINIMIZING v_tot_cost;
            if ( EXECERROR > 0, abort "internal error in xxxx");
*$ontext
*
*           Try re-starting solver twice if non-optimal or infeasible
            if(  (m_locatepolicy.modelstat eq 7) OR (m_locatepolicy.modelstat eq 4) OR (m_locatepolicy.solvestat eq 3),
               m_locatepolicy.Reslim    =  60;
               SOLVE m_locatepolicy USING MIP MINIMIZING v_tot_cost;
            );

*           Now we should have a good starting point. Give it some time now.
            if(  (m_locatepolicy.modelstat eq 7) OR (m_locatepolicy.modelstat eq 4) OR (m_locatepolicy.solvestat eq 3),
               m_locatepolicy.Reslim    =  (%reslim% ) * 60;
               SOLVE m_locatepolicy USING MIP MINIMIZING v_tot_cost;
            );

*$offtext
* Calculate elapsed time for solving model
p_solveInfo("elapsedtime") = (jnow - starttime)*24*3600;


display feedstock;
