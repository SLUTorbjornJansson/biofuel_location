* -----------------------------------------
* Calcualting hectares per livestock units
* -----------------------------------------

* ---- Including data from model ----
*$setglobal demandMode Demand
$setglobal level 70     
$setglobal fixedlocations
*J.fx(fuel,"medium","1498")=1;
$setglobal scen data_rev_EndoON_distrON_gap005_target00_emistarget100_7feb

$setglobal gap 01
$setglobal reslim 300
$setglobal mipstart 0

$setglobal data data_rev

$include 'declarations.gms'

$include data\%data%.gms
* ----------------------------------------

* Declare
set livst 'animal types assumed eating forage'/"kor för mjölkproduktion","kor för uppfödning av kalvar","kvigor, tjurar och stutar","kalvar, under 1 år","baggar och tackor","lamm"/;
*set landsdel /"�stra Sverige", "S�dra Sverige", "Norra Sverige"/;
set reg /set.landsdel, set.g, set.lan/;
display reg, lan_to_landsdel;

* I don't remeber why, buy seems i cannot just add together sets, and then assign to e.g. "lan".  gives "domain violation for set"
parameter forage(*,*);
parameter animals(*,livst,*);
parameter LSU(livst) ' livestock units per animal';
parameter livestock(*);
parameter forage_density(*,*);



* --- Load result data on feedstock

$gdxin 'results/PII/results_%scen%.gdx'
$load

$load v_feedstock
$GDXIN

* --- Aggregate hectares to county level to fit animal statistics


* --- Calculate change in hectars for forage
* the used hectares less all other land (in grassland category) that is not for forage
display areaHA2;



forage(g, "ref")=
(areaHA2(g,"slatter- och betesvall som utnyttjas","average15_19")
    +  areaHA2(g,"slattervall och gronfoder","average15_19")
    )
    
/1000
    ;

forage(g, "refNnLey")=
     (areaHA2(g,"ej utnyttjad slatter- och betesvall","average15_19")
     +  areaHA2(g,"energiskog","average15_19")
     +  areaHA2(g,"trada","average15_19")
     
     +  areaHA2(g,"ospecificerad akermark","average15_19")
     +  areaHA2(g,"annan obrukad akermark","average15_19"))
     /1000
;
     




forage(lan, "ref")= sum(g $lan_to_kn(lan,g), forage(g, "ref"));
forage(lan, "refNnLey")= sum(g $lan_to_kn(lan,g), forage(g, "refNnLey"));

forage(lan, "relRefNnLey") =  forage(lan, "refNnLey")/ forage(lan, "ref");

forage(landsdel, "ref")=
    sum(lan $ lan_to_landsdel(landsdel, lan), forage(lan, "ref"));

* yield in t tonne per hectare, with feedstock in t tonne, gives t tonne per t hectare when multiplied with 1000
forage(g, "change") =
max(0,   sum((f,b_fuel,tech,i) $ yield(g,f), v_feedstock.l(f,b_fuel,tech,i,g)/(yield(g,f)*1000) )- forage(g, "refNnLey")
);



forage(lan, "change")=
    sum(g $ lan_to_kn(lan,g), forage(g, "change"));

forage(landsdel, "change")=
    sum(lan $ lan_to_landsdel(landsdel, lan), forage(lan, "change"));
 
forage(g,"remaining") =
    forage(g,"ref") -forage(g,"change");

forage(lan,"remaining") =
    forage(lan,"ref") -forage(lan,"change");

forage(landsdel,"remaining") =
    sum(lan $ lan_to_landsdel(landsdel, lan),  forage(lan,"remaining"));
   
* Some arable land can be used. this is the remaining part if change was larger than total grassareas
forage(g,"croplandused")=  max[0, sum((f,b_fuel,tech,i) $ yield(g,f), v_feedstock.l(f,b_fuel,tech,i,g)/(yield(g,f)*1000) )
                                                                        - sum(grassareas, areaHA2(g,grassareas,"average15_19")/1000)
 ];

