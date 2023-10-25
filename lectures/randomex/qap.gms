$title  Different formulations of quadratic assignment problem

$ontext
$offtext

option seed = 612 ;
option optcr = 0.00001;

$setglobal NUMITEMS 8

set N /i1*i%NUMITEMS%/ ;

alias(N,L,F,F1,L1,F2,L2);

parameters
  dist(L,L)  Distance
  flow(F,F)  Flow

  xloc(L)   x location
  yloc(L)   y location

;

xloc(L) = uniform(-10,10) ;
yloc(L) = uniform(-10,10) ;
dist(L1,L2) = sqrt((xloc(L1)-xloc(L2))*(xloc(L1)-xloc(L2)) +
                (yloc(L1)-yloc(L2))*(yloc(L1)-yloc(L2))) ;
flow(F1,F2) = round(uniform(-50,50)) ;

binary variables
  x(F,L)
;

equations
  nonlin_obj
  lin_ob
  assign_fac(F)
  assign_loc(L)
  trix_1(F,L,F,L)
  trix_2(F,L,F,L)
  trix_3(F,L,F,L)
;

free variable val ;

* If all dist and flow are positive, you don't need trix_1 and trix_2

nonlin_obj..
  val =E= sum( (F1,L1,F2,L2), dist(L1,L2)* flow(F1,F2) * x(F1,L1) * x(F2,L2) ) ;

assign_fac(F)..
  sum(L, x(F,L)) =E= 1;

assign_loc(L)..
  sum(F,x(F,L)) =E= 1;

option minlp = baron ;
option reslim = 120;

model qap_nonlinear /nonlin_obj, assign_fac, assign_loc/ ;

solve qap_nonlinear using minlp minimizing val;

* Now do a linear model
binary variables
  z(F,L,F,L) ;


equations
  lin_obj
  trix_1(F,L,F,L)
  trix_2(F,L,F,L)
  trix_3(F,L,F,L)
;

lin_obj..
  val =E=  sum( (F1,L1,F2,L2), dist(L1,L2)* flow(F1,F2) * z(F1,L1,F2,L2) ) ;

trix_1(F1,L1,F2,L2)..
  z(F1,L1,F2,L2) =L= x(F1,L1);

trix_2(F1,L1,F2,L2)..
  z(F1,L1,F2,L2) =L= x(F2,L2);

trix_3(F1,L1,F2,L2)..
  z(F1,L1,F2,L2) =G= x(F1,L1) + x(F2,L2) - 1;

model qap_linear /lin_obj, assign_fac, assign_loc, trix_1, trix_2, trix_3 /;
* CPLEX is lousy, even with options, gurobi is best, copt ok on first model

$onecho > cplex.opt
zerohalfcuts -1
$offecho

solve qap_linear using mip minimizing val;
display qap_linear.resusd;

$exit

equations
  trix_4(F,L,F,L)
;

trix_4(F1,L1,F2,L2)..
  x(F1,L1) + x(F2,L2) - 2*z(F1,L1,F2,L2) =G= 0 ;


model qap_linear2 /lin_obj, assign_fac, assign_loc, trix_3, trix_4 /;
solve qap_linear2 using mip minimizing val;
display qap_linear2.resusd;

