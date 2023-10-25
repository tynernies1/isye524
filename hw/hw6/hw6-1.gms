set O Options for Investing / 1*6 /;

parameter
min_inv(O) Min Invest / 1 3, 2 2, 3 9, 4 5, 5 12, 6 4 /
max_inv(O) Max Invest / 1 27, 2 12, 3 35, 4 15, 5 46, 6 18 /
return(O) ROI / 1 1.13, 2 1.09, 3 1.17, 4 1.10, 5 1.22, 6 1.12 /;

scalar
amt_on_hand / 80 /;

variable
z Total Profit;

positive variable
x(O) Amount to Invest;

binary variable
delta(O) Turn on variable;

equations
obj, total_cons, max_cons, min_cons, option5_cons, option3_cons;

obj..
z =e= sum(O, return(O)*x(O));

total_cons..
sum(O, x(O)) =l= amt_on_hand;

max_cons(O)..
x(O) =l= max_inv(O)*delta(O);

min_cons(O)..
x(O) =g= min_inv(O)*delta(O);

option5_cons..
x('2') + x('4') + x('6') =g= x('5');

option3_cons..
x('6') =l= max_inv('6')*delta('3');

model invest / all /;

option limrow=0, limcol=0;
invest.optcr=0;
invest.optca=0;

solve invest using mip maximize z;

parameter expectedReturn;

expectedReturn = z.L;
display expectedReturn;

set investments(O);

investments(O) = yes$(x.L(O) > 0.5);

options investments:0:0:1;
display investments;


 