set orig(*), dest(*);

parameter supply(orig), demand(dest), rate(orig,dest), limit(orig,dest);

$gdxin nltrans.gdx
$load orig,dest,supply,demand,rate,limit
$gdxin

$macro trnfn(x) x/(1 - (x)**0.8/limit(orig,dest))

positive variable trans(orig,dest) ’units to ship’;

variable total_cost;

equation defobj, supplycons(orig), demandcons(dest);

defobj..
total_cost =e= sum((orig,dest), rate(orig,dest)*trnfn(trans(orig,dest)));

supplycons(orig)..
sum(dest, trans(orig,dest)) =e= supply(orig);

demandcons(dest)..
sum(orig, trans(orig,dest)) =e= demand(dest);

model nltrans /all/;

trans.l(orig,dest) = limit(orig,dest)/2;
trans.lo(orig,dest) = 1e-10;
trans.up(orig,dest) = 0.99*limit(orig,dest);

solve nltrans using nlp min total_cost;

$if not set NB $set  NB 3
set break0 / 0*%NB% /;
set break1(break0) / 1*%NB% /;

alias(break0, i);
alias(break1, j);

parameters br(break0, orig, dest) flow from origin to supply at breakpoints;
br('0', orig, dest) = 1e-10;
br('1', orig, dest) = 1/3*limit(orig,dest);
br('2', orig, dest) = 2/3*limit(orig, dest);
br('3', orig, dest) = 0.99*limit(orig, dest);

parameter c(break1, orig, dest);
parameter m(break1, orig, dest);
m(j, orig, dest)$(j.ord le 2) = ( trnfn(br(j, orig, dest)) - trnfn(br(j-1, orig, dest)) )/
                     ( br(j, orig, dest) - br(j-1, orig, dest) );             
m('3', orig, dest) = ( trnfn(11/12*limit(orig, dest)) - trnfn(br('2', orig, dest)) )/
                     ( 11/12*limit(orig, dest) - br('2', orig, dest) );

c(j, orig, dest)$(j.ord le 2) = trnfn(br(j, orig, dest)) - m(j, orig, dest)*br(j, orig, dest);
c('3', orig, dest) = trnfn(11/12*limit(orig, dest)) - m('3', orig, dest)*11/12*limit(orig, dest);

display m, c;

binary variables
b(break0, orig, dest);

positive variables
x(orig, dest), w(break0, orig, dest);

variables 
y(orig, dest),  min_cost;

equations
obj, cost_eq, wlo, wup, oneW, supplycons_mip, demandcons_mip, xeq;

obj..
min_cost =e= sum((orig, dest), rate(orig, dest)*y(orig, dest));

cost_eq(orig, dest)..
y(orig, dest) =e= sum(j, m(j, orig, dest)*w(j, orig, dest) + c(j, orig, dest)*b(j, orig, dest));

wlo(i, orig, dest)$j(i)..
w(i, orig, dest) =g= br(i-1, orig, dest)*b(i, orig, dest);

wup(i, orig, dest)$j(i)..
w(i, orig, dest) =l= br(i, orig, dest)*b(i, orig, dest);

oneW(orig, dest)..
sum(i$break1(i), b(i, orig, dest)) =e= 1;

supplycons_mip(orig)..
sum(dest, x(orig,dest)) =e= supply(orig);

demandcons_mip(dest)..
sum(orig, x(orig,dest)) =e= demand(dest);

xeq(orig, dest)..
x(orig, dest) =e= sum(i$j(i), w(i, orig, dest));

model transport / obj, cost_eq, wlo, wup, oneW, supplycons_mip, demandcons_mip, xeq /;

solve transport using mip minimize min_cost;








