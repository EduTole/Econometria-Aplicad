
/*
foreach i in 2015 2021{
	
	if `i'==2015 {
	
	******  Filtro 1 ******.
	gen filtro=.
	replace filtro=1 if (((p204==1 & p205==2) | (p204==2 & p206==1)) & p501>0 & p501!=. & p501!=9) & fac500!=.
	keep if filtro==1

	}
*/	
	
*	if  `i'>2015 {	
	******  Filtro  2 ******.
	gen filtro=.
	replace filtro=1 if (((p204==1 & p205==2) | (p204==2 & p206==1)) & p501>0 & p501!=. & p501!=9) & fac500a!=.
	keep if filtro==1
*	}
*}


