set type, I;
set T / t0*t59 /;
parameter data(type<,i<), p(I, T);
$gdxin wine.gdx
$load data
$gdxin

integer variable
x(I, T) Bottle i in I for week t in T;

variable
pleasure;

equations
obj, bottles, weeks;

* Pleasure dervied from drinking wine i in I in week t in T as a function of age
p(I, T) = (data('b', I)*((data('a', I)+(ord(T)-1))**3))-(data('c', I)*(data('a', I)+(ord(T)-1)));

obj..
pleasure =e= sum((I, T), p(I, T)*x(I, T));

bottles(I)..
sum(T, x(I, T)) =e= 1;

weeks(T)..
sum(I, x(I, T)) =e= 1;

model assign / all /;

solve assign using rmip maximize pleasure;

option x:0:0:2;

display x.l, pleasure.l;