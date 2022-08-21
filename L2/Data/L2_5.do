*********************************************
*
* Institucion:			Educa-Peru
* Autor:				Edinson Tolentino
* Proyecto:				Analisis Subempleo
* Fecha:				Agosto	
*********************************************
cls 
clear all

*--------------------------------------------------
*Paso 1: Direccion de carpeta
*--------------------------------------------------
*glo path 	"D:\Dropbox\BASES\ENAHO" // Base de datos
glo clase 	"E:\EducatePeru\Stata\S2" // Clase 2	
glo main 	"${clase}/Data"			// Data
glo Imagen	"${clase}/Imagen"		// Imagen
glo Tablas	"${clase}/Tablas"		// Tablas

*--------------------------------------------------
*Paso 2: Carga de data
*--------------------------------------------------

u "${main}/Data_S2.dta",clear
*Descripcion
d

glo Xs "rmujer rlima lnrprod redad"
*glo Xs "mujer joven lnypm horas "

*Estadisticas descriptivas
*--------------------------------------------------------------
sum rcredito $Xs

*Tabla 2 se realizo como identificación de variables

*Pregunta 1
*--------------------------------------------------------------
*Modelo Lineal : MPL
reg rcredito $Xs
*Modelo No-Lineal : probit
probit rcredito $Xs

*Pregunta 2
*--------------------------------------------------------------
*Efecto Marginal
*-----------------------------------------------------
*Efectos marginales
quietly probit rcredito $Xs
margins, dydx(*) post	
		
*Pregunta 3
*----------------------------------------------
probit rcredito $Xs	
estimate store m_probit
margins, dydx(*) post	

logit rcredito $Xs	
estimate store m_logit
margins, dydx(*) post	

*Pregunta 4
*----------------------------------------------
estimate table m_probit m_logit, stats(N ) star

*Pregunta 5
*----------------------------------------------
*Bondades de Ajuste
probit rcredito $Xs	
estat classification

logit rcredito $Xs	
estat classification

*Curva ROC
lroc

*Efecto marginales
*-----------------------------------------------
*Comparacion de efectos marginales 
*-------------------------------------------
	quietly probit rcredito $Xs, r
	margins, dydx(*) post
	
	quietly logit rcredito $Xs, r
	margins, dydx(*) post
	
	reg rcredito $Xs, r

*Graficos de Efectos Marginales
*-------------------------------------------
quietly probit rcredito i.rmujer i.rlima c.lnrprod c.redad , r
margins rmujer, at(redad=(18(5)60))
marginsplot , ytitle("Probabilidad") xtitle("")

quietly probit rcredito i.rmujer i.rlima c.lnrprod c.redad , r
margins rmujer, at(lnrprod=(4(1)15))
marginsplot , ytitle("Probabilidad") xtitle("")

