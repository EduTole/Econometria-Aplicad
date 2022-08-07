

***************************
******  Variable R3  ******
***************************
*	foreach b in  15 16 17 18 19 {
gen r3=.
replace r3=1 if ocu500==1
replace r3=2 if ocu500==2
replace r3=3 if (ocu500==3 | ocu500==4)
*}
label define r3 1 "Ocupado" 2 "Desempleado" 3 "Inactivo"
label values r3 r3
label var r3 "categoria de trabajo"