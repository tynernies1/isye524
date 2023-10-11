set node Locations / MSN, ORD, MSP, DTW, SFO, IAH, DCA, MCO /
hub(node)
destination(node) / SFO, IAH, DCA, MCO /
origin(node) / MSN /;
alias(node, i, j);

parameter
supply(node) / MSN 12, ORD 0, MSP 0, DTW 0, SFO -3, IAH -3, DCA -3, MCO -3 /
delay(node);

delay('ORD') = uniform(0, 180);
delay('MSP') = uniform(0, 120);
delay('DTW') = uniform(0, 90);

table
flight_time(node, node)
     MSN    SFO     IAH     DCA     MCO
MSP  46     213     139     125     176
ORD  22     247     124      82     135
DTW  65     280     147      53     130
;

set arc(node, node);

positive variable
flow(node, node);

variable
time;

equations obj, balance;


obj..
time =e= sum(arc(i, j), flight_time(arc) + delay(i)*flow(arc));

balance(i)..
sum(arc(i, j), flow(arc)) - sum(arc(j, i), flow(arc)) =e= supply(i);

model flights / all /;

parameter times(*);

hub('ORD') = yes;
arc(i, j) = no;
arc(i, j)$(origin(i) and hub(j)) = yes;
arc(i, j)$(hub(i) and destination(j)) = yes;

solve flights using lp minimize time;
times('United') = time.l; 

hub(node) = no;
hub('MSP') = yes;
arc(i, j) = no;
arc(i, j)$(origin(i) and hub(j)) = yes;
arc(i, j)$(hub(i) and destination(j)) = yes;

solve flights using lp minimize time;
times('Delta_MSP') = time.l;

hub(node) = no;
hub('DTW') = yes;
arc(i, j) = no;
arc(i, j)$(origin(i) and hub(j)) = yes;
arc(i, j)$(hub(i) and destination(j)) = yes;

solve flights using lp minimize time;
times('Delta_DTW') = time.l;

hub(node) = no;
hub('MSP') = yes;
hub('DTW') = yes;
arc(i, j) = no;
arc(i, j)$(origin(i) and hub(j)) = yes;
arc(i, j)$(hub(i) and destination(j)) = yes;

solve flights using lp minimize time;
times('Delta_All') = time.l;

hub(node) = no;
hub('ORD') = yes;
hub('MSP') = yes;
hub('DTW') = yes;
arc(i, j) = no;
arc(i, j)$(origin(i) and hub(j)) = yes;
arc(i, j)$(hub(i) and destination(j)) = yes;


display arc, flight_time;

solve flights using lp minimize time;
times('All') = time.l;

display times;

