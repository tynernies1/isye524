set N / 1*50 /;

alias(N, I);

binary variables
cs_300(I), math_340(I), cs_400(I), female(I), male(I), undergrad(I), cs(I), math(I), ie(I), december(I),
finalfemales(I), ieundergrads(I), both300and400(I), both300and400ordecem(I), maleieundergrads(I),
maleieundergradsboth300and400ordecem(I);

variable
totfemales;

equations
obj, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9, eq10, eq11, eq12, eq13, eq14, eq15, eq16, eq17, eq18, eq19,
eq20, eq21, eq22, eq23, eq24, eq25, eq26, eq27, eq28, eq29, eq30, eq31, eq32, eq33, eq34, eq35, eq36, eq37;

obj..
totfemales =e= sum(I, finalfemales(I));

eq2..
sum(I, cs_300(I)) =g= 10;

eq3..
sum(I, math_340(I)) =g= 10;

eq4..
sum(I, cs_400(I)) =e= 15;

eq5..
sum(I, female(I)) =e= 15;

eq6(I)..
male(I) =e= 1 - female(I) ;

eq7..
sum(I, undergrad(I)) =e= 20;

eq8..
sum(I, cs(I)) =e= 25;

eq9..
sum(I, math(I)) =e= 15;

eq10..
sum(I, ie(I)) =e= 10;

eq11..
sum(I, december(I)) =e= 12;

eq12(I)..
finalfemales(I) =l= ie(I);

eq13(I)..
finalfemales(I) =l= undergrad(I);

eq14(I)..
finalfemales(I) =l= female(I);

eq15(I)..
finalfemales(I) =l= december(I);

eq16(I)..
finalfemales(I) =l= both300and400(I);

eq17(I)..
finalfemales(I) =g= ie(I) + undergrad(I) + female(I) + december(I) + both300and400(I) - 4;

eq18(I)..
ieundergrads(I) =l= ie(I);

eq19(I)..
ieundergrads(I) =l= undergrad(I);

eq20(I)..
ieundergrads(I) =g= ie(I) + undergrad(I) - 1;

eq21(I)..
both300and400(I) =l= cs_400(I);

eq22(I)..
both300and400(I) =l= cs_300(I);

eq23(I)..
both300and400(I) =g= cs_400(I) + cs_300(I) - 1;

eq24(I)..
both300and400ordecem(I) =g= both300and400(I);

eq25(I)..
both300and400ordecem(I) =g= december(I);

eq26(I)..
both300and400ordecem(I) =l= both300and400(I) + december(I);

eq27(I)..
maleieundergrads(I) =l= ie(I);

eq28(I)..
maleieundergrads(I) =l= undergrad(I);

eq29(I)..
maleieundergrads(I) =l= male(I);

eq30(I)..
maleieundergrads(I) =g= ie(I) + undergrad(I) + male(I) - 2;

eq31(I)..
maleieundergradsboth300and400ordecem(I) =l= ie(I);

eq32(I)..
maleieundergradsboth300and400ordecem(I) =l= undergrad(I);

eq33(I)..
maleieundergradsboth300and400ordecem(I) =l= male(I);

eq34(I)..
maleieundergradsboth300and400ordecem(I) =l= both300and400(I);

eq35(I)..
maleieundergradsboth300and400ordecem(I) =g= ie(I) + undergrad(I) + male(I) + both300and400ordecem(I) - 3;

eq36..
sum(I, maleieundergrads(I)) =g= [2/3]*sum(I, ieundergrads(I));

eq37..
sum(I, maleieundergradsboth300and400ordecem(I)) =e= 2;

model female_engineers / all /;

solve female_engineers using mip maximize totfemales;

parameter results(*);

results('exists') = 1$(totfemales.l > 0);
results('max howmany') = totfemales.l;
results('femIEugrads') = sum(I$(ieundergrads.l(I) > 0.5), ieundergrads.l(I) - maleieundergrads.l(I));
results('maleIEudrads') = sum(I$(ieundergrads.l(I) > 0.5),maleieundergrads.l(I));
display results;




