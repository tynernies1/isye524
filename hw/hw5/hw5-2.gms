set P Personnel / 2*7 /
M Months / Feb, Mar, Apr, May, Jun, Jul, Aug, Sep /
nodes(P, M) Nodes;

alias(P, Q), (M, N), (nodes, I, J);

parameters
supply(P, M) / 3.Feb 1, 3.Sep -1 /
require(M) / Feb 3, Mar 4, Apr 6, May 7, Jun 4, Jul 6, Aug 2, Sep 3  /
low_nodes(M) / Feb 3, Mar 3, Apr 5, May 6, Jun 3, Jul 5, Aug 2, Sep 3 /
high_nodes(M) / Feb 3, Mar 7, Apr 7, May 7, Jun 6, Jul 7, Aug 5, Sep 3 / 
;

scalar
ot_pct / [1/4] /
max_loss / [1/3] /
hire_cost / 100 /
redeploy_cost / 160 /
shortage_surplus_cost / 200 /;

nodes(P, M) = yes$(ord(P)+1 le high_nodes(M) and ord(P)+1 ge low_nodes(M));

set arcs(P, M, Q, N);

arcs(P, M, Q, N) = yes$((ord(M) + 1 = ord(N)) and nodes(P, M) and nodes(P, N));

display nodes, arcs;

parameter
cost(P, M, Q, N);
 
cost(P, M, Q, N) = hire_cost*(ord(Q)-ord(P))$(ord(P) lt ord(Q))
                    + redeploy_cost*(ord(P) - ord(Q))$(ord(P) gt ord(Q))
                    + shortage_surplus_cost*(abs(ord(Q)+1 - require(N)))$(ord(Q)+1 ne require(N));
positive variable
flow(P, M, Q, N);

variable
totcost;

equations
obj, balance(P, M);

obj..
totcost =e= sum(arcs, cost(arcs)*flow(arcs));

balance(I)..
sum(arcs(I, J), flow(I, J)) - sum(arcs(J, I), flow(J, I)) =e= supply(I);

model short / all /;

solve short using lp min totcost;

option flow:0:0:1;
display flow.l;

parameter workers(M) 'Number of workers in each month';

*workers(M) = flow.l();

*display workers;

$onecho > cplex.opt
lpmethod 3
netfind 2
preind 0
$offecho
short.optfile = 1;










