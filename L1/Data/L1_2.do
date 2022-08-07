cls
clear all
glo ENAHO	"D:\Dropbox\BASES\ENAHO"
glo Out		"E:\EducatePeru\Stata\S1\Data"

*Informacion de educacion
*------------------------------------------------------------
forvalues i=2019/2021{
use "${ENAHO}/`i'/enaho01a-`i'-300.dta",clear
do "${Out}/42.- reduca.do"
*Solo jefe del hogar
keep if p203==1
keep conglome vivienda hogar codperso reduca
saveold "${Out}/Educacion_`i'.dta",replace


*Informacion de empleo
use "${ENAHO}/`i'/enaho01a-`i'-500.dta",clear
do "${Out}/1.- Filtro de residentes habituales.do"
*Solo jefe del hogar
keep if p203==1
do "${Out}/9c.- r3.do"
do "${Out}/15.- r6.do"
do "${Out}/38a.- redad.do"
do "${Out}/36a.- restado.do"
do "${Out}/41a.- rmujer.do"
*Solo considerar la PEA Ocupada
keep if ocu500==1
keep conglome vivienda hogar codperso r6 redad rpareja rsoltero rmujer ocu500 fac500a
saveold "${Out}/Empleo_`i'.dta",replace


*Union de las dos bases  de datos
*------------------------------------------------------------
u "${Out}/Empleo_`i'.dta",clear
merge 1:1 conglome vivienda hogar codperso using "${Out}/Educacion_`i'.dta", keepusing(reduca) keep(match) nogen

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
g ryear=`i'
sum
saveold "${Out}/BD_`i'.dta",replace

erase "${Out}/Empleo_`i'.dta"
erase "${Out}/Educacion_`i'.dta"
}

*Uniendo las bases : Pooled
use "${Out}/BD_2019.dta",clear
forvalues i=2020/2021{
append using "${Out}/BD_`i'.dta"
}
saveold "${Out}/BD_2019-2020.dta",replace
