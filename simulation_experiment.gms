**************************************************************

* Load varaibles from several simulation experiments
**************************************************************

$setglobal simulationset march2023


*** Load data 

* Load data and parameters from biofuel model
$include declarations.gms
$include data/data_rev.gms
* --- Load data of share of land in a certain land class
$gdxin 'data\municipality_areas_land.gdx'
$load
parameter landAreaSCB(*,*);
$load landAreaSCB =landarea
$GDXIN


*** declare parameters
* Covariates to the econometric model
parameter v_yield2(*,*);
parameter v_agri_dens(*,*);
parameter v_ley_dens(*,*);
parameter v_ley_elas(*,*);
parameter v_GHG_intensity(*,*);
parameter v_feedstock_cost2(*,*);
parameter v_carbon_price(*,*);
parameter v_borderDummy(*,*);

* Data to construct covariates
parameter land_area(*,*,*);
parameter Y_usedfeedstock(f,b_fuel,tech,i,g,*);
parameter Y_usedLand(*,*);
parameter Y_landShare(*,*);

scalar carbonpricetemp;


set reg / set.lan, set.g/;
*make unique data point
set regrVariables 'covariates and dependent varaiable of the econometric model'/yield, agriDens, leyDens, leyElas, GHGintensity, feedstockCost, borderDummy, carbonPrice, landShare/;
set dataID 'unique number to each data point'/1*10000/;
parameter data_point(*, *,regrVariables);

set scen /a*q/;
parameter letter_scen_map(scen,*);
set g_i(g,i) /(set.g).(set.i)
/;
display g_i;

$batinclude 'simulation_experiment/load_from_simulation.gms' data_rev_EndoON_distrON_gap005_target00_emistarget10_LP_7feb a

$batinclude 'simulation_experiment/load_from_simulation.gms' data_rev_EndoON_distrON_gap005_target00_emistarget20_LP_7feb b

$batinclude 'simulation_experiment/load_from_simulation.gms' data_rev_EndoON_distrON_gap005_target00_emistarget30_LP_7feb c

$batinclude 'simulation_experiment/load_from_simulation.gms' data_rev_EndoON_distrON_gap005_target00_emistarget40_LP_7feb d

$batinclude 'simulation_experiment/load_from_simulation.gms' data_rev_EndoON_distrON_gap005_target00_emistarget50_LP_7feb e

$batinclude 'simulation_experiment/load_from_simulation.gms' data_rev_EndoON_distrON_gap005_target00_emistarget60_LP_7feb f

display data_point, letter_scen_map, scen;

*** Unload data for econometric estimation
********************************************************************************************

execute_unload 'simulation_experiment\regrdata_%simulationset%.gdx'
v_yield2, v_agri_dens, v_ley_dens, v_GHG_intensity, v_feedstock_cost2, v_borderDummy,
v_carbon_price, Y_usedfeedstock, Y_usedLand, Y_landShare
data_point, letter_scen_map;

execute 'gdxxrw.exe simulation_experiment\regrdata_%simulationset%.gdx o=simulation_experiment\regrdata_%simulationset%.xls par=data_point rdim=2 cdim=1 rng=data_point! '

********************************************************************************************
*** Estimation
********************************************************************************************

* R-interface or not?

*** Prepare extrapolation
********************************************************************************************

*** Read in CAPRI data
* read in regions from CAPRI
set NUTS2Regions /1*200/;

parameter diff_v_yield2(g,NUTS2Regions,*)         ;
parameter diff_v_agri_dens(g,NUTS2Regions,*)     ;
parameter diff_v_ley_dens(g,NUTS2Regions,*)      ;
parameter diff_v_ley_elas(g,NUTS2Regions,*)      ;
parameter diff_v_GHG_intensity(g,NUTS2Regions,*) ;
parameter diff_v_feedstock_cost2(g,NUTS2Regions,*);


$include simulation_experiment/read_capri_data.gms


*** Normalize capri data
* make ok for capri regions!!!!

$include simulation_experiment/normalize_capri_data.gms

*** Compare covariates
$include simulation_experiment/compare_covariates.gms

*** Read in coefficients from estimation
* --- Read EXCEL files to GDX format

$if not exist simulation_experiment/coeffients%simulationset%.gdx $call 'gdxxrw simulation_experiment/coeffients%simulationset%.xlsx output=simulation_experiment/coeffients%simulationset%.gdx par=coeffients rng=A3 rDim=2 cDim=1  '

*** Extrpolate to regions
********************************************************************************************

* specify model

* calculate share of agricultural area for each CAPRI region based on regression results
* Y= x('capri')*coeff_x;

* caclualate forecast intervals

* check validity for Sweden





$exit

