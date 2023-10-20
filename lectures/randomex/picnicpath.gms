$title max flow problem

*** DATA SECTION

$if not set small $set small 1

$ontext
The Hatfields, Montagues, McCoys and Capulets are going on their annual
family picnic.  Four cars are available to transport the families to
the picnic.  The cars can carry the following numbers of people:
car 1, 4; car 2, 3; car 3, 3; car 4, 4.
There are four people in each family, and no car can carry more than two
people from any one family.  Determine the maximum number of people that 
can be transported to the picnic.
$offtext

$ifthene %small% == 1
option limrow = 10, limcol=0;
set nodes /s,hatfield,montague,mccoy,capulet,car1*car4,t/;
set family(nodes) /hatfield,montague,mccoy,capulet/;
set car(nodes) /car1*car4/;

parameter cap(car) /car1 4, car2 3, car3 3, car4 4/;
parameter famsize(family);
famsize(family) = 4;
parameter perFam(family);
perFam(family) = 2;
 
$else

* Try a big one?
option limrow=0, limcol=0, solprint=off;
set nodes /s,f1*f1000,c1*c1000,t/;
set family(nodes) /f1*f1000/;
set car(nodes) /c1*c1000/;
parameter cap(car);
parameter famsize(family);
parameter perFam(family);

cap(car) = round(uniform(2,5));
famSize(family) = max(1,round(normal(4,2)));
perFam(family) = 2;

$endif

alias(i,j,k,nodes);
set arcs(i,j);
arcs('s',family) = yes;
arcs(family,car) = yes;
arcs(car,'t') = yes;

parameter u(i,j);
u('s',family) = famsize(family);
u(family,car) = perFam(family);
u(car,'t') = cap(car);

* Each path is indexed by a (family,car) pair
* a path = source -> family -> car -> sink

set p(i,j); p(family,car) = yes;
  
*** MODEL SECTION

positive variables
    f(nodes,nodes)    Flow on unique path through family and car;
variable totgo total people going to picnic;
equations defobj, linkb(i,j);

defobj..
  totgo =e= sum(p, f(p));

linkb(i,j)$arcs(i,j)..
* path flow on arc from family i to car j
  f(i,j)$((not sameas(i,'s')) and (not sameas(j,'t')))
* all paths going through family j
  + sum(k$arcs(j,k), f(j,k))$sameas(i,'s')
* all paths using car i
   + sum(k$arcs(k,i), f(k,i))$sameas(j,'t')
  =l= u(i,j);
  
model pflow / defobj, linkb /;
solve pflow using lp max totgo;

variable dualobj;
positive variables
  pi(i,j);
equation
  def_dualobj,
  dualcons(i,j) each path constraint;

def_dualobj..
  dualobj =e= sum(arcs(i,j), u(arcs)*pi(arcs));

dualcons(i,j)$p(i,j)..
  pi('s',i) + pi(i,j) + pi(j,'t') =g= 1;

model dualflow /def_dualobj, dualcons/;
solve dualflow using lp min dualobj;

* use network simplex method (in option file)
$onecho > cplex.opt
lpmethod 3
netfind 2
preind 0
$offecho