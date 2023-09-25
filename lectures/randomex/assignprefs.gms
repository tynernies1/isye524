$title Assigning students to projects to maximize overall satisfaction

option limrow=0, limcol=0;

$ontext
A teacher wishes to assign 5 projects to 5 different students. Each
student has indicated their preference for each project by assigning it a
score between 0 and 10 (0 indicating strong dislike and 10 indicating
strong preference). The teacher wishes to make the assignment of projects
to students in a way that maximizes their overall satisfaction, as
measured by the sum of the preferences for the given assignments.

Specializing CPLEX for network problems below
Lists option names followed by chosen value 
$offtext

$onecho > cplex.opt
lpmethod 3
netfind 2
preind 0
$offecho

set projects/proj1*proj5/
    students/student1*student5/;

table preferences(students,projects)
             proj1     proj2     proj3     proj4    proj5
student1      7          6        5          8       9
*student1      0          0        5.2        8.3     0
student2      0          3        0          8       5
student3      0          0        0          4       3
student4      0          9        3          0       9
student5      0          6        7          6       0;

* want x to be 1 if that student is assigned to that project; 0 otherwise
* (actually in this simple assignment problem, dont need the variables to
* be binary)
binary variable x(students,projects);
variable satisfaction;

equations EQassignProjects(projects), EQassignStudents(students), objective;

* ensure that each project is assigned to one of the student
EQassignProjects(projects).. sum(students, x(students,projects)) =e= 1;

* ensure that each students is assigned exactly one project
EQassignStudents(students)..  sum(projects, x(students,projects)) =e= 1;

* satisfaction index
objective..
  satisfaction =e= sum((students,projects),
    x(students,projects) * preferences(students,projects));

model  happyclass /EQassignProjects, EQassignStudents, objective/;

happyclass.optfile = 0;
x.up(students,projects) = 1;
solve happyclass using mip maximizing satisfaction;

* define a set to display the solution in a nice way
set matchings(students,projects);
matchings(students,projects) = yes$(x.l(students,projects) > 0);

* display in list format
option matchings:0:0:1; display matchings;

parameters
    prefgot(*,students),
    minpref(students)
;

minpref(students) = smin(projects, preferences(students, projects)) ;
* minpref(students) = max(eps,minpref(students)) ;

prefgot('happyclass',students) = sum(projects, x.l(students,projects) *
                            preferences(students,projects));

display minpref, prefgot;

$exit

$ontext
Can we also maximize the minimum assigned preference
$offtext

free variable z;

equations
    zdef(students)
;

zdef(students)..
    z =L= sum(projects, preferences(students,projects) * x(students,projects));

model minmax /EQassignProjects, EQassignStudents, zdef/;
option solprint = off;
minmax.optfile=1;
solve minmax using rmip maximizing z;

prefgot('minmax(rmip)',students) = sum(projects, x.l(students,projects) *
                            preferences(students,projects));

solve minmax using mip maximizing z;

prefgot('minmax(mip)',students) = sum(projects, x.l(students,projects) *
                            preferences(students,projects));

display prefgot;
