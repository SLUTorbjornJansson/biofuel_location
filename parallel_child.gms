* --- Construct a model
$if not set results_out $set results_out .

display "Running with results_out=%results_out%";
display "Flag file = %flag%";
*$set s1 scen_Emistarget_10_to_100_crpALALUCdiff

*$if sameas(s,"s1") 
*$if s==s2 $set scenfile scen_Emistarget_10_to_100_crpALA
*parameter p(s);
*p(s) = ord(s);
*display p(s);

*display n;
*$if n ==1 $set scenfile scen_Emistarget_10_to_100_crpALALUCdiff
*$if n ==2 $set scenfile scen_Emistarget_10_to_100_crpALALUCdiff

*$set scenfile scen_Emistarget_10_to_100_crpALALUCdiff


display "scen är %scenario2%";

$include run_model_template.gms


if(execerror eq 0,
    execute "del %flag%";
else
    abort "Something went wrong";
);

