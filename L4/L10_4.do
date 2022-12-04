cls
clear all
capture mkdir "E:\EducatePeru\Stata\S10\Data"
set more off
gl main 	"E:\EducatePeru\Stata\S10"
gl clean 	"${main}/Data"
gl codigos 	"${clean}/Codigos"
gl Tabla 	"${main}/Tablas"

u "$clean/BD_L10.dta",clear


*Analisis de politica
g rtreat=(L>20)
g rtime=(ryear>2013)
g rpolicy=rtreat*rtime

label var rtreat "L > 20"
label var rpolicy "Policy"

*Variables such as performance
g rpl =Y/L
g lnpl =log(rpl)
g rck =K/L
g lnrck =log(rck)

* estadisticas descriptivas
g rY=Y/1000000
g rK=K/1000000
sum rpl rY rK

** Grafico de antecedentes
	preserve
	
	keep if L<=40
	g E=1
	collapse (sum) E, by(L)
	
	twoway (line E L)  , xline(20) legend(off) title("Number of firms") xtitle("Number employees") /*
	*/ graphr(color(white)) plotr(color(white)) subtitle("Nº empresas segun Nº trabajadores") title("Analisis de empresas (umbral 20 trabajadores)")  ytitle("Number for firms")
	*graph export "$Imagen/F1g.png", replace
		
	restore

** Test de medias
ttest lnpl if rtreat==1, by(rtime)	
ttest lnpl if rtreat==0, by(rtime)	
	
*Variables such as models
*Productivity
reg lnpl rpolicy rtreat i.ryear, r
