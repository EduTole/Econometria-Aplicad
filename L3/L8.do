***********************************************
****Econometria Aplicada 
***********************************************
/****************************************
Institucion:					
Autor:							Edinson Tolentino (edinson.tolentino@gmail.com)
*****************************************/
cls
clear all

*Ruta de direcciones
gl main 	"E:\EducatePeru\Stata\S8\Data"


*Cargar la base de datos
use "${main}/BD8.dta",clear

*Estadisticas
sum 

*Estadisticas sobre el tiempo
stset durat, failure(_d) /*estructura de modelos de duracion*/
stdes
centile durat

*Estadisticas sobre el tiempo no censurado
centile durat if _d==1

*Pregunta 1
*Es importarte poder setear la base de formato de STATA (cross-section)
*Hacia un formato de mdoelos de duracion, considerando la variable de censura
stset durat, failure(_d)

*Tabular el tiempo de falla (failure time) , dada la variable durat
tab durat

*Pregunta 2
*Este comando reporta el tiempo de falla por periodos de informacion
*en particular el calculo de la funcion de riesgo (hazard rate)
ltable durat, hazard interval(0(1)80)

*Suavizamiento de la tasas de riesgo dado el comando sts
sts graph, hazard

sts gr
*Funcion de supervivencia
sts gr, title("Fn. de supervivencia Kaplan-Meier") ytitle("Pr. condicional de no cometer crimen") xtitle("Meses")
*funcion de riesgo por variable == afroamerica==1
sts graph, hazard by(black)
* 
sts gr, by(black) title("Fn. de supervivencia Kaplan-Meier") ytitle("Pr. condicional de no cometer crimen") xtitle("Meses")

sts gr, by(married) title("Fn. de supervivencia Kaplan-Meier") ytitle("Pr. condicional de no cometer crimen") xtitle("Meses")

*** Prueba de hipotesis, Funciones de sobrevivencia son iguales?
sts test black // H0: Las Funciones de supervivencia son iguales. 

*Pregunta 3
////Estimacion del exponential model
streg age married black alcohol drugs priors rules tserved, distribution(exponential) nohr
display _b[age]*12*100
display (exp(_b[black])-1)*100
stcurve,haz

*Pregunta 4
////Estimacion para Weibull PH model
streg age married black alcohol drugs priors rules tserved, distribution(weibull) nohr
stcurve,haz

////Estimacion para the Cox PH model
stcox age married black alcohol drugs priors rules tserved, nohr
stcurve,haz

///This estimates the Schoenfeld residuals for each covariate based on the Cox PH model
stcox age married black alcohol drugs priors rules tserved,nohr schoenfeld(sch*)
///Summarise the Schoenfeld residuals for the 'black' covariate
su sch13

*Pregunta 5
stcox age married black alcohol drugs priors rules tserved,nohr
///Test log-log (el supuesto no se viola cuando las curvas tienden a ser paralelas entre categorías en el tiempo)
stphplot, by(black)
stphplot, by(married)
stphplot, by(alcohol)
stphplot, by(drugs)
*stphplot, by(age)
stphplot, by(priors)
stphplot, by(rules)
stphplot, by(tserved)

*Test que compara curvas de sobrevivencia Kaplan-Meier observadas con curvas predichas por el modelo de Cox (cuánto más cercanas más factible que el supuesto de riesgos proporcionales sea cierto)
stcoxkm, by(black) separate

*Test del supuesto PH basado en los residuso de Schonfeld
estat phtest, plot(married)
estat phtest, plot(age)
estat phtest, plot(black)
estat phtest, plot(alcohol)
estat phtest, plot(drugs)
estat phtest, plot(priors)
estat phtest, plot(rules)
estat phtest, plot(tserved)

*Test para los grupos de covariables especificas sobre las proporciones 
*Grambsch and Therneau (1994) test 
estat phtest, rank detail 
estat phtest 
