option limrow=0, limcol=0;

set I Items for Sale / bookcase, desk, chair, bedframe, coffee_table / ;
set R Requirements Needed / work, metal, wood /;
set M Model Variations / '2.1', '2.2', '2.3', '2.4' /;

parameters 
p(I) Profit Margin / bookcase 19, desk 13, chair 12, bedframe 17 /
u(R) Amount Available Resources / work 225, metal 117, wood 420 /
n(I, R) Resource Requirement per Process Item ;

table
n(I, R)
            work      metal      wood
bookcase       3          1         4 
desk           2          1         3
chair          1          1         3
bedframe       2          1         4
coffee_table   3          1         2;

* insprofit and insres are 2 tables that detail the changes of each variation to refer to in loop below
table
insprofit(I, M) Profit Margin Changes by Instance
            '2.1'      '2.2'      '2.3'      '2.4'
bookcase    
desk                     15         15         15
chair
bedframe
coffee_table ;

table
insres(R, M) Resource Availability Changes by Instance
            '2.1'      '2.2'      '2.3'      '2.4'
work                
metal                              125        125
wood ;

* used as base for referring to in loop below
parameter savprofit(I) Save Profit Margins, savres(R) Save Resource Availabilities;
savprofit(I) = p(I);
savres(R) = u(R);

positive variable produce(I);
variable Profit;
equation obj, res_con;

obj..
Profit =e= sum(I, p(I)*produce(I));

res_con(R)..
sum(I, n(I, R)*produce(I)) =l= u(R);

model books /all/;

produce.up('coffee_table') = 0;

* initializing empty parameter to save different objective values for different variations
parameter resprof(*);
* iterating through all scenarios of M (2.1, 2.2, 2.3, 2.4)
loop(M,
* if loop is on the 4th or greater iteration, then change upper limit of coffee tables produced to +INF 
    if(ord(M) ge 4,
        produce.up('coffee_table') = INF;);
* set profit margin and available resources to original/base values
    p(I) = savprofit(I);
    u(R) = savres(R);
* set p(I) and u(R) to the values in insprofit and insres based on the current iteration of the loop
    p(I)$insprofit(I, M) = insprofit(I, M);
    u(R)$insres(R, M) = insres(R, M);
* solve each iteration of loop
    solve books using lp maximize Profit;
* assign each iteration's objective to resprof parameter
    resprof(M) = Profit.l;
);

display resprof, produce.l;