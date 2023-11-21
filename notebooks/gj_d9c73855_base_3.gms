$gdxIn gj_d9c73855_base_3_gdxin.gdx
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
$if not declared profit free variable profit 'total profit';
$load profit
$gdxIn
$offeolcom
$eolcom #
equation 
    profit_eq "profit definition",
    resource_con(R) "resource limit";

* EQUATION (MODEL) DEFINITION
profit_eq..
  profit =E= sum(I,c(I)*x(I));

resource_con(R)..
  sum(I, a(R,I)*x(I)) =L= b(R);

model btb /all/;

solve btb using lp maximizing profit;
