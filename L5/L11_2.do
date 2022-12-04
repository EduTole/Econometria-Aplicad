	cls	
	gl main "E:\EducatePeru\Stata\S11"
	gl Data 	"${main}\Data"
	gl tablas 	"${main}/Tablas"
	
	u "${Data}/BD_L12.dta",clear

	g lnva=log(VA)
	g lnpl=log(PL)
	
	*Pregunta 1
	count
	local Xs "female SF Edad edad_group1 edad_group2 edad_group3 edad_group4 edad_group5 exporta solefirms manufacturing commerce services"
	sum `Xs'

	matrix means = J(13, 3, -99)
	matrix colnames means = control treated t-value
	matrix rownames means = `Xs'

	local irow = 0
	foreach Xs of varlist `Xs'			{
		local ++irow
		sum `Xs' if crime2 == 0
		matrix means[`irow',1] = r(mean)
		sum `Xs' if crime2 == 1
		matrix means[`irow',2] = r(mean)
		ttest `Xs', by(crime2)
		matrix means[`irow',3] = r(t)
	}
	
	matrix list means, format(%15.4f)			// matrix named "means" with a rough test for equal means
	*Pregunta 1
	reg lnpl crime2 $Xs, r
	
	*Pregunta 2	
	*Modelo Logit
	gl Xs "female SF Edad edad_group2-edad_group5 exporta solefirms manufacturing commerce services"
	logit crime2 $Xs
	predict phat
	
	*Grupo de treatment and crontrol
	kdensity phat if crime2 == 1, addplot(kdensity phat if crime2==0) legend(label(1 "crime") label(2 "Non-crime"))
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
	
	psmatch2 crime2 $Xs if com_sup==1, kernel out(lnpl) logit  
	psgraph	
	
