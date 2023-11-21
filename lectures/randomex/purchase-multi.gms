$title Purchasing with price breaks
option limrow=0, limcol=0, solprint=off;
$ontext
This uses multiple choice model
$offtext

$if not set fcost $set fcost 0
* small data from purchase.gms

$set  NB 3
set BREAK0 'price break points' /0*%NB%/;
set BREAK1(BREAK0) 'price break segments' /1*%NB%/;
set SUPPL 'Suppliers' /1*3/;

table CBR(SUPPL,BREAK0) 'Total cost at break points'
            0           1           2           3
1     30.0000    950.0000   1850.0000   7450.0000
2      8.0000    458.0000   2158.0000  16683.0000
3     10.0000   1110.0000   2810.0000  30560.0000
;

table  BR(SUPPL,BREAK0) 'Breakpoints (quantities at which unit cost changes)'
   0 1   2   3
1  0 100 200 1000
2  0 50  250 2000
3  0 100 300 4000
;

alias(s,SUPPL);
alias(i,BREAK0);

parameter c(SUPPL,BREAK0);
parameter m(SUPPL, BREAK0);
m(s,i)$BREAK1(i) = (CBR(s,i)-CBR(s,i-1))/(BR(s,i)-BR(s,i-1));
c(s,i)$BREAK1(i) = CBR(s,i-1) - m(s,i)*BR(s,i-1);

parameter ALPHA(SUPPL) 'Maximum percentages for each supplier'
      /1 0.60, 2 0.45, 3 0.60/;
scalar REQ 'Total quantity required' /600/;

positive variables x(SUPPL) 'Quantity to purchase from supplier s';
binary variables b(SUPPL,BREAK0) 'use piece for supplier';
binary variables z(SUPPL) 'use supplier s';
variables w(SUPPL,BREAK0) 'X values in segment k for supplier s';
variables MinCost;
equations defobj, defbuy(s), wlo(s,i), wup(s,i), OneW(s), Demand;

* Objective: sum of costs*weights
defobj..
  MinCost =e= 
  sum((s,i)$BREAK1(i), C(s,i)*b(s,i) + m(s,i) * w(s,i)); 

* Define buy and also order the weight variables by breakpoint quantities
defbuy(s)..
  sum(i$BREAK1(i), w(s,i)) =e= x(s);

wlo(s,i)$BREAK1(i)..
  BR(s,i-1) * b(s,i) =l= w(s,i);

wup(s,i)$BREAK1(i)..
  w(s,i) =l= BR(s,i) * b(s,i);

* The convexity row (w sum to 1)
OneW(s)..
  sum(i$BREAK1(i), b(s,i)) =e= 
$ifthene %fcost% == 1
  z(s);
$else
  1;
$endif

* The minimum quantity that must be bought
Demand..
  sum(s, x(s)) =g= REQ;

* No more than the maximum percentage from each supplier
x.up(s) = ALPHA(s)*REQ;

model purchase /all/;
purchase.optcr = 1e-6;
purchase.threads = 3;
solve purchase using mip minimizing MinCost;

parameter multi_time;
multi_time = purchase.resusd;

display multi_time;
