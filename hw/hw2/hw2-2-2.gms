*$include hw2-2-2.inc
option limrow=0, limcol=0;

set I Items for Sale / bookcase, desk, chair, bedframe, coffee_table / ;
set R Requirements Needed / work, metal, wood /;

parameters 
p(I) Profit Margin / bookcase 19, desk 15, chair 12, bedframe 17 /
u(R) Amount Available Resources / work 225, metal 125, wood 420 /
n(I, R) Resource Requirement per Process Item ;

table
n(I, R)
            work      metal      wood
bookcase       3          1         4 
desk           2          1         3
chair          1          1         3
bedframe       2          1         4
coffee_table   3          1         2;

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