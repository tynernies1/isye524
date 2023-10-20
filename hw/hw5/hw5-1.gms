set nodes / s, m1*m4, p1*p3, t /
projects(nodes) / p1*p3 /
months(nodes) / m1*m4 /;

alias(nodes, i, j, k);

parameters
worker_months(projects) / p1 8, p2 10, p3 12 /
months_done(projects) / p1 3, p2 4, p3 2 /;

scalars
workers_available / 8 /
job_workers / 6 /; 

set arcs(nodes, nodes);
arcs('s', months) = yes;
arcs(months, projects) = yes$(ord(months) le months_done(projects));
arcs(projects, 't') = yes;

parameter
u(i, j);
u('s', months) = workers_available;
u(months, projects)$arcs(months, projects) = job_workers;
u(projects, 't') = worker_months(projects);

display arcs, u;

positive variable
flow(nodes, nodes);

variable
totflow;

equations
obj, balance;

obj..
totflow =e= sum(arcs(months, projects), flow(arcs));

balance(i, j)$(arcs(i, j))..
flow(i, j)$((not sameas(i, 's')) and (not sameas(j, 't')))
+ sum(k$arcs(j, k), flow(j, k))$sameas(i, 's')
+ sum(k$arcs(k, i), flow(k, i))$sameas(j, 't') =l= u(i, j);

model construction_max / obj, balance /;

solve construction_max using lp max totflow;
option flow:0:1:1;
display flow.l;

variable dualobj;

positive variable
pi(i, j);

equations
dual_obj_eq, dual_cons;

dual_obj_eq..
dualobj =e= sum(arcs(i, j), u(i, j)*pi(i, j));

dual_cons(i, j)$(arcs(i, j))..
pi('s', i) + pi(i, j) + pi(j, 't') =g= 1;

model construction_dual / dual_obj_eq, dual_cons /;

solve construction_dual using lp min dualobj;
option pi:2:0:1;
display dualobj.l, pi.l;
















 