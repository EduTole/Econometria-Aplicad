*********************************************
*
* Institucion:			Educa-Peru
* Autor:				Edinson Tolentino
* Proyecto:				ENE
* Fecha: 					
*********************************************
cls
clear all

glo path 	"D:\Dropbox\BASES\ENE-INEI\INEI\2015\Data"
glo clase 	"E:\EducatePeru\Stata\S2\Data"

*Manejo de base de datos
*----------------------------------
use "${path}/ENE_2015.dta",clear

sum
*Solo informacion de Micro y Pequeña empresa
*Se elimina los valores donde 
*Solo filtrar informacion con Ventas positivo y mayor 10 soles
*Solo filtrar informacion con VA positivo y mayor 10 soles
keep if rventas>=10
keep if rva>=10

*Solo filtrar informacion mayor a 2 personas
keep if rl>=2

mdesc


*Generacion de dummy 
g rsmall=(rC20==2)
label var rsmall "==1 Small firms"

g rDpto=real(substr(ubigeo,1,2))
g rlima=(rDpto==15)
label var rlima "==1, empresa en Lima"

g rmanucturing=(sector2r4_2==3)
g rservices=(sector2r4_2==6)
g rcomerce=(sector2r4_2==8)

label var rmanucturing "==1 Manufacturing firms"
label var rservices "==1 Commerce firms"
label var rcomerce "==1 Services firms"


*Logaritmo de ventas y produccion
g lnrventas=log(rventas)
g lnrpt=log(rpt)
g rprod=rventas/rl
g lnrprod=log(rprod)

label var lnrventas "Log-ventas"
label var lnrpt "Log-production"
label var lnrprod "Log-productividad"

*solo empresas de los sectores manufactura, servicios y comercio
keep if rmanucturing==1 | rservices==1 | rcomerce==1

keep IRUC rC20 rmanucturing rservices rcomerce rmujer redad rventas rpt rva rl rexport rcredito rorga lnrprod rlima
order IRUC rC20 rcredito rorga rmujer redad rventas rpt rva rl rexport rmanucturing rservices rcomerce  lnrprod rlima


saveold "${clase}/Data_S2.dta",replace



