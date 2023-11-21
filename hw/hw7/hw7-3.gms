set I /1*10/;

alias(I,J);

table clean(I,J)
    1       2       3       4       5       6       7       8       9       10
1   0       11      7       13      11      12      4       9       7       11
2   5       0       13      15      15      6       8       10      9       8
3   13      15      0       23      11      11      16      18      5       7
4   9       13      5       0       3       8       10      12      14      5
5   3       7       7       7       0       9       10      11      12      13
6   10      6       3       4       14      0       8       5       11      12
7   4       6       7       3       13      7       0       10      4       6
8   7       8       9       9       12      11      10      0       10      9
9   9       14      8       4       9       6       10      8       0       12
10  11      17      11      6       10      4       7       9       11      0
;
parameter dur(I) / 1 40, 2 35, 3 45, 4 32, 5 50, 6 42, 7 44, 8 30, 9 33, 10 55 /;

scalar
num_batches / 10 /;

binary variable
x(I, J) Edges traveled along;

positive variable
y(I) Relative Position of node i in I;

variable
obj Total time taken;

equations
obj_eq, assign_J, assign_I, subtour_elim;

obj_eq..
obj =e= sum((I, J), clean(I, J)*x(I, J)) + sum(I, dur(I));

assign_I(J)..
sum(I$(not sameas(I, J)), x(I, J)) =e= 1;

assign_J(I)..
sum(J$(not sameas(I, J)), x(I, J)) =e= 1;

subtour_elim(I, J)$(ord(I) ne 1 and ord(J) ne 1)..
y(I) - y(J) + 1 =l= (num_batches - 1)*(1 - x(I, J));

y.lo(I) = 2;
y.up(I) = num_batches;

model paint / all /;

solve paint using mip minimize obj;

parameter batchlength;

batchlength = obj.L;

parameter order(I) ;

loop(J,
    order(I)$(abs(y.L(J) - ord(I)) < 0.5) = ord(J);
);

display batchlength;
display order, y.l;

















