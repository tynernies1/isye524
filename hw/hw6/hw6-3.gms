set S Sites / 1*7 /
C Communities / 1*15 /;

alias(S, I);
alias(C, J)

parameter
cost(S) / 1 1.8, 2 1.3, 3 4.0, 4 3.5, 5 3.8, 6 2.6, 7 2.1 /
inhabitants(C) / 1 2, 2 4, 3 13, 4 6, 5 9, 6 4, 7 8, 8 12, 9 10, 10 11, 11 6, 12 14, 13 9, 14 3, 15 6 /;

set
cover(S, C) / 1.(1,2,4), 2.(2,3,5), 3.(4,7,8,10), 4.(5,6,8,9), 5.(8,9,12), 6.(7,10,11,12,15), 7.(12,13,14,15) /;

display cover;

variable
pop_covered;

binary variable
x(S), covered(C);

equations
obj, cover_cons, budget_cons;

obj..
pop_covered =e= sum(J, inhabitants(J)*covered(J));

cover_cons(J)..
sum(I$(cover(I, J)), x(I)) =g= covered(J);

budget_cons..
sum(I, cost(I)*x(I)) =l= 10;

model dumbledore / all /;

option optcr = 0; option optca = 0;

solve dumbledore using mip maximize pop_covered;

set open(I);
open(I) = yes$(x.L(I) > 0.5);

option open:0:0:1;

display open, pop_covered.L;