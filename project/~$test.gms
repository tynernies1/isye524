$gdxin tclasses.gdx

set c, s, r, d, m, ch, pr, cd;
parameter cr, rc;
scalar mac, mic;

$load  c, s, r, d, m, ch, cr, rc, mac, mic, pr, cd

alias(s, si, sj);
alias(c, ci, cj);

set sem(s);
sem(s)$(ord(s) < 9) = yes;

scalar min_abroad_cred / 3 /,
max_abroad_cred / 18 /;

variable
totclasses;

binary variable
x(c, s), y(c);

equations 
    obj_equation, choice_eq, req_fulfill, link, semester_min, semester_max, totcredits_req, incidence, cons_ie450, cons_ie350, cons_ie321, cons_ie348, cons_unique_discipline, abroad_max, abroad_min;

obj_equation..
    totclasses =e= sum((c,sem), x(c, sem));

req_fulfill(d, r, c)$(m(d, r, c))..
    y(c) =e= 1;

semester_min(sem)..
    sum(c, x(c, sem)*cr(c)) =g= mic;
  
semester_max(sem)..
    sum(c, x(c, sem)*cr(c)) =l= mac;
   
link(c)..
    y(c) =e= sum(sem, x(c, sem));  

totcredits_req..
    sum(c, cr(c)*y(c)) =g= 120;
    
choice_eq(r)..
    sum((c, d)$(ch(d, r, c)), cr(c)*y(c)) =g= rc(r);
    
cons_unique_discipline(c, d)$(cd(c, d))..
    sum(r$(ch(d, r, c)), y(c)) =l= 1;

incidence(ci, cj)$(pr(ci,cj))..
    sum((si, sj)$(ord(si) lt ord(sj)), x(ci,si)) =g= sum(sj, x(cj,sj));
    
cons_ie350..
    x('ie_350', 's5') + x('ie_450', 's6') =e= 1;

cons_ie450..
    x('ie_450', 's7') + x('ie_450', 's8') =e= 1;
    
cons_ie321(sem)..
    x('ie_320', sem) =e= x('ie_321', sem);
    
cons_ie348(sem)..
    x('ie_psych_349', sem) =e= x('ie_348', sem);
    
abroad_max..
    sum(c, x(c, 's6')*cr(c)) =l= max_abroad_cred;
    
abroad_min..
    sum(c, x(c, 's6')*cr(c)) =g= min_abroad_cred;
     
model triple_major /all/;
solve triple_major using mip minimize totclasses;

set possible_credits_taken / 3*18 /;

parameter classes_sem(s, *), credits_sem(s, *), plans(c, s, *);

classes_sem(s, 'normal') = sum(c, x.l(c,s));
credits_sem(s, 'normal') = sum(c, cr(c)*x.l(c,s));
plans(c, s, 'normal') = x.l(c, s);

parameter
abroad_trials(possible_credits_taken);

sem(s) = yes;

loop(possible_credits_taken,
    max_abroad_cred = ord(possible_credits_taken)+2;    
    solve triple_major using mip minimize totclasses;
    abroad_trials(possible_credits_taken) = sum(c, cr(c)*x.l(c, 's6')); 
);

scalar min_credits_taken_abroad;
min_credits_taken_abroad = smin(possible_credits_taken, abroad_trials(possible_credits_taken));

equations 
abroad_max_opt;

abroad_max_opt..
    sum(c, x(c, 's6')*cr(c)) =l= min_credits_taken_abroad;

model triple_major_abroad / all /;
solve triple_major_abroad using mip minimize totclasses;

classes_sem(s, 'abroad') = sum(c, x.l(c,s));
credits_sem(s, 'abroad') = sum(c, cr(c)*x.l(c,s));
plans(c, s, 'abroad') = x.l(c, s);
