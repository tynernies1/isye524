$title Kilroy County: Set-Covering Problem

$ontext 

There are 6 cities in Kilroy County. The county must determine where
to build fire stations to serve these cities. They want to build the
stations in some of the cities, and to build the minimum number of
stations needed to ensure that at least one station is within 15
minutes driving time of each city. (The driving times between cities
are shown in the table below.)  Formulate an integer program whose
solution gives the minimum number of fire stations and their
locations.

$offtext

option limcol=0;

set city /1*6/;
alias (city,i,j);

table travelTime(i,j) "travel time between cities in Kilroy County"
      1       2      3      4     5     6
1     0      10     20     30    30    20
2    10       0     25     35    20    10
3    20      25      0     15    30    20
4    30      35     15      0    15    25
5    30      20	    30	   15     0    14
6    20      10     20     25    14     0;

set cover(i,j) "city i is covered by station at j";
cover(i,j) = yes$(travelTime(i,j) <= 15);

binary variables x(j) "build station";
variable totalStations;

equation coverConstraint(i), objective;

objective..
	totalStations =e= sum(j, x(j));
	
coverConstraint(i)..
	sum(j$cover(i,j), x(j)) =g= 1;

model kilroy /all/;

* any optimum within <1 of the true optimum must BE the true optimum!
kilroy.optca = 0.999;
solve kilroy using mip minimizing totalStations;

display cover, x.l;
