$title  bigassign
option limrow = 0, limcol = 0;
option solprint=off;
* option solvelink=2;

$ontext
Build some large random assignment problems and see difference in
solution times

Demonstrates:
  How to set the random seed.

  How to use option files

  How to do things in a 'sparse' way in gams

  How to do conditional processing using the gams dolla'

$offtext

option seed=42
*option seed = %gams.user1%;
* This is how you change seed using time
*execseed = 1 + gmillisec(jnow);


set
   Boys /b1*b2500/
   Girls /g1*g2500/
;

alias(I,Boys,B,B2);
alias(J,Girls,G,G2);

set ARCS(I,J);


scalar
    density /0.15/
;

parameters
  c(I,J)
;

* following are not much different in exec time
arcs(I,J)$(uniform(0,1) < density) = yes;
* arcs(I,J) = yes$(uniform(0,1) < density);
* display arcs  ;

c(ARCS) = uniform(0,100) ;
* Same as
* c(I,J)$(ARCS(I,J)) = uniform(0,100) ;

* $exit

positive variables
  x(I,J)
;

free variable hookup_score;

* This dense model is the WRONG way to do it.

equations
  hookup_boys_dense(Boys)
  hookup_girls_dense(Girls)
  def_hookup_score_dense
;

hookup_boys_dense(I)..
  sum(J, x(I,J)) =L= 1;

hookup_girls_dense(J)..
  - sum(I, x(I,J)) =G= -1;

def_hookup_score_dense..
  sum((I,J), c(I,J) * x(I,J)) =E= hookup_score ;

x.UP(I,J)$(not ARCS(I,J)) = 0.0;
model hookup_dense /hookup_boys_dense, hookup_girls_dense,
      def_hookup_score_dense /;

solve hookup_dense using lp maximizing hookup_score;
parameter dense_var;
dense_var = hookup_dense.numvar;
display dense_var;
 
$exit
 
equations
  hookup_boys(Boys)
  hookup_girls(Girls)
  def_hookup_score
;

hookup_boys(I)..
  sum(J$ARCS(I,J), x(I,J)) =L= 1;

hookup_girls(J)..
  -sum(I$ARCS(I,J), x(I,J)) =G= -1;

def_hookup_score..
  sum((I,J)$ARCS(I,J), c(I,J) * x(I,J)) =E= hookup_score ;



* This is needed to start from scratch
option bratio = 1.0;

parameter
  primal_time
  dual_time
  network_time
  barrier_time
  sifting_time
;

model hookup /hookup_boys,hookup_girls,def_hookup_score/;
option lp = cplex;

hookup.optfile = 1;
$onecho > cplex.opt
lpmethod 1
names no
$offecho

solve hookup using lp maximizing hookup_score;
primal_time = hookup.resusd;

* $exit

parameter sparse_var;
sparse_var = hookup.numvar;
display sparse_var;



$onecho > cplex.op2
lpmethod 2
names no
$offecho
hookup.optfile = 2;

solve hookup using lp maximizing hookup_score;
display hookup.resusd;
dual_time = hookup.resusd;


$onecho > cplex.op3
lpmethod 3
netfind 2
preind 0
names no
$offecho
hookup.optfile = 3;

solve hookup using lp maximizing hookup_score;
network_time  = hookup.resusd;


$onecho > cplex.op4
lpmethod 4
names no
$offecho
hookup.optfile = 4;

solve hookup using lp maximizing hookup_score;
barrier_time = hookup.resusd;

option decimals = 1;

display primal_time, dual_time, network_time, barrier_time ;

$exit

* Let's figure out how many boys and girls get their top choice
* Use this to demonstrate profile and stepsum

sets
  boy_pref(Boys,Girls)
  girl_pref(Boys,Girls)
  boys_who_got_best_girl(Boys)
  girls_who_got_best_boy(Girls)
;

parameter best_girl(B), best_boy(G);
* Following lines take LOTS of time
* boy_pref(ARCS(B,G)) = yes$(c(B,G) = smax(G2,c(B,G2)));
* girl_pref(ARCS(B,G)) = yes$(c(B,G) = smax(B2,c(B2,G)));

* $exit

best_girl(B) = smax(ARCS(B,G), c(B,G));
best_boy(G) = smax(ARCS(B,G), c(B,G));
boy_pref(B,G)$(ARCS(B,G) and c(B,G) = best_girl(B)) = yes;
girl_pref(B,G)$(ARCS(B,G) and c(B,G) = best_boy(G)) = yes;

option boy_pref:0:0:1;
option girl_pref:0:0:1;
display boy_pref ;
display girl_pref;

boys_who_got_best_girl(B) = yes$(sum(G$boy_pref(B,G), x.L(B,G)) > 0.01);
girls_who_got_best_boy(G) = yes$(sum(B$girl_pref(B,G), x.L(B,G)) > 0.01);

display boys_who_got_best_girl;
display girls_who_got_best_boy;

scalar 
  pct_boys_happy,
  pct_girls_happy
;

pct_boys_happy = 100*card(boys_who_got_best_girl)/card(B);
pct_girls_happy = 100*card(girls_who_got_best_boy)/card(G);

display pct_boys_happy;
display pct_girls_happy;

