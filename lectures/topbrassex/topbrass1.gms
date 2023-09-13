positive variable f "num football trophies", s "num soccer trophies";
variable p;

equation profit, plaq, wood;

* objective function
profit..
    p =e= 12*f + 9*s;
    
* plaque constraint
plaq..
    f + s =l= 1750;

* wood constraint
wood..
   4*f + 2*s =l= 4800;
   
* run model using all constraints listed above
model topbrass /all/;

* upper constraint on number of football and soccer trophies
f.up = 1000;
s.up = 1500;


solve topbrass using lp maximize p;