* GENERAL/ABSTRACT MODEL FOR TOPBRASS

$include bigtopbrass-1.inc

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
