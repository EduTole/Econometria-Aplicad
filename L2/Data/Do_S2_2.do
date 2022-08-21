*********************************************
*
* Institucion:			Educa-Peru
* Autor:				Edinson Tolentino
* Proyecto:				ENE
* Fecha: 					
*********************************************
cls
clear all
*--------------------------------------------------
*Paso 1: Direccion de carpeta
*--------------------------------------------------
glo path "D:/Dropbox" // ET

*Dirección de carpeta de la ENE
glo main "${path}/BASES/ENE-INEI/INEI/2015"

glo base	"${main}/Inicial"
glo data	"${main}/Data"
glo ene		"${main}/ENE-ET"

******************************************************
*Creando la carpeta
cap mkdir "$data"

u "${base}/01_EMPRESA_IDENTIFICA.dta",clear

do "${ene}/1.- rfiltro.do"

destring C14_COD, g(p506r4)
do "${ene}/sector1r4_ene.do"
egen ubigeo=concat(CCDD CCPP CCDI) 
do "${ene}/regiones.do"

*Variables
do "${ene}/1.- rsexo.do"
do "${ene}/1.1.- rC20.do"
do "${ene}/2.- redad.do"
do "${ene}/3.- reduca.do"

keep IRUC ubigeo r* sector1r4 sector2r4_2	Factor_exp
saveold "${data}/ENE00_2015_Directorio.dta",replace

u "${base}/02_MODULO_I_II_III.dta",clear

do "${ene}/1.- rfiltro.do"

do "${ene}/9.- rcredito.do"
do "${ene}/9.- rorga.do"

do "${ene}/5.- rtrab.do"

keep IRUC r* 
saveold "${data}/ENE03_2015_300.dta",replace


u "${base}/04_MODULO_V_VI.dta",clear

do "${ene}/1.- rfiltro.do"
do "${ene}/8.- rexporta.do"

keep IRUC r* 
saveold "${data}/ENE06_2015_600.dta",replace



u "${base}/05_MODULO_VII_VIII_IX.dta",clear

do "${ene}/1.- rfiltro.do"
do "${ene}/4.- rventas.do"

preserve
u "${base}/09_MODULO_IX_6.dta",clear
do "${ene}/1.- rfiltro.do"
keep IRUC M9P6_ID M9P6_1 M9P6_2 M9P6_3 M9P6_4 M9P6_5
do "${ene}/6.1.- M9.do"
tempfile CAPITAL
saveold `CAPITAL',replace
restore
merge 1:1 IRUC using `CAPITAL', keep(match master) nogen
do "${ene}/6.- rk.do"
do "${ene}/7.- rva.do"

keep IRUC r*
saveold "${data}/ENE09_2015_900.dta",replace

******************************************************
* ENE -   UNION DE MODULOS
******************************************************

u "${data}/ENE00_2015_Directorio.dta",clear
foreach q in 9 3 6{
merge 1:1 IRUC using "${data}/ENE0`q'_2015_`q'00.dta", nogen keep(match)
}

saveold "${data}/ENE_2015.dta",replace







