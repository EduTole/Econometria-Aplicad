cls
clear all
capture mkdir "E:\EducatePeru\Stata\S10\Data"
set more off
gl main 	"E:\EducatePeru\Stata\S10"
gl clean 	"${main}/Data"
gl codigos 	"${clean}/Codigos"
gl Tabla 	"${main}/Tablas"
gl Imagen 	"${main}/Imagen"
u "$clean/BD_L10.dta",clear

*Estadisticas 
*Variables such as performance
g rpl =Y/L
g lnpl =log(rpl)
label var lnpl "Log(Productivity)"
g rck =K/L
g lnrck =log(rck)
label var lnpl "Log(Capital-employee)"

g rY=Y/1000000
g rK=K/1000000

label var rY "Value-Added (S/. Millones soles)"
label var rK "Capital (S/. Millones soles)"

eststo clear
	estpost tabstat rpl rY rK, s(n mean p50 min max sd) col(stat) 

	esttab using "$Tabla\T_0.tex", ///
	c("count(label(Firms)) mean(label(Promedio) fmt(%10.2fc)) p50(label(Medium) fmt(%10.2fc) ) min(label(Min.) fmt(%10.2fc)) max(label(Max.) fmt(%10.2fc)) sd(label(Std) fmt(%10.0fc))") ///
	varlabels(rpl "Valuee-Added per employees S/." Y "Value-Added S/." K "Capital S/." ) /// 
	label nomtitles nodepvars noobs nonumbers booktabs prehead("\begin{table}[H] \scriptsize \centering \begin{threeparttable} \protect \caption{\label{tab:Estadisticos0} Summary Statistics }  \begin{tabular}{lrrrrrrrr}" \hline \hline) ///
		posthead(\hline) prefoot() postfoot(\hline \end{tabular} ///
		\begin{tablenotes} ///
		\begin{footnotesize} ///
		\item[] Fuente: EEA - INEI ///
		\item[] Elaboracion: Autor  ///
		\end{footnotesize} ///
		"\end{tablenotes} \end{threeparttable} \end{table}" ) replace

*Analisis de politica
g rtreat=(L>20)
g rtime=(ryear>2013)
g rpolicy=rtreat*rtime

label var rtreat "Mayor 20 employees"
label var rpolicy "Policy"

** Grafico de antecedentes
	preserve
	
	keep if L<=40
	g E=1
	collapse (sum) E, by(L)
	
	twoway (line E L)  , xline(20) legend(off) title("Number of firms") xtitle("Number employees") /*
	*/ graphr(color(white)) plotr(color(white)) subtitle("Nº empresas segun Nº trabajadores") title("Analisis de empresas (umbral 20 trabajadores)")  ytitle("Number for firms")
	graph export "$Imagen/F1g.png", replace
		
	restore

*Difference in difference test
	eststo clear
eststo treated_pre: quietly estpost summarize ///
    lnpl lnrck if rtime==0 & rtreat==1
eststo treated_post: quietly estpost summarize ///
    lnpl lnrck if rtime==1 & rtreat==1
eststo control_pre: quietly estpost summarize ///
    lnpl lnrck if rtime==0 & rtreat==0
eststo control_post: quietly estpost summarize ///
    lnpl lnrck if rtime==1 & rtreat==0
eststo diff: quietly estpost ttest ///
    lnpl lnrck if rtreat==1, by(rpolicy) unequal
*use regression

	esttab treated_pre treated_post control_pre control_post diff using "$Tabla\T_1.tex", ///
cells("mean(pattern(1 1 1 1 0) fmt(2)) b(star pattern(0 0 0 0 1 ) fmt(2))" "sd(pattern(1 1 1 1 0) par)") collabels(none) nonumber  nogaps label booktabs varlabels(`e(labels)') coeflabel(lnpl "Log(Value-Added per employees)" lnrck "Log(Capital ratio)")  mgroups("Treated" "Control" "Difference", pattern(1 0 1 0  1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) mtitles("Pre-reform" "Post-reform" "Pre-reform" "Post-reform" )  prehead("\begin{table}[H] \scriptsize \centering \begin{threeparttable} \protect \caption{\label{tab:T1} Mean values before and after the 2014 reform }  \begin{tabular}{lrrrrrrrr}" \hline \hline) ///
		posthead(\hline) prefoot() postfoot(\hline \end{tabular} ///
		\begin{tablenotes} ///
		\begin{footnotesize} ///
		\item[] Desviacion estandar en parentesis. ///
		\item[] Fuente: EEA - INEI. ///
		\item[] Elaboracion: Autor  ///
		\item[] Nota: mean values in log. ///
		\end{footnotesize} ///
		"\end{tablenotes} \end{threeparttable} \end{table}" ) replace	

*Variables such as models
*Productivity
reg lnpl rpolicy rtreat i.ryear, r

	eststo clear
	eststo: reg lnpl rpolicy rtreat i.ryear, r
	*estadd local Fixedy "$\surd$",replace
	
	esttab using "$Tabla\T_2.tex",  label booktabs b(2) se(2) nonumber mtitles("Log(Productivity)")  star(* 0.10 ** 0.05 *** 0.01)  drop( *ryear)/*
	*/  varlabels(`e(labels)') /*
	*/ stats(N r2_a Fixedy Fixedy Fixedy , layout(@) fmt(a2 a2 a2 a2 a2  ) labels("Observations" "Adj. R$^2$" "Year FE" "Sectors FE" "Controls")  ) addnote("Recurso: Exercise 4" "Elaboracion: Autor") prehead("\begin{table}[H] \scriptsize \centering \begin{threeparttable} \protect \caption{\label{tab:MetodoDiD1} Difference in Difference }  \begin{tabular}{lrrrrrrrr}" \hline \hline) ///
		posthead(\hline) prefoot() postfoot(\hline \end{tabular} ///
		\begin{tablenotes} ///
		\begin{footnotesize} ///
		\item[] Fuente: EEA - INEI. ///
		\item[] Elaboracion: Autor  ///
		\item[] ***, **, * denote statistical significance at the 1\%, 5\% and 10\% levels respectively for zero.  ///		
		\end{footnotesize} ///
		"\end{tablenotes} \end{threeparttable} \end{table}" ) replace
		

*Inversiones
*reg lnrck rpolicy rtreat i.ryear, r