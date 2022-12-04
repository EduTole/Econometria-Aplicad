/*
---------------------------------------------------
Curso: Microeconometria Aplicada II
Tema: EEA
Autor: Edinson Tolentino
---------------------------------------------------
*/

cls
clear all
capture mkdir "E:\EducatePeru\Stata\S10\Data"
set more off
gl main 	"E:\EducatePeru\Stata\S10"
gl clean 	"${main}/Data"
gl codigos 	"${clean}/Codigos"
gl tablas 	"${main}/Tablas"

cd $clean

pwd 
dir
*Pagina web desde 2013
*--------------------------------------------------
global url "http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS"
*-------------------------------------------------------------------------
* 1.- Cargando las Bases de Datos
*-------------------------------------------------------------------------

*2013
clear all
cd "${clean}"
copy "$url/393-Modulo345.zip" 393-Modulo345.zip, replace
unzipfile 393-Modulo345.zip, replace

cap cd .//393-Modulo345//a2012_CAP_01
import spss "a2012_CAP_01.sav", clear
cd "${clean}"
saveold a2012_CAP_01.dta, replace
clear all

*2014
clear all
cd "${clean}"
copy "$url/451-Modulo345.zip" 451-Modulo345.zip, replace
unzipfile 451-Modulo345.zip, replace

cap cd .//451-Modulo345//a2013_CAP_01
import spss "a2013_CAP_01.sav", clear
cd "${clean}"
saveold a2013_CAP_01.dta, replace
clear all

*2015
clear all
cd "${clean}"
copy "$url/511-Modulo838.zip" 511-Modulo838.zip, replace
unzipfile 511-Modulo838.zip, replace

cap cd .//393-Modulo445//
import spss "a2014_CAP_01.sav", clear
cd "${clean}"
saveold a2014_CAP_01.dta, replace
clear all

*2016
clear all
cd "${clean}"
copy "$url/552-Modulo1094.zip" 552-Modulo1094.zip, replace
unzipfile 552-Modulo1094.zip, replace

cap cd .//552-Modulo1094//
import spss "a2015_CAP_01.sav", clear
cd "${clean}"
saveold a2015_CAP_01.dta, replace
clear all

*-------------------------------------------------------
* Year : 2013 - Año fiscal 2012
*-------------------------------------------------------

clear all
cd "${clean}"
copy "$url/393-Modulo355.zip" 393-Modulo355.zip, replace
unzipfile 393-Modulo355.zip, replace

*Informacion de base de datos de valor agregado
*-----------------------------------------------------------------
cap cd .//393-Modulo355//a2012_s11_fD2
import spss "a2012_s11_fD2_c03_1.sav", clear
cd "${clean}"
saveold a2012_s11_fD2_c03_1.dta, replace
clear all

*Informacion de base de datos de numero de trabajadores
*-------------------------------------------------------------------------
cap cd .//393-Modulo355//a2012_s11_fD2
import spss "a2012_s11_fD2_c11_1.sav", clear
cd "${clean}"
saveold a2012_s11_fD2_c11_1.dta, replace
clear all

*Informacion de base de datos de capital
*-------------------------------------------------------------------------
cap cd .//393-Modulo355//a2012_s11_fD2
import spss "a2012_s11_fD2_c05_1.sav", clear
cd "${clean}"
saveold a2012_s11_fD2_c05_1.dta, replace
clear all

*-------------------------------------------------------
* Year : 2014 - Año fiscal 2013
*-------------------------------------------------------
clear all
cd "${clean}"
copy "$url/451-Modulo355.zip" 451-Modulo355.zip, replace
unzipfile 451-Modulo355.zip, replace

*Informacion de base de datos de valor agregado
*-------------------------------------------------------------------------
cap cd .//451-Modulo355//a2013_s11_fD2
import spss "a2013_s11_fD2_c03_1.sav", clear
cd "${clean}"
saveold a2013_s11_fD2_c03_1.dta, replace
clear all

*Informacion de base de datos de numero de trabajadores
*-------------------------------------------------------------------------
cap cd .//451-Modulo355//a2013_s11_fD2
import spss "a2013_s11_fD2_c11_1.sav", clear
cd "${clean}"
saveold a2013_s11_fD2_c11_1.dta, replace
clear all

*Informacion de base de datos de capital
*-------------------------------------------------------------------------
cap cd .//451-Modulo355//a2013_s11_fD2
import spss "a2013_s11_fD2_c05_1.sav", clear
cd "${clean}"
saveold a2013_s11_fD2_c05_1.dta, replace
clear all


*-------------------------------------------------------
* Year : 2015 : Año fiscal 2014
*-------------------------------------------------------
clear all
cd "${clean}"
copy "$url/511-Modulo848.zip" 511-Modulo848.zip, replace
unzipfile 511-Modulo848.zip, replace

*Informacion de base de datos de valor agregado
*-------------------------------------------------------------------------
cap cd .//393-Modulo455//a2014_s11_fD2
import spss "a2014_s11_fD2_c03_1.sav", clear
cd "${clean}"
saveold a2014_s11_fD2_c03_1.dta, replace
clear all

*Informacion de base de datos de numero de trabajadores
*-------------------------------------------------------------------------
cap cd .//393-Modulo455//a2014_s11_fD2
import spss "a2014_s11_fD2_c11_1.sav", clear
cd "${clean}"
saveold a2014_s11_fD2_c11_1.dta, replace
clear all

*Informacion de base de datos de capital
*-------------------------------------------------------------------------
cap cd .//393-Modulo455//a2014_s11_fD2
import spss "a2014_s11_fD2_c05_1.sav", clear
cd "${clean}"
saveold a2014_s11_fD2_c05_1.dta, replace
clear all



