$include hw2-2-1.inc

positive variable x(I);
variable Profit;
equation obj, res_con;

obj..
Profit =e= sum(I, p(I)*x(I));

res_con(R)..
sum(I, n(I, R)*x(I)) =l= u(R);

model woodcrafters /all/;

solve woodcrafters using lp maximize Profit;

display Profit.l, x.l;
 