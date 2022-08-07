cls
clear all
glo ENAHO	"D:\Dropbox\BASES\ENAHO\2021"
glo Out		"E:\EducatePeru\Stata\S1\Data"

*Informacion de educacion
use "${ENAHO}/enaho01a-2021-300.dta",clear

g reduca =0 if p301a==1
replace reduca=p301b+0 if p301a==2 //educaci´on incial
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

*Solo jefe del hogar
keep if p203==1

keep conglome vivienda hogar codperso reduca

saveold "${Out}/Educacion_2021.dta",replace

*Informacion de empleo
use "${ENAHO}/enaho01a-2021-500.dta",clear

* Filtración MTPE
drop if  fac500a==. 
drop if p501==.a | p501==. 
g corr=1 if  (p204==1 & p205==2) | (p204==2 & p206==1) 
keep if  corr==1

*Solo jefe del hogar
keep if p203==1

*Ingresos laborales
egen r6= rowtotal(i524a1 d529t i530a d536 i538a1 d540t i541a d543 d544t)    // generamos el ingreso en la ocupacion rincipal y secundario anual
replace r6= r6/12 

*Edad de la persona
g redad=p208a

*Sexo de la persona : ==2 mujer
g rmujer = (p207==2)

*Estado civil
g rpareja=(p209 ==1 | p209==2)
g rsoltero=(p209 ==6)

*Solo considerar la PEA Ocupada
keep if ocu500==1

keep conglome vivienda hogar codperso r6 redad rpareja rsoltero rmujer ocu500 fac500a
saveold "${Out}/Empleo_2021.dta",replace

*Union de las dos bases  de datos
u "${Out}/Empleo_2021.dta",clear
merge 1:1 conglome vivienda hogar codperso using "${Out}/Educacion_2021.dta", keepusing(reduca) keep(match) nogen

sum
*Lista de missing
mdesc
*Eliminamos 3 observaciones
keep if reduca!=.

*eliminamos el percentil 10
sum r6, detail
local p5 =r(p5)
keep if r6>=`p5'
*1,407 observations deleted

*Experiencia laboral 
g rexp_a = redad - reduca -5
replace rexp_a=. if rexp_a<=1
g rexp_b= redad -14
replace rexp_b=. if rexp_b<=1
g rexper = min(rexp_a, rexp_b)
g rexpersq=rexper*rexper

*Codigo de la persona
egen ID_persona= concat(conglome vivienda hogar codperso)

mdesc

keep ID_persona reduca rexper rexpersq redad rmujer rpareja rsoltero r6 fac500a
order ID_persona r6 reduca rexper rexpersq redad rmujer rpareja rsoltero  fac500a

sum
saveold "${Out}/BD_1.dta",replace

erase "${Out}/Empleo_2021.dta"
erase "${Out}/Educacion_2021.dta"
