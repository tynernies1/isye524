$gdxIn gj_ec19c19b_base_4_gdxin.gdx
$onMultiR
$if not declared classes set classes(*) '';
$load classes
$if not declared semesters set semesters(*) '';
$load semesters
$if not declared discipline set discipline(*) '';
$load discipline
$if not declared musttake set musttake(*,*) '';
$load musttake
$if not declared credits parameter credits(*) '';
$load credits
$if not declared max_credits scalar max_credits '';
$load max_credits
$if not declared min_credits scalar min_credits '';
$load min_credits
$if not declared total_classes free variable total_classes 'total classes';
$load total_classes
$if not declared x binary variable x(classes,semesters) 'if class c is taken in semester s';
$load x
$gdxIn
$offeolcom
$eolcom #
# set C "classes" / /;
# set S "semester" /s1*s8/;
# set R "requirements" /ie_math221,ie_math222, ie_math234, ie_math340, ie_phys_ema, ie_basic_science, ie_stat_311_309,
# ie_210_or_stats ,ie_cs220,ie_cs_choice, ie_191, ie_312, ie_313,ie_315,ie_320,ie_321, ie_323, ie_348, ie_349, ie_350, ie_450,
# ie_an_op, ie_diff_elective, ie_elective, ie_comm, ie_eng_comm, ie_econ, math_linalg, math_algebra, math_advanced, math_electives,
# cs_240, cs_252, cs_300, cs_354, cs_400, cs_calc, cs_math, cs_theory, cs_software, cs_app, cs_elective/;
alias(c, classaes);
alias(s, semesters);
alias(m, musttake);

# parameter credits(C); #number of credits for each class
# parameter max_cred(S) = 12;
# parameter min_cred(S) = 3;
# parameter req_credits(requirements) /ie_math221 5,ie_math222 4, ie_math234 4, ie_math340 3, ie_phys_ema 5, ie_basic_science 9, ie_stat_311_309 3,
# ie_210_or_stats 3, ie_cs220 4, ie_cs_choice 3, ie_191 2, ie_312 3, ie_313 3,ie_315 3,ie_320 3, ie_321 1, ie_323 3, ie_348 1, ie_349 3, ie_350 3, ie_450 3,
# ie_an_op 9, ie_diff_elective 3, ie_elective 6, ie_comm 6, ie_eng_comm 3, ie_econ 4, math_linalg 3, math_algebra 6, math_advanced 3, math_electives 9,
# cs_240 3, cs_252 3, cs_300 3, cs_354 3, cs_400 3, cs_calc 9, cs_math 6, cs_theory 3, cs_software 6, cs_app 3, cs_elective 6 /;
# table satisfy(C,R)
         
# math_221       1               0.               1
# physics_207    0                1
# chemistry_103  0.                1 ;
   


# set pred(i,j); #classes in i must be taken before class j

# binary variable x(C, S); #1 if class is taken during that semester
# variable total_classes;

equations 
    obj_equation, req_fulfill;

obj_equation..
    totclasses =e= sum((c,s), x(c, s));

# req_fulfill(m)..
#     sum((c, s), x(c, s)) =e= 1;
                         
                         
model triple_major /all/;
solve triple_major using lp minimize total_classes;

#then we do abroad example where only thing that changes is that during s6, no credits are taken