forage(lan, "croplandused")=
    sum(g $ lan_to_kn(lan,g), forage(g, "croplandused"));

forage(landsdel, "croplandused")=
    sum(lan $ lan_to_landsdel(landsdel, lan), forage(lan, "croplandused"));


* --- Load data on animal numbers
* Number of animals, cows and sheep. (Jordbruksverkets statistikdatabas, Lantbruksdjur efter l�n/riket och djurslag. �r 1981-2019. Average 2015-2019, Intern referenskod:JO0103G5,  31/07/2020)

$if not exist data\animals2015_2019.gdx $call 'gdxxrw data\animals2015_2019.xlsx output=data\animals2015_2019.gdx par=animals ignoreColumns=B,C rng=A3 rDim=2 cDim=1'

$gdxin 'data\animals2015_2019.gdx'
$load

$load animals
$GDXIN

* --- Convert animals to livestock units  (LSU)

* Livestock units (LSU), from eurostat (https://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Livestock_unit_(LSU), 31/07/2020)

* kor f�r mj�lkproduktion = Dairy cows, kor f�r uppf�dning av kalvar= Other cows, 2 years old and over ,
* kvigor, tjurar och stutar= Bovine animals 1 but less than 2 years old Male, 2 years old and over and  Heifers, 2 years old and over ,
* kalvar, under 1 �r = Bovine animals  Under 1 year old , baggar och tackor = sheep , lamm = sheep.

LSU("kor för mjölkproduktion") = 1.0;
LSU("kor för uppfödning av kalvar") = 0.8;
LSU("kvigor, tjurar och stutar")= 0.8;
LSU("kalvar, under 1 år") = 0.4;
LSU("baggar och tackor") = 0.1;
LSU("lamm")= 0.1;


livestock(lan) =
    sum(livst,LSU(livst) * animals(lan,livst,"Average15_19")) /1000;
livestock(landsdel) =
    sum(lan$ lan_to_landsdel(landsdel, lan), livestock(lan)) ;

* --- Calcualte hectares per livestock unit before and after, and percentage change


* Reference
forage_density(reg,"ref") $ livestock(reg) =
    forage(reg,"ref")/livestock(reg);

* After
forage_density(reg,"remaining") $ livestock(reg) =
    forage(reg,"remaining")/livestock(reg);


* Change in density, absolute and relative change
forage_density(reg,"change_abs") =
    forage_density(reg,"ref") - forage_density(reg,"remaining");

* Assume same for kommun as lan
forage_density(g,"change_abs") = sum(lan$lan_to_kn(lan,g) ,forage_density(lan,"change_abs"));

forage_density(reg,"change_rel") $  forage_density(reg,"ref")=
    forage_density(reg,"remaining") / forage_density(reg,"ref")
    -1;
* Assume same for kommun as lan
forage_density(g,"change_rel") = sum(lan$lan_to_kn(lan,g) ,forage_density(lan,"change_rel"));
forage_density(reg,"change_rel")$ (forage_density(reg,"change_rel")=0) =0.0000001;

forage_density(g,"remaining") = sum(lan$lan_to_kn(lan,g) ,forage_density(lan,"remaining"));
forage_density(g,"ref") = sum(lan$lan_to_kn(lan,g) ,forage_density(lan,"ref"));
* --- Unload results

execute_unload 'results/change_animals_%scen%.gdx' forage, forage_density, livestock;
execute 'gdxxrw.exe results/change_animals_%scen%.gdx o=results/change_animals_%scen%.xlsx par=forage_density Rng=forage_density!'
execute 'gdxxrw.exe results/change_animals_%scen%.gdx o=results/change_animals_%scen%.xlsx par=livestock Rng=livestock!'
execute 'gdxxrw.exe results/change_animals_%scen%.gdx o=results/change_animals_%scen%.xlsx par=forage Rng=forage!'
display    livestock, forage , forage_density, v_feedstock.l;

* want to have hectare per municipality, before and after. so can make one map before and the other after
* want to have animals and hectares in län to R, then can do this calulation in R too. 

