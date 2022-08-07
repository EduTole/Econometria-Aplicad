************************
* reduca
*************************


	*Nivel de educacion 
	gen reduca=0 if p301a==1
	replace reduca=p301b+0 if p301a==2 //educacion incial
	replace reduca=p301b+0 if p301a==3 //primaria incompleta
	replace reduca=p301b+0 if p301a==4 //primaria completa
	replace reduca=p301c+0 if p301a==3 & p301b==0 //primaria incompleta
	replace reduca=p301c+0 if p301a==4 & p301b==0 //primaria completa
	replace reduca=p301b+6 if p301a==5 //secundaria incompleta
	replace reduca=p301b+6 if p301a==6 //secundaria completa
	replace reduca=p301b+11 if p301a==7 //Superior No Universitaria Incompleta
	replace reduca=p301b+11 if p301a==8 //Superior No Universitaria Completa
	replace reduca=p301b+11 if p301a==9 //Superior Universitaria Incompleta
	replace reduca=p301b+11 if p301a==10 //Superior Universitaria Completa
	replace reduca=p301b+16 if p301a==11 //Postgrado
	
	label var reduca "Años de educacion"
	
	
	