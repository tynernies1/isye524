option limrow=0, limcol=0;

set I Items for Sale / bookcase, desk, chair, bedframe / ;
set R Requirements Needed / work, metal, wood /;

parameters 
p(I) Profit Margin / bookcase 19, desk 13, chair 12, bedframe 17 /
u(R) Amount Available Resources / work 225, metal 117, wood 420 /
n(I, R) Resource Requirement per Process Item ;

table
n(I, R)
            work      metal      wood
bookcase       3          1         4 
desk           2          1         3
chair          1          1         3
bedframe       2          1         4;

