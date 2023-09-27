set item all items / dish, ink, lipstick, pen, pencil, perfume /
* defining a subset from set item 
    subitem1(item) first subset / pen, pencil, perfume /
    subitem2(item) second subset;
    
* dynamically changing subset subitem1 for values ink and lipstick
subitem1('ink') = yes;  subitem1('lipstick') = yes;
* changing all values of subset subitem2 to be yes
subitem2(item) = yes; subitem2('perfume') = no;
display subitem1, subitem2;

sets stuff items sold /pencil, pen/
     firm suppliers /bic, parker, waterman/;

$ontext
sets supply(stuff,firm);
* can also change values for a 2 dimensional variable using hardcoded values to index sets 
supply('pencil','bic') = yes;
* or change values for all entries indexed within one or both sets
supply('pen',firm) = yes;
$offtext
* static definition
sets supply(stuff,firm) /
  pencil.bic,
  pen.set.firm
/;
display supply;

set allr /n,s,w,e,n-e,s-w/, r(allr);

scalar price /10/;
equations prodbal(allr), defobj;
variables activity(allr), revenue(allr), obj;

defobj..
  obj =e= 0;
  
* equation prodbal declared over allr, defined over r

prodbal(r).. activity(r)*price =e= revenue(r);

* elements in r are assigned before solve statement
model test / prodbal, defobj /;
r('n') = yes;
solve test using lp min obj;

* sum over the dynamic set only
parameter totinv, inventory(item);
inventory(item) = ord(item);

totinv = sum(item$subitem1(item), inventory(item));

* alternative for the same thing
totinv = sum(subitem1, inventory(subitem1));

* union
set sunion(item);
sunion(item) = subitem1(item) + subitem2(item); display sunion;

* intersection
set sint(item);
sint(item) = subitem1(item) * subitem2(item); display sint;

* complement
set scomp(item);
scomp(item) = not subitem1(item); display scomp;

* difference
set sdiff(item);
sdiff(item) = subitem1(item) - subitem2(item); display sdiff;
