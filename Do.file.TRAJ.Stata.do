* 1) FIRST You need to download the traj plugin via this command
net from https://www.andrew.cmu.edu/user/bjones/traj
net install traj

* 2) SECOND Then, before setting the traj, in order to obtain the statistical fit indices for correct classification automatically with the traj command (APP,OCC, mismatch) you need to run both command below (two commands because with dual traj there is two set of indices for each traj)

*THE FIRST ONE*

*I made a function to print out summary stats
program summary_table_procTraj_Toxictrio
    preserve
    *now lets look at the average posterior probability
	gen Mp = 0
	foreach i of varlist _traj_ProbG* {
	    replace Mp = `i' if `i' > Mp 
	}
    sort _traj_Group
    *and the odds of correct classification
    by _traj_Group: gen countG = _N
    by _traj_Group: egen groupAPP = mean(Mp)
    by _traj_Group: gen counter = _n
    gen n = groupAPP/(1 - groupAPP)
    gen p = countG/ _N
    gen d = p/(1-p)
    gen occ = n/d
    *Estimated proportion for each group
    scalar c = 0
    gen TotProb = 0
    foreach i of varlist _traj_ProbG* {
       scalar c = c + 1
       quietly summarize `i'
       replace TotProb = r(sum)/ _N if _traj_Group == c 
    }
	gen d_pp = TotProb/(1 - TotProb)
	gen occ_pp = n/d_pp
    *This displays the group number [_traj_~p], 
    *the count per group (based on the max post prob), [countG]
    *the average posterior probability for each group, [groupAPP]
    *the odds of correct classification (based on the max post prob group assignment), [occ] 
    *the odds of correct classification (based on the weighted post. prob), [occ_pp]
    *and the observed probability of groups versus the probability [p]
    *based on the posterior probabilities [TotProb]
    list _traj_Group countG groupAPP occ occ_pp p TotProb if counter == 1
	
	list _traj_Group countG groupAPP occ occ_pp  p if counter == 1
	
    restore
end

summary_table_procTraj_Toxictrio


*THE SECOND ONE****

***************Summary table 2 Dual****


program summary_table_procTraj2
    preserve
    *updating code to drop missing assigned observations
    drop if missing(_traj_Model2_Group)
    *now lets look at the average posterior probability
    gen Mp = 0
    foreach i of varlist _traj_Model2_ProbG* {
        replace Mp = `i' if `i' > Mp 
    }
    sort _traj_Model2_Group
    *and the odds of correct classification
    by _traj_Model2_Group: gen countG = _N
    by _traj_Model2_Group: egen groupAPP = mean(Mp)
    by _traj_Model2_Group: gen counter = _n
    gen n = groupAPP/(1 - groupAPP)
    gen p = countG/ _N
    gen d = p/(1-p)
    gen occ = n/d
    *Estimated proportion for each group
    scalar c = 0
    gen TotProb = 0
    foreach i of varlist _traj_Model2_ProbG* {
       scalar c = c + 1
       quietly summarize `i'
       replace TotProb = r(sum)/ _N if _traj_Model2_Group == c 
    }
    gen d_pp = TotProb/(1 - TotProb)
    gen occ_pp = n/d_pp
    *This displays the group number [_traj_~p], 
    *the count per group (based on the max post prob), [countG]
    *the average posterior probability for each group, [groupAPP]
    *the odds of correct classification (based on the max post prob group assignment), [occ] 
    *the odds of correct classification (based on the weighted post. prob), [occ_pp]
    *and the observed probability of groups versus the probability [p]
    *based on the posterior probabilities [TotProb]
    list _traj_Model2_Group countG groupAPP occ occ_pp p TotProb if counter == 1
    restore
end

* 3) THIRD, After running both commands for indices, I run two separate univariate models for each behavior traj (GBTM) to get the proper number of groups and polynomial forms before performing the command for the DUAL traj afterwards*
*Note= you only need the first summary table for running the univariate models, both the two summary tables for the dual traj model 

*Univariate model for bullying only*
*1 trajectory*
traj, model(cnorm) var(bulle*) indep(Age*) order(0) min(0) max(6),  

*2 trajectories*
traj, model(cnorm) var(bulle*) indep(Age*) order(0 1) min(0) max(6),  

*3 trajectories, order OK*
traj, model(cnorm) var(bulle*) indep(Age*) order(1 1 1) min(0) max(6)
trajplot, xtitle("Age") ytitle("BULLYING") ci
summary_table_procTraj_Toxictrio

*4 trajectories, order OK. 4th group=32, quadratic*
traj, model(cnorm) var(bulle*) indep(Age*) order(0 0 1 2) min(0) max(6)
trajplot, xtitle("Age") ytitle("BULLYING") ci
summary_table_procTraj_Toxictrio 

*5 trajectories, polynomial order ok*
*You will see later I have chosen 5 groups, here the polynomial order is great but in the dual model, it wasnt fitting well so i changed the polynomial order later so it fit more properly*
traj, model(cnorm) var(bulle*) indep(Age*) order(0 0 2 2 1) min(0) max(6) 
trajplot, xtitle("Age") ytitle("BULLYING") ci
summary_table_procTraj_Toxictrio 

* 6 trajectories, doesnt fit better*
traj, model(cnorm) var(bulle*) indep(Age*) order(0 0 1 1 2 2) min(0) max(6) 
trajplot, xtitle("Age") ytitle("BULLYING") ci


*Univariate model for conduct problems only*
*1 trajectory*
traj, model(cnorm) var(CD*) indep(Age*) order(2) min(0) max(12)
trajplot, xtitle("Age") ytitle("CONDUCT") ci
summary_table_procTraj_Toxictrio

*2 trajectories*
traj, model(cnorm) var(CD*) indep(Age*) order(2 2) min(0) max(12)
trajplot, xtitle("Age") ytitle("CONDUCT") ci
summary_table_procTraj_Toxictrio

*3 trajectories*
traj, model(cnorm) var(CD*) indep(Age*) order(1 2 2) min(0) max(12)
trajplot, xtitle("Age") ytitle("CONDUCT") ci
summary_table_procTraj_Toxictrio

*4 trajectories*
*THIS IS THE CHOOSEN ONE, BEST FIT*
traj, model(cnorm) var(CD*) indep(Age*) order(1 1 1 1) min(0) max(12)
summary_table_procTraj_Toxictrio
trajplot, xtitle("Age") ytitle("CONDUCT") ci

*still 4, Different order*
traj, model(cnorm) var(CD*) indep(Age*) order(1 0 1 0) min(0) max(12)
summary_table_procTraj_Toxictrio
trajplot, xtitle("Age") ytitle("CONDUCT") ci

*5 trajectories, doesnt fit better than for 4 groups*
traj, model(cnorm) var(CD*) indep(Age5-Age12) order(1 1 1 1 1) min(0) max(12)
summary_table_procTraj_Toxictrio
trajplot, xtitle("Age") ytitle("CONDUCT") ci

*6 trajectorie, same as aboves*
traj, model(cnorm) var(CD*) indep(Age5-Age12) order(1 1 1 1 1 1) min(0) max(12)
summary_table_procTraj_Toxictrio
trajplot, xtitle("Age") ytitle("CONDUCT") ci



*4) FOUTH, running the final Dual model with bullying AND conduct problems traj groups*
*with 2 censored normal distributions*
*The one that i have chosen : You can perform the command with different polynomial forms(the order, for ex, 1,2,..) but this is the best fit I found on stata (i had a lot of times problems with matrix variance because its heavy for the software to perform such a big command)
traj, model(cnorm) var(CD*) indep(Age*) max(12) order(1 1 1 1) var2(bulle*) indep2(Age*) max2(6) model2(cnorm) order2(1 1 1 1 2)
summary_table_procTraj_Toxictrio 
summary_table_procTraj2
trajplot, xtitle("Age") ytitle("CONDUCT") ci
trajplot, model(2) xtitle("Age") ytitle("BULLYING") ci

