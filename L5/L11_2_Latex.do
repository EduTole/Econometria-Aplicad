	cls	
	gl main "E:\EducatePeru\Stata\S11"
	gl Data 	"${main}\Data"
	gl tablas 	"${main}/Tablas"
	gl imagen 	"${main}/Imagen"
	
	u "${Data}/BD_L12.dta",clear

	g lnva=log(VA)
	g lnpl=log(PL)
	

	*Definicion de variables
	gl Xs "female edad_group2-edad_group5 SF Edad exporta solefirms manufacturing commerce services"

	eststo clear
	
eststo treated_pre: quietly estpost summarize ///
   $Xs if crime2==1
eststo treated_post: quietly estpost summarize ///
   $Xs if crime2==0	
eststo diff: quietly estpost ttest ///
    $Xs, by(crime2) unequal

	esttab treated_pre treated_post diff using "$tablas\T_1.tex", ///
cells("mean(pattern(1 1 0) fmt(2)) b (star pattern(0 0 1) fmt(2))" "sd(pattern(1 1 0) par)") wide collabels(none) nonumber nogaps label booktabs varlabels(`e(labels)') mtitles("Tratado (Crimen)" "Controles (No-crimen)" "Diferencia")  prehead("\begin{table}[H] \scriptsize \centering \begin{threeparttable} \protect \caption{\label{tab:T1} Estadistica descriptiva (promedio) }  \begin{tabular}{lrrrrrrrr}" \hline \hline) ///
		posthead(\hline) prefoot() postfoot(\hline \end{tabular} ///
		\begin{tablenotes} ///
		\begin{footnotesize} ///
		\item[] Standard deviations in parentheses. ///
		\item[] Source: INEI - ENE. ///
		\item[] Elaboration: Author  ///
		\item[] Note: The standard deviations for the log(outcomes) variables are reported in parentheses in the first two columns; the standard error of the average differential is reported in parenthesis in the final column . ///
		\end{footnotesize} ///
		"\end{tablenotes} \end{threeparttable} \end{table}" ) replace
	
	
	******************
	*Modelo de MCO
	******************
	reg lnpl crime2 $Xs, r
	
	eststo clear
	eststo: reg lnpl crime2 , r
	estadd local Fixedy "",replace

	eststo: reg lnpl crime2 $Xs, r
	estadd local Fixedy "$\surd$",replace
	
	esttab using "$tablas\T_2.tex",  label booktabs b(2) se(2) nonumber mtitles("Model (1)" "Model (2)")  star(* 0.10 ** 0.05 *** 0.01)  drop( female edad_group* SF Edad exporta solefirms manufacturing commerce services _cons)/*
	*/  varlabels(`e(labels)') /*
	*/ stats(N r2_a Fixedy Fixedy , layout(@) fmt(a2 a2 a2 a2) labels("Observaciones" "Adj. R$^2$" "Sectors FE" "Controls")  ) addnote("Recurso: Exercise 4" "Elaboracion: Autor") prehead("\begin{table}[H] \scriptsize \centering \begin{threeparttable} \protect \caption{\label{tab:T2} Modelo de Regresion }  \begin{tabular}{lrrrrrrrr}" \hline \hline) ///
		posthead(\hline) prefoot() postfoot(\hline \end{tabular} ///
		\begin{tablenotes} ///
		\begin{footnotesize} ///
		\item[] Fuente: INEI - ENE. ///
		\item[] Elaboracion: Autor  ///
		\item[] ***, **, * denote statistical significance at the 1\%, 5\% and 10\% levels respectively for zero.  ///		
		\end{footnotesize} ///
		"\end{tablenotes} \end{threeparttable} \end{table}" ) replace	
		
	*******************
	*Modelo LOGIT
	*******************
	
	
	eststo clear
	eststo: logit crime2 $Xs
	estadd local Fixedy "$\surd$",replace
	
	esttab using "$tablas\T_3.tex",  label booktabs b(2) se(2) nonumber mtitles("Model (1)") wide star(* 0.10 ** 0.05 *** 0.01) /*
	*/  varlabels(`e(labels)') /*
	*/ stats(N aic, layout(@) fmt(a2) labels("Observaciones" "AIC")  ) addnote("Recurso: Exercise 4" "Elaboracion: Autor") prehead("\begin{table}[H] \scriptsize \centering \begin{threeparttable} \protect \caption{\label{tab:T3} Modelo Logistico }  \begin{tabular}{lrrrrrrrr}" \hline \hline) ///
		posthead(\hline) prefoot() postfoot(\hline \end{tabular} ///
		\begin{tablenotes} ///
		\begin{footnotesize} ///
		\item[] Fuente: INEI - ENE. ///
		\item[] Elaboracion: Autor  ///
		\item[] ***, **, * denote statistical significance at the 1\%, 5\% and 10\% levels respectively for zero.  ///		
		\end{footnotesize} ///
		"\end{tablenotes} \end{threeparttable} \end{table}" ) replace
		
	logit crime2 $Xs
	predict phat

	kdensity phat if crime2 == 1, addplot(kdensity phat if crime2==0) legend(label(1 "crime") label(2 "Non-crime"))
	graph export "${imagen}/fig_1.png",replace

	su phat if crime2==1
	local x1=r(min)
	local x2=r(max)
	su phat if crime2==0
	tab phat if crime2==0
	
	gen com_sup=0
	replace com_sup=1 if phat < `x2' & phat > `x1'

	psmatch2 crime2 $Xs if com_sup==1, kernel out(lnpl) logit  
	pstest if com_sup==1, sum both
	pstest if com_sup==1
	pstest if com_sup==1,rubin
	pstest if com_sup==1,onlysig graph
	graph export "${imagen}/fig_2.png",replace
	
	psmatch2 crime2 $Xs if com_sup==1, kernel out(lnpl) logit  
	psgraph	
	graph export "${imagen}/fig_3.png",replace
	
