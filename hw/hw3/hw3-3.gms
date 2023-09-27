set I Equations / 1*6 /;
set J Variables / x1*x4 /;

parameter
R(I) Right Hand Side Value / 1 17, 2 -16, 3 7, 4 -15, 5 6, 6 0 /;

table
coef(I, J)
        x1      x2      x3      x4
1       8       -2      4       -9
2       1       6       -1      -5
3       1       -1      1       0
4       1       2       -7      4
5       0       0       1       -1
6       1       0       1       -1;

positive variables
abs_err_pos(I) Positive Side Absolute Difference,
abs_err_neg(I) Negative Side Absolute Difference;

variables
ztotdev Sum of Absolute Errors,
zminmax Min Max Absolute Error,
x(J) Variables,
e(I) Absolute Differences;

equations
objtot, objminmax, abs_err_eq, abs_errs;

abs_err_eq(I)..
e(I) =e= sum(J, coef(I, J)*x(J)) - R(I);

abs_errs(I)..
e(I) =e= abs_err_pos(I) - abs_err_neg(I);

objtot..
ztotdev =e= sum(I, abs_err_pos(I)+abs_err_neg(I));

objminmax(I)..
zminmax =e= abs_err_pos(I)+abs_err_neg(I);

model abs_err_tot / objtot, abs_err_eq, abs_errs /;

solve abs_err_tot using lp minimize ztotdev;

parameters TotalDevSmall, xValSmall(J);

TotalDevSmall = ztotdev.L ;
xValSmall(J) = x.L(J);

display TotalDevSmall, xValSmall;

model minmax / objminmax, abs_err_eq, abs_errs /;

solve minmax using lp minimize zminmax;

parameters MinMaxDevSmall;

MinMaxDevSmall = zminmax.L;

display MinMaxDevSmall;



