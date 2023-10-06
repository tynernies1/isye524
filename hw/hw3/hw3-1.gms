option limrow=0, limcol=0, solprint=off;

set T Investment Types / 1, 2, 3, 4 /;
set M Months / January, February, March, April, May /;
alias(M,J);

scalar
C0 Initial Cash / 400 /; 

parameters
I(M) Income Received / January 600, February 800, March 250, April 300, May 0 /
B(M) Bills Paid / January 700, February 500, March 600, April 250, May 0 /
R(T) Interest Rate / 1 0.0025, 2 0.0035, 3 0.004, 4 0.006 /;

positive variable
invest(M, T) Amount Invested,
cash(M) Cash on Hand;

variable
end_cash Cash in May;

equations
obj, bal_cons;

obj..
cash('May') =e= end_cash;

bal_cons(M)..
cash(M) =e= C0$(ord(M)=1) + cash(M-1) + I(M) - (B(M) + sum(T, invest(M, T))) + sum((J, T)$(ord(J)+ord(T)=ord(M)),((1+R(T))**ord(T))*invest(J, T));

model finco / all /;

solve finco using lp maximize end_cash;
display invest.l;
