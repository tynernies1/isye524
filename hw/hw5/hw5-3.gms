set activity /
        A "Find Site",
        B "Find Engineers",
        C "Hire Opening Act",
        D "Set Radio and TV Ads",
        E "Set Up Ticket Agents",
        F "Prepare Electronics",
        G "Print Advertising",
        H "Set up Transportation",
        I "Rehearsals",
        J "Last-Minute Details"
/;

alias (activity,ai,aj);

set pred(ai,aj) "ai preceeds aj" /
        A. (B,C,E) 
        B . F
        C . (D,G,H)
        (F,H) . I
        I . J
/;

parameter duration(activity) "in days" /
        A       3,      B       2
        C       6,      D       2
        E       3,      F       3
        G       5,      H       1
        I       1.5,    J       2
/;
display pred;

variables tottime;
positive variable t(ai) "time activity starts";
equations endtime(ai), incidence(ai, aj);

incidence(ai, aj)$pred(ai, aj)..
t(aj) =g= t(ai) + duration(ai);

endtime(ai)..
tottime =g= t(ai) + duration(ai);

model cpm / incidence, endtime /;
solve cpm using lp min tottime;

set critical(activity) "critical activities";

critical(activity) = yes$(smax(aj$pred(aj,activity),incidence.m(aj,activity)) ge 1 or smax(aj$pred(activity,aj),incidence.m(activity,aj)) ge 1);

display critical;

parameter
eeTime(activity) "early event time",
leTime(activity) "late event time";

tottime.fx = tottime.l;

variables obj;
equations timeopt;

timeopt..
obj =e= sum(activity,t(activity));

model eventtimes /timeopt,incidence,endtime/;

solve eventtimes using lp maximizing obj;
leTime(activity) = t.l(activity);

solve eventtimes using lp minimizing obj;
eeTime(activity) = t.l(activity);

critical(activity) = yes$(eeTime(activity) ge leTime(activity));

display critical;




