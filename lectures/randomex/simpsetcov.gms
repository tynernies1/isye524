$title Simple set covering example

option limcol=0;
$ontext 
From lecture 21.
$offtext

set s "base set" /a,b,c,d,e,f/;
set j "index of subsets" /1*5/;
alias (s,i);

set cover(i,j) "item i is covered by set j" /
  (a,b).1,
  (a,c,e).2,
  (a,b,d,e).3,
  (d,e).4,
  (c,f).5
/;

* following lines show alternative using matrix A
parameter A(i,j);
A(i,j) = 1$cover(i,j);

binary variables x(j);
variable totalUsed;

equation coverConstraint(i), objective;

objective..
	totalUsed =e= sum(j, x(j));

coverConstraint(i)..
	sum(j$cover(i,j), x(j)) =g= 1;
*	sum(j, A(i,j)*x(j)) =g= 1;

model setcover /all/;

* any optimum within <1 of the true optimum must BE the true optimum!
setcover.optca = 0.999;
solve setcover using mip minimizing totalUsed;
