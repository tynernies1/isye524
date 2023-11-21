sets part / p1*p3 /
oper / o1*o8 /
machine / m1, m2 /
;

alias(oper, oi, oj);
alias(part, pj, pk);
alias(machine, m);

set task(part, oper) /
p1.o1, p1.o2, p2.o3, p2.o4, p2.o5, p3.o6, p3.o7, p3.o8 /;

parameter procdata(part,oper,machine) /
p1.o1.m1 4
p1.o2.m2 2
p2.o3.m2 3
p2.o4.m1 2
p2.o5.m1 2
p3.o6.m2 3
p3.o7.m1 2
p3.o8.m2 1
/;

scalar bigm;
bigm  = sum((part, oper, machine), procdata(part, oper, machine));

set okmach(part, oper, machine);

okmach(part, oper, m) = yes$(procdata(part, oper, m) gt 0);

binary variable
x(m, pj, oi, pk, oj), y(part, oper, oper);

positive variable
start(part, oper, machine);

variable
makespan;

equations
obj, either_machord, or_machord, either_partord, or_partord, p1cons, p2cons, p3cons, p4cons;

obj(part, oper, machine)..
makespan =g= start(part, oper, machine) + procdata(part, oper, machine);

either_machord(m, pj, oi, pk, oj)$(okmach(pj, oi, m) and okmach(pk, oj, m) and not sameas(oi, oj))..
start(pj, oi, m) + procdata(pj, oi, m) =l= start(pk, oj, m) + bigm*(1 - x(m, pj, oi, pk, oj));
    
or_machord(m, pj, oi, pk, oj)$(okmach(pj, oi, m) and okmach(pk, oj, m) and not sameas(oi, oj))..
start(pk, oj, m) + procdata(pk, oj, m) =l= start(pj, oi, m) + bigm*x(m, pj, oi, pk, oj);

either_partord(pj, oi, oj, m)$(task(pj, oi) and task(pj, oj) and not sameas(oi, oj))..
start(pj, oi, m) + procdata(pj, oi, m) =l= start(pj, oj, m) + bigm*(1 - y(pj, oi, oj));

or_partord(pk, oi, oj, m)$(task(pk, oi) and task(pk, oj) and not sameas(oi, oj))..
start(pk, oj, m) + procdata(pk, oj, m) =l= start(pk, oi, m) + bigm*y(pk, oi, oj);

p1cons..
start('p1', 'o1', 'm1') + procdata('p1', 'o1', 'm1') =l= start('p1', 'o2', 'm2');

p2cons..
start('p2', 'o3', 'm2') + procdata('p2', 'o3', 'm2') =l= start('p2', 'o5', 'm1');
    
p3cons..
start('p2', 'o4', 'm1') + procdata('p2', 'o4', 'm1') =l= start('p2', 'o5', 'm1');
    
p4cons..
start('p3', 'o7', 'm1') + procdata('p3', 'o7', 'm1') =l= start('p3', 'o8', 'm1');

model machines / all /;

solve machines using mip minimize makespan;

option makespan:1,start:1:0:1;
display makespan.l, start.l;



