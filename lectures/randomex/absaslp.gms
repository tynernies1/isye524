$ontext
Models minimizing the sum_i  abs ( x(i) ) as an LP
$offtext

set i / 1*2 /;
positive variables x(i);
variable z(i), obj;
equations cons, defzplus(i), defzminus, defobj1;

cons.. 2*x('1') + x('2') =g= 1;

defzplus(i)..
  z(i) =g= x(i);

defzminus(i)..
  z(i) =g= -x(i);

defobj1.. 
   obj =e= sum(i, z(i));

* first model minimax
model abs1 / cons, defzplus, defzminus, defobj1 /;
solve abs1 using lp min obj;

* second model split into positive and negative
positive variables p(i), n(i);
equations defx(i), defobj2;

defx(i).. x(i) =e= p(i) - n(i);
defobj2.. obj =e= sum(i, p(i) + n(i));

model abs2 / cons, defx, defobj2 /;
solve abs2 using lp min obj;

parameter check;
check = sum(i, abs(x.l(i)));
display check;
