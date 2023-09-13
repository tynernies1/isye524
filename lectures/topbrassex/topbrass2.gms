* defining a set that includes a collection of strings containing football and soccer
* {'football', 'soccer'}
set I / football, soccer /;

* one variable for every element in I
* use x('football') or x('soccer') to define decision variables in code below
positive variable x(I) "trophies";

variable p;

equation profit, plaq, wood;

* objective function
profit..
    p =e= 12*x('football') + 9*x('soccer');
    
* plaque constraint
plaq..
    x('football') + x('soccer') =l= 1750;

* wood constraint
wood..
   4*x('football') + 2*x('soccer') =l= 4800;
   
* run model using all constraints listed above
model topbrass /all/;

* upper constraint on number of football and soccer trophies
x('football').up = 1000;
x('soccer').up = 1500;


solve topbrass using lp maximize p;