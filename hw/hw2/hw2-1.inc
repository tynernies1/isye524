option limrow=0, limcol=0;

set C / c1, c2 /;
set R / r1, r2, f /;
set P / p1, p2, p3 /;

parameters 
u(R) Resources Available / r1 200, r2 400, f 1850 / 
q(P, R) Resource Requirement per Process Unit Time
o(P, C) Chemical Output per Process Unit Time

scalar
b / [2/5] /;

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


