scalars
tool_change_tm / 6 /,
tool_change_cost / 87 /,
cost_per_min / [52/60] /,
tool_length / 42 /;

positive variables
N lathe revolutions per min (rpm),
f flow rate (in per rev);

variable
totcost;

equations
cost_eq;

cost_eq..
totcost =e= cost_per_min*(tool_length/(f*N)) + (tool_change_tm*cost_per_min + tool_change_cost)*((tool_length/(f*N)) / ((10/(N*(f**0.6)))**6.667));

N.lo = 200;
N.up = 600;
f.lo = 0.001;
f.up = 0.005;

model machine_wear / all /;
solve machine_wear using nlp minimize totcost;

display N.l, f.l, totcost.l;

