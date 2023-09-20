option limrow=0, limcol=0;

set S Sites / s1, s2, s3, s4 /;
set T Tree Types / Pine, Spruce, Walnut, Hardwood /;


parameters
A(S) Area Available / s1 1500, s2 1700, s3 900, s4 600 / 
M(T) Resources Available / Pine 22.5, Spruce 9, Walnut 4.8, Hardwood 3.5 / 
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

