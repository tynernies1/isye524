set node Locations /1*10/;
alias(node, i, j, P);

parameter
require(node) Required Brooms / 1 10, 2 6, 3 8, 4 11, 5 9, 6 7, 7 15, 8 7, 9 9, 10 12 /,
current(node) Current Brooms / 1 8, 2 13, 3 4, 4 8, 5 12, 6 2, 7 14, 8 11, 9 15, 10 7 /,
x(node) x-coordinates / 1 0, 2 20, 3 18, 4 30, 5 35, 6 33, 7 5, 8 5, 9 11, 10 2 /,
y(node) y-coordinates / 1 0, 2 20, 3 10, 4 12, 5 0, 6 25, 7 27, 8 10, 9 0, 10 15 /
d(node, node);

scalar
trns_cost / [1/2] /;

* Calculating distance matrix for all arcs (x, y) in A
loop
((i, j),
    d(i, j) = sqrt(sqr(x(j)-x(i)) + sqr(y(j)-y(i)));
);

* Defining dynamic set arc for bringing in "legal" arcs (distances) -- all legal except distances between same node (i.e. d(1, 1) = 0)
set arc(node, node);
arc(i, j) = yes$(d(i, j) > 0);
display arc;
positive variable
flow(node, node);

variable
cost;

equations 
obj, flow_bal, restrict;

obj..
cost =e= sum(arc, trns_cost*d(arc)*flow(arc));

flow_bal(i)..
sum(arc(i, j), flow(arc))- sum(arc(j, i), flow(arc)) + current(i) =e= require(i);

restrict(i)..
sum(arc(j, i), flow(arc)) =l= current(i);

model brooms / all /;

solve brooms using lp minimize cost;

parameter transportCost ;
transportCost = cost.L;
display transportCost;

set
not_min_distance(node, node),
test(node, node),
extra_brooms(node);

parameter min_distance(node);


min_distance(i) = smin(j$arc(i,j), d(i, j));
not_min_distance(i, j)$(arc(i,j) and d(i, j) ne min_distance(i)) = yes;

extra_brooms(i) = yes$(sum(j$not_min_distance(j, i), flow.L(j, i) > 0));

option extra_brooms:0:0:1;
display extra_brooms, flow.l, not_min_distance, min_distance;






















