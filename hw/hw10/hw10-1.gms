sets P / salsa, ketchup, paste /,
R / tomatoes, sugar, labor, spices /,
S / 1*4 /,
T / 1*3 /,
scen(S);

scen(s) = yes;

parameters
a(p, r) /
salsa.tomatoes 0.5,
salsa.sugar 1.0
salsa.labor 1.0
salsa.spices 3.0
ketchup.tomatoes 0.5
ketchup.sugar 0.5
ketchup.labor 0.8
ketchup.spices 1.0
paste.tomatoes 1.0
paste.sugar 0
paste.labor 0.5
paste.spices 0.25
/,

b(r) / tomatoes 250, sugar 300, labor 200, spices 100 /,

g(r) / tomatoes 0.5, sugar 1.0, labor 2.0, spices 1.0 /,

c(p, t) /
paste.1 1.0
paste.2 1.1
paste.3 1.2
ketchup.1 1.5
ketchup.2 1.75
ketchup.3 2.0
salsa.1 2.5
salsa.2 2.75
salsa.3 3.0
/,

alpha(p) / paste 0.5, ketchup 0.25, salsa 0.2 /,

beta(p) / paste 4.0, ketchup 6.0, salsa 12.0 /,

d(p, t, s) /
paste.1.1 100
ketchup.1.1 30
salsa.1.1 5
paste.2.1 100
ketchup.2.1 30
salsa.2.1 5
paste.3.1 100
ketchup.3.1 30
salsa.3.1 5
paste.1.2 100
ketchup.1.2 30
salsa.1.2 5
paste.2.2 100
ketchup.2.2 30
salsa.2.2 5
paste.3.2 200
ketchup.3.2 40
salsa.3.2 20
paste.1.3 100
ketchup.1.3 30
salsa.1.3 5
paste.2.3 200
ketchup.2.3 40
salsa.2.3 20
paste.3.3 100
ketchup.3.3 30
salsa.3.3 5
paste.1.4 100
ketchup.1.4 30
salsa.1.4 5
paste.2.4 200
ketchup.2.4 40
salsa.2.4 20
paste.3.4 200
ketchup.3.4 40
salsa.3.4 20 /,

prob(s) / 1 0.15, 2 0.4, 3 0.15, 4 0.3 /;

parameters
expected_demand(p, t);
expected_demand(p, t) = sum(s, d(p, t, s)*prob(s));

positive variables
over(p, t) resources we are over expected demand,
under(p, t) resources we are under expected demand,
extra(r, t) extra resources we have to buy;

variables
cost, x(p, t) number of tomato products p made in time period t;

equations
defobj, res_cons, surplus;

defobj..
    cost =e= sum(t, sum(p, c(p, t)*x(p, t) + over(p, t)*alpha(p) + under(p, t)*beta(p)) + sum(r, extra(r, t)*g(r)));
    
res_cons(R, T)..
    sum(p, a(p, r)*x(p, t)) =l= b(r) + extra(r, t); 

surplus(P, T)..
    over(p, t) =e= x(p, t) + over(p, t-1) + under(p, t) - expected_demand(p, t);
    
model mean_val_soln / defobj, res_cons, surplus /;

solve mean_val_soln using lp minimize cost; 

parameter
x_stor(p, t), obj_stor(*);
x_stor(p, t) = x.l(p, t);

positive variables
over_scen(p, t, s) resources we are over demand in each scenario,
under_scen(p, t, s) resources we are under demand in each scenario;

variables
cost_scen;

equations
defobj_scen, res_cons_scen, surplus_scen;

defobj_scen..
    cost_scen =e= sum((p, t, scen), prob(scen)*(c(p, t)*x(p, t) + over_scen(p, t, scen)*alpha(p) + under_scen(p, t, scen)*beta(p))) + sum((r, t, scen), prob(scen)*(extra(r, t)*g(r)));
    
res_cons_scen(R, T)..
    sum(p, a(p, r)*x(p, t)) =l= b(r) + extra(r, t);
    
surplus_scen(P, T, scen)..
    over_scen(p, t, scen) =e= x(p, t) + over_scen(p, t-1, scen) + under_scen(p, t, scen) - d(p, t, scen);
    
model stochastic_soln / defobj_scen, res_cons_scen, surplus_scen /;

solve stochastic_soln using lp minimize cost_scen;
obj_stor('de') = cost_scen.l;

scen(s) = no;

parameter
obj_stor_scen(*);

loop(s,
    scen(s) = yes;
    solve stochastic_soln using lp minimize cost_scen;
    obj_stor_scen(s) = cost_scen.l;
    scen(s) = no;
);

x.fx(p, t) = x_stor(p, t);
scen(s) = yes;
solve stochastic_soln using lp minimize cost_scen;
obj_stor('mean') = cost_scen.l;

parameter evpi, vss;
evpi = obj_stor('de') - sum(s, obj_stor_scen(s));
vss = obj_stor('mean') - obj_stor('de');

display evpi, vss, obj_stor;







