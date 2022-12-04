/*
---------------------------------------------------
Curso: Microeconometria Aplicada II
Tema: EEA
Autor: Edinson Tolentino
---------------------------------------------------
*/

cls
clear all
capture mkdir "E:\EducatePeru\Stata\S11\Data"
set more off
gl main 	"E:\EducatePeru\Stata\S11"
gl clean 	"${main}/Data"
gl codigos 	"${clean}/Codigos"
gl tablas 	"${main}/Tablas"

cd $clean

pwd 
dir
*Pagina web desde 2020
*--------------------------------------------------
global url "http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS"
*-------------------------------------------------------------------------
* 1.- Cargando las Bases de Datos
*-------------------------------------------------------------------------

*Manufacturing
*2020
clear all
cd "${clean}"
copy "$url/767-Modulo1686.zip" 767-Modulo1686.zip, replace
unzipfile 767-Modulo1686.zip, replace

cap cd .//630-Modulo1620//a2019_CAP_01
import spss "a2019_CAP_01.sav", clear
cd "${clean}"
saveold a2019_CAP_01.dta, replace
clear all


clear all
cd "${clean}"
copy "$url/767-Modulo1695.zip" 767-Modulo1695.zip, replace
unzipfile 767-Modulo1695.zip, replace

*Informacion de base de datos de valor agregado
*-----------------------------------------------------------------
cap cd .//630-Modulo1629//a2019_s11_fD2
import spss "a2019_s11_fD2_c03_1.sav", clear
cd "${clean}"
saveold a2019_s11_fD2_c03_1.dta, replace
clear all

*Informacion de base de datos de numero de trabajadores
*-------------------------------------------------------------------------
cap cd .//630-Modulo1629//a2019_s11_fD2
import spss "a2019_s11_fD2_c011_1.sav", clear
cd "${clean}"
saveold a2019_s11_fD2_c011_1.dta, replace
clear all

*Informacion de base de datos de capital
*-------------------------------------------------------------------------
cap cd .//630-Modulo1629//a2019_s11_fD2
import spss "a2019_s11_fD2_c05_1.sav", clear
cd "${clean}"
saveold a2019_s11_fD2_c05_1.dta, replace
clear all

*Informacion de seguridad
*-------------------------------------------------------------------------
cap cd .//630-Modulo1629//a2019_s11_fD2
import spss "a2019_s11_fD2_cS01_1.sav", clear
cd "${clean}"
saveold a2019_s11_fD2_cS01_1.dta, replace
clear all


*-------------------------------------------------------------------------
* 3.- Limpiando las Bases de Datos
*-------------------------------------------------------------------------
local bases "a2019_s11_fD2_c03_1 a2019_s11_fD2_c011_1 a2019_s11_fD2_c05_1 a2019_s11_fD2_cS01_1"
foreach q in `bases' {
clear all
unicode analyze "`q'.dta" //Para cada uno cambiar la ruta.
unicode encoding set "latin1"
unicode translate "`q'.dta"
*** Modulo de Manufactura
use "`q'.dta", clear
d
*rename _all, lower
*saveold "`q'.dta", replace
*d
clear all
}

**********
** Generacion de variables
************************
*-------------------------------------------------------------------------
* 4.- Procesando las Bases de Datos
*-------------------------------------------------------------------------
*** Midiendo el valor agregado
forvalues i=2019/2019{
u "${clean}/a`i'_s11_fD2_c03_1.dta",clear
do "${codigos}/1.- rva.do"
g ryear=`i'
tempfile bd_rva_`i'
saveold `bd_rva_`i'',replace
}

forvalues i=2019/2019{
u "${clean}/a`i'_s11_fD2_c011_1.dta",clear
do "${codigos}/2.- rl.do"
g ryear=`i'
tempfile bd_rl_`i'
saveold `bd_rl_`i'',replace
}

forvalues i=2019/2019{
u "${clean}/a`i'_s11_fD2_c05_1.dta",clear
do "${codigos}/3.- rk.do"
g ryear=`i'
tempfile bd_rk_`i'
saveold `bd_rk_`i'',replace
}

forvalues i=2019/2019{
u "${clean}/a`i'_s11_fD2_cS01_1.dta",clear
do "${codigos}/r1.-rsecurity.do"
g ryear=`i'
tempfile bd_security_`i'
saveold `bd_security_`i'',replace
}

forvalues i=2019/2019{
	u "${clean}/a`i'_CAP_01.dta",clear
	do "${codigos}/4.- restablecimiento.do"
	g ryear=`i'
	*destring factor_exp, replace
	keep ryear iruc ubigeo ciiu 
	order ryear iruc ubigeo ciiu

tempfile bd_id_`i'
saveold `bd_id_`i'',replace
}

*-------------------------------------------------------------------------
* 5.- Procesando bases
*-------------------------------------------------------------------------
u `bd_id_2019',clear
merge 1:1 ryear iruc using `bd_security_2019',keep(match) nogen
merge 1:1 ryear iruc using `bd_rva_2019',keep(match) nogen
merge 1:1 ryear iruc using `bd_rl_2019',keep(match) nogen
merge 1:1 ryear iruc using `bd_rk_2019',keep(match) nogen
*br

egen rventas=rowtotal(vn_m vn_p p_ss)

* Solo Valor agregado
sum rva, detail
local p5=r(p5)
keep if rva>`p5'
count

sum rl, detail
local g5=r(p5)
keep if rl>`g5'

mdesc
keep iruc ryear ubigeo ciiu rva rventas rl rsecurity_*
order iruc ryear ubigeo ciiu rva rventas rl

label var iruc "Iruc de la empresa"
label var ryear "tiempo"
label var ubigeo "ubigeo de la empresa"
label var ciiu "CIIU de la empresa"
label var rva "Value Added S/."
label var rventas "Sales S/."
label var rl "N trabajadores"
label var rsecurity_1 "==1 Robo"
label var rsecurity_2 "==1 Intento de Robo"
label var rsecurity_3 "==1 Extorsion"
label var rsecurity_4 "==1 Estafa"
label var rsecurity_5 "==1 Vandalismo"
label var rsecurity_6 "==1 Amenazas"


g lnrva =log(rva)
label var lnrva "Log-rva"
g lnrventas =log(rventas)
label var lnrventas "Log-rventas"
g lnrl =log(rl)
label var lnrva "Log-trabajadores"

saveold "${clean}/BD_L11.dta",replace




