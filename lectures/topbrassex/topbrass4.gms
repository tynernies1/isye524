* defining a set that includes a collection of strings containing football and soccer
* {'football', 'soccer'}
* elements not defined are assigned initial values of 0
set I / football, soccer /;

* using symbolic constraints to make readability and understanding easier
* parameter: one of 3 ways of representing numbers symbolically, here parameterizing football and soccer info
parameters
    profitMargin(I) / "football" 12 , "soccer" 9 / 
    boardFeet(I) / "football" 4 , "soccer" 2 /
    plaques(I) / "football" 1 , "soccer" 1 /;

* another way of representing numbers symbolically, here representing upper limits on plaques and wood
scalar
    plaquesMax /1750/
    woodMax /4800/;
* one variable for every element in I
* use x('football') or x('soccer') to define decision variables in code below
positive variable x(I) "trophies";

variable p;

equation obj, plaq, wood;

* objective function
* summing over all elements of set I (football, soccer)
obj..
    p =e= sum(I, profitMargin(I)*x(I));
    
* plaque constraint
* using scalar defined above to replace upper constraint for plaques and wood
plaq..
    sum(I, plaques(I)*x(I)) =l= plaquesMax;

* wood constraint
wood..
   sum(I, boardFeet(I)*x(I)) =l= woodMax;
   
* run model using all constraints listed above
model topbrass /all/;

* upper constraint on number of football and soccer trophies
x.up('football') = 1000;
x.up('soccer') = 1500;


solve topbrass using lp maximize p;

* alias: alternative name for set that contains exact same elements
$ontext
alias (I,J);
parameter pct(I);
pct(I) = 100*x.l(I) / sum(J,x.l(J));
display pct;
$offtext