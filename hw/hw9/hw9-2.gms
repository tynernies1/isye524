sets N /ad1*ad20/;
alias(I,N) ;

parameters c(I) Cost,
alpha(I) Witches proportionality constant,
beta(I) Wizards proportionality constant ;

scalars K1, K2;

c(I) = normal(100,5);
alpha(I) = uniform(7,13);

beta(I) = 13-alpha(I) + 7 + 5$(uniform(0,1) < 0.3) ;

K1 = 5000;
K2 = 8000;

variable cost;
positive variable x(I);

equations defobj, tot_witches, tot_wizards;

defobj..
    cost =e= sum(I, c(I)*x(I));

tot_witches..
    sum(I, alpha(I)*sqrt(x(I))) =g= K1;
    
tot_wizards..
    sum(I, beta(I)*sqrt(x(I))) =g= K2;
    
x.lo(I) = 1;

model w1 / defobj, tot_witches, tot_wizards /;
solve w1 using nlp min cost;

parameter solution(*,i), totalAdTime(*);
totalAdTime('nlp') = sum(I, x.l(I)) ;
solution('nlp',i) = x.l(i);

display totalAdTime;

variables witch_mins(I), wiz_mins(I);

equations witch_eq, wizard_eq, cons1, cons2;

witch_eq..
    sum(I, alpha(I)*witch_mins(I)) =g= K1;
    
wizard_eq..
    sum(I, beta(I)*wiz_mins(I)) =g= K2;
    
cons1(I)..
    sqrt(witch_mins(I)) =l= x(I);

cons2(I)..
    sqrt(wiz_mins(I)) =l= x(I);

model w2 / defobj, witch_eq, wizard_eq, cons1, cons2 /;

option qcp = mosek;
solve w2 using qcp minimizing cost;

totalAdTime('qcp') = sum(I, x.l(I));
solution('qcp',I) = x.l(I);

display solution, totalAdTime;












