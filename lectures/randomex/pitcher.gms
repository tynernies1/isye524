$title Pitcher: Use of binary variables

$ontext

The Brewers are trying to determine which of the following free agent
pitchers should be signed: Rick Sutcliffe (RS), Bruce Sutter (BS), 
Dennis Eckersley (DE), Steve Trout (ST), Tim Stoddard (TS).  The cost of
signing each player and the number of victories each pitcher will add to 
the Brewers are shown in the table below.  Subject to the following
restrictions, the Brewers wish to sign the pitchers who will add the most
victories to the team.
 1. At most $12 million can be spent.
 2. If DE and ST are signed, then BS cannot be signed.
 3. At most two right-handed pitchers can be signed.
 4. The Brewers cannot sign both BS and RS.
Who should they sign?

$offtext

set player /rs,bs,de,st,ts/;

table data(player,*)
   cost victory lefty
rs 6	  6
bs 4    5
de 3    3
st 2    3       1
ts 2    2
;

binary variable sign(player);
variable wins;
equations money,restrict2,righty,restrict4,obj;

money..
sum(player,data(player,'cost')*sign(player)) =l= 12;

restrict2..
sign('de') + sign('st') =l= 1 + (1 - sign('bs'));

righty..
sum(player$(data(player,'lefty') ne 1), sign(player)) =l= 2;

restrict4..
sign('rs') + sign('bs') =l= 1;

obj..
wins =e= sum(player, data(player,'victory')*sign(player));

model pitcher /money,righty,restrict2,restrict4,obj/;
solve pitcher using mip maximizing wins;
