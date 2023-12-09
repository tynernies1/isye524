$Title Simple newsboy problem, discrete

$ontext

Simple newsboy problem
Normal distribution for random parameter d

$offtext

Scalar  c       Purchase costs per unit              / 0.3 /
        r       return value per unit leftover       / 0.05 /
        q       Revenue per unit sold                / 2.0 /
*       Random parameters
        d       Demand                               / 100 /;

Variable obj Profit;
Positive Variables
         X Units bought
         Z returns
         Y Units sold;

Equations Row1, Row2, Profit;

* demand = UnitsSold + LostSales
Row1.. d =g= Y;

* Returns(salvage) = UnitsBought - UnitsSold
Row2.. Z =e= X - Y;

* Profit, to be maximized;
Profit..  obj =e= -c*X + q*Y + r*Z;

Model nb / Row1, Row2, Profit /;

solve nb max obj using lp;
scalar Xmvs, Fmvs; Xmvs = X.l;

* sample of 3000 demands
$funclibin stolib stodclib
Functions
  randnorm     /stolib.dnormal/,
  setseedh     /stolib.SetSeed /,
  icdfnorm     /stolib.icdfnormal/;

scalar seedno; seedno=setseedh(39183);

Set i / i1*i3000 /;
Parameter 
  testD(i)    "demand sample for out of sample testing",
  F(i) profit sample;

testD(i) = randnorm(100,20);
F(i) = min((q-c)*Xmvs, (q-r)*testD(i) + (r-c)*Xmvs);

Fmvs = sum(i, F(i))/card(i);
display Xmvs, Fmvs;

* Now do stochastic model

$if not set ss $set ss 400
Set s planning scenarios / s1*s%ss% /;
Parameter trainD(s), prob(s) / set.s [1/%ss%] /;

trainD(s) = randnorm(100,20);

equations sRow1(s), sRow2(s), sProfit;
positive variables s_Y(s), s_Z(s);

* demand = UnitsSold + LostSales
sRow1(s).. trainD(s) =g= s_Y(s);

* Returns(salvage) = UnitsBought - UnitsSold
sRow2(s).. s_Z(s) =e= X - s_Y(s);

* Profit, to be maximized;
sProfit..  obj =e= -c*X + sum(s, prob(s)*(q*s_Y(s) + r*s_Z(s)));

Model snb / sRow1, sRow2, sProfit /;

solve snb max obj using lp;
Display X.l, s_Y.l;

scalar Xss, Fss, CFss; Xss = X.l;

F(i) = min((q-c)*Xss, (q-r)*testD(i) + (r-c)*Xss);
Fss = sum(i, F(i))/card(i);
* Closed form stochastic solution
CFss = icdfnorm((q-c)/(q-r),100,20);
display Xss, Fss, CFss;

* Calculate VSS
scalar vss; vss =  Fss - Fmvs;
display vss;
