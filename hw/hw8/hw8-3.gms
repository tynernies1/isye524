$if not set N $set N 50
$eval NM1 %N%-1

set t times /0*%N%/;
set i /x,y,dx,dy/;
alias(i,j);

set ct(t) control times /0*%NM1%/;

display ct;

parameter A(i,j) /x.x 1, x.y -0.1, y.x -0.5, y.y 0.5, dx.dx 0.1,
dx.dy -1.1, dy.dx 0.5, dy.y -0.5/,
b(i) /x 1, y 1, dx 1, dy 1/,
xdes(i) /x -5, y 2, dx 0, dy 0 /;

variables
x(t, i), u(t), z(t), totfuel;

equations
obj, absp1, absn1, absp2, absn2, lin_recur;

obj..
totfuel =e= sum(ct, z(ct));

absp1(t)..
z(t) =g= u(t);

absn1(t)..
z(t) =g= -u(t);

absp2(t)..
z(t) =g= 2*u(t) - 1;

absn2(t)..
z(t) =g= -2*u(t) - 1;

lin_recur(t, i)$(ord(t) < card(t))..
x(t+1, i) =e= sum(j, A(i, j)*x(t, j)) + b(i)*u(t);

x.fx('0', i) = 0;
x.fx('%N%', i) = xdes(i);

model fuel / all /;

solve fuel using lp minimize totfuel;

