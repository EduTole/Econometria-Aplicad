
cls
clear all
glo Data		"E:\EducatePeru\Stata\S1\Data"
glo Out			"E:\EducatePeru\Stata\S1\Data"
*Carga de Data
u "${Data}/BD_1.dta",clear

*Analisis exploratorio
*-----------------------------------
sum r6 redad rexper rmujer reduca

*Por percentiles 
g pct = r6, nq(4) 
tabstat r6 reduca, stats(mean p5 p25 p50 p75 max min ) col(stats) 

*Grafico
*-----------------------------------
tw (scatter r6 reduca ) (lfit r6 reduca)

*Transformacion de variables
*-----------------------------------
g lnr6=log(r6)
g lnreduca=log(reduca)

*Grafico de dispersion
*-----------------------------------
tw (scatter lnr6 reduca ) (lfit lnr6 reduca), ytitle("Log-Ingresos") xtitle("Educacion (años)")
graph export "${Out}/f0.png",replace

*Grafico de caja que excluye los missing values
*-----------------------------------
graph box r6,  nooutside

*Grafico de caja que excluye los missing values segun sexo
*-----------------------------------
graph box r6, over(rmujer)  nooutside
table rmujer , c(mean r6 mean redad  mean rexper) row col 

*Grafico de CDF 
*-----------------------------------
cumul r6 if r6<2501 & rmujer==0, g(r6_cdf_1)
cumul r6 if r6<2501 & rmujer==1, g(r6_cdf_2)
line r6_cdf_1 r6_cdf_2 r6 if r6<2501, sort legend(label(1 "Hombre") label(2 "Mujer")) xline(1000) xtitle("Ingresos") ytitle("Proporcion de pop.")
graph export "${Out}/f1.png",replace

*Grafico de PDF 
*-----------------------------------
tw (kdensity lnr6 if rmujer==0 ) (kdensity lnr6 if rmujer==1 ) , legend(label(1 "Hombre") label(2 "Mujer")) xtitle("Log-Ingresos") ytitle("Densidad")
graph export "${Out}/f2.png",replace

tw (kdensity r6 if rmujer==0 & r6<2501) (kdensity r6 if rmujer==1 & r6<2501) , legend(label(1 "Hombre") label(2 "Mujer")) xline(1000)

*Modelos de Regresion
*-----------------------------------
*Modelo Bivariado
*-----------------------------------
reg r6 reduca , r
estimate store m1
estimate table m1, b(%7.4f) stats(N r2_a aic bic rss) star

*Formas funcionales
reg lnr6 reduca 
reg lnr6 lnreduca 
reg r6 lnreduca 

*Prueba de Heterocedasticidad grafica
reg r6 reduca
predict mu_hat , residual 

kdensity mu_hat
graph export "${Out}/f3.png",replace

graph box mu_hat
graph export "${Out}/f4.png",replace


*Modelo Multivariado
*-----------------------------------
*Analisis exploratorio
gl Xs "r6 reduca rmujer rexper rexpersq rpareja rsoltero"
sum $Xs

*Pregunta 1a)
reg lnr6 reduca
reg lnr6 reduca rmujer rexper rexpersq rpareja rsoltero

*Pregunta 1b) Estimacion de errores del modelo		
*--------------------------------------------------------------
reg lnr6 reduca rmujer rexper rexpersq rpareja rsoltero
*Prediciones de los errores del modelo
predict uhat,resid

*Bosquejo de la densidad kernel de las estimaciones
*del error y tets para nomalidad de la distribucion de errors
kdensity uhat
sktest uhat, noadj 
graph export "${Imagen}/t1.png", replace

*Grafico de caja
graph box uhat
graph export "${Imagen}/t2.png", replace

*Pregunta 1c) prueba de errores de heterocedasticidad	
*--------------------------------------------------------------
*Test de Koenker para heterocedasticidad
hettest reduca rmujer rexper rexpersq rpareja rsoltero, iid

*Test manual de heterocedasticidad
gen uhatsq=uhat^2
label var uhatsq "$\mu^{2}$"

reg uhatsq reduca rmujer rexper rexpersq rpareja rsoltero
scalar r2 = e(r2)
scalar sample = e(N)
scalar lm_het = r2*sample
display lm_het

*Pregunta 2
*-------------------------------------------------------------
*Pregunta 2a) prediccion de los errores
eststo clear	
reg lnr6 reduca 
reg lnr6 reduca rmujer 
reg lnr6 reduca rmujer rexper rexpersq rpareja rsoltero
	
*Pregunta 2b) prediccion de los errores
*Test de Wald: edad y edad cuadrado
reg lnr6 reduca rmujer rexper rexpersq rpareja rsoltero , r
display _b[rexper]/(-2*_b[rexpersq])
display 1/(-2*_b[rexper])
display _b[rexper]/(2*(_b[rexpersq])^2)

display ((-22.5468^2)*0.0000001948) + ((69051.769^2)*0.00000000003635)+(2*(-22.5468)*(69051.769)*(-0.00000000255))

display (27.670369-50)/(sqrt(0.18116328))

reg lnr6 reduca rmujer rexper rexpersq rpareja rsoltero
*Extraer matrices
matrix b=e(b) 
matrix vb=e(V) 

matrix vage=vb[3..4,3..4]
matrix list vage
nlcom - _b[rexper]/(2*_b[rexpersq]) - 50		
gen lnr6_predicted=_b[rexper]*rexper +_b[rexpersq]*rexpersq
scatter lnr6_predicted rexper		
graph export "${Imagen}/t3.png", replace	

*Pregunta 3
*--------------------------------------------------------------
*Rgresion por separado
reg lnr6 reduca rmujer rexper rexpersq rpareja rsoltero
reg lnr6 reduca  rexper rexpersq rpareja rsoltero if rmujer==1
reg lnr6 reduca  rexper rexpersq rpareja rsoltero if rmujer==0


*OLS INTERACCIONES	
g i1=rmujer*reduca
g i2=rmujer*rexper
g i3=rmujer*rexpersq
g i4=rmujer*rpareja
g i5=rmujer*rsoltero

label var i1 "educa x mujer"
 reg lnr6 rmujer reduca rexper rexpersq rpareja rsoltero i1 i2 i3 i4 i5

reg lnr6 rmujer reduca rexper rexpersq rpareja rsoltero
reg lnr6 reduca rexper rexpersq rpareja rsoltero if rmujer==1
reg lnr6 reduca rexper rexpersq rpareja rsoltero if rmujer==0
reg lnr6 reduca rexper rexpersq rpareja rsoltero rmujer i1 i2 i3 i4 i5
	