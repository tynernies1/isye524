option limrow=0, limcol=0;

parameters
    obj / "x1" 3, "x2" 4, "x3" -20 /
    a / "x1" 1, "x2" -4, "x3" 2 /
    b / "x1" 3, "x3" 6 /
    c / "x1" 5, "x2" -9 /;
scalar
    aMax /10/
    bMax /12/
    cMax /-3/;

positive variable x1, x2, x3;
variable o;
equation eq_obj, eq_a, eq_b, eq_c;

eq_obj..
    o =e=  obj('x1')*x1 + obj('x2')*x2 + obj('x3')*x3;
eq_a..
    a('x1')*x1 + a('x2')*x2 + a('x3')*x3 =l= aMax;
eq_b..
    b('x1')*x1 + b('x2')*x2 + b('x3')*x3 =l= bMax;
eq_c..
    c('x1')*x1 + c('x2')*x2 + c('x3')*x3 =l= cMax;
    
model warmup /all/;

solve warmup using lp minimize o;

parameter x1val, x2val, x3val, objval;

* parameterizing variables x1, x2 and x3
objval = o.l;
x1val = x1.l;
x2val = x2.l;
x3val = x3.l;

display objval, x1val, x2val, x3val;
