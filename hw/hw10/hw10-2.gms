sets I Product /i1*i2/,
J Part /j1*j5/;

table
Data(*,*)
    j1      j2      j3      j4      j5      l       q       d
c   10      30      10      100     50
v    1       8       2       30     10
i1  10       5       5        1      1      500     1200    10
i2   8       5       0        2      1      600     3000    20;

parameters
a(i,j) how many part j needed to make a unit of product i
c(j) cost of procuring a unit of part j
v(j) salvage value of a unit of part j
l(i) manufacturing cost of a unit of product i
q(i) selling price of a unit of product i,
md(i) mean demand of product i;

a(i,j) = Data(i,j);
c(j) = Data('c',j);
v(j) = Data('v',j);
l(i) = Data(i,'l');
q(i) = Data(i,'q');
md(i) = Data(i,'d');

positive variables
x(i) how many products i in I to produce and sell,
y(j) how many parts j in J to order,
z(j) how many parts j in J are not used (salvaged);

variables
profit;

equations
obj, res_cons, demand_cons, salvage_cons;

obj..
    profit =e= sum(i, (q(i)-l(i))*x(i)) - sum(j, c(j)*y(j) - v(j)*z(j));
    
res_cons(j)..
    sum(i, a(i, j)*x(i)) =l= y(j) - z(j);
    
demand_cons(i)..
    x(i) =l= md(i);
    
salvage_cons(j)..
    z(j) =l= y(j) - sum(i, a(i, j)*x(i));
    
model multi_product / obj, res_cons, demand_cons, salvage_cons /;
solve multi_product using lp maximize profit;

set S / 1*10000 /
scen(s);

scen(s) = yes$(s.ord le 9);

table cd(i, s,*)
    1.v     1.p     2.v     2.p     3.v     3.p
i1  5.00    0.1     10.0    0.2     12.0    0.7
i2  17.0    0.1     20.0    0.2     25.0    0.7
;

parameters
prob(s), d(i, s);

prob('1') = cd('i1', '1', 'p')*cd('i2', '1', 'p');
prob('2') = cd('i1', '1', 'p')*cd('i2', '2', 'p');
prob('3') = cd('i1', '1', 'p')*cd('i2', '3', 'p');
prob('4') = cd('i1', '2', 'p')*cd('i2', '1', 'p');
prob('5') = cd('i1', '2', 'p')*cd('i2', '2', 'p');
prob('6') = cd('i1', '2', 'p')*cd('i2', '3', 'p');
prob('7') = cd('i1', '3', 'p')*cd('i2', '1', 'p');
prob('8') = cd('i1', '3', 'p')*cd('i2', '2', 'p');
prob('9') = cd('i1', '3', 'p')*cd('i2', '3', 'p');

d('i1', '1') = cd('i1', '1', 'v');
d('i1', '2') = cd('i1', '1', 'v');
d('i1', '3') = cd('i1', '1', 'v');
d('i1', '4') = cd('i1', '2', 'v');
d('i1', '5') = cd('i1', '2', 'v');
d('i1', '6') = cd('i1', '2', 'v');
d('i1', '7') = cd('i1', '3', 'v');
d('i1', '8') = cd('i1', '3', 'v');
d('i1', '9') = cd('i1', '3'`, 'v');
d('i2', '1') = cd('i2', '1', 'v');
d('i2', '2') = cd('i2', '2', 'v');
d('i2', '3') = cd('i2', '3', 'v');
d('i2', '4') = cd('i2', '1', 'v');
d('i2', '5') = cd('i2', '2', 'v');
d('i2', '6') = cd('i2', '3', 'v');
d('i2', '7') = cd('i2', '1', 'v');
d('i2', '8') = cd('i2', '2', 'v');
d('i2', '9') = cd('i2', '3', 'v');

positive variables
x_scen(i, s) how many products i in I to produce and sell in each scenario r in R
z_scen(j, s) how many products j in J to salvage in each scenario r in R;

variables
profit_scen;

equations
obj_scen, res_cons_scen, demand_cons_scen, salvage_cons_scen;

obj_scen..
    profit_scen =e= sum((i, scen), prob(scen)*(q(i)-l(i))*x_scen(i, scen)) - sum((j, scen), prob(scen)*(c(j)*y(j) - v(j)*z_scen(j, scen)));
    
res_cons_scen(j, scen)..
    sum(i, a(i, j)*x_scen(i, scen)) =l= y(j) - z_scen(j, scen);
    
demand_cons_scen(i, scen)..
    x_scen(i, scen) =l= d(i, scen);
    
salvage_cons_scen(j, scen)..
    z_scen(j, scen) =l= y(j) - sum(i, a(i, j)*x_scen(i, scen));
    
model multi_product_scen / obj_scen, res_cons_scen, demand_cons_scen, salvage_cons_scen /;
solve multi_product_scen using lp maximize profit_scen; 
    
display profit_scen.l;

$funclibin stolib stodclib
functions
randpoisson /stolib.dpoisson/,
setseedh /stolib.SetSeed /;

scalar seedno;
seedno=setseedh(39183);

set numScenarios / 100, 200, 400, 800, 1600, 10000 /;
scen(s) = no;

parameter obj_results(numScenarios) Objective values,
first_stage_results(numScenarios, *) First stage variable values;

loop(numScenarios,
*populate S
    scen(s) = yes$(s.ord le numScenarios.val);
    d('i1',s) = randpoisson(10);
    d('i2',s) = randpoisson(20);
    prob(s) = 1/card(s);
    solve multi_product_scen using lp maximize profit_scen;
    obj_results(numScenarios) = profit_scen.l;
    first_stage_results(numScenarios, j) = y.l(j);
);

display obj_results, first_stage_results;

*The first stage variables come to consensus very quickly, profit takes longer to converge especially when it runs the last iteration
 








