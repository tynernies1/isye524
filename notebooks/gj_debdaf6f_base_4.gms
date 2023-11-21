$gdxIn gj_debdaf6f_base_4_gdxin.gdx
$onMultiR
$if not declared I set I(*) '';
$load I
$if not declared R set R(*) '';
$load R
$if not declared a parameter a(R,I) 'Per-Unit resource requirements';
$load a
$if not declared c parameter c(I) '';
$load c
$if not declared b parameter b(R) '';
$load b
$if not declared x positive variable x(I) 'number trophies';
$load x
$gdxIn
$offeolcom
$eolcom #
set I /football,soccer/;
set R /plaques,wood/;

table a(R,I)  "Per-Unit resource requirements"
         football   soccer
plaques     1         1
wood        4         2  ;

parameters
    c(I) / "football" 12, "soccer" 9 /
    u(I) / "football" 1000 , "soccer"  1500 /
    b(R) / "plaques"  1750,  "wood"  4800 /;

* VARIABLE AND EQUATION DECLARATIONS
free variable profit "total profit";

positive variables
x(I)     "number trophies" ;
