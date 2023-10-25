set all_nodes / A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, W, X, Y, Z /;
set nodes(all_nodes) / A, B, C, D, E, F, G, H, I, J /;
alias(nodes, I, J);

binary variables
use(nodes, nodes);

set arcs(nodes, nodes) Arcs / A.(B, C, F, G), B.(H), C.D, D.(E, F), G.I, H.I, I.J /;

display arcs;

variable
totguards;

binary variable
use(nodes, nodes) Arcs Used;

equations
obj, coverage(nodes);

obj..
totguards =e= sum((I, J), use(I, J));

coverage(I)..
sum(J, use(I, J)$(arcs(I, J))) + sum(J, use(J, I)$(arcs(J, I))) =g= 1;

model guards1 / obj, coverage /;

solve guards1 using mip minimize totguards;

alias(all_nodes, P, Q)

set arcs_new(all_nodes, all_nodes) /
    A.(B, Z),
    B.C,
    C.(D, E),
    E.(F, G, I),
    G.H,
    I.(J, K),
    K.(L, O),
    L.(M, N),
    O.P,
    P.(Q, T, U),
    Q.R,
    R.S,
    S.T,
    U.(W, X, Z),
    X.Y /;

variable
totguards2;

binary variable
use2(all_nodes, all_nodes) Arcs Used;

equations
obj2, coverage2(all_nodes);

obj2..
totguards2 =e= sum((P, Q), use2(P, Q));

coverage2(P)..
sum(Q, use2(P, Q)$(arcs_new(P, Q))) + sum(Q, use2(Q, P)$(arcs_new(Q, P))) =g= 1;

model guards2 / obj2, coverage2 /;

solve guards2 using mip minimize totguards2;

set stations(all_nodes, all_nodes);
stations(P, Q) = yes$(use2.l(P, Q));

option stations:0:0:1;
display stations;
