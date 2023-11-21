$gdxIn gj_44d6aac3_base_2_gdxin.gdx
$onMultiR
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
