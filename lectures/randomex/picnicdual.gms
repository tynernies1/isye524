$title max flow problem

$ontext
The Hatfields, Montagues, McCoys and Capulets are going on their annual
family picnic.  Four cars are available to transport the families to
the picnic.  The cars can carry the following numbers of people:
car 1, 4; car 2, 3; car 3, 3; car 4, 4.
There are four people in each family, and no car can carry more than two
people from any one family.  Determine the maximum number of people that 
can be transported to the picnic.
$offtext

*** DATA SECTION

set nodes /s,hatfield,montague,mccoy,capulet,car1*car4,t/;
alias(i,j,k,nodes);
set family(nodes) /hatfield,montague,mccoy,capulet/;
set car(nodes) /car1*car4/;

set arcs(i,j);
arcs('s',family) = yes;
arcs(family,car) = yes;
arcs(car,'t') = yes;

parameter cap(car) /car1 4, car2 3, car3 3, car4 4/;
parameter famsize(family);
famsize(family) = 4;
* famsize('hatfield') = 1;  famsize('capulet') = 2;
parameter perFam(family);
perFam(family) = 2;

parameter u(i,j);
u('s',family) = famsize(family);
u(family,car) = perFam(family);
u(car,'t') = cap(car);
 
*** MODEL SECTION

positive variables
    x(i,j)    Number of people from family in car;

variable totgo total people going to picnic;

equations
    defobj, balance(i);

defobj..
  totgo =e= sum(j$arcs('s',j), x('s',j));

balance(i)$(not (sameas(i,'s') or sameas(i,'t')))..
    sum(k$arcs(i,k), x(i,k)) 
    - sum(j$arcs(j,i), x(j,i)) =E= 0;

model maxflow /defobj,balance/;

x.up(arcs) = u(arcs);

* use network simplex method (in option file)
$onecho > cplex.opt
lpmethod 3
netfind 2
preind 0
$offecho
maxflow.optfile = 1;

solve maxflow using lp max totgo;

* Set up standard dual problem (see later)
* Assumes that pi(family,car) are duals on capacities

variable dualobj;
positive variables pi(i,j); 
variables phi(i);
equation def_dualobj, dualcons(i,j);

def_dualobj..
  dualobj =e= sum((i,j)$arcs(i,j), u(i,j)*pi(i,j));

dualcons(i,j)$arcs(i,j)..
  phi(i)$(not sameas(i,'s')) 
  + pi(i,j) 
  - phi(j)$(not sameas(j,'t')) =g= 1$sameas(i,'s');

model dualflow /def_dualobj, dualcons/;
option limrow = 100, limcol=0;
solve dualflow using lp min dualobj;
