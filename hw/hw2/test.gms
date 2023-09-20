positive variable x1, x2, x3;
variable blend;
equations obj, r1, r2, r3;

obj..
blend =e= 5*(9x1+7x2+10x3) + 2*(6x1+10x2+6x3);

r1..
9x1+6x2+4x3=l=200;

r2..
5x1+8x2+11x3 =l=400;

r3..
50x1+75x2+100x3=l=1850;

model chemmod /all/;

solve chemmod using lp maximize blend;
