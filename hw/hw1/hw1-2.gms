option limrow=0, limcol=0;

set I / malt, hops, yeast /;
set T / light, dark /;

parameters
    s(T, I)
    / light.malt 2, light.hops 3, light.yeast 2
      dark.malt 3, dark.hops 1, dark.yeast [5/3] /  
    p(T) / light 2, dark 1 /
    u(I) / malt 90, hops 40, yeast 80 /;

positive variable quant(T);
variable Profit;
equation eq_obj, eq_stock;

eq_obj..
    Profit =e= sum(T, p(T)*quant(T));
    
eq_stock(I)..
    sum(T, s(T,I)*quant(T)) =l= u(I);

model softsuds /all/;

solve softsuds using lp maximize Profit;

display Profit.l, quant.l;