





* --- Start parallel gams processes that don't interfere with each other


set s "Process, e.g. scenario run" /s1 'scen_Emistarget_20_nov'
                                    s2 'scen_Emistarget_40_nov'
                                    s3 'scen_Emistarget_60_nov'
                                    s4 'scen_Emistarget_20_crpALA_nov'
                                    s5 'scen_Emistarget_40_crpALA_nov'
                                    s6 'scen_Emistarget_60_crpALA_nov'
                                    s7 'scen_Emistarget_10_to_100_crpALAhigh_nov'
                                    s8 'scen_Emistarget_10_to_100_crpPastALA_nov'
                                    s9 'scen_Emistarget_10_to_100_crpPastALAhigh_nov'
                                    s10 'scen_Emistarget_10_to_100_crpALALUCdiff_nov'
                                    /;


$set gamsexe c:\gams\37\gams.exe
$set sd temp
$if not dexist %sd% $call mkdir %sd%

scalar n;
file batch "Some file" /%sd%\temp.cmd/;
put batch;



loop(s,

* --- Generate directories for gams
    
    display "Running...";
    n = ord(s);
   
*   --- Make a temporary directory for the child model
    
    put_utility 'exec' / 'mkdir ' '%sd%\model-':0 s.tl:0;


*   --- Write out a file that signals that the process has started (to be deleted by the child process itself)

    put_utility 'shell' / 'echo test > %sd%\started-':0 s.tl:0 '.flag';

*   --- Run the child model using the temp directory for temporary files
    
    put_utility 'shell' / 'start "Running model" %gamsexe% parallel_child.gms '
                          ' scrdir=%sd%\model-':0 s.tl:0
                          ' procdir=%sd%\model-':0 s.tl:0
                          ' --results_out=%sd%\model-':0 s.tl:0
                          ' seed=' n:0
                          ' o=model-':0 s.tl:0 '.lst'
                          ' --flag=%sd%\started-':0 s.tl:0 '.flag':0
                          ' --scenariofile=' s.te(s):0;
*                          ' --scenario2=' s.tl:0;
                          

);


* --- Collect results from the child processes

* start a DOS program that repeatedly checks if any files with the pattern in arg 3 exists
* arg 1 how many seconds to wait in each check (e.g. 1 second)
* arg 2 how many times to check (eg 120 = 2 minutes waiting max)

execute.checkErrorLevel "=utils\taskSync.bat 1 90000 %sd%\started-*.flag";

$exit
set i /i1*i100/;
parameter p_resTmp(i);
parameter p_allRes(i,s);
scalar deafult_emisTargetTmp;
parameter deafult_emisTargetAll(s);

loop(s,
    put_utility 'gdxin' / '%sd%\model-':0 s.tl:0 '\res.gdx';
    execute_loadpoint  deafult_emisTargetTmp=deafult_emisTarget;
    deafult_emisTargetAll(s)=deafult_emisTargetTmp;
    display deafult_emisTargetAll;
    );
    
execute_unload "allRes.gdx" deafult_emisTargetAll;