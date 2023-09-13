option limrow=0, limcol=0;

set P / p1, p2 /;
set W / w1, w2, w3 /;

parameters
    h(P, W)
    / p1.w1 5, p1.w2 9, p1.w3 7,
      p2.w1 10, p2.w2 2, p2.w3 5 /
    s(P) / p1 108, p2 84 /
    m(P) / p1 10, p2 8 /;

scalar
    hMax /40/
    lCost /5/;

positive variable make(P, W);
variable Profit;
equation obj, workshops;

obj..
    Profit =e= sum((P, W), s(P)*make(P, W)) - lCost*sum((P, W), m(P)*make(P, W));
    
workshops(W)..
    sum(P, h(P, W)*make(P, W)) =l= hMax;

model prodmix /all/;

solve prodmix using lp maximize Profit;

display Profit.l, make.l;