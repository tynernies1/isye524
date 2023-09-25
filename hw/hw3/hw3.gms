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
i(D, M)
          A       B
March   200      40
April   130      15;

positive variable
water(D, M) Amount of Water (in KAF),
normal_power(D, M) Amount of Power <= 50000 MWH,
excess_power(D, M) Amount of Power > 50000 MWH,
outflow(D, M) Outflow of Water (in KAF),
spill(D, M) Spill Water (in KAF);

variable Profit;

equations
obj, normal_power_eq, excess_power_eq,bal_cons_A, bal_cons_B,
plant_cap, dam_cap, dam_min;

obj..
Profit =e= sum((D, M), Profit_Normal*normal_power(D, M) + Profit_Excess*excess_power(D, M));

normal_power_eq(D, M)..
normal_power(D, M) =e= W(D)*water(D, M);

excess_power_eq(D, M)..
excess_power(D, M) =e= W(D)*water(D, M) - Normal_Capacity;

bal_cons_A(M)..
water('A', M) =e= water('A', (M-1)) + i('A', M) - (outflow('A', M)+spill('A', M));

bal_cons_B(M)..
water('B', M) =e= water('B', (M-1)) + i('B', M) - ((outflow('B', M) - outflow('A', M)) + (spill('B', M)) - spill('A', M));

plant_cap(D, M)..
normal_power(D, M) + excess_power(D, M) =l= P(D);

dam_cap(D, M)..
water(D, M) =l= U(D);

dam_min(D, M)
water(D, M) =g= L(D);

model hydro / all /;

normal_power.up('A', 'March') = Normal_Capacity;
normal_power.up('B', 'April') = Normal_Capacity;
normal_power.up('A', 'April') = Normal_Capacity;
normal_power.up('B', 'April') = Normal_Capacity;

solve hydro using lp maximize Profit;







