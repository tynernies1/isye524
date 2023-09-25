$title McGreasy Diet Problem

$ontext
A simple diet model.
Data taken from "Optimization Models",
Chapter 1, by Robert Fourer.
$offtext

set food, nutr;

table a(nutr<,food<)  per unit nutrients
        QP  MD  BM  FF  MC  FR  SM  1M   OJ
Prot    28  24  25  14  31   3  15   9    1
VitA    15  15   6   2   8   0   4  10    2
VitC     6  10   2   0  15  15   0   4  120
Calc    30  20  25  15  15   0  20  30    2
Iron    20  20  20  10   8   2  15   0    2
Cals   510 370 500 370 400 220 345 110   80
Carb    34  33  42  38  42  26  27  12   20;



parameter min_nutr(nutr) /Prot 55, VitA 100, VitC 100, Calc 100,
    Iron 100, Cals 2000, Carb 350 /;

parameter cost(food) /QP 1.84, MD 2.19, BM 1.84, FF 1.44, MC 2.29,
    FR 0.77, SM 1.29, 1M 0.6, OJ 0.72 /;

free variables
    total_cost  Total Cost of Daily Diet
;

positive variables
    x(food)     Number of each type of food to eat
;


equations
    cost_eqn        Define Objective
    min_nutr_eqn(nutr)    Minimum Daily Requirement
;

min_nutr_eqn(nutr)..
    sum(food,a(nutr,food)*x(food)) =G= min_nutr(nutr) ;

cost_eqn..
    total_cost =E= sum(food,cost(food)*x(food)) ;

set beef(food) / QP, MD, BM /;

free variable total_beef;

equations
    beef_eqn    Amount of beef I get to eat
;

beef_eqn..
    total_beef =E= sum(beef,x(beef));

set bad_nutr(nutr) / Cals, Carb /;

parameter max_nutr(bad_nutr);
max_nutr(bad_nutr) = 2 * min_nutr(bad_nutr);

equations
    max_nutr_req(bad_nutr)  Jane doesn't want the insurance money yet
;

max_nutr_req(bad_nutr)..
    sum(food,a(bad_nutr,food)*x(food)) =L= max_nutr(bad_nutr);


$ontext
Some new requirements.  Let's suppose that Jane will allow me to eat
as many burgers as a want, but I just can't eat them in "too high" a
proportion with the vitamins I get.

For example, let's say that ...
cals/vitc <= rho
cals/vita <= rho

Also, I can't eat more than 10,000 calories/day

$offtext

positive variables
    cals_eaten  Number of calories I ingest
    vitc_eaten  Amount of vitamin C I eat
    vita_eaten  Amount of vitamin A I eat
;

equations
    cals_eaten_eqn
    vitc_eaten_eqn
    vita_eaten_eqn
    limit_vitc_ratio_eqn
    limit_vita_ratio_eqn
;

cals_eaten_eqn..
    cals_eaten =E= sum(food,a("Cals",food) * x(food));

vitc_eaten_eqn..
    vitc_eaten =E= sum(food,a("VitC",food) * x(food));

vita_eaten_eqn..
    vita_eaten =E= sum(food,a("VitA",food) * x(food));

$ontext
limit_vitc_ratio_eqn..
    cals_eaten - 40*vitc_eaten =L= 0 ;

limit_vita_ratio_eqn..
    cals_eaten - 40*vita_eaten =L= 0 ;
$offtext
limit_vitc_ratio_eqn..
    cals_eaten / vitc_eaten =L= 40 ;

limit_vita_ratio_eqn..
    cals_eaten / vita_eaten =L= 40 ;


cals_eaten.up = 10000;

model ratiomodel /  cals_eaten_eqn,  vitc_eaten_eqn,  vita_eaten_eqn,
        limit_vitc_ratio_eqn, limit_vita_ratio_eqn, min_nutr_eqn, beef_eqn /;

solve ratiomodel using nlp maximizing total_beef;
