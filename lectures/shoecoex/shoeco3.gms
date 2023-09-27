$ontext
This is a continuation of shoeco2.gms
Now suppose we have demand scenarios Scen

Run using  
gams shoeco s=shoe
gams shoeco3 r=shoe
$offtext
$ontext

$ontext
Let's see how easy it is to do scenarios and minimax
Demand scenarios:  Minimax
$offtext

set Scen /1*3/;

table d2(T,Scen)
       1     2    3
Jan  3000  5000  1000
Feb  5000  3000  1000
Mar  2000  1000  5000
Apr  1000  2000  4000
;


positive variables
    I2(T,Scen)    Inventory in scenario
    L2(T,Scen)    Leftover inventory in scenario
    S2(T,Scen)    Shortage inventory in scenario
;

free variable z Auxiliary var for maximum;


equations
    BacklogDef2_eq(T,Scen)
    zdef_eq(Scen)
    BalShoe2_eq(T,Scen)
;

scalar  theta   Backlog cost;
theta = 20;

I2.lo(T,Scen) = -inf;
I2.lo("Apr",Scen) = 0;

zdef_eq(Scen)..
    z =G= sum(T, delta*x(T) + alpha * w(T) + beta * o(T) + eta * h(T) +
                    zeta * f(T)  + iota * L2(T,Scen) + theta * S2(T,Scen));


BacklogDef2_eq(T,Scen)..
    I2(T,Scen) =E= L2(T,Scen) - S2(T,Scen)    ;

BalShoe2_eq(T,Scen)..
    I0$(Ord(T) = 1) + I2(T-1,Scen) + x(T) =E= d2(T,Scen) + I2(T,Scen) ;

model minimax  / RegLabor_eq, OverLabor_eq,
    BalShoe2_eq, BalPeople_eq, BacklogDef2_eq,
    zdef_eq /;

solve minimax using lp minimizing z;

