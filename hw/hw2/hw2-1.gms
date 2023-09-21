option limrow=0, limcol=0, lp=cplex;

set C Chemicals / c1, c2 /;
set R Requirements / r1, r2, f /;
set P Processes / p1, p2, p3 /;

parameters 
u(R) Resources Available / r1 200, r2 400, f 1850 /
b(C) Ratio of Chemicals / c1 [1/5], c2 [1/2] /
q(P, R) Resource Requirement per Process Unit Time
o(P, C) Chemical Output per Process Unit Time

table
q(P, R)
    r1      r2      f
p1   9       5      50 
p2   6       8      75
p3   4      11     100;

table
o(P, C)
    c1      c2
p1   9       6
p2   7      10
p3  10       6;

positive variable x(P);
variable blend, chem1_prd, chem2_prd;
equation res_con, chem1_eq, chem2_eq, limit_chem1_eq, limit_chem2_eq;

res_con(R)..
sum(P, q(P, R)*x(P)) =l= u(R);

* chemicals produced
chem1_eq..
chem1_prd =e= sum(P, o(P, 'c1')*x(P));

chem2_eq..
chem2_prd =e= sum(P, o(P, 'c2')*x(P));

* blending constraint 
limit_chem1_eq..
blend =l= b('c1')*chem1_prd;

limit_chem2_eq..
blend =l= b('c2')*chem2_prd;


model chemmod / all /;

solve chemmod using lp maximize blend;

scalars mstat, sstat;
parameter proctime(P);

mstat = chemmod.modelstat;
sstat = chemmod.solvestat;
proctime(P) = x.l(P);

display mstat, sstat, blend.l, proctime;
 