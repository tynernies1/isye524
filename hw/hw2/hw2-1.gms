*$include hw2-1.inc
option limrow=0, limcol=0, lp=cplex;

set C / c1, c2 /;
set R / r1, r2, f /;
set P / p1, p2, p3 /;

parameters 
u(R) Resources Available / r1 200, r2 400, f 1850 /
b(C) Ratio of Chemicals / c1 5, c2 2 /
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
variable blend;
equation obj, res_con;

obj..
blend =e= sum((P, C), b(C)*o(P, C)*x(P));

res_con(R)..
sum(P, q(P, R)*x(P)) =l= u(R);

model chemmod /all/;

solve chemmod using lp maximize blend;

scalars mstat, sstat;
parameter proctime;

mstat = chemmod.modelstat;
sstat = chemmod.solvestat;
proctime = chemmod.etsolve 

display mstat, sstat, blend.l, proctime;
 