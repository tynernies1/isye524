option limrow=0, limcol=0;

set D Dams / A, B /;
set M Months / March, April /;


scalars
Profit_Normal / 5 /
Profit_Excess / 3.5 /
Normal_Capacity / 50000 /;


parameters
U(D) Storage Capacity / A 2000, B 1500 /
L(D) Minimum Allowable Level / A 1200, B 800 /
W(D) Water Power Conversion / A 400, B 200 /
P(D) Power Plant Capacity / A 60000, B 35000 /
I(D) Initial Inventory / A 1900, B 850 /;

table
inflow(D, M)
        March       April
A         200         130
B          40          15;

positive variable
water(D, M) Amount of Water (in KAF),
normal_power(M) Amount of Power <= 50000 MWH,
excess_power(M) Amount of Power > 50000 MWH,
outflow(D, M) Outflow of Water (in KAF),
spill(D, M) Spill Water (in KAF),
total_power(D, M) Total Power (in MWH);

variable Profit;

equations
obj, power_eq, water_bal_cons, total_power_bal_cons, plant_cap;

obj..
Profit =e= sum(M, Profit_Normal*normal_power(M)+ Profit_Excess*excess_power(M));

power_eq(D, M)..
total_power(D, M) =e= W(D)*outflow(D, M);

total_power_bal_cons(M)..
sum(D, total_power(D, M)) =e= normal_power(M) + excess_power(M);

water_bal_cons(D, M)..
water(D, M) =e= I(D)$(ord(M)=1) + water(D, M-1) + inflow(D, M) - ((outflow(D, M) - outflow(D-1, M)) + spill(D-1, M) - spill(D-1, M));

plant_cap(D, M)..
total_power(D, M) =l= P(D);

model hydro / all /;

water.up(D, M) = U(D);
water.lo(D, M) = L(D);
normal_power.up(M) = Normal_Capacity;

solve hydro using lp maximize Profit;

display spill.l, total_power.l, excess_power.l;





