$gdxIn gj_debdaf6f_base_3_gdxin.gdx
$onMultiR
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
