*$include hw2-3.inc
option limrow=0, limcol=0;

set S Sites / s1, s2, s3, s4 /;
set T Tree Types / Pine, Spruce, Walnut, Hardwood /;


parameters
A(S) Area Available / s1 1500, s2 1700, s3 900, s4 600 / 
M(T) Resources Available / Pine 22500, Spruce 9000, Walnut 4800, Hardwood 3500 / 
p(S, T) Profit Margin 
y(S, T) Expected Yield

table
y(S, T)
    Pine      Spruce      Walnut    Hardwood
s1    17          14          10           9
s2    15          16          12          11
s3    13          12          14           8
s4    10          11           8           6;

table
p(S, T)
    Pine      Spruce      Walnut    Hardwood
s1    16          12          20          18
s2    14          13          24          20
s3    17          10          28          20
s4    12          11          18          17;

positive variable grow(S, T);
variable profit;
equation obj, yield_con, area_con;

obj..
profit =e= sum((S, T), p(S, T)*grow(S, T));

yield_con(T)..
sum(S, y(S, T)*grow(S, T)) =g= M(T);

area_con(S)..
sum(T, grow(S, T)) =l= A(S)

model forest /all/;

solve forest using lp maximize profit;

display profit.l, grow.l;