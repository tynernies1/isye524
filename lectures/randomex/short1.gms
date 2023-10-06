$title shortest path example with intervening lake (short1.gms)
* use highs to demonstrate non-uniqueness
* option lp = highs;

$ontext
     3    5
   
 
1         6      8


2    4    7
$offtext

*** DATA SECTION

option limrow=10,limcol=10;

set 
    nodes /node1*node8/
    coords /x,y/
    arcs(nodes,nodes) /
		      node1 . (node2,node3)
		      node2 . node4
		      node3 . node6
		      node4 . node7
		      node6 . node5 
		      node7 . node6
		      (node5, node6, node7) . node8/
    lakeCrossings(nodes,nodes) /
	        node4 . node7
		      node6 . node8
		      node7 . node6 /;

alias (i,j,nodes);

parameter supply(nodes) / node1 1, node8 -1/;

* check that lakeCrossings is a subset of arcs
set diff(nodes,nodes);
diff(i,j) = lakeCrossings(i,j) - arcs(i,j);
abort$(sum(diff,1)) "Lake Crossings must be a subset of Arcs";

table posn(nodes,coords)
        x      y
node1   0      1
node2   0      0
node3   1      2
node4   1      0
node5   2      2
node6   2      1
node7   2      0
node8   3      1;

* figure the distances
parameter distance(nodes, nodes);
distance(arcs(i,j)) = sqrt(sum(coords,sqr(posn(i,coords) - posn(j,coords))));

* double the distance if the route goes over a lake
distance(lakeCrossings) = 2*distance(lakeCrossings);

display distance;

*** MODEL SECTION

variables totalDistance;
positive variables x(nodes,nodes) flow;
equations balance(nodes), objective;

* remove redundant constraint to get unique multipliers
* balance(nodes)$(not sameas(nodes,'node8'))..
balance(nodes)..
  sum(arcs(nodes,j), x(nodes,j)) - sum(arcs(i,nodes), x(i,nodes)) 
    =e= supply(nodes);

objective..
  totalDistance =e= sum(arcs, distance(arcs) * x(arcs));

model short1/balance, objective/;

solve short1 minimizing totalDistance using lp;

*** POST PROCESSING

option x:5:0:2;
display x.l, totalDistance.l;

*** MODEL SECTION
* following sets up the dual problem (use later)

variable dualobj;
positive variables pi(i);
equation def_dualobj, dualcons(i,j);

def_dualobj..
  dualobj =e= sum(i, supply(i)*pi(i));

dualcons(i,j)$arcs(i,j)..
  pi(i) - pi(j) =l= distance(i,j);

model dualflow /def_dualobj, dualcons/;
* fix dual multiplier corresponding to dropped constraint
* pi.fx('node8') = 0;
solve dualflow using lp max dualobj;

*** POST PROCESSING
display balance.m, pi.l;