*-------------------------------------------------------------------------
* 3.- Limpiando las Bases de Datos
*-------------------------------------------------------------------------
local bases "a2012_s11_fD2_c03_1 a2012_s11_fD2_c11_1 a2012_s11_fD2_c05_1 a2013_s11_fD2_c03_1 a2013_s11_fD2_c11_1 a2013_s11_fD2_c05_1 a2014_s11_fD2_c03_1 a2014_s11_fD2_c11_1 a2014_s11_fD2_c05_1"
foreach q in `bases' {
clear all
unicode analyze "`q'.dta" //Para cada uno cambiar la ruta.
unicode encoding set "latin1"
unicode translate "`q'.dta"
*** Modulo de Manufactura
use "`q'.dta", clear
d
clear all
}

*-------------------------------------------------------------------------
* 4.- Procesando las Bases de Datos
*-------------------------------------------------------------------------
*** Midiendo el valor agregado
forvalues i=2012/2014{
u "${clean}/a`i'_s11_fD2_c03_1.dta",clear
do "${codigos}/1.- rva.do"
g ryear=`i'
tempfile bd_rva_`i'
saveold `bd_rva_`i'',replace
}

u `bd_rva_2012'
append using `bd_rva_2013'
append using `bd_rva_2014'
tempfile bd_rva
save `bd_rva',replace

forvalues i=2012/2014{
u "${clean}/a`i'_s11_fD2_c11_1.dta",clear
do "${codigos}/2.- rl.do"
g ryear=`i'
tempfile bd_rl_`i'
saveold `bd_rl_`i'',replace
}

u `bd_rl_2012'
append using `bd_rl_2013'
append using `bd_rl_2014'
tempfile bd_rl
save `bd_rl',replace


forvalues i=2012/2014{
u "${clean}/a`i'_s11_fD2_c05_1.dta",clear
do "${codigos}/3.- rk.do"
g ryear=`i'
tempfile bd_rk_`i'
saveold `bd_rk_`i'',replace
}

u `bd_rk_2012'
append using `bd_rk_2013'
append using `bd_rk_2014'
tempfile bd_rk
save `bd_rk',replace

forvalues i=2012/2014{
	u "${clean}/a`i'_CAP_01.dta",clear
	do "${codigos}/4.- restablecimiento.do"
	g ryear=`i'
	*destring factor_exp, replace
	keep ryear iruc ubigeo ciiu 
	order ryear iruc ubigeo ciiu

tempfile bd_id_`i'
saveold `bd_id_`i'',replace
}

u `bd_id_2012'
append using `bd_id_2013'
append using `bd_id_2014'
tempfile bd_id
save `bd_id',replace


*-------------------------------------------------------------------------
* 5.- Procesando bases
*-------------------------------------------------------------------------
u `bd_id',clear
merge 1:1 ryear iruc using `bd_rva',keep(match) nogen
merge 1:1 ryear iruc using `bd_rl',keep(match) nogen
merge 1:1 ryear iruc using `bd_rk',keep(match) nogen
br

*-------------------------------------------------------------------------
* 6.- Generacion de variables
*-------------------------------------------------------------------------
** Nivel de ventas
egen rventas = rowtotal(vn_m vn_p p_ss)
lab var rventas "Ventas (S/.)"

** Tamaño empresarial
gen rtam = .
replace rtam = 1 if rventas<=150*3950
replace rtam = 2 if rventas>150*3950 & rventas<=1700*3950
replace rtam = 3 if rventas>1700*3950 & rventas<=2300*3950
replace rtam = 4 if rventas>2300*3950
lab define rtam 1 "Microempresa" 2 "Pequeña empresa" 3 "Mediana empresa" 4 "Gran empresarial"
lab values rtam rtam
tab rtam
** Capital
egen K = rowmean(act_tot_ini act_tot_fin)

** Inversión
gen INV = act_tot_fin - act_tot_ini

** Renombramos
rename (rva rl) (Y L)

keep ryear iruc ubigeo ciiu rtam rventas Y K L INV insumos 
order ryear iruc ubigeo ciiu rtam rventas Y K L INV insumos
format rventas Y K L %20.0f
saveold "${clean}\BD_EEA_Manufactura.dta", replace

*-------------------------------------------------------------------------
* 7.- Deflactacion de datos
*-------------------------------------------------------------------------
u "${clean}\BD_EEA_Manufactura.dta",clear
*reacion de sector
g sector1 =9
merge m:1 ryear sector1 using "${clean}/BD_Deflactores.dta", keep(match) keepusing(d_VA d_FBK_Fijo) nogen

*** Deflactamos
replace Y = 100 * Y / d_VA
replace K = 100 * K / d_FBK_Fijo

*** Logaritmo
gen lnY = ln(Y)
gen lnK = ln(K)
gen lnL = ln(L)
gen lnI	= ln(insumos)
gen lnINV = ln(INV)


compress
cls
d

label var rtam "Tamaño de empresas"
label var ryear "Año"
label var Y "Valor Agregado S/."
label var K "Capital S/."
label var L "N trabajadores"
label var INV "Inversiones"

label var lnY "log Valor agregado S/."
label var lnK "log Capital S/."
label var lnL "log N trabajadores"
label var lnINV "log Inversiones"

glo Xs "Y L K INV lnY lnL lnK lnINV"
keep ryear iruc rtam $Xs
order ryear iruc rtam $Xs

saveold "${clean}\BD_L10.dta", replace