* Write excel file

execute 'gdxxrw.exe simulation_experiment\regrdata_%resultfile%.gdx o=simulation_experiment\regrdata_%resultfile%.xls par=v_yield2 rdim=1 cdim=0 rng=v_yield2! '
execute 'gdxxrw.exe simulation_experiment\regrdata_%resultfile%.gdx o=simulation_experiment\regrdata_%resultfile%.xls par=v_agri_dens rdim=1 cdim=0  rng=v_agri_dens! '
execute 'gdxxrw.exe simulation_experiment\regrdata_%resultfile%.gdx o=simulation_experiment\regrdata_%resultfile%.xls par=v_ley_dens rdim=1 cdim=0 rng=v_ley_dens! '
execute 'gdxxrw.exe simulation_experiment\regrdata_%resultfile%.gdx o=simulation_experiment\regrdata_%resultfile%.xls par=v_GHG_intensity rdim=1 cdim=0 rng=v_GHG_intensity! '
execute 'gdxxrw.exe simulation_experiment\regrdata_%resultfile%.gdx o=simulation_experiment\regrdata_%resultfile%.xls par=v_feedstock_cos2t rdim=1 cdim=0  rng=v_feedstock_cost2!'
execute 'gdxxrw.exe simulation_experiment\regrdata_%resultfile%.gdx o=simulation_experiment\regrdata_%resultfile%.xls par=v_borderDummy rdim=1 cdim=0 rng=border_dummy!'
execute 'gdxxrw.exe simulation_experiment\regrdata_%resultfile%.gdx o=simulation_experiment\regrdata_%resultfile%.xls par=v_carbon_price rng=v_carbon_price! '
execute 'gdxxrw.exe simulation_experiment\regrdata_%resultfile%.gdx o=simulation_experiment\regrdata_%resultfile%.xls par=Y_usedLandBM rdim=1 cdim=0 rng=landUsed! '
execute 'gdxxrw.exe simulation_experiment\regrdata_%resultfile%.gdx o=simulation_experiment\regrdata_%resultfile%.xls par=Y_landShare rdim=1 cdim=0 rng=land_shareUsed! '

*** Run regression with data, R
 
**********************************************************************************
*** New file for extrapolation?


$exit
***************************************** funkar ej

$ontext
set simulations / data_rev_EndoON_distrON_gap005_target00_emistarget70_LP_7feb/;
loop(simulations,
$include test2.gms
);
loop(simulations,
$batinclude 'simulation_experiment/load_from_simulation.gms' simulations
);
$exit

set sim "Process, e.g. scenario run" /s1 'data_rev_EndoON_distrON_gap005_target00_emistarget70_LP_7feb'
*                                    s2 'scen_Emistarget_40_nov'
*                                    s3 'scen_Emistarget_60_nov'
*                                    s4 'scen_Emistarget_20_crpALA_nov'
*                                    s5 'scen_Emistarget_40_crpALA_nov'
*                                    s6 'scen_Emistarget_60_crpALA_nov'
*                                    s7 'scen_Emistarget_10_to_100_crpALAhigh_nov'
*                                    s8 'scen_Emistarget_10_to_100_crpPastALA_nov'
*                                    s9 'scen_Emistarget_10_to_100_crpPastALAhigh_nov'
*                                    s10 'scen_Emistarget_10_to_100_crpALALUCdiff_nov'



                                    /;


$set gamsexe c:\gams\37\gams.exe
$set sd temp
$if not dexist %sd% $call mkdir %sd%

scalar n;
file batch "Some file" /%sd%\temp.cmd/;
put batch;



loop(sim,

* --- Generate directories for gams
    
    display "Running...";
    n = ord(sim);
   
*   --- Make a temporary directory for the child model
    
    put_utility 'exec' / 'mkdir ' '%sd%\model-':0 sim.tl:0;


*   --- Write out a file that signals that the process has started (to be deleted by the child process itself)

    put_utility 'shell' / 'echo test > %sd%\started-':0 sim.tl:0 '.flag';

*   --- Run the child model using the temp directory for temporary files
    
    put_utility 'shell' / 'start "add data" %gamsexe% simulation_experiment/load_from_simulation.gms' 
                          ' scrdir=%sd%\model-':0 sim.tl:0
                          ' procdir=%sd%\model-':0 sim.tl:0
                          ' --results_out=%sd%\model-':0 sim.tl:0
                          ' seed=' n:0
                          ' o=model-':0 sim.tl:0 '.lst'
                          ' --flag=%sd%\started-':0 sim.tl:0 '.flag':0
                          ' --scenariofile=' sim.te(sim):0;
*                          ' --scenario2=' s.tl:0;
                          

);
$offtext



