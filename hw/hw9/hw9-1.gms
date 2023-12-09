set i(*), headr(*);

parameter A(i,headr);

$gdxin abalone.gdx

$LOAD i
$LOAD headr
$LOAD A=Data
$gdxin

set j(headr) index of independent variables;
j(headr) = yes$(not sameas(headr,'Rings'));

parameter y(i);
y(i) = -1 + 2$(A(i,'Rings') gt 10);

set train(i), tune(i), test(i);
train(i) = yes$(ord(i) le 3000);
tune(i) = yes$(ord(i) gt 3000 and ord(i) le 3500);
test(i) = yes$(ord(i) gt 3500);

scalar C;
C = 1;

positive variable delta(i);
variables obj, w(headr), gamma;
equations defobj, cons(i);

cons(i)$train(i)..
    y(i)*(sum(j, A(i,j)*w(j)) - gamma) + delta(i) =g= 1;

defobj..
    obj =e= C*sum(i$train(i), delta(i)) + [1/2]*sum(j, sqr(w(j)));

variable v(headr), dual_obj;
positive variable alpha(i);

equations defdual_obj, cons_v, cons1_alpha, cons2_alpha(i);

defdual_obj..
    dual_obj =e= sum(i$train(i), alpha(i)) - [1/2]*sum(j, sqr(v(j)));

cons_v(j)..
    v(j) =e= sum(i$train(i), alpha(i)*y(i)*A(i, j));

cons1_alpha..
    sum(i$train(i), y(i)*alpha(i)) =e= 0;

cons2_alpha(i)$train(i)..
    C =g= alpha(i);

model svmmod / all /;

solve svmmod using qcp minimize obj;
solve svmmod using qcp maximize dual_obj;

parameter wsolns(*,headr), gsolns(*);

wsolns('primal',j) = w.l(j);
gsolns('primal') = gamma.l;
wsolns('dual',j) = v.l(j);
gsolns('dual') = -cons1_alpha.m;

set folds / f1*f5 /;
set trials / t1*t6 /;
set err(i); 
parameter errvec(trials);

loop(trials,
    C = power(10, trials.ord - 2);
    err(i) = no;
    loop(folds,
        tune(i) = yes$(i.ord gt (folds.ord-1)*700 and i.ord le folds.ord*700);
        train(i) = yes$(not test(i) and (not tune(i)));
        solve svmmod min obj using qcp;
        loop(tune,
            if ((sum(j, A(tune, j)*w.l(j)) - gamma.l) * y(tune) < 0,
                err(tune) = yes;
            );
        );
    );
    errvec(trials) = card(err)/3500;
); 
C = 10000;
train(i) = yes$(not test(i));
solve svmmod min obj using qcp;
set errs(i);
parameter errorrate;

loop(test,
    if((sum(j, A(test, j)*w.l(j)) - gamma.l) * y(test) < 0,
        errs(test) = yes;
    );
);
errorrate = card(errs)/card(test);

display wsolns, gsolns, errvec, C, errorrate;