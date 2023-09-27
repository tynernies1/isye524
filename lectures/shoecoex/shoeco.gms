$title ShoeCo Aggregate Planning Model.

$ontext
An aggregate planning model taken (Mostly) from Winston and Albright 4.4)

\BI
\item Plan production of shoes for next several months
\item Meet forecast demands on time
\item Hire and/or lay off workers
\item Make overtime decisions
\item Objective: minimize total cost
\EI

\BI
\item Planning horizon $T = \{1, 2, \ldots |T|\}$.  ($|T| = 4$).
\item Meet demand $d_t$ for shoes in period $t \in T$. $d =
(3000,5000,2000,1000)$
\item Initial Shoe Inventory: ${\cal I}_0 = 500$
\item Have ${\cal W}_0 = 100$ workers currently employed
\item Workers paid $\$\alpha = 1500$/month for working $H = 160$ hours
\item They can work overtime (max of $O = 20$ hours/worker) and get paid
 $\beta = 13$/hour.
\item It take $a = 4$ hours of labor and $\delta = \$15$ in raw
material costs to produce a shoe
\item Hire-Fire costs: $\eta = 1600$ to hire a worker, $\zeta =
\$2000$ to fire a worker.
\item Running out of greek letters, $\iota = \$3$ holding cost
incurred for each pair of shoes held at the end of the month.
\EI



\BBR{Decision Variables}
\BI
\item $x_t$: \# of shoes to produce during month $t$
\item $I_t$: Ending inventory in month $t$, $t \in T \cup \{0\}$
\item $w_t$: \# of workers available in month $t$, $t \in T
\cup\{0\}$.
\item $o_t$: \# of overtime hours used in month $t$
\item $h_t$: \# workers hired at the beginning of month $t$
\item $f_t$: \# workers fired at the beginning of month $t$
\EI
\EBR


FULL (ALGEBRAIC MODEL)

\[ \min \sum_{t \in T} \left( \delta x_t + \alpha w_t + \beta o_t +
\eta h_t + \zeta f_t + \iota I_t \right) \]
\noindent s.t.
\begin{eqnarray*}
a x_t & \leq & H w_t + o_t \quad \forall t \in T\\
o_t & \leq & O w_t \quad \forall t \in T\\
I_{t-1} + x_t & = & d_t + I_t \quad \forall t \in T\\
I_0 & = & {\cal I}_0\\
w_t & = & w_{t-1} + h_t - f_t \quad \forall t \in T\\
w_0 & = & {\cal W}_0\\
x_t, I_t, w_t, h_t, f_t & \geq & 0 \quad \forall t \in T
\end{eqnarray*}

$offtext

option limrow = 50, limcol = 0 ;

set T;

scalars
    I0      Initial Inventory
    W0      Initial Number of Workers
    alpha   Dollars per month for worker
    beta    Dollars per hour for overtime
    MAXH    max hours per month
    MAXO    max overtime hours per month
    a       labor hours per shoe
    delta   Raw material costs (dollars) per shoe
    eta     hiring cost (dollars) per worker
    zeta    firing cost (dollars) per worker
    iota    inventory cost (dollars) per shoe
;


parameters
    d(T<)    Demand
;

* Don't redefine domain of d here (read it into T as declared before)
parameter d / Jan 3000, Feb 5000, Mar 2000, Apr 1000/;

I0 = 500;
W0 = 100;
alpha = 1500;
MAXH = 160;
MAXO = 20;
beta = 13;
a = 4;
delta = 15;
eta = 1600;
zeta = 2000;
iota = 3;



display T;

positive variables
    x(T)    Production in period T
    I(T)    Ending inventory in period T
    w(T)    Worker level at end of period T
    h(T)    Number of workers hired at beginning of T
    f(T)    Number of workers fired at beginning of T
    o(T)    Number of overtime hours in period T
;

free variable cost;

equations
    cost_eq
    RegLabor_eq(T)
    OverLabor_eq(T)
    BalShoe_eq(T)
    BalPeople_eq(T)
;

cost_eq..
    cost =E= sum(T, delta*x(T) + alpha * w(T) + beta * o(T) + eta * h(T) +
                    zeta * f(T) + iota * I(t)) ;

RegLabor_eq(T)..
    a*x(T) =L= MAXH * w(T) + o(T) ;

OverLabor_eq(T)..
    o(T) =L= MAXO*w(T) ;

BalShoe_eq(T)..
  I(T) =E= I(T-1) + x(T) - d(T);
*   I(T) =E= I0$(ord(T) eq 1) + I(T-1) + x(T) - d(T) ;
*   I(T) =E= I0$sameas(T,'Jan') + I(T-1) + x(T) - d(T) ;


BalPeople_eq(T)..
  W(T) =E= W(T-1) + h(T) - f(T);
*  W(T) =E= W0$(ord(T) eq 1) + w(T-1) + h(T) - f(T) ;


model shoeco /all/;
* d(T) = 2*d(T);
solve shoeco minimizing cost using lp;

display x.l, I.l, w.l, h.l, f.l, o.l;

