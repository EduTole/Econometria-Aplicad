cls
glo Data 	"D:\Dropbox\BASES\ENAHO\PANEL\2021\Clean"
glo Out		"E:\EducatePeru\Stata\S10\Data"

u "${Data}/tmp500_trianual_1821.dta",replace
d

g rjefe=(p203==1)
tab r2r_d, g(rnivel)
tab rArea, g(rrural)
tab rDpto, g(rregion)
* 1. Collapsamos la informacion por hogar
*collapse (mean) rjobs, by(Ano numpanh)
keep numpanh Ano rjobs rnivel1-rnivel4 rrural1-rrural2 rmu rregion1-rregion25
gl Zs "rjobs rnivel1-rnivel4 rrural1-rrural2 rmu rregion1-rregion25"
tempfile base1
saveold `base1',replace


u "${Data}/tmp340_trianual_1821.dta",clear
*merge 1:1 numpanh Ano using `base1', keep(match master) keepusing(rjobs) nogen
merge 1:m numpanh Ano using `base1', keep(match ) keepusing($Zs) nogen

*Filtramos año 21
*keep if Ano<21
* Solo los hogares pobres
keep if pobreza<3

* Variables de bonos
preserve
g rbono_c=(rbono_casa!=0)
keep if rbono_c==1
keep numpanh rbono_c 
duplicates drop numpanh, force
duplicates report numpanh
tempfile base2
saveold `base2',replace
restore

merge m:1 numpanh using `base2',keepusing(rbono_c) keep(match master) nogen
tab rbono_c Ano
replace rbono_c=0 if rbono_c!=1
tab rbono_c Ano

label var 

saveold "${Data}/BD_L11.dta",replace

*g rbono_i=(rbono_indep!=0)
tab rbono_c Ano

*Modelo
g T=(Ano>19)
g Policy=T*rbono_c
reg rjobs Policy rbono_c i.Ano, r

*Modelo DiD incluyendo controles
gl Xs "rnivel2-rnivel4 rrural2 rmu rregion2-rregion25"

reg rjobs Policy rbono_c i.Ano $Xs, r
