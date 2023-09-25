$include shoeco.gms

positive variables
    L(T)    Leftover inventory in scenario
    S(T)    Shortage inventory in scenario
;


equations
    BacklogDef_eq(T)
    BacklogCost_eq
;

scalar  theta   Backlog cost /20/;

I.lo(T) = -inf;
* I.lo(T)$(ord(T)=card(T)) = 0;
I.lo(T)$T.last = 0;

BacklogCost_eq..
    cost =E= sum(T, delta*x(T) + alpha * w(T) + beta * o(T) + eta * h(T) +
                    zeta * f(T) + iota * L(T) + theta * S(T) ) ;

BacklogDef_eq(T)..
    I(T) =E= L(T) - S(T);

*model shoeco_backlog / RegLabor_eq, OverLabor_eq,
*    BalShoe_eq, BalPeople_eq, BacklogDef_eq,
*    BacklogCost_eq /;
    
* Start with shoeco, remove cost_eq, add others
model shoeco_backlog / shoeco - cost_eq, BacklogDef_eq, BacklogCost_eq /;

solve shoeco_backlog minimizing cost using lp;

display x.l, I.l, w.l, h.l, f.l, o.l, L.l, S.l;

