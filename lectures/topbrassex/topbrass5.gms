* GENERAL/ABSTRACT MODEL FOR TOPBRASS

* 
option limrow=0, limcol=0;

* defining a set that includes a collection of strings containing football and soccer {'football', 'soccer'}
* elements not defined are assigned initial values of 0
set I / football, soccer /;

* defining a second set that includes the resources needed to make trophies {plaques, wood}
set R / plaques, wood /;

* using symbolic constraints to make readability and understanding easier
* parameter: one of 3 ways of representing numbers symbolically, here parameterizing football and soccer info
* additionally, parameterizing upper limits of each resource used in trophy production
parameters
    c(I) / "football" 12 , "soccer" 9 / 
    b(R) / "plaques" 1750 , "wood" 4800 /
    u(I) / "football" 1000 , "soccer" 1500 /;
    
* table: another way of representing numbers symbolically; data in table must be two dimensional, similar to a matrix
table a(R, I) Per-Unit resource requirements
        football    soccer
plaques   1           1
wood      4           2;

display c,a;

* one variable for every element in I
* use x('football') or x('soccer') to define decision variables in code below
positive variable x(I) trophies;

free variable profit total profit;

equations obj max total profit, resource_con(R) resource constraints;

* objective function
* summing over all elements of set I (football, soccer)
obj..
    profit =e= sum(I, c(I)*x(I));
    
* resource constraint
* resource_con(R) iterates over all instances of set R to generate all constraints related to resource constraints (1 constraint instead of 2)
* using parameter b(R) defined above to replace upper constraint for plaques and wood
resource_con(R)..
    sum(I, a(R, I)*x(I)) =l= b(R);

   
* run model using all constraints listed above
model topbrass /all/;

* upper constraint on number of football and soccer trophies
x.up(I) = u(I);

* solve model using linear programming and maximize objective in this case 
solve topbrass using lp maximize profit;
