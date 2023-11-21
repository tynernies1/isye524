sets T, P, C(P), N(P);
parameters d(T), cost(P), ell(P), u(P);
$gdxin ucdata.gdx
$load T,P,C,N,d,cost,ell,u
$gdxin

binary variables
on(P, T), start(P, T), coal_2_on(T);

positive variable
power(P, T);

variable
obj;

equations
obj_eq, power_dmnd(T), on_cons1(N, T), on_cons2(N, T), on_cons3(N, T), on_cons4(N, T), coal_2_activate(T),
nuclear_3_on(T), max_pwr(P, T), min_pwr(P, T);

obj_eq..
obj =e= sum((P, T), cost(P)*power(P, T));

power_dmnd(T)..
sum(P, power(P, T)) =g= d(T);

on_cons1(N, T)..
on(N, T) =g= start(N, T);

on_cons2(N, T)..
start(N, T) + 2 =g= 1 + on(N, T) + (1 - on(N, T-1));

on_cons3(N, T)..
(1 - on(N, T-1)) =g= start(N, T);

*Making the assumption that we cannot turn a power plant on if there is less than 3 time periods left in total
on_cons4(N, T)$(card(T) - ord(T) ge 3)..
4 - on(N, T) - on(N, T+1) - on(N, T+2) - on(N, T+3) =l= 4*(1 - start(N, T));

coal_2_activate(T)..
sum(C, on(C, T)) - 1 =l= card(C)*coal_2_on(T);

nuclear_3_on(T)..
3 - sum(N, on(N, T)) =l= 3*(1 - coal_2_on(T));

max_pwr(P, T)..
power(P, T) =l= u(P)*on(P, T);

min_pwr(P, T)..
power(P, T) =g= ell(P)*on(P, T);

model nuclear / all /;

solve nuclear using mip minimize obj;

set oper(P,T);
oper(P, T) = on.l(P, T);

option oper:0:0:1;
display oper;









