$title Sequencing on a single machine (Xpress Models: pp 128-132)

$ontext
A set of tasks is to be processed on a single machine.
The execution of the tasks is non-preemptive (ie cannot be interrupted).
For every task i its release date, duration and due date are given.

What is the sequence that minimizes the maximum tardiness?

This formulation uses rank and binary variables
$offtext

$if not set data $set data simple

$ifthen %data%==simple
set job / 1*7 /;
set times /release,duration,due/;

table data(times,job)
		1	2	3	4	5	6	7
release		2	5	4			8	9
duration	5	6	8	4	2	4	2
due		10	21	15	10	5	15	22
;
set k 'position' / p1*p7 /;
$else
set job(*), times(*), k(*);
parameter data(times,job);
$gdxLoad scheddata.gdx job times data k
$endif

* For comparison with sequence5.gms
* data('release',job) = 0;

alias (job,i,j);

sos1 variable rank(j,k) "job j has position k";
positive variables comp(k) "completion time of job in position k";
variable tardiness 'maximum tardiness';
* variable lateness;

equations
  oneInPosition(k), oneRankPer(j), defrelease(k),
  defcomp(k), deftardiness(k);

oneInPosition(k)..
  sum(i,rank(i,k)) =e= 1;

oneRankPer(i)..
  sum(k,rank(i,k)) =e= 1;

defrelease(k)..
  comp(k) =g= sum(j,(data('duration',j)+data('release',j))*rank(j,k));

defcomp(k)..
  comp(k) =g= comp(k-1) + sum(j,data('duration',j)*rank(j,k));

deftardiness(k)..
  tardiness =g= comp(k) - sum(j,data('due',j)*rank(j,k));

model sequence /all/;
sequence.optcr = 0;
sequence.threads = 3;
sequence.reslim = 120;

* This is really max(0, comp(k) - sum(j,...))
tardiness.lo = 0;

solve sequence using mip min tardiness;

* How to find start and comp times for jobs j (not positions k)
parameter startt(j), compt(j),tardt(j);
compt(j) = sum(k$rank.l(j,k), comp.l(k));
tardt(j) = max(0,compt(j) - data('due',j));
startt(j) = compt(j) - data('duration',j);
display startt, compt, tardt;
