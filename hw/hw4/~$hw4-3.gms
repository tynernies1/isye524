set node Airports / MSN, ORD, MSP, DTW, SFO, IAH, DCA, MCO /
destination(node) Destination Airports / SFO, IAH, DCA, MCO /
origin(node) Origin Airport / MSN /
hub(node) Hub Airports / ORD, MSP, DTW /;
alias(node, i, j, k);

parameter
supply(node) Supply at node / MSN 12, ORD 0, MSP 0, DTW 0, SFO -3, IAH -3, DCA -3, MCO -3 /,

flight_time(node, node) Flight Times / MSN.ORD 22, MSN.DTW 65, MSN.MSP 46,
MSP.SFO 213, MSP.IAH 139, MSP.DCA 125, MSP.MCO 176,
ORD.SFO 247, ORD.IAH 124, ORD.DCA 82, ORD.MCO 135,
DTW.SFO 280, DTW.IAH 147, DTW.DCA 53, DTW.MCO 130 /,

delay(node) Delay;

delay('ORD') = 180;
delay('MSP') = 120;
delay('DTW') = 90;

set arc(node, node) Arcs;

positive variable
flow(node, node) Flow;

variable
time;

equations obj, balance(node);

obj..
time =e= sum(arc(i, j), (flight_time(arc) + delay(i))*flow(arc));

balance(i)..
sum(arc(i, j), flow(arc)) - sum(arc(k, i), flow(arc)) =e= supply(i);

model flights / all /;
set A Airlines / United, Delta_MSP, Delta_DTW, Delta_All, All /;
parameter times(*);

loop(A,
    hub(node) = no;
    arc(i, j) = no;

    if(ord(A) = 1,
        hub('ORD') = yes;);
    if(ord(A) = 2,
        hub('MSP') = yes;);
    if(ord(A) = 3,
        hub('DTW') = yes;);
    if(ord(A) = 4,
        hub('DTW') = yes;
        hub('MSP') = yes;);
    if(ord(A) = 5,
        hub('DTW') = yes;
        hub('MSP') = yes;
        hub('ORD') = yes;);
    arc(i, j)$(origin(i) and hub(j)) = yes;
    arc(i, j)$(hub(i) and destination(j)) = yes;
    solve flights using lp minimize time;
    times(A) = time.l;
);

$onText
Question 3.1:
Professor Wright should switch to Delta because the flights using United takes 4188 minutes and the flights using Delta takes 3522 minutes.
I deal with the uncertainties in the delays at the hubs by choosing to use the worst case scenario, meaning I choose the highest possible delay time at each hub (180 for ORD, 120 for MSP, and 90 for DTW).

Question 3.2:
If we add the constraint that Professor Wright must always use the same hub, he would still choose to fly Delta because using United takes 4188 minutes and using Delta from hub DTW takes 3690 minutes.

Question 3.3:
If Professor Wright chooses to use both United and Delta, he should still fly only Delta going through MSP and DTW. He will fly to SFO through MSP will fly to MCO, IAH, DCA through DTW.
$offText

display times, flow.l;