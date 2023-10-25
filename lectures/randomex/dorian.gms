$title Dorian Auto example: Either-Or constraints (p. 471, Winston)

$ontext

Dorian Auto is considering manufacturing three types of autos: 
compact, midsize and large.  The resources required for, and the 
profits yielded by, each type of car are shown below.
At present 6,000 tons of steel and 60,000 hours of labor are avaiable.
In order for production of a type of car to be economically feasible, at 
least 1,000 cars of that type must be produced.  
Formulate an IP to maximize Dorian's profit.

$offtext

set type /compact, midsize, tank/;
set ingredients /labor  "in hours"
	       steel  "in tons"/;
table resources(ingredients,type)
      compact   midsize   tank
steel  1.5        3        5
labor  30         25       40;

parameter profit(type) / compact 2, midsize 3, tank 4/;

parameter available(ingredients) / steel 6000, labor 60000/;

* minimum amount of a car to be produced, for viability
scalar carsRequired / 1000 / 
       bigM         / 3000 /;

integer variables cars(type)   "how many cars of this type";
cars.lo(type)=0;
cars.up(type)=bigM;
variable totalProfit;
binary variable produce(type)  "produce this type of car";

equations
	EQeither(type)   "either constraint"
	EQor(type)       "or constraint"
	resourceConstraint
	objective;

EQeither(type)..
	cars(type) =l= bigM*produce(type);
	
EQor(type)..
	carsRequired - cars(type) =l= bigM*(1-produce(type));

resourceConstraint(ingredients)..
	sum(type,resources(ingredients,type)*cars(type)) =l= 
	         available(ingredients);

objective..
	totalProfit =e= sum(type,profit(type)*cars(type));

model dorian/EQeither, EQor, resourceConstraint, objective/;

option limrow=0, limcol=0;
dorian.optcr=0;

solve dorian using mip maximizing totalProfit;

