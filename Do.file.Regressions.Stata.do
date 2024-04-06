* 1) FIRST, i run some descriptive statistics and correlations between the variables
*Descriptive statistics
summarize iqe5 exfunce5 tomtote5 
summarize bulle5 bulle7 bulle10 bulle12
summarize CDtotexbul_v2_5e CDtotexbul_v2_7e CDtotexbul_v2_10e CDtotexbul_v2_12e


* Correlations across age of bullying behaviors
* Correlations across age of conduct problems
*Concurrent and Across Age Correlations between Bullying Behaviors and Conduct Problems 
*Correlations between age-5 cognitive functions (EF, IQ, TOM) and bullying behaviors
*Correlations between age-5 cognitive functions (EF, IQ, TOM) and conduct problems
**With the correlation command, you can not control for cluster, SES, SEX, but i did later for the regressions as it work with this command*
pwcorr bulle5 bulle7 bulle10 bulle12 CDtotexbul_v2_5e CDtotexbul_v2_7e CDtotexbul_v2_10e CDtotexbul_v2_12e iqe5 tomtote5 exfunce5, sig




* 2) SECOND, later, once i had my traj output (variables), I run multinomial logistic regressions between cognitive functioning and the two behaviors

*Univariate multinomial logistic regressions
*BYLLYING
*TOM+Bully*
mlogit _traj_Model2_Group seswq35 sampsex tomtote5, base(2) cluster(familyid)
mlogit, rrr

*EF+Bully*
mlogit _traj_Model2_Group seswq35 sampsex exfunce5, base(2) cluster(familyid)
mlogit, rrr

*IQ+Bully*
mlogit _traj_Model2_Group seswq35 sampsex iqe5, base(2) cluster(familyid)
mlogit, rrr

*CONDUCT PROBLEMS
*TOM*
mlogit _traj_Group seswq35 sampsex tomtote5, base(1) cluster(familyid)
mlogit, rrr

*EF*
mlogit _traj_Group seswq35 sampsex exfunce5, base(1) cluster(familyid)
mlogit, rrr

*IQ*
mlogit _traj_Group seswq35 sampsex iqe5, base(1) cluster(familyid)
mlogit, rrr



*Multivariate multinomial logistic regressions 
*BULLYING
*Multivariate multinomial regression; Bullying*
mlogit _traj_Model2_Group seswq35 sampsex exfunce5 tomtote5 iqe5, base(2) cluster(familyid)
mlogit, rrr
*Controlling for age-5 CD*
mlogit _traj_Model2_Group seswq35 sampsex CDtotexbul_v2_5e exfunce5 tomtote5 iqe5, base(2) cluster(familyid)
mlogit, rrr

*CONDUCT PROBLEMS
*Multivariate multinomial regressions : CF + Conduct problems*
mlogit _traj_Group seswq35 sampsex exfunce5 tomtote5 iqe5, base(1) cluster(familyid)
mlogit, rrr
*Controlling for age-5 bullying*
mlogit _traj_Group seswq35 sampsex bulle5 exfunce5 tomtote5 iqe5, base(1) cluster(familyid)
mlogit, rrr




**)3 THIRD, Sensitivity analysis : posterior probabilities >.8, suppplement material**

*BULLYING
gen include = .
* Set include = yes to start with, as long as they have a group membership
gen include = .
replace include = 1 if _traj_Model2_Group != .
replace include = 0 if _traj_Model2_Group == 1 & _traj_Model2_ProbG1 <= 0.8 & _traj_Model2_ProbG1 >= 0
replace include = 0 if _traj_Model2_Group == 2 & _traj_Model2_ProbG2 <= 0.8 & _traj_Model2_ProbG2 >= 0
replace include = 0 if _traj_Model2_Group == 3 & _traj_Model2_ProbG3 <= 0.8 & _traj_Model2_ProbG3 >= 0
replace include = 0 if _traj_Model2_Group == 4 & _traj_Model2_ProbG4 <= 0.8 & _traj_Model2_ProbG4 >= 0
replace include = 0 if _traj_Model2_Group == 5 & _traj_Model2_ProbG5 <= 0.8 & _traj_Model2_ProbG5 >= 0

tab _traj_Model2_Group sampsex if include == 1
*Univariate level*
*TOM*
mlogit _traj_Model2_Group seswq35 sampsex tomtote5, base(2) cluster(familyid), if include == 1
*EF*
mlogit _traj_Model2_Group seswq35 sampsex exfunce5, base(2) cluster(familyid), if include == 1
*IQ*
mlogit _traj_Model2_Group seswq35 sampsex iqe5, base(2) cluster(familyid), if include == 1 
*Multivariate level*
mlogit _traj_Model2_Group seswq35 sampsex exfunce5 tomtote5 iqe5, base(2) cluster(familyid), if include == 1
*Controlling for age-5 CD*
mlogit _traj_Model2_Group seswq35 sampsex CDtotexbul_v2_5e exfunce5 tomtote5 iqe5, base(2) cluster(familyid), if include == 1



*CONDUCT PROBLEMS
 Create variable called "include" that has all missing values
gen include = .
* Set include = yes to start with, as long as they have a group membership
gen include = .
replace include = 1 if _traj_Group != .
replace include = 0 if _traj_Group == 1 & _traj_ProbG1 <= 0.8 & _traj_ProbG1 >= 0
replace include = 0 if _traj_Group == 2 & _traj_ProbG2 <= 0.8 & _traj_ProbG2 >= 0
replace include = 0 if _traj_Group == 3 & _traj_ProbG3 <= 0.8 & _traj_ProbG3 >= 0
replace include = 0 if _traj_Group == 4 & _traj_ProbG4 <= 0.8 & _traj_ProbG4 >= 0


tab _traj_Group sampsex if include == 1
*Univariate level*
*TOM*
mlogit _traj_Group seswq35 sampsex tomtote5, base(1) cluster(familyid), if include == 1
mlogit, rrr
*EF*
mlogit _traj_Group seswq35 sampsex exfunce5, base(1) cluster(familyid), if include == 1
mlogit, rrr
*IQ*
mlogit _traj_Group seswq35 sampsex iqe5, base(1) cluster(familyid), if include == 1 
mlogit, rrr
*Multivariate level*
mlogit _traj_Group seswq35 sampsex exfunce5 tomtote5 iqe5, base(1) cluster(familyid), if include == 1
mlogit, rrr
*Controlling for age-5 bullying*
mlogit _traj_Group seswq35 sampsex bulle5 exfunce5 tomtote5 iqe5, base(1) cluster(familyid), if include == 1
mlogit, rrr
