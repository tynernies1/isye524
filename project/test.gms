$gdxin tclasses.gdx

set c, s, r, d, m, ch, pr, k;
parameter cr, rc;
scalar mac, mic;

$load  c, s, r, d, m, ch, cr, rc, mac, mic, pr

alias(s, si, sj);
alias(c, ci, cj);

display pr;

variable
totclasses;

binary variable
x(c, s), y(c), z(d, r, c);

equations 
    obj_equation, choice_eq, req_fulfill, link, semester_min, semester_max, totcredits_req, incidence, cons_ie450, cons_ie350;

obj_equation..
    totclasses =e= sum((c,s), cr(c)*x(c, s));

req_fulfill(d, r, c)$(m(d, r, c))..
    y(c) =e= 1;

semester_min(s)..
    sum(c, x(c, s)*cr(c)) =g= mic;
  
semester_max(s)..
    sum(c, x(c, s)*cr(c)) =l= 18;
   
link(c)..
    y(c) =e= sum(s, x(c, s));  

totcredits_req..
    sum(c, cr(c)*y(c)) =g= 120;
    
choice_eq(r)..
    sum((c, d)$(ch(d, r, c)), cr(c)*y(c)) =g= rc(r);
    
*cons_unique_discipline(c,d)$(cd(c,d))..
*    sum(r$(ch(d, r, c)), y(c)) =l= 1;

incidence(ci, cj)$(pr(ci,cj))..
    sum((si, sj)$(ord(si) lt ord(sj)), x(ci,si)) =g= sum(sj, x(cj,sj));
    
cons_ie350..
    x('ie_350', 's5') + x('ie_450', 's6') =e= 1;

cons_ie450..
    x('ie_450', 's7') + x('ie_450', 's8') =e= 1;
     
model triple_major /all/;
solve triple_major using mip minimize totclasses;

set credits_sem(s);

credits_sem(s) = sum(c, cr(c)*x.l(c,s));

display totclasses.l, x.l, credits_sem;