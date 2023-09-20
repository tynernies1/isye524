* GENERAL/ABSTRACT MODEL FOR TOPBRASS

option limrow=0, limcol=0;

* defining a set that includes a collection of strings containing football and soccer {'football', 'soccer'}
* elements not defined are assigned initial values of 0
set I /t1 * t100/ ;
set R /r1 * r50/;

parameters
c(I) "Profit margin"
u(I) "Max to produce"
b(R) "Amt. available"
a(R,I) "Per-Unit resource requirements"
;
* Now do fancy stuff to create a random instance
c(I) = round(uniform(2,20));
u(I) = round(uniform(500,2500));
b(R) = round(uniform(5000,25000));

* maybe better to use this
a(R,I) = uniformInt(1, 5);


* table: another way of representing numbers symbolically; data in table must be two dimensional, similar to a matrix
table a(R, I) Per-Unit resource requirements
        football    soccer
plaques   1           1
wood      4           2;
