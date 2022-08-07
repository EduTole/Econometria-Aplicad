
***************************
******  Variable R6  ******
***************************

replace d529t=. if d529t==999999
replace d536=. if d536==999999
replace d543=. if d543==999999

egen r6=rowtotal(i524a1 d529t i530a d536 i538a1 d540t i541a d543 d544t) if (r3==1)
replace r6=r6/12 if (r3==1)
replace r6=0 if (r3==1 & r6==.)

label var r6 "Ingreso laboral mensual (ocup. princ. y secun.)" 


