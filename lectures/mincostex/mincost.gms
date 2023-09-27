$title Min-Cost Network Flow (Williams, p.82)

option limrow=8, limcol=100, solprint=off;

set node /0*7/;
parameter supply(node) /0 10, 1 15, 5 -9, 6 -10, 7 -6/;
parameter cost(node,node) /
	  0.2   5
	  1.3   4
	  2.3   2
	  2.4   6
	  2.5   5
	  3.4   1
	  3.7	2
	  4.2	4
	  4.5	6
	  4.6	3
	  7.6	4
/;

alias (node,i,j,k);
abort$(smin((i,j), cost(i,j)) lt 0) "bad costs given";
abort$(sum(i, supply(i)) ne 0) "supply must equal demand";

* define a dynamic set that indicates the "legal" arcs
set arc(node,node);
arc(i,j) = yes$(cost(i,j) gt 0);

positive variable x(node,node) flow;
variable totalcost;

equations balance(node), objective;

balance(i)..
  sum(k$arc(i,k), x(i,k)) - sum(j$arc(j,i), x(j,i)) 
  =e= supply(i);

objective..
  totalcost =e= sum((i,j)$arc(i,j), cost(i,j)*x(i,j));

model mcf /balance, objective/;

solve mcf using lp minimizing totalcost;

option x:0:0:2; display x.l;

$onecho > cplex.opt
lpmethod 3
netfind 2
preind 0
names no
$offecho
