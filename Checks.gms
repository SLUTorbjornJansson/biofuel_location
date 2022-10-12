* ------------------------------------------------
* Some checks of data
* ------------------------------------------------
parameter checks(*,*);
* fossil q compared ethanol
checks("ethmax","SE")=sum((f,g), feedstock(f,g)*0.3)*energy_ekv("ethanol");
checks("fossilmax", "se")= sum((blend_fuel,h), f_fuel_0(blend_fuel,h));

execute_load 'results\results_%data%_demand_gap01_target70_normal.gdx'
v_totEmissions.l, v_tot_cost.l;

* prodtarget emissions vs climate target
checks("emis_eth70target", "se")= v_totemissions.l;
*checks("emis_70_Ctarget", "se")=  0.7 * (sum(h, f_fuel_0("gasE",h)) * ghg_factor("all", "gasoline","all") + sum(h, f_fuel_0("dieB",h)) * ghg_factor("all", "diesel", "all"));
p_prodTarget(b_fuel) = %level%/100 * max_target(b_fuel) ;
* cost per TJ ethanol---
checks("cost_per_TJ_eth", "se") = v_tot_cost.l/(p_prodTarget("ethanol")*energy_ekv("ethanol"));
checks("cost_per_TJ_gas", "1") = sum(h, md_consumer("gasE_1", h)) / sum(h $md_consumer("gasE_1", h), 1);
checks("price_gas", "se") = p_0("gasE");
checks("cost_per_co2_reduction", "se")= checks("cost_per_TJ_gas", "1")/(ghg_factor("all", "gasoline","all")/energy_ekv("gas"));
checks("cost_per_co2_eth", "se")=  v_tot_cost.l/v_totEmissions.l;

display checks, p_prodtarget, energy_ekv, v_tot_cost.l;
*$exit
